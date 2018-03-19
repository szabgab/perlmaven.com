use strict;
use warnings;
use 5.010;

my ($size, $count) = @ARGV;
die "USAGE: $0 SIZE COUNT\n" if not $count; 

#my @words = qw(Foo Bar Moo);
my @words;
for my $i (1 .. $size) {
    push @words, "abc " . $i;
}


sub use_reverse {
    for my $item (reverse @words) {
        #say $item
    }
}

sub implement_reverse {
    my $i = @words - 1;
    while ($i >= 0) {
        #say $words[$i];
        $i--;
    }
}

#use_reverse();
#implement_reverse();


use Benchmark qw(:all) ;
timethese(1000, {
    'reverse' => \&use_reverse,
    'my_loop' => \&implement_reverse,
});
