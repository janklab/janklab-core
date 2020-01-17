classdef BinaryColumnTypeConversion < jl.sql.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.BinaryColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.sql.colconv.BinaryColumnFetcher;
        end
    end
end