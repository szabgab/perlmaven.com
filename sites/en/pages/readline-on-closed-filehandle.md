---
title: "readline() on closed filehandle in Perl"
timestamp: 2018-04-25T08:30:01
tags:
  - open
  - warnings
published: true
author: szabgab
archive: true
---


In a Perl program all kinds of things can go wrong and if you don't [use warnings](/always-use-warnings)
then you might not even know about it.

Take this examples that has a programming mistake.
Perl would generate a `readline() on closed filehandle` warning if warnings were enabled
helping you locate the problem, but it would silently and probably incorrectly(!) work without the
warnings.


## Not checking if 'open' was successful

There are several programming issues in the following examples:

{% include file="examples/try_to_read_log_file.pl" %}

If we run this script it will run silently regardless of the existence of the file `/tmp/application.conf`
it tries to read.

If we turn on `use warnings` as [recommended](/always-use-warnings)
then, if the file we are trying to open does not exists we'll get a run-time warning:

```
readline() on closed filehandle F at ...
```

The real problem of this code is that we don't check the return value of `open`.

The recommended way to [open a file](/open-and-read-from-files) is to either write

```
open ... or die ...
```

or to write 

```
if (open ...) {

}
```

but in this case the author have forgotten to protect the code in case the file is missing
or cannot be read for some other reason.

The solution is to use either of the above construct.

There is another issue of [opening the file in the old way](/open-files-in-the-old-way)
instead of the recommended [3-argument open](/always-use-3-argument-open), but the main
issue is the lack of error checking.

## Conclusion

[Always use strict](/strict) and 
[always use warnings](/always-use-warnings). 

They can protect you from certain programming mistakes.

## Comments

I think you forgot to actually use readline() in your example code. also, why would you name the life "try_to_read_log_file.pl" when you are opening an obviously config file? :-)

<hr>

Why not add in an existence check on the file itself before the open command? Both are better since this is not an atomic operation.

if ( -f $filename ) {
    open F, '<:encoding(utf8)', $filename or die "$!: $filename";
        BLAH BLAH BLAH;
   close F;
}

NOTE: Depending on the usage, the "-s" test may be better to see if the file size is > 0.

@flamey : simple - the conf file references the log files so you can open them later in the code. : )

