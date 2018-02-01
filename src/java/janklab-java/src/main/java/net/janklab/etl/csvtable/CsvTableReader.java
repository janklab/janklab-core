package net.janklab.etl.csvtable;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.io.input.BOMInputStream;

/**
 * Knows how to read tabular data with different column types from a CSV file.
 * Not thread-safe.
 */
public class CsvTableReader {
    // Reading options
    /** How many lines after start to begin reading at. */
    public int lineOffset = 0;
    /** How many columns to skip before reading on each line. */
    public int columnOffset = 0;
    /** Whether the CSV has a column header with column names. */
    public boolean hasHeader = true;
    /** Col names to be used in absence of header. */
    public List<String> clientProvidedColNames;
    /** CSV format options. */
    public CSVFormat csvFormat = CSVFormat.DEFAULT;
    /** Column type map. */
    public ColTypeMap colTypeMap = new ColTypeMap();
    /** Format to use for LOCALDATETIME columns; null for auto detection. */
    public DateTimeFormatter localDateTimeFormat;
    /** Format to use for LOCALDATE columns; null for auto detection. */
    public DateTimeFormatter localDateFormat;
    /** Format to use for LOCALTIME columns; null for auto detection. */
    public DateTimeFormatter localTimeFormat;
    
    // Reading process state
    /** Number of columns. */
    private int nCols;
    /** Effective column names for the CSV being read. */
    private List<String> colNames;
    /** Buffers for storing data. */
    private List<ColBuffer> colBuffers;
    /** Data source that contains the CSV data. */
    private Reader reader;
    /** Parser for the reading process. */
    //private CSVParser parser;
        
    /**
     * Attach this reader to an input source.
     * @param reader Input source to read the CSV data from.
     */
    public void attach(Reader reader) {
        this.reader = reader;
    }
    
    /**
     * Convenience method to attach this reader to a file.
     * @param file File to read from
     * @throws java.io.FileNotFoundException
     */
    public void attach(File file) throws FileNotFoundException {
        this.reader = new BufferedReader(new InputStreamReader(new BOMInputStream(
                new BufferedInputStream(new FileInputStream(file)))));
    }
    
    /**
     * Convenience method to attach this reader to a file.
     * @param file Path to file to read from.
     * @throws java.io.FileNotFoundException
     */
    public void attachFile(String file) throws FileNotFoundException {
        attach(new File(file));
    }
        
    /**
     * Read a table from the currently attached I/O source.
     * @return
     * @throws IOException if there is an I/O error
     * @throws IllegalArgumentException if there is an error parsing the CSV contents
     */
    public Object read() throws IOException, IllegalArgumentException {
        if (csvFormat == null) {
            throw new IllegalStateException("csvFormat may not be null");
        }
        if (reader == null) {
            throw new IllegalStateException("no input source is attached to this CsvTableReader");
        }        
        // Start parsing
        try (CSVParser parser = new CSVParser(reader, csvFormat)) {
            // Determine column names
            Iterator<CSVRecord> it = parser.iterator();
            CSVRecord lookahead = null;
            if (hasHeader) {
                CSVRecord headerRec = it.next();
                nCols = headerRec.size();
                colNames = new ArrayList<>(nCols);
                for (int iCol = 0; iCol < nCols; iCol++) {
                    colNames.add(headerRec.get(iCol));
                }
            } else {
                if (clientProvidedColNames != null) {
                    colNames = new ArrayList<>(clientProvidedColNames);
                    nCols = colNames.size();
                } else {
                    lookahead = it.next();
                    nCols = lookahead.size();
                    colNames = new ArrayList<>(nCols);
                    for (int iCol = 0; iCol < nCols; iCol++) {
                        colNames.add("col"+(iCol+1));
                    }
                }
            }
            // Create buffers
            colBuffers = new ArrayList<>(nCols);
            for (int iCol = 0; iCol < nCols; iCol++) {
                colBuffers.add(colBufferForType(
                        colTypeMap.getTypeForColumn(iCol, colNames.get(iCol))));
            }
            // Parse the data
            while (lookahead != null || it.hasNext()) {
                CSVRecord rec;
                if (lookahead != null) {
                    rec = lookahead;
                    lookahead = null;
                } else {
                    rec = it.next();
                }
                for (int iCol = 0; iCol < nCols; iCol++) {
                    colBuffers.get(iCol).addValue(rec.get(iCol));
                }
            }
            // Wrap up the output
            // This is just a placeholder return value for now; we should be returning
            // a DumbRelation or other public API object.
            return colBuffers;
        }
    }
    
    ColBuffer colBufferForType(ColType colType) {
        Objects.requireNonNull(colType);
        switch (colType) {
            case AUTO:
                return new AutoColBuffer(this);
            case STRING:
                return new StringColBuffer();
            case SYMBOL:
                return new SymbolColBuffer();
            case DOUBLE:
                return new DoubleColBuffer();
            case LOCALDATE:
                return new LocalDateColBuffer(localDateFormat);
            case LOCALDATETIME:
                return new LocalDateTimeColBuffer(localDateTimeFormat);
            case LOCALTIME:
                return new LocalTimeColBuffer(localTimeFormat);
            default:
                throw new IllegalArgumentException("Invalid ColType value");
        }
    }
    
    public String[] getEffectiveColNames() {
        return colNames.toArray(new String[0]);
    }
}
