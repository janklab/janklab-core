# Janklab Goals

These are the goals guiding Janklab’s development. In addition to goals, we explicitly define non-goals, the things we are willing to give up in order to achieve our goals. Engineering is all about trade-offs.

## Goals

* Concise client code
* Portability of non-OS-specific features
* Support for useful OS-specific features
* Support for polymorphic programming
* Avoiding edge cases and “discontinuities” in our data types

## Secondary goals

* Concise Janklab implementation code

## Non-goals

* Modularity
* Clean top-level namespace
* All features being fully portable across OSes
* Back-compatibility of new Janklab releases with older Matlab releases
* Minimizing third-party library dependencies
* Small distribution file size
* Minimizing number of classes and functions
* Running without Java

## MDBC

### Goals for MDBC

* Support major open database vendors
  * PostgreSQL, MySQL, Microsoft SQL Server, Oracle, Derby
  * Major criteria: a free-as-in-beer downloadable version of the DB server for development and testing
* Placeholder parameters and prepared statements
* Efficient large INSERTs
* Date/times as real date/time types
  * Definitely not strings, and not raw numerics/datenums
* Smooth edge cases and uniform types
  * E.g. empty result sets returned as empty table types, not '[]'
* Support “INSERT ... RETURNING”
* Support JDBC driver tuning parameters
  * Preferably with reasonable Matlab-tuned per-flavor defaults
* Symbol/categorical support with Java-side conversion
* Bonus: extensibility for DB extensions
  * Like PostGIS and user-defined types
* Bonus: NoSQL databases that present PostgreSQL or other JDBC APIs

### Non-goals for MDBC

* Harder-to-work-with or non-free databases
  * IBM DB2, Sybase
* Non-JDBC/non-Java drivers
* ODBC support
* Drop-in compatibility with base Database Toolbox
