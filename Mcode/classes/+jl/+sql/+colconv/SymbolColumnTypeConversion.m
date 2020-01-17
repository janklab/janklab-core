classdef SymbolColumnTypeConversion < jl.sql.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.SymbolColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.sql.colconv.SymbolColumnFetcher;
        end
    end
end