package AsLinkedList;
use strict;
use warnings;

use Time::HiRes qw(time);
use List::Util qw(reduce);

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;
    $self->{data} = {};
    $self->{first} = undef;
    $self->{last} = undef;

    return $self;
}

sub add {
    my ($self, $name, $payload) = @_;

    $self->{data}{$name} = {
       name    => $name,
       payload => $payload,
       date    => time,
       _next   => undef,
       _prev   => $self->{last},
    };
    my $last  = $self->{last};
    if ($last) {
        $self->{data}{$last}{_next} = $name;
    }
    if (not $self->{first}) {
        $self->{first} = $name;
    }

    $self->{last} = $name;

    return;
}

sub remove_oldest {
    my ($self) = @_;

    my $first = $self->{first};
    return if not $first;

    return $self->remove_by_name($first);
}

sub remove_by_name {
    my ($self, $name) = @_;

    my $element = delete $self->{data}{$name};
    my $next = $element->{_next};
    my $prev = $element->{_prev};
    $self->{data}{$next}{_prev} = $prev if $next;
    $self->{data}{$prev}{_next} = $next if $prev;

    if ($self->{first} eq $name) {
        $self->{first} = $next;
    }
    if ($self->{last} eq $name) {
        $self->{last} = $prev;
    }

    delete $element->{_next};
    delete $element->{_prev};
    return $element;
}

sub count {
    my ($self) = @_;
    return scalar keys %{ $self->{data} };
}


1;


