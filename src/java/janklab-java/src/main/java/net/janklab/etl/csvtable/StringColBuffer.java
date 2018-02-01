package net.janklab.etl.csvtable;

import java.util.ArrayList;

/**
 *
 */
public class StringColBuffer extends ColBuffer {
    private final ArrayList<String> buf = new ArrayList<>();

    @Override
    public void addValue(String cellValue) throws IllegalArgumentException {
        // Assume memory is more important than speed, especially for the Matlab-Java
        // layer transfer
        cellValue = cellValue.intern();
        buf.add(cellValue);
    }
    
    @Override
    public String[] getValues() {
        return buf.toArray(new String[0]);
    }

}
