function mustBeMatrix(x, name)
%MUSTBEMATRIX Validate that value is a matrix or issue error
%
% MUSTBEMATRIX(X) issues an error if X is not a matrix. Calls ismatrix to
% determine if X is a matrix.

if nargin < 2; name = []; end
if ismatrix(x)
    return
end

valueName = firstNonEmpty(name, inputname(1));
reportBadValue(valueName, 'matrix', size2str(size(x)));

end