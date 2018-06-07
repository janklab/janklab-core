classdef DateColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    % Conversion for SQL DATE columns
    
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.SqlDateToLocaldatenumColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.mdbc.colconv.DatenumToLocaldateColumnFetcher;
        end
    end
end
