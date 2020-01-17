classdef LoudBigintToDoubleColumnTypeConversion < jl.sql.ColumnTypeConversion
    % An integer-to-double column conversion that warns on overflows
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.LoudBigintToDoubleColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.sql.colconv.DoubleColumnFetcher;
        end
    end
end