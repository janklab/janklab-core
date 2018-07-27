package net.janklab.colstyledtable;

/**
 * A listener that can be notified of changes in a CellStyleContext's
 * state.
 */
public interface CellStyleContextListener {
    void stateChanged(CellStyleContextEvent evt);
}
