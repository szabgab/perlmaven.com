use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Markua::Parser',
    AUTHOR       => q{Gabor Szabo <szabgab@cpan.org>},
    VERSION_FROM => 'lib/Markua/Parser.pm',
    ABSTRACT     => 'Parsing Markua documents and creating DOM',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    PREREQ_PM => {
        'Path::Tiny'      => 0.072,
        'JSON::MaybeXS'   => 1,
    },
    TEST_REQUIRES => {
          'Test::More'    => 1.001014,
    },
);
