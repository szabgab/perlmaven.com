---
title: "Refactoring the script and add logging"
timestamp: 2015-05-30T12:01:01
tags:
  - Log::Log4perl
published: true
books:
  - mongodb
  - mbox
author: szabgab
---


[So far](/indexing-emails-in-an-mbox) we have not run the indexer on all the mailboxes,
but before we do that I'd like to make some more improvements to the script.

First of all, in the [latest version](/putting-emails-into-mongodb) we skipped messages that did not have
a From field, or that we could not recognize a From field.
I think it would be better to include them too. In order to do this we need to slightly reorganize the code.


We'll create and empty hash to represent the document at the beginning of the loop `my %doc;`, and we will add
data to it after validation.

Probably the cleanest way is to move all the code checking and adding the From field to a subroutine. Also pass the
reference to the `%doc` hash we need to fill. We have a slight problem though.
It turns out the `add_from` subroutine itself can have 3 outcomes.

1. We found the From field and want to store it.
1. We did not find the From field.
1. We found a From field and we'd like to skip this message.

Luckily for our purposes, in both the first and the second case we would like to continue
processing this message, and will want to skip to the next message only in the 3rd case.

So the `add_form` will return true in every case we would like to continue processing
the message and false in case we would like to abort processing the current message.

Then in the main loop we can write `add_from(\%doc, $msg) or next;`.

```perl
    while (my $msg = $folder->next_message) {  # Email::Simple objects
        $count++;
        my %doc;

        add_from(\%doc, $msg) or next;

        $doc{Subject} = $msg->header('Subject'),
     }
```


The extracted function is quite similar to the code we had in the loop, except that it has to
call `return` instead of `next`:

```perl
sub add_from {
    my ($doc, $msg) = @_;

    my $from_string = $msg->header('From');
    if (not defined $from_string) {
        warn "There is no From field in this message";
        return 1;
    }
    my @from = Email::Address->parse($from_string);
    if (@from > 1) {
        warn "Strange, there were more than one emails recognized in the From field: " . $msg->header('From');
    }
    if (not @from) {
        warn "Very strange. No email in the From field! " . $msg->header('From');
        return 1;
    }
    #say Dumper \@from;
    say $from[0]->address;
    say $from[0]->name;
    if ($from[0]->name eq 'Mail System Internal Data') {
        return;
    }
    $doc->{From} = {
        name => $from[0]->name,
        address => $from[0]->address,
    };
    return 1;
}
```

## The main function

The next step is something I probably should have done at the very beginning, is to wrap everything in a "main" function
to avoid any use of global variables.

This is how the beginning of the script look like after the change. The only variable in the main body of the code
is checking for the command line argument:

```perl
my $path_to_dir = shift or die "Usage: $0 path/to/mail\n";

process($path_to_dir);
exit;

sub process {
    my ($dir) = @_;
    ...
}
```


## Add logging

As a first version it was ok to call `say` to report what the code is doing and to call
`warn` to report about strange situations, but as the script grows, it is better to
switch to one of the logging modules from CPAN. I've used
[Log::Dispatch](https://metacpan.org/pod/Log::Dispatch) quite a lot,
but after watching a presentation of Tom Hukins
I decided to give [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) try.

After some reading I created a file called `log.conf` and put the following in it:

```
log4perl.rootLogger=DEBUG, LOGFILE

log4perl.appender.LOGFILE=Log::Log4perl::Appender::File
log4perl.appender.LOGFILE.filename=process.log
log4perl.appender.LOGFILE.mode=append

log4perl.appender.LOGFILE.layout=PatternLayout
log4perl.appender.LOGFILE.layout.ConversionPattern=[%r] %F %L %c - %m%n
```

Then in the script I added the following:

```perl
use Log::Log4perl;
Log::Log4perl->init("log.conf");
```

In each subroutine I added the following at the beginning

```perl
   my $log = Log::Log4perl->get_logger('process');
```

and replaced each call to `warn` by a call to `$log->warn()`
and each call to `say` by a call to `$log->info()`.


Then I only had to comment out the code that was limiting the process to 20 messages
and I could run the script. (This is starting to be disturbing, that I have to comment out a line
to run the script on all the messages.)

It took almost 4 minutes to run (though this time I am using an external disk connected via USB
so it is not really comparable to the previous measurements.)

In the log file I found several entries that indicated issues:

```
[32517] bin/mbox-indexer.pl 77 add_from - Very strange.
    No email in the From field! <Saved by Priority - Enterprise Management System>
[55818] bin/mbox-indexer.pl 73 add_from - Strange, there were more than one emails recognized
    in the From field: "" foobar@gmail.com " via RT" <other@example.com>
[73796] bin/mbox-indexer.pl 77 add_from - Very strange. No email in the From field! Gabor Szabo <sgabor>
[98695] bin/mbox-indexer.pl 69 add_from - There is no From field in this message
```

I'll certainly have to investigate these, but I also would like to make it easier to find these among
the regular log messages. So I'll have to either separate the warnings and errors in another log file
or I'll have to add the log-level (info, warn, etc) to the actual log string.

We'll do that next time.
For now, let me paste the current version of the script here:

```perl
use strict;
use warnings;
use 5.010;

use Path::Iterator::Rule;
use Email::Folder;
use Email::Address;
use MongoDB;
use Data::Dumper qw(Dumper);
use Log::Log4perl;

my $path_to_dir = shift or die "Usage: $0 path/to/mail\n";

Log::Log4perl->init("log.conf");

process($path_to_dir);
exit;

sub process {
    my ($dir) = @_;

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
    
            $doc{Subject} = $msg->header('Subject'),
            $collection->insert(\%doc);
            #exit if $count > 20;
        }
    }
    $log->info("Count: $count");
}


sub add_from {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_from');

    my $from_string = $msg->header('From');
    if (not defined $from_string) {
        $log->warn("There is no From field in this message");
        return 1;
    }
    my @from = Email::Address->parse($from_string);
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
        name => $from[0]->name,
        address => $from[0]->address,
    };
    return 1;
}
```

