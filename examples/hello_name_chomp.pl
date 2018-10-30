use 5.010;
use strict;
use warnings;

say "What is your name? ";
my $name = <STDIN>;
chomp $name;
say "Hello $name, how are you?";
