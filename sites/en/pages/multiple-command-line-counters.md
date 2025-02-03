---
title: "Multiple command line counters with plain TSV text file back-end"
timestamp: 2015-09-30T15:30:01
tags:
  - split
  - \t
  - CSV
  - TSV
published: true
books:
  - counter
author: szabgab
archive: true
---


As part of the [big counter example](https://code-maven.com/counter) project, this example runs on the command line and uses a plain text file as back-end 'database'.
It is the second most basic version of all the [counter examples](https://code-maven.com/counter), that provides multiple counters.
(The most simple one provided a [single counter](/command-line-counter).
It accepts a value (a word) on the command line and uses a separate counter for each such value.


## Front-end

The front end is the command line. We just run the script as `perl counters.pl foo` providing the name of the counter on the command line.

## Back-end

In this example the "database" is going to be a simple file called 'counters.txt' with several lines in it. Every line represents one counter.
In every line we save the "name of the counter" and the most recent number separated by a `TAB` character.

This can of file is called a TSV which stands for Tab Separated Values. It is a special case of what people usually refer to as CSV file
(though CSV really stands for Comma Separated Values). The idea behind these files is that we have many rows of data and in each row
we have multiple fields. Just like in a spreadsheet (e.g. Microsoft Excel). The lines are separated by newlines, the fields are separted
by some character. In a CSV file this is a comman. In a TSV file this separator character is a TAB, but in the general case any character
can be used a separator as long as both who writes the file and who reads the file agree on the separator character.

In the generic case a CSV file can contain even newslines inside its lines which makes parsing it quite complex. That's
why for th generic case there are specilalized module that can [read and write CSV files](/search/Text::CSV),
but in our case we can assume that the name received on the command line does not contain a TAB and this we can get-by
with the use of [split](/perl-split).

## Code


The multiple counter example is a lot more complex.

In the memory we need to keep a mapping from "counter name" to "counter value. We can use a hash where each key is a "counter name" and
each value is the respective "counter value", but we will need to map this to the 'database' file and then we will have to be able to read
the data back from the file and fill the hash.

For the database file we are going to use the rather simple TSV format explained above.
We just need to assume that the character which separates the fields (TAB in our case), cannot be part of any of the values.

{% include file="examples/counters.pl" %}

Let's then see the implementation. After declaring the `$file` variable that contains the name of the storage file, we retreive the value
from the command line and complain (throw an exception using `die`) if the user has forgotten to pass a value.
[@ARGV](/argv-in-perl) contains the list of values on the command line (and it does not include the script itself).


```perl
my ($name) = @ARGV;
```

copies the first value from `@ARGV` to `$name`. Please make sure you include the parentheses around the `$name` variable.
Without those the assignment will be in [scalar context](/scalar-and-list-context-in-perl) and Perl will assign the length of the `@ARGV` array to
the `$name` variable.

The next expression:

```perl
die "Usage: $0 NAME\n" if not $name;
```

will throw an excpetion if the user has not supplied any value on the command line.

Then we declare the hash `%counters` where we are going to store our counters in memory.

Unlike in the [single command line counter](/command-line-counter) case, here we cannot assign an initial 0 to all the keys
as any string can be a key. We will have to rely on the [autovivification](/autovivification) feature of Perl.
When we increment the value of one of the keys that did not exists before (e.g. `$counters{foo}++;`),
that key will just spring into existence pretending its value is 0 which is then incremented to 1.


The next step here too is checking if the 'counters.txt' file exists, but as it does not exist during the first run, we will skip that code for now
and look at the code after the closing curly brace.

There we will just increment the value of the appropriate key in the hash using the `$counter{$name}++;` expression.
If there already was a key `$name` then it is quite clear that this code will just increment that number, but what will happen
the first time we encounter the given value? And especially the first time we run the script when the hash is still empty?

That's where [autovivification](/autovivification) playes its nice role. The key will just appear from nowhere with a value
of `undef`. Because in a numerical operation, such as `++`  `undef`, acts as if it was actuall 0, the autoincrement
will increase it to 1, and that will be the new value of the `$name` key in the `%counter` hash.
Then we just print the new content of `$counter{$name}`.

In the next few lines:

```perl
open my $fh, '>', $file or die "Could not open '$file' for writing. $!";
foreach my $str (keys %counter) {
    print $fh "$str\t$counter{$str}\n";
}
close $fh;
```

we open the 'counters.txt' file for writing, then we go over all the keys of the `%counter` hash (that were fetches by the `keys` keyword)
and for each key we print the key (in the `$str` variable), a TAB (represented in Perl by `\t`) and the corresponding value of in `%counter`.
Finally we close the file.

After incrementing the current counter, this will save the new values back in the file.

Now that we have seen how do we save the counters.txt file, lets' go back to the `if` statement and see how can we read the file.

```perl
if (-e $file) {
    open my $fh, '<', $file or die "Could not open '$file' for reading. $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($str, $count) = split /\t/, $line;
        $counter{$str} = $count;
    }
    close $fh;
}
```

After making sure that the file exists using the `-e` operator we try to [open the file for reading](/open-and-read-from-files) and throw
an exception using `die` we we don't succeed.
Then we need to go over all the rows of the file which we do using the `while` loop. As the condition of the `while`
statement we can see a simple call to the readline operator of Perl. Just we have seen in the [simple example](/command-line-counter).
Then we do something different though. We call the [chomp](/chomp) function to remove the trailing newline.
The `$line` variable holds a string followed by a TAB, followed by a number. We use [split](/perl-split) along the TAB to cut the string into
two pieces and we assign those two pieces to `$str` and `$count` respsectively.

Then we insert the key-value pair into the `%counter` hash.

Finally we close the file.

Try the script:

```
$ perl counters.pl 
Usage: counters.pl NAME

$ perl counters.pl foo
1

$ perl counters.pl bar
1

$ perl counters.pl bar
2

$ perl counters.pl bar
3

$ perl counters.pl foo
2
```

## sort

If you ran the script several times with several counters, you'll notice that the order of the lines in the database file always changes.
That's because we save the rows in the same order the `keys` function returns the key and it returns the keys in random order.
If you'd like the order to be stable then you can `sort` the keys and iterate over the sorted keys:

```perl
foreach my $str (sort keys %counter) {
```


## Memory size/processing time

This is not really an issue, but let me just mention it.
In this solution on every run of the script we load the whole 'counters.txt' into memory. If there are many counters (in the millions)
then this can be both time-consuming and it can take a lot of memory of the script. There will be other solutions
in the [counter examples](https://code-maven.com/counter) with different back-ends that will make it easy to fecth and store a single entry.


