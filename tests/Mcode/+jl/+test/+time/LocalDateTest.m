classdef LocalDateTest < matlab.unittest.TestCase
    % Tests the jl.time.localdate class
    %
    % See also: jl.time.localdate
    
    methods (Test)
        
        function testZeroArgConstructor(t)
        % Test the localdate zero-arg constructor behavior
        
        dt = jl.time.localdate;
        t.verifyNotEmpty(dt);
        t.verifySize(dt, [1 1]);
        t.verifyTrue(isnat(dt), 'Default constructor returns a NaT');
        t.verifyTrue(isnan(dt), 'Default constructor isnan() is true');
        end
        
        function testStringConstructor(t)
        % Test string-conversion constructor behavior
        
        dateStr = '1/14/2018';
        dt = jl.time.localdate(dateStr);
        t.verifyInstanceOf(dt, 'jl.time.localdate');
        expectedDatenum = datenum(dateStr);
        t.verifyEqual(datenum(dt), expectedDatenum, ...
            '1/14/2018 has correct datenum conversion');
        t.verifyEqual(year(dt), 2018);
        t.verifyEqual(month(dt), 1);
        t.verifyEqual(day(dt), 14);
        end
    end
    
end