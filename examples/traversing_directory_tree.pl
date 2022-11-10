use strict;
use warnings;
use 5.010;

use Path::Iterator::Rule;

my $path_to_dir = shift or die "Usage: $0 path/to/mail\n";

my $rule = Path::Iterator::Rule->new;
my $it = $rule->iter( $path_to_dir );
while ( my $file = $it->() ) {
    next if not -f $file;
    say $file;
}

