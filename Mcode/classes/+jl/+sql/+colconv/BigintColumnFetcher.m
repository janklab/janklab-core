classdef BigintColumnFetcher < jl.sql.ColumnFetcher
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData) %#ok<INUSL>
        % Fetch column data.
        % 
        % Assumes the data has been buffered as long[] on the Java side.
        x = columnBufferData;
        if columnMetaData.isSigned
            out = x;
        else
            out = typecast(x, 'uint64');
        end
        end
    end
    
end