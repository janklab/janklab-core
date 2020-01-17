classdef DateColumnTypeConversion < jl.sql.ColumnTypeConversion
    % Conversion for SQL DATE columns
    
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.SqlDateToLocaldatenumColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.sql.colconv.DatenumToLocaldateColumnFetcher;
        end
    end
end
