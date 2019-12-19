function mustBeScalarLogical(x)
%MUSTBESCALARLOGICAL Validate that value is a scalar logical
%
% mustBeScalarLogical(x)
%
% Errors if x is not a scalar logical value.

mustBeA(x, 'logical');
mustBeScalar(x);

