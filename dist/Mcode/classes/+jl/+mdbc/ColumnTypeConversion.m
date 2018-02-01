classdef (Abstract) ColumnTypeConversion
    % Contains the logic for a column retrieval type conversion
    
    methods (Abstract)
        % Get a new Java column buffer implementing this conversion
        getColumnBuffer(this);
        % Get a new Matlab column fetcher implementing this conversion
        getColumnFetcher(this);
    end
    
end