package MyModulino;
use 5.010;
use strict;
use warnings;

hi() if not caller();
 
sub hi {
    say "Hello from main() of modulino.pl";
}

1;


