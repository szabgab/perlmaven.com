use strict;
use warnings;
use Net::Dogstatsd;

#prints warning to STDERR if no StatsD server running on the local machine

my $n = 10;

for (1 .. $n) {
    sleep rand(2);
    my $elapsed_time = rand;
    
    my $dogstatsd = Net::Dogstatsd->new();
    my $socket    = $dogstatsd->get_socket();
    $dogstatsd->increment( name => 'demo.page_views', );
    $dogstatsd->gauge(
        name  => 'demo.elapsed_time',
        value => $elapsed_time,
    );
    $dogstatsd->histogram(
        name  => 'demo.elapsed_time_histogram',
        value => $elapsed_time,
    );
}
