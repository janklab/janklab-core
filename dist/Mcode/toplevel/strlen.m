function out = strlen(str)
%STRLEN Length of strings in char, cellstr, or string array
%
% Counts the length of each string in the input, as a number of characters.
%
% Char arrays are considered to be column vectors of strings, and trailing blanks are
% not counted.
%
% Returns an array the same size as the string input array.

if isa(str, 'string')
	out = strlength(str);
else
	if ischar(str)
		str = cellstr(str);
	end
	if ~iscellstr(str)
		error('str must be char, cellstr, or string; got %s', class(str));
	end
	out = cellfun('prodofsize', str);
end
	