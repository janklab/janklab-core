classdef nil
%NIL Placeholder for missing arrays
%
% NIL is a placeholder for a missing or omitted array, much like NaN is a
% placeholder for individual missing elements within an array. It is used
% to indicate omitted arguments or fields where a default value should be
% used, or to indicate completely missing data.
%
% @nil is the only type which is considered to be nil by ISNIL.
%
% A @nil is always empty. It is only equal to itself or another @nil, and
% never equal to anything else. (There may as well be just one singleton
% instance of @nil, but I'm not sure how to implement that in Matlab.)

methods
	function tf = isnil(~)
		%ISNIL True if input is nil
		tf = true;
	end
	
	function out = isequal(a, b)
		out = isnil(a) && isnil(b);
	end
	
	function out = isequaln(a, b)
		out = isequal(a, b);
	end
	
	% Overrides for structural stuff
	
	function out = size(~)
		out = [0 0];
	end
	
	function out = numel(~)
		out = 0;
	end
	
	function out = isempty(~)
		out = true;
	end
	
	function out = length(~)
		out = 0;
	end
	
	function out = subsasgn(varargin) %#ok
		error('jl:BadOperation', '@nil may not have its elements assigned to');
	end
	
	function out = repmat(this, varargin) %#ok
	  error('jl:BadOperation', 'repmat() is not supported for @nil inputs');
	end
	
	function out = cat(this, varargin) %#ok
	  error('jl:BadOperation', 'cat() is not supported for @nil inputs');
	end
	
	function out = horzcat(this, varargin) %#ok
	  error('jl:BadOperation', 'horzcat() is not supported for @nil inputs');
	end
	
	function out = vertcat(this, varargin) %#ok
	  error('jl:BadOperation', 'vertcat() is not supported for @nil inputs');
	end
	
	function disp(~)
		disp('@nil');
	end
	
	
end

end
