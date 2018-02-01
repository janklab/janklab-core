classdef Mdbc
    % Central methods for MDBC
    %
    % This provides global settings, utilities, and factory methods for MDBC.
    
    methods (Static)
        function out = connectFromJdbcUrl(url, user, password, properties)
        % Connect to a database using a JDBC URL specification
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
        
        jdbcUrl = ['jdbc:' url];
        jProps = java.util.Properties;
        fields = fieldnames(properties);
        for i = 1:numel(fields)
            jProps.setProperty(fields{i}, properties.(fields{i}));
        end
        jProps.setProperty('user', user);
        jProps.setProperty('password', password);
        
        jdbcConnection = java.sql.DriverManager.getConnection(jdbcUrl, jProps);
        jlConnection = net.janklab.mdbc.JLConnection(jdbcConnection, url, user);
        
        out = jl.mdbc.Connection;
        out.jlConn = jlConnection;
        
        end
    end
end