package net.janklab.util.dumbtable;

/**
 * A DumbTable column whose values are doubles.
 */
public class DoubleDumbTableColumn implements DumbTableColumn {

    private double[] values;

    public DoubleDumbTableColumn(double[] values) {
        this.values = new double[values.length];
        System.arraycopy(values, 0, this.values, 0, values.length);
    }

    @Override
    public Class<?> getDataClass() {
        return Double.class;
    }

    @Override
    public Double getValueAt(int rowIndex) {
        return values[rowIndex];
    }

    @Override
    public int getRowCount() {
        return values.length;
    }
}
