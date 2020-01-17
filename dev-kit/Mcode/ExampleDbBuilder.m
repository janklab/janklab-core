classdef ExampleDbBuilder
    % Creates the example database for testing out MDBC (jl.sql.*)
    %
    % Note: I built this example against Postgres; dunno if it'll work with
    % other databases.
    
    %#ok<*NBRAK>
    
    properties
        host = 'mydbserver.local'
        username = 'goose'
        password = 'honk'
        databaseName = 'village'
        
        exampleTables = { 'S' 'P' 'SP' 'ADozen' 'AThousand' };
    end
    
    methods
        function out = connect(this)
            jdbcUrl = sprintf('postgresql://%s/%s', ...
                this.host, this.databaseName);            
            out = jl.sql.Mdbc.connectFromJdbcUrl(jdbcUrl, ...
                this.username, this.password);
        end
        
        function blowAwayTables(this)
            db = this.connect;
            for i = 1:numel(this.exampleTables)
                sql = sprintf('DROP TABLE %s', this.exampleTables{i});
                try
                    db.exec(sql)
                catch err
                    fprintf('Error dropping %s: %s\n', this.exampleTables{i}, ...
                        err.message);
                end
            end
        end
        
        function createTables(this)
            db = this.connect;
            
            % Suppliers-Parts database
            
            sql = sprintf(strjoin({
                'CREATE TABLE S ('
                '    SNum   varchar(8),'
                '    SName  varchar(256),'
                '    Status numeric(5),'
                '    City   varchar(256)'
                ')'
                }, '\n'));
            db.exec(sql);
            sql = sprintf(strjoin({
                'CREATE TABLE P ('
                '    PNum   varchar(64),'
                '    PName  varchar(64),'
                '    Color  varchar(64),'
                '    Weight numeric(18,6),'
                '    City   varchar(256)'
                ')'
                }, '\n'));
            db.exec(sql);
            sql = sprintf(strjoin({
                'CREATE TABLE SP ('
                '    SNum   varchar(8),'
                '    PNum   varchar(64),'
                '    Qty    numeric(10)'
                ')'
                }, '\n'));
            db.exec(sql);
            
            % Thousand/Million tables

            n = 12;
            i = [1:n]';
            x = [1.11] * [1:n]';
            chr = repmat("x", [n 1]);
            flagDay = datenum(jl.time.flagday);
            dt = datetime(flagDay+[1:n]'-1, 'ConvertFrom','datenum');
            tbl = table(i, x, chr, dt);
            
            sql = sprintf(strjoin({
                'CREATE TABLE ADozen ('
                '    i     numeric(16),'
                '    x     numeric(18,6),'
                '    chr   char(1),'
                '    dt    timestamp'
                ')'
                }, '\n'));
            db.exec(sql);
            db.insert('ADozen', tbl);
                        
            n = 1000;
            i = [1:n]';
            x = [1.11] * [1:n]';
            chr = repmat("x", [n 1]);
            flagDay = datenum(jl.time.flagday);
            dt = datetime(flagDay+[1:n]'-1, 'ConvertFrom','datenum');
            tbl = table(i, x, chr, dt);
            
            sql = sprintf(strjoin({
                'CREATE TABLE AThousand ('
                '    i     numeric(16),'
                '    x     numeric(18,6),'
                '    chr   char(1),'
                '    dt    timestamp'
                ')'
                }, '\n'));
            db.exec(sql);
            db.insert('AThousand', tbl);
            
        end
    end
end