use strict;
use warnings;
use 5.010;


my $name = "Perl";

my $text = "The name of this programming language is \"$name\".";
say $text;


my $better = qq{The name of this programming language is "$name".};
say $better;

my $other = qq!The name of this programming language is "$name".!;
say $other;

say qq(The name of this programming language is "$name".);
say qq[The name of this programming language is "$name".];

say qq?The name of this programming language is "$name".?;
say qq#The name of this programming language is "$name".#;
