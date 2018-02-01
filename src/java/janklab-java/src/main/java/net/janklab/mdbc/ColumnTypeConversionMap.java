package net.janklab.mdbc;

import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import static java.util.Objects.requireNonNull;
import java.util.Set;

/**
 * A lookup map for selecting the column type conversion to be used for a given column. This is a
 * chained-lookup map, allowing lookups to fall back to an underlying backup/default map when the
 * lookup in the current map fails.
 *
 * The conversion lookup is done based on four factors, in order of precedence: 
 * <ol>
 *   <li> Column name 
 *   <li> Column index 
 *   <li> Column vendor database-specific type name 
 *   <li> Column SQL type 
 * </ol>
 * If none of these factors matches in a particular level,
 * the lookup is passed on to the current map's fallback map, if one exists.
 *
 * The resulting conversion is represented by name as a String.
 *
 * Each instance has a label. This label is used only for display and debugging 
 * purposes; it does not affect lookup behavior.
 */
public class ColumnTypeConversionMap {

  public final String label;
  private final ColumnTypeConversionMap fallbackMap;
  public final Map<String, String> byColName = new LinkedHashMap<>();
  public final Map<Integer, String> byColIndex = new LinkedHashMap<>();
  public final Map<String, String> byVendorType = new LinkedHashMap<>();
  public final Map<SqlType, String> bySqlType = new LinkedHashMap<>();

  public ColumnTypeConversionMap(String label) {
    this(label, null);
  }

  public ColumnTypeConversionMap(String label, ColumnTypeConversionMap fallbackMap) {
    this.label = label;
    this.fallbackMap = fallbackMap;
  }

  /**
   * Look up the conversion for a column with certain attributes. Returns
   *
   * @param colIndex
   * @param colName
   * @param sqlType
   * @param vendorType
   * @return The relevant conversion name, or null if no matching conversion was found in the map.
   */
  public String lookupConversion(int colIndex, String colName, SqlType sqlType,
          String vendorType) {
    if (byColName.containsKey(colName)) {
      return byColName.get(colName);
    }
    if (byColIndex.containsKey(colIndex)) {
      return byColIndex.get(colIndex);
    }
    if (byVendorType.containsKey(vendorType)) {
      return byVendorType.get(vendorType);
    }
    if (bySqlType.containsKey(sqlType)) {
      return bySqlType.get(sqlType);
    }
    if (fallbackMap != null) {
      return fallbackMap.lookupConversion(colIndex, colName, sqlType, vendorType);
    }
    return null;
  }

  public void registerForName(String colName, String conversionName) {
    requireNonNull(colName);
    requireNonNull(conversionName);
    byColName.put(colName, conversionName);
  }

  public void registerForIndex(int colIndex, String conversionName) {
    requireNonNull(conversionName);
    byColIndex.put(colIndex, conversionName);
  }
  
  public void registerForSqlType(SqlType sqlType, String conversionName) {
    requireNonNull(conversionName);
    bySqlType.put(sqlType, conversionName);
  }
  
  public void registerForVendorType(String vendorType, String conversionName) {
    requireNonNull(vendorType);
    requireNonNull(conversionName);
    byVendorType.put(vendorType, conversionName);
  }
  
  /**
   * Gets a String containing debugging info about this's state. Includes all
   * the registered mappings.
   * @return String
   */
  public String debugDump() {
    return debugDumpImpl(new MapAccumulator());
  }
  
  private String debugDumpImpl(MapAccumulator accum) {
    StringBuilder sb = new StringBuilder();
    sb.append(label).append(":\n");
    if (byColName.isEmpty() && byColIndex.isEmpty() && byVendorType.isEmpty()
            && bySqlType.isEmpty()) {
      sb.append("  (no entries)\n");
    }
    if (!byColName.isEmpty()) {
      sb.append("  By column name:\n");
      for (String key : byColName.keySet()) {
        String str = String.format("    %s -> %s", key, byColName.get(key));
        if (accum.byColName.contains(key)) {
          str = str + " (shadowed)";
        }
        sb.append(str).append("\n");
        accum.byColName.add(key);
      }
    }
    if (!byColIndex.isEmpty()) {
      sb.append("  By column index:\n");
      for (Integer key : byColIndex.keySet()) {
        String str = String.format("    %s -> %s", key, byColIndex.get(key));
        if (accum.byColIndex.contains(key)) {
          str = str + " (shadowed)";
        }
        sb.append(str).append("\n");
        accum.byColIndex.add(key);
      }
    }
    if (!byVendorType.isEmpty()) {
      sb.append("  By vendor data type:\n");
      for (String key : byVendorType.keySet()) {
        String str = String.format("    %s -> %s", key, byVendorType.get(key));
        if (accum.byVendorType.contains(key)) {
          str = str + " (shadowed)";
        }
        sb.append(str).append("\n");
        accum.byVendorType.add(key);
      }
    }
    if (!bySqlType.isEmpty()) {
      sb.append("  By SQL data type:\n");
      for (SqlType key : bySqlType.keySet()) {
        String str = String.format("    %s -> %s", key, bySqlType.get(key));
        if (accum.bySqlType.contains(key)) {
          str = str + " (shadowed)";
        }
        sb.append(str).append("\n");
        accum.bySqlType.add(key);
      }
    }
    if (fallbackMap != null) {
      sb.append(fallbackMap.debugDumpImpl(accum));
    }
    return sb.toString();
  }
  
  /**
   * Used internally by debugDumpImpl().
   */
  private static class MapAccumulator {
    final Set<String> byColName = new HashSet<>();
    final Set<Integer> byColIndex = new HashSet<>();
    final Set<String> byVendorType = new HashSet<>();
    final Set<SqlType> bySqlType = new HashSet<>();
  }
}
