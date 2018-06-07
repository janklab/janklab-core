classdef tables
    %TABLES Utilities for working with table objects
    
    
    methods (Static = true)
        function out = tableFromVectors(varargin)
            %TABLEFROMVECTORS Construct a table from row or column vector inputs
            %
            % This lets you build a table without worrying about whether
            % your variables are row or column vectors.
            names = {};
            for i = 1:nargin
                names{i} = inputname(i); %#ok<*AGROW>
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
            % Constructs a table from a cellrec that contains variable
            % names in column 1 and variable values in column 2.
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
            % out = groupby(tbl, groupCols, groupSpec)
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
    end
    
    methods (Access = private)
        function this = tables
            %TABLES Private constructor to suppress helptext
        end
    end
end