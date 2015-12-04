use strict;
use warnings;
use 5.010;

use Perl::Version;
use version;

say Perl::Version->new('5.11') == Perl::Version->new('v5.11');   # 1
say version->parse('5.11') == version->parse('v5.11');           #
