classdef uint64n < intn
	%UINT64N NaN-able unsigned 64-bit integer array
	%
	% See also:
	% INTN
	
	methods
		
		function this = uint64n(ints, tfnan)
			if nargin < 2 || isempty(tfnan)
				tfnan = isnan(ints);
			end
			ints = uint64(ints);
			this = this@intn(ints, tfnan);
		end
		
	end
	
end