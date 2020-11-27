use strict;
use warnings;
use 5.010;

use Perl::Tidy;
use Path::Tiny qw(path);

my $filename = 'code.pl';
my $code = path($filename)->slurp_utf8;

my %config = (
    '--indent-columns' => 4,
    '--maximum-line-length' => 80,
    '--variable-maximum-line-length' => undef,
    '--whitespace-cycle' => 0,
);

my $clean;
my $stderr;

my $rc = '';
for my $field (sort keys %config) {
    if (defined $config{$field}) {
        $rc .= "$field=$config{$field}\n";
    } else {
        $rc .= "$field\n";
    }
}
say $rc;


my $error = Perl::Tidy::perltidy(
    source      => \$code,
    destination => \$clean,
    stderr      => \$stderr,
    perltidyrc  => \$rc,
);

say $code;
say '--------';
if ($error) {
    say 'ERROR';
    say $stderr;
} else {
    say $clean;
}
