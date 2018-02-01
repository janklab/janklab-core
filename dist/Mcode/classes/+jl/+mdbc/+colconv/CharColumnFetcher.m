classdef CharColumnFetcher
    % Fetches columns that were returned as java.lang.String[].
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData)
        out = string(columnBufferData);
        out = cellstr(out);
        out = out(:);
        end
    end
end