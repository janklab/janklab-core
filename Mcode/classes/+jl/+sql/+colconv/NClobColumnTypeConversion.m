classdef NClobColumnTypeConversion < jl.sql.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.ClobToStringColumnBuffer();
        out.useNClob = true;
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.sql.colconv.CharColumnFetcher;
        end
    end
end