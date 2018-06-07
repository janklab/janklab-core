classdef ColumnTypeConversionMap < handle
    
    properties (GetAccess = public, SetAccess = protected)
        % The underlying Java net.janklab.mdbc.ColumnTypeConversionMap for
        % mapping columns to strategies.
        jval
        % Maps strategy names to Matlab implementation classes
        strategyMap = struct;
        % The fallback map
        fallback jl.mdbc.ColumnTypeConversionMap
    end
    properties (Dependent)
        label
    end
    
    methods
        function this = ColumnTypeConversionMap(label, fallbackMap)
        % Construct a new ColumnTypeConversionMap
        narginchk(1,2);
        if nargin < 2; fallbackMap = [];  end
        if isempty(fallbackMap)
            this.jval = net.janklab.mdbc.ColumnTypeConversionMap(label);
        else
            mustBeType(fallbackMap, 'jl.mdbc.ColumnTypeConversionMap');
            this.fallback = fallbackMap;
            this.jval = net.janklab.mdbc.ColumnTypeConversionMap(label, ...
                fallbackMap.jval);
        end
        end
        
        function out = get.label(this)
        out = char(this.jval.label());
        end
        
        function out = lookupConversion(this, colIndex, colName, sqlType, vendorType)
        %LOOKUPCONVERSION Look up a conversion strategy based on column properties
        %
        % Returns (char) the name of the strategy to use.
        out = char(this.jval.lookupConversion(colIndex, colName, sqlType, vendorType));
        end
        
        function out = lookupStrategy(this, strategyName)
        if isfield(this.strategyMap, strategyName)
            out = this.strategyMap.(strategyName);
        elseif ~isempty(this.fallback)
            out = this.fallback.lookupStrategy(strategyName);
        else
            error('jl:mdbc:BadInput', 'No such column conversion strategy: %s', ...
                strategyName);
        end
        end
        
        function registerForName(this, colName, conversionName)
        this.jval.registerForName(colName, conversionName);
        end
        
        function registerForIndex(this, colIndex, conversionName)
        this.jval.registerForIndex(colIndex, conversionName);
        end
        
        function registerForSqlType(this, sqlType, conversionName)
        if ischar(sqlType)
            sqlType = net.janklab.mdbc.SqlType.valueOf(sqlType);
        end
        this.jval.registerForSqlType(sqlType, conversionName);
        end
        
        function registerForSqlTypes(this, sqlTypeConversions)
        mustBeType(sqlTypeConversions, 'cell');
        if ~ismatrix(sqlTypeConversions) || size(sqlTypeConversions, 2) ~= 2
            error('jl:InvalidInput', 'Input must be n-by-2 cell; got %s %s', ...
                sizestr(sqlTypeConversions), class(sqlTypeConversions));
        end
        mustBeCellstr(sqlTypeConversions(:,2));
        for i = 1:size(sqlTypeConversions, 1)
            [sqlType, conversionName] = sqlTypeConversions{i,:};
            this.registerForSqlType(sqlType, conversionName);
        end
        end
        
        function registerForVendorType(this, vendorType, conversionName)
        this.jval.registerForVendorType(vendorType, conversionName);
        end
        
        function registerForVendorTypes(this, conversions)
        mustBeType(conversions, 'cell');
        if ~ismatrix(conversions) || size(conversions, 2) ~= 2
            error('jl:InvalidInput', 'Input must be n-by-2 cell; got %s %s', ...
                sizestr(conversions), class(conversions));
        end
        mustBeCellstr(conversions(:,2));
        for i = 1:size(conversions, 1)
            [vendorType, conversionName] = conversions{i,:};
            this.registerForVendorType(vendorType, conversionName);
        end
        end
        
        
        
        function registerStrategy(this, strategyName, strategyClassName)
        s = this.strategyMap;
        s.(strategyName) = strategyClassName;
        this.strategyMap = s;
        end
        
        function registerStrategies(this, strategies)
        mustBeCellstr(strategies);
        mustBeType(strategies, 'cellrec');
        for i = 1:size(strategies, 1)
            [strategyName, strategyClassName] = strategies{i,:};
            registerStrategy(this, strategyName, strategyClassName);
        end
        end
        
        function out = debugDump(this)
        out = char(this.jval.debugDump);
        out = sprintf('%sStrategy Class Map:\n%s', out, ...
            this.debugDumpStrategyMap);        
        if nargout == 0
            disp(out); %#ok<DSPS>
            clear out
        end
        end
        
        function useFastDangerousDoubles(this)
        % Enable fast, non-roundoff-warning buffering of doubles
        %
        % This changes the map to use the fast, "dangerous" double buffer
        % strategy for BIGINT, NUMERIC, and DECIMAL values. These are
        % "dangerous" because they convert all values directly to double,
        % without checking for roundoff errors.
        this.registerForSqlTypes({
            'BIGINT', 'DOUBLE'
            'NUMERIC', 'DOUBLE'
            'DECIMAL', 'DOUBLE'
            });
        end
        
        function useAllStringsAsSymbols(this)
        % Enable fetching strings as @symbols for all columns
        %
        % This changes the column type mappings to map all CHAR data to
        % symbols. This is useful for efficiently retrieving low-cardinality
        % data.
        
        % Repointing the strategy (as oppsed to remapping individual SQL types)
        % ensures that all types that are converted to
        % CHAR get caught. This is probably the right thing to do.
        this.registerStrategies({
            'CHAR'      'jl.mdbc.colconv.SymbolColumnTypeConversion'
            });
        end
    end
    
    methods (Access = private)
        function out = debugDumpStrategyMap(this)
        x = {};
        x{end+1} = sprintf('  %s:', this.label);
        stratNames = fieldnames(this.strategyMap);
        if isempty(stratNames)
            x{end+1} = '    (empty)';
        else
            for i = 1:numel(stratNames)
                x{end+1} = sprintf('    %s -> %s', stratNames{i}, ...
                    this.strategyMap.(stratNames{i})); %#ok<AGROW>
            end
        end
        out = strjoin(x, '\n');
        if ~isempty(this.fallback)
            out = sprintf('%s\n%s', out, this.fallback.debugDumpStrategyMap);
        end
        end
    end
end