use 5.010;
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my ($name, $file) = @ARGV;
die "Usage: $0 NAME FILE\n" if not $file;

open my $fh, '<', $file or die;
my @words = <$fh>;
chomp @words;

#print Dumper \@words;

my $res = binary_search($name, \@words);
if (not defined $res) {
    say "$name not found";
} else {
    say "$name found at $res";
}

sub binary_search {
    my ($str, $list) = @_;

    my $min = 0;
    my $max = @$list - 1;
    
    while ($min <= $max) {
        my $middle = int(($max+$min) / 2);
        # say "$min - $max ($middle)";
        if ($name lt $list->[$middle]) {
            $max = $middle-1;
            next;
        }
        if ($name gt $list->[$middle]) {
            $min = $middle+1;
            next;
        }
        return $middle;
    }

    return;
}
