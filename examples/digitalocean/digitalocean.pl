use strict;
use warnings;
use DigitalOcean;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);

main();
exit();

sub main {
    eval {
        require Dotenv;
        Dotenv->load;
    };

    my $token = $ENV{DIGITAL_OCEAN_TOKEN};
    my $list;
    my $dump;
    my $create;
    my $droplet;
    GetOptions(
        'token=s' => \$token,
        'list=s'  => \$list,
        'dump'    => \$dump,

        'droplet=s' => \$droplet,

        'create'  => \$create,
    ) or usage();

    usage("We need a token") if not $token;

    my $do = DigitalOcean->new(oauth_token => $token, wait_on_actions => 1);
    if ($list) {
        if ($list eq 'sizes') {
            # TODO could we easily sort them by name or by size or by price?
            list($do->sizes, $dump, ['slug']); # no name method here
        } elsif ($list eq 'images') {
            list($do->images, $dump, ['slug', 'name']);
        } elsif ($list eq 'regions') {
            list($do->regions, $dump, ['slug', 'name']);
        } elsif ($list eq 'ssh') {
            list($do->ssh_keys, $dump, ['name', 'id']);
        } elsif ($list eq 'droplets') {
            list($do->droplets, $dump, ['name', 'id']);
        } else {
            usage("Incorrect --list value '$list'");
        }
    } elsif ($droplet) {
        my $droplet_obj = $do->droplet($droplet);
        print $droplet_obj->name, "\n";
        print $droplet_obj->created_at, "\n";
        #print Dumper $droplet_obj->DigitalOcean;
        #print Dumper $droplet_obj;
        for my $network (@{ $droplet_obj->networks->v4 }) {
            print $network->type, "\n";
            print $network->ip_address, "\n";
        }
    } elsif ($create) {
        my $size_id = 's-1vcpu-1gb';
        my $image_id = 'ubuntu-20-04-x64'; # 72067660   20.04 (LTS) x64';
        my $region_id = 'nyc1';
        my $ssh_id = '24064194';

        # This Will print "going to wait" then "waiting" several times then "comlete"
        # TODO how to stop it?
        # TODO how to get the IP address and the ssh signature of the server?
        # TODO set ssh
        my $response = $do->create_droplet(
            name => 'demo',
            size => $size_id,
            image => $image_id,
            region => $region_id,
            ssh_keys => [$ssh_id],
            backups => 0,
            ipv6 => 0,
            private_networking => 0,
            wait_on_event => 1,
        );
        print Dumper $response;
    }
}

sub list {
    my ($collection, $dump, $fields) = @_;

    while (my $obj = $collection->next) {
        if ($dump) {
            print Dumper $obj;
            exit;
        }
        my $str = '';
        for my $field (@$fields) {
            $str .= $obj->$field . '   ';
        }
        print "$str\n";
    }
}

sub usage {
    my ($msg) = @_;
    print "$msg\n\n" if $msg;
    print qq{
Usage: $0
        --token TOKEN
        --list [sizes|images|regions|ssh|droplets]
        --dump         Dump the first listed structure and exit

        --droplet ID     (returned by --list droplets)
        --create      Create a droplet with fixed definitions

You can supply the token either on the command line or as an environment variable DIGITAL_OCEAN_TOKEN
or by saving it in the .env file as
DIGITAL_OCEAN_TOKEN = <TOKEN>
In this case you also need to install the Dotenv module from CPAN.
};
    exit 1;
}

