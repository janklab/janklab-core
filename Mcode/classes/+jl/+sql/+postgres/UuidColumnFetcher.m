classdef UuidColumnFetcher < jl.sql.ColumnFetcher
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData) %#ok<INUSL>
        % Fetch column data.
        % 
        % Assumes the data has been buffered as Object[] on the Java side.
        jUUIDs = javaArray('java.util.UUID', numel(columnBufferData));
        for i = 1:numel(columnBufferData)
            jUUIDs(i) = columnBufferData(i);
        end
        out = jl.util.UUID(jUUIDs);
        end
    end
end