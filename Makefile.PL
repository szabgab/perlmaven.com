use ExtUtils::MakeMaker;

my %opts = (
	'NAME'      => 'Perl::Maven',
	'VERSION'   => '0.1',
	'PREREQ_PM' => {
		'Test::More' => 0.47,
		'YAML'       => 0,
	},
);
WriteMakefile( %opts );
