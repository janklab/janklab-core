function [onlyA,onlyB,ixA,ixB] = symsetdiff(a, b)
%SYMSETDIFF Symmetric set difference
%
% [onlyA,onlyB,ixA,ixB,inBoth] = symsetdiff(a, b)
%
% Does a two-way "symmetric" setdiff indicating the values unique to each 
% side of a setdiff operation.
%
% Works on any a and b that support setdiff.
%
% Returns the elements unique to each set, along with their indexes.

[onlyA,ixA] = setdiff(a, b);
[onlyB,ixB] = setdiff(b, a);
end