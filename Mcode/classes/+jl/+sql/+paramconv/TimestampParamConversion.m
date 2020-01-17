classdef TimestampParamConversion < jl.sql.ParamConversion
    
    %#ok<*INUSL>
    %#ok<*MANU>
    
    methods
        function out = convertParamData(this, paramData)
            mustBeA(paramData, 'jl.time.timestamp');
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