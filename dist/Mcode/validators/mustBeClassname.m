function mustBeClassname(x, name)
%MUSTBECLASSNAME Validate that value is a valid Matlab class name
%
% MUSTBECLASSNAME(X) issues an error if X is not a valid Matlab class name. The
% name may be package-qualified.

if nargin < 2; name = []; end

if ischar(x) && isscalar(x) && ismember(x, ['A':'Z' 'a':'z'])
    return;
end
if regexp(x, '[A-Za-z][A-Za-z.]*[A-Za-z]')
    return;
end

valueName = firstNonEmpty(name, inputname(1));
if isempty(valueName)
    valueLabel = 'Value';
else
    valueLabel = sprintf('Value ''%s''', valueName);
end
if ischar(x)
    error('jl:InvalidInput', '%s must be a valid class name, but got ''%s''', ...
        valueLabel, x);
else
    error('jl:InvalidInput', '%s must be a valid class name', valueLabel);
end

end