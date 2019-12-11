classdef Displayable
  %DISPLAYABLE A mixin for defining custom display format using dispstrs()
  %
  % This defines custom disp(), display(), and dispstr() behavior in terms of
  % dispstrs().
  %
  % Classes inheriting from this should implement a dispstrs() that conforms
  % to its standard signature.
  %
  % See also:
  % jl.util.DisplayableHandle
  
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
  end
  
  methods (Access = protected)
    function out = dispstr_scalar(this) %#ok<STOUT>
      error('jl:Unimplemented', ['Subclasses of Displayable must override ' ...
        'dispstr_scalar; %s does not'], ...
        class(this));
    end
  end
end