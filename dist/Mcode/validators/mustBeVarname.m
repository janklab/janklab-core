function mustBeVarname(x, name)
%MUSTBEVARNAME Validate that value is a valid Matlab variable name
%
% MUSTBEVARNAME(X) issues an error if X is not a valid Matlab variable name, as
% determined by isvarname(X). This implies that X must be char, as well.

if nargin < 2; name = []; end

if isvarname(x)
    return
end

valueName = firstNonEmpty(name, inputname(1));
if isempty(valueName)
    valueLabel = 'Value';
else
    valueLabel = sprintf('Value ''%s''', valueName);
end
if ischar(x)
    error('jl:InvalidInput', '%s must be a valid variablename, but got ''%s''', ...
        valueLabel, x);
else
    error('jl:InvalidInput', '%s must be a valid variablename', valueLabel);
end

end