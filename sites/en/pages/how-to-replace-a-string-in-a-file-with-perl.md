---
title: "How to replace a string in a file with Perl"
timestamp: 2013-04-05T13:10:10
tags:
  - open
  - close
  - replace
  - File::Slurp
  - read_file
  - write_file
  - slurp
  - $/
  - $INPUT_RECORD_SEPARATOR
  - Path::Tiny
published: true
books:
  - beginner
author: szabgab
---


Congratulations! Your start-up company was just bought by super large corporation.
You now need to replace **Copyright Start-Up** by **Copyright Large Corporation**
in the README.txt file



If you need to do this as part of a larger application then go on reading this article.
On the other hand, if this is a stand-alone work then you can do this with a
[one-liner replacing a string in a file](/perl-on-the-command-line).

## Using Path::Tiny

If you can install [Path::Tiny](https://metacpan.org/pod/Path::Tiny) and
if the file is not too large to fit in the memory of your computer,
then this can be the solution:

```perl
use strict;
use warnings;

use Path::Tiny qw(path);

my $filename = 'README.txt';

my $file = path($filename);

my $data = $file->slurp_utf8;
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
$file->spew_utf8( $data );
```

The `path` function imported from [Path::Tiny](https://metacpan.org/pod/Path::Tiny) accepts
a path to a file and returns an object that can be used for all kinds of interesting things.
The `slurp_utf8` method will read in the content of the file (after opening it with UTF8 encoding) and
return all the content as a single string.

The `s///` substitution does the string replacement. It uses the `/g` global flag to replace all the
occurrences. 

The `spew_utf8` method will write out the string passed to it to the underlying file, replacing all the content.

## File::Slurp

This is an older version of it. It is less preferable than the Path::Tiny one, but
if you already have [File::Slurp](https://metacpan.org/pod/File::Slurp) installed
and then this can be the solution:

```perl
use strict;
use warnings;

use File::Slurp qw(read_file write_file);

my $filename = 'README.txt';

my $data = read_file $filename, {binmode => ':utf8'};
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
write_file $filename, {binmode => ':utf8'}, $data;
```

The `read_file` function of File::Slurp will read the whole file into a
single scalar variable. This assumes the file is not too big.

We set `binmode => ':utf8'` to correctly handle Unicode characters.
Then a regex substitution is used with the `/g` modifier to **globally**
replace all the occurrences of the old text by the new text.

Then we save the content in the same file, again using `binmode => ':utf8'`
to handle Unicode characters correctly.


## Replace content with pure Perl

If you cannot install File::Slurp you can implement a limited
version of its function. In this case, the main body of the code is almost
the same, except that we don't pass the parameters to open the file in Unicode
mode. We have that coded in the functions themselves. You can see how it is done
in the calls to `open`.

```perl
use strict;
use warnings;

my $filename = 'README.txt';

my $data = read_file($filename);
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
write_file($filename, $data);
exit;

sub read_file {
    my ($filename) = @_;

    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all;
}

sub write_file {
    my ($filename, $content) = @_;

    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;

    return;
}
```

The `read_file` function we set the `$/` variable (which is also called $INPUT_RECORD_SEPARATOR)
to `undef`. This is what is usually referred to as [slurp mode](/slurp). It tells the "read-line" operator
of Perl to read in the content of all the file into the scalar variable on the left-hand-side of the
assignment: `my $all = &lt;$in>;`. We even used the `local` keyword when we set `$/` so
this change will be reverted once we exit the enclosing block - in this case, once we leave the `read_file`
function.

The `write_file` function is much more straight forward and we put it in a function only to make the
main body of the code similar to the previous solution.

## Comments

Thank you! So helpful :)

---

Hi , i need help im new , how can i writh a perl script using regex replace to put names and Last names in the strings . my english is not good soory .
```
<div>
<label>First name:</label>First name

<label>Last name:</label>Last name

</div>
```

<hr>

You probably want to clarify that the variable $filename require a full path, at least for me is not working if I don't pass it with the full path to the file

<hr>
Thank you for this job. It's really interesting. But please if you can explane more all the solutions because some times i didnt get how it works. Thanks a lot 
<hr>

give perl program example with explanation using scalar variable

<hr>

Hi All,

$filename = "${datafile1}NPS_${BUSINESSDATE}.txt";
$lines = 0;
open(FILE, $filename) or die "Can't open `$filename': $!";
while (sysread FILE $buffer, 4096) {
$lines += ($buffer =~ tr/\n//);

}
close FILE;
$tot_records= $lines-1 ; ##Minus 1 for the header
open (FILE, ">> $filename") || die "problem opening $filename\n";
print FILE "TOTAL COUNT|$tot_records\n";
close FILE;

need to add command in removing "(double quotes in file.

please let me know where can i add the command.

<hr>

Hello, honestly too much to consume for me but after a day of battling with scripting and reading forums I would need kind of help.

I have 2 files where I`m looking for a way how to find from the 2nd one a specific line that start with specific string ending with another one and extract the string between these 2 strings;
Then do the lookup in 1st file for this string from the top of the file and return its value that is located 2 lines below the 1st finding and again located after specific strings:

Example:
1st file explanations.txt contains:
blablabla
edit "20nd_Aug_2020"
set start 13:55 2019/07/25
set end 23:59 2020/08/20
blablabla

2nd file definitions.txt:
blablabla
set schedule "20nd_Aug_2020" <---
blablabla

1: in the 2nd file find each line starting with ' set schedule "' ending with '" <---'
2: replace these 2 strings with nothing and save '20nd_Aug_2020' as a temporary value
3: look for this value '20nd_Aug_2020' from the top in the 1st file and replace with string (2 lines below its 1st match and after the string set end) '2020/08/20'

I was able to come up with this command that covers the point #1 and partially #2:
perl -pe 's%(.*set schedule ".*" <---)% ($_x = $1) =~ s/(.*set schedule "|" <---)//g; $_x %eg' definitions.txt
In the output I see that the matched line from the 2nd file is filtered out correctly.
- but can`t figure out which symbol(s) are causing the misinterpretation of the logic when this command is parsed into the perl script.
The result is "nothing" not even an empty file.

<hr>

Please do not recommend File::Slurp. Use File::Slurper instead, its read_text function automatically will apply the correct UTF-8 decoding.

