classdef HelloWorldTest < matlab.unittest.TestCase
    %HELLOWORLDTEST A trivial test case to see if the unit tests are running
    %
    % If this test suite fails, something is seriously wrong.
    
    methods (Test)
        
        function testHelloWorld(this)
        %TESTHELLOWORLD A trivial example test
        str = 'Hello, world!';
        this.verifyEqual(str, str, ...
            '''Hello, world!'' is equal to itself');
        end
        
    end
end