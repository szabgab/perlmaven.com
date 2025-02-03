---
title: "use Path::Tiny instead of home-made ReadFile and WriteFile"
timestamp: 2016-02-12T06:30:01
tags:
  - Path::Tiny
  - slurp
  - spew
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


Now that we have made the [Perl code look nice](/run-perl-tidy-to-beautify-the-code),
we can start cleaning up the constructs in the code and convert them to beetter expressions based
in the current <b>best practices</b>. For this we are going to use [Perl::Critic](https://metacpan.org/pod/Perl::Critic).


## Running perlcritic on the tests

I ran `perlcritic t/*.t` which gave me a full page of output. The beginning looked like this:

```
t/cut.t: Bareword file handle opened at line 67, column 2.  See pages 202,204 of PBP.  (Severity: 5)
t/cut.t: Two-argument "open" used at line 67, column 2.  See page 207 of PBP.  (Severity: 5)
t/cut.t: Bareword file handle opened at line 77, column 2.  See pages 202,204 of PBP.  (Severity: 5)
t/cut.t: Two-argument "open" used at line 77, column 2.  See page 207 of PBP.  (Severity: 5)
...
```


When looking at line 67 and line 77 of the `t/cut.t` file I saw the following:

```perl
sub ReadFile {
       my $file = shift;
       open( FILE, $file ) or return '';
       local $/;
       undef $/;
       my $contents = <FILE>;
       close FILE;
       $contents;
}

sub WriteFile {
       my ( $file, $contents ) = @_;
       open( FILE, ">$file" ) or die "Can't open $file: $!\n";
       print FILE $contents;
       close FILE;
}
```

and around the file I saw rows like these:

```perl
my $content = ReadFile("filename");

...

WriteFile("filename", "content");
```

The `ReadFile` function is an implementation of the  [slurp-mode](/slurp). It could be fixed, or
it could be replaced by either [File::Slurp](https://metacpan.org/pod/File::Slurp), or by the `slurp`
method of [Path::Tiny](https://metacpan.org/pod/Path::Tiny).

Because Path::Tiny seems to be the most modern implementation I've replace the above code with the following:

```perl
use Path::Tiny qw(path);
```

```perl
my $content = path("filename")->slurp;

...

path( "filename" )->spew( "content" );
```

I made similar changes to a number of other test-files.

I also had to add Path::Tiny to Makefile.PL as a prerequisite.

[commit](https://github.com/szabgab/Pod-Tree/commit/6e207f45030609bbb2ac34ab6fe95d333ccc0c7c)

