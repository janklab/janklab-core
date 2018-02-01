classdef Num2cellstrTest < matlab.unittest.TestCase
    % Tests num2cellstr() functionality
    %
    % This test case uses the top-level num2cellstr() wrapper instead of
    % jl.util.num2cellstr() for brevity. The results should be the same.
    
    methods (Test)
        
        function testSomeNumbers(this)
        
        cases = {
            42              {'42'}
            1:4             {'1' '2' '3' '4'}
            [1 2 3.1234]    {'1' '2' '3.1234'}
            1/12345         {'8.1004e-05'}
            NaN             {'NaN'}
            Inf             {'Inf'}
            -Inf            {'-Inf'}
            1 + 0.2i        {'1+0.2i'}
            [1:5]'          {'1' '2' '3' '4' '5'}'
            };
        
        for i = 1:size(cases, 1)
            [input,expected] = cases{i,:};
            output = num2cellstr(input);
            this.verifyEqual(output, expected);
        end
        
        end
    end
end