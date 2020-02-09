classdef util
    %UTIL Time-related utilities
    
    methods (Static)
      
        function out = javaLocalDateTime2datetime(jdt)
        %JAVALOCALDATETIME2DATETIME Convert Java LocalDateTime to 
        %
        % NOTE: This conversion is currently only precise to the second.
        datenums = net.janklab.time.TimeUtil.javaLocalDateTime2datenum(jdt);
        out = datetime(datenums, 'ConvertFrom', 'datenum');
        end
        
        function out = ismidnight(x)
          % True if value is at midnight
          %
          % out = jl.time.util.ismidnight(x)
          %
          % You can use this as a heuristic to determine whether date/time
          % values represent date/times or just dates.
          %
          % Returns logical array the same size as x.
          if isstringy(x)
            x = datenum(x);
          end
          if isa(x, 'datetime')
            x = datenum(x);
          end
          if isnumeric(x)
            out = x == fix(x);
          else
            error('jl:InvalidInput', 'Invalid input type: %s', class(x));
          end
        end
        
    end
    
    methods (Access = private)
        function this = util()
        %UTIL Private constructor to suppress appearance in doco
        end
    end
end