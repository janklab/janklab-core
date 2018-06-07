function mustBeScalar(x, name)
%MUSTBESCALAR Validate that value is scalar or issue error
%
% MUSTBESCALAR(X) issues an error if X is nonscalar. Calls isscalar to
% determine if X is scalar.
%
% See also: mustBeVector, mustBeNonEmpty

if nargin < 2; name = []; end

if isscalar(x)
    return
end

valueName = firstNonEmpty(name, inputname(1));
reportBadValue(valueName, 'scalar', size2str(size(x)));

end