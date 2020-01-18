function out = strlen(str)
%STRLEN Length of strings in char, cellstr, or string array
%
% out = strlen(str)
%
% Counts the length of each string in the input, as a number of characters.
%
% str may be a string array, cellstr, or char array.
%
% Char arrays are considered to be column vectors of strings, and trailing blanks are
% not counted.
%
% This is a convenience wrapper around jl.util.strings.strlen().
%
% Returns an array the same size as the string input array.

out = jl.util.strings.strlen(str);