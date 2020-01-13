Janklab Feature Areas
=======================

Janklab provides several feature areas, many of which interact with each other.

## Extended Type System

The Janklab “extended type system” provides a unified view of the entire Matlab type system by defining new pseudotypes that represent sets of types (like `primitive` or `java`) or subtypes that depend on the state of values (like `cellstr` or `cellrec`). This is in the `jl.types` namespace.

This lets you write concise type tests using `isa2` instead of having to do combinations of `isnumeric`/`iscellstr`/`isjava` and so on. This can be used to do concise type conversions that look almost like declarative type constraints/coercions for function arguments.

## Date/Time

Janklab provides additional date/time types to supplement Matlab’s new `datetime` class. These are inspired by the Joda-Time and JSR-310 Java APIs.

* `localdate` - a calendar date without a time component
* `localtime` - a local (wall clock) time
* `duration` - a length of time

These are found in the `jl.time` namespace.

Note: `jl.time.duration` is probably going away because Matlab’s own `duration` object provides the same functionality.

## Validators

Janklab provides several validator functions for use with Matlab R2017b’s new function-based object property validation feature. These are in the `validators` directory; browse through it to learn what's available.

## MDBC Database Connectivity

MDBC is an extension to the Matlab Database Toolbox that provides additional features and improved performance.

Additional features:

* Placeholders and bound parameters in SQL queries
* `datetime`, `categorical`, `BigDecimal`, and other types in result sets and inserts
* Prepared statements
* SQL query tracing
* Larger data sets for inserts and query result sets
* Multiple result sets and out-of-band management data support

Performance of MDBC is improved in some cases over the JDBC mode of the Database Toolbox. This is accomplished by using custom column buffering code and other optimizations down in the Java layer.

MDBC is an extension to the Database Toolbox, not a replacement for it. But you still need to use the new API and objects that MDBC provides, instead of using the regular Database Toolbox API.

## Data Structures

### Relation

The `relation` class is a container data type much like Matlab’s `table`, but supports:

* Arbitrary column names (instead of just valid Matlab variable names)
* Arrays of relation objects (compared to how `table` itself is an array)

### Symbol

The `symbol` type is a compact way of representing low-cardinality sets of strings that supports low memory usage and fast equality comparison. It is similar to Matlab's `categorical` type, but uses a global symbol space, and is integrated with Janklab I/O features.

## Monkeypatches

Janklab monkey-patches a couple of the Matlab-provided types with additional functionality. The main purpose of this is to define a useful `==` and `eqnan` for cell values, which are used primarily for polymorphic programming with cellstrs.

## CSV Reader

The `jl.etl.CsvTableReader` is an improved version of Matlab’s `csvread()`/`readtable()` that provides support for additional data types and column type autodetection. It is implemented primarily in Java for speed.

## Algorithms

## Matlab Introspection

The `jl.mlintrospect` namespace contains tools for examining Matlab itself.

The main current use of this is to list and annotate the Java libraries that Matlab ships with, so you can manage your Java dependencies.

### Binsearch

Binary search, implemented in M-code and MEX. Useful mostly as a benchmarking reference. Found in `jl.algo`.

## SQL Stuff

Located in the `jl.sql` namespace. These are utilities for manipulating SQL query text.

### SQL QueryBuilder

A “sentence diagram” for SQL statements that lets you build them incrementally and programmatically.

## Miscellaneous

The rest of Janklab is a grab bag of miscellaneous classes and utility functions. Browse the source to see what’s available. These are aimed at supporting concise, readable code, and filling in the behavior around some of Matlab’s edge cases.

Here are some highlights.

### ifthen()

A function that operates like C and Java’s ternary operator (except that all inputs are evaluated eagerly). Useful for concise one-liners that replace five-line `if`/`else` structures.

```
value = ifthen(condition, valueIfTrue, valueIfFalse);
```

### nil

The `nil` type is a placeholder for missing values, in places where `[]` is not appropriate because it might really represent an empty set or empty array.

### Pseudoconstants

* `CR` - carriage return (`\r`)
* `LF` - line feed (`\n`)
* `CRLF` - carriage return / line feed (`\r\n`)

### Table Utilities

Found in `jl.util.tables`. Provides a higher-level abstraction for doing GROUP BY operations on Matlab `table` objects, and convenient methods for constructing them from other data structures.
