---
title: "Calculating bank balance, take two: DBD::CSV"
timestamp: 2012-09-07T09:45:56
tags:
  - DBD::CSV
  - CSV
  - SQL
  - DBI
published: true
author: dmcbride
---


<i>This is a guest post by [Darin McBride](http://www.linkedin.com/pub/darin-mcbride/32/a53/184)
who is a Software Developer in the IBM Canada Lab and the author
of several [Perl modules on CPAN](https://www.metacpan.org/author/DMCBRIDE).
A father of three, he is currently trying to figure out how to `use more 'sleep';`. -- Gabor</i>

After Gabor answered a user's question on
<a href="/how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl">how
to calculate bank balances in CSV</a>, I suggested that this was just screaming
for [DBD::CSV](https://metacpan.org/pod/DBD::CSV).  Gabor invited
me to put my fingers where my mouth was, so to speak, and explain in greater
detail.


## Why DBD::CSV?

Nearly every time someone has a question on CSV in Perl, the first thing
in my mind is always the same thing: DBD::CSV.  The reason for this is two-fold.
First, when accessing CSV files through DBD::CSV, you're learning and/or using
two skills that are portable to far more projects than na&iuml;ve splits or
even using [Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS):
**DBI** and **SQL**. This means that your skill set will grow in ways that are more
useful to your career, but, more immediately, you will also have a larger
set of people to whom you can ask for help.  For example, nearly any Database
Administrator (DBA) should be able to help you with SQL questions, but may
not be able to help with perl questions.

The second reason for using DBD::CSV is that it gets you thinking about
your data differently. Often, in my experience, simply treating the CSV
as if it were a table in a relational database can be enough of a lightbulb
moment to realize simpler solutions, even if the computer will spend far
more time executing them.

And a bonus reason is that once you realize your data is, well, data,
the natural transition to another database system (SQLite, DB2, Oracle,
whatever is handy) becomes natural.  And since you've already written your
code with DBD::CSV, transitioning to
[DBD::DB2](https://metacpan.org/pod/DBD::DB2) or
[DBD::SQLite](https://metacpan.org/pod/DBD::SQLite) (the two I
use the most, YMMV) becomes simpler.

## The Approach

So, to start, we will begin with the original CSV:

```
TranID,Date,AcNo,Type,Amount,ChequeNo,DDNo,Bank,Branch
13520,01-01-2011,5131342,Dr,5000,,,,
13524,01-01-2011,5131342,Dr,1000,,416123,SB,Ashoknagar
13538,08-01-2011,5131342,Cr,1620,19101,,,
13548,17-01-2011,5131342,Cr,3500,19102,,,
13519,01-01-2011,5522341,Dr,2000,14514,,SBM,Hampankatte
13523,01-01-2011,5522341,Cr,500,19121,,,
13529,02-01-2011,5522341,Dr,5000,13211,,SB,Ashoknagar
13539,09-01-2011,5522341,Cr,500,19122,,,
13541,10-01-2011,5522341,Cr,2000,19123,,,
```

Nothing different here.  I don't know what all of these fields are
but the question was simple: <i>How to Calculate and display total balance in
each account using hash in perl. Without using parse function?</i>
Ok, not quite simple, so I'm going to also make a few adjustments.  I feel
Gabor answered this fairly precisely, as well as going on and answering a
few related questions.  So I'll go in another direction here:
<i>How to Calculate and display total balance in each account <del>using hash</del> in perl.
<del>Without using parse function?</del></i>


So, it looks to me like we need to add up all the debits (Dr) and credits
(Cr), grouped by the account number (AcNo).  This sounds almost exactly
like SQL, so maybe an SQL solution would be apropos?

## DBI setup

First, we need to do some set up.  This setup is definitely longer than
any solution using Text::CSV_XS, but since I mostly cut and paste it now
from project to project, it's not too bad.  And it's the same setup (mostly)
as with other drivers.

As always, the safety net:

```perl
use strict;
use warnings;
```

<p>(Which saved me a fair bit of pain while developing this code.) And then
the magic:</p>

```perl
use DBI;
```

Note that we don't load the CSV driver, but only [DBI](https://metacpan.org/pod/DBI).
Shortly, DBI will load DBD::CSV for us.  This is convenient in that there will
only be one place where we're specifying what back-end database we're using,
meaning less to change should we desire to upgrade to a full-fledged database
later.  Unlikely here, but, again, we're not simply trying to get this total,
we're learning DBI and SQL here.

```perl
use File::Basename qw(dirname);
use File::Spec;

my $dbh = DBI->connect('dbi:CSV:', undef, undef,
             {
                 f_dir => File::Spec->rel2abs(dirname($0)),
                 f_ext => '.csv',
                 csv_eol => "\n",
                 RaiseError => 1,
             });
```

Here we load a couple of modules that make our job a little easier and
then tell DBI that we're going to use a CSV back-end.  Since CSV files
don't need users or passwords to connect, we leave them as `undef`,
but then
we pass in a few extra flags.  Some of these flags go to the CSV driver,
but `RaiseError` is a generic DBI setting which auto-dies when something goes
wrong.  This is great for development, so I don't miss anything.  In production,
it may be less desirable, but I also run with `use warnings FATAL => 'all';`
in production, so I'm obviously okay with that.

The other parameters need a bit of an explanation.  f_dir is the directory
that DBD::CSV will look for all the CSV files.  In this case, I'm specifying
that the directory is the same as the one with the script.  If that's not your
case, you will need to adjust appropriately.
In the [original article](/how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl),
Gabor just relied on the current working directory, which is also a valid
approach.

f_ext is the extension added to any table name when discerning the file
name.  With this extension, trying to SELECT ... FROM foo will mean that
DBD::CSV will read the file foo.csv (in the f_dir specified above).

csv_eol tells DBD::CSV what the end-of-line string is. I think the
default is `\r\n`, but as I'm on Linux, that's not appropriate for me.

## Getting the SQL right

<p>Now we can finally get on to the real question</p>

```perl
my $sth = $dbh->prepare(q[
             SELECT
               AcNo,
               SUM(CASE WHEN Type = ? THEN Amount ELSE 0 - Amount DONE)
             FROM
               banktran
             GROUP BY
               AcNo]);

$sth->execute('Dr');
my $res = $sth->fetchall_arrayref();

use Data::Dumper;
print Dumper $res;
```

Here are a few things.  The first statement prepares the SQL I am about
to run.  Under normal circumstances, this allows the database driver to
compile the SQL into some sort of internal format so that it can be executed
multiple times faster.  However, I'm not sure if the CSV driver does any
pre-compilation though it does do validation.  And we're only running this
once.  In general, however, this is a good idea.

The SQL also uses a placeholder value.  This is to ensure that invalid
values don't get through.  In this particular case, the value is also
hard-coded, so it doesn't actually gain us anything other than exposure and
experience.

The SQL itself is a bit more involved.  We are telling the SQL engine
that we want to get the account number (**AcNo**) and the total of
the **Amount**s from the **banktran** table (which the f_ext above will tell
DBD::CSV to map to banktran.csv), but when Type is Dr, we want to count **Amount**
as a positive, otherwise we count it as a negative.  At this point, I'm not sure
if the zero is required here or not, but first let's get something working,
and then we can tweak it.  The **GROUP BY** tells the SQL engine that
we want to do this select where the sum is applied per AcNo - different AcNo's
will have independent sums.

There is much more to the SQL than this, but as mentioned earlier,
there are many more places to learn SQL than there is Text::CSV_XS, and you
can use those resources to improve your SQL knowledge.  Also, I'm a novice
in SQL, so probably am not the best person to teach it.

Having compiled the SQL, we then call execute which executes the statement,
and then fetchall_arrayref which does pretty much exactly what it says: returns
all of the rows as a single reference to an array.  We then use Data::Dumper
to dump this out to see what type of data we have so we know what steps
to take next.

Executing this so far gives the following output:

```perl
$ perl banktran.pl
Bad table or column name: '=' has chars not alphanumeric or underscore!
   at /usr/lib64/perl5/vendor_perl/5.12.3/SQL/Statement.pm line 88
DBD::CSV::db prepare failed: Bad table or column name: '='
   has chars not alphanumeric or underscore!
   at /usr/lib64/perl5/vendor_perl/5.12.3/SQL/Statement.pm line 88
 [for Statement "
           SELECT
             AcNo,
             SUM(CASE WHEN Type = ? THEN Amount ELSE 0 - Amount DONE)
           FROM
             banktran
           GROUP BY
             AcNo"] at banktran.pl line 32.
DBD::CSV::db prepare failed: Bad table or column name: '='
   has chars not alphanumeric or underscore!
   at /usr/lib64/perl5/vendor_perl/5.12.3/SQL/Statement.pm line 88
 [for Statement "
             SELECT
               AcNo,
               SUM(CASE WHEN Type = ? THEN Amount ELSE 0 - Amount DONE)
             FROM
               banktran
             GROUP BY
               AcNo"] at banktran.pl line 32.
```

Whoops.  It looks like SQL::Statement doesn't support the **CASE** syntax
that other databases do.  Well, this will mean we have to do a bit more work
in perl to compensate.  And should we want to move to another database in
the future, we may want to mark this so that we can come back to it.  The
solution we will eventually use will also work with other databases, of course,
but may not be quite as "pure" SQL.  And, in general, other databases have
this code done in C and so will be able to do what we will do faster.  Further,
with client/server databases (where the database is not on the same machine
as the perl code that is requesting data), it can also reduce the amount of
network traffic.  Whether these concerns are of any importance to your
project will, of course, depend on what constraints you have.

## Retrying with simpler SQL

To simplify the SQL such that SQL::Statement will accept it, I've opted
to **GROUP BY** both the **AcNo** and the <b>Type</b>.  This will
allow me to total the **Amount** field for both debits and credits, per account,
and have only a single subtraction to do later.

```perl
my $sth = $dbh->prepare(q[
             SELECT
               AcNo,
               Type,
               SUM(Amount)
             FROM
               banktran
             GROUP BY
               AcNo, Type]);

$sth->execute();
my $res = $sth->fetchall_arrayref({});

use Data::Dumper;
print Dumper($res);
```

Having replaced the non-working prepare above with this, I get the
following output:

```perl
$ perl banktran.pl
$VAR1 = [
          {
            'Type' => 'Dr',
            'AcNo' => '5522341',
            'SUM' => 7000
          },
          {
            'Type' => 'Cr',
            'AcNo' => '5131342',
            'SUM' => 5120
          },
          {
            'Type' => 'Cr',
            'AcNo' => '5522341',
            'SUM' => 3000
          },
          {
            'Type' => 'Dr',
            'AcNo' => '5131342',
            'SUM' => 6000
          }
        ];
```

Now we're getting somewhere.  The total debits for 5522341 is 7000,
credits for 5131342 is 5120, etc.  Notice how there's no rhyme or reason
to the output.  That's because we didn't ask the SQL engine to ORDER BY
anything.  It comes back in whatever order it feels like.  We would have to
specify "ORDER BY AcNo, Type" to order it by account number and then, within
each account number, by type (Cr &lt; Dr, of course).

To perform the equivalent SUM(CASE...) from the first attempt, I start
by populating a hash of the above:

```perl
# pull together debits and credits.
my %totals;
for my $r (@$res)
{
    $totals{$r->{AcNo}}{$r->{Type}} = $r->{SUM};
}
```

The keys at the top are the account numbers, and subkeys are the types
of transactions.  Since there is, by definition of SQL, only one row for
each of these pairings as that is the GROUP BY we did, I don't need to worry
about accidentally clobbering anything here.

## The Output as a table

During output I do the subtraction.  In this case, I have no idea what
the original requester really wanted, but we have all the information from
the CSV that we wanted, so it's really not that important.  I've opted to
use one of my favorite modules, [Text::Table](https://metacpan.org/pod/Text::Table).

```perl
use Text::Table;
my $tb = Text::Table->new("Account\nNumber", "Total\n(Rs)");

$tb->load(
          map {
              [ $_, $totals{$_}{Dr} - $totals{$_}{Cr} ]
          } sort keys %totals
         );

print $tb;
```

We load Text::Table, and then create the object.  Its constructor
takes the column headers to use, so I fill that in.  The load could be
done a little more readily, but, again, the main point is where we
do the subtraction of Cr from Dr.  Text::Table wants each row as an
array reference, so we create that via map.  Outside of the map, we
get all of the keys from %totals (from above, that was what we got
from the database as AcNo), and sort them.  Note that this is, by default,
a string sort - if you want numerical sorting, you'll have to provide that.</p>
<p>Inside the map, we create an anonymous array, put the key (AcNo) as the
first column, and perform the subtraction as the second column, this is
the total we wanted from the outset, and then return the array.

## The whole solution

<p>Putting all this together, we get:</p>

```perl
#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use File::Basename qw(dirname);
use File::Spec;

my $dbh = DBI->connect('dbi:CSV:', undef, undef,
              {
                  f_dir => File::Spec->rel2abs(dirname($0)),
                  f_ext => '.csv',
                  csv_eol => "\n",
                  RaiseError => 1,
              });

my $sth = $dbh->prepare(q[
               SELECT
                 AcNo,
                 Type,
                 SUM(Amount)
               FROM
                 banktran
               GROUP BY
                 AcNo, Type]);

$sth->execute();
my $res = $sth->fetchall_arrayref({});

# pull together debits and credits.
my %totals;
for my $r (@$res)
{
    $totals{$r->{AcNo}}{$r->{Type}} = $r->{SUM};
}

use Text::Table;
my $tb = Text::Table->new("Account\nNumber", "Total\n(Rs)");

$tb->load(
          map {
              [ $_, $totals{$_}{Dr} - $totals{$_}{Cr} ]
          } sort keys %totals
         );

print $tb;
```

<p>And for output:</p>

```
$ perl banktran.pl
Account Total
Number  (Rs)
5131342  880
5522341 4000
```

