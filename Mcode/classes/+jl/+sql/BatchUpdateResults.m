classdef BatchUpdateResults
    %BATCHUPDATERESULTS The results of doing a batch update
    
    properties
        % An array of update counts; NaN to indicate the count is unknown
        updateCounts double
        % An array of flags indicating whether each statement in the batch
        % succeeded
        isSuccess logical
    end
    
    properties (Dependent)
        totalUpdates
    end
    
    methods
        function disp(this)
        % Custom display
        disp(dispstr(this));
        end
        
        function out = dispstr(this)
        % Custom display string
        if ~isscalar(this)
            dispf('%s %s', sizestr(this), class(this));
            return;
        end
        str = dispstrs(this);
        out = str{1};
        end
        
        function out = dispstrs(this)
        % Custom display strings
        out = cell(size(this));
        for i = 1:numel(this)
            out{i} = sprintf('BatchUpdateResults: %d updates, %d errors', ...
                sum(this(i).updateCounts), sum(double(~this(i).isSuccess)));
        end
        end
        
        function out = get.totalUpdates(this)
        out = sum(this.updateCounts);
        end
    end
    
    methods (Static)
        function out = ofJdbcUpdateCount(updates)
        % Convert a JDBC  update counts array to BatchUpdateResults
        out = jl.sql.BatchUpdateResults;
        out.isSuccess = updates >= 0 | updates == java.sql.Statement.SUCCESS_NO_INFO;
        u = double(updates);
        u(u < 0) = NaN;
        out.updateCounts = u;
        end
    end
end