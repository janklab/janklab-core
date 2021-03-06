classdef ProcessBuilder < jl.util.DisplayableHandle
  % ProcessBuilder Launcher for processes with redirection, env, etc
  %
  % A ProcessBuilder lets you build up a new Process with input/output
  % redirection, environment setting, and so on. This is what you use if
  % you want more control over your process's behavior that
  % jl.util.Process.run() gives you.
  %
  % See also:
  % jl.util.Process
  
  % TODO: A convenient way to access the full effective environment, not
  % just envadd. But don't include that in the default display.
  
  properties (SetAccess = private)
    % The underlying java.lang.ProcessBuilder object
    jobj
    % Additions to the process's environment
    envadd = struct
  end
  
  properties (Dependent = true)
    % The directory the process will start in, as a string
    directory
    % Whether the process merges its error stream into its output stream
    redirectErrorStream
    % The full command line for the process
    commandLine
    % The command for the process
    command
    % The arguments after the command for the process
    arguments
    % How to redirect the process's stdin
    redirectInput
    % How to redirect the process's stdout
    redirectOutput
    % How to redirect the process's stderr
    redirectError
  end
  
  methods
    function this = ProcessBuilder(cmd)
      % ProcessBuilder Construct a new ProcessBuilder
      %
      % obj = jl.util.ProcessBuilder(cmd)
      %
      % cmd is a string array indicating the command and, optionally, any
      % arguments to pass to it. Also known as the "command line".
      %
      % If you call this with no arguments, you will get an unusable
      % object. You must pass a command in for it to be usable.
      if nargin == 0
        return
      end
      cmd = string(cmd);
      this.jobj = java.lang.ProcessBuilder(cmd);
    end
    
    function out = get.directory(this)
      dirFile = this.jobj.directory;
      if isempty(dirFile)
        out = [];
      else
        out = string(dirFile.getPath);
      end
    end
    
    function set.directory(this, dir)
      this.jobj.directory(java.io.File(dir));
    end
    
    function out = get.redirectErrorStream(this)
      out = this.jobj.redirectErrorStream;
    end
    
    function set.redirectErrorStream(this, tf)
      mustBeScalarLogical(tf);
      this.jobj.redirectErrorStream(tf);
    end
    
    function out = get.redirectInput(this)
      out = jl.util.ProcessBuilderRedirect(this.jobj.redirectInput);
    end
    
    function set.redirectInput(this, redirect)
      if isempty(redirect)
        this.jobj.redirectInput(jl.util.ProcessBuilderRedirect.PIPE.jobj);
      elseif ischar(redirect) || isstring(redirect)
        redirect = char(redirect);
        if startsWith(redirect, '<')
          redirect = redirect(2:end);
        end
        redirect = strtrim(redirect);
        red = jl.util.ProcessBuilderRedirect.from(redirect);
        this.jobj.redirectInput(red.jobj);
      elseif isa(redirect, 'jl.util.ProcessBuilderRedirect')
        this.jobj.redirectInput(redirect.jobj)
      else
        error('jl:InvalidInput', ['redirect must be a string or ' ...
          'jl.util.ProcessBuilderRedirect; got a %s'], class(redirect));
      end
    end
    
    function out = get.redirectOutput(this)
      out = jl.util.ProcessBuilderRedirect(this.jobj.redirectOutput);
    end
    
    function set.redirectOutput(this, redirect)
      if isempty(redirect)
        this.jobj.redirectOutput(jl.util.ProcessBuilderRedirect.PIPE.jobj);
      elseif ischar(redirect) || isstring(redirect)
        redirect = char(redirect);
        if startsWith(redirect, '>>')
          file = strtrim(redirect(3:end));
          red = jl.util.ProcessBuilderRedirect.appendTo(file);
        else
          file = strtrim(regexprep(redirect, '^>', ''));
          red = jl.util.ProcessBuilderRedirect.to(file);
        end
        this.jobj.redirectOutput(red.jobj);
      elseif isa(redirect, 'jl.util.ProcessBuilderRedirect')
        this.jobj.redirectOutput(redirect.jobj)
      else
        error('jl:InvalidInput', ['redirect must be a string or ' ...
          'jl.util.ProcessBuilderRedirect; got a %s'], class(redirect));
      end
    end
    
    function out = get.redirectError(this)
      out = jl.util.ProcessBuilderRedirect(this.jobj.redirectError);
    end
    
    function set.redirectError(this, redirect)
      if isempty(redirect)
        this.jobj.redirectError(jl.util.ProcessBuilderRedirect.PIPE.jobj);
      elseif ischar(redirect) || isstring(redirect)
        redirect = char(redirect);
        if startsWith(redirect, '>>')
          file = strtrim(redirect(3:end));
          red = jl.util.ProcessBuilderRedirect.appendTo(file);
        else
          file = strtrim(regexprep(redirect, '^>', ''));
          red = jl.util.ProcessBuilderRedirect.to(file);
        end
        this.jobj.redirectError(red.jobj);
      elseif isa(redirect, 'jl.util.ProcessBuilderRedirect')
        this.jobj.redirectError(redirect.jobj)
      else
        error('jl:InvalidInput', ['redirect must be a string or ' ...
          'jl.util.ProcessBuilderRedirect; got a %s'], class(redirect));
      end
    end
    
    function inheritIO(this)
      % inheritIO Make the new process inherit the parent's I/O streams
      %
      % Calling this method causes the process built by this ProcessBuilder
      % to inherit the parent process's input and output streams. The
      % behavior of this inside a Matlab desktop process is not
      % well-defined, so be careful.
      this.jobj.inheritIO;
    end
    
    function out = start(this)
      % start Start a new process as defined by this ProcessBuilder
      %
      % Returns a jl.util.Process.
      jproc = this.jobj.start;
      out = jl.util.Process(jproc, this.command, this.arguments);
    end
    
    function out = get.commandLine(this)
      jlist = this.jobj.command;
      % TODO: Can we one-liner this conversion with a toArray() call?
      n = jlist.size;
      out = repmat("", [1 n]);
      for i = 1:n
        out(i) = string(jlist.get(i-1));
      end
    end
    
    function set.commandLine(this, commandLine)
      this.jobj.command(commandLine);
    end
    
    function out = get.command(this)
      cl = this.commandLine;
      out = cl(1);
    end
    
    function out = get.arguments(this)
      cl = this.commandLine;
      out = cl(2:end);
    end
    
    function out = env(this, a, b)
      % env Get or set environment variables for the process
      %
      % obj.env(s)
      % obj.env(name, val)
      % val = obj.env(name)
      % s = obj.env()
      %
      % s is a struct.
      %
      % name and val are strings.
      narginchk(1, 3);
      if nargin == 1
        out = this.envadd;
      elseif nargin == 2
        if isstruct(a)
          names = fieldnames(a);
          for i = 1:numel(names)
            this.setEnvVar(names{i}, a.(names{i}));
          end
        elseif ischar(a) || isstring(a)
          out = this.envadd(a);
        else
          error('jl:InvalidInput', 'Invalid input type');
        end
      else
        this.setEnvVar(a, b);
      end
    end
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this)
      if isempty(this.jobj)
        out = 'ProcessBuilder: <null>';
        return;
      end
      s.commandLine = this.commandLine;
      if this.redirectErrorStream
        s.redirectErrorStream = true; 
      end
      if ~isempty(this.directory)
        s.directory = this.directory;
      end
      if ~isequal(this.redirectInput.type, 'PIPE')
        s.redirectInput = shortstr(this.redirectInput);
      end
      if ~isequal(this.redirectOutput.type, 'PIPE')
        s.redirectOutput = shortstr(this.redirectOutput);
      end
      if ~isequal(this.redirectError.type, 'PIPE')
        s.redirectError = shortstr(this.redirectError); %#ok<STRNU>
      end
      out = sprintf('ProcessBuilder:\n%s', chomp(evalc('disp(s)')));
      envVars = fieldnames(this.envadd);
      if ~isempty(envVars)
        out = sprintf('%s\nEnvironment:', out);
        for i = 1:numel(envVars)
          out = sprintf('%s\n  %s = %s', out, envVars{i}, ...
            this.envadd.(envVars{i}));
        end
        out = [out newline];
      end
    end
  end
  
  methods (Access = private)
    function setEnvVar(this, name, val)
      this.envadd.(name) = val;
      envmap = this.jobj.environment;
      envmap.put(name, val);
    end
  end
end

function out = chomp(str)
out = regexprep(str, '\r?\n$', '');
end