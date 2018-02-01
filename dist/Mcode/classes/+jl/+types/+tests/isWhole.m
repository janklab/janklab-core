function out = isWhole(x)
%ISWHOLE True if input is a whole (integer) number.

out = fix(x) == x;

end