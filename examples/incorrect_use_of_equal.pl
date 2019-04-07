use strict;
use warnings;
use 5.010;

print "input: ";
my $name = <STDIN>;
chomp $name;

if ( $name == "" ) {   # wrong! you need to use eq instead of == here!
  say "TRUE";
} else {
  say "FALSE";
}

