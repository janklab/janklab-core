classdef SqlWarning
    % A SQL Warning message
    
    properties
        reason char = '';
        sqlState char = '';
        vendorCode double = NaN;
    end
    
    methods
        function this = SqlWarning(reason, sqlState, vendorCode)
            % Construct a new SqlWarning
            if nargin == 0
                return;
            end
            if nargin < 2 || isempty(sqlState);  sqlState = '';     end
            if nargin < 3 || isempty(vendorCode); vendorCode = NaN;  end
            this.reason = reason;
            this.sqlState = sqlState;
            this.vendorCode = vendorCode;
        end
        
        function disp(this)
            % Custom display
            disp(dispstr(this));
        end
        
        function out = dispstr(this)
            % Custom display string
            if ~isscalar(this)
                out = sprintf('%s %s', sizestr(this), class(this));
                return;
            end
            out = sprintf('SqlWarning: %s', this.reason);
            if ~isempty(this.sqlState)
                out = [out ' sqlState=''' this.sqlState ''''];
            end
            if ~isnan(this.vendorCode)
                out = [out ' ' sprintf('vendorCode=%d', this.vendorCode)];
            end
        end
    end
    
end