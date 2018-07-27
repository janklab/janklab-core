package net.janklab.colstyledtable;

import javax.swing.table.TableModel;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.*;

import static java.util.Objects.requireNonNull;

public class ColumnarCellStyleContext extends CellStyleContext {

    public static final List<Class<?>> INTEGER_TYPES = Arrays.asList(new Class<?>[] {
            Byte.class, Short.class, Integer.class, Long.class, BigInteger.class
    });
    public static final List<Class<?>> FRACTIONAL_TYPES = Arrays.asList(new Class<?>[] {
            Float.class, Double.class, BigDecimal.class
    });
    public static final List<Class<?>> NUMERIC_TYPES = Arrays.asList(new Class<?>[] {
            Number.class, Float.class, Double.class,
            Byte.class, Short.class, Integer.class, Long.class,
            BigInteger.class, BigDecimal.class
    });

    private Map<Integer,CellStyle> byColumnIndex = new TreeMap<>();
    private Map<String,CellStyle> byColumnName = new TreeMap<>();
    private Map<Class<?>,CellStyle> byColumnClass = new HashMap<>();

    private CellStyle defaultStyle = new GeneralCellStyle();

    /** Get the CellStyle to use for a given cell in a given TableModel.
     * The TableModel is used to get the column's name and class.
     * @param tm TableModel that the cell is in
     * @param rowIndex row index of the cell
     * @param columnIndex column index of the cell
     * @return CellStyle to use for rendering that cell's value; never null
     */
    public CellStyle effectiveCellStyle(TableModel tm, int rowIndex, int columnIndex) {
        requireNonNull(tm);

        if (byColumnIndex.containsKey(columnIndex)) {
            return byColumnIndex.get(columnIndex);
        }
        String columnName = tm.getColumnName(columnIndex);
        if (byColumnName.containsKey(columnName)) {
            return byColumnName.get(columnName);
        }
        Class<?> columnClass = tm.getColumnClass(columnIndex);;
        if (byColumnClass.containsKey(columnClass)) {
            return byColumnClass.get(columnClass);
        }
        return defaultStyle;
    }

    public void setStyleForColumnIndex(int columnIndex, CellStyle style) {
        requireNonNull(style);
        byColumnIndex.put(columnIndex, style);
        fireCellStyleContextEvent(columnIndex);
    }

    public void removeStyleForColumnIndex(int columnIndex) {
        byColumnIndex.remove(columnIndex);
        fireCellStyleContextEvent(columnIndex);
    }

    public void setStyleForColumnName(String columnName, CellStyle style) {
        requireNonNull(style);
        byColumnName.put(columnName, style);
        fireCellStyleContextEvent();
    }

    public void removeStyleForColumnName(String columnName) {
        byColumnName.remove(columnName);
        fireCellStyleContextEvent();
    }

    public void setStyleForColumnClass(Class<?> columnClass, CellStyle style) {
        requireNonNull(style);
        byColumnClass.put(columnClass, style);
        fireCellStyleContextEvent();
    }

    public void removeStyleForColumnClass(Class<?> columnClass) {
        byColumnClass.remove(columnClass);
        fireCellStyleContextEvent();
    }

    public void setDefaultStyle(CellStyle style) {
        requireNonNull(style);
        defaultStyle = style;
        fireCellStyleContextEvent();
    }

    /**
     * Sets the style for all numeric types. This is a set of well-known types that are subclasses
     * of Number. This is a convenience method; it has the same effect of setting the style for all
     * the numeric types individually.
     */
    public void setStyleForNumericTypes(CellStyle style) {
        for (Class<?> klass : NUMERIC_TYPES) {
            setStyleForColumnClass(klass, style);
        }
    }

    /**
     * Sets the style for multiple column classes at once.
     * @param classes Column classes to set the style for.
     * @param style Style to use for those column classes.
     */
    public void setStyleForColumnClasses(List<Class<?>> classes, CellStyle style) {
        for (Class klass : classes) {
            setStyleForColumnClass(klass, style);
        }
    }

}
