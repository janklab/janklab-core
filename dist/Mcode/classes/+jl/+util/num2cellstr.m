function out = num2cellstr(x, format)
%NUM2CELLSTR Convert numbers to cellstr using NUM2STR formatting
%
% out = jl.util.num2cellstr(x, format)
%
% Converts the numbers x to strings, returning the results as a cellstr array the
% same size as x.

if nargin == 1
    strs = num2str(x(:));
else
    strs = num2str(x(:), format);
end

out = regexprep(cellstr(strs), ' +', '');
out = reshape(out, size(x));