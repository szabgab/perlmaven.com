use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);
use Net::Whois::Raw;
use Path::Tiny qw(path);

$Net::Whois::Raw::CHECK_FAIL = 1;
$Net::Whois::Raw::OMIT_MSG = 1;

my @domains = path($0)->parent->child('domains.txt')->lines( { chomp => 1 } );
if (@ARGV) {
    @domains = @ARGV;
}

foreach my $domain (@domains) {
    say $domain;
    my $data = whois($domain);
    my @ns = get_ns($data);
    check_ns($domain, @ns);

    if ($domain =~ /\.org$/) {
        say 'Waiting 16 seconds to avoid rate limit';
        sleep 16;
    }
}


sub get_ns {
    my ($data) = @_;

    my @ns = map { uc $_ } sort $data =~ /^Name Server:\s*(\S+)\s*$/mg;

    if (not @ns) {
        @ns = map { uc $_ } sort $data =~ /^nserver:\s*(\S+)\s*$/mg;
    }

    if (not @ns) {
        my @lines = split /\n/, $data;
        my $in_ns = 0;
        for my $line (@lines) {
            if ($line =~ /^\s*Domain servers in listed order:\s*$/) {
                $in_ns = 1;
                next;
            }
            if ($line =~ /^\s*$/) {
                $in_ns = 0;
            }
            if ($in_ns) {
                $line =~ s/^\s+|\s+$//g;
                push @ns, uc $line;
            }
        }
        @ns = sort @ns;
    }

    return @ns;
}

sub check_ns {
    my ($domain, @ns) = @_;

    if (@ns != 2 or $ns[0] ne 'NS.TRACERT.COM' or $ns[1] ne 'NS2.TRACERT.COM') {
        say "Error in $domain";
        say Dumper \@ns;
    }
}

