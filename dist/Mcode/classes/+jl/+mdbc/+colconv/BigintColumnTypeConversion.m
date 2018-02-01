classdef BigintColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.LongColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.mdbc.colconv.BigintColumnFetcher;
        end
    end
end