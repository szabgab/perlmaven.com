---
title: "POD - Plain Old Documentation - video"
timestamp: 2015-02-06T22:02:07
tags:
  - POD
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


POD is a simple markup language that allows us to embed documentation in any perl script of module
the same way as the people who write the documentation of Perl do. This will allow our users
to read the documentation the same way they are already used to read the documentation of perl
and of CPAN modules.


{% youtube id="1LDHUTf-LHo" file="beginner-perl/pod" %}

Also read the [article about POD](/pod-plain-old-documentation-of-perl) and
another article on
[core Perl documentation and CPAN module documentation](/core-perl-documentation-cpan-module-documentation).

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Hello, there is no more code here\n";

=head1 Explaining how PODs work

Documentation starts any time there is a  =tag
at the beginning of a line (tag can be any word)
and ends where there is a =cut at the beginning
of a line.

Around the =tags you have to add empty rows.

A few example tags:

 Main heading           =head1

 Subtitle               =head2

 Start of indentation   =over 4

 element                =item *

 end of indentation     =back

Documentation of PODs can be found in B<perldoc perlpod>

See a few examples:

=head1 Main heading

text after main heading

=head2 Less important title

more text

 some text shown verbatim
 more verbatim text typed in indented to the right

=over 4

=item *

Issue

=item *

Other issue

=back

documentation ends here

=cut

print "Just documentation\n";
```

