use strict;
use warnings;
use 5.010;
use Games::Sudoku::Component::Controller;

my $c = Games::Sudoku::Component::Controller->new(size => 9);

say $c->table->as_string;
say "\n";

$c->solve;
say $c->table->as_string;
say "\n";

$c->make_blank(50);
say $c->table->as_string;
say "\n";

say $c->table->cell(1, 2)->value;
say $c->table->cell(1, 3)->value;

$c->table->cell(1, 4)->value(9);
say $c->table->cell(1, 4)->value;
