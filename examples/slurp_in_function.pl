use strict;
use warnings;
use 5.010;

my $file = 'data.txt';
my $data = slurp($file);

print $data;

$data =~ s/Java\s+is\s+Hot/Jabba The Hutt/g;
say '-' x 30;

print $data;

sub slurp {
    my $file = shift;
    open my $fh, '<', $file or die;
    local $/ = undef;
    my $cont = <$fh>;
    close $fh;
    return $cont;
}

