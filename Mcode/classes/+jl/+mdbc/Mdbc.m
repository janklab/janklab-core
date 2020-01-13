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
            jl.mdbc.internal.AppDataBackedColumnTypeConversionMap('Global', 'colTypeConversions');
        globalParamConversionSelector = ...
            jl.mdbc.internal.AppDataBackedParamConversionSelector('paramTypeConversions');
        traceLog = logger.Logger.getLogger('jl.mdbc.trace');
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
        jl.mdbc.Mdbc.registerDefaultColumnTypeConversions();
        jl.mdbc.Mdbc.registerDefaultParamConversions();
        jl.mdbc.Mdbc.registerDefaultDbmsFlavors();
        end
        
        function out = enableSqlTracing(newValue)
        %ENABLESQLTRACING Turn SQL tracing on or off
        if nargin == 0
            out = ismember(logger.Configurator.getEffectiveLevel('jl.mdbc.trace'), ...
                {'DEBUG','TRACE','ALL'});
        else
            if newValue
                logger.Configurator.setLevels({'jl.mdbc.trace','DEBUG'});
            else
                logger.Configurator.setLevels({'jl.mdbc.trace','INFO'});
            end
        end
        end
        
        function out = getColumnTypeConversion(conversionName)
        %GETCOLUMNTYPECONVERSION Get the column conversion strategy class for a named conversion
        out = jl.mdbc.Mdbc.globalColumnTypeConversionMap.lookupStrategy(conversionName);
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
        globalMap = jl.mdbc.Mdbc.globalColumnTypeConversionMap;
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
            'CHAR',             'jl.mdbc.colconv.CharColumnTypeConversion'
            'DOUBLE',           'jl.mdbc.colconv.DoubleColumnTypeConversion'
            'SINGLE',           'jl.mdbc.colconv.SingleColumnTypeConversion'
            'BIGINT',           'jl.mdbc.colconv.BigintColumnTypeConversion'
            'loud_bigdecimal',  'jl.mdbc.colconv.LoudBigDecimalToDoubleColumnTypeConversion'
            'loud_bigint',      'jl.mdbc.colconv.LoudBigintToDoubleColumnTypeConversion'
            'DATE',             'jl.mdbc.colconv.DateColumnTypeConversion'
            'TIME',             'jl.mdbc.colconv.TimeColumnTypeConversion'
            'TIMESTAMP',        'jl.mdbc.colconv.TimestampColumnTypeConversion'
            'BLOB',             'jl.mdbc.colconv.BlobColumnTypeConversion'
            'CLOB',             'jl.mdbc.colconv.ClobColumnTypeConversion'
            'NCLOB',            'jl.mdbc.colconv.NClobColumnTypeConversion'
            'BINARY',           'jl.mdbc.colconv.BinaryColumnTypeConversion'
            'BOOLEAN',          'jl.mdbc.colconv.BooleanColumnTypeConversion'
            'OBJECT',           'jl.mdbc.colconv.ObjectColumnTypeConversion'
            'symbol',           'jl.mdbc.colconv.SymbolColumnTypeConversion'
            });
        end
        
        function registerDefaultParamConversions()
        jl.mdbc.Mdbc.globalParamConversionSelector.registerByType({
            'double'    'jl.mdbc.paramconv.DoubleParamConversion'
            'string'    'jl.mdbc.paramconv.StringParamConversion'
            'symbol'    'jl.mdbc.paramconv.SymbolParamConversion'
            'jl.time.localdate' 'jl.mdbc.paramconv.LocalDateParamConversion'
            'jl.time.localtime' 'jl.mdbc.paramconv.LocalTimeParamConversion'
            'jl.time.timestamp' 'jl.mdbc.paramconv.TimestampParamConversion'
            });
        end
        
        function registerDefaultDbmsFlavors()
        jl.mdbc.DbmsFlavor.registerFlavor('postgresql', ...
            'jl.mdbc.postgres.PostgresDbmsFlavor');
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
        % Returns a jl.mdbc.Connection object, or throws an error if connection
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
        dbmsFlavor = jl.mdbc.DbmsFlavor.getFlavorHandler(dbmsFlavorName);
        jdbcConnection = java.sql.DriverManager.getConnection(jdbcUrl, jProps);
        jlConnection = net.janklab.mdbc.JLConnection(jdbcConnection, url, user);
        out = jl.mdbc.Connection(jlConnection, dbmsFlavor);
        out.dbmsFlavor.initializeConnection(out);
        te = toc(t0);
        
        jl.mdbc.Mdbc.traceLog.debugf('SQL CONNECT: %s (flavor %s) (in %0.3f s)', ...
            url, dbmsFlavorName, te);
        end
        
    end
    
end