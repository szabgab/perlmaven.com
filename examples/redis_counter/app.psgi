use strict;
use warnings;
use Dancer2;
use Redis;

my $redis = Redis->new(server => 'myredis:6379');

get '/' => sub {
    my $counter = $redis->get('counter');
    $counter++;
    $redis->set('counter' => $counter);
    return $counter;
};

dance;
