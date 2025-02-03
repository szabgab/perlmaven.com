---
title: "Traversing a directory tree, finding required files"
timestamp: 2013-07-26T17:50:01
tags:
  - File::Find::Rule
  - map
published: true
author: szabgab
---


A few days ago one of the readers sent me a request that I'd like to share with you now.
First I include the e-mail I received, then I'll try to understand the problem, read a bit
of code and then provide a solution.

I replaced the name with Foo Bar, to keep the information private.


## The requests: Search file from Folders

Hi Gabor,

I am new to Perl. I want to test files in a directory also sub directory in windows platform.
Could you please explain how we can do this.

Folder Structure is like this.
Each folder has some .Pdf file.
I have list of pdf file & i want to check whether it is available in a directory from dir1.

```
                                dir1
                                 |
                                 |
                  -----------------------------------------------
                  |           |            |         |          |
                 dir2        dir3         dir4      dir5       dir6
                  |                        |
                  |                        |
       ----------------------         --------------
       |                    |         |            |
     dir7                  dir8      dir9         dir10
```

Now I am copying all pdf file into separate folder by manually & using this script i am checking it.
But i don't like manual work instead of i want to search from main Folder.

I am waiting for your mail. Thanks in advance.


Script which i used :-

```perl
print "Enter the file name:";
my $file=<>;
chomp($file);

open(OUT,$file) || die ("Could not open $file file.");

open(MYOP,">final.txt") || die ("Could not open $data file.");

print MYOP "Below files are not exist in the Dir:\n";

while ( $myfile = <OUT> )
{
print "Your File is:$myfile\n";

my $name = "C:/Users/foobar/files/$myfile";

#print "Full Path is $name\n";

chomp($name);
if ( -e "$name" )

#if ( -e "$file" )
{
    print "File exists!\n";
}
else
{
    chomp($myfile);
    print MYOP $myfile."\n"
}
}
```


----
Regards
   
   Foo Bar

## The understanding

First of all, I think Foo Bar commendable for both creating the ascii art of the directory structure
and writing a script that already works. Even if it has issues. I see too many people asking questions
without trying to solve the problem themselves. In many cases probably without even understanding
the problem.

Here we have an input file listing a number of files

```
a.pdf
b.pdf
c.pdf
```

and a directory structure.

We need to generate the subset of files from the listing that cannot be found in the directory structure.

We can go in two main directions.

1. We can first create a list of files in the given directory structure and then compare that list
with the list of expected file. This requires us to hold the list of the existing file in the memory,
which can be an issue if the lists are bigger than the memory of our computer.

2. For each expected file we can search in the directory tree.
This approach requires only one file-name at a time in the memory, but will require us to traverse the
directory structure for every file. It can take a lot of time, especially if there are a lot of expected
files.


Let's see an implementation of the first solution.
We'll use [File::Find::Rule](https://metacpan.org/pod/File::Find::Rule) to traverse
the file system and collect the filenames.

```perl
use strict;
use warnings;

use File::Find::Rule;
use File::Basename qw(basename);

my $path = "C:/Users/foobar/files/dir1";
my $report = 'final.txt';
my $expected = <STDIN>;
chomp $expected;

open(my $fh, '<', $expected) or die "Could not open '$expected' $!\n";
open(my $out, '>', $report) or die "Could not open '$report' $!\n";

my @full_pathes = File::Find::Rule->file->name('*.pdf')->in($path);
my @files = map { lc basename $_ } @full_pathes;
my %file = map { $_ => 1 } @files;

print $out "Below files do not exist in the Dir ($path):\n";
while (my $name = <$fh>) {
    chomp $name;
    if ($file{lc $name}) {
        print "$name found\n";
    } else {
        print $out "$name\n";
    }
}
close $out;
close $fh;
```

First we ask the user for the name of file with the expected list.
Then, even before collecting the file names we opened the file with the list of expected (or required?) filenames,
and the file where we create the report. That way, if either of this operations fail, we have not
wasted time traversing the whole directory tree.

The `File::Find::Rule->file->name('*.pdf')->in($path);` call file list all the `files`, that
match the wild-card `*.pdf` and can be found `in` the subdirectories of `$path`.

The only issue might be that on Windows the file names are case insensitive and I think the wild-card
of File::Find::Rule is always case-sensitive. So the above code will only find file with `.pdf` extension,
but not with `.Pdf` extension. The problem can easily be solved by writing: `->name('*.[pP][dD][fF]')`.
That will disregard case for all 3 letters.

The list of files returned by [File::Find::Rule](https://metacpan.org/pod/File::Find::Rule) contains the
full path to each file, while we only need the filename. For that we create a new array called `@files`
after we called `basename()` on each one of the entries. For this we used [map](/transforming-a-perl-array-using-map).
We also called `lc()` on each name to turn them into a lower-case string.
The lower-casing is important on Windows as there the file names are case insensitive
while the strings in perl are case sensitive. If this script needs to run on Linux/Unix this whole question about
case would need further discussion.

The last step in preparing the existing list of files for further inspection is creating a hash called `%file`
in which the keys are the names of the files and all the values are just the number `1`.
This hash will help us easily check if a file was found in the directory structure.

We go over the entries in the input file, `chomp` off the newline, and then check if the lower-case version
of the file is in the `%file` hash. If it is in the hash, we know it was in the directory structure.
If it was not in the hash we add it to the report file.


