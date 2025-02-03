---
title: "Adding Date, Size, CC, and Message-ID"
timestamp: 2015-06-07T09:30:01
tags:
  - Email::Simple
published: true
books:
  - mongodb
  - mbox
author: szabgab
---


The next step is processing the Date field, the CC field, the Message-ID, and the size of the message.


We call the `add_date()` function in the inner while-loop of the `process()` function:

```perl
    add_from(\%doc, $msg) or next;
    add_to(\%doc, $msg);
    add_date(\%doc, $msg);
```

The fist version of the `add_date` function looks like this:

```perl
sub add_date {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_date');
    my $date_string = $msg->header('Date');
    if (not defined $date_string) {
        $log->warn("There is no Date field in this message");
        return;
    }
    $log->info("Date: $date_string");
    $doc->{Date} = $date_string;

    return;
}
```

If we check in the database, we'll see that the `Date` field was correctly added, but it was added as a string and not
as a Date object. Unlike plain JSON, the data format of MongoDB called BSON supports Date objects as well.
The Perl driver expects a [DateTime](https://metacpan.org/pod/DateTime) object that it will translate
to the Date object of BSON.

We get a date string in some standard format. Frankly I don't want to delve into the depth of RFCs,
but luckily there is a module called [DateTime::Format::Mail](https://metacpan.org/pod/DateTime::Format::Mail)
written by the late Iain Truskett more than 10 years ago(!), that can parse such strings and return DateTime objects.

The first attempt looked like this:

```perl
    my $dt = DateTime::Format::Mail->parse_datetime($date_string);
    if (not $dt) {
        $log->warn("Date field could not be parsed '$date_string'");
    }
    $doc->{Date} = $dt;
```

Soon I found out that this module will throw an exception if it cannot parse the
string so I changed the code:

```perl
    eval {
        my $dt = DateTime::Format::Mail->parse_datetime($date_string);
        $doc->{Date} = $dt;
    };
    if ($@) {
        chomp(my $err = $@);
        $log->warn("Date field could not be parsed ($err) '$date_string'");
    }
```

That revealed the date string that caused the exception was this:
`Fri, 30 Nov 2007 02:50:57 -0500 (EST)`
I don't know it the time-zone in the parentheses should be accepted or if it is really
invalid there, but for now I decided to disregard it. So I added the following substitution
before the eval-block:

```perl
    $date_string =~ s/\s*\([A-Z]+\)\s*$//; # TODO process time-zones as well!
```

with that comment.

Running the script now, we get nice ISODates in the command-line shell of the database:

```
"Date": ISODate("2009-09-27T10:37:53Z")
```


## Add size

The [Email::Simple](https://metacpan.org/pod/Email::Simple) does not have a
method to get the size of a message, but it can return the full message including headers
and body as a string using the `as_string` method. We can take the `length()`
of that string.

```perl
$doc{size} = length $msg->as_string;
```

## Include the body of the message

There is also a method called `body` that returns just the body part without the header.

```perl
$doc{body} = $msg->body;
```

After including this I ran the script. It worked, but when I looked at the actual
data in the database, I noticed some of the text is unreadable.

Of course.  Some of the e-mails are in plain text, but others have attachments.
There is no point in including a binary attachment. I have not seen an obvious and
easy way to take a message apart, so for now I am going to comment out this line.

We'll have to find a way to fetch just the text-part of a multi-part message and include that.

## Add CC

There were two fields that seem to be the same. It is sometimes called `CC`, and sometimes called `Cc`.

```perl
sub add_cc {
    my ($doc, $msg) = @_;

    my %seen;
    my $log = Log::Log4perl->get_logger('add_cc');
    foreach my $field ('CC', 'Cc') {
        my $cc_string = $msg->header($field);
        next if not defined $cc_string;
        $log->info("$field: $cc_string");
        my @cc = Email::Address->parse($cc_string);
        if (not @cc) {
            $log->warn("Email no recognized in the $field field! '$cc_string'");
            return;
        }

        foreach my $t (@cc) {
            next if $seen{lc $t->address}++;
            my %h = (address => lc $t->address);
            if (defined $t->phrase and $t->phrase ne $t->address) {
                $h{name} = $t->phrase;
            }
            push @{ $doc->{CC} }, \%h;
        }
    }

    return;
}
```

The code is quite similar to that of the `add_to` function, but this one has an internal loop to go over
all the potential names of the field (in this case 'CC' or 'Cc').
As this is not a required field, there is no warning if it is missing. There is still a warning if the field exists,
but we could not parse it.

Because I saw some duplicate entries, (one message had both CC an Cc), I also added an internal hash called `%seen`
that is used to ensure uniqueness of the e-mail addresses in the CC field.

## Locating the actual message - path and Mesage-ID

Even if we had the whole e-mail in the MongoDB database (which we don't), we would still want to be able to
locate the file where each specific e-mail is found. If for nothing else, because we might want to delete it.

So it would be nice to know which file the message came from and what is the message-id of each message.

## Adding the filename

This is quite easy as we have the filename in the `$file` variable in the internal while-loop,
so we only need to add: `$doc{file} = $file;`.


## Adding the Message-ID

As we saw in the [first article](/indexing-emails-in-an-mbox) there are cases where instead of
`Message-ID`, a message will have `Message-Id` or `Message-id`. I have not checked
if they are replacements or are just duplicates, but in the code extracting this header, I'll look
at all 3 potential fields:

```perl
sub add_message_id {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_message_id');
    my $id = $msg->header('Message-ID');
    if (not $id) {
        $id = $msg->header('Message-Id');
        if ($id) {
            $log->info("Message-Id found");
        }
    }
    if (not $id) {
        $id = $msg->header('Message-id');
        if ($id) {
            $log->info("Message-id found");
        }
    }

    if (not $id) {
        $log->warn("There is no Message id in this message");
        return;
    }
    $log->info("Message-ID: $id");

    return;
}
```

As I can see Message IDs look like this: `<37653D.2012401@foobar.com>`


## Full versions

The current version of the script look like this:

```perl
use strict;
use warnings;
use 5.010;

use Moo;
use MooX::Options;

use Path::Iterator::Rule;
use Email::Folder;
use Email::Address;
use MongoDB;
use Data::Dumper qw(Dumper);
use DateTime::Format::Mail;
use Log::Log4perl;

option path    => (is => 'ro', required => 1, format => 's',
    doc => 'path/to/mail');

option limit   => (is => 'ro', required => 0, format => 'i',
    doc => 'limit number of messages to be processed');

Log::Log4perl->init("log.conf");

main->new_with_options->process();
exit;

sub process {
    my ($self) = @_;

    my $dir = $self->path;

    my $log = Log::Log4perl->get_logger('process');
    $log->info("Starting to process in '$dir'");

    my $client     = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    my $database   = $client->get_database( 'mboxer' );
    $database->drop;
    my $collection = $database->get_collection( 'messages' );

    my $count = 0;

    my $rule = Path::Iterator::Rule->new;
    my $it = $rule->iter( $dir );
    while ( my $file = $it->() ) {
        next if not -f $file;
        $log->info("Processing $file");
        my $folder = Email::Folder->new($file);
        while (my $msg = $folder->next_message) {  # Email::Simple objects
            $count++;
            my %doc;

            add_from(\%doc, $msg) or next;
            add_to(\%doc, $msg);
            add_cc(\%doc, $msg);
            add_date(\%doc, $msg);
            add_message_id(\%doc, $msg);

            $doc{size} = length $msg->as_string;
            #$doc{body} = $msg->body; # we should fetch the text part of it.

            #'Delivery-date' is like Date, but it is not a required field, so no need to warn about it if it is missing
            $doc{file} = $file;
            $doc{Subject} = $msg->header('Subject'),
            $collection->insert(\%doc);
            exit if defined $self->limit and $count > $self->limit;
        }
        #last;
        #exit;
    }
    $log->info("Count: $count");
}

sub add_message_id {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_message_id');
    my $id = $msg->header('Message-ID');
    if (not $id) {
        $id = $msg->header('Message-Id');
        if ($id) {
            $log->info("Message-Id found");
        }
    }
    if (not $id) {
        $id = $msg->header('Message-id');
        if ($id) {
            $log->info("Message-id found");
        }
    }

    if (not $id) {
        $log->warn("There is no Message id in this message");
        return;
    }
    $log->info("Message-ID: $id");

    return;
}


sub add_date {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_date');
    my $date_string = $msg->header('Date');
    if (not defined $date_string) {
        $log->warn("There is no Date field in this message");
        return;
    }
    $log->info("Date: $date_string");
    $doc->{Date} = $date_string;

    $date_string =~ s/\s*\([A-Z]+\)\s*$//; # TODO process time-zones as well!

    eval {
        my $dt = DateTime::Format::Mail->parse_datetime($date_string);
        $doc->{Date} = $dt;
    };
    if ($@) {
        chomp(my $err = $@);
        $log->warn("Date field could not be parsed ($err) '$date_string'");
    }

    return;
}

sub add_cc {
    my ($doc, $msg) = @_;

    my %seen;
    my $log = Log::Log4perl->get_logger('add_cc');
    foreach my $field ('CC', 'Cc') {
        my $cc_string = $msg->header($field);
        next if not defined $cc_string;
        $log->info("$field: $cc_string");
        my @cc = Email::Address->parse($cc_string);
        if (not @cc) {
            $log->warn("Email no recognized in the $field field! '$cc_string'");
            return;
        }

        foreach my $t (@cc) {
            next if $seen{lc $t->address}++;
            my %h = (address => lc $t->address);
            if (defined $t->phrase and $t->phrase ne $t->address) {
                $h{name} = $t->phrase;
            }
            push @{ $doc->{CC} }, \%h;
        }
    }

    return;
}

sub add_to {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_to');
    my $to_string = $msg->header('To');
    if (not defined $to_string) {
        $log->warn("There is no To field in this message");
        return;
    }
    $log->info("To: $to_string");

    my @to = Email::Address->parse($to_string);
    if (not @to) {
        $log->warn("Very strange. No email recognized in the To field! $to_string");
        return;
    }

    foreach my $t (@to) {
        my %h = (address => lc $t->address);
        if (defined $t->phrase and $t->phrase ne $t->address) {
            $h{name} = $t->phrase;
        }
        push @{ $doc->{To} }, \%h;
    }

    return;
}

sub add_from {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_from');

    my $from_string = $msg->header('From');
    #$log->info("From: $from_string");
    if (not defined $from_string) {
        $log->warn("There is no From field in this message");
        return 1;
    }
    my @from = Email::Address->parse($from_string);
    #$log->info(Dumper \@from);
    if (@from > 1) {
        $log->warn("Strange, there were more than one emails recognized in the From field: " . $msg->header('From'));
    }
    if (not @from) {
        $log->warn("Very strange. No email in the From field! " . $msg->header('From'));
        return 1;
    }

    if ($from[0]->name eq 'Mail System Internal Data') {
        return;
    }

    $doc->{From} = {
        address => lc $from[0]->address,
    };

    if (defined $from[0]->phrase and $from[0]->phrase ne $from[0]->address) {
        $doc->{From}{name} = $from[0]->phrase;
    }

    return 1;
}
```

