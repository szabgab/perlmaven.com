use strict;
use warnings;

f();

sub f {
    g();
}

sub g {
    h();
}

sub h {
    for my $i (0..2) {
        my ($package, $filename, $line, $subroutine, $hasargs, $wantarray,
            $evaltext, $is_require, $hints, $bitmask, $hinthash) = caller($i);
        print "$i: $package  $filename  $line $subroutine\n";
    }
}
