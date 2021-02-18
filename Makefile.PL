use ExtUtils::MakeMaker;

my %opts = (
    'NAME'      => 'Perl::Maven',
    'NORECURS'  => 1,     # avoid trying to use examples/Makefile.PL
    'VERSION'   => '0.1',
    'PREREQ_PM' => {
        'Test::More'           => 1,
        'Path::Iterator::Rule' => 0,
        'YAML::XS'             => 0,
        'Encode'               => 2.62,
        'Encode::Guess'        => 2.06,
        'Path::Tiny'           => 0,

#        'HTML::Tidy'           => 0,
#        'Test::HTML::Tidy'     => 0,

    },
);
WriteMakefile( %opts );
