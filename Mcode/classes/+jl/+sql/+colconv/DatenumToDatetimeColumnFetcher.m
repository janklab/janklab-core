classdef DatenumToDatetimeColumnFetcher < jl.sql.ColumnFetcher
    % Fetches doubles and converts to zoneless datetime
    %
    % This assumes that the underlying buffer is buffering datenum values as
    % doubles.
    
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData)
        datenums = columnBufferData(:);
        out = datetime(datenums, 'convertFrom','datenum');
        end
    end
    
end