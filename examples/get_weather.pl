use 5.010;
use strict;
use warnings;

use LWP::Simple qw(get);
use Config::Tiny;
use Cpanel::JSON::XS qw(decode_json);
use Data::Dumper qw(Dumper);

sub get_api_key {
    my $config = Config::Tiny->read('config.ini');
    return $config->{openweathermap}{api};
}

sub get_weather {
    my ($api_key, $location) = @_;

    my $url = "https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$api_key";
    my $json_str = get $url;
    return decode_json $json_str;
}

sub main {
    my $location = shift @ARGV or die "Usage: $0 LOCATION\n";
    my $api_key = get_api_key();
    my $weather = get_weather($api_key, $location);

    say $weather->{main}{temp};
    print Dumper $weather;
}

main();


