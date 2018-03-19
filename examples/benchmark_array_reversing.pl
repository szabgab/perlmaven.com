use strict;
use warnings;
use 5.010;

my ($length, $size, $count) = @ARGV;
die "USAGE: $0 LENGTH SIZE COUNT\n" if not $count; 

#my @words = qw(Foo Bar Moo);
my @words;
my $str =  'c' x $length;
for my $i (1 .. $size) {
    push @words, "$str$i";
}


sub use_reverse {
    for my $item (reverse @words) {
        my $x = $item;
        #say $item
    }
}

sub implement_reverse {
    my $i = @words - 1;
    while ($i >= 0) {
        my $x = $words[$i];
        #say $words[$i];
        $i--;
    }
}

#use_reverse();
#implement_reverse();


use Benchmark qw(:all) ;
timethese($count, {
    'reverse' => \&use_reverse,
    'my_loop' => \&implement_reverse,
});
