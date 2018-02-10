package AsHash;
use strict;
use warnings;

use Time::HiRes qw(time);
use List::Util qw(reduce);

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;
    $self->{data} = {};

    return $self;
}

sub add {
    my ($self, $name, $payload) = @_;

    $self->{data}{$name} = {
       name    => $name,
       payload => $payload,
       date    => time,
    };
    return;
}

sub remove_oldest {
    my ($self) = @_;

    my $min = reduce { $a->{date} < $b->{date} ? $a : $b } values %{ $self->{data} };
    return $self->remove_by_name($min->{name});
}

sub remove_by_name {
    my ($self, $name) = @_;

    return delete $self->{data}{$name};
}

sub count {
    my ($self) = @_;
    return scalar keys %{ $self->{data} };
}

1;

