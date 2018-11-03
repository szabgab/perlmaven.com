use 5.010;

use strict;

use warnings;

use Cpanel::JSON::XS qw(decode_json encode_json);

use LWP::Simple qw(get);

use Time::HiRes qw(usleep);



my $sec = 1_000_000;

my $parallel = 7;

my $serial   = 7;



for (1 .. $parallel) {
    my $pid = fork;
    if (not $pid) {
        for (1 .. $serial) {
            my $out = get "http://127.0.0.1:8080/ [127.0.0.1:8080]";
            print $out;
            usleep 500_000;
        }
        exit;
    }
}

for (1 .. $parallel) {
    wait();
}

