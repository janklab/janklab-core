classdef StringParamConversion < jl.sql.ParamConversion
    
    %#ok<*INUSL>
    
    methods
        function out = convertParamData(this, paramData)
            out = string(paramData);
        end
        
        function out = getBinder(this)
            out = net.janklab.mdbc.params.StringParamBinder;
        end
    end
    
end