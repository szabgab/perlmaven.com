#!/usr/bin/perl
use strict;
use warnings;

my @queue = accept_new_to_queue();
while (@queue) {
    my $next_item = shift @queue;
	handle_item($next_item);

	push @queue, accept_new_to_queue()
}

sub accept_new_to_queue {
    ...
}
sub handle_item {
    ...
}

