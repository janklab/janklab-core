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
        
        function out = tableFromStructRecArray(s)
            %TABLEFROMSTRUCTRECARRAY
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