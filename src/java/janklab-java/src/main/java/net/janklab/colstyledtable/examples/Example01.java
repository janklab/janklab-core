package net.janklab.colstyledtable.examples;

import net.janklab.colstyledtable.ColumnarStyledTable;
import net.janklab.util.dumbtable.*;

import javax.swing.*;
import java.awt.*;

public class Example01 {

    public static void main(String[] args) {
        new Example01().doExample();
    }

    public void doExample() {
        String[] colNames = {"names", "x", "y"};
        String[] names = {"foo", "bar", "baz", "foobar",  "qux", "quux", "quuux", "quuuux"};
        int[] x        = {   1,      2,  1234, 12345678,  999,   6, 7, 8 };
        double[] y     = {   1,     1.1, 1.001, 1.000001, 999999999, 999999999.999999999, 0.01, -0.01};

        DumbTableColumn[] cols = {
                new ObjectDumbTableColumn(String.class, names),
                new LongDumbTableColumn(x),
                new DoubleDumbTableColumn(y)
        };
        DumbTable table = new DumbTable(colNames, cols);

        ColumnarStyledTable jtable = new ColumnarStyledTable();
        jtable.getCellStyleContext().setDefaultStyle(new WackyCellStyle());
        jtable.setModel(table);

        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(jtable, BorderLayout.CENTER);
        frame.pack();
        frame.setVisible(true);
    }
}
