classdef int8n < intn
	%INT8N NaN-able signed 8-bit integer array
	%
	% See also:
	% INTN
	
	methods (Static)
		function out = empty(sz)
			if nargin < 1 || isempty(sz); sz = [0 0]; end
			out = int8n(reshape([], sz));
		end
	end
	
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
