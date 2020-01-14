classdef BinaryColumnFetcher < jl.sql.ColumnFetcher
    % Fetches column data that's stored as arrays of byte[]
    %
    % Converts the bytes to uint8 on the Matlab side.
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData) %#ok<INUSL>
        % Fetch column data.
        out = cell(size(columnBufferData));
        for i = 1:numel(out)
            out{i} = uint8(columnBufferData(i));
        end
        end
    end
end