package net.janklab.util.dumbtable;

/**
 * A DumbTable column whose values are longs.
 */
public class LongDumbTableColumn implements DumbTableColumn {

    private long[] values;

    public LongDumbTableColumn(long[] values) {
        this.values = new long[values.length];
        System.arraycopy(values, 0, this.values, 0, values.length);
    }

    public LongDumbTableColumn(int[] values) {
        this.values = new long[values.length];
        for (int i = 0; i < values.length; i++) {
            this.values[i] = values[i];
        }
    }

    @Override
    public Class<?> getDataClass() {
        return Long.class;
    }

    @Override
    public Long getValueAt(int rowIndex) {
        return values[rowIndex];
    }

    @Override
    public int getRowCount() {
        return values.length;
    }
}