use strict;
use warnings;
use 5.010;

use Email::Address;

my $line = 'foo@bar.com  Foo Bar <foobar@example.com>  Text bar@foo.com ' ;

my @addresses = Email::Address->parse($line); 
foreach my $addr (@addresses) {
    say $addr;
}
