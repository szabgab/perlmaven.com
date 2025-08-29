---
title: "Can't call method ... on unblessed reference"
timestamp: 2014-04-03T08:10:01
tags:
  - B::Deparse
published: true
books:
  - beginner
author: szabgab
---


A while ago I got an e-mail from one of the readers with the following question:

<blockquote>
What is the difference between `subname $param` and `subname($param)`?

One seems to work, the other throws an error `Can't call method ... on unblessed reference`.
</blockquote>

In other words:  **do you have to put parentheses around the parameters of function calls?**


Let's look at some things:

## require

If we run the following script we will get an error:
`Can't call method "Storable::freeze" on unblessed reference at ...` pointing to the line
where we call `Storable::freeze $data;`.

```perl
use strict;
use warnings;

require Storable;

my $data = { a => 42 };
my $frozen = Storable::freeze $data;
```


If we change the problematic line and put the parameters in parentheses:
`my $frozen = Storable::freeze($data);`, everything works fine.


## B::Deparse

Let's try to use B::Deparse again. Once it already
[helped us with the for loop](/bug-in-the-for-loop-b-deparse-to-the-rescue).


Let's run the first version of the script using `perl -MO=Deparse  store.pl`:

```perl
use warnings;
use strict;
require Storable;
my $data = {'a', 42};
my $frozen = $data->Storable::freeze;
```

and the the second version of the script:

```perl
use warnings;
use strict;
require Storable;
my $data = {'a', 42};
my $frozen = Storable::freeze($data);
```

The second version returned exactly the same code as we had in our file.
(Well, except that it replaced the [fat-arrow](/perl-hashes) by a comma, but we know they are the same.)

On the other hand, in the first script, the critical part of the code was changed to 
`$data->Storable::freeze;`.

Perl thought that we are calling the `Storable::freeze` method on the `$data` object.
This code would work if the `$data` was a [blessed reference](/getting-started-with-classic-perl-oop),
though it would probably do something different than what we meant.

## use

If we replace the `require Storable;` by `use Storable;` then both cases work correctly,
and in both cases B::Deparse will show the code as being `Storable::freeze($data);`

## eval "use Storable";

If instead of calling `use` directly we wrap it in an `eval` statement with a string
after it, the problem appears again.

## Explanation

`use` happens at compile time. By the time perl sees the call to `Storable::freeze` it has
already loaded the `Storable` module.

`require` and `eval "use ...";` happens at run time, so when perl compiles the
`Storable::freeze $data` call, it does not know that there is going to be a `Storable::freeze`
functions. At this point it needs to guess what this code is, and it guesses, incorrectly,
that we are using the so-called **indirect object notation**. It thinks `$data` is going to be
an object and `Storable::freeze` is a method of this object.

That's why B::Deparse shows this code as `$data->Storable::freeze;`.

## Solution

In order to eliminate the error you need to make sure the functions you use are already defined or loaded
before you actually use them. Putting parentheses after the function call eliminates this restriction,
and allows you put the function call wherever you want.

## Comments

Hello,

I am using below code.

my $sql = "SELECT sn, givenName, employeeID, mail, sAMAccountName, department, cn, company
FROM '$table' ";

$a = $recordSearch->Fields('sn')->{Value};

I am getting "Can't call method "Fields" on unblessed reference" error. I am using Perl 5.12

It's using ADO

Please help me on this

----

Is that all your code? Where is use strict? Where did you assign value to $recordSearch?

---

Hi Gabor,

If I use strict then the page is not responding properly.
I am using ADODB connection to get the details from AD group and when I try to execute the sql query using ADODB command , I am getting below exception

code:

#!/usr/local/bin/perl
$|=1;

use CGI qw(:all);
use English;
use Sys::Hostname;
use Win32::OLE 'in';
use Net::LDAP;
use Net::LDAP::Util qw(ldap_error_name ldap_error_text);
use Mime::Lite;
use DBI;

my $connObj = Win32::OLE-> new("ADODB.Connection") || die "Connection ERROR: " . Win32::OLE->LastError() . "\n";
my $recordSearch = Win32::OLE-> new("ADODB.Recordset") || die "Recordset ERROR: " . Win32::OLE->LastError() . "\n";
my $cmdObj = Win32::OLE-> new("ADODB.Command") || die "Command ERROR: " . Win32::OLE->LastError() . "\n";

$connObj-> {Provider} = ("ADsDSOObject") || die "Provider ERROR: " . Win32::OLE->LastError() . "\n";
$connObj-> Open();
$cmdObj-> {ActiveConnection} = ($connObj);

my $table = "GC://.......";
my $sql = "SELECT name
FROM '$table'
WHERE objectCategory = 'person'
AND objectClass='user'";

$cmdObj-> {CommandText} = ("$sql");
$recordSearch = $cmdObj-> Execute;

Error: [-2147467259] Unspecified error

----

1) Read why is it important to always use strict and warnings, add them to your code and figure out what are they complaining about. They are there to help you find bugs. https://perlmaven.com/always-use-strict-and-use-warnings
2) In the code you pasted there is no such line that you had in your original question so this is not the whole code
3) In this code you assign to $recordSearch twice. That looks incorrect.
4) Figure out why is $recordSearch undef!

