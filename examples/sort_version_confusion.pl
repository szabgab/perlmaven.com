use strict;
use warnings;
use 5.010;

use Perl::Version;
use version;
say "Perl::Version: $Perl::Version::VERSION";
say "version:       $version::VERSION";

my @versions = ( '5.11', 'v5.11', '5.011', '5.11');

say '----';

my @sorted = sort { Perl::Version->new( $a ) <=> Perl::Version->new( $b ) } @versions;
for my $s (@sorted) {
    say $s;
}

say '----';

my @other = sort { version->parse( $a ) <=> version->parse( $b ) } @versions;
for my $s (@other) {
    say $s;
}


