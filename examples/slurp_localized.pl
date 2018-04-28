use strict;
use warnings;
use 5.010;

my $file = 'data.txt';
my $data;
{
    open my $fh, '<', $file or die;
    local $/ = undef;
    $data = <$fh>;
    close $fh;
}
print $data;

$data =~ s/Java\s+is\s+Hot/Jabba The Hutt/g;
say '-' x 30;

print $data;

