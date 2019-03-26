classdef PostgresDbmsFlavor < jl.mdbc.DbmsFlavor
    %POSTGRESDBMSFLAVOR DbmsFlavor for PostgreSQL
    %
    % Developed against and supports version 10, but will probably work fine
    % with older versions, too.
    
    methods
        function out = flavorDescription(this)
        out = 'PostgreSQL';
        end
        
        function out = flavorName(this)
        out = 'postgresql';
        end
        
        function initializeConnection(this, conn)
        %INITIALIZECONNECTION Do flavor-specific connection initialization
        %
        % This should be called once on each new jl.mdbc.Connection.
        this.registerDbmsSpecificTypeMappings(conn);
        end
        
        function registerDbmsSpecificTypeMappings(this, conn)
        % Registers dbms-flavor-specific type mappings on a connection.
        %
        % This registers column conversions and parameter conversions for
        % vendor-defined types supported by this DbmsFlavor.
        mustBeA(conn, 'jl.mdbc.Connection');
        conn.columnTypeConversionMap.registerForVendorTypes({
            'uuid'      'uuid'
            });
        conn.columnTypeConversionMap.registerStrategies({
            'uuid'      'jl.mdbc.postgres.UuidColumnTypeConversion'
            });
        end
    end
    
end