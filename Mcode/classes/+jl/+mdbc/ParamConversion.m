classdef ParamConversion
    
    methods (Abstract)
        out = getBinder(this);
    end
    
    methods
        function out = convertParamData(this, paramData)
        %CONVERTPARAMDATA
        
        % The default conversion is to do nothing
        out = paramData;
        end
    end
end
    