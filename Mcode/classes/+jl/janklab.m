classdef janklab
  %JANKLAB Central info and management for the Janklab library
  
  methods(Static)
    
    function init_janklab
      %INIT_JANKLAB Runs Janklab initialization code
      %
      % This is for Janklab's internal use, to be called by the top-level
      % INIT_JANKLAB.
      % Do not call it yourself.
      
      % Initialize state data
      setappdata(0, 'JanklabState', struct);
      
      % Initialize logging
      logger.initSLF4M();
      
      % Initialize MDBC
      jl.sql.Mdbc.initMdbc();
      
      % Announce initialization and version
      dispf('Janklab %s initialized', jl.janklab.version);
      
      % Check the version
      
      if verLessThan('matlab', '9.7.0')
        warning(['This version of Matlab is too old. Janklab requires Matlab R2019b ' ...
          'or newer. Some parts of Janklab will not work.\n']);
      end
    end
    
    function out = version
      %VERSION Version information for Janklab
      persistent val
      if isempty(val)
        thisDir = fileparts(mfilename('fullpath'));
        repoDir = fileparts(fileparts(fileparts(thisDir)));
        versionFile = [repoDir '/VERSION'];
        txt = fileread(versionFile);
        lines = regexp(txt, '\r?\n', 'split');
        val = lines{1};
      end
      out = val;
    end
    
    function addSynchronizedFoldersToPath()
      % Add synchronized-service folders to path
      %
      % This is a hack to support a common user-specific "MATLAB" folder that lives in
      % Dropbox or elsewhere.
      
      % The paths within these synchronized folders are entirely a Janklab convention;
      % I just made it up based on where Matlab likes to store its "user documents" by
      % default.
      
      % Add Dropbox
      dropboxDir = dropboxPath();
      dropboxMatlabPath = fullfile(dropboxDir, 'Documents', 'MATLAB');
      if isfolder(dropboxMatlabPath)
        addpath(dropboxMatlabPath);
      end
      
      % Nothing else is supported yet. Sorry, Microsoft OneDrive users!
      
    end
    
  end
end

function out = dropboxPath()
userHomeDir = char(java.lang.System.getProperty('user.home'));
if ismac()
  out = fullfile(userHomeDir, 'Dropbox');
elseif ispc()
  out = fullfile(userHomeDir, 'Dropbox');
else
  % I don't know where Dropbox lives on Linux. Let's just guess it's at
  % ~/Dropbox.
  out = fullfile(userHomeDir, 'Dropbox');
end
end