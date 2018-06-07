classdef Results
    %RESULTS The results of executing an SQL statement.
    %
    % A Results object collects ResultSets, update counts, and warnings returned
    % as the result of running an SQL statement.
    
    properties
        % The data results of executing the SQL statement
        results jl.mdbc.Result
        % SqlWarnings encountered when executing the SQL statement
        warnings jl.mdbc.SqlWarning
    end
    
    methods
        function disp(this)
        %DISP Custom display.
        if isscalar(this)
            prettyprint(this);
        else
            disp(dispstr(this));
        end
        end
        
        function out = dispstr(this)
        %DISPSTR Custom display string.
        if ~isscalar(this)
            out = sprintf('%s %s', sizestr(this), class(this));
            return;
        end
        out = sprintf('%d Results', numel(this.results));
        if ~isempty(this.warnings)
            out = [out sprintf(', %d warnings', numel(this.warnings))];
        end
        end
        
        function prettyprint(this)
        %PRETTYPRINT Pretty-print this Results.
        fprintf('Results (%d items):\n', numel(this.results));
        for i = 1:size(this.results)
            rslt = this.results(i);
            if isequal(rslt.type, 'ResultSet')
                descr = sprintf('%s', dispstr(rslt.resultSet));
            elseif isequal(rslt.type, 'UpdateCount')
                descr = sprintf('Update: %d rows', rslt.updateCount);
            else
                descr = '<unknown>';
            end
            fprintf('  %d: %s: %s\n', i, rslt.type, descr);
        end
        if ~isempty(this.warnings)
            fprintf('%d SqlWarnings', numel(this.warnings));
        end
        end
        
        function out = summaryString(this)
        items = {};
        for i = 1:numel(this.results)
            items{i} = summaryString(this.results(i)); %#ok<AGROW>
        end
        if isempty(items)
            out = '(no results)';
        else
            out = strjoin(items, ', ');
        end
        end
    end
    
end