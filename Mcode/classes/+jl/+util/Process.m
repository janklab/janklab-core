classdef Process < jl.util.DisplayableHandle
  % Process An external process that you can control and interact with
  %
  % This class allows you to create, control, and interact with a
  % subprocess using M-code. This differs from the system() and ! commands
  % in that your M-code can interact with the process while it is still
  % running, whereas system() and ! wait until the process completes and
  % then return its results.
  %
  % I can't actually think of a practical use for this, aside from getting
  % Matlab to play interactive adventure games like Zork, but here it is
  % anyway.
  %
  % Examples:
  %
  % proc = jl.util.Process.run("ls")
  % output = proc.readText()
  %
  % See also:
  % jl.util.ProcessBuilder
  
  % TODO: Merge command and arguments into a single arg/property?
  
  properties (SetAccess = private)
    % The underlying java.lang.Process object
    proc
    % The process's PID, if known
    pid
    % The command used to start the process, or "?" if unknown
    command string = "?"
    % The arguments to the command used to start the process, if known
    arguments = []
    % The process's standard input, as a java.io.OutputStream
    stdin
    % The process's standard output, as a java.io.InputStream
    stdout
    % The process's standard error, as a java.io.InputStream
    stderr
    % A java.io.Writer wrapping stdin
    stdin_txt
    % A java.io.Reader wrapping stdout
    stdout_txt
    % A java.io.Reader wrapping stderr
    stderr_txt
  end
  
  methods (Static)
    function out = run(command, arguments)
      % run Create a process by running a command
      %
      % proc = jl.util.Process.run(command)
      % proc = jl.util.Process.run(command, arguments)
      %
      % command (string) is the command to run. It is required.
      %
      % arguments (string) is a list of arguments to pass to the command.
      % It is optional.
      %
      % Returns a newly created jl.util.Process object. Throws an error if
      % there was a problem running the command.
      command = string(command);
      if nargin < 2 || isempty(arguments)
        arguments = [];
      else
        arguments = string(arguments);
      end
      pb = java.lang.ProcessBuilder([command arguments]);
      proc = pb.start;
      out = jl.util.Process(proc, command, arguments);
    end
  end
  
  methods
    function this = Process(proc, command, arguments)
      % Process Construct a new Process object around a Java Process
      %
      % You probably want to use the run() method instead.
      %
      % See also:
      % jl.util.Process.run
      if nargin == 0
        return
      end
      mustBeA(proc, 'java.lang.Process');
      this.proc = proc;
      if nargin >= 2
        this.command = string(command);
      end
      if nargin >= 3
        this.arguments = string(arguments);
      end
      if isa(proc, 'java.lang.UNIXProcess')
        this.pid = getPidFromUnixProcess(proc);
      end
      this.stdin = proc.getOutputStream;
      this.stdout = proc.getInputStream;
      this.stderr = proc.getErrorStream;
      % No buffering, since we're interacting with a process!
      this.stdin_txt = java.io.OutputStreamWriter(this.stdin);
      % It would probably be fine to buffer these, but then the caller
      % would have to be careful to only use either the InputStreams or the
      % Readers, and not switch between them.
      this.stdout_txt = java.io.InputStreamReader(this.stdout);
      this.stderr_txt = java.io.InputStreamReader(this.stderr);
    end
    
    function [out,err] = readText(this)
      % readText Read all the available output of this process, as text
      %
      % [out,err] = readText(this)
      %
      % Reads all the available output from stdout and optionally stderr,
      % as text.
      %
      % If 2 or more argouts are supplied, then stderr is read and drained.
      % If less than 2 argouts are supplied, then stderr is untouched.
      %
      % Returns a string, which may be empty.
      out = slurpReader(this.stdout_txt);
      if nargout > 1
        err = slurpReader(this.stderr_txt);
      end
    end
    
    function writeText(this, text)
      % writeText Write text to the process's stdin
      text = string(text);
      this.stdin_txt.write(text);
      this.stdin_txt.flush;
    end
    
    function destroy(this)
      % destroy Destroys (kills) the process
      this.proc.destroy;
    end
    
    function out = exitValue(this)
      % exitValue Gets the exit value of the process
      %
      % Throws an error if the process hasn't exited yet.
      out = this.proc.exitValue;
    end
    
    function waitFor(this)
      % waitFor Wait until the process has been terminated
      this.proc.waitFor;
    end
    
    function out = isAlive(this)
      % isAlive Whether the process is alive
      %
      % tf = proc.isAlive()
      %
      % Only works on Unix systems. May throw an error on other systems.
      out = this.proc.isAlive;
    end
    
    function signal(this, sig)
      % signal Send a signal to the process
      %
      % signal(proc, signum)
      % signal(proc, signame)
      %
      % You can pass either a signal name or number. The set of valid
      % signals and their corresponding numbers is system-dependent.
      %
      % Only works on Unix systems.
      %
      % Examples:
      % proc.signal(9)
      % proc.signal('KILL')
      
      if ispc
        error("signal only works on Unix systems");
      end
      if isempty(this.pid)
        error("Process PID is unknown; cannot send signal");
      end
      
      if ischar(sig)
        sig = string(sig);
      end
      if isstring(sig)
        cmdLine = sprintf("kill -s '%s' %d", sig, this.pid);
        sigDescrip = sig;
      else
        cmdLine = sprintf("kill -%d %d", sig, this.pid);
        sigDescrip = num2str(sig);
      end
      [status,output] = system(cmdLine);
      if status ~= 0
        error("Failed sending signal %s to PID %d: %s", sigDescrip, ...
          this.pid, output);
      end
    end
    
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this)
      out = 'Process';
      if ~isempty(this.pid)
        out = sprintf('%s pid %d', out, this.pid);
      end
      if ~isempty(this.command)
        cmdLine = this.command;
        if ~isempty(this.arguments)
          cmdLine = sprintf("%s %s", this.command, strjoin(this.arguments, " "));
        end
        out = sprintf('%s (%s)', out, cmdLine);
      end
      if isunix
        if ~this.isAlive
          out = sprintf('%s (exit value = %d)', out, this.exitValue);
        end
      end
    end
  end
  
end

function out = slurpReader(reader)
  buf = java.nio.CharBuffer.allocate(1024);
  out = "";
  while reader.ready
    nRead = reader.read(buf);
    if nRead <= 0
      return
    end
    arr = buf.array;
    % I'm not sure that starting at 1 is the right thing here when repeated
    % reads to the same buffer are done.
    chars = arr(1:nRead)';
    out = out + string(chars);
  end
end

function out = getPidFromUnixProcess(proc)
  s = jl.util.java.getPrivateFieldsCombined(proc);
  out = s.pid;
end