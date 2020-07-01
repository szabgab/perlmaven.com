use 5.030;

die "Usage: $0 FILENAME LIMIT" if @ARGV != 2;

my ($filename, $limit) = @ARGV;

open (my $fh, '<', $filename) or die;
while (my $line = <$fh>) {
    for (1..$limit) {
        print($line) if $line =~ /(.)y\1/;
    }
}

