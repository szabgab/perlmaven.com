use strict;
use warnings;
use 5.010;

use HTTP::Tiny;

my @urls = qw(
    https://perlmaven.com/
    https://cn.perlmaven.com/
    https://br.perlmaven.com/
);

my $ht = HTTP::Tiny->new;

foreach my $url (@urls) {
    say "Start $url";
    my $response = $ht->get($url);
    if ($response->{success}) {
        say 'Length: ', length $response->{content};
    } else {
        say "Failed: $response->{status} $response->{reasons}";
    }
}

