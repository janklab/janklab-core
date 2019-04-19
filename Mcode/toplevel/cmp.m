function out = cmp(a, b)
%CMP Compare for ordering
%
% This is basically the same as VALCMP and may be replaced by it. Or it may be
% changed to be a special extension of VALCMP with type-specific support for
% chars and cellstrs (since they don't implement < or > natively).
%
% Returns a double array the size of (the scalar expansion of) a and b.
% Each element will be -1, 0, or 1.
%
% See also: VALCMP

if isscalar(a)
	sz = size(b);
else
	sz = size(a);
end
out = NaN(sz);

out(a < b) = -1;
out(a > b) = 1;
out(eqnan(a, b)) = 0;

if any(isnan(out))
	error('jl:InvalidInput', 'None of LT, EQNAN, or GT returned true for some input elements (class %s and %s)',...
		class(a), class(b));
end

