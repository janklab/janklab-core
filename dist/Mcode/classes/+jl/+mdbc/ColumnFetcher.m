classdef (Abstract) ColumnFetcher
   % Fetcher/converter for buffered Java ResultSet column data
    methods
        out = fetchColumn(this, columnBuffer, columnMetaData);
    end
end