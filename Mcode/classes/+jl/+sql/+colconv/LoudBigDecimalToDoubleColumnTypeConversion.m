classdef LoudBigDecimalToDoubleColumnTypeConversion < jl.sql.ColumnTypeConversion
    % A BigDecimal-to-double column conversion that warns on overflows/roundoffs
    methods
        function out = getColumnBuffer(this)
        out = net.janklab.mdbc.colbuf.LoudBigDecimalToDoubleColumnBuffer();
        end
        
        function out = getColumnFetcher(this)
        out = jl.sql.colconv.DoubleColumnFetcher;
        end
    end
end