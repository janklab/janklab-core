function out = cellrec(x)
%CELLREC Convert to cellrec
%
% Converts the input value to a "cellrec". A cellrec is an n-by-2 cell
% array with names in the first column that represents a list of name/value
% pairs.

out = jl.datastruct.cellrec(x);
end