classdef TimeColumnTypeConversion < jl.sql.ColumnTypeConversion
    % Conversion for SQL TIME columns
    
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.SqlTimeToLocalTimenumColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.sql.colconv.TimenumToLocaltimeColumnFetcher;
        end
    end
end
