function varargout = map(func, varargin)
%MAP Apply a function to each element in an array, cell array, or struct
%
% Applies a function to each elements in the input, using cellfun, objfun,
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
% This is a more concise, polymorphic way of writing "cellfun(...)", etc. It's
% mainly here for completeness, though; I expect MAPNU to be more commonly used.
%
% See also:
% MAPNU

narginchk(2, Inf);
varargout = cell([1, nargout]);

x = varargin{1};
if iscell(x)
    [varargout{:}] = cellfun(func, varargin{:});
elseif isobject(x)
    [varargout{:}] = objfun(func, varargin{:});
elseif isstruct(x)
    if nargin > 2
        error('Invalid number of inputs: the struct variant of map only takes a single value');
    end
    [varargout{:}] = structfun(func, x);
else
    [varargout{:}] = arrayfun(func, varargin{:});
end

end