classdef DoubleParamConversion < jl.mdbc.ParamConversion
    
    methods
        function out = getBinder(this)
        out = net.janklab.mdbc.params.DoubleParamBinder;
        end
    end
    
end