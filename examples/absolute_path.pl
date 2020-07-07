use strict;
use warnings;
use 5.010;

use Cwd qw(abs_path);
use File::Spec;

my @cases = ("..", "../Perl-Maven", "../perlmaven.com");
for my $path (@cases) {
    say $path;
    say File::Spec->canonpath( $path );
    say abs_path($path);
    say '';
}
