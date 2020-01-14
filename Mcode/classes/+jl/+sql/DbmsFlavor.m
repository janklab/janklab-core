classdef DbmsFlavor < handle
    %DBMSFLAVOR DBMS-specific behaviors
    %
    % DbmsFlavor represents the dbms-flavor-specific behaviors of a database
    % system. A "flavor" here is a vendor or product, such as PostgreSQL, MySQL,
    % SQL Server, or Oracle.
    %
    % DbmsFlavor behaviors are implemented by subclasses.
    %
    % DbmsFlavor functionality is generally for MDBC's internal use, and not for
    % client code to use.
    
    methods
        
        function out = flavorDescription(this)
        out = 'Generic SQL DBMS';
        end
        
        function out = flavorName(this)
        out = 'generic';
        end
        
        function initializeConnection(this, conn)
        %INITIALIZECONNECTION Do flavor-specific connection initialization
        %
        % This should be called once on each new jl.sql.Connection.
        mustBeA(conn, 'jl.sql.Connection');
        end
        
        function registerDbmsSpecificTypeMappings(this, conn)
        % Registers dbms-flavor-specific type mappings on a connection.
        %
        % This registers column conversions and parameter conversions for
        % vendor-defined types lssupported by this DbmsFlavor.
        mustBeA(conn, 'jl.sql.Connection');
        % Default: do nothing
        end
    end
    
    methods (Static)
        function registerFlavor(flavorName, flavorClass)
        %REGISTERFLAVOR Register a DbmsFlavor class
        %
        % registerFlavor(flavorName, flavorClass)
        %
        % FlavorName (char) is the name used to identify the DBMS flavor. This
        % is probably just going to be the prefix used in the JDBC URL.
        mustBeA(flavorClass, 'char');
        s = getappdata(0, 'JanklabState');
        if ~isfield(s, 'mdbc')
            s.mdbc = struct;
        end
        if ~isfield(s.mdbc, 'registeredFlavors')
            s.mdbc.registeredFlavors = struct;
        end
        s.mdbc.registeredFlavors.(flavorName) = flavorClass;
        setappdata(0, 'JanklabState', s);
        end
        
        function out = getFlavorHandler(flavorName)
        %GETFLAVORHANDLER
        %
        % If no handler for the given flavor is registered, it falls back to
        % using the generic SQL DbmsFlavor.
        s = getappdata(0, 'JanklabState');
        if ~isfield(s, 'mdbc')
            s.mdbc = struct;
        end
        if ~isfield(s.mdbc, 'registeredFlavors')
            s.mdbc.registeredFlavors = struct;
        end
        if isfield(s.mdbc.registeredFlavors, flavorName)
            flavorClass = s.mdbc.registeredFlavors.(flavorName);
        else
            logger.debug(['No handler registered for DBMS flavor ''%s'';' ...
                'falling back to generic flavor.'], flavorName);
            flavorClass = 'jl.sql.DbmsFlavor';
        end
        out = feval(flavorClass);
        end
    end
end