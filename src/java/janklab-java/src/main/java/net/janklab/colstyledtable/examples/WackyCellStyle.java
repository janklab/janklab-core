package net.janklab.colstyledtable.examples;

import net.janklab.colstyledtable.CellStyle;
import net.janklab.colstyledtable.StyledCellText;

import javax.swing.*;
import java.awt.*;

/**
 * A "wacky" cell style that exercises all the styling abilities of
 * StyledCellText.
 */
public class WackyCellStyle extends CellStyle {
    @Override
    public StyledCellText style(Object value) {
        String text = (value == null) ? "" : value.toString();
        StyledCellText out = new StyledCellText(text);
        if (value instanceof Double) {
            double x = (Double) value;
            if (x < 0) {
                out.isItalic = true;
            }
            if (Math.abs(x) < 1.0) {
                out.isBold = true;
            }
        }
        if (value instanceof Double || value instanceof Long) {
            out.horizontalAlignment = SwingConstants.RIGHT;
        }
        if (text.length() > 5) {
            out.textColor = Color.BLUE;
            out.backgroundColor = Color.LIGHT_GRAY;
        }
        return out;
    }
}
