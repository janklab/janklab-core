package net.janklab.etl.csvtable;

/**
 * A buffer for a single column of data coming from a table in a CSV.
 */
public abstract class ColBuffer {
    /**
     * Add a new value based on parsing the contents of a cell.
     * @param cellValue The String contents of the cell to be parsed
     * @throws IllegalArgumentException 
     */
    public abstract void addValue(String cellValue) throws IllegalArgumentException;
    /**
     * Gets the buffered column values.
     * @return An array of some sort; particular class is subclass-specific. It will 
     * be of a specific array type so that the type can be determined at run time by 
     * inspection of the returned object.
     */
    public abstract Object getValues();
}
