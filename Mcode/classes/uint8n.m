classdef uint8n < intn
	%UINT8N NaN-able unsigned 8-bit integer array
	
	methods (Static)
		function out = empty(sz)
			if nargin < 1 || isempty(sz); sz = [0 0]; end
			out = uint8n(reshape([], sz));
		end
	end
	
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
