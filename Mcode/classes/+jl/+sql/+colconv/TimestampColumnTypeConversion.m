classdef TimestampColumnTypeConversion < jl.sql.ColumnTypeConversion
    % Conversion for SQL TIMESTAMP columns
    
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.TimestampColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.sql.colconv.TimestampColumnFetcher;
        end
    end
end
