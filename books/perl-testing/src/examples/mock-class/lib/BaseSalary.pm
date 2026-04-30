package BaseSalary;
use strict;
use warnings;
use feature 'say';

sub new {
    my ($class) = @_;
    say "new $class";
    my $self = bless {}, $class;

    return $self;
}

# plain getter/setter for name
sub name {
    my ($self, $value) = @_;
    if (@_ == 2) {
        say "set name to $value";
        $self->{name} = $value;
    }
    return $self->{name};
}

sub get_base_salary {
    my ($self) = @_;
    # say "get_base_salary";

    return 1370;
}

1;

