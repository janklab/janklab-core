function out = cmp(a, b)
%CMP Compare for ordering
%
% This is basically the same as VALCMP and may be replaced by it.

if isscalar(a)
	sz = size(b);
else
	sz = size(a);
end
out = NaN(sz);

out(a < b) = -1;
out(a > b) = 1;
out(a == b) = 0;