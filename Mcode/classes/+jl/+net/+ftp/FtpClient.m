classdef FtpClient < handle
  % FtpClient An alternative FTP client that supports PASV and other stuff
  %
  % jl.net.ftp.FtpClient is an FTP client that is an alternative to
  % Matlab's own @ftp class. FtpClient supports the PASV and some other
  % stuff.
  %
  % The interface for FtpClient is similar to Matlab's @ftp class, so if
  % you can use that, you can probably pick this up pretty quickly. The big
  % difference is that you must call connect() on FtpClient before doing
  % any file transfer activity with it.
  %
  % Examples:
  %
  % % If you don't give a username and password before connect(), it
  % % defaults to anonymous ftp
  %
  % f = jl.net.ftp.FtpClient("gnu.mirror.iweb.com")
  % f.connect
  %
  % f.cd("uucp")
  % f.dir
  % f.get("uucp-1.06.2.tar.gz")
  % f.cd("..")
  %
  % % List or download multiple files using "*" wildcards
  %
  % f.cd("m4")
  % f.dir("*1.4.8*")
  % f.mget("*1.4.8*.sig")

  % Developer notes:
  % * features() is not supported, because the Apache FTP library shipping
  %   with Matlab R2020a is too old.
  
  % TODO: Implement features() myself using the low-level FTP command
  % interface of the Apache FTP/SocketClient class. (Need to use
  % SocketClient because Matlab's shipped Apache FTPClient is too old to
  % have features() or doCommand().)
  % TODO: mput()
  
  properties (SetAccess = private)
    % The underlying apache FTPClient object
    jobj = org.apache.commons.net.ftp.FTPClient
  end
  properties
    % Remote host to connect to
    host (1,1) string = string(missing)
    % Port for the command port
    port (1,1) double = NaN
    % Username to log in as. Defaults to 'anonymous'.
    username (1,1) string = "anonymous"
    % Password to provide. Defaults to your email address from Matlab's
    % Internet prefs
    password string = repmat("", [0 0])
    % Account to use in addition to username and password. May be empty to
    % indicate "no account"
    account string = repmat("", [0 0])
  end
  properties (Dependent)
    % The current directory on the remote host
    cwd
    % Whether the client has an active FTP connection to the remote host
    isconnected
    % Whether to include hidden files in the dir listing
    listHiddenFiles
    % Type of the remote system
    systemType
  end
  
  methods
  
    function this = FtpClient(host, port)
      % FtpClient Construct a new object
      %
      % obj = jl.net.ftp.FtpClient(host, port)
      if nargin == 0
        return
      end
      if isa(host, 'jl.net.ftp.FtpClient')
        this = host;
        return
      end
      if nargin >= 1
        this.host = host;
      end
      if nargin >= 2 && ~isempty(port) && ~ismissing(port)
        mustBeScalarNumeric(port);
        this.port = port;
      end
    end
    
    function out = get.isconnected(this)
      out = this.jobj.isConnected;
    end
    
    function connect(this)
      % connect Connect and log in
      %
      % obj.connect()
      %
      % Creates a connection to the FTP server and logs in using the
      % username, password, and account set on this object.
      %
      % If you wish to use non-anonymous FTP, you must set the username and
      % password properties on obj before calling connect.
      if ismissing(this.host)
        error('jl:IllegalState', 'No host name is set. You must set a host name before calling connect().')
      end
      if isnan(this.port)
        this.jobj.connect(this.host);
      else
        this.jobj.connect(this.host, this.port);
      end
      replyCode = this.replyCode;
      if ~replyCode.isPositiveCompletion
        this.jobj.disconnect;
        error('jl:ftp:LoginFailure', 'Failed connecting to FTP server: %s', ...
          replyCode);
      end
      passwd = this.password;
      if isempty(passwd) && this.username == "anonymous"
        passwd = this.defaultPasswordForAnonymousFtp;
      end
      if isempty(this.account)
        ok = this.jobj.login(this.username, passwd);
      else
        ok = this.jobj.login(this.username, passwd, this.account);
      end
      if ~ok
        reply = this.replyCode;
        error('jl:ftp:LoginFailure', 'Failed logging in as %s to %s: %s', ...
          this.username, this.host, reply);
      end
    end
    
    function disconnect(this)
      if this.isconnected
        try
          this.jobj.logout;
          this.jobj.disconnect;
        catch err %#ok<NASGU>
          % Quash. You'll often get errors that the remote connection was
          % closed without indication, especially if you're cleaning up
          % after a failure
        end
      end
    end
    
    function delete(this)
      if this.isconnected
        this.disconnect;
      end
    end
    
    function out = replyCode(this)
      % replyCode Get the reply code for the last operation on this object
      %
      % out = replyCode(obj)
      %
      % Returns a jl.net.ftp.ReplyCode object.
      code = this.jobj.getReplyCode;
      out = jl.net.ftp.ReplyCode.ofNumericCode(code);
    end
    
    function cd(this, newDir)
      % cd Change directory on remote server
      %
      % obj.cd(newDir)
      % obj.cd("..")
      newDir = string(newDir);
      if newDir == ".."
        ok = this.jobj.changeToParentDirectory;
      else
        ok = this.jobj.changeWorkingDirectory(newDir);
      end
      if ~ok
        reply = this.getFullReply;
        error('Failed changing dir on remote server to ''%s'': %s: %s', ...
          newDir, reply.code, reply.message);
      end
    end
    
    function out = dir(this, pathname)
      % dir List files in a directory, with info
      %
      % out = obj.dir()
      % out = obj.dir(pathname)
      %
      % If no pathname is given, lists files in obj.cwd.
      %
      % Returns a table with at least variables:
      %   name
      %   date
      %   bytes
      %   isdir
      %   issymlink
      %   user
      %   group
      % or if there were no files, returns empty []. (Sorry about that; I'm
      % lazy.)
      if nargin == 1
        jFtpFiles = this.jobj.listFiles;
      else
        jFtpFiles = this.jobj.listFiles(pathname);
      end
      this.checkReplyCode('dir');
      out = [];
      for i = 1:numel(jFtpFiles)
        jf = jFtpFiles(i);
        s = struct;
        s.name = string(jf.getName);
        s.date = javaCalendarToDatetime(jf.getTimestamp);
        s.bytes = jf.getSize;
        s.isdir = jf.isDirectory;
        s.issymlink = jf.isSymbolicLink;
        s.user = string(jf.getUser);
        s.group = string(jf.getGroup);
        out = [out; s]; %#ok<AGROW>
      end
      if ~isempty(out)
        out = struct2table(out);
      end
    end
    
    function out = ls(this, pathname)
      % ls List files in a dir, getting just file names
      %
      % out = obj.ls()
      % out = obj.ls(pathname)
      %
      % Returns a string array of file names.
      if nargin == 1
        jFiles = this.jobj.listNames;
      else
        jFiles = this.jobj.listNames(pathname);
      end
      this.checkReplyCode('ls');
      out = string(jFiles);
    end
    
    function out = get.cwd(this)
      out = string(this.jobj.printWorkingDirectory);
      this.checkReplyCode('pwd');
    end
    
    function out = get.listHiddenFiles(this)
      out = this.jobj.getListHiddenFiles;
    end
    
    function set.listHiddenFiles(this, newVal)
      this.jobj.setListHiddenFiles(newVal);
    end
    
    function pasv(this)
      % pasv Enter Passive Mode
      %
      % obj.pasv()
      %
      % This causes the server to listen for data connections from the
      % client, instead of the other way around. This may be needed when
      % you're connecting from behind a firewall, like in many corporate IT
      % environments.
      this.jobj.enterLocalPassiveMode;
      this.checkReplyCode('PASV');
    end
    
    function actv(this)
      % actv Enter Active Mode
      %
      % obj.actv()
      this.jobj.enterLocalActiveMode;
      this.checkReplyCode('ACTV');
    end
    
    function get(this, file, localFile)
      % get Retrieve a single file from the server to the local machine
      %
      % obj.get(file)
      % obj.get(file, localDir)
      % obj.get(file, localFile)
      %
      % LocalDir is an existing local directory to save the file under.
      %
      % LocalFile is the path to save the file at locally. Passing an empty
      % is the same as omitting it.
      %
      % If neither LocalDir nor LocalFile is given, saves the file under
      % the Matlab process's current working directory.
      %
      % Raises an error if the file transfer fails.
      if nargin < 3; localFile = []; end
      if isempty(localFile)
        localFile = fullfile(pwd, file);
      else
        if isfolder(localFile)
          [~,base,extn] = fileparts(file);
          baseFile = [base extn];
          localFile = fullfile(localFile, baseFile);
        end
      end
      % TODO: Save to a temp file and then move the file, to avoid
      % clobbering local file upon download failure
      jOstr = java.io.BufferedOutputStream(java.io.FileOutputStream(localFile));
      RAII.jOstr = onCleanup(@() jOstr.close);
      ok = this.jobj.retrieveFile(file, jOstr);
      if ~ok
        reply = this.replyCode;
        error('jl:ftp:TransferFailure', 'Failed retrieving file ''%s'': %s', ...
          file, reply);
      end
    end
    
    function out = mget(this, pattern, localDir)
      % mget Get multiple files
      %
      % obj.mget(pattern)
      % obj.mget(pattern, localDir)
      %
      % Pattern is a string describing the files to download. It may use
      % the "*" wildcard.
      %
      % LocalDir is an optional local directory to download them to. If
      % omitted, they are downloaded to the current local directory.
      %
      % Returns the list of downloaded files, as relative paths.
      if nargin < 3; localDir = []; end
      if ~isempty(localDir)
        if ~isfolder(localDir)
          error('localDir must be an existing directory; %s is not');
        end
      end
      
      files = this.ls(pattern);
      this.checkReplyCode('mget');
      if isempty(files)
        error('jl:ftp:FileNotFound', 'Cannot mget ''%s'': no files on server matched pattern', ...
          pattern);
      end
      for i = 1:numel(files)
        this.get(files(i), localDir);
      end
      
      if nargout > 0
        out = files;
      end
    end
    
    function mkdir(this, newDir)
      % mkdir Create a new directory on the remote server
      ok = this.jobj.makeDirectory(newDir);
      if ~ok
        reply = this.replyCode;
        error('jl:ftp:OperationFailure', 'Failed creating dir ''%s'': %s', ...
          newDir, reply);
      end
    end
    
    function noop(this)
      % noop Send a no-op command to the server
      %
      % obj.noop()
      %
      % Sends a "no-op" command to the server which does nothing, but
      % ensures that the control connection is still working.
      %
      % This is useful for keeping the network connection alive if you're
      % going to be idle for a long time.
      ok = this.jobj.sendNoOp;
      if ~ok
        reply = this.replyCode;
        error('jl:ftp:OperationFailure', 'Failed doing no-op: %s', ...
          reply);
      end
    end
    
    function allocate(this, nbytes)
      % allocate Reserve space on the server for the next file transfer
      %
      % obj.allocate(nbytes)
      ok = this.jobj.allocate(nbytes);
      if ~ok
        reply = this.replyCode;
        error('jl:ftp:OperationFailure', 'Failed allocating %d bytes: %s', ...
          nbytes, reply);
      end
    end
    
    function deleteFile(this, file)
      % deleteFile Delete a file on the remote server
      ok = this.jobj.deleteFile(file);
      if ~ok
        reply = this.replyCode;
        error('jl:ftp:OperationFailure', 'Failed deleting file ''%s'': %s', ...
          file, reply);
      end
    end
    
    function ascii(this)
      % ascii Switch to ASCII file type mode
      this.jobj.setFileType(org.apache.commons.net.ftp.FTPClient.ASCII_FILE_TYPE);
    end
    
    function binary(this)
      % binary Switch to binary file type mode
      this.jobj.setFileType(org.apache.commons.net.ftp.FTPClient.BINARY_FILE_TYPE);
    end

    function out = status(this)
      % status Get session status
      %
      % Gets session status information, as a human-readable string.
      %
      % Returns a scalar string.
      out = string(this.jobj.getStatus);
    end
    
    function out = get.systemType(this)
      if this.isconnected
        out = string(this.jobj.getSystemName);
      else
        out = string(missing);
      end
    end
    
    function put(this, localFile, remoteFile)
      % put Upload a file to the remote host
      %
      % obj.put(localFile)
      % obj.put(localFile, remoteFile)
      %
      % Uploads and stores the given local file to the server.
      %
      % RemoteFile is the path to the remote file to store. If omitted,
      % stores in the current remote working directory using the leaf file
      % name of localFile.
      if nargin < 3; remoteFile = []; end
      if isempty(remoteFile)
        [~,base,extn] = fileparts(localFile);
        remoteFile = [base extn];
      end
      jFile = java.io.File(localFile);
      jIstr = java.io.BufferedInputStream(java.io.FileInputStream(jFile));
      RAII.jIstr = onCleanup(@() jIstr.close);
      ok = this.jobj.storeFile(remoteFile, jIstr);
      if ~ok
        reply = this.replyCode;
        error('jl:ftp:OperationFailure', 'Failed storing file ''%s'' on remote host: %s', ...
          localFile, reply);
      end      
    end
    
    function putUnique(this, localFile, remoteFileBase)
      % putUnique Upload a file to the remote host with a unique name
      %
      % obj.putUnique(localFile)
      % obj.putUnique(localFile, remoteFileBase)
      %
      % Stores a file on the server using a unique name assigned by the
      % server.
      %
      % RemoteFileBase (string) is the base name to use for the remote file
      % name. If provided, the remote unique name is derived from the given
      % file name. If omitted, the server just makes up whatever name it
      % wants.
      if nargin < 3; remoteFileBase = []; end
      jFile = java.io.File(localFile);
      jIstr = java.io.BufferedInputStream(java.io.FileInputStream(jFile));
      RAII.jIstr = onCleanup(@() jIstr.close);
      if isempty(remoteFileBase)
        ok = this.jobj.storeUniqueFile(jIstr);
      else
        ok = this.jobj.storeUniqueFile(remoteFileBase, jIstr);
      end
      if ~ok
        reply = this.replyCode;
        if isempty(remoteFileBase)
        else
          error('jl:ftp:OperationFailure', 'Failed storing unique file ''%s'' on remote host: %s', ...
            localFile, reply);
        end
      end      
    end
    
    function out = mtime(this, file)
      % mtime Get the modification time of a file
      %
      % out = obj.mtime(file)
      %
      % Gets the modification time of a file on the remote host.
      %
      % Not all servers support this command. If your server does not
      % support this command, you may get a weird Java error message in the
      % raised error.
      %
      % Returns a datetime.
      mtimeStr = string(this.jobj.getModificationTime(java.lang.String(file)));
      out = datetime(mtimeStr);
    end
    
  end
  
  methods (Access = private)

    function out = getFullReply(this)
      % getFullReply Get the full reply, including code and message text
      %
      % Note: This can hang for a long time if there is no actual message
      % text to be retrieved! Only call it when you know you're in a state
      % to receive a text reply.
      code = this.jobj.getReply;
      msg = strjoin(string(this.jobj.getReplyStrings), LF);
      out = jl.net.ftp.Reply.of(code, msg);
    end

    function out = wrapReplyCode(this, code) %#ok<INUSL>
      out = jl.net.ftp.ReplyCode.ofNumericCode(code);
    end
    
    function out = defaultPasswordForAnonymousFtp(this) %#ok<MANU>
      try
        out = getpref('Internet', 'E_mail');
      catch err %#ok<NASGU>
        out = 'janklab_user@example.com';
      end
    end

    function checkReplyCode(this, operation)
      if nargin < 2 || isempty(operation); operation = 'operation'; end
      replyCode = this.replyCode;
      if ~replyCode.isPositiveCompletion
        error('jl:net:ftp:FailedOperation', '%s failed: error %s', ...
          operation, replyCode);
      end
    end
    
  end
end

function out = javaCalendarToDatetime(jCal)
unixMillis = jCal.getTimeInMillis;
unixSecs = double(unixMillis) / 1000;
out = datetime(unixSecs, 'ConvertFrom','posixtime');
end
