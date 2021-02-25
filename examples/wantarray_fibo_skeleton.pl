use strict;
use warnings;
use 5.010;

sub fibo {
   if (wantarray) {
       say 'LIST';
   } elsif (defined wantarray) {
       say  'SCALAR';
   } else {
       say  'VOID';
   }
}

my @numbers = fibo();  # LIST
my $value   = fibo();  # SCALAR
fibo();                # VOID

