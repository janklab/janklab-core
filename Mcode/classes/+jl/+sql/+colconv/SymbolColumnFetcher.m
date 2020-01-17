classdef SymbolColumnFetcher
    % Fetches columns that were returned encoded symbols in int[].
    methods
        function out = fetchColumn(this, columnBufferData, columnMetaData)
        symbolCodes = columnBufferData;
        out = symbol.ofSymbolCode(symbolCodes);
        end
    end
end