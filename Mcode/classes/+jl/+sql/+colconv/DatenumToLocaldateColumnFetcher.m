classdef DatenumToLocaldateColumnFetcher < jl.sql.ColumnFetcher
    % A ColumnFetcher that retrieves doubles and converts to jl.time.localdate
    %
    % This assumes that the underlying buffer is buffering datenum values as
    % doubles.
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData)
        datenums = columnBufferData(:);
        out = jl.time.localdate(datenums);
        end
    end
    
end