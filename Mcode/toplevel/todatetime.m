function out = todatetime(x)
% Convert input to Matlab datetime array.
%
% out = todatetime(x)
%
% This is an alternative to Matlab's DATETIME function, with a signature
% and conversion logic that Janke likes better.
%
% This mainly exists because datetime's constructor signature does
% not accept datenums. It also does a couple date-format
% recognition hacks to work around try/catch logic in
% datetime's constructor that triggers "dbstop if all error"
% even on the happy path.
%
% Returns a datetime array whose size depends on the size and type of the
% input array.


% Common and easy short-circuits first.
if isdatetime(x)
    out = x;
    return
elseif isnumeric(x)
    out = datetime(x, 'ConvertFrom', 'datenum');
    return
end

% String handling next, with format recognition hacks.
if isstringy(x)
    % char rep of empty string is a weird special case.
    if ischar(x) && isempty(x)
        out = NaT;
        return
    end
    x = string(x);
    if isempty(x)
        out = repmat(datetime, size(x));
        return
    end
    % TODO: Format recognition hacks
    out = datetime(x);
    return
end

% Unusual input types.
if isa(x, 'java.time.ZonedDateTime')
    nanosOfSecond = x.getNano;
    fractionalSecs = double(nanosOfSecond) / (10^9);
    out = datetime(x.getYear, x.getMonthValue, x.getDayOfMonth, ...
        x.getHour, x.getMinute, x.getSecond + fractionalSecs);
    out.TimeZone = string(x.getZone.getId);
    return
end
% TODO: Add java.util.Date
% TODO: Add java.util.Calendar?
% TODO: Add java.util.LocalDateTime
% TODO: Add java.sql.Timestamp or whatever that special SQL extension type is
% TODO: Optimized Java type conversion using custom Java code?

% General case: delegate to datetime().
% TODO: Maybe this should also go in an `if isobject()` block higher up, as
% an optimization to avoid isa() calls for less-common types?
out = datetime(x);

end

