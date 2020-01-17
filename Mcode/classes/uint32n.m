classdef uint32n < intn
	%UINT32N NaN-able unsigned 32-bit integer array
	%
	% See also:
	% INTN
	
	methods
		
		function this = uint32n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = uint32(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end
