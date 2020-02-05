package net.janklab.util;

import org.apache.commons.collections.primitives.ArrayIntList;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * An ArrayList that looks like a Matlab categorical array.
 */
public class CategoricalArrayList {

    private final ArrayIntList codes = new ArrayIntList();
    private Map<String, Integer> codeMap = new HashMap<>();
    private ArrayList<String> levels = new ArrayList<>();

    public int encode(String str) {
        if (codeMap.containsKey(str)) {
            return codeMap.get(str);
        } else {
            int code = levels.size();
            levels.add(str);
            codeMap.put(str, code);
            return code;
        }
    }

    public void add(String str) {
        codes.add(encode(str));
    }

    public int[] getCodes() {
        return codes.toArray(new int[0]);
    }

    public String[] getLevels() {
        return levels.toArray(new String[0]);
    }

    public String get(int index) {
        return levels.get(codes.get(index));
    }

    public int getCode(int index) {
        return codes.get(index);
    }

    public void set(int index, String val) {
        codes.set(index, encode(val));
    }

}
