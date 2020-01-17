classdef uint16n < intn
	%UINT16N NaN-able unsigned 16-bit integer array
	%
	% See also:
	% INTN
	
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