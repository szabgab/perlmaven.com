package MySalary;
use strict;
use warnings;

use BaseSalary;

sub new {
    my ($class, $name) = @_;
    my $self = bless {}, $class;

    $self->{base} = BaseSalary->new;
    $self->{base}->name($name);

    return $self;
}


sub get_name {
    my ($self) = @_;
    $self->{base}->name;
}


sub get_salary {
    my ($self) = @_;

    my $bonus = 100;

    my $base_salary = $self->{base}->get_base_salary();

    return $base_salary + $bonus;
}

1;


