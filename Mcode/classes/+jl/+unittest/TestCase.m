classdef TestCase < matlab.unittest.TestCase
    % A custom extension of Matlab's TestCase
    %
    % This provides a couple convenience methods that extend Matlab's TestCase.
    
    methods
        function v(this, condition, diagnosticMessage)
        %V An alias for verifyTrue()
        %
        % This is just an alias for verifyTrue(). This lets you convert code
        % like this:
        %   t.verifyTrue(condition)
        % To the terser:
        %   t.v(condition)
        %
        % This alias is provided because verifyTrue() is used so much.
        % 
        narginchk(2,3);
        if nargin == 2
            this.verifyTrue(condition);
        else
            this.verifyTrue(condition, diagnosticMessage);
        end
        end
        
        function verifyEqualN(this, actual, expected, diagnosticMessage)
        narginchk(3, 4);
        if nargin == 3
            this.verifyTrue(isequaln(actual, expected));
        else
            this.verifyTrue(isequaln(actual, expected), diagnosticMessage);
        end
        end
    end
    
end
    