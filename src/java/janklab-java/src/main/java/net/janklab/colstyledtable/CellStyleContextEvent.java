package net.janklab.colstyledtable;

/**
 * An event indicating a change in state in a CellStyleContext object. This means that the
 * effective style mapping has changed.
 */
public class CellStyleContextEvent {
    private final CellStyleContext source;
    private final int columnIndex;

    /**
     * Constructs a new event that indicates all columns may have been affected.
     * @param source source of the event.
     */
    CellStyleContextEvent(CellStyleContext source) {
        this.source = source;
        this.columnIndex = -1;
    }

    /**
     * Constructs a new event indicating that a single column was affected.
     * @param source source of the event.
     * @param columnIndex index of the affected column.
     */
    CellStyleContextEvent(CellStyleContext source, int columnIndex) {
        this.source = source;
        this.columnIndex = columnIndex;
    }

    /**
     * Get the index of the affected column. May be -1 to indicate that all columnns may
     * have been affected.
     * @return index of the column, or -1 to indicate all columns.
     */
    public int getColumnIndex() {
        return columnIndex;
    }

    /**
     * Gets the source of this event. This is the CellStyleContext whose state changed.
     * @return source of this event.
     */
    public CellStyleContext getSource() {
        return source;
    }
}
