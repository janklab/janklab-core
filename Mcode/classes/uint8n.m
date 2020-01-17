classdef uint8n < intn
	%UINT8N NaN-able unsigned 8-bit integer array
	
	methods
		
		function this = uint8n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = uint8(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end
