package net.janklab.util;

import com.google.common.collect.Lists;
import org.apache.commons.collections.primitives.ArrayIntList;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * An ArrayList that looks like a Matlab categorical array.
 *
 * The codes in this object are zero-indexed, not one-indexed. Make sure you adjust if you're doing
 * a conversion from Matlab categoricals.
 */
public class CategoricalArrayList {

    private final ArrayIntList codes = new ArrayIntList();
    private final Map<String, Integer> codeMap = new HashMap<>();
    private final List<String> levels = new ArrayList<>();

    public CategoricalArrayList() {
    }

    public CategoricalArrayList(int[] codes, String[] levels) {
        int n = levels.length;
        int maxCode = n - 1;
        this.levels.addAll(Lists.newArrayList(levels));
        // Sigh. We have to do a copy, I guess, because the conversion constructor isn't present
        // in the version of Apache Commons that ships with Matlab.
        for (int code : codes) {
            if (code < 0) {
                throw new IllegalArgumentException("Code out of range: " + code + " is less than 0.");
            }
            if (code > maxCode) {
                throw new IllegalArgumentException(("Code out of range: " + code " is greater than max code "
                    +maxCode + " (for " + n + " levels)"));
            }
            this.codes.add(code);
        }
        for (int i = 0; i < levels.length; i++) {
            codeMap.put(levels[i], i);
        }
    }

    public CategoricalArrayList(String[] values) {
        addAll(values);
    }

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

    public void addAll(String[] strs) {
        for (String str : strs) {
            add(str);
        }
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

    public int size() {
        return codes.size();
    }

    public String[] toStringArray() {
        int n = this.size();
        String[] out = new String[n];
        for (int i = 0; i < n; i++) {
            out[i] = levels.get(codes.get(i));
        }
        return out;
    }

}
