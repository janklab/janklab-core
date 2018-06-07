function out = qw(str)
% Split a string on whitespace
%
% strs = qw(str)
%
% Splits the input string str on whitespace and returns the split tokens as a
% cellstr.
%
% The name "qw" is inspired by Perl's "qw/.../" quoting form, which stands for "quote
% words". The qw() function is a way of concisely producing cellstrs from literals in
% code, without having to type out all the quotes.
%
% Examples:
%
% w = qw('foo bar baz qux')

out = regexp(str, '\s+', 'split');

end