classdef LoudBigDecimalToDoubleColumnTypeConversion < jl.mdbc.ColumnTypeConversion
    % A BigDecimal-to-double column conversion that warns on overflows/roundoffs
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.LoudBigDecimalToDoubleColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.mdbc.colconv.DoubleColumnFetcher;
        end
    end
end