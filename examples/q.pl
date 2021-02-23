use strict;
use warnings;
use 5.010;


my $name = 'Perl';

my $text = 'We have a variable name called \'$name\'.';
say $text;

my $better = q{We have a variable name called '$name'.};
say $better;

my $other = q!We have a variable name called '$name'.!;
say $other;

say q(We have a variable name called '$name'.);
say q[We have a variable name called '$name'.];
say q?We have a variable name called '$name'.?;
say q#We have a variable name called '$name'.#;
