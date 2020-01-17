classdef uint64n < intn
	%UINT64N NaN-able unsigned 64-bit integer array
	%
	% See also:
	% INTN
	
	methods (Static)
		function out = empty(sz)
			if nargin < 1 || isempty(sz); sz = [0 0]; end
			out = uint64n(reshape([], sz));
		end
	end
	
	methods
		
		function this = uint64n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = uint64(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end