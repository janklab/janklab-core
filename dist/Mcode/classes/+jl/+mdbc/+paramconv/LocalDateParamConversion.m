classdef LocalDateParamConversion < jl.mdbc.ParamConversion
    
    methods
        function out = convertParamData(this, paramData)
        out = datenum(paramData);
        end
        
        function out = getBinder(this)
        out = net.janklab.mdbc.params.LocaldatenumToSqlDateParamBinder;
        end
    end
    
end