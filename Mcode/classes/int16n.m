classdef int16n < intn
	%INT16N NaN-able signed 16-bit integer array
	
	methods (Static)
		function out = empty(sz)
			if nargin < 1 || isempty(sz); sz = [0 0]; end
			out = int16n(reshape([], sz));
		end
	end
	
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
