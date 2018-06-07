classdef TimestampParamConversion < jl.mdbc.ParamConversion
    
    methods
        function out = convertParamData(this, paramData)
        mustBeType(paramData, 'jl.time.timestamp');
        datenums = datenum(paramData.date);
        nanosOfDay = paramData.time.getNanosOfDay();
        out = net.janklab.mdbc.colbuf.BufferedTimestampComponents( ...
            datenums, nanosOfDay);
        end
        
        function out = getBinder(this)
        out = net.janklab.mdbc.params.TimestampParamBinder;
        end
    end
    
end