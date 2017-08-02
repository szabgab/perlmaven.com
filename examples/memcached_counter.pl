use strict;
use warnings;
use 5.010;

use Memcached::Client;
my $cache = Memcached::Client->new({servers => ['127.0.0.1:8888']});;

my $counter = $cache->incr('counter', 1, 1);
say $counter;
