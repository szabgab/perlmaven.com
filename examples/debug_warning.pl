use 5.010;
use strict;
use warnings;

my $x = 42;
my $y;

$SIG{__WARN__} = sub {
    my $warn = shift;
    my ($package, $filename, $line) = caller;
    if (open my $fh, '<', $filename) {
        my @lines = <$fh>;
        return if $lines[$line-1] =~ /debug\(/;
    }
    print $warn;
};

my $z = $x+$y;

debug("x=$x y=$y");

sub debug {
    say shift;
}

