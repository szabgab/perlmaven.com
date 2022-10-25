use strict;
use warnings;
use Net::Statsd::Client;

# no warning even if no StatsD server running on the local machine

my $stats = Net::Statsd::Client->new(prefix => "demo.");

my $n = 10;

for (1 .. $n) {
    sleep rand(2);
    my $elapsed_time = rand;
    
    $stats->increment('page_views');
    $stats->gauge('elapsed_time' => $elapsed_time);
}

