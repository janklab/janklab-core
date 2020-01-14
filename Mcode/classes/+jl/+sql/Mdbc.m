classdef Mdbc
    % Central methods for MDBC
    %
    % This provides global settings, utilities, and factory methods for MDBC.
    %
    % TODO: Come up with better names for the two stages of column type
    % conversion mapping.
    %  1: Maps SQL types/col names/indexes/vendor types to conversion strategies
    %  2: Maps strategy names to Matlab implementation classes
    
    properties (Constant)
        globalColumnTypeConversionMap = ...
            jl.sql.internal.AppDataBackedColumnTypeConversionMap('Global', 'colTypeConversions');
        globalParamConversionSelector = ...
            jl.sql.internal.AppDataBackedParamConversionSelector('paramTypeConversions');
        traceLog = logger.Logger.getLogger('jl.sql.trace');
    end
    
    methods (Static)
        function initMdbc()
        %INITMDBC Initialize MDBC
        %
        % This method is called by init_janklab. There is no reason for user
        % code to call it.
        s = getappdata(0, 'JanklabState');
        s.mdbc = struct;
        setappdata(0, 'JanklabState', s);
        jl.sql.Mdbc.registerDefaultColumnTypeConversions();
        jl.sql.Mdbc.registerDefaultParamConversions();
        jl.sql.Mdbc.registerDefaultDbmsFlavors();
        end
        
        function out = enableSqlTracing(newValue)
        %ENABLESQLTRACING Turn SQL tracing on or off
        if nargin == 0
            out = ismember(logger.Configurator.getEffectiveLevel('jl.sql.trace'), ...
                {'DEBUG','TRACE','ALL'});
        else
            if newValue
                logger.Configurator.setLevels({'jl.sql.trace','DEBUG'});
            else
                logger.Configurator.setLevels({'jl.sql.trace','INFO'});
            end
        end
        end
        
        function out = getColumnTypeConversion(conversionName)
        %GETCOLUMNTYPECONVERSION Get the column conversion strategy class for a named conversion
        out = jl.sql.Mdbc.globalColumnTypeConversionMap.lookupStrategy(conversionName);
        end
        
        function registerDefaultColumnTypeConversions()
        %REGISTERDEFAULTCOLUMNTYPECONVERSIONS Registers the default conversions.
        %
        % This should be called once during Janklab/MDBC initialization.
        
        % Register the column type -> type conversion mappings
        % The defaults map all numeric columns to Matlab double, since double is
        % the main native type to Matlab. This is lossy.
        % TODO: Provide a useIntTypes() to enable exact/efficient conversions.
        % TODO: Warn on overflow/rounding errors. Prob needs a new buffer type.
        globalMap = jl.sql.Mdbc.globalColumnTypeConversionMap;
        globalMap.registerForSqlTypes({
            'REAL', 'SINGLE'
            'FLOAT', 'DOUBLE'
            'DOUBLE', 'DOUBLE'
            
            'TINYINT', 'DOUBLE'
            'SMALLINT', 'DOUBLE'
            'INTEGER', 'DOUBLE'
            'BIGINT', 'loud_bigint'
            
            'NUMERIC', 'DOUBLE'
            'DECIMAL', 'loud_bigdecimal'
            
            'CHAR', 'CHAR'
            'NCHAR', 'CHAR'
            'VARCHAR', 'CHAR'
            'NVARCHAR', 'CHAR'
            'LONGVARCHAR', 'CHAR'
            'LONGNVARCHAR', 'CHAR'
            'SQLXML', 'CHAR'
            
            'DATE', 'DATE'
            'TIME', 'TIME'
            'TIME_WITH_TIMEZONE', 'TIME'
            'TIMESTAMP', 'TIMESTAMP'
            'TIMESTAMP_WITH_TIMEZONE', 'TIMESTAMP'
            
            'BLOB', 'BLOB'
            'CLOB', 'CLOB'
            'NCLOB', 'NCLOB'
            
            'BINARY', 'BINARY'
            'VARBINARY', 'BINARY'
            'BIT', 'CHAR'
            'BOOLEAN', 'BOOLEAN'
            
            'JAVA_OBJECT', 'OBJECT'
            'OTHER', 'OBJECT'
            'REF', 'OBJECT'
            'REF_CURSOR', 'OBJECT'
            'ROWID', 'OBJECT'
            'STRUCT', 'OBJECT'
            'DISTINCT', 'CHAR'
            });
        
        % Register the conversions themselves
        globalMap.registerStrategies({
            'CHAR',             'jl.sql.colconv.CharColumnTypeConversion'
            'DOUBLE',           'jl.sql.colconv.DoubleColumnTypeConversion'
            'SINGLE',           'jl.sql.colconv.SingleColumnTypeConversion'
            'BIGINT',           'jl.sql.colconv.BigintColumnTypeConversion'
            'loud_bigdecimal',  'jl.sql.colconv.LoudBigDecimalToDoubleColumnTypeConversion'
            'loud_bigint',      'jl.sql.colconv.LoudBigintToDoubleColumnTypeConversion'
            'DATE',             'jl.sql.colconv.DateColumnTypeConversion'
            'TIME',             'jl.sql.colconv.TimeColumnTypeConversion'
            'TIMESTAMP',        'jl.sql.colconv.TimestampColumnTypeConversion'
            'BLOB',             'jl.sql.colconv.BlobColumnTypeConversion'
            'CLOB',             'jl.sql.colconv.ClobColumnTypeConversion'
            'NCLOB',            'jl.sql.colconv.NClobColumnTypeConversion'
            'BINARY',           'jl.sql.colconv.BinaryColumnTypeConversion'
            'BOOLEAN',          'jl.sql.colconv.BooleanColumnTypeConversion'
            'OBJECT',           'jl.sql.colconv.ObjectColumnTypeConversion'
            'symbol',           'jl.sql.colconv.SymbolColumnTypeConversion'
            });
        end
        
        function registerDefaultParamConversions()
        jl.sql.Mdbc.globalParamConversionSelector.registerByType({
            'double'    'jl.sql.paramconv.DoubleParamConversion'
            'string'    'jl.sql.paramconv.StringParamConversion'
            'symbol'    'jl.sql.paramconv.SymbolParamConversion'
            'jl.time.localdate' 'jl.sql.paramconv.LocalDateParamConversion'
            'jl.time.localtime' 'jl.sql.paramconv.LocalTimeParamConversion'
            'jl.time.timestamp' 'jl.sql.paramconv.TimestampParamConversion'
            });
        end
        
        function registerDefaultDbmsFlavors()
        jl.sql.DbmsFlavor.registerFlavor('postgresql', ...
            'jl.sql.postgres.PostgresDbmsFlavor');
        end
        
        function out = connectFromJdbcUrl(url, user, password, properties)
        %CONNECTFROMJDBCURL Connect to a database using a JDBC URL specification
        %
        % out = connectFromJdbcUrl(url, user, password, properties)
        %
        % This is a low-level method for connecting to an arbitrary database
        % using MDBC. All inputs are required.
        %
        % Url (char) is the JDBC URL to connect to, without the leading 'jdbc:'
        % included.
        %
        % User is the username to log in with.
        %
        % Password is the password to log in with.
        %
        % Properties (struct, optional) is a set of arbitrary connection
        % properties. All the values in it must be char strings.
        %
        % Returns a jl.sql.Connection object, or throws an error if connection
        % fails.
        
        if nargin < 4 || isempty(properties);  properties = struct;  end
        
        dbmsFlavorName = regexprep(url, ':.*', '');
        jdbcUrl = ['jdbc:' url];
        jProps = java.util.Properties;
        fields = fieldnames(properties);
        for i = 1:numel(fields)
            jProps.setProperty(fields{i}, properties.(fields{i}));
        end
        jProps.setProperty('user', user);
        jProps.setProperty('password', password);
        
        t0 = tic;
        dbmsFlavor = jl.sql.DbmsFlavor.getFlavorHandler(dbmsFlavorName);
        jdbcConnection = java.sql.DriverManager.getConnection(jdbcUrl, jProps);
        jlConnection = net.janklab.mdbc.JLConnection(jdbcConnection, url, user);
        out = jl.sql.Connection(jlConnection, dbmsFlavor);
        out.dbmsFlavor.initializeConnection(out);
        te = toc(t0);
        
        jl.sql.Mdbc.traceLog.debugj('SQL CONNECT: %s (flavor %s) (in %0.3f s)', ...
            url, dbmsFlavorName, te);
        end
        
    end
    
end