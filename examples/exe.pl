use strict;
use warnings;
use 5.010;

say "Please select:";
say "a) Hello";
say "b) World";
my $input1 = <STDIN>;
chomp $input1;

say "You selected: $input1\n";

say "Please select again:";
say "c) Hello World";
say "d) Goodbye";
my $input2 = <STDIN>;
chomp $input2;

say "Now you selected: $input2";

