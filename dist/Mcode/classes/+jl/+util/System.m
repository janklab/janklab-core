classdef System
    %SYSTEM System-level utilities
    
    methods (Static)
        
        function out = getpid()
        %GETPID Get the process ID of this Matlab process
        %
        % out = jl.util.System.getPid()
        %
        % Returns the processId of this Matlab process as a double.
        runtimeBean = java.lang.management.ManagementFactory.getRuntimeMXBean();
        procName = char(runtimeBean.getName());
        procNumStr = regexprep(procName, '@.*', '');
        out = str2double(procNumStr);
        end
        
    end
end