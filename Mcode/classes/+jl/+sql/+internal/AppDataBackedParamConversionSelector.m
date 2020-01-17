classdef AppDataBackedParamConversionSelector < jl.sql.ParamConversionSelector
    % A conversion selector that can store/load its state as appdata
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
        function this = AppDataBackedParamConversionSelector(persistenceLabel)
            this.persistenceLabel = persistenceLabel;
            % Check app data and reload if a definition is present
            this.loadFromAppData();
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
                this.byParameterIndex = storedConversions.byParameterIndex;
                this.byTypeMappings = storedConversions.byTypeMappings;
                this.doPersistence = true;
            end
        end
        
        function out = storedConversionRepresentation(this)
            out = struct;
            out.byParameterIndex = this.byParameterIndex;
            out.byTypeMappings = this.byTypeMappings;
        end
        
        function this = registerByType(this, conversions)
            registerByType@jl.sql.ParamConversionSelector(this, conversions);
            this.storeToAppData();
        end
    end
end