classdef ProcessBuilderRedirect < handle
  % Indicates an input or output redirection for a Process
  %
  % This class is only used with ProcessBuilder.
  %
  % See also:
  % jl.util.ProcessBuilder
  % jl.util.Process

  % TODO: Custom display
  
  %#ok<*PROP>
  
  properties
    jobj
  end
  
  properties (Dependent)
    file
    type
  end
  
  properties (Constant, Hidden)
    PIPE = jl.util.ProcessBuilderRedirect(jl.util.java.getStaticFieldOnClass(...
      'java.lang.ProcessBuilder$Redirect', 'PIPE'))
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
  end
  
  methods (Static)
    function out = appendTo(file)
      jFile = java.io.File(file);
      jobj = jl.util.java.callStaticMethod('java.lang.ProcessBuilder$Redirect', ...
        'appendTo', { jFile });
      out = jl.util.ProcessBuilderRedirect(jobj);
    end
    
    function out = to(file)
      jFile = java.io.File(file);
      jobj = jl.util.java.callStaticMethod('java.lang.ProcessBuilder$Redirect', ...
        'to', { jFile });
      out = jl.util.ProcessBuilderRedirect(jobj);
    end
    
    function out = from(file)
      jFile = java.io.File(file);
      jobj = jl.util.java.callStaticMethod('java.lang.ProcessBuilder$Redirect', ...
        'from', { jFile });
      out = jl.util.ProcessBuilderRedirect(jobj);
    end
  end
  
end