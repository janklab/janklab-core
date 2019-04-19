function out = eqnan(a, b)
%EQNAN Equal, considering NaNs to be equal
%
% Elementwise equality test with equal NaNs.
% This is like EQ, but considers all NaNs to be equal.
%
% Works on any type for which == and isnan() are both defined.
%
% Will not work on cells.
%
% Returns a logical array the size of (the scalar expansion of) a and b.

if isscalar(a)
	if isnan(a)
	  out = isnan(b);
	else
		out = a == b;
	end
elseif isscalar(b)
	if isnan(b)
		out = isnan(a);
	else
		out = a == b;
	end
else
	out = a == b | (isnan(a) & isnan(b));
end
