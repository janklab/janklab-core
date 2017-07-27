function out = isWhole(x)
%ISWHOLE True if input is a whole (integer) number.

out = all(fix(x) == x);

end