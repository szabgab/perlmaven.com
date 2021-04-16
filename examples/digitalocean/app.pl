use strict;
use warnings;
use DigitalOcean;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);

# Visit https://cloud.digitalocean.com/account/api/tokens to Generate a new Token

main();

sub main {
    eval {
        require Dotenv;
        Dotenv->load;
    };

    my $token = $ENV{DIGITAL_OCEAN_TOKEN};
    my $list;
    my $dump;
    GetOptions(
        'token=s' => \$token,
        'list=s'  => \$list,
        'dump'    => \$dump,
    ) or usage();

    usage("We need a token") if not $token;

    my $do = DigitalOcean->new(oauth_token => $token, wait_on_actions => 1);
    if ($list) {
        if ($list eq 'sizes') {
            my $sizes_collection = $do->sizes;
            # TODO could we easily sort them by name or by size or by price?
            while (my $obj = $sizes_collection->next) {
                if ($dump) {
                    print Dumper $obj;
                    exit;
                }
                print $obj->slug, "\n"; # no name method here
            }
        } elsif ($list eq 'images') {
            my $images_collection = $do->images;
            while (my $obj = $images_collection->next) {
                if ($dump) {
                    print Dumper $obj;
                    exit;
                }
                printf "%s  %s\n", $obj->slug, $obj->name;
            }
        } elsif ($list eq 'regions') {
            my $regions_collection = $do->regions;
            while (my $obj = $regions_collection->next) {
                if ($dump) {
                    print Dumper $obj;
                    exit;
                }
                printf "%s  %s\n", $obj->slug, $obj->name;
            }
        } else {
            usage("Incorrect --list value '$list'");
        }
    }
    if (0) {
        # Will print "going to wait" then "waiting" several times then "comlete"
        #my $size_id = 's-1vcpu-1gb';
        #my $image_id = 'ubuntu-20-04-x64'; # 72067660   20.04 (LTS) x64';
        #my $region_id = 'nyc1';
        #
        #my $droplet = $do->create_droplet(
        #    name => 'demo',
        #    size => $size_id,
        #    image => $image_id,
        #    region => $region_id,
        #    wait_on_event => 1,
        #);
        #print Dumper $droplet;
    }
}

sub usage {
    my ($msg) = @_;
    print "$msg\n\n" if $msg;
    print qq{
Usage: $0
         --token TOKEN
         --list [sizes|images|regions]
         --dump         Dump the first listed structure and exit

You can supply the token either on the command line or as an environment variable DIGITAL_OCEAN_TOKEN
or by saving it in the .env file as
DIGITAL_OCEAN_TOKEN = <TOKEN>
In this case you also need to install the Dotenv module from CPAN.
};
    exit 1;
}

