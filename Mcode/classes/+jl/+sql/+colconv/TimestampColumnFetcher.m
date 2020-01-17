classdef TimestampColumnFetcher < jl.sql.ColumnFetcher
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData) %#ok<INUSL>
        % Fetch column data.
        datenums = columnBufferData.datenums;
        nanosOfDays = double(columnBufferData.nanosOfDays);
        nanosOfDays(isnan(datenums)) = NaN;
        date = jl.time.localdate(datenums);
        time = jl.time.localtime.ofNanosOfDay(double(nanosOfDays));
        out = jl.time.timestamp.ofDateAndTime(date, time);
        out = out(:);
        end
    end
    
end