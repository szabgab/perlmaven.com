use strict;
use warnings;
use 5.010;

my $path = shift || '.';

traverse($path);

sub traverse {
    my ($thing) = @_;

    say $thing;
    return if not -d $thing;
    opendir my $dh, $thing or die;
    while (my $sub = readdir $dh) {
        next if $sub eq '.' or $sub eq '..';

        traverse("$thing/$sub");
    }
    close $dh;
    return;
}

