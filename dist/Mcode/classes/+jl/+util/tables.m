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
    end
    
    methods (Access = private)
        function this = tables
            %TABLES Private constructor to suppress helptext
        end
    end
end