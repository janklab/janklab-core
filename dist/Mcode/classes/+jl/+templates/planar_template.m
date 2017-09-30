classdef planar_template
%PLANAR_TEMPLATE Boilerplate for a "planar-organized" class
%
% This contains most of the methods needed to implement a planar-organized
% (as opposed to struct-organized) class that behaves like a normal Matlab
% array.

methods (Access = private)
	function out = planarfields(this) %#ok
	%PLANARFIELDS Lists the planar fields of this object, at this class level
		out = { 'a', 'b' };
	end
end

methods (Access = protected)
	
	function this = reshape(this, sz)
		for field = this.planarfields
			fld = field{1};
			this.(fld) = reshape(this.(fld), sz);
		end		
	end
end

end