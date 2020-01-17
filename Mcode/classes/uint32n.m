classdef uint32n < intn
	%UINT32N NaN-able unsigned 32-bit integer array
	%
	% See also:
	% INTN
	
	methods (Static)
		function out = empty(sz)
			if nargin < 1 || isempty(sz); sz = [0 0]; end
			out = uint32n(reshape([], sz));
		end
	end
	
	methods
		
		function this = uint32n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = uint32(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end
