classdef LocalTimeParamConversion < jl.mdbc.ParamConversion
    
    methods
        function out = convertParamData(this, paramData)
        out = floor(getNanosOfDay(paramData) / 10^6);
        end
        
        function out = getBinder(this)
        out = net.janklab.mdbc.params.TimeParamBinder;
        end
    end
    
end