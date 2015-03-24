use strict;
use warnings;

use Cpanel::JSON::XS qw(encode_json decode_json);
use Path::Tiny qw(path);

my $file = 'counters.json';

my ($name) = @ARGV;
die "Usage: $0 NAME\n" if not $name;

my $counter;

if (-e $file) {
    $counter = decode_json path($file)->slurp;
}

if ($name eq '--list') {
    foreach my $key (sort keys $counter) {
        print "$key: $counter->{$key}\n";
    }
    exit;
}


$counter->{$name}++;
print "$name: $counter->{$name}\n";

path($file)->spew(encode_json $counter);

