classdef ObjectColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    % Conversion for types fetched and returned as Java objects
    
    methods
        function out = getColumnBuffer(this) %#ok<MANU>
        out = net.janklab.mdbc.colbuf.ObjectColumnBuffer();
        end
        
        function out = getColumnFetcher(this) %#ok<MANU>
        out = jl.mdbc.colconv.RawColumnFetcher;
        end
    end
end