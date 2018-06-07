function out = isUintType(x)
out = jl.types.tests.isaOneOf(x, {'uint8','uint16','uint32','uint64'});
end
