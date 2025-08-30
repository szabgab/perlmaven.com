---
title: "disk usage: du in Perl - video"
timestamp: 2015-08-15T16:05:06
tags:
  - Filesys::DiskUsage
  - du
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


du using [Filesys::DiskUsage](https://metacpan.org/pod/Filesys::DiskUsage)


{% youtube id="uOch-LIPix4" file="beginner-perl/disk-usage-du" %}

{% include file="examples/du.pl" %}

## Comments

Very helpful and I love you did a VDO too! Smooth and elegant presentation.
I'm an APL-trained programmer always seeking brevity. My lines might be (untested!):

use feature "say";
use Filesys::DiskUsage qw/du/'

die "Usage: $0 DIRs\n" unless @ARGV;
my %sizes = du({'make-hash' => 1}, @ARGV);
say "$_ : $sizes{$_}" for sort { $sizes{$a} <=> $sizes{$b} } keys %sizes;

As an aside- seems difficult to install Filesys::DiskUsage . CPAN install fails.


