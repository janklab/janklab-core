classdef SystemTest < matlab.unittest.TestCase
    % Tests the jl.util.System class
    
    methods (Test)
        function testGetpid(t)
        % Tests getpid()
        
        pid = jl.util.System.getpid();
        t.verifyTrue(true, 'getpid() returned');
        t.verifyTrue(isscalar(pid), 'getpid() returned a scalar');
        t.verifyClass(pid, 'double');
        t.verifyEqual(pid, floor(pid), 'gitpid() returned an integer');
        
        % Is there another way we can get the current PID to verify the results?
        % Not that I can think of, without compiling special code for it.
        % Oh well.
        end
        
        function testSleep(t)
        %Tests sleep()
        
        t0 = tic;
        jl.util.System.sleep(0.5);
        te = toc(t0);
        
        % Allow a wide margin of error on the upside so this still passes on
        % heavily loaded systems
        t.verifyTrue(te > 0.3 && te < 3.0, ...
            'sleep() slept for a reasonable amount of time');
        
        end
    end
    
end