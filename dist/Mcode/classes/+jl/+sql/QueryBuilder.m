classdef QueryBuilder
    %QUERYBUILDER Incrementally construct SQL queries
    %
    % This object is like a sentence diagram for a simple SQL query. It
    % lets you construct queries programmatically by conditionally adding
    % items to each of the clauses in the query.
    %
    % The QueryBuilder represents an SQL statement in a loosely structured manner that
    % allows for programmatically building SQL statements in an incremental,
    % conditional manner. This allows you to conditionally add in columns, WHERE
    % conditions, and groupings in a concise and readable manner using M-code.
    %
    % Not all SQL statements can be represented by an SqlQueryBuilder object. It just
    % supports easy construction of a set of them in a form that happens a lot in
    % data analysis.
    %
    % The query in a SqlQueryBuilderis broken down in to a set of clauses common in SQL 
    % statements, each of which holds a list of SQL fragments. These fragments and
    % clauses are then combined to produce the resulting SQL statement as a string.
    % Each of the clauses combines its fragments using a predefined combining
    % operator or "glue". Certain "clauses" do not have glue because they only
    % support single values.
    % 
    % Clause              Glue       Notes
    % ---------------     ---------  --------------
    % Select              ,
    % Into
    % TopN                           numeric or []
    % Distinct                       true/false
    % From                ,
    % Where               AND
    % GroupBy             ,
    % Having              AND
    %
    % The fragments held in each clause are stored as simple strings and treated as
    % raw arbitrary SQL. They are not further parsed or structured, except in
    % response to explicit method calls that act on them.
    %
    % For each of the multi-item clauses, there are "addX" methods that append additional terms
    % to the existing list in that property. And there are special convenience
    % methods like restrictOn that do more complex processing to their inputs to
    % produce the SQL fragments that are added to clauses.
    
    properties
        select    cell = {}
        distinct  logical = false
        into      char
        topN      double = NaN
        from      cell = {}
        where     cell = {}
        groupBy   cell = {}
        having    cell = {}
        orderBy   cell = {}
        
        % Query output format. May be 'short', 'long', or 'reallyshort'
        format    = 'short'
    end
    
    properties (Constant = true)
        clauseMap = {
            'select'    'SELECT'    ', '        ''
            'from'      'FROM'      ', '        ''
            'into'      'INTO'      ''          ''
            'where'     'WHERE'     ' AND '     'before'
            'groupBy'   'GROUP BY'  ', '        ''
            'having'    'HAVING'    ' AND '     'before'
            'orderBy'   'ORDER BY'  ', '        ''
            };
        
    end
    
    methods
        function disp(obj)
            %DISP Custom display
            sql = char(obj);
            if isempty(sql)
                sql = '(empty)';
            end
            fprintf('QueryBuilder:\n%s\n', sql);
        end

        function set.format(obj, newValue)
        mustBeValidFormat(newValue);
        obj.format = newValue;
        end
        
        function out = char(obj)
            %CHAR Convert to string containing the SQL query
            out = obj.sql;
        end
        
        function out = sql(obj)
            %SQL Convert to string containing the SQL query
            strs = {};
            % Special-case SELECT because of the DISTINCT
            if ~isempty(obj.select)
                str = 'SELECT';
                if obj.distinct
                    str = [str ' DISTINCT'];
                end
                if ~isnan(obj.topN)
                    str = sprintf('%s TOP %d', str, obj.topN);
                end
                str = [str ' ' strjoin(obj.select, obj.glue(', ', []))];
                strs{end+1} = str;
            end
            for iClause = 2:size(obj.clauseMap, 1)
                [clause, intro, glue, lineLocation] = obj.clauseMap{iClause,:};
                if isempty(obj.(clause))
                    continue
                end
                vals = cellstr(obj.(clause));
                strs{end+1} = sprintf('%6s %s', intro, strjoin(vals, obj.glue(glue, lineLocation))); %#ok<AGROW>
            end
            if isequal(obj.format, 'reallyshort')
                out = strjoin(strs, ' ');
            else
                out = strjoin(strs, LF);
            end
        end
        
        function obj = addSelect(obj, strs)
            %ADDSELECT Add items to the SELECT clause
            strs = cellstr(strs);
            obj.select = [obj.select strs(:)'];
        end
        
        function obj = addFrom(obj, strs)
            %ADDFROM Add items to the FROM clause
            strs = cellstr(strs);
            obj.from = [obj.from strs(:)'];
        end
        
        function obj = addWhere(obj, strs)
            %ADDWHERE Add items to the WHERE clause
            strs = cellstr(strs);
            obj.where = [obj.where strs(:)'];
        end
        
        function obj = addGroupBy(obj, strs)
            %ADDGROUPBY Add items to the GROUP BY clause
            strs = cellstr(strs);
            obj.groupBy = [obj.groupBy strs(:)'];
        end
        
        function obj = addHaving(obj, strs)
            %ADDHAVING Add items to the HAVING clause
            strs = cellstr(strs);
            obj.having = [obj.having strs(:)'];
        end
        
        function obj = addOrderBy(obj, strs)
            %ADDORDERBY Add items to the ORDER BY clause
            strs = cellstr(strs);
            obj.orderBy = [obj.orderBy strs(:)'];
        end
        
    end
    
    methods (Access = private)
        function out = glue(obj, str, lineLocation)
            switch obj.format
                case {'short','reallyshort'}
                    out = str;
                case 'long'
                    if isequal(lineLocation, 'before')
                        out = sprintf('\n       %s', str);
                    else
                       out = sprintf('%s\n        ', str);
                    end
                otherwise
                    error('Invalid format');
            end
        end
        
    end
    
end

function mustBeValidFormat(x)
if ~ismember(x, {'short','reallyshort','long'})
    error('Invalid format: %s', x);
end
end