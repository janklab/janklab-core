function mustBeScalarString(x)
%MUSTBESCALARSTRING Validate that value is a single string as string
%
% mustBeScalarString(x)
%
% Errors if x is not a single string represented as a scalar string array.

mustBeA(x, 'string');
mustBeScalar(x);

