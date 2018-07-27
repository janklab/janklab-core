package net.janklab.colstyledtable;

import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;

import static java.util.Objects.requireNonNull;

public class CellStylingTableModelAdapter extends AbstractTableModel {

    private TableModel underlyingModel = new DefaultTableModel();
    private CellStyleContext cellStyleContext;
    private TableModelListener myTableModelListener = new UnderlyingTableModelListener();
    private CellStyleContextListener myCellStyleContextListener = new MyCellStyleContextListener();

    public CellStylingTableModelAdapter(CellStyleContext cellStyleContext) {
        requireNonNull(cellStyleContext);
        this.cellStyleContext = cellStyleContext;
        cellStyleContext.addCellStyleContextListener(myCellStyleContextListener);
    }

    public CellStylingTableModelAdapter(CellStyleContext cellStyleContext, TableModel underlyingModel) {
        this(cellStyleContext);
        setUnderlyingModel(underlyingModel);
    }

    public void setUnderlyingModel(TableModel model) {
        requireNonNull(model);
        model.removeTableModelListener(myTableModelListener);
        this.underlyingModel = model;
        model.addTableModelListener(myTableModelListener);
        fireTableStructureChanged();
    }

    @Override
    public int getRowCount() {
        return underlyingModel.getRowCount();
    }

    @Override
    public int getColumnCount() {
        return underlyingModel.getColumnCount();
    }

    @Override
    public String getColumnName(int columnIndex) {
        return underlyingModel.getColumnName(columnIndex);
    }

    @Override
    public Class<?> getColumnClass(int columnIndex) {
        //return underlyingModel.getColumnClass(columnIndex);
        return StyledCellText.class;
    }

    @Override
    public StyledCellText getValueAt(int rowIndex, int columnIndex) {
        CellStyle style = cellStyleContext.effectiveCellStyle(underlyingModel, rowIndex, columnIndex);
        return style.style(underlyingModel.getValueAt(rowIndex, columnIndex));
    }

    private class UnderlyingTableModelListener implements TableModelListener {

        @Override
        public void tableChanged(TableModelEvent e) {
            fireTableChanged(e);
        }
    }

    private class MyCellStyleContextListener implements CellStyleContextListener {

        @Override
        public void stateChanged(CellStyleContextEvent evt) {
            if (evt.getColumnIndex() == -1) {
                fireTableDataChanged();
            } else {
                fireTableChanged(new TableModelEvent(CellStylingTableModelAdapter.this,
                        0, getRowCount()-1, evt.getColumnIndex()));
            }
        }
    }
}
