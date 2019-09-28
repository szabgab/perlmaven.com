use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);
use MetaCPAN::Client;

main();
exit();

sub main {
    my $mcpan  = MetaCPAN::Client->new();

    my ($count) = @ARGV;
    $count //= 10;
    my $recent = $mcpan->recent($count);      # https://metacpan.org/pod/MetaCPAN::Client::ResultSet

    #say $recent->total;
    while (my $this = $recent->next) {
        #say $this;      # https://metacpan.org/pod/MetaCPAN::Client::Release
        #say $this->name;
        #say $this->author;
        #say $this->date;
        #say $this->version;
        #say $this->version_numified;
        #say Dumper $this->license;
        #say Dumper $this->metadata;
        #say '---------------';

        my @issues;

        my $license = $this->license;
        if (not @$license) {
            push @issues, "Missing license in META files";
        }
        if (@$license == 1 and $license->[0] eq 'unknown') {
            push @issues, "License in META files is unknown";
        }
        push @issues, check_meta($this->metadata);

       if (@issues) {
            printf qq{<a href="%s">%s</a><br>\n}, $this->metacpan_url, $this->name;
            for my $issue (@issues) {
                say qq{$issue<br>\n};
            }
            say qq{<p>\n};
       }
    }
}

sub check_meta {
    my ($meta) = @_;

    return "Missing resources from META files" if not exists $meta->{resources};
    return "Missing repository from META files" if not exists $meta->{resources}{repository};
    #return "No repository type" if not exists $meta->{resources}{repository}{type};
    #return Dumper $meta->{resources}{repository};
    return
}

