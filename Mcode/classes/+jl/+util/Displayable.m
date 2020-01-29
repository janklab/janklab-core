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
        out{i} = dispstr_scalar(subsref(this, ...
					struct('type','()', 'subs',{{i}})));
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
    
  end
  
  methods (Access = protected)
    
    function out = dispstr_scalar(this) %#ok<STOUT>
      error('jl:Unimplemented', ['Subclasses of Displayable must override ' ...
        'dispstr_scalar; %s does not'], ...
        class(this));
		end
		
		function dispMaybeMatrix(this)
			if ~ismatrix(this)
				disp(dispstr(this));
				return
			elseif isempty(this)
				if isequal(size(this), [0 0])
					fprintf('[] (%s)\n', class(this));
				else
					fprintf('Empty %s %s array\n', size2str(size(this)), ...
						class(this));
				end
			else
				strs = dispstrs(this);
				nCols = size(strs, 2);
				colWidths = NaN(1, nCols);
				for i = 1:nCols
					colWidths(i) = max(strlen(strs(:,i)));
				end
				fmt = [strjoin(repmat({'%*s'}, [1 nCols]), '  ') '\n'];
				for iRow = 1:size(strs, 1)
					args = [num2cell(colWidths); strs(iRow,:)];
					args = args(:);
					fprintf(fmt, args{:});
				end
			end
    end
    
  end
end

function out = convertDisplayablesToString(c)
mustBeA(c, 'cell');
out = c;
for i = 1:numel(c)
  if isa(c{i}, 'jl.util.Displayable')
    out{i} = dispstr(c{i});
  end
end
end