classdef Connection < handle
    % A connection to a database
    
    % Dev note: A Connection object "owns" the underlying jlConn and jdbConn
    % objects. It will close them upon cleanup, and they cannot be shared with
    % other objects.
    
    properties
        jlConn  % The janklab-java MDBC JLConnection object
    end
    
    properties (Dependent=true)
        jdbcConn              % The underlying JDBC Connection object
        TransactionIsolation  % This' transaction isolation level, as string
        user                  % The username for this connection
        baseUrl               % The base JDBC URL for this connection
    end
    
    
    methods
        
        function this = Connection(jlConn)
        % Create a new Connection, taking ownership of the underlying connection
        if nargin == 0
            % NOP
        else
            this.jlConn = jlConn;
        end
        end
        
        function delete(this)
        % Destructor: cleans up underlying database connection
        for i = 1:numel(this)
            if ~isempty(this(i).jlConn)
                if ~this(i).jdbcConn.isClosed()
                    try
                        this(i).jdbcConn.close();
                    catch
                        % quash
                    end
                end
            end
        end
        end
        
        function disp(this)
        % Custom display
        disp(dispstr(this));
        end
        
        function out = dispstr(this)
        
        if ~isscalar(this)
            dispf('%s %s', sizestr(this), class(this));
            return;
        end
        if isempty(this.jdbcConn)
            disp('<no connection>');
            return
        end
        
        % General case
        
        jc = this.jdbcConn;
        str = 'Connection:';
        
        str = sprintf('%s %s@%s', str, this.user, this.baseUrl);
        
        
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
        if jc.getNetworkTimeout ~= 0
            items{end+1} = sprintf('NetworkTimeout=%f', jc.getNetworkTimeout);
        end
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
        out = this.jlConn.jdbcConn;
        end
        
        function out = get.user(this)
        out = char(this.jlConn.user);
        end
        
        function out = get.baseUrl(this)
        out = char(this.jlConn.baseUrl);
        end
        
        function out = get.TransactionIsolation(this)
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
        out = this.jdbcConn.isValid(timeout);
        end
    end
end