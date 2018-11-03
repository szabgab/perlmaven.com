use strict;
use warnings;
use MCE;
use Data::Dumper qw(Dumper);

my $forks = shift or die "Usage: $0 N\n";

my @numbers = map { $_ * 2000000 } reverse 1 .. 10;
my %results;

print "Forking up to $forks at a time\n";
my $mce = MCE->new(
   user_tasks => [{
      max_workers => $forks,
      #chunk_size  => 1,
      #sequence    => { begin => 11, end => 19, step => 1 },
      user_func   => \&calc
   }]);

    my $res = calc($q);
    $pm->finish(0, { result => $res, input => $q });
}
$pm->wait_all_children;

print Dumper \%results;

sub calc {
    my ($n) = @_;
    my $sum = 0;
    for (1 .. $n) {
        $sum += 1 + rand()/100;
    }
    return $sum;
}
