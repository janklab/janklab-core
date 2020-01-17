classdef tables
    %TABLES Utilities for working with table objects
    
    methods (Static = true)
        function out = tableFromVectors(varargin)
            %TABLEFROMVECTORS Construct a table from row or column vector inputs
            %
            % out = tableFromVectors(A, B, C, ...)
            %
            % This lets you build a table without worrying about whether
            % your variables are row or column vectors.
            %
            % Accepts any number of inputs. Each of them must be a vector.
            %
            % The variable names are taken from the input names, as with the
            % table(...) constructor.
            names = {};
            for i = 1:nargin
                names{i} = inputname(i); %#ok<*AGROW>
                if isempty(names{i})
                    names{i} = sprintf('Column%d', i);
                end
            end
            values = varargin;
            for i = 1:numel(values)
                values{i} = values{i}(:);
            end
            out = table(values{:}, 'VariableNames',names);
        end

        function out = tableFromCellrec(c)
            %TABLEFROMCELLREC Construct a table from a cellrec of variable names and values
            %
            % out = jl.util.tables.tableFromCellrec(c)
            %
            % Constructs a table from a cellrec that contains variable
            % names in column 1 and variable values in column 2.
            %
            % c is a cellrec.
            %
            % Returns a table.
            names = c(:,1);
            values = c(:,2);
            for i = 1:numel(values)
                values{i} = values{i}(:);
            end
            out = table(values{:}, 'VariableNames',names);
        end

        function out = groupby(tbl, groupCols, groupSpec)
            %GROUPBY SQL-style grouping operation
            %
            % out = jl.util.tables.groupby(tbl, groupCols, groupSpec)
            %
            % Tbl is the table object to group.
            %
            % GroupCols (cellstr) is the list of group columns. These correspond to the
            % columns listed after "GROUP BY" in SQL SELECT statement.
            %
            % GroupSpec (cell) is an n-by-3 cell array specifying the aggregations to do
            % within the groups. It is in the form:
            %  { OutCols, AggregateFcn, InCols }
            % Where:
            %  OutCols - char or cellstr list of new columns to create from the argouts of
            %     AggregateFcn
            %  AggregateFcn - a function handle to the function to do the aggregation
            %  InCols - list of column names whose data will be passed to the inputs of
            %     AggregateFcn
            %
            % See also: RELATION.GROUPBY
            [groupid,groupvals] = findgroups(tbl(:,groupCols));
            nGroups = max(groupid);
            
            for iFcn = 1:size(groupSpec, 1)
                groupSpec{iFcn, 1} = cellstr(groupSpec{iFcn, 1});
                groupSpec{iFcn, 3} = cellstr(groupSpec{iFcn, 3});
            end
            outColNames = cat(2, groupSpec{:,1});
            nOutCols = numel(outColNames);
            outVals = cell(1, nOutCols);
            for iGroup = 1:nGroups
                tfInGroup = groupid == iGroup;
                tGroup = tbl(tfInGroup,:);
                outOffset = 0;
                for iFcn = 1:size(groupSpec, 1)
                    [outCols,aggregateFcn,inCols] = groupSpec{iFcn,:};
                    argins = cell(numel(inCols), 1);
                    for iIn = 1:numel(argins)
                        argins{iIn} = tGroup.(inCols{iIn});
                    end
                    argouts = cell(size(outCols));
                    [argouts{:}] = aggregateFcn(argins{:});
                    for iOut = 1:numel(argouts)
                        outVals{outOffset+iOut}(end+1) = argouts{iOut};
                    end
                    outOffset = outOffset + numel(argouts);
                end
            end
            
            out = groupvals;
            for iOut = 1:nOutCols
                out.(outColNames{iOut}) = outVals{iOut}(:);
            end
        end
        
        function [S,P,SP] = supplierPartsExample()
            %SUPPLIERPARTSEXAMPLE The classic "Supplier Parts" example database
            %
            % s = jl.util.tables.supplierPartsExample
            % [S,P,SP] = jl.util.tables.supplierPartsExample
            %
            % Generates the classic C. J. Date "Supplier Parts" example database
            % as a set of table objects.
            %
            % If a single output is captured, returns a struct with fields S, P,
            % and SP. If multiple outputs are captured, returns S, P, and SP as
            % separate outputs.
            S = cell2table({
                'S1'    'Smith'     20  'London'
                'S2'    'Jones'     10  'Paris'
                'S3'    'Blake'     30  'Paris'
                'S4'    'Clark'     20  'London'
                'S5'    'Adams'     30  'Athens'
                }, 'VariableNames', {'SNum','SName','Status','City'});
            P = cell2table({
                'P1'    'Nut'   'Red'   12.0    'London'
                'P2'    'Bolt'  'Green' 17.0    'Paris'
                'P3'    'Screw' 'Blue'  17.0    'Oslo'
                'P4'    'Screw' 'Red'   14.0    'London'
                'P5'    'Cam'   'Blue'  12.0    'Paris'
                'P6'    'Cog'   'Red'   19.0    'London'
                }, 'VariableNames', {'PNum','PName','Color','Weight','City'});
            SP = cell2table({
                'S1'    'P1'    300
                'S1'    'P2'    200
                'S1'    'P3'    400
                'S1'    'P5'    100
                'S1'    'P6'    100
                'S2'    'P1'    300
                'S2'    'P2'    400
                'S3'    'P2'    200
                'S4'    'P2'    200
                'S4'    'P4'    300
                'S4'    'P5'    400
                }, 'VariableNames', {'SNum','PNum','Qty'});
            
            if nargout == 1
                tmp = S;
                S = struct;
                S.S = tmp;
                S.P = P;
                S.SP = SP;
            end
        end
        
        function out = tableFromStructRecArray(s)
            %TABLEFROMSTRUCTRECARRAY Convert array of record structs to table
            %
            % out = jl.util.tables.tableFromStructRecArray(s)
            %
            % Takes an array of structs that each represent a single record
            % and turns it in to a table.
            fields = fieldnames(s);
            vals = cell(size(fields));
            for i = 1:numel(fields)
                for is = 1:numel(s)
                    if ischar(s(is).(fields{i}))
                        s(is).(fields{i}) = cellstr(s(is).(fields{i}));
                    end
                end
                vals{i} = [s.(fields{i})]';
            end
            out = table(vals{:}, 'VariableNames', fields);
        end
        
        function [status,message] = xlswrite(file, tbl, sheet)
            %XLSWRITE Write table to Excel spreadsheet file
            %
            % [status,message] = jl.util.tables.xlswrite(file, tbl, sheet)
            %
            % You probably don't want to use this method. Use Matlab's own
            % WRITETABLE instead.
            if nargin < 3;  sheet = [];  end
            header = tbl.Properties.VariableNames;
            data = table2cell(tbl);
            A = [header; data];
            args = {};
            if ~isempty(sheet)
                args{end+1} = sheet;
            end
            [status,message] = xlswrite(file, A, args{:});
        end
        
        function out = restrictexpr(tbl, expr)
          %RESTRICTEXPR Subset rows based on an expression
          %
          % out = restrictexpr(tbl, expr)
          %
          % tbl (table) is the table to subset rows on, and also is the context
          % for evaluation of expr.
          %
          % expr (char) is a Matlab expression that returns a logical or numeric
          % vector that indexes into the rows of tbl.
          %
          % Returns a subsetted copy of tbl.
          %
          % Example:
          %
          % [s,p,sp] = jl.examples.table.SpDb;
          % p2 = jl.util.tables.restrictexpr(p, 'Weight > 12 & Weight <= 18 & City == "London"')
          %
          % See also:
          % EVALWITH
          ix = jl.util.tables.evalwith(tbl, expr);
          out = tbl(ix,:);
        end
        
        function out = evalwith(tbl, expr)
          %EVALWITH Evaluate an expression in the context of a table's variables
          %
          % out = jl.util.evalwith(tbl, expr)
          %
          % Evaluates a given Matlab expression in the context of a table's
          % variables. This means it is run inside a workspace where all of the
          % given table's contained variables are available as regular Matlab
          % workspace variables.
          %
          % tbl (table) is the table that provides the context
          % for evaluation of expr.
          %
          % expr (char) is a Matlab expression written in terms of the variables
          % inside tbl.
          %
          % [s,p,sp] = jl.examples.table.SpDb;
          % expr = 'find(Weight > 12 & Color == "Red" | City == "London")';
          % strs = jl.util.tables.evalwith(p, expr)
          %
          % Returns the result of evaluating expr.
          %
          % See also:
          % RESTRICTEXPR
          out = JL_EVALWITH__(tbl, expr);
        end
        
        function out = semijoin(a, b)
          %SEMIJOIN Relational semijoin
          %
          % out = jl.util.tables.semijoin(a, b)
          %
          % a and b are the input tables.
          %
          % Returns the subset of a that matches rows in b.
          mustBeA(a, 'table');
          mustBeA(b, 'table');
          keyCols = intersect(a.Properties.VariableNames, b.Properties.VariableNames);
          keysA = a(:,keyCols);
          keysB = b(:,keyCols);
          tf = ismember(keysA, keysB);
          out = a(tf,:);
        end
        
        function out = antijoin(a, b)
          %ANTIJOIN Relational antijoin (aka "semidifference")
          %
          % out = jl.util.tables.antijoin(a, b)
          %
          % a and b are tables.
          %
          % Returns the subset of a that does not match any rows in b.
          mustBeA(a, 'table');
          mustBeA(b, 'table');
          keyCols = intersect(a.Properties.VariableNames, b.Properties.VariableNames);
          keysA = a(:,keyCols);
          keysB = b(:,keyCols);
          tf = ismember(keysA, keysB);
          out = a(~tf,:);
        end
    end
    
    methods (Access = private)
        function this = tables
            %TABLES Private constructor to suppress helptext
        end
    end
end

% All the funky variable names here are to avoid name collisions with
% the user's variables.
function JL_EVALWITH_out = JL_EVALWITH__(JL_EVALWITH_tbl__, JL_EVALWITH_expr__)
  JL_EVALWITH_vars = JL_EVALWITH_tbl__.Properties.VariableNames;
  for JL_EVALWITH_i = 1:numel(JL_EVALWITH_vars)
    JL_EVALWITH_var = JL_EVALWITH_vars{JL_EVALWITH_i};
    if isvarname(JL_EVALWITH_var)
      JL_EVALWITH_assgn_expr = [JL_EVALWITH_var ' = JL_EVALWITH_tbl__.(''' JL_EVALWITH_var ''');'];
      eval(JL_EVALWITH_assgn_expr);
    end
  end
  JL_EVALWITH_out = eval(JL_EVALWITH_expr__);
end