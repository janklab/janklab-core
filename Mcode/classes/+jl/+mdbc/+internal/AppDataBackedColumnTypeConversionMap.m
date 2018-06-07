classdef AppDataBackedColumnTypeConversionMap < jl.mdbc.ColumnTypeConversionMap
    % A conversion map that can store/load its state as appdata
    %
    % This is used to let Mdbc's type registration state surve a "clear
    % classes". To simplify the implementation, this does not support a fallback
    % map.
    properties
        % The field under JanklabState.mdbc to store the definitions
        persistenceLabel
        % Whether to update the stored definitions upon new registrations. This
        % can be turned off during the restoration phase to prevent a race
        % condition.
        doPersistence = true
    end
    
    methods
        function this = AppDataBackedColumnTypeConversionMap(label, persistenceLabel)
        % Construct a new AppDataBackedColumnTypeConversionMap
        this = this@jl.mdbc.ColumnTypeConversionMap(label);
        this.persistenceLabel = persistenceLabel;
        % Check app data and reload if a definition is present
        this.loadFromAppData();
        end
        
        function registerForSqlType(this, sqlType, conversionName)
        registerForSqlType@jl.mdbc.ColumnTypeConversionMap(this, sqlType, conversionName);
        this.storeToAppData();
        end
        
        function registerStrategy(this, strategyName, strategyClassName)
        registerStrategy@jl.mdbc.ColumnTypeConversionMap(this, ...
            strategyName, strategyClassName);
        this.storeToAppData();
        end
        
        function storeToAppData(this)
        %STORETOAPPDATA Store this' persistent conversions to appdata
        rep = this.storedConversionRepresentation;
        s = getappdata(0, 'JanklabState');
        s.mdbc.(this.persistenceLabel) = rep;
        setappdata(0, 'JanklabState', s);
        end
        
        function loadFromAppData(this)
        %LOADFROMAPPDATA Load this' persistent conversions from appdata
        s = getappdata(0, 'JanklabState');
        if ~isfield(s, 'mdbc')
            s.mdbc = struct;
        end
        if isfield(s.mdbc, this.persistenceLabel)
            storedConversions = s.mdbc.(this.persistenceLabel);
            this.doPersistence = false;
            byType = storedConversions.byType;
            for i = 1:size(byType, 1)
                [sqlType,conversionName] = byType{i,:};
                this.registerForSqlType(sqlType, conversionName);
            end
            this.strategyMap = storedConversions.strategyMap;
            this.doPersistence = true;
        end
        end
        
        function out = storedConversionRepresentation(this)
        out = struct;
        % We'll only bother storing the by-type mappings, because the other
        % mappings (by column name/index or vendor type) are not meaningful at
        % the global level.
        byTypeMap = this.jval.bySqlType;
        sqlTypes = byTypeMap.keySet.toArray;
        c = {};
        for i = 1:numel(sqlTypes)
            sqlType = sqlTypes(i);
            sqlTypeName = char(sqlType.toString());
            conversionName = char(byTypeMap.get(sqlType));
            c = [c; {sqlTypeName conversionName}]; %#ok<AGROW>
        end
        out.byType = c;
        out.strategyMap = this.strategyMap;
        end
    end
end