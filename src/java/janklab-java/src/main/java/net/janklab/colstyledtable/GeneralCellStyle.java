package net.janklab.colstyledtable;

import javax.swing.*;

public class GeneralCellStyle extends CellStyle {

    @Override
    public StyledCellText style(Object value) {
        String text = (value == null) ? "" : value.toString();
        StyledCellText out = new StyledCellText(text);
        if (value instanceof Number) {
            out.horizontalAlignment = SwingConstants.RIGHT;
        }
        return out;
    }
}
