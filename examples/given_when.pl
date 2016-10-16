use strict;
use warnings;
use 5.010;
no warnings 'experimental';

my $num = rand();

given ($num) {
   when ($_ > 0.7) {
       say "$_ is larger than 0.7";
   }
   when ($_ > 0.4) {
       say "$_ is larger than 0.4";
   }
   default {
       say "$_ is something else";
   }
}

