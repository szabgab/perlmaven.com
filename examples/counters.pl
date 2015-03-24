use strict;
use warnings;

my $file = 'counters.txt';

my ($name) = @ARGV;
die "Usage: $0 NAME\n" if not $name;

my %counter;

if (-e $file) {
    open my $fh, '<', $file or die "Could not open '$file' for reading. $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($str, $count) = split /\t/, $line;
        $counter{$str} = $count;
    }
    close $fh;
}

$counter{$name}++;
print "$counter{$name}\n";

open my $fh, '>', $file or die "Could not open '$file' for writing. $!";
foreach my $str (keys %counter) {
    print $fh "$str\t$counter{$str}\n";
}
close $fh;

