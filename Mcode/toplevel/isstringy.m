function out = isstringy(x)
%ISSTRINGY True if input is char, string, or cellstr
out = ischar(x) || isstring(x) || iscellstr(x);
end