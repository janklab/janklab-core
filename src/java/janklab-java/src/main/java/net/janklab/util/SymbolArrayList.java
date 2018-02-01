package net.janklab.util;

import org.apache.commons.collections.primitives.ArrayIntList;

/**
 * An ArrayList of Symbols, encoded as primitive integers.
 */
public class SymbolArrayList {
    private final ArrayIntList syms;

    public SymbolArrayList() {
        syms = new ArrayIntList();
    }
    
    public String getString(int i) {
        return Symbol.decodeSymbol(syms.get(i));
    }
    
    public int getSymbol(int i) {
        return syms.get(i);
    }
    
    public void add(String str) {
        syms.add(Symbol.encodeString(str));
    }
    
    public void add(int sym) {
        syms.add(sym);
    }
    
    public int[] getSymbols() {
        return syms.toArray();
    }
    
    public String[] getStrings() {
        return Symbol.decodeSymbols(syms.toArray());
    }
}
