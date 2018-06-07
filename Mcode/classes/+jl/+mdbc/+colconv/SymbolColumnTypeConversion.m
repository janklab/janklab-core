classdef SymbolColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.SymbolColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.mdbc.colconv.SymbolColumnFetcher;
        end
    end
end