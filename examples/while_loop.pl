use strict;
use warnings;
use 5.010;

my $counter = 10;

while ($counter > 0) {
  say $counter;
  $counter -= 2;
}
say 'done';

