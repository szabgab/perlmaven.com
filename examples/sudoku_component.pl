use strict;
use warnings;
use 5.010;
use Games::Sudoku::Component;
 
my $sudoku = Games::Sudoku::Component->new(
    size => 9,
);

say $sudoku->as_string;
say "\n";

$sudoku->generate(
    blanks => 50,
);

say $sudoku->as_string;
say "\n";

$sudoku->solve;

say $sudoku->as_string;

