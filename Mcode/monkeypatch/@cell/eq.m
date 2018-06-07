function out = eq(a, b)
%EQ Equality, based on cell contents
%
% a == b
%
% Compares cells for equality based on the equality of their corresponding
% cells. If either input is not a cell, it is wrapped in a scalar cell
% before doing the comparison.
%
% Yes, Janklab duck-punches new '==' semantics in to the builtin @cell
% type. This is primarily a convenience so you can do '==' on cellstrs, or
% use them with polymorphic code that depends on `==`.

if ~iscell(a)
	a = { a };
end
if ~iscell(b)
	b = { b };
end

[a, b] = scalarexpand(a, b);

out = logical(size(a));
for i = 1:numel(a)
	out(i) = isequal(a{i}, b{i});
end
