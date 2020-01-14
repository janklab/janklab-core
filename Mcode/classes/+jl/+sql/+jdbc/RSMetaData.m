classdef RSMetaData < handle
    % ResultSetMetaData wrapper
    %
    % This is a Matlab wrapper for a JDBC ResultSetMetaData object
    
    properties
        jdbc
    end
    
    properties (Dependent = true)
        columnCount
    end
    
    methods
        function this = RSMetaData(jResultSetMetaData)
        mustBeA(jResultSetMetaData, 'java.sql.ResultSetMetaData');
        this.jdbc = jResultSetMetaData;
        end
        
        function out = getColumnMetaData(this, colIndex)
        %GETCOLUMNMETADATA Get metadata for a particular column
        out = jl.sql.jdbc.RSColumnMetaData(this, colIndex);
        end
        
        function out = columnLabels(this)
        %COLUMNLABELS Get the labels for all the columns
        %
        % Returns cellstr
        out = cell(1, this.columnCount);
        for i = 1:this.columnCount
            colMeta = this.getColumnMetaData(i);
            out{i} = colMeta.label;
        end
        end
        
        function out = get.columnCount(this)
        out = this.jdbc.getColumnCount();
        end
    end
    
end