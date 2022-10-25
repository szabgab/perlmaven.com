use strict;
use warnings;
use Net::Statsd;

# no warning even if no StatsD server running on the local machine

# $Net::Statsd::HOST = 'localhost';    # Default
# $Net::Statsd::PORT = 8125;           # Default

my $n = 10;

for (1 .. $n) {
    sleep rand(2);
    my $elapsed_time = rand;
    
    Net::Statsd::increment('demo.page_views');
    Net::Statsd::gauge('demo.elapsed_time' => $elapsed_time);
#    Net::Statsd::histogram('demo.elapsed_time_histogram' => $elapsed_time);
}

