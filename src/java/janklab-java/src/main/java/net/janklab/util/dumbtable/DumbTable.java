package net.janklab.util.dumbtable;

import javax.swing.event.TableModelListener;
import javax.swing.table.TableModel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static java.util.Objects.requireNonNull;

/**
 * A "dumb" table that is a simple container of tabular data. It holds columns of
 * data, but does not implement any relational logic. It is a read-only, immutable
 * object.
 */
public class DumbTable implements TableModel {

    private final List<String> columnNames;
    private final List<DumbTableColumn> columns;

    public DumbTable(String[] columnNames, DumbTableColumn[] columnData) {
        this(Arrays.asList(columnNames), Arrays.asList(columnData));
    }

    public DumbTable(List<String> columnNames, List<DumbTableColumn> columnData) {
        requireNonNull(columnNames);
        requireNonNull(columnData);
        this.columnNames = new ArrayList<>(columnNames);
        this.columns = new ArrayList<>(columnData);
    }

    @Override
    public int getRowCount() {
        return columns.isEmpty() ? 0 : columns.get(0).getRowCount();
    }

    @Override
    public int getColumnCount() {
        return columns.size();
    }

    @Override
    public String getColumnName(int columnIndex) {
        return columnNames.get(columnIndex);
    }

    @Override
    public Class<?> getColumnClass(int columnIndex) {
        return columns.get(columnIndex).getDataClass();
    }

    @Override
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return false;
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        return columns.get(columnIndex).getValueAt(rowIndex);
    }

    @Override
    public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
        throw new UnsupportedOperationException("Cells in DumbTable are not editable.");
    }

    @Override
    public void addTableModelListener(TableModelListener l) {
        // Ignore: DumbTable is immutable, so it never fires table events.
    }

    @Override
    public void removeTableModelListener(TableModelListener l) {
        // Ignore: DumbTable is immutable, so it never fires table events.
    }
}
