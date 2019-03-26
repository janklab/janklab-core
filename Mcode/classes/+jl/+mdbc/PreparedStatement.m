classdef PreparedStatement < jl.mdbc.Statement
    % A prepared statement
    
    properties
        paramConversionSelector jl.mdbc.ParamConversionSelector
        % The JLPreparedStatement wrapping the underlying JDBC Statement
        jlStmt
    end
    
    methods
        function this = PreparedStatement(connection, sql, jdbcStatement)
        % Construct a new PreparedStatement
        %
        % Client code should never call this. Instead, call prepareStatement()
        % on a jl.mdbc.Connection object.
        this = this@jl.mdbc.Statement(connection, sql, jdbcStatement);
        this.jlStmt = net.janklab.mdbc.JLPreparedStatement(jdbcStatement);
        this.paramConversionSelector = jl.mdbc.ParamConversionSelector(...
            this.connection.paramConversionSelector);
        end
        
        function out = dispstr(this)
        % Custom display string
        if ~isscalar(this)
            out = sprintf('%s %s', sizestr(this), class(this));
            return;
        end
        if isempty(this.jdbc)
            out = 'PreparedStatement: []';
            return;
        end
        out = sprintf('PreparedStatement: %s', char(this.jdbc.toString()));
        end
        
        function disp(this)
        % Custom display
        display(dispstr(this));
        end
        
        function out = execute(this, params)
        % Execute statement with given parameters
        %
        % out = execute(this, params)
        %
        % This is the general case of execution, where the results may be any
        % combination of update counts and ResultSets.
        %
        % Params (cell) is a cell array of parameters to be bound to the
        % placeholders in this's previously prepared statement. It may also be []
        % or omitted to indicate no parameters are to be bound.
        %
        % Returns a jl.mdbc.Results.
        if nargin < 2 || isempty(params);  params = {}; end
        
        t0 = tic;
        % Bind parameters
        this.bindParameters(params);
        
        % Execute statement
        execStatus = this.jdbc.execute();
        
        % Fetch all results
        out = this.fetchAllResults(execStatus);
        te = toc(t0);
        
        % Log the execution
        paramDescrs = sprintfv('%d: %s', 1:numel(params), ...
            cellfun(@(x)dispstr(x,{'QuoteStrings',true}), ...
            params, 'UniformOutput',false));
        logDetails = sprintf('%s\n  Params: %s', ...
            this.sql, strjoin(paramDescrs, ', '));
        this.traceLog.debugf('SQL EXECUTE\n%s\n  %s in %0.3f s', ...
            logDetails, summaryString(out), te);
        end
        
        function out = executeBatch(this, params, opts)
        % Execute statement with multiple parameter values as batch update(s)
        %
        % out = executeBatch(this, params, opts)
        %
        % Params (cell) is a cell array of parameter value arrays to be bound to
        % the placeholders in this's previously prepared statement.
        %
        % Opts (options) controls behavior. This is currently for internal use
        % only.
        if nargin < 3;  opts = [];  end
        opts = jl.util.parseOpts(opts, {'DoLogging',true});
        
        t0 = tic;
        [~,nRows] = this.setUpParameterBinding(params);
        this.jlStmt.bindBatch(nRows);
        updateCounts = this.jdbc.executeBatch();
        out = jl.mdbc.BatchUpdateResults.ofJdbcUpdateCount(updateCounts);
        te = toc(t0);
        
        if opts.DoLogging
            paramDescrs = sprintfv('%d: %s', 1:numel(params), ...
                cellfun(@class, params, 'UniformOutput',false));
            logDetails = sprintf('%s\n  Batch: %d rows, param types: %s', ...
                this.sql, nRows, strjoin(paramDescrs, ', '));
            this.traceLog.debugf('SQL EXECUTEBATCH\n%s\n  %d updates in %0.3f s', ...
                logDetails, out.totalUpdates, te);
        end
        end
        
    end
    
    methods (Access = private)
        function [binders,nRows] = setUpParameterBinding(this, params)
        % Set up parameter bindings, but don't actually bind yet
        mustBeA(params, 'cell');
        
        % Do initial type conversion
        for i = 1:numel(params)
            if ischar(params{i}) || iscellstr(params{i})
                params{i} = string(params{i});
            end
        end
        % Set up parameter converters
        converters = cell(1, numel(params));
        binders = cell(1, numel(params));
        for i = 1:numel(params)
            paramConverterType = this.paramConversionSelector.selectConversion(...
                i, params{i});
            converters{i} = feval(paramConverterType);
            binders{i} = converters{i}.getBinder();
            binders{i}.attach(this.jdbc, i);
            convertedData = converters{i}.convertParamData(params{i});
            binders{i}.setBuffer(convertedData);
            this.jlStmt.addBinder(binders{i});
        end
        if isempty(params)
            % In the degenerate case, consider that a single row with no
            % bindings done.
            nRows = 1;
        else
            nRows = numel(params{1});
        end
        
        end
        
        function bindParameters(this, params)
        % Bind parameter values to placeholder parameters
        %
        % This method is for internal use. Don't call it directly.
        this.setUpParameterBinding(params);
        this.jlStmt.bindSingle();
        end
    end
    
end