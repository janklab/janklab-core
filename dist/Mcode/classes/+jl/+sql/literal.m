function out = literal(x)
%LITERAL Convert a value to an SQL literal

%TODO: Add support for my own date types, like localdate

if isnumeric(x)
    if ~isscalar(x)
        error('Numeric x must be scalar');
    end
    out = num2str(x);
elseif ischar(x)
    out = sprintf('''%s''', strrep(x, '''', ''''''));
elseif isa(x, 'datetime')
    out = sprintf('cast(''%s'' as datetime)', datestr(x, 'yyyy-mm-ddTHH:MM:SS'));
else
    error('jl:InvalidInput', 'Unsupported type for literal(): %s', class(x));
end