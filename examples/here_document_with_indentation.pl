#!/usr/bin/perl
use strict;
use warnings;

my $name = 'Foo';
my $send = 1;

if ($send) {
    my $message = <<"END_MESSAGE";
        Dear $name,

        this is a message I plan to send to you.

        regards
          the Perl Maven
END_MESSAGE
    print $message;
}

