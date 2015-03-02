package Person;
use Moo;

has name => (is => 'rw');
has age  => (
    is  => 'rw',
    isa => sub {
       die "'$_[0]' is not an integer!"
          if $_[0] !~ /^\d+$/;
    },
);

1;
