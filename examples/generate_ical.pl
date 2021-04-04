#!/usr/bin/perl

use strict;
use warnings;

use Data::ICal               ();
use Data::ICal::Entry::Event ();
use DateTime                 ();
use DateTime::Format::ICal   ();
use DateTime::Duration       ();

my $calendar = Data::ICal->new;

{
    my $begin = DateTime->new( year => 2021, month => 4, day => 5, hour => 15 );
    my $end   = DateTime->new( year => 2021, month => 4, day => 5, hour => 17 );
    my $event = Data::ICal::Entry::Event->new;
    $event->add_properties(
    	summary     => 'Short title of the event',
    	description => "A longer description that can also have ebedded newlines.\nThen it can continue on a second and\nthird line.",
    	dtstart     => DateTime::Format::ICal->format_datetime($begin),
    	location    => 'The local coffee shop',
    	dtend       => DateTime::Format::ICal->format_datetime($end),
    );
    $calendar->add_entry($event);
}

{
    my $begin = DateTime->new( year => 2021, month => 4, day => 6, hour => 6 );
    my $duration = DateTime::Duration->new(hours => 3, minutes => 15);
    my $event = Data::ICal::Entry::Event->new;
    $event->add_properties(
    	summary     => 'Another event',
    	description => "Description",
    	dtstart     => DateTime::Format::ICal->format_datetime($begin),
    	location    => 'https://zoom.us/',
        duration    => DateTime::Format::ICal->format_duration($duration),
    );
    $calendar->add_entry($event);
}


print $calendar->as_string;

