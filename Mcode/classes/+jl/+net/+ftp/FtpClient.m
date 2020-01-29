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
  
  properties (Access = private)
    % The underlying apache FTPClient object
    jobj = org.apache.commons.net.ftp.FTPClient
  end
  properties
    % Remote host to connect to
    host (1,1) string = string(missing)
    % Port for the command port
    port (1,1) double = 21
    % Username to log in as. Defaults to 'anonymous'.
    username (1,1) string = "anonymous"
    % Password to provide. Defaults to your email address from Matlab's
    % Internet prefs
    password (1,1) string = getpref('Internet', 'E_mail')
  end
  properties (Dependent)
    % The current directory on the remote host
    cwd
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
    
    function out = isconnected(this)
      out = this.jobj.isConnected;
    end
    
    function connect(this)
      if ismissing(this.host)
        error('jl:IllegalState', 'No host name is set. You must set a host name before calling connect().')
      end
      this.jobj.connect(this.host, this.port);
      replyCode = this.replyCode;
      if ~replyCode.isPositiveCompletion
        this.jobj.disconnect;
        error('Failed connecting to FTP server: %s', ...
          dispstr(replyCode);
      end
    end
    
    function disconnect(this)
      if this.isconnected
        this.jobj.logout;
        this.jobj.disconnect;
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
    
  end
  
end