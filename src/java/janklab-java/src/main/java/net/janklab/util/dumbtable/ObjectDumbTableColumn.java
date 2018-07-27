package net.janklab.util.dumbtable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static java.util.Objects.requireNonNull;

/**
 * A DumbTable column that stores its values as objects.
 */
public class ObjectDumbTableColumn implements DumbTableColumn {
    Class<?> dataClass;
    List<Object> values;

    public ObjectDumbTableColumn(Class<?> dataClass, Object[] values) {
        this.dataClass = requireNonNull(dataClass);
        this.values = new ArrayList<>(Arrays.asList(values));
    }

    public ObjectDumbTableColumn(Class<?> dataClass, List<?> values) {
        this.dataClass = requireNonNull(dataClass);
        this.values = new ArrayList<>(values);
    }

    @Override
    public Class<?> getDataClass() {
        return dataClass;
    }

    @Override
    public Object getValueAt(int rowIndex) {
        return values.get(rowIndex);
    }

    @Override
    public int getRowCount() {
        return values.size();
    }

}
