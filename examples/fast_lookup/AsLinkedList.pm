package AsLinkedList;
use strict;
use warnings;

use Time::HiRes qw(time);
use List::Util qw(reduce);

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;
    $self->{data} = {};
    $self->{_first} = undef;
    $self->{_last} = undef;

    return $self;
}

sub add {
    my ($self, $name, $payload) = @_;

    $self->{data}{$name} = {
       name    => $name,
       payload => $payload,
       date    => time,
       _next   => undef,
       _prev   => $self->{_last},
    };
    my $last  = $self->{_last};
    if ($last) {
        $self->{data}{$last}{_next} = $name;
    }
    if (not $self->{_first}) {
        $self->{_first} = $name;
    }

    $self->{_last} = $name;

    return;
}

sub remove_oldest {
    my ($self) = @_;

    my $first = $self->{_first};
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

    if ($self->{_first} eq $name) {
        $self->{_first} = $next;
    }
    if ($self->{_last} eq $name) {
        $self->{_last} = $prev;
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


