classdef Connection < handle
    % A connection to a database
    
    % Dev note: A Connection object "owns" the underlying jlConn and jdbConn
    % objects. It will close them upon cleanup, and they cannot be shared with
    % other objects.
    
    properties
        % The underlying janklab-java MDBC JLConnection object
        jlConn
        % The connection's column type conversion map
        columnTypeConversionMap
        % The connections param conversion selector, chained to the global one
        paramConversionSelector
        % The DBMS flavor handler, for DBMS-specific behavior
        dbmsFlavor jl.mdbc.DbmsFlavor
    end
    properties (Access = protected)
        % Logger for SQL tracing
        traceLog = logger.Logger.getLogger('jl.mdbc.trace');
    end
    properties (Dependent)
        jdbcConn              % The underlying JDBC Connection object
        TransactionIsolation  % This' transaction isolation level, as string
        user                  % The username for this connection
        baseUrl               % The base JDBC URL for this connection
    end
    
    
    methods
        
        function this = Connection(jlConn, dbmsFlavor)
        % Create a new Connection, taking ownership of the underlying connection
        if nargin == 0
            % NOP
            return
        end
        % Database Toolbox license check
        [status,errmsg] = license('checkout','database_toolbox');
        if ~status
            error('jl:licensing:NoLicense', ['MDBC requires the Matlab ' ...
                'Database Toolbox.\n\n%s'], errmsg);
        end
        % Real constructor logic
        this.jlConn = jlConn;
        this.dbmsFlavor = dbmsFlavor;
        this.columnTypeConversionMap = jl.mdbc.ColumnTypeConversionMap(...
            "Connection", jl.mdbc.Mdbc.globalColumnTypeConversionMap);
        this.paramConversionSelector = jl.mdbc.ParamConversionSelector(...
            jl.mdbc.Mdbc.globalParamConversionSelector);
        end
        
        function delete(this)
        % Destructor: cleans up underlying database connection
        close(this);
        end
        
        function close(this)
        %CLOSE Close the connection
        for i = 1:numel(this)
            if ~isempty(this(i).jlConn)
                if ~this(i).jdbcConn.isClosed()
                    try
                        t0 = tic;
                        this(i).jdbcConn.close();
                        te = toc(t0);
                        this.traceLog.debug('SQL CLOSE: %s (in %0.3f s)', ...
                            this.jlConn.baseUrl, te);
                    catch err
                        % quash
                        this.traceLog.warning('SQL CLOSE failed on connection %s: %s', ...
                            this.baseUrl, err.message);
                    end
                end
            end
        end
        end
        
        function disp(this)
        %DISP  Custom display
        disp(dispstr(this));
        end
        
        function out = dispstr(this)
        %DISPSTR Custom display string
        if ~isscalar(this)
            out = sprintf('%s %s', sizestr(this), class(this));
            return;
        end
        if isempty(this.jdbcConn)
            out = '<no connection>';
            return
        end
        
        % General case
        jc = this.jdbcConn;
        str = 'Connection:';
        str = sprintf('%s %s@%s (%s)', str, this.user, this.baseUrl, ...
            this.dbmsFlavor.flavorName);
        
        items = {};
        
        if jc.getAutoCommit()
            % NOP - this is the default for Matlab, so omit it
        else
            items{end+1} = 'AutoCommit=OFF';
        end
        schema = char(jc.getSchema);
        if ~isempty(schema)
            items{end+1} = ['Schema=' schema];
        end
        catalog = char(jc.getCatalog);
        if ~isempty(catalog)
            items{end+1} = ['Catalog=' catalog];
        end
        items{end+1} = ['TransactionIsolation=' this.TransactionIsolation];
        if jc.isReadOnly()
            items{end+1} = 'READONLY';
        end
        if jc.isClosed()
            items{end+1} = 'CLOSED';
        end
        
        if ~isempty(items)
            str = [str ' (' strjoin(items, ' ') ')'];
        end
        
        out = str;
        end
        
        function out = get.jdbcConn(this)
        % Get the jdbcConn
        out = this.jlConn.jdbcConn;
        end
        
        function out = get.user(this)
        % Get the user
        out = char(this.jlConn.user);
        end
        
        function out = get.baseUrl(this)
        % Get the baseUrl
        out = char(this.jlConn.baseUrl);
        end
        
        function out = get.TransactionIsolation(this)
        % Get the TransactionIsolation
        jCode = this.jdbcConn.getTransactionIsolation();
        switch jCode
            case java.sql.Connection.TRANSACTION_NONE
                out = 'NONE';
            case java.sql.Connection.TRANSACTION_READ_COMMITTED
                out = 'READ_COMMITTED';
            case java.sql.Connection.TRANSACTION_READ_UNCOMMITTED
                out = 'READ_UNCOMMITTED';
            case java.sql.Connection.TRANSACTION_REPEATABLE_READ
                out = 'REPEATABLE_READ';
            case java.sql.Connection.TRANSACTION_SERIALIZABLE
                out = 'SERIALIZABLE';
            otherwise
                out = sprintf('UNKNOWN (%d)', jCode);
        end
        end
        
        function set.TransactionIsolation(this, val)
        % Set the TransactionIsolation
        switch val
            case 'NONE'
                this.jdbcConn.setTransactionIsolation(...
                    java.sql.Connection.TRANSACTION_NONE);
            case 'READ_COMMITTED'
                this.jdbcConn.setTransactionIsolation(...
                    java.sql.Connection.READ_COMMITTED);
            case 'READ_UNCOMMITTED'
                this.jdbcConn.setTransactionIsolation(...
                    java.sql.Connection.READ_UNCOMMITTED);
            case 'REPEATABLE_READ'
                this.jdbcConn.setTransactionIsolation(...
                    java.sql.Connection.REPEATABLE_READ);
            case 'SERIALIZABLE'
                this.jdbcConn.setTransactionIsolation(...
                    java.sql.Connection.SERIALIZABLE);
            otherwise
                error('Invalid TransactionIsolation value: %s', val);
        end
        end
        
        function out = ping(this, timeout)
        %PING Check whether this connection is open and valid
        %
        % status = obj.ping(timeout)
        %
        % Timeout (double, optional) is the number of seconds to wait for a
        % response. Defaults to waiting forever.
        %
        % Returns logical indicating whether the connection is valid.
        if nargin < 2 || isempty(timeout);  timeout = 0; end
        if isnan(timeout) || isinf(timeout)
            timeout = 0; % JDBC uses 0 for "wait forever"
        end
        % Raise an error here instead of passing it on to the JDBC object,
        % because calling isValid() with a bad timeout parameter can actually
        % cause the connection to be closed (e.g. with MySql).
        if timeout < 0
            error('jl:InvalidInput', 'Invalid timeout value: %d. Value must be >= 0.', timeout);
        end
        t0 = tic;
        out = this.jdbcConn.isValid(timeout);
        te = toc(t0);
        this.traceLog.debug('SQL PING: %s (%0.3f s)', this.jlConn.baseUrl, te);
        end
        
        function out = prepareStatement(this, sql)
        % Prepare a statement for execution
        %
        % out = prepareStatement(obj, sql);
        %
        % Prepares a statement for future execution, possibly using placeholder
        % parameters.
        %
        % Returns a jl.mdbc.PreparedStatement
        jdbcPreparedStatement = this.jdbcConn.prepareStatement(sql);
        out = jl.mdbc.PreparedStatement(this, sql, jdbcPreparedStatement);
        end
        
        function out = createStatement(this, sql)
        % Create a statement that does not use placeholders
        %
        % You will generally not need to use this; it's provided just for
        % completeness. Use exec() instead.
        jdbcStatement = this.jdbcConn.createStatement();
        out = jl.mdbc.Statement(this, sql, jdbcStatement);
        end
        
        function out = exec(this, sql, params, options)
        %EXEC Execute a statement and return its results
        %
        % out = exec(obj, sql, params, options)
        %
        % Sql (char) is the SQL statement to execute.
        %
        % Params (cell) is the list of values to bind to placeholder parameters
        % in sql. If your statement does not have placeholder parameters, you
        % may omit params by omitting the argument or passing [].
        %
        % Options is a set of options that controls the behavior of this
        % statement execution. Available options:
        %   AllStringsAsSymbols - All character data will be retrieved as
        %     symbols instead of strings. Useful for efficiently retrieving
        %     low-cardinality string data.
        %
        % Returns a jl.mdbc.Results object.
        narginchk(2, 4);
        if nargin < 3 || isempty(params);    params = [];  end
        if nargin < 4 || isempty(options);   options = []; end
        options = jl.util.parseOpts(options, {
            'AllStringsAsSymbols'   false
            });
        
        if isempty(params)
            stmt = this.createStatement(sql);
        else
            stmt = this.prepareStatement(sql);
        end
        if options.AllStringsAsSymbols
            stmt.columnTypeConversionMap.useAllStringsAsSymbols();
        end
        if isempty(params)
            out = stmt.exec();
        else
            out = stmt.exec(params);
        end
        end
        
        function out = query(this, sql, params, options)
        % QUERY Run a query that returns a single result set
        end
        
        function out = insert(this, table, data, options)
        %INSERT Insert data into a table
        %
        % out = insert(this, table, data, options)
        %
        % Inserts data from a Matlab object to a named table on the server.
        %
        % Table (char) is the name of the SQL table to insert to. It may be
        % qualified by database and schema if the database driver supports it.
        %
        % Data (relation,table) is the set of data to be inserted to table. The
        % column/variable names in data must match columns in the target table.
        %
        % Options:
        %   * QuoteColumnNames (logical) - enables
        %
        % Returns a jl.mdbc.BatchUpdateResults object, or may throw an error if
        % one or more of the updates failed.
        
        if nargin < 4 || isempty(options); options = [];  end
        options = jl.util.parseOpts(options, {'QuoteColumnNames',false});
        
        % Check inputes
        if isa(data, 'table')
            data = relation(data);
        end
        mustBeA(data, 'relation');
        mustBeA(table, 'char');
        mustBeValidSqlTableName(table);
        % Can we do some validation of the column names to prevent SQL injection
        % issues here?
        
        % Insert
        t0 = tic;
        colNames = colnames(data);
        nCols = numel(colNames);
        % Using quoted column names can make the logic stricter and cause
        % breakage with PostgreSQL. Let's leave it off by default
        if options.QuoteColumnNames
            colNames = sprintfv('"%s"', colNames);
        end
        sql = sprintf('INSERT INTO %s (%s) VALUES (%s)', ...
            table, strjoin(colNames, ', '),...
            strjoin(repmat({'?'}, [1 nCols]), ', '));
        params = coldata(data);
        
        stmt = this.prepareStatement(sql);
        out = stmt.executeBatch(params, {'DoLogging',false});
        te = toc(t0);
        
        this.traceLog.debugj('SQL: INSERT\n%s\n%s', ...
            sprintf('  Table: %s  Columns: %s', table, strjoin(colNames, ', ')), ...
            sprintf('  %d rows in %0.3f s', nrows(data), te));
        end
    end
end

function mustBeValidSqlTableName(str)
if isempty(regexp(str, '^[\w._]+$', 'once'))
    error('Must be a valid SQL table identifier. Got invalid string: ''%s''', ...
        str);
end
end
