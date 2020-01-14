classdef RSColumnMetaData < handle
    
    properties
        % The RSMetaData for the ResultSet
        rsmd
        % The JDBC ResultSetMetaData for the ResultSet
        jrsmd
        % The column index this provides metadata for, 1-indexed
        ix
    end
    
    properties (Dependent)
        catalogName
        className
        displaySize
        label
        name
        % Generic SQL data type, as net.janklab.mdbc.SqlType
        sqlType
        dbmsTypeName
        precision
        scale
        schemaName
        tableName
        isAutoIncrement
        isCaseSensitive
        isCurrency
        isDefinitelyWritable
        isReadOnly
        isSearchable
        isSigned
        isWritable
        % Nullability as string
        nullability
    end
    
    methods
        function this = RSColumnMetaData(resultSetMetaData, columnIndex)
        % Construct new RSColumnMetaData
        this.rsmd = resultSetMetaData;
        this.jrsmd = this.rsmd.jdbc;
        this.ix = columnIndex;
        end
        
        function disp(this)
        % Custom display
        disp(dispstr(this));
        end
        
        function out = dispstr(this)
        % Custom display string
        if ~isscalar(this)
            out = sprintf('%s %s', sizestr(this), class(this));
            return;
        end
        out = sprintf('Col %d: "%s": %s (%d,%d) %s', ...
            this.ix, this.label, this.sqlType, this.precision, this.scale, ...
            this.nullability);
        end
        
        function out = get.catalogName(this)
        out = char(this.jrsmd.getCatalogName(this.ix));
        end
        
        function out = get.className(this)
        out = char(this.jrsmd.getColumnClassName(this.ix));
        end
        
        function out = get.displaySize(this)
        out = this.jrsmd.getColumnDisplaySize(this.ix);
        end
        
        function out = get.label(this)
        out = char(this.jrsmd.getColumnLabel(this.ix));
        end
        
        function out = get.name(this)
        out = char(this.jrsmd.getColumnName(this.ix));
        end
        
        function out = get.sqlType(this)
        typeCode = this.jrsmd.getColumnType(this.ix);
        out = net.janklab.mdbc.SqlType.fromTypesConstant(typeCode);
        end
        
        function out = get.dbmsTypeName(this)
        out = char(this.jrsmd.getColumnTypeName(this.ix));
        end
        
        function out = get.precision(this)
        out = this.jrsmd.getPrecision(this.ix);
        end
        
        function out = get.scale(this)
        out = this.jrsmd.getScale(this.ix);
        end
        
        function out = get.schemaName(this)
        out = char(this.jrsmd.getSchemaName(this.ix));
        end
        
        function out = get.tableName(this)
        out = char(this.jrsmd.getTableName(this.ix));
        end
        
        function out = get.isAutoIncrement(this)
        out = this.jrsmd.isAutoIncrement(this.ix);
        end
        
        function out = get.isCaseSensitive(this)
        out = this.jrsmd.isCaseSensitive(this.ix);
        end
        
        function out = get.isCurrency(this)
        out = this.jrsmd.isCurrency(this.ix);
        end
        
        function out = get.isDefinitelyWritable(this)
        out = this.jrsmd.isDefinitelyWritable(this.ix);
        end
        
        function out = get.isReadOnly(this)
        out = this.jrsmd.isReadOnly(this.ix);
        end
        
        function out = get.isSearchable(this)
        out = this.jrsmd.isSearchable(this.ix);
        end
        
        function out = get.isSigned(this)
        out = this.jrsmd.isSigned(this.ix);
        end
        
        function out = get.isWritable(this)
        out = this.jrsmd.isWritable(this.ix);
        end
        
        function out = get.nullability(this)
        jVal = this.jrsmd.isNullable(this.ix);
        switch jVal
            case java.sql.ResultSetMetaData.columnNoNulls
                out = 'NOT NULL';
            case java.sql.ResultSetMetaData.columnNullable
                out = 'NULL';
            case java.sql.ResultSetMetaData.columnNullableUnknown
                out = 'NULL?';
            otherwise
                out = sprintf('<invalid Nullability value: %d>', jVal);
        end
        end
        
    end
    
end