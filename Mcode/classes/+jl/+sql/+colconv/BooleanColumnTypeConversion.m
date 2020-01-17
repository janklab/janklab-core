classdef BooleanColumnTypeConversion < jl.sql.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.BooleanColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.sql.colconv.RawColumnFetcher;
        end
    end
end