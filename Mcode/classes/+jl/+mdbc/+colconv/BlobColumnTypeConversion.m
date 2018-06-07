classdef BlobColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.BlobToBytesColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.mdbc.colconv.BinaryColumnFetcher;
        end
    end
end