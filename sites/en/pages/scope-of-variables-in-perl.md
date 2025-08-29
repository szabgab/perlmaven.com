---
title: "Scope of variables in Perl"
timestamp: 2013-04-17T17:45:59
tags:
  - my
  - scope
published: true
books:
  - beginner
author: szabgab
---


There are two major variable types in Perl. One of them is the package global variable declared either with the now obsolete
`use vars` construct or with `our`.

The other one is the lexical variable declared with `my`.

Let's see what happens when you declare a variable using `my`? In which parts of the code will that variable be visible?
In other words, what is the **scope** of the variable?


## Variable scope: enclosing block

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $email = 'foo@bar.com';
    print "$email\n";     # foo@bar.com
}
# print $email;
# $email does not exists
# Global symbol "$email" requires explicit package name at ...
```

Inside the anonymous block (the pair of curly braces `{}`), first we see the declaration of a new variable called
`$email`. This variable exists between the point of its declaration till the end of the block. Thus the line
after the closing curly brace `}` had to be commented out. If you removed the `#` from the
`# print $email;` line, and tried to run the script, you'd get the following compile-time error:
[Global symbol "$email" requires explicit package name at ...](/global-symbol-requires-explicit-package-name).

In other words, the **scope of every variable declared with my is the enclosing block.**.

## Variable scope: visible everywhere

The variable `$lname` is declared at the beginning of the code. It will be visible
till the end of the file everywhere. Even inside blocks. Even if those are function declarations.
If we change the variable inside the block, that will change the value for the rest of the code.
Even when you leave the block:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $lname = "Bar";
print "$lname\n";        # Bar

{
    print "$lname\n";    # Bar
    $lname = "Other";
    print "$lname\n";    # Other
}
print "$lname\n";        # Other
```


## Variable hidden by other declaration

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname = "Foo";
print "$fname\n";        # Foo

{
    print "$fname\n";    # Foo

    my $fname  = "Other";
    print "$fname\n";    # Other
}
print "$fname\n";        # Foo
```

In this case the variable `$fname` is declared at the beginning of the code. As written earlier, it will be visible
till the end of the file everywhere, **except in places where they are hidden by locally declared variables with the same name**.

Inside the block we used `my` to declare another variable with the same name. This will effectively hide the `$fname`
declared outside the block till we leave the block. At the end of the block (at the closing `}`), the `$fname`
declared inside will be destroyed and the original `$fname` will be accessible again.
This feature is especially important as this makes it easy to create variables inside small scopes without the need to think
about possible use of the same name outside.

## Same name in multiple blocks

You can freely use the same variable name in multiple block. These variables have no connection to each other.

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $name  = "Foo";
    print "$name\n";    # Foo
}
{
    my $name  = "Other";
    print "$name\n";    # Other
}
```

## in-file package declaration


This a bit more advanced example, but it might be important to mention it here:

Perl allows us to switch between **name-spaces** using the `package` keyword inside
a file. A package declaration does **NOT** provide scope. If you declare a variable in
the implicit **main package** which is just the regular body of your script, that `$fname`
variable will be visible even in other name-spaces in the same file.

If you declare a variable called `$lname` in the 'Other' name-space, it will be visible
when later you might switch back to the `main` name-space. If the `package Other`
declaration was in another file, then the variables would have separate scope created by
the file.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname  = "Foo";
print "$fname\n";    # Foo

package Other;
use strict;
use warnings;

print "$fname\n";    # Foo
my $lname = 'Bar';
print "$lname\n";    # Bar


package main;

print "$fname\n";    # Foo
print "$lname\n";    # Bar
```


