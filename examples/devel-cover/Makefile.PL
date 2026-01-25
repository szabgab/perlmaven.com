use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Example',
    VERSION_FROM  => 'lib/Example.pm',
    #    PREREQ_PM     => {},
    #    BUILD_REQUIRES   => {},
    #    CONFIGURE_REQUIRES => {},
    #    MIN_PERL_VERSION => 5.006,
    #    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
