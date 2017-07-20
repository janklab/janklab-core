function reportBadValue(valueName, expectedThing, actualThing)
if isempty(valueName)
    valueLabel = 'Value';
else
    valueLabel = sprintf('Value ''%s''', valueName);
end
error('jl:InvalidInput', '%s must be a %s, but got a %s.', valueLabel,...
    expectedThing, actualThing);
end