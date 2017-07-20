function out = isIntType(x)
intTypes = {'int8','int16','int32','int64','uint8','uint16','uint32','uint64'};
% Must use isa() instead of ismember(class(x),...) because primitives
% can now be subclassed.
out = jl.types.tests.isaOneOf(x, intTypes);
end
