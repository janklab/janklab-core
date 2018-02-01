classdef TimeColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    % Conversion for SQL TIME columns
    
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.SqlTimeToLocalTimenumColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.mdbc.colconv.TimenumToLocaltimeColumnFetcher;
        end
    end
end
