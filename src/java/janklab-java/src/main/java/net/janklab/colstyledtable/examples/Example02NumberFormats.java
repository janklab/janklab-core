package net.janklab.colstyledtable.examples;

import net.janklab.colstyledtable.ColumnarCellStyleContext;
import net.janklab.colstyledtable.ColumnarStyledTable;
import net.janklab.colstyledtable.NumericStyle;
import net.janklab.util.dumbtable.DoubleDumbTableColumn;
import net.janklab.util.dumbtable.DumbTable;
import net.janklab.util.dumbtable.DumbTableColumn;
import net.janklab.util.dumbtable.LongDumbTableColumn;

import javax.swing.*;
import java.awt.*;

public class Example02NumberFormats {

    public static void main(String[] args) {
        new Example02NumberFormats().doExample();
    }

    public void doExample() {
        String[] colNames = { "x1", "x2", "x3" };
        int[] x1    = { 1, 2, 3, 4, 5, 6 };
        int[] x2    = { 1, 2, 3, 4, 5, 123_456_789 };
        double[] x3 = { 1.0, 1.01, 1.001, 999999999.999, 999999999.999999, 0.0000001 };
        DumbTableColumn[] cols = {
                new LongDumbTableColumn(x1),
                new LongDumbTableColumn(x2),
                new DoubleDumbTableColumn(x3)
        };
        DumbTable table = new DumbTable(colNames, cols);

        ColumnarStyledTable jtable = new ColumnarStyledTable();
        ColumnarCellStyleContext styleContext = jtable.getCellStyleContext();
        String myFractionalFormat = "#,###.000";
        NumericStyle myFractionalStyle = new NumericStyle.Builder().format(myFractionalFormat).build();
        String myIntegerFormat = "#,###";
        NumericStyle myIntegerStyle = new NumericStyle.Builder().format(myIntegerFormat).build();
        styleContext.setStyleForColumnClasses(ColumnarCellStyleContext.FRACTIONAL_TYPES, myFractionalStyle);
        styleContext.setStyleForColumnClasses(ColumnarCellStyleContext.INTEGER_TYPES, myIntegerStyle);
        jtable.setModel(table);
        JTable jtable2 = jtable.getJTable();
        jtable2.setShowGrid(true);
        jtable2.setAutoCreateColumnsFromModel(true);

        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(jtable, BorderLayout.CENTER);
        frame.pack();
        frame.setVisible(true);
    }
}
