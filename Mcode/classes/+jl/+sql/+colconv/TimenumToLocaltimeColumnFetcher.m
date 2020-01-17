classdef TimenumToLocaltimeColumnFetcher < jl.sql.ColumnFetcher
    % Retrieves micros-of-day and converts to jl.time.localtime
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData)
        microsOfDay = columnBufferData(:);
        nanosOfDay = microsOfDay * 10^3;
        out = jl.time.localtime.ofNanosOfDay(nanosOfDay);
        end
    end
end