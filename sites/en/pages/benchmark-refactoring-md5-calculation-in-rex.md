---
title: "Benchmark: Refactoring MD5 calculation in Rex"
timestamp: 2017-09-22T17:42:13
tags:
  - Benchmark
  - MD5
  - Rex
published: true
author: ferki
---


Regardless of your level of involvement with coding, sooner or later the time
comes when you have to choose between various implementations for a specific
task. Depending on the situation, there can be multitude of criteria to help
your decision, and performance is usually one of them.

Luckily, Perl 5 comes with a [Benchmark](https://metacpan.org/pod/Benchmark) module, that can help
you to quickly compare alternative solutions, and thus help you do a better
job.

In this article, I'll show you how this module helped us to improve the MD5
calculation logic of [Rex](https://www.rexify.org) while making
sure we are not slowing things down.


[As you might already know](/levels-of-security-using-rex),
Rex is a deployment and configuration management framework
written in Perl. Since those kind of tasks very often boil down to file
manipulation, the ability to identify content changes, or to identify
identical files, is essential part of the software. Currently Rex uses MD5
checksumming to do that, but the implementation is modular enough to switch
to other methods in the future.

The complexity comes from the fact that Rex has to calculate those checksums
on a wide variety of systems: different flavors of Linux and BSD systems,
Solaris, or Mac OS X as local or remote machines, or even locally on Windows.

## The problem

After some iterations, the [logic](https://github.com/RexOps/Rex/blob/03e969323c135b6bf7525a1adb83f522674e7756/lib/Rex/Commands/MD5.pm)
looked roughly like this:

* if it's a BSD or Mac OS X, use `/sbin/md5`
* if it's not, then try to use `md5sum`
* and if that fails, write a short perl script to a temporary location, and
execute it as a fallback

This looks good at first, but we bumped into some bugs, we could trace back
to MD5 calculation. The fallback method also could fail with files that are
bigger than the available memory in some cases, especially on binary files. On
top of that, writing the script to a file, executing it, then deleting it
sounded to be slow and unnecessarily complex. So I went on to find a platform
independent way to calculate MD5 checksums, but I also wanted to make sure I
don't end up with something slow.

Judging by its documentation, the [Digest::MD5](https://metacpan.org/pod/Digest::MD5) module seemed to
be up for the job, especially given it's part of Perl core distribution since
5.7.3. And this is the part where

## Benchmarking

came into picture. With the `cmpthese` function of Benchmark, it is
possible to compare performance of Perl code passed as strings or as
subroutine references.

There can be differences in the results depending on which style is used,
but I was interested in the relative performances of different calculation
methods, rather than their absolute performances. So as long as I was using the
same style, I was on the safe side of things.

I wanted to compare slightly different algorithms so, for the sake of
simplicity, I just created new subroutines for them within Rex::Commands::MD5,
and exported them.

I expected using the system's compiled `md5sum` (or `md5`)
binary would be the fastest, so I decided to test the original perl helper
script's speed, and created an `md5_current` sub for that:

```perl
sub md5_current {
  my ($file) = @_;

  my $script = q|
    use Digest::MD5;
    my $ctx = Digest::MD5->new;
    open my $fh, "<", $ARGV[0];
    binmode $fh;
    while(my $line = <$fh>) {
      $ctx->add($line);
    }
    print $ctx->hexdigest . "\n";
    |;

  my $rnd_file = get_tmp_file;

  my $fh = Rex::Interface::File->create;
  $fh->open( ">", $rnd_file );
  $fh->write($script);
  $fh->close;

  my $md5 = i_run "perl $rnd_file '$file'";
  Rex::Interface::Fs->create->unlink($rnd_file);
  return $md5;
}
```

First I was curious how that compares to executing the same perl code directly
as a one-liner instead via a script, so I added a variation of it as another
sub:

```perl
sub md5_current_no_script {
  my ($file) = @_;

  my $script =
    qq|perl -e 'use Digest::MD5; my \$ctx = Digest::MD5->new; open my \$fh, "<", \$ARGV[0]; binmode \$fh; while(my \$line = <\$fh>) { \$ctx->add(\$line); }; print \$ctx->hexdigest . "\n";' "$file"|;

  return i_run "$script";
}
```

At this point I could already compare them with the following little script:

```perl
use strict;
use warnings;
use 5.010;

use Benchmark qw(cmpthese);
use Rex::Commands::MD5;

my $small_file = '/etc/localtime';
my $large_file = '/tmp/1g';

say 'small files';

cmpthese(
  1000,
  {
    'current'           => qq(Rex::Commands::MD5::md5_current('$small_file')),
    'current no script' => qq(Rex::Commands::MD5::md5_current_no_script('$small_file')),
  }
);

say 'large files';
cmpthese(
  10,
  {
    'current'           => qq(Rex::Commands::MD5::md5_current('$large_file')),
    'current no script' => qq(Rex::Commands::MD5::md5_current_no_script('$large_file')),
  }
);
```

As you can see, we are using both a small and a large file for calculation.
The small file is 2335 bytes long, and I created the large (1GB) file with
the following command:

```bash
dd if=/dev/zero of=/tmp/1g bs=1M count=1024
```

The calculation is repeated 1000 times for the small file, and 10 times for
the large file (plainly because that already gives comparable results for
large files).

I added my new proposed implementation as `md5_new` to the list:

```perl
sub md5_new {
  my ($file) = @_;

  my $exec = Rex::Interface::Exec->create;

  my $command =
      'perl -MDigest::MD5 -e \'open my $fh, "<", "'
    . $file
    . '" or die "Cannot open '
    . $file
    . '"; binmode $fh; print Digest::MD5->new->addfile($fh)->hexdigest;\'';

  my $md5 = $exec->exec($command);
  chomp $md5;

  return $md5;
}
```

(Note: during my tests I noticed if I use `$fh->binmode` here instead of
`binmode $fh`, that results in a remarkable performance drop. I couldn't
reproduce it outside the scope of Rex, so looks like we just spotted some kind
of bug to be investigated separately. Anyhow, I also included an
`md5_new_binmode_method` variation for this case in the final version
of my benchmarks.)

Finally, for the sake of completeness, I created an `md5sum` variant
too, which plainly executes, well, `md5sum`:

```perl
my ($file) = @_;
my $exec = Rex::Interface::Exec->create;

return split( /\s/, $exec->exec("md5sum '$file'") );
```

Now, let's see how do they perform against each other!

```bash
$ perl benchmark_md5.pl 
small files
                     Rate new binmode method current current no script  new md5sum
new binmode method 86.1/s                 --    -37%              -41% -44%   -85%
current             137/s                59%      --               -6% -12%   -75%
current no script   145/s                69%      6%                --  -6%   -74%
new                 155/s                80%     13%                7%   --   -72%
md5sum              556/s               546%    307%              282% 258%     --
large files
                   s/iter current current no script new binmode method  new md5sum
current              3.27      --               -0%               -29% -30%   -39%
current no script    3.26      0%                --               -29% -30%   -39%
new binmode method   2.31     41%               41%                 --  -1%   -13%
new                  2.30     42%               42%                 1%   --   -13%
md5sum               2.01     63%               63%                15%  15%     --
```

The results are sorted by increasing performance. As expected, `md5sum`
comes out as fastest.

Also as expected with the variations of the current algorithm, it looks like
there is some penalty for writing the script to a file before executing it.
But it's actually not as big as I thought initially, and it seems to vanish
for larger files.

The newly proposed method proven itself faster than the current one, so we
could be confident about not introducing slowness. It also does the
calculation in a memory efficient way, able to handle files that cannot fit
into the memory (this can be tested by using a large enough file). Moreover,
it only uses a core module, which is a very important detail for Rex, as we
like to assume as little as possible about the remote systems.

(Note: it's interesting to see that calling `binmode` as a method of
the filehandle essentially halves the performance for some reason. This needs
further debugging, but it is a nice example of how benchmarking can help
uncovering otherwise hidden problems).

We found a better way to calculate MD5 checksums for our purposes, so I'd
like to finish up the whole story with some

## Finetuning

First of all, it turned out Windows systems need a slightly different quoting
style, so that has been added to the final version of the new implementation.

Later we also learned that some distributions (e.g. the ones in the Red Hat
family, like Fedora and CentOS), don't install all core modules by default,
and for them we need to add back the binary based method. Which is not a big
problem as we saw that can be faster if available, and still makes sense to
try it first.

## Try it out yourself

The benchmarking script and the modified `Rex::Command::MD5` module are
included in the examples directory for your convenience. If you would like to
give them a spin, you need the following steps:

1. Create a "large" testfile by running `dd if=/dev/zero of=/tmp/1g bs=1M count=1024` or similar
1. Install Rex with `cpanm Rex` or equivalent (for dependencies)
1. Run the benchmark with `perl benchmark_md5.pl`


## Related articles
* [Comparing the speed of JSON decoders](/comparing-the-speed-of-json-decoders)


## Source files

{% include file="examples/benchmark-refactoring-md5-calculation-in-rex/benchmark_md5.pl" %}

{% include file="examples/benchmark-refactoring-md5-calculation-in-rex/lib/Rex/Commands/MD5.pm" %}

