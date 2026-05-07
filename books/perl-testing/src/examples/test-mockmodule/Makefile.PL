use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'MyGreeting',
    VERSION_FROM => 'lib/MyGreeting.pm',
    LICENSE      => 'perl',
    TEST_REQUIRES => {
        'Test::More'       => '0',
        'Test::MockModule' => '0',
    },
);
