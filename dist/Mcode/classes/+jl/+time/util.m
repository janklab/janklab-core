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
    end
    
    methods (Access = private)
        function this = util()
        %UTIL Private constructor to suppress appearance in doco
        end
    end
end