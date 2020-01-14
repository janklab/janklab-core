classdef DoubleParamConversion < jl.sql.ParamConversion
    
    methods
        function out = getBinder(this)
            out = net.janklab.mdbc.params.DoubleParamBinder;
        end
    end
    
end