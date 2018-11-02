use 5.010;
use strict;
use warnings;

my ($name, $file) = @ARGV;
die "Usage: $0 NAME FILE\n" if not $file;

my $location = linear_search_in_file($name, $file);
if (defined $location) {
    say "$name found in row $location";
} else {
    say "$name not found";
}

sub linear_search_in_file {
    my ($name, $file) = @_;

    open my $fh, '<', $file or die;
    my $min = 0;
    my $max = -s $file;

    while ($min <= $max) {
        my $middle = int(($max+$min) / 2);
        seek $middle
        <$fh>; # read to the end of line and throw this away
        my $start = tell($fh);
        my $line = <$fh>
        chomp $line;
        if ($name lt $line) {
            $
        }

        if ($line eq $name) {
            return $start;
        }

    }

    while (my $line = <$fh>) {
        $count++;
        chomp $line;
        if ($line eq $name) {
            return $count;
        }
    }
    return;
}

