function out = SQL(x)
%SQL Convert a value to SQL literal expression
%
% out = SQL(x)
%
% Converts the value x to a SQL literal or expression representing that
% value. This is useful for safely constructing queries that do not use
% placeholder values. The resulting expression will be properly quoted and
% escaped, to prevent SQL injection attacks or bugs.
%
% The resulting expressions may not be simply literals. For example, dates
% may be represented as 'DATE(...)' conversion functions.
%
% The input value X may be:
%   * numeric 
%   * char
%   * datetime
%
% Note that when numerics are converted, you may encounter decimal round-off 
% error, because they are converted to decimal literals. This function
% assumes that the database supports scientific notation in its numeric
% literals.
%
% Some values (such as NaN and Inf) may not work on all databases, due to
% SQL dialect differences.
%
% If X is a datetime, it is converted to an ANSI SQL DATE or
% TIMESTAMP literal, depending on whether it is at midnight, or has a
% nonzero time of day component. Time zones are not supported, and are
% ignored.
%
% Returns char.
%
% See also:
% SQL

% Cell pop-out. This is mostly for SQL_LIST's convenience
if iscell(x) && isscalar(x) && ischar(x{1})
    x = x{1};
end

if isnumeric(x)
    mustBeScalar(x);
    mustBeReal(x);
    % These NaNs and Infs are the Postgresql dialect
    if isnan(x)
        out = 'NaN';
    elseif isinf(x)
        if x > 0
            out = 'Infinity';
        else
            out = '-Infinity';
        end
    else
        % This is problematic because we're converting an approximate
        % numeric type to an exact DECIMAL SQL datatype. We'll just go with
        % about full precision here.
        out = num2str(x, 16);
    end
elseif ischar(x)
    mustBeSingleCharStr(x);
    if isempty(x)
        out = '''';
    else
        out = sprintf('''%s''', strrep(x, '''', ''''''));
    end
elseif isa(x, 'datetime')
    mustBeScalar(x);
    dt = x;
    if isnat(dt)
        error('jl:InvalidInput', 'NaT datetimes cannot be converted to SQL');
    end
    if isinf(dt)
        if dt > datetime(0, 'ConvertFrom', 'datetime')
            out = 'Infinity';
        else
            out = '-Infinity';
        end
        return
    end
    % We use ANSI date literals because they do not depend on the locale
    % settings of the db session, and are (hopefully) widely supported
    if dt == dateshift(dt, 'start', 'day')
        out = sprintf('DATE ''%04d-%02d-%02d''', year(dt), month(dt), day(dt));
    else
        % Not every database supports this much precision in their
        % TIMESTAMP types, but some (like Oracle) do, and it's how much
        % precision there is in the Matlab datetime type.
        nanos = floor(rem(second(dt), 1) * 1000000000);
        out = sprintf('TIMESTAMP ''%s.%09d''',...
            datestr(dt, 'yyyy-mm-dd HH:MM:SS'), nanos);
    end
else
    error('Unsupported input type: %s', class(x));
end