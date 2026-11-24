use v5.44;

use Data::Dumper qw(Dumper);

sub add_header($thing, %header) {
    say $thing;
    say Dumper \%header;
}


add_header("Hello");
add_header("Key-value pairs", machine => "localhost", signature => "Foo Bar" );

add_header("Just values", "machine", "localhost", "signature", "Foo Bar" );

my %data = (
    machine => "localhost",
    signature => "Foo Bar",
);
add_header("Hash", %data);
