use strict;
use warnings;
use 5.010;

use HTTP::Tiny;
use Data::Dumper qw(Dumper);

my $url = 'https://perlmaven.com/';

my $response = HTTP::Tiny->new->get($url);
if ($response->{success}) {
    while (my ($name, $v) = each %{$response->{headers}}) {
        for my $value (ref $v eq 'ARRAY' ? @$v : $v) {
            say "$name: $value";
        }
    }
    if (length $response->{content}) {
        say 'Length: ', length $response->{content};
        delete $response->{content};
    }
    print "\n";
    print Dumper $response;
} else {
    say "Failed: $response->{status} $response->{reasons}";
}

