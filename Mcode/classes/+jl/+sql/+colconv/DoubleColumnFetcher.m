classdef DoubleColumnFetcher < jl.sql.ColumnFetcher
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData) %#ok<INUSD,INUSL>
        out = columnBufferData;
        out = out(:);
        end
    end
end