function out = isa2(value, type)
%ISA2 Type test with support for pseudotypes
%
% This is a convenience wrapper around jl.types.TypeSystem.isa2.
%
% See also:
% jl.types.TypeSystem.isa2

out = jl.types.TypeSystem.isa2(value, type);

end
