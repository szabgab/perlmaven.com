use strict;
use warnings;
use Parallel::ForkManager;
use Data::Dumper qw(Dumper);


my $forks = shift;

my @numbers = map { $_ * 2000000 } reverse 1 .. 10;
my %results;

if ($forks) {
    print "Forking up to $forks at a time\n";
    my $pm = Parallel::ForkManager->new($forks);
    $pm->run_on_finish( sub {
        my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;
#die Dumper \@_;
        my $q = $data_structure_reference->{input};
        $results{$q} = $data_structure_reference->{result};
    });
 
    DATA_LOOP:
    foreach my $q (@numbers) {
        my $pid = $pm->start and next DATA_LOOP;
        my $res = calc($q);
        $pm->finish(0, { result => $res, input => $q });
    }
    $pm->wait_all_children;
} else {
    print "Non-forking\n";
    foreach my $q (@numbers) {
        $results{$q} = calc($q);
    }
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
