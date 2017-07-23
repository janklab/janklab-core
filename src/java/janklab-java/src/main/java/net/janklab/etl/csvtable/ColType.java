
package net.janklab.etl.csvtable;

/**
 * The types of columns the CsvTableReader supports. Each type represents a combination 
 * of data representation and parsing/buffering strategy.
 */
public enum ColType {
    /** Automatically detect column type based on its contents. */
    AUTO,
    /** Numeric data stored as doubles. */
    DOUBLE,
    /** Strings taken exactly as provided in the cells. */
    STRING,
    /** Strings stored as Symbols. */
    SYMBOL,
    /** A local (unzoned) calendar date. */
    LOCALDATE,
    /** A local (unzoned) time. */
    LOCALTIME,
    /** A local (unzoned) date-time. */
    LOCALDATETIME,
    /** A zoned date-time, with the zone explicitly included in the cell contents. */
    ZONEDDATETIME
}
