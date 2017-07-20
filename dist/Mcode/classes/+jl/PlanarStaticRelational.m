classdef PlanarStaticRelational
	%PLANARSTATICRELATIONAL Relational operations boilerplate for a planar class
	
	
	% Developer's note: these only work for single-property classes
	
	methods
		
		function out = eq(a, b)
		%EQ Equality comparison
		
		%@@ one_planar
		out = eq(a.xxx, b.xxx);
		%@@ end
		end
		
		function out = ne(a, b)
		%NE Not equal
		
		%@@ one_planar
		out = ne(a.xxx, b.xxx);
		%@@ end
		end
		
		function out = lt(a, b)
		%LT Less than
		
		%@@ one_planar
		out = lt(a.xxx, b.xxx);
		%@@ end
		end
		
		function out = le(a, b)
		%LE Less than or equal
		
		%@@ one_planar
		out = le(a.xxx, b.xxx);
		%@@ end
		end
		
		function out = gt(a, b)
		%GT Greater than
		
		%@@ one_planar
		out = gt(a.xxx, b.xxx);
		%@@ end
		end
		
		function out = ge(a, b)
		%GE Greater than or equal
		
		%@@ one_planar
		out = ge(a.xxx, b.xxx);
		%@@ end
		end
		
	end
	
end