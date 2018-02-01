classdef RawColumnFetcher < jl.mdbc.ColumnFetcher
    % A ColumnFetcher that does no conversion of the retrieved data
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData)
        out = columnBufferData;
        out = out(:);
        end
    end
    
end