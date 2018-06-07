classdef TestDynPlanar < jl.DynamicPlanar
	
	properties
		x double = 0
	end
	
	methods
		function out = planarfields(obj) %#ok
			persistent flds
			if isempty(flds)
				flds = {'x'};
			end
			out = flds;
		end
			
	end
end