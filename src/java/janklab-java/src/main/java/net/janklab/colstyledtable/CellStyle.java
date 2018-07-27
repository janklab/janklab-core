package net.janklab.colstyledtable;

/**
 * A cell style, that knows how to convert objects into StyledCellText.
 *
 * CellStyle objects must be immutable, to avoid issues with change notification
 * and object aliasing.
 */
public abstract class CellStyle {
    /**
     * Format and style the value from a cell.
     * @param value The cell's value; may be any type.
     * @return StyledCellText representing that value
     */
    public abstract StyledCellText style(Object value);
}
