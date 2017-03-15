use strict;
use warnings;
use 5.010;

use Tie::IxHash;
my %people;
my $t = tie %people, 'Tie::IxHash';

%people = (first => 1, second => 2, third => 3);
$people{fourth} = 4;
$people{another} = 5;

for my $k (keys %people) {
    say $k;
}

$t->SortByKey;
print "\n";
for my $k (keys %people) {
    say $k;
}


$t->Reorder(  sort { length $a <=> length $b } $t->Keys );
print "\n";
for my $k (keys %people) {
    say $k;
}

