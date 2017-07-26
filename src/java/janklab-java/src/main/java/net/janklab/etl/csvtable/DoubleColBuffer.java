package net.janklab.etl.csvtable;

import org.apache.commons.collections.primitives.ArrayDoubleList;

/**
 * A column buffer holding doubles.
 */
public class DoubleColBuffer extends ColBuffer {
    
    private final ArrayDoubleList buf = new ArrayDoubleList();
    
    @Override
    public void addValue(String cellValue) throws IllegalArgumentException {
        double value = Double.parseDouble(cellValue);
        buf.add(value);
    }
    
    @Override
    public double[] getValues() {
        return buf.toArray();
    }

}
