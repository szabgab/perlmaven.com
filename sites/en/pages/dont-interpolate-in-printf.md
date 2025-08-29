---
title: "Don't interpolate in printf (Missing argument in sprintf at ...)"
timestamp: 2014-08-10T15:30:01
tags:
  - printf
  - sprintf
types:
  - screencast
published: true
author: szabgab
---


Just the other day, when I ran one of my scripts, I encountered an exception `Missing argument in sprintf at ...`.
The nasty thing was the line number showed one of my logging calls. I think this is one of the nastiest thing when
you have a bug in your logging or debugging statement...

Anyway, I created a smaller version of the problem. Look at the example:


{% youtube id="Plv9nT9RzdE" file="dont-interpolate-in-printf" %}

In the root directory of the project I had two files, a script and a module representing the current file
to be processed:

```
dir/
   printf_interpolate.pl
   lib/App/File.pm
```


The `printf_interpolate.pl` script looks like this:

```perl
use strict;
use warnings FATAL => 'all';

use App::File;

my $LIMIT = 80;

my $file = read_params(@ARGV);
_log("START");
check_file($file);
_log("DONE");


sub read_params {
    my $filename = shift or die "Usage: $0 FILENAME\n";
    my $file = App::File->new($filename);
    return $file;
}

sub check_file {
    my ($file) = @_;

    open my $fh, '<', $file->filename or die;
    while (my $line = <$fh>) {
        my $actual = length $line;
        if ($actual > $LIMIT) {
            _log(sprintf "Line is too long ($actual > $LIMIT) ($line) (file %s)", $file->filename);
        }
    }
}


sub _log {
    my $str = shift;
    say $str;
}
```

All this example does is reading in a file line-by-line and checking if each line is shorter than
the expected line. If it the line is too long, call the `_log` function and report the issue.

The `/lib/App/File.pm` looks like this:

```perl
package App::File;
use strict;
use warnings;

sub new {
    my ($class, $filename) = @_;
    return bless {filename => $filename}, $class;
}
sub filename {
    my ($self) = @_;
    return $self->{filename};
}

1;
```

It is a simple module representing the file. (In the real code it was of course much more complex, but
this is enough to show the problem.

So what if I run the script passing itself as a parameter? That is, what if we check that none of the lines
of this script is longer than 80 characters?

```
cd dir/
perl printf_interpolate.pl printf_interpolate.pl
```

After seeing the word "START" printed, we get the following exception:
`Missing argument in sprintf at printf_interpolate.pl line 27, <$fh> line 27.`
pointing us to the line where we call `sprintf`.

It took me a while to understand two things:

First of all, this was actually a **warning**, but because of the `FATAL => 'all'`, all the warnings were turned into fatal exceptions.

The actual problem was that the line that was too long actually had some parts that looked like sprintf place-holders. You know the `%s` things.
As the `sprintf` statement had some embedded (interpolated) variables in it (specifically the `$line` variable), after the interpolation
the string contains more than one `%s` place-holders.

Changing the line to
```perl
  _log(sprintf "Line is too long ($actual > $LIMIT) (%s) (file %s)", $line, $file->filename);
```

solved the problem, as now we are inserting the `%s` snippets during the `sprintf` call and not
before it.

If we run the code now we'll see the following output:

```
START
Line is too long (104 > 80) (            _log(sprintf "Line is too long ($actual > $LIMIT) (%s) (file %s)", $line, $file->filename);
) (file printf_interpolate.pl)
DONE
```

Much better.

Of course if we have already moved one variable outside the string we should do with the other two as well, even though we can
assume they will be always numbers:

```perl
  _log(sprintf "Line is too long (%s > %s) (%s) (file %s)", $actual, $LIMIT, $line, $file->filename);
```

## Short example

The next snippet can already reproduce the warning:

```perl
use strict;
use warnings;

my $name = 'Foo';
#my $smalltalk = 'how are you?';
my $smalltalk = '%s hi?';

printf "Hello %s, $smalltalk\n", $name; 
```

```
Missing argument in printf at printf_interpolate_short line 8.
Hello Foo,  hi?
```

## Bottom line

If you use `printf`, or `sprintf` don't embed variables that might contain characters that have special meaning
for `sprintf`.





