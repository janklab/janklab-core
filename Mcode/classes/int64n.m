classdef int64n < intn
	%INT64N NaN-able signed 64-bit integer array
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
		
		function this = int64n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = int64(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end