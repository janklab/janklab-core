classdef Statement < handle
    % A SQL statement
    %
    % This class is subclassed by PreparedStatement and CallableStatement.
    %
    % See also: PREPAREDSTATEMENT, CALLABLESTATEMENT
    
    properties (GetAccess = public, SetAccess = private)
        % The underlying JDBC Statement. May be a subclass.
        jdbc
        % The SQL statement string
        sql char
        % The statement's column type conversion map
        columnTypeConversionMap
        % The connection this statement was produced from
        connection
    end
    properties (Access = protected)
        traceLog = logger.Logger.getLogger('jl.mdbc.trace');
    end
    properties
        % Rows per chunk when fetching results
        rowsPerFetchChunk = 10000;
    end
    
    methods
        function this = Statement(connection, sql, jdbcStatement)
        %STATEMENT Construct a new Statement
        this.sql = sql;
        this.jdbc = jdbcStatement;
        this.connection = connection;
        this.columnTypeConversionMap = jl.mdbc.ColumnTypeConversionMap(...
            "Statement", connection.columnTypeConversionMap);
        end
        
        function out = dispstr(this)
        %DISPSTR Custom display string
        if ~isscalar(this)
            out = sprintf('%s %s', sizestr(this), class(this));
            return;
        end
        if isempty(this.jdbc)
            out = 'Statement: []';
            return;
        end
        out = sprintf('Statement: %s', char(this.jdbc.toString()));
        end
        
        function disp(this)
        %DISP Custom display
        display(dispstr(this));
        end
        
        function out = exec(this)
        % EXEC Execute the statement
        %
        % out = exec(obj)
        %
        % Executes the statement, returning all results.
        %
        % Returns a jl.mdbc.Results object.
        t0 = tic;
        execStatus = this.jdbc.execute(this.sql);
        out = this.fetchAllResults(execStatus);
        te = toc(t0);
        this.traceLog.debug('SQL: EXEC\n  %s\n  %s in %0.3f s', ...
            this.sql, summaryString(out), te);
        end
        
        function useStringsAsSymbols(this, columns)
        %USESTRINGSASSYMBOLS Configure this to fetch selected strings as symbols
        %
        % useStringsAsSymbols(this, columns)
        %
        % Sets up the identified columns to be fetched as symbols.
        %
        % Columns (double, cellstr) may be a list of column names or column
        % indexes.
        if ischar(columns) || isstring(columns)
            columns = cellstr(columns);
        end
        if isnumeric(columns)
            for ixCol = columns(:)'
                this.columnTypeConversionMap.registerForIndex(ixCol, 'symbol');
            end
        elseif iscellstr(columns)
            for i = 1:numel(columns)
                columnName = columns{i};
                this.columnTypeConversionMap.registerForName(columnName, 'symbol');
            end
        else
            error('jl:InvalidInput', 'Invalid columns input: %s', class(columns));
        end
        end
    end
    
    methods (Access = protected)
        function out = fetchAllResults(this, initialExecStatus)
        %FETCHALLRESULTS
        
        %TODO: Figure out when and how to retrieve SqlWarnings
        out = jl.mdbc.Results;
        isResultSetNext = initialExecStatus;
        while true
            if isResultSetNext
                % Next result is a ResultSet
                rs = this.fetchCurrentResultSet();
                out.results(end+1) = jl.mdbc.Result(rs);
            else
                % Next result is an update count or end of results
                updateCount = this.jdbc.getUpdateCount();
                if updateCount == -1
                    % End of results
                    break;
                else
                    out.results(end+1) = jl.mdbc.Result(updateCount);
                end
            end
            isResultSetNext = this.jdbc.getMoreResults();
        end
        end
        
        function out = fetchCurrentResultSet(this)
        %FETCHCURRENTRESULTSET
        log = logger.Logger.getLogger('jl.mdbc');
        jResultSet = this.jdbc.getResultSet();
        rsMeta = jl.mdbc.jdbc.RSMetaData(jResultSet.getMetaData());
        nCols = rsMeta.columnCount;
        colFetchers = cell(1, nCols);
        jRSBuffer = net.janklab.mdbc.ResultSetBuffer(jResultSet);
        for iCol = 1:nCols
            % Look up ColBuffer and ColFetcher to use
            % Look up the conversion type name
            colMeta = rsMeta.getColumnMetaData(iCol);
            conversionName = char(this.columnTypeConversionMap.lookupConversion(...
                iCol, colMeta.label, colMeta.sqlType, colMeta.dbmsTypeName));
            if isempty(conversionName)
                error('No column type conversion found for column %d (''%s'', sqlType=%s (%s))', ...
                    iCol, colMeta.label, colMeta.sqlType, colMeta.dbmsTypeName);
            end
            % Get the ColTypeConversion based on that name
            colConversionClass = this.columnTypeConversionMap.lookupStrategy(...
                conversionName);
            colConversion = feval(colConversionClass);
            % Get the ColBuffer and ColFetcher from the ColTypeConversion
            colBuffer = colConversion.getColumnBuffer();
            colFetcher = colConversion.getColumnFetcher();
            jRSBuffer.setColumnBuffer(iCol, colBuffer);
            colFetchers{iCol} = colFetcher;
            if log.isDebugEnabled
                m = colMeta;
                log.debug('Col %d: "%s": %s (%d,%d) (%s) -> %s', ...
                    iCol, m.label, m.sqlType, m.precision, m.scale, m.dbmsTypeName, ...
                    conversionName);
            end
        end
        % Fetch the current result set in chunks
        chunks = {};
        mayHaveMoreChunks = true;
        while mayHaveMoreChunks
            % Fetch a chunk from the Java buffer
            jRSFetchResult = jRSBuffer.fetch(this.rowsPerFetchChunk);
            mayHaveMoreChunks = ~jRSFetchResult.isFinished;
            % Convert it to Matlab types and store it
            chunks{end+1} = this.convertFetchedChunkToMatlab(jRSFetchResult, rsMeta, ...
                nCols, colFetchers); %#ok<AGROW>
        end
        % Build Matlab result from fetched chunks
        % Returning as @table for now; should be converted to @relation
        data = cat(1, chunks{:});
        colData = cell(1, nCols);
        for iCol = 1:nCols
            colData{iCol} = cat(1, data{:,iCol});
        end
        columnNames = rsMeta.columnLabels();
        out = relation(columnNames, colData);
        end
        
        function out = convertFetchedChunkToMatlab(this, jRSFetchResult, rsMeta, nCols, colFetchers)
        colVals = cell(1, nCols);
        for iCol = 1:nCols
            bufferedData = jRSFetchResult.bufferedColumnData(iCol);
            colVals{iCol} = colFetchers{iCol}.fetchColumn(...
                bufferedData, ...
                rsMeta.getColumnMetaData(iCol));
        end
        out = colVals;
        end
    end
    
end