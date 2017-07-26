
package net.janklab.etl.csvtable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Maps column names or positions to data types. This allows setting column types
 * based on both column name or column position. Name-based mappings take 
 * precedence.
 */
public class ColTypeMap {
    /** Types for columns identified by name. */
    private final Map<String,ColType> typesByName = new HashMap<>();
    /** Types for columns identified by offset. */
    private final Map<Integer,ColType> typesByIndex = new HashMap<>();
    /** Default type, if not specified by name or offset. */
    private ColType defaultType = ColType.AUTO;
    
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        if (typesByName.size() > 0) {
            sb.append("by name: ");
            List<String> strs = new ArrayList<>();
            typesByName.keySet().forEach((key) -> {
                strs.add(key + ": " + typesByName.get(key));
            });
            sb.append(strs).append(" ");
        }
        if (typesByIndex.size() > 0) {
            sb.append("by index: ");
            List<String> strs = new ArrayList<>();
            typesByIndex.keySet().forEach((key) -> {
                strs.add(key + ": " + typesByIndex.get(key));
            });
            sb.append(strs).append(" ");
        }
        sb.append("default: ").append(defaultType);
        sb.append("]");
        return sb.toString();
    }
    
    public void setTypeByName(String colName, ColType type) {
        Objects.requireNonNull(type);
        typesByName.put(colName, type);
    }
    
    public void setTypeByOffset(int offset, ColType type) {
        Objects.requireNonNull(type);        
        typesByIndex.put(offset, type);
    }
    
    public void setDefaultType(ColType type) {
        Objects.requireNonNull(type);
        defaultType = type;
    }
    
    public ColType getTypeForColumn(int offset, String name) {
        if (typesByName.containsKey(name)) {
            return typesByName.get(name);
        }
        if (typesByIndex.containsKey(offset)) {
            return typesByIndex.get(offset);
        }
        return defaultType;
    }
}
