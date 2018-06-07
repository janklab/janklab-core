classdef UuidColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    %UUIDCOLUMNTYPECONVERSION Supports Postgres's UUID type
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.ObjectColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.mdbc.postgres.UuidColumnFetcher;
        end
    end    
end