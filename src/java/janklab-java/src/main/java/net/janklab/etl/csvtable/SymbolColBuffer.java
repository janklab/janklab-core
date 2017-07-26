package net.janklab.etl.csvtable;

import net.janklab.util.SymbolArrayList;

/**
 * Strings buffered as Symbols.
 */
class SymbolColBuffer extends ColBuffer {

    /** The buffered data. */
    private final SymbolArrayList buf = new SymbolArrayList();

    @Override
    public void addValue(String cellValue) throws IllegalArgumentException {
        buf.add(cellValue);
    }

    @Override
    public Object getValues() {
        return buf;
    }
    
    

}
