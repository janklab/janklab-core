classdef LoggingExample
    % An example of how to use logging in Janklab
    %
    % Examples:
    % jl.log.LoggingExample.helloWorld()
    
    methods (Static)
        function helloWorld()
        % Logs 'Hello, world!'
        jl.log.info('Hello, world!');
        jl.log.debug('This debug message will not appear by default.');
        end
    end
    
end