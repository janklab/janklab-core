classdef SingleColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.FloatColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.mdbc.colconv.RawColumnFetcher;
        end
    end
end