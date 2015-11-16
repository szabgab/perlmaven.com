use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @numbers = map { $_ * 2000000 } reverse 1 .. 10;
my %results;

foreach my $q (@numbers) {
    $results{$q} = calc($q);
}

print Dumper \%results;

sub calc {
    my ($n) = @_;
    my $sum = 0;
    for (1 .. $n) {
        $sum += 1 + rand()/100;
    }
    return $sum;
}
