package net.janklab.util.dumbtable;

/**
 * A column of data in a DumbTable.
 */
public interface DumbTableColumn {
    public Class<?> getDataClass();
    public Object getValueAt(int rowIndex);
    public int getRowCount();
}
