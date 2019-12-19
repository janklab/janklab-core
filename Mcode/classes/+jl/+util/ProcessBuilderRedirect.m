classdef ProcessBuilderRedirect < jl.util.DisplayableHandle
  % Indicates an input or output redirection for a Process
  %
  % This class is only used with ProcessBuilder.
  %
  % See also:
  % jl.util.ProcessBuilder
  % jl.util.Process

  %#ok<*PROP>
  
  properties
    % The underlying java.lang.ProcessBuilder.Redirect object
    jobj
  end
  
  properties (Dependent)
    % The file this redirect is writing to or from, if any
    file
    % The type of this redirect, as a string
    type
  end
  
  properties (Constant)
    % Indicates that subprocess I/O will be connected to the current
    % process via a pipe
    PIPE = jl.util.ProcessBuilderRedirect(jl.util.java.getStaticFieldOnClass(...
      'java.lang.ProcessBuilder$Redirect', 'PIPE'))
    % Indicates that subprocess I/O source/destination will be the same as
    % that of the current process
    INHERIT = jl.util.ProcessBuilderRedirect(jl.util.java.getStaticFieldOnClass(...
      'java.lang.ProcessBuilder$Redirect', 'INHERIT'))
  end
  
  methods
    function this = ProcessBuilderRedirect(jobj)
      % Construct a new ProcessBuilderRedirect
      %
      % You generally do not want to call this. Instead, call one of the
      % static to(), appendTo(), or from() methods, or use the PIPE or
      % INHERIT constants.
      if nargin == 0
        return
      end
      mustBeA(jobj, 'java.lang.ProcessBuilder$Redirect');
      this.jobj = jobj;
    end
    
    function out = get.file(this)
      if isempty(this.jobj)
        out = [];
      else
        file = this.jobj.file;
        if isempty(file)
          out = [];
        else
          out = string(file.toString);
        end
      end
    end
    
    function out = get.type(this)
      if isempty(this.jobj)
        out = [];
      else
        out = char(this.jobj.type.toString);
      end
    end
    
    function out = shortstr(this)
      mustBeScalar(this);
      if isempty(this.jobj)
        descr = '<null>';
      else
        switch this.type
          case 'PIPE'
            descr = 'PIPE';
          case 'INHERIT'
            descr = 'INHERIT';
          case 'APPEND'
            descr = sprintf('>> %s', this.file);
          case 'READ'
            descr = sprintf('< %s', this.file);
          case 'WRITE'
            descr = sprintf('> %s', this.file);
          otherwise
            descr = sprintf('<unrecognized type: %s>', this.type);
        end
      end
      out = descr;
    end
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this)
      descr = shortstr(this);
      out = sprintf('ProcessBuilderRedirect: %s', descr);
    end
  end
  
  methods (Static)
    function out = appendTo(file)
      % appendTo Create a new ProcessBuilderRedirect for appending to a file
      jFile = java.io.File(file);
      jobj = jl.util.java.callStaticMethod('java.lang.ProcessBuilder$Redirect', ...
        'appendTo', { jFile });
      out = jl.util.ProcessBuilderRedirect(jobj);
    end
    
    function out = to(file)
      % to Create a new ProcessBuilderRedirect for writing to a file
      jFile = java.io.File(file);
      jobj = jl.util.java.callStaticMethod('java.lang.ProcessBuilder$Redirect', ...
        'to', { jFile });
      out = jl.util.ProcessBuilderRedirect(jobj);
    end
    
    function out = from(file)
      % from Create a new ProcessBuilderRedirect for reading from a file
      jFile = java.io.File(file);
      jobj = jl.util.java.callStaticMethod('java.lang.ProcessBuilder$Redirect', ...
        'from', { jFile });
      out = jl.util.ProcessBuilderRedirect(jobj);
    end
  end
  
end