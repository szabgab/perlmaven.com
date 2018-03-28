use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Markua::Parser',
    AUTHOR        => q{Gabor Szabo <szabgab@cpan.org>},
    VERSION_FROM  => 'lib/Markua/Parser.pm',
    ABSTRACT_FROM => 'lib/Markua/Parser.pm',
    LICENSE       => 'perl',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Path::Tiny'      => 0.072,
        'JSON::MaybeXS'   => 1,
    },
    TEST_REQUIRES => {
          'Test::More'    => 1.001014,
    },
    META_MERGE    => {
        'meta-spec' => { version => 2 },
         resources => {
             repository => {
                 type => 'git',
                 url  => 'https://github.com/szabgab/perl5-markua-parser.git',
                 web  => 'https://github.com/szabgab/perl5-markua-parser',
             },
             bugtracker => {web => 'https://github.com/szabgab/perl5-markua-parser/issues'},
             homepage   => 'https://github.com/szabgab/perl5-markua-parser',
         },
    },
);
