package net.janklab.colstyledtable.examples;

import net.janklab.colstyledtable.ColumnarCellStyleContext;
import net.janklab.colstyledtable.ColumnarStyledTable;
import net.janklab.colstyledtable.NumericStyle;
import net.janklab.util.dumbtable.*;

import javax.swing.*;
import java.awt.*;

public class Example03 {

    public static void main(String[] args) {
        new Example03().doExample();
    }

    public void doExample() {
        String[] colNames = { "str1", "x1", "x2", "str2", "x3", "x4 but with a long column name" };
        String[] str1 = { "a", "b", "c", "d", "e", "f" };
        int[] x1    = { 1, 2, 3, 4, 5, 6 };
        int[] x2    = { 1, 2, 3, 4, 5, 123_456_789 };
        String[] str2 = { "a", "b", "a much longer string, hello", "d", "e", "f" };
        double[] x3 = { 1.0, 1.01, 1_111.111, 999999999.999, 999999999999.999999, 0.0000001 };
        int[] x4    = { 1, 2, 3, 4, 5, 6 };
        DumbTableColumn[] cols = {
                new ObjectDumbTableColumn(String.class, str1),
                new LongDumbTableColumn(x1),
                new LongDumbTableColumn(x2),
                new ObjectDumbTableColumn(String.class, str2),
                new DoubleDumbTableColumn(x3),
                new LongDumbTableColumn(x4),
        };
        DumbTable table = new DumbTable(colNames, cols);

        ColumnarStyledTable jtable = new ColumnarStyledTable();
        ColumnarCellStyleContext styleContext = jtable.getCellStyleContext();
        String myFractionalFormat = "#,##0.000";
        NumericStyle myFractionalStyle = new NumericStyle.Builder().format(myFractionalFormat).build();
        String myIntegerFormat = "#,##0";
        NumericStyle myIntegerStyle = new NumericStyle.Builder().format(myIntegerFormat).build();
        styleContext.setStyleForColumnClasses(ColumnarCellStyleContext.FRACTIONAL_TYPES, myFractionalStyle);
        styleContext.setStyleForColumnClasses(ColumnarCellStyleContext.INTEGER_TYPES, myIntegerStyle);
        jtable.setModel(table);

        doBaseExample(jtable);
    }

    protected void doBaseExample(ColumnarStyledTable table) {
        JPanel panel = new JPanel();
        panel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        panel.setLayout(new BorderLayout());
        panel.add(table, BorderLayout.CENTER);
        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(panel, BorderLayout.CENTER);
        frame.setTitle(getClass().getSimpleName());
        frame.pack();
        frame.setVisible(true);
    }
}
