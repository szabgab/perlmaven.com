---
title: "Common causes and fixes for HTTP 500 Error in Perl CGI scripts"
timestamp: 2022-02-25T09:30:01
tags:
  - Perl
  - CGI
published: true
author: szabgab
archive: true
show_related: true
---


One of the nasty things that can happen in a Perl CGI environment is to get a 500 HTTP error. It is nasty as it is hard to know what is the problem and how to solve it.

The first step is to look at the error log of your web server, if you can. If you can't well, best would be to change hosting to one that will give you access to the error
log.

On this page you'll find some of the most common cases and their solutions.


* The CGI script is not executable
* First line is not an sh-bang line
* No header (no Content-type)
* DOS-style line endings
* Exception in the code

## Checking syntax errors

A basic thing would be to make sure we do not have a syntax error in the file on the server:

```
perl -c app.pl
```

It might be also useful to turn on warnings using the <b>-w</b> flag and to make sure there are no warnings emitted
by the program, but if you wrote it carefully following my suggestions to [always use warnings](/always-use-warnings)
then this is not necessary. In any case you could try this:

```
perl -cw app.pl
```


## The CGI script is not executable

Check if the rights on the file:

```
$ ls -l app.pl
-rw-rw-r-- 1 gabor gabor 378 Feb 25 08:57 app.pl
```

Solution: Make it executable:

```
chmod +x app.pl
```

```
$ ls -l app.pl
-rwxrwxr-x 1 gabor gabor 378 Feb 25 08:57 app.pl
```


## First line is not an sh-bang line

You try to run the script on the command line and get some strange error:

```
$ ./app.pl
./app.pl: line 3: use: command not found
./app.pl: line 4: my: command not found
```

Solution:

Make sure the first line of app.pl looks something like this:

```
#!/usr/bin/perl
```

or

```
#!/usr/bin/env perl
```

Pay attention, if you have a space after the hash-sign you still get error. This is NOT good:

```
# !/usr/bin/env perl
```


## No header (no Content-type)

You run the code and you see the HTML content, but not the header:

```
$ ./app.pl
<h1>Hello World</h1>
```

The response need to have a header like this:

```
$ ./app.pl
Content-Type: text/html; charset=utf-8

<h1>Hello World</h1>
```

How can you achieve that?

print it yourself:

```
print "Content-Type: text/html; charset=utf-8\n\n";
```

Note, there are two newlines at the end as the body (the HTML content) must be separated from the header by an empty row.

using the CGI module:

```
use CGI;
my $q = CGI->new;
print $q->header(-charset => 'utf-8');
```

## DOS-style line endings

```
$ ./app.pl
/usr/bin/env: ‘perl\r’: No such file or directory

$ echo $?
127
```

This can happen if you have uploaded the file from a Windows machine and it did not go through new-line conversion.

The solution is to convert the dos-style newlines to linux/unix-style newlines either on the server:

```
unix2dos app.pl
```

or makes sure the upload does the conversion. (ftp text mode)

## Exception in the code

Sample code:

{% include file="examples/without_defindness_checking/app.pl" %}

```
$ ./app.pl
Content-Type: text/html; charset=utf-8

<h1>Hello World</h1>
Illegal division by zero at ./app.pl line 11.
```

From this you can already see there is something fishy, but now also check the exit code:

```
$ echo $?
255
```

It is expected to be 0 after every successful run.

Fixing: check if the parameters you are expecting were supplied.

{% include file="examples/without_input_checking/app.pl" %}

This works now:

```
$ ./app.pl
Content-Type: text/html; charset=utf-8

<h1>Hello World</h1>
y was missing
```

The exit code is now 0:

```
$ echo $?
0
```

However if the user sends in y to be 0 we still have a problem.

This is how you can try on the command line:

```
$ ./app.pl x=6 y=0
Content-Type: text/html; charset=utf-8

<h1>Hello World</h1>
Illegal division by zero at ./app.pl line 15.
```

The exit
```
$ echo $?
255
```

Check also with good parameters:

```
$ ./app.pl x=6 y=2
Content-Type: text/html; charset=utf-8

<h1>Hello World</h1>
6 / 2 = 3
```

Solution:

{% include file="examples/checking_parameters/app.pl" %}

Now:

```
$ ./app.pl x=6 y=0
Content-Type: text/html; charset=utf-8

<h1>Hello World</h1>
y was 0
$ (gabor@code-maven:~/work/perlmaven.com) (main) $ echo $?
0
```


