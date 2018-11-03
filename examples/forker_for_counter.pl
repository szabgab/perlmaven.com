use 5.010;

use strict;

use warnings;

use Cpanel::JSON::XS qw(decode_json encode_json);

use LWP::Simple qw(get);
my $n = 10;

for (1 .. $n) {
    my $pid = fork;
    if (not $pid) {
        for (1 .. 10) {
            my $out = get "http://127.0.0.1:8080/";
            print $out;
        }
        exit;
    }
}

for (1 .. $n) {
    wait();
}
