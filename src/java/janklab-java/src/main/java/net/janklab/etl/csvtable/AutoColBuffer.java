package net.janklab.etl.csvtable;

import org.threeten.bp.format.DateTimeFormatter;
import org.threeten.bp.format.DateTimeParseException;
import org.threeten.bp.format.FormatStyle;
import java.util.Objects;

/**
 *
 */
public class AutoColBuffer extends ColBuffer {
    /** The CsvTableReader this is being used by. */
    private final CsvTableReader reader;
    /** The fallback String buffer. */
    private final StringColBuffer stringBuf = new StringColBuffer();
    /** Buffered data of detected column type. */
    private ColBuffer delegateBuf;
    /** Whether this is the first cell or not. */
    private boolean isFirstCell = true;
    /** (DateTimeFormatter, ColType) pairs for datetime column detection. */
    private Object[] dateCandidates;
    
    AutoColBuffer(CsvTableReader reader) {
        Objects.requireNonNull(reader);
        this.reader = reader;
        dateCandidates = new Object[] {
            DateTimeFormatter.ISO_LOCAL_DATE, ColType.LOCALDATE,
            DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL), ColType.LOCALDATE,
            DateTimeFormatter.ofLocalizedDate(FormatStyle.LONG), ColType.LOCALDATE,
            DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM), ColType.LOCALDATE,
            DateTimeFormatter.ofLocalizedDate(FormatStyle.SHORT), ColType.LOCALDATE,
            reader.localDateTimeFormat, ColType.LOCALDATETIME,
            DateTimeFormatter.ISO_LOCAL_DATE_TIME, ColType.LOCALDATETIME,
            DateTimeFormatter.ofLocalizedDateTime(FormatStyle.FULL), ColType.LOCALDATETIME,
            DateTimeFormatter.ofLocalizedDateTime(FormatStyle.LONG), ColType.LOCALDATETIME,
            DateTimeFormatter.ofLocalizedDateTime(FormatStyle.MEDIUM), ColType.LOCALDATETIME,
            DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT), ColType.LOCALDATETIME,
            DateTimeFormatter.ISO_ZONED_DATE_TIME, ColType.ZONEDDATETIME,
            DateTimeFormatter.ISO_LOCAL_TIME, ColType.LOCALTIME,
            DateTimeFormatter.ofLocalizedTime(FormatStyle.FULL), ColType.LOCALTIME,
            DateTimeFormatter.ofLocalizedTime(FormatStyle.LONG), ColType.LOCALTIME,
            DateTimeFormatter.ofLocalizedTime(FormatStyle.MEDIUM), ColType.LOCALTIME,
            DateTimeFormatter.ofLocalizedTime(FormatStyle.SHORT), ColType.LOCALTIME,        
        };
    }
    
    
    @Override
    public void addValue(String cellValue) throws IllegalArgumentException {
        Objects.requireNonNull(cellValue);
        // On first cell, detect column type        
        if (isFirstCell) {
            ColType detectedColType = null;
            // Try dates first
            for (int iDateFmt = 0; iDateFmt < dateCandidates.length; iDateFmt += 2) {
                DateTimeFormatter fmt = (DateTimeFormatter) dateCandidates[iDateFmt];
                if (fmt == null) {
                    // Placeholder for formats not specified in parent rearder object
                    continue;
                }
                ColType correspondingType = (ColType) dateCandidates[iDateFmt + 1];
                try {
                    fmt.parse(cellValue);
                    detectedColType = correspondingType;
                    break;
                } catch (DateTimeParseException dtpe) {
                    // quash and try next formatter
                }
            }
            // Dates didn't work; try numeric
            if (detectedColType == null) {
                try {
                    Double.parseDouble(cellValue);
                    detectedColType = ColType.DOUBLE;
                } catch (NumberFormatException nfe) {
                    // Nope. Quash.
                }
            }
            // Construct buffer for detected type
            if (detectedColType != null) {
                delegateBuf = reader.colBufferForType(detectedColType);
            } else {
                // All special formats failed; fall back to String
                // This is done by just leaving the delegate buffer null
                delegateBuf = null;
            }
            isFirstCell = false;
        }
        // Buffer the value
        if (delegateBuf != null) {
            try {
                delegateBuf.addValue(cellValue);
            } catch (RuntimeException re) {
                // Detected type failed. Fall back to just using strings
                //System.err.println("Caught exception: " + re.toString());
                //System.err.println("Parsing failed for value: '" + cellValue 
                //       + "'. Falling back to String buffering.");
                delegateBuf = null;
            }
        }
        // Always buffer the string value, too, in case we need to fall back later
        stringBuf.addValue(cellValue);
    }

    @Override
    public Object getValues() {
        return (delegateBuf != null) ? delegateBuf.getValues() : stringBuf.getValues();
    }
}
