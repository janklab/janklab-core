classdef DoubleColumnFetcher < jl.mdbc.ColumnFetcher
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData) %#ok<INUSD,INUSL>
        out = columnBufferData;
        out = out(:);
        end
    end
end