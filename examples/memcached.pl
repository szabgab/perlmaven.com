use 5.010;
use strict;
use warnings;
use Cache::Memcached;

my $name = shift or die "Usage $0 NAME";

# using 1.28
# if we supply an incorrect port-number we don't get any error message
# 'servers' => ["127.0.0.1:11212" ],
my $memd = Cache::Memcached->new({
    #'servers' => [  "/var/sock/memcached", ],
    'servers' => ["127.0.0.1:11211"],
    'debug'   => 1,
});


my $value = $memd->get($name);
#say $value;
$value++;
say $value;
$memd->set($name, $value);

=pod 

Memorization using Memcache
https://github.com/tom-lpsd/p5-memoize-cached

session management for Dancer
https://github.com/sukria/Dancer-Session-Memcached

provide a way to fetch all the keys from memcached
https://github.com/gitpan/Cache-Memcached-Indexable

=cut

