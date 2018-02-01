classdef TimestampColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    % Conversion for SQL TIMESTAMP columns
    
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.TimestampColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.mdbc.colconv.TimestampColumnFetcher;
        end
    end
end
