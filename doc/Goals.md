# Goals

These are the goals guiding Janklab's development. In addition to goals, we explicitly define non-goals, the things we are willing to give up in order to achieve our goals. Engineering is all about trade-offs.

## Goals

* Concise client code
* Portability of non-OS-specific features
* Support for useful OS-specific features
* Support for polymorphic programming
* Avoiding edge cases and "discontinuities" in our data types

## Secondary goals

* Concise Janklab implementation code

## Non-goals

* Modularity
* A clean top-level namespace
* All features being fully portable
* Back-compatibility of new Janklab releases with older Matlab releases
* Minimizing third-party library dependencies
* Small distribution file size
* Minimizing number of classes and functions
* Running without Java

## MDBC

### Goals for MDBC

* Support major open database vendors
 * PostgreSQL, MySQL, Microsoft SQL Server, Oracle, Derby
 * Major criteria: a free downloadable version of the DB server for development and testing
* Placeholder parameters
* Efficient large INSERTs
* Bonus: extensibility for DB extensions
 * Like PostGIS and user-defined types
* Smooth edge cases and uniform types
 * E.g. empty result sets returned as empty table types, not '[]'
* Support "INSERT ... RETURNING"

### Non-goals for MDBC

* Harder-to-work-with or non-free databases
 * IBM DB2, Sybase
* Non-JDBC/non-Java drivers
* ODBC support
