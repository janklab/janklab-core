function out = isSintType(x)
out = jl.types.tests.isaOneOf(x, {'int8','int16','int32','int64'});
end