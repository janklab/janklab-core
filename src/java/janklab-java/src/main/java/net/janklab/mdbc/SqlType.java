package net.janklab.mdbc;

/**
 * A typesafe-enum version of the types in java.sql.Types.
 */
public enum SqlType {
  ARRAY("ARRAY", java.sql.Types.ARRAY),
  BIGINT("BIGINT", java.sql.Types.BIGINT),
  BINARY("BINARY", java.sql.Types.BINARY),
  BIT("BIT", java.sql.Types.BIT),
  BLOB("BLOB", java.sql.Types.BLOB),
  BOOLEAN("BOOLEAN", java.sql.Types.BOOLEAN),
  CHAR("CHAR", java.sql.Types.CHAR),
  CLOB("CLOB", java.sql.Types.CLOB),
  DATALINK("DATALINK", java.sql.Types.DATALINK),
  DATE("DATE", java.sql.Types.DATE),
  DECIMAL("DECIMAL", java.sql.Types.DECIMAL),
  DISTINCT("DISTINCT", java.sql.Types.DISTINCT),
  DOUBLE("DOUBLE", java.sql.Types.DOUBLE),
  FLOAT("FLOAT", java.sql.Types.FLOAT),
  INTEGER("INTEGER", java.sql.Types.INTEGER),
  JAVA_OBJECT("JAVA_OBJECT", java.sql.Types.JAVA_OBJECT),
  LONGNVARCHAR("LONGNVARCHAR", java.sql.Types.LONGNVARCHAR),
  LONGVARBINARY("LONGVARBINARY", java.sql.Types.LONGVARBINARY),
  LONGVARCHAR("LONGVARCHAR", java.sql.Types.LONGVARCHAR),
  NCHAR("NCHAR", java.sql.Types.NCHAR),
  NCLOB("NCLOB", java.sql.Types.NCLOB),
  NULL("NULL", java.sql.Types.NULL),
  NUMERIC("NUMERIC", java.sql.Types.NUMERIC),
  NVARCHAR("NVARCHAR", java.sql.Types.NVARCHAR),
  OTHER("OTHER", java.sql.Types.OTHER),
  REAL("REAL", java.sql.Types.REAL),
  REF("REF", java.sql.Types.REF),
  REF_CURSOR("REF_CURSOR", java.sql.Types.REF_CURSOR),
  ROWID("ROWID", java.sql.Types.ROWID),
  SMALLINT("SMALLINT", java.sql.Types.SMALLINT),
  SQLXML("SQLXML", java.sql.Types.SQLXML),
  STRUCT("STRUCT", java.sql.Types.STRUCT),
  TIME("TIME", java.sql.Types.TIME),
  TIME_WITH_TIMEZONE("TIME_WITH_TIMEZONE", java.sql.Types.TIME_WITH_TIMEZONE),
  TIMESTAMP("TIMESTAMP", java.sql.Types.TIMESTAMP),
  TIMESTAMP_WITH_TIMEZONE("TIMESTAMP_WITH_TIMEZONE", java.sql.Types.TIMESTAMP_WITH_TIMEZONE),
  TINYINT("TINYINT", java.sql.Types.TINYINT),
  VARBINARY("VARBINARY", java.sql.Types.VARBINARY),
  VARCHAR("VARCHAR", java.sql.Types.VARCHAR);

  private final String name;
  private final int code;

  private SqlType(String name, int code) {
    this.name = name;
    this.code = code;
  }

  @Override
  public String toString() {
    return name;
  }

  public static SqlType fromTypesConstant(int val) {
    switch (val) {
      case java.sql.Types.ARRAY:
        return ARRAY;
      case java.sql.Types.BIGINT:
        return BIGINT;
      case java.sql.Types.BINARY:
        return BINARY;
      case java.sql.Types.BIT:
        return BIT;
      case java.sql.Types.BLOB:
        return BLOB;
      case java.sql.Types.BOOLEAN:
        return BOOLEAN;
      case java.sql.Types.CHAR:
        return CHAR;
      case java.sql.Types.CLOB:
        return CLOB;
      case java.sql.Types.DATALINK:
        return DATALINK;
      case java.sql.Types.DATE:
        return DATE;
      case java.sql.Types.DECIMAL:
        return DECIMAL;
      case java.sql.Types.DISTINCT:
        return DISTINCT;
      case java.sql.Types.DOUBLE:
        return DOUBLE;
      case java.sql.Types.FLOAT:
        return FLOAT;
      case java.sql.Types.INTEGER:
        return INTEGER;
      case java.sql.Types.JAVA_OBJECT:
        return JAVA_OBJECT;
      case java.sql.Types.LONGNVARCHAR:
        return LONGNVARCHAR;
      case java.sql.Types.LONGVARBINARY:
        return LONGVARBINARY;
      case java.sql.Types.LONGVARCHAR:
        return LONGVARCHAR;
      case java.sql.Types.NCHAR:
        return NCHAR;
      case java.sql.Types.NCLOB:
        return NCLOB;
      case java.sql.Types.NULL:
        return NULL;
      case java.sql.Types.NUMERIC:
        return NUMERIC;
      case java.sql.Types.NVARCHAR:
        return NVARCHAR;
      case java.sql.Types.OTHER:
        return OTHER;
      case java.sql.Types.REAL:
        return REAL;
      case java.sql.Types.REF:
        return REF;
      case java.sql.Types.REF_CURSOR:
        return REF_CURSOR;
      case java.sql.Types.ROWID:
        return ROWID;
      case java.sql.Types.SMALLINT:
        return SMALLINT;
      case java.sql.Types.SQLXML:
        return SQLXML;
      case java.sql.Types.STRUCT:
        return STRUCT;
      case java.sql.Types.TIME:
        return TIME;
      case java.sql.Types.TIME_WITH_TIMEZONE:
        return TIME_WITH_TIMEZONE;
      case java.sql.Types.TIMESTAMP:
        return TIMESTAMP;
      case java.sql.Types.TIMESTAMP_WITH_TIMEZONE:
        return TIMESTAMP_WITH_TIMEZONE;
      case java.sql.Types.TINYINT:
        return TINYINT;
      case java.sql.Types.VARBINARY:
        return VARBINARY;
      case java.sql.Types.VARCHAR:
        return VARCHAR;
      default:
        throw new IllegalArgumentException("Invalid java.sql.Types code: "+val);
    }
  }
}
