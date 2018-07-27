package net.janklab.colstyledtable;

import javax.swing.*;
import java.awt.*;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.text.DecimalFormat;
import java.text.NumberFormat;

import static java.util.Objects.requireNonNull;

public class NumericStyle extends CellStyle {

    /** Fixed format for numbers; may be null, which indicates to use the default format logic. */
    private NumberFormat format;
    /** Whether to make negative values red. */
    private boolean redNegatives;
    /** Whether to make NaN values red. */
    private boolean redNaNs;

    @Override
    public StyledCellText style(Object value) {
        if (value instanceof Double) {
            return styleDouble((Double) value);
        } else if (value instanceof Float) {
            return styleFloat((Float) value);
        } else if (value instanceof Long) {
            return styleLong((Long) value);
        } else if (value instanceof Integer) {
            return styleLong((Integer) value);
        } else if (value instanceof Short) {
            return styleLong((Short) value);
        } else if (value instanceof Byte) {
            return styleLong((Byte) value);
        } else {
            // Fallback styling for unsupported type
            String text = (value == null) ? "" : value.toString();
            return new StyledCellText(text);
        }
    }

    private StyledCellText styleDouble(Double x) {
        StyledCellText out = styleNumber(x);
        if (redNaNs && x.isNaN()) {
            out.textColor = Color.RED;
        }
        return out;
    }

    private StyledCellText styleFloat(Float x) {
        return styleNumber(x);
    }

    private StyledCellText styleLong(long x) {
        return styleNumber(x);
    }

    private StyledCellText styleNumber(Number x) {
        String text;
        if (format == null) {
            text = x.toString();
        } else {
            text = format.format(x);
        }
        StyledCellText out = new StyledCellText(text);
        if (redNegatives && isNegative(x)) {
            out.textColor = Color.RED;
        }
        // All numbers are right-justified
        out.horizontalAlignment = SwingConstants.RIGHT;
        return out;
    }

    private static boolean isNegative(Number x) {
        if (x instanceof Double) {
            return ((Double) x) < 0;
        } else if (x instanceof Float) {
            return ((Float) x) < 0;
        } else if (x instanceof Long) {
            return ((Long) x) < 0;
        } else if (x instanceof Integer) {
            return ((Integer) x) < 0;
        } else if (x instanceof Short) {
            return ((Short) x) < 0;
        } else if (x instanceof Byte) {
            return ((Byte) x) < 0;
        } else if (x instanceof BigDecimal) {
            return ((BigDecimal) x).compareTo(BigDecimal.ZERO) < 0;
        } else if (x instanceof BigInteger) {
            return ((BigInteger) x).compareTo(BigInteger.ZERO) < 0;
        } else {
            return x.doubleValue() < 0;
        }
    }

    /**
     * Builder pattern for NumericStyle.
     */
    public static class Builder {
        private NumberFormat format = null;
        private boolean redNegatives = false;
        private boolean redNaNs = false;

        public Builder format(NumberFormat numberFormat) {
            this.format = numberFormat;
            return this;
        }

        /**
         * Sets the format for this to a new Decimal Pattern specified by a format
         * pattern. This is a convenience method; it's the equivalent of:
         *    format(new DecimalFormat(pattern));
         *
         * @param pattern DecimalFormat pattern to use.
         * @return this, for chaining.
         */
        public Builder format(String pattern) {
            requireNonNull(pattern);
            this.format = new DecimalFormat(pattern);
            return this;
        }

        public Builder redNegatives(boolean redNegatives) {
            this.redNegatives = redNegatives;
            return this;
        }

        public Builder redNaNs(boolean redNaNs) {
            this.redNaNs = redNaNs;
            return this;
        }

        public NumericStyle build() {
            NumericStyle out = new NumericStyle();
            out.format = format;
            out.redNegatives = redNegatives;
            out.redNaNs = redNaNs;
            return out;
        }
    }
}
