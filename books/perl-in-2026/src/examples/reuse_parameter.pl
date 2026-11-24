use v5.44;

sub greet($first_name, $surname, $nickname = $first_name) {
    say qq{Hello $first_name $surname is known as "$nickname"};
}

greet("Foo", "Bar");
greet("Gabor", "Szabo", "szabgab");

