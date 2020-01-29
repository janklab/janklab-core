classdef DisplayableHandle < handle
  %DISPLAYABLEHANDLE A mixin for defining custom display format using dispstrs()
  %
  % This defines custom disp(), display(), and dispstr() behavior in terms of
  % dispstrs().
  %
  % Classes inheriting from this should implement a dispstrs() that conforms
  % to its standard signature.
  %
  % This is exactly the same as jl.util.Displayable, except that it is a
  % handle, so it can be used as a mixin by handle classes.
  %
  % See also:
  % jl.util.Displayable
  
  methods
    function disp(this)
      %DISP Custom display
      disp(dispstr(this));
    end
    
    function out = dispstr(this)
      %DISPSTR Custom display string
      if isscalar(this)
        strs = dispstrs(this);
        out = strs{1};
      else
        out = sprintf('%s %s', size2str(size(this)), class(this));
      end
    end
    
    function out = dispstrs(this)
      out = cell(size(this));
      for i = 1:numel(this)
        out{i} = dispstr_scalar(this(i));
      end
    end
    
    
    function error(varargin)
      args = convertDisplayablesToString(varargin);
      err = MException(args{:});
      throwAsCaller(err);
    end
    
    function warning(varargin)
      args = convertDisplayablesToString(varargin);
      warning(args{:});
    end
    
    function out = sprintf(varargin)
      args = convertDisplayablesToString(varargin);
      out = sprintf(args{:});
    end
    
    function out = fprintf(varargin)
      args = convertDisplayablesToString(varargin);
      out = sprintf(args{:});
    end
    
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this) %#ok<STOUT>
      error('jl:Unimplemented', ['Subclasses of DisplayableHandle must override ' ...
        'dispstr_scalar; %s does not'], ...
        class(this));
    end
  end
end

function out = convertDisplayablesToString(c)
mustBeA(c, 'cell');
out = c;
for i = 1:numel(c)
  if isa(c{i}, 'jl.util.DisplayableHandle')
    out{i} = dispstr(c{i});
  end
end
end
