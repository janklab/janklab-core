classdef Result
    % A single result (ResultSet or update count) from a statement
    
    properties
        type = 'Undefined' % Type of result ('ResultSet' or 'UpdateCount' or 'Undefined')
        resultSet  % The result set as table or relation, if this is a ResultSet
        updateCount (1,1) double = NaN % Update count, if this is an UpdateCount
    end
    
    methods
        function this = Result(in)
            % Construct a new Result
            if nargin == 0
                return;
            end
            if isnumeric(in)
                mustBeScalar(in);
                this.type = 'UpdateCount';
                this.updateCount = in;
            elseif isa(in, 'relation')
                this.type = 'ResultSet';
                this.resultSet = in;
            elseif isa(in, 'table')
                this.type = 'ResultSet';
                this.resultSet = in;
            else
                error('jl:InvalidInput', 'Invalid input type: %s', class(in));
            end
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
            switch this.type
                case 'Undefined'
                    out = 'Result (Undefined)';
                case 'ResultSet'
                    out = sprintf('Result (ResultSet): %s', dispstr(this.resultSet));
                case 'UpdateCount'
                    out = sprintf('Result (UpdateCount): %d', this.updateCount);
                otherwise
                    out = 'Result: <invalid type>';
            end
        end
        
        function out = summaryString(this)
            mustBeScalar(this);
            switch this.type
                case 'Undefined'
                    out = '(Undefined)';
                case 'ResultSet'
                    out = sprintf('%d rows', nrows(this.resultSet));
                case 'UpdateCount'
                    out = sprintf('%d updates', this.updateCount);
                otherwise
                    out = '<invalid type>';
            end
        end
        
        function this = set.type(this, type)
          mustBeMember(type, {'ResultSet','UpdateCount','Undefined'});
          this.type = type;
        end
        
    end
    
end
