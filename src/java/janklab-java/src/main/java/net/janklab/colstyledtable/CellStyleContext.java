package net.janklab.colstyledtable;

import javax.swing.table.TableModel;
import java.util.HashSet;
import java.util.Set;

public abstract class CellStyleContext {

    private Set<CellStyleContextListener> listeners = new HashSet<>();

    public abstract CellStyle effectiveCellStyle(TableModel tm, int rowIndex, int columnIndex);

    public void addCellStyleContextListener(CellStyleContextListener listener) {
        listeners.add(listener);
    }

    public void removeCellStyleContextListener(CellStyleContextListener listener) {
        listeners.remove(listener);
    }

    public void fireCellStyleContextEvent() {
        CellStyleContextEvent evt = new CellStyleContextEvent(this);
        fireEvent(evt);
    }

    public void fireCellStyleContextEvent(int columnIndex) {
        CellStyleContextEvent evt = new CellStyleContextEvent(this, columnIndex);
        fireEvent(evt);
    }

    private void fireEvent(CellStyleContextEvent evt) {
        for (CellStyleContextListener listener : listeners) {
            listener.stateChanged(evt);
        }
    }
}
