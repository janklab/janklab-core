package net.janklab.util;

import java.util.HashMap;
import java.util.Map;

/**
 * Backing for the compact symbol string representation at the Matlab layer. This
 * class maintains the global symbol table and provides block translation of 
 * numeric symbol ids into their corresponding strings.
 */
public class Symbol {
    static Map<String,Integer> symbolMap = new HashMap<>();
    static Map<Integer,String> reverseMap = new HashMap<>();
    private static int nextSymbol = 0;
    
    static {
        // Special case: 0 is always the empty string, so we always have a known 
        // valid default value for objects at the Matlab layer
        encodeString("");
    }
    
    public static String[] decodeSymbols(int[] symbols) {
        String[] out = new String[symbols.length];
        for (int i = 0; i < symbols.length; i++) {
            out[i] = reverseMap.get(symbols[i]);
        }
        return out;
    }
    
    public static String decodeSymbol(int symbol) {
        return reverseMap.get(symbol);
    }
    
    public static int[] encodeStrings(String[] strings) {
        int[] out = new int[strings.length];
        for (int i = 0; i < strings.length; i++) {
            out[i] = encodeString(strings[i]);
        }
        return out;
    }
    
    public static int encodeString(String string) {
        Integer symbol = symbolMap.get(string);
        if (symbol == null) {
            // new string value
            symbol = nextSymbol++;
            string = string.intern();
            symbolMap.put(string, symbol);
            reverseMap.put(symbol, string);
        }
        return symbol;
    }
}
