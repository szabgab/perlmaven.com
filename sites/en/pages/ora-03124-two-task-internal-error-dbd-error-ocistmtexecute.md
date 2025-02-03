---
title: "ORA-03124: two-task internal error (DBD ERROR: OCIStmtExecute)"
timestamp: 2009-08-21T01:14:34
tags:
  - DBD::Oracle
published: true
archive: true
---



Posted on 2009-08-21 01:14:34-07 by xinhuan

I am getting ORA-03124: two-task internal error (DBD ERROR: OCIStmtExecute)
when using DBD::Oracle version 1.23. This is a select query. Oracle server is 11g
and client is also 11g. The select statement is like this:

```
select col1, col2 from table where key = '12335|678999|345667';
```

The interesting thing is the query worked at the very first time, and failed on second time and onwards.
My question is: does DBD::Oracle 1.23 (latest version) support Oracle 11g client and server?
If it is, is this a known bug in Oracle 11g server or client or in DBD::Oracle module?

Thanks, --xinhuan

Posted on 2009-08-21 10:15:05-07 by byterock in response to 11339

The ora-03124 has nothing to do with DBB::Oracle as this is either a disk/space issue a license issue
(as in you do not have the correct one) or you are trying to stuff too much data into a
single row or field. You will have to look at you oracle logs to see what is going wrong.
As it ran once I would go the too much data in a row or field and it might have something to
do with non UTF8 chars By they way no one but me actually look at this list
(and I only when I have some spare time) You would be much better
[off posting on the DBI mailing list](http://www.nntp.perl.org/group/perl.dbi.users/)
or raise a [RT ticket](http://rt.cpan.org/Dist/Display.html?Queue=DBD-Oracle)

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/11339 -->


