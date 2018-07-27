package net.janklab.colstyledtable;

import javax.swing.*;
import javax.swing.table.*;

import java.awt.*;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.util.Arrays;

import static java.util.Objects.requireNonNull;

/**
 * A table display component with column-wise cell styling.
 *
 * This should be treated as an opaque JComponent; do not use the
 * JPanel methods to do things like add or remove child components.
 */
public class ColumnarStyledTable extends JPanel {

    private static int MAX_PREFERRED_HEIGHT = 500;

    private JTable table = new JTable();
    private ColumnarCellStyleContext cellStyleContext;
    private TableModel underlyingTableModel = new DefaultTableModel();
    private CellStylingTableModelAdapter stylingTableModel;
    private CellSizeConstraints cellSizeConstraints = new CellSizeConstraints();
    private FontSizeAdjuster fontSizeAdjuster;

    public ColumnarStyledTable() {
        this(new ColumnarCellStyleContext());
    }

    public ColumnarStyledTable(ColumnarCellStyleContext cellStyleContext) {
        this.cellStyleContext = requireNonNull(cellStyleContext);
        stylingTableModel = new CellStylingTableModelAdapter(cellStyleContext);
        table.setModel(stylingTableModel);
        initComponents();
    }

    private void initComponents() {
        setLayout(new BorderLayout());
        JScrollPane scrollPane = new JScrollPane(table);
        scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        scrollPane.setBorder(BorderFactory.createEmptyBorder());
        add(scrollPane, BorderLayout.CENTER);
        table.setDefaultRenderer(StyledCellText.class, new StyledCellRenderer());
        table.setGridColor(table.getForeground());
        table.setShowGrid(true);
        table.setGridColor(new Color(200, 200, 200));
        table.setRowMargin(cellSizeConstraints.rowMargin);
        table.getColumnModel().setColumnMargin(cellSizeConstraints.columnMargin);
        table.getTableHeader().setFont(getFont().deriveFont(Font.BOLD));
        fontSizeAdjuster = new FontSizeAdjuster(Arrays.asList(this));
        fontSizeAdjuster.installKeystrokeHandlerOnAllComponents();
        addPropertyChangeListener("font", new FontSizeChangeListener());
    }

    private void setComponentSizesBasedOnTable() {
        int preferredWidth = 0;
        int maxWidth = 0;
        int columnMargin = table.getColumnModel().getColumnMargin();
        for (int iCol = 0; iCol < stylingTableModel.getColumnCount(); iCol++) {
            TableColumn col = table.getColumnModel().getColumn(iCol);
            preferredWidth += col.getPreferredWidth();
            preferredWidth += columnMargin;
            maxWidth += col.getMaxWidth();
            maxWidth += columnMargin;
        }
        int nRows = stylingTableModel.getRowCount();
        int height = (table.getRowHeight() * nRows) + (2 * table.getRowMargin() * (nRows - 1));
        height += table.getTableHeader().getHeight();
        height += 5; // fudge factor
        maxWidth += 10; // fudge factor
        int preferredHeight = Math.min(height, MAX_PREFERRED_HEIGHT);
        setPreferredSize(new Dimension(preferredWidth, preferredHeight));
        setMaximumSize(new Dimension(maxWidth, height));
    }

    public void setModel(TableModel model) {
        this.underlyingTableModel = requireNonNull(model);
        stylingTableModel.setUnderlyingModel(this.underlyingTableModel);
        setRowAndColumnSizesBasedOnData();
        setComponentSizesBasedOnTable();
    }

