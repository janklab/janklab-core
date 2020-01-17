classdef int16n < intn
	%INT16N NaN-able signed 16-bit integer array
	
	methods
		function this = int16n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = int16(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
end