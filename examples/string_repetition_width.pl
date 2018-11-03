use strict;
use warnings;
use 5.010;


print "Please type in the title: ";
my $title = <STDIN>;
chomp $title;

say $title;
say '-' x length $title;
