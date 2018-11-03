use 5.010;
use strict;
use warnings;
use Cpanel::JSON::XS qw(decode_json encode_json);

my $n = 10;
# {"errors":["API rate limit exceeded for organization"]}
#
for (1 .. $n) {
    my $pid = fork;
    my $errors = 0;
    if (not $pid) {
        for (1 .. 5) {
            my $out = qx{curl -L -H 'X-Cisco-Meraki-API-Key: ca862ac2a58d9c1d824feb4329d45' https://dashboard.meraki.com/api/v0/organizations/2556/admins 2>/dev/null};
            #my $out = qx{curl  -L -H 'X-Cisco-Meraki-API-Key: ca862ac2a58d9c1d824feb4329d45' https://dashboard.meraki.com/api/v0/devices/QQFD-5K2P-7SKQ/clients?timespan=84000 2>/dev/null};
            #say $out;
            my $res = decode_json $out;
            if (ref $res and ref $res eq 'HASH' and $res->{errors}) {
                $errors++;
            }
        }
        say $errors;
        exit;
    }
}

for (1 .. $n) {
    wait();
}
