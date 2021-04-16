use strict;
use warnings;
use 5.010;
use Dotenv;
use DigitalOcean;
use Data::Dumper qw(Dumper);

Dotenv->load;
my $do = DigitalOcean->new(oauth_token => $ENV{token}, wait_on_actions => 1);

my $regions_collection = $do->regions;
while (my $obj = $regions_collection->next) {
    say $obj;
    #say Dumper $obj;
    printf "%s  %s\n", $obj->slug, $obj->name;
}
