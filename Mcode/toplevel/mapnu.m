function varargout = mapnu(func, varargin)
%MAP Apply a function to each element in an array, with non-uniform output
%
% Applies a function to each of the elements in the inputs, using cellfun, objfun,
% structfun, or arrayfun as appropriate.
%
% * If input is cell, uses cellfun
% * If input is object, uses objfun
% * If input is struct, uses structfun
% * Otherwise, uses arrayfun
%
% Only the first input after func is checked for type. If you pass in mixed
% types, you will probably get an error.
%
% This is a more concise, polymorphic way of writing 
% "cellfun(..., 'UniformOutput',false)", etc. 
%
% The struct variant returns its output as a struct instead of a cell, and
% supports nonscalar structs as inputs, unlike structfun.
%
% See also:
% MAPNU

narginchk(2, Inf);
varargout = cell([1, nargout]);

x = varargin{1};
if iscell(x)
    [varargout{:}] = cellfun(func, varargin{:}, 'UniformOutput',false);
elseif isobject(x)
    [varargout{:}] = objfun(func, varargin{:}, 'UniformOutput',false);
elseif isstruct(x)
    if nargin > 2
        error('Invalid number of inputs: the struct variant of map only takes a single value');
    end
    s = x;
    out = s;
    for i = 1:numel(s)
        out(i) = structfun(func, s(i), 'UniformOutput',false);
    end
    varargout{1} = out;
else
    [varargout{:}] = arrayfun(func, varargin{:}, 'UniformOutput',false);
end

end