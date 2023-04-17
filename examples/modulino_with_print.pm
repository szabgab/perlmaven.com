use strict;
use warnings;
use 5.010;

say "Hello from the body of modulino.pl";

main() if not caller();

sub main {
    say "Hello from main() of modulino.pl";
}

1;

