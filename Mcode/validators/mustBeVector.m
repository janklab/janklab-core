function mustBeVector(x, name)
%MUSTBEVECTOR Validate that value is a vector or issue error
%
% MUSTBEVECTOR(X) issues an error if X is not a vector. Calls isvector to
% determine if X is a vector.
%
% See also: mustBeScalar, mustBeNonEmpty

if nargin < 2; name = []; end
if isvector(x)
    return
end

valueName = firstNonEmpty(name, inputname(1));
reportBadValue(valueName, 'vector', size2str(size(x)));

end