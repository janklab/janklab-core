function out = SQL_LIST(x)
%SQL_LIST Convert an array of values to SQL literal expressions
%
% out = SQL_LIST(x)
%
% Treats x as a list and converts it to a comma-separated list of SQL
% literal expressions, suitable for use in an 'IN (...)' clause. (The
% parentheses are not included.)
%
% This is a convenience function that uses SQL() on each of the values in X
% and joins them with commas.
%
% Returns char.
%
% See also:
% SQL

if ischar(x)
    x = cellstr(x);
end

if isempty(x)
    out = '';
    return
end

for i = numel(x):-1:1
    literals{i} = SQL(x(i));
end

out = strjoin(literals, ', ');