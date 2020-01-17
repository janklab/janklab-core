classdef int8n < intn
	%INT8N NaN-able signed 8-bit integer array
	%
	% See also:
	% INTN
	
	methods
		
		function this = int8n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = int8(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end
