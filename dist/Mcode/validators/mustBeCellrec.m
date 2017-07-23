function mustBeCellrec(value, name)
%MUSTBECELLREC Validate that value is a cellrec or issue error
%
% MUSTBECELLREC(X) issues an error if X is not a cellrec. Calls iscellrec to
% determine if X is scalar.
%
% See also: cellrec, jl.types.tests.isCellrec, mustBeVector, mustBeNonEmpty


if nargin < 2; name = []; end
if jl.types.tests.isCellrec(value)
    return
end

valueName = firstNonEmpty(name, inputname(1));
if iscell(value)
    elementTypes = unique(cellfun(@class, value, 'UniformOutput',false));
    typeDescription = sprintf('cell containing %s', strjoin(elementTypes, ' and '));
else
    typeDescription = class(value);
end
reportBadValue(valueName, 'cellrec', typeDescription);

end
