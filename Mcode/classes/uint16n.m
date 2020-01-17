classdef uint16n < intn
	%UINT16N NaN-able unsigned 16-bit integer array
	%
	% See also:
	% INTN
	
	methods (Static)
		function out = empty(sz)
			if nargin < 1 || isempty(sz); sz = [0 0]; end
			out = uint16n(reshape([], sz));
		end
	end
	
	methods
		
		function this = uint16n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = uint16(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end
