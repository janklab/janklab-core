classdef SymbolParamConversion < jl.sql.ParamConversion
    
    methods
        function out = convertParamData(this, paramData)
        paramData = symbol(paramData);
        out = paramData.symbolCode;
        end
        
        function out = getBinder(this)
        out = net.janklab.mdbc.params.SymbolParamBinder;
        end
    end
end