---
title: "DBI - Database Independent Interface for Perl"
timestamp: 2015-09-20T00:30:01
tags:
  - DBI
  - DBD
published: true
description: "DBI that stands for Database Independent Interface is the de-facto standard library in Perl to access Relational Databases (RDBMS) using SQL.  It can be used to access any RDBMS using the appropriate Database Driver (DBD)."
author: szabgab
archive: true
---


[DBI](https://metacpan.org/pod/DBI) that stands for Database Independent Interface is the standard library for Perl to access Relational Databases
([RDBMS](https://en.wikipedia.org/wiki/Relational_database_management_system))
using [SQL](https://en.wikipedia.org/wiki/SQL). It can be used to access any RDBMS using the appropriate Database Driver ([DBD](#dbd)).


Many people, instead of directly using DBI, would opt to to use one of the [ORMs (Object Relation Mapping)](https://en.wikipedia.org/wiki/Object-relational_mapping)
available for Perl. The most popular being [DBIx::Class (a.k.a. DBIC)](https://metacpan.org/pod/DBIx::Class) that wraps DBI.

## Examples

[Simple database access using Perl DBI and SQL](/simple-database-access-using-perl-dbi-and-sql)

## Database Drivers (DBDs)

* For [Oracle](https://en.wikipedia.org/wiki/Oracle_Database) use [DBD::Oracle](https://metacpan.org/pod/DBD::Oracle).
* For [Microsoft SQL Server](https://en.wikipedia.org/wiki/Microsoft_SQL_Server) you can use either [DBD::ODBC](https://metacpan.org/pod/DBD::ODBC) or [DBD::ADO](https://metacpan.org/pod/DBD::ADO).
* For [MySQL](https://www.mysql.com/) and [MariaDB](https://mariadb.org/) use [DBD::mysql](https://metacpan.org/pod/DBD::mysql).
* For [IBM DB2](https://en.wikipedia.org/wiki/IBM_DB2) use [DBD::DB2](https://metacpan.org/pod/DBD::DB2).
* For [IBM Informix](https://en.wikipedia.org/wiki/IBM_Informix) use [DBD::Informix](https://metacpan.org/pod/DBD::Informix).
* For [SAP Sybase](https://en.wikipedia.org/wiki/Adaptive_Server_Enterprise) use [DBD::Sybase](https://metacpan.org/pod/DBD::Sybase).
* For [PostgreSQL](http://www.postgresql.org/) use [DBD::Pg](https://metacpan.org/pod/DBD::Pg).
* For [SQLite](https://www.sqlite.org/) use [DBD::SQLite](https://metacpan.org/pod/DBD::SQLite).
* For [Teradata](https://en.wikipedia.org/wiki/Teradata) you have two choices: [DBD::Teradata](https://metacpan.org/pod/DBD::Teradata) is the older. It has a version off CPAN, but it is uncler to me if it is being maintained now.  [Teradata::SQL](https://metacpan.org/pod/Teradata::SQL) is less comprehensive and it does not work with DBI. It has a different API. The author of the latter seems to be much more responsive.
* For [Daegis Inc](https://en.wikipedia.org/wiki/Daegis_Inc.), what was formerly called the Unify database use [DBD::Unify](https://metacpan.org/pod/DBD::Unify).
* For [Neo4j](http://neo4j.com/) graph database you can use [REST::Neo4p](https://metacpan.org/pod/REST::Neo4p) that allows for the execution of Neo4j Cypher language queries, or [DBD::Neo4p](https://metacpan.org/pod/DBD::Neo4p) which is a DBI-compliant wrapper around that module.

### Generic Database Drivers (DBDs)

* [DBD::ADO](https://metacpan.org/pod/DBD::ADO) for Microsoft ADO ([ActiveX Data Objects](https://en.wikipedia.org/wiki/ActiveX_Data_Objects)) (There is also a Win32::ADO module but that's not recommended.)
* [DBD::ODBC](https://metacpan.org/pod/DBD::ODBC) to connect to any database via [ODBC (Open Database Connectivity)](https://en.wikipedia.org/wiki/Open_Database_Connectivity)
* [Win32::ODBC](https://metacpan.org/pod/Win32::ODBC) solely exist for backwards compatibility. It started life in 1996 when DBD::ODBC didn't exist yet, and Perl on Windows was still a fork that couldn't build CPAN modules (it didn't even support MakeMaker). Use DBD::ODBC instead.

### Special Database Drivers

There are all kinds of other Database Drivers that can be used to make data look like they are in a Relational Database.

* [DBD::PO](https://metacpan.org/pod/DBD::PO) for PO (Portable Object) files used by [gettext](https://en.wikipedia.org/wiki/Gettext) for internationalization and localization (i18n)
* [DBD::CSV](https://metacpan.org/pod/DBD::CSV) allows us to access [CSV files](https://en.wikipedia.org/wiki/Comma-separated_values). For example [Calculating bank balance using DBD::CSV](/calculate-bank-balance-take-two-dbd-csv)
* [DBD::DBM](https://metacpan.org/pod/DBD::DBM) for [DBM](https://en.wikipedia.org/wiki/Dbm) and MLDBM files.
* [DBD::Mock](https://metacpan.org/pod/DBD::Mock) is a database driver for testing
* [DBD::iPod](https://metacpan.org/pod/DBD::iPod) connects DBI to an iPod
* [DBD::Google](https://metacpan.org/pod/DBD::Google) to treat Google as relational database.
* [DBD::Sys](https://metacpan.org/pod/DBD::Sys) treat System tables as a relational database.

### Not Database Drivers

There are some module in the DBD::* namespace that are not Database drivers.

* [DBD::Log](https://metacpan.org/pod/DBD::Log) is a logging mechanism for DBI

### Wrappers around DBI

* [DBIx::Class (a.k.a. DBIC)](https://metacpan.org/pod/DBIx::Class)
* [Pcore::DBD](https://metacpan.org/pod/Pcore::DBD) works on top of the [Pcore](https://metacpan.org/pod/Pcore) application framework.
     It provides general API for:
    * Connections cache for use with forks and threads.
    * Query builder with support of particular db server specific syntax.
    * Schema management (apply / revert changesets).
    * More handy functions for fetching data (from my point of view).



See also the comprehensive list of all the [DBD modules](https://metacpan.org/search?q=module%3ADBD&size=20&search_type=modules).

## Other database related articles

* [MongoDB](/mongodb)

