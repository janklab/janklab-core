classdef int64n < intn
	%INT64N NaN-able signed 64-bit integer array
	%
	% See also:
	% INTN
	
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