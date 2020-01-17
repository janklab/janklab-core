Janklab MDBC User Guide
=======================

MDBC is Janklab’s database connectivity layer. It is an extension to the Matlab Database Toolbox, and is built on top of JDBC.

## Introduction

MDBC extends the Matlab Database Toolbox to provide additional features and higher performance.

MDBC provides a separate API from the regular Database Toolbox API. Its functions and objects do not interact with the Database Toolbox's functions, objects, and settings. You can ignore the Database Toolbox documentation when working with MDBC.

The code for MDBC is in the `jl.sql` package.

## Setup

### Installation

MDBC is part of [Janklab](https://github.com/apjanke/janklab). To install MDBC, install Janklab.

MDBC cannot be used as an independent component outside of Janklab.

You will also need the JDBC Driver JAR files for the flavors of database you want to connect to (such as Postgres, Microsoft SQL Server, or Oracle). Drop them into the `lib/java-ext-static` directory inside your Janklab installation if you want them automatically loaded for you. Or get them on your Matlab JAVACLASSPATH any way you wish.

## Creating a connection

The main database connection class in MDBC is `jl.sql.Connection`. When you connect to a database, you will get a `Connection` object, and work with that for all your queries and other SQL activity.

Currently, MDBC only supports creating connections using a JDBC URL string. Contact your database administrator if you need help figuring out what the connection strings for your database are.

Call `jl.sql.Mdbc.connectFromJdbcUrl` to create a new `Connection` using a JDBC URL connection string. Do not include “`jdbc:`” in your connection string.

Example:

```
host = 'mydbserver.local';
username = 'goose';
password = 'honk';
databaseName = 'village';

jdbcUrl = sprintf('postgresql://%s/%s', host, databaseName);

db = jl.sql.Mdbc.connectFromJdbcUrl(jdbcUrl, username, password)
```

