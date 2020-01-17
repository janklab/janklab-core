classdef int32n < intn
	%INT32N NaN-able signed 32-bit integer array
	%
	% See also:
	% INTN
	
	methods
		
		function this = int32n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = int32(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end
