use 5.010;
use strict;
use warnings;
use Fcntl qw(SEEK_SET SEEK_CUR SEEK_END);

my ($name, $file) = @ARGV;
die "Usage: $0 NAME FILE\n" if not $file;

my $location = binary_search_in_file($name, $file);
if (defined $location) {
    say "$name found at byte $location";
} else {
    say "$name not found";
}

sub binary_search_in_file {
    my ($name, $file) = @_;

    open my $fh, '<', $file or die;
    my $min = 0;
    my $max = -s $file;

    while ($min < $max) {
        my $middle = int(($max+$min) / 2);
        seek $fh, $middle, SEEK_SET;
        <$fh>; # read to the end of line and throw this away

        # make sure we don't try to read from the $max
        my $start = tell($fh);
        if ($max <= $start) {
            $start = $min;
            seek $fh, $start, SEEK_SET;
        }

        my $line = <$fh>;
        chomp $line;

        if ($name lt $line) {
            $max = $start;
            next;
        }
        if ($name gt $line) {
            $min = tell($fh);
            next;
        }

        return $start;
    }

    #while (my $line = <$fh>) {
    #    $count++;
    #    chomp $line;
    #    if ($line eq $name) {
    #        return $count;
    #    }
    #}
    return;
}