    public void setRowAndColumnSizesBasedOnData() {
        CellSizeConstraints constraints = cellSizeConstraints;
        // Go through data and get heights and widths of contained text
        int nCols = stylingTableModel.getColumnCount();
        int nRows = stylingTableModel.getRowCount();
        int[] headerWidths = new int[nCols];
        int[] renderedWidths = new int[nCols];
        FontMetrics fontMetrics = getFontMetrics(getFont());
        int fontStandardHeight = fontMetrics.getHeight();
        FontMetrics headerFontMetrics = table.getTableHeader().getFontMetrics(table.getTableHeader().getFont());
        int nameFudgeFactor = 2;
        for (int iCol = 0; iCol < nCols; iCol++) {
            headerWidths[iCol] = headerFontMetrics.stringWidth(stylingTableModel.getColumnName(iCol))
                    + nameFudgeFactor;
            for (int iRow = 0; iRow < nRows; iRow++) {
                StyledCellText styledCellText = stylingTableModel.getValueAt(iRow, iCol);
                int renderedWidth = styledCellText.getRenderedWidth(table);
                if (renderedWidth > renderedWidths[iCol]) {
                    renderedWidths[iCol] = renderedWidth;
                }
            }
        }
        // Pick min, max, and preferred widths for them.
        for (int iCol = 0; iCol < nCols; iCol++) {
            TableColumn columnModel = table.getColumnModel().getColumn(iCol);
            int preferredWidth = renderedWidths[iCol] + (2 * constraints.preferredWidthPadding)
                    + (2 * constraints.internalHorizontalPadding);
            preferredWidth = Math.max(constraints.minPreferredWidth, preferredWidth);
            int maxWidth = Math.max(preferredWidth, headerWidths[iCol]);
            preferredWidth = Math.min(constraints.maxPreferredWidth, preferredWidth);
            if (preferredWidth < constraints.maxNameBasedPreferredWidth) {
                preferredWidth = Math.min(constraints.maxNameBasedPreferredWidth,
                        Math.max(preferredWidth, headerWidths[iCol] + (2 * constraints.preferredWidthPadding)
                        + (2 * constraints.columnMargin)));
            }
            columnModel.setPreferredWidth(preferredWidth);
            int minWidth = Math.max(constraints.minMinimumWidth, Math.min(constraints.maxMinimumWidth,
                    renderedWidths[iCol] + (2 * constraints.internalHorizontalPadding)));
            columnModel.setMinWidth(minWidth);
            if (constraints.doMaxWidths) {
                maxWidth = Math.max(maxWidth, headerWidths[iCol]);
                columnModel.setMaxWidth(maxWidth);
            }
        }
        // Pick row height
        int rowHeight = fontStandardHeight + (2 * constraints.rowMargin)
                + (2 * constraints.internalVerticalPadding);
        table.setRowHeight(rowHeight);
    }

    public ColumnarCellStyleContext getCellStyleContext() {
        return cellStyleContext;
    }

    public JTable getJTable() {
        return table;
    }

    /**
     * Constraints on the setting of column width properties.
     */
    public static class CellSizeConstraints {
        public int maxMinimumWidth = 100;
        public int minMinimumWidth = 20;
        public int maxPreferredWidth = 600;
        public int minPreferredWidth = 40;
        /** Padding to be added to left and right when calculating preferred cell width. */
        public int preferredWidthPadding = 10;
        /** Maximum preferred width to be set based upon width of column names (as opposed to
         * cell data). */
        public int maxNameBasedPreferredWidth = 150;
        /** Whether to set maximum column widths. */
        public boolean doMaxWidths = true;
        /** Padding added above and below rendered cell contents. */
        public int rowMargin = 1;
        /** Column margin. Not included in preferredWidthPadding. Be careful with this. If you don't
         * set it to 1, the grid lines may look hinky. */
        public int columnMargin = 2;
        /** Horizontal padding inside the cell renderer. */
        public int internalHorizontalPadding = 3;
        /** Vertical padding inside the cell renderer. */
        public int internalVerticalPadding = 1;
    }

    private class StyledCellRenderer extends JLabel implements TableCellRenderer {

        StyledCellRenderer() {
            CellSizeConstraints c = cellSizeConstraints;
            setBorder(BorderFactory.createEmptyBorder(c.internalVerticalPadding, c.internalHorizontalPadding,
                    c.internalVerticalPadding, c.internalHorizontalPadding));
        }

        @Override
        public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected,
                                                       boolean hasFocus, int row, int column) {
            if (!(value instanceof StyledCellText)) {
                setText("" + value);
                return this;
            }
            StyledCellText styled = (StyledCellText) value;
            setText(styled.text);
            if (styled.textColor == null) {
                setForeground(table.getForeground());
            } else {
                setForeground(styled.textColor);
            }
            if (styled.backgroundColor == null) {
                setBackground(table.getBackground());
                setOpaque(false);
            } else {
                setBackground(styled.backgroundColor);
                setOpaque(true);
            }
            Font font = styled.getEffectiveFont(table.getFont());
            setFont(font);
            setHorizontalAlignment(styled.horizontalAlignment);
            return this;
        }
    }

    private class FontSizeChangeListener implements PropertyChangeListener {

        @Override
        public void propertyChange(PropertyChangeEvent evt) {
            table.setFont(getFont());
            table.getTableHeader().setFont(getFont().deriveFont(Font.BOLD));
            setRowAndColumnSizesBasedOnData();
            stylingTableModel.fireTableDataChanged();
        }
    }
}
