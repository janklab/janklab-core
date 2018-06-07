function out = num2cellstr(x, format)
%NUM2CELLSTR Convert numbers to cellstr using NUM2STR formatting
%
% out = num2cellstr(x, format)
%
% Converts the numbers x to strings, returning the results as a cellstr array the
% same size as x.
%
% This is actually just a convenience wrapper around jl.util.num2cellstr,
% provided because this is such a common use case.
%
% See also: jl.util.num2cellstr

if nargin < 2;  format = [];  end

out = jl.util.num2cellstr(x, format);