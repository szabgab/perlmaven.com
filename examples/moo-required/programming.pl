use strict;
use warnings;
use 5.010;
 
use Person;
my $anonymous = Person->new;
say $anonymous->name;
say 'DONE';
