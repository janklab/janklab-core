classdef LocalDateTest < matlab.unittest.TestCase
    % Tests the jl.time.localdate class
    %
    % See also: jl.time.localdate
    
    methods (Test)
        
        function testZeroArgConstructor(this)
        % Test the localdate zero-arg constructor behavior
        
        dt = jl.time.localdate;
        this.verifyNotEmpty(dt);
        this.verifySize(dt, [1 1]);
        this.verifyTrue(isnat(dt), 'Default constructor returns a NaT');
        this.verifyTrue(isnan(dt), 'Default constructor isnan() is true');
        end
        
        function testStringConstructor(this)
        % Test string-conversion constructor behavior
        
        dateStr = '1/14/2018';
        dt = jl.time.localdate(dateStr);
        this.verifyInstanceOf(dt, 'jl.time.localdate');
        expectedDatenum = datenum(dateStr);
        this.verifyEqual(datenum(dt), expectedDatenum, ...
            '1/14/2018 has correct datenum conversion');
        this.verifyEqual(year(dt), 2018);
        this.verifyEqual(month(dt), 1);
        this.verifyEqual(day(dt), 14);
        end
    end
    
end