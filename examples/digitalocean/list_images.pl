use strict;
use warnings;
use 5.010;
use Dotenv;
use DigitalOcean;
use Data::Dumper qw(Dumper);

Dotenv->load;
my $token = $ENV{DIGITAL_OCEAN_TOKEN};
my $do = DigitalOcean->new(oauth_token => $token, wait_on_actions => 1);

my $collection = $do->images;
while (my $obj = $collection->next) {
    #say $obj;
    #say Dumper $obj;
    printf "%s  %s\n", $obj->slug, $obj->name;
}
