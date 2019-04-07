#!/usr/bin/perl
use strict;
use warnings;

my $name = 'Foo';
my $send = 1;

if ($send) {
    (my $message = qq{
        Dear $name,

        this is a message I plan to send to you.

        regards
          the Perl Maven
        }) =~ s/^ {8}//mg;
    print $message;
}

