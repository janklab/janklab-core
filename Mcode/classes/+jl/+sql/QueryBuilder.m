classdef QueryBuilder
    %QUERYBUILDER Incrementally construct SQL queries
    %
    % This is like a sentence diagram for a simple SQL query. It
    % lets you construct queries programmatically by conditionally adding
    % items to each of the clauses in the query.
    %
    % The QueryBuilder represents an SQL statement in a loosely structured manner that
    % allows for programmatically building SQL statements in an incremental,
    % conditional manner. This allows you to conditionally add in columns, WHERE
    % conditions, and groupings in a concise and readable manner using M-code.
    %
    % Not all SQL statements can be represented by an SqlQueryBuilder thisect. It just
    % supports easy construction of a set of them in a form that happens a lot in
    % data analysis.
    %
    % The query in a SqlQueryBuildern is broken down in to a set of clauses common in SQL
    % statements, each of which holds a list of SQL fragments. These fragments and
    % clauses are then combined to produce the resulting SQL statement as a string.
    % Each of the clauses combines its fragments using a predefined combining
    % operator or "glue". Certain clauses do not have glue because they only
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
    
    % Note: most of these properties should be restricted to be cellstrs, but we
    % can't do that with declarative type constraints, because at least as of R2016b,
    % property getters are not called prior to evaluating those type constraints, so
    % we can't do automatic conversion, which I want here (from char to cellstr).
    % This order of precedence is documented at
    % https://www.mathworks.com/help/matlab/matlab_oop/validate-property-values.html
    properties
        select    = {} % cellstr
        distinct  logical = false
        into      char
        top       double = NaN
        from      = {} % cellstr
        where     = {} % cellstr
        groupBy   = {} % cellstr
        having    = {} % cellstr
        orderBy   = {} % cellstr
        
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
        function this = QueryBuilder(arg)
            % Construct a new QueryBuilder
            %
            % QB = jl.sql.QueryBuilder()
            % QB = jl.sql.QueryBuilder(spec)
            % QB = jl.sql.QueryBuilder({
            %     'clause1'      values1
            %     'clause2'      values2
            % });
            %
            % Constructs a new QueryBuilder from a "spec" cell array that contains names
            % of clauses and values to stick in them.
            %
            % This constructor argument format is intended to make the code readable and
            % resemble equivalent SQL queries.
            %
            % Examples:
            %
            % QB = jl.sql.QueryBuilder({
            %     'SELECT'      {'PNum' 'PName' 'Color'}
            %     'FROM'        'P'
            %     'WHERE'       'Weight > 13'
            % });
            if nargin == 0
                return
            end
            mustBeA(arg, 'cell');
            validClauses = [jl.sql.QueryBuilder.clauseMap(:,1); {'distinct'; 'top'}];
            for i = 1:size(arg, 1)
                [clause,values] = arg{i,:};
                clause = lower(clause);
                if ~ismember(clause, validClauses)
                    error('Invalid clause: ''%s''', clause);
                end
                this.(clause) = values;
            end
        end
        
        function this = set.select(this, val)
            this.select = cellstr(val);
        end
        
        function this = set.from(this, val)
            this.from = cellstr(val);
        end
        
        function this = set.where(this, val)
            this.where = cellstr(val);
        end
        
        function this = set.groupBy(this, val)
            this.groupBy = cellstr(val);
        end
        
        function this = set.having(this, val)
            this.having = cellstr(val);
        end
        
        function this = set.orderBy(this, val)
            this.orderBy = cellstr(val);
        end
        
        function disp(this)
            %DISP Custom display
            sql = char(this);
            if isempty(sql)
                sql = '(empty)';
            end
            fprintf('QueryBuilder:\n%s\n', sql);
        end
        
        function this = set.format(this, newValue)
            mustBeValidFormat(newValue);
            this.format = newValue;
        end
        
        function out = char(this)
            %CHAR Convert to string containing the SQL query
            out = this.sql;
        end
        
        function out = sql(this)
            %SQL Convert to string containing the SQL query
            strs = {};
            % Special-case SELECT because of the DISTINCT
            if ~isempty(this.select)
                str = 'SELECT';
                if this.distinct
                    str = [str ' DISTINCT'];
                end
                if ~isnan(this.top)
                    str = sprintf('%s TOP %d', str, this.top);
                end
                str = [str ' ' strjoin(this.select, this.glue(', ', []))];
                strs{end+1} = str;
            end
            for iClause = 2:size(this.clauseMap, 1)
                [clause, intro, glue, lineLocation] = this.clauseMap{iClause,:};
                if isempty(this.(clause))
                    continue
                end
                vals = cellstr(this.(clause));
                strs{end+1} = sprintf('%6s %s', intro, strjoin(vals, this.glue(glue, lineLocation))); %#ok<AGROW>
            end
            if isequal(this.format, 'reallyshort')
                out = strjoin(strs, ' ');
            else
                out = strjoin(strs, LF);
            end
        end
        
        function this = addSelect(this, strs)
            %ADDSELECT Add items to the SELECT clause
            strs = cellstr(strs);
            this.select = [this.select strs(:)'];
        end
        
        function this = addFrom(this, strs)
            %ADDFROM Add items to the FROM clause
            strs = cellstr(strs);
            this.from = [this.from strs(:)'];
        end
        
        function this = addWhere(this, strs)
            %ADDWHERE Add items to the WHERE clause
            strs = cellstr(strs);
            this.where = [this.where strs(:)'];
        end
        
        function this = addGroupBy(this, strs)
            %ADDGROUPBY Add items to the GROUP BY clause
            strs = cellstr(strs);
            this.groupBy = [this.groupBy strs(:)'];
        end
        
        function this = addHaving(this, strs)
            %ADDHAVING Add items to the HAVING clause
            strs = cellstr(strs);
            this.having = [this.having strs(:)'];
        end
        
        function this = addOrderBy(this, strs)
            %ADDORDERBY Add items to the ORDER BY clause
            strs = cellstr(strs);
            this.orderBy = [this.orderBy strs(:)'];
        end
        
    end
    
    methods (Access = private)
        function out = glue(this, str, lineLocation)
            switch this.format
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