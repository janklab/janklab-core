package net.janklab.colstyledtable;

import javax.swing.*;
import java.awt.*;

import static java.util.Objects.requireNonNull;

/**
 * A cell contents that has been formatted and styled as text, with cell
 * styling options.
 */
public class StyledCellText {
    /** Display text. Never null. */
    public String text;
    public boolean isBold;
    public boolean isItalic;
    // I'd like to have isUnderlined and isStrikethrough, too, but Java's Font doesn't
    // seem to support those
    /** Text color; null to use parent component's default color. */
    public Color textColor;
    /** Background color; null to use parent component's default background color. */
    public Color backgroundColor;
    /** Text alignment. One of the following constants defined in SwingConstants: LEFT,
     *  CENTER, RIGHT, LEADING or TRAILING. */
    public int horizontalAlignment = SwingConstants.LEFT;

    public StyledCellText() {
        this.text = "";
    }

    public StyledCellText(String text) {
        requireNonNull(text);
        this.text = text;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("[");
        sb.append("\"").append(text).append("\"");
        if (isBold) {
            sb.append(" bold");
        }
        if (isItalic) {
            sb.append(" italic");
        }
        if (textColor != null) {
            sb.append(" (fg=").append(textColor).append(")");
        }
        if (backgroundColor != null) {
            sb.append(" (bg=").append(backgroundColor).append(")");
        }
        if (horizontalAlignment != SwingConstants.LEFT) {
            sb.append(" align=").append(horizontalAlignment);
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * Get the rendered width of this text, as rendered in a given component.
     * @param component The component where the text will be rendered
     * @return width in pixels
     */
    public int getRenderedWidth(JComponent component) {
        Font font = getEffectiveFont(component.getFont());
        FontMetrics fontMetrics = component.getFontMetrics(font);
        return fontMetrics.stringWidth(text);
    }

    public Font getEffectiveFont(Font baseFont) {
        Font font = baseFont;
        int style = Font.PLAIN;
        if (isBold) {
            style = style | Font.BOLD;
        }
        if (isItalic) {
            style = style | Font.ITALIC;
        }
        if (style != Font.PLAIN) {
            font = font.deriveFont(style);
        }
        return font;
    }
}
