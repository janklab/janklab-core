function out = eqnan(a, b)
%EQNAN Equality, based on cell contents, with equal NaNs
%
% a == b
%
% Compares cells for equality based on the equality of their corresponding
% cells, considering NaNs to be equal to each other. If either input is 
% not a cell, it is wrapped in a scalar cell before doing the comparison.
%
% This is just like CELL.EQ, except it uses ISEQUALN instead of
% plain ISEQUAL for its cell contents equality test.

if ~iscell(a)
	a = { a };
end
if ~iscell(b)
	b = { b };
end

[a, b] = scalarexpand(a, b);

out = logical(size(a));
for i = 1:numel(a)
	out(i) = isequaln(a{i}, b{i});
end
