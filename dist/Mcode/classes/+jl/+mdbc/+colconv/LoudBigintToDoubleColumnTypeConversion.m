classdef LoudBigintToDoubleColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    % An integer-to-double column conversion that warns on overflows
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.LoudBigintToDoubleColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.mdbc.colconv.DoubleColumnFetcher;
        end
    end
end