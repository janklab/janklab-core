function mustBeCellstr(value, name)
%MUSTBECELLSTR Validate that value is a cellstr or issue error
%
% MUSTBECELLSTR(X) issues an error if X is not a cellstr. Calls iscellstr to
% determine if X is scalar.
%
% See also: mustBeVector, mustBeNonEmpty

% Dev note: this is a copy-and-paste from mustBeA's cellstr special
% case. Could probably refactor. Avoiding it for now because I'm concerned
% about method call overhead. Probably spuriously, but still.

if nargin < 2; name = []; end
if iscellstr(value)
    return
end

valueName = firstNonEmpty(name, inputname(1));
if iscell(value)
    elementTypes = unique(cellfun(@class, value, 'UniformOutput',false));
    typeDescription = sprintf('cell containing %s', strjoin(elementTypes, ' and '));
else
    typeDescription = class(value);
end
reportBadValue(valueName, 'cellstr', typeDescription);

end
