---
title: "Adding the To: field to the MongoDB database"
timestamp: 2015-06-03T01:00:01
tags:
  - Email::Address
  - MongoDB
published: true
books:
  - mongodb
  - mbox
author: szabgab
---


The next step in [indexing the mailbox](/indexing-emails-in-an-mbox)
will be to include the `To:` field.


## Adding the To field

In the while-loop of the `process()</hl function add a call to `add_to(\%doc, $msg);`
immediately after the `add_from` call:

```perl
    add_from(\%doc, $msg) or next;
    add_to(\%doc, $msg);
```

Implement the `add_to` function:

```perl
sub add_to {
    my ($doc, $msg) = @_;

    my $log = Log::Log4perl->get_logger('add_to');
    my $to_string = $msg->header('To');
    if (not defined $to_string) {
        $log->warn("There is no To field in this message");
        return;
    }
    my @to = Email::Address->parse($to_string);
    #$log->info($to_string);

    $doc->{To} = [ map { {
        name    => $_->name,
        address => $_->address,
    } } @to ];

    return;
}
```

It does check the number of addresses, instead there is a `map`
expression that creates simple hashes from the Email::Address objects returned by the
`parse` method. The new hashes are collected into an anonymous array, and a reference
to that array is assigned to the `To` field of the `$doc` reference to hash.

If we now connect to the database using the command line client we can see how this structure is
entered:

```
$ mongo
> use mboxer
switched to db mboxer

> db.messages.find().limit(1)
{
  "_id": ObjectId("5308aa0797e32fcb59000015"),
  "To": [
    {
      "address": "foo@bar.com",
      "name": "Foo Bar"
    },
    {
      "addess": "foobar@qux.com",
      "name": "foobar"
    }
  ],
  "From": {
    "address": "mongo@exmaple.co",
    "name": "Mongo User"
  },
  "Subject": "Learning to use MongoDB?"
}
Fetched 1 record(s) in 4ms
```

We can see how the "From" field is a hash, while the "To" field is an array of hashes.

We can now play with the command line shell of mongodb and fetch some other messages. For example:
`db.messages.find( {'From.address': 'foobar@qux.com'} )` will return all the messages
where the address of the From-field matches that value.

Respectively `db.messages.find( {'To.address': 'foovar@qux.com'} )` will fetch
all the messages where **one of the addresses** of the To field match.

Before executing a find() in the shell we might want to execute a
`db.messages.find( {'To.address': 'foovar@qux.com'} ).count()` that will return the number
of instances.

A couple of thins I noticed now.

* Some of the e-mail addresses were in mixed case. e.g FooBar@qux.com
* In cases where the "To" field was only an e-mail without a name, Email::Address helpfully provided the part before the `@` as the name.
      That's probably not what I want in this case. I'd rather have the field left empty.
* There were cases where the name method returned the full e-mail address. Apparently there are emails that are addressed `To: "foobar@qux.com" &lt;foobar@qux.com>`.
      We should recognize those too and exclude the name part.

Actually, in order to see these issues I added a couple of logging calls like this one:
`$log->info('name: ' . $to[0]->name);`

We'll try to fix these issues now.

## Lower case addresses

This part is easy. We just add a call to `lc` in front of the `$_->address` expression in the add_to function,
and in front of the `$from[0]->address` expression in the add_from function.

## Replace name by phrase

After looking at the documentation of [Email::Address](https://metacpan.org/pod/Email::Address) I saw that the `name` method
is working harder than I wanted. I should use the `phrase` method. (And then there is also a comment section I have not deal with yet.)

If I replace the calls to `name` by calls to `phrase`, including in the code that prints the log:
`$log->info('phrase: ' . $to[0]->phrase);`, and run the script, soon I'll get an exception:

`Use of uninitialized value in concatenation (.) or string at bin/mbox-indexer.pl line 80, <GEN0> line 99.`

Wait, we know [that](/use-of-uninitialized-value). That should not be an exception! What's going on here?
Have we turned the `warnings` into FATAL errors by issuing `use warning FATAL => 'all';`?

Well, not us, but Moo did. When we write `use Moo;` it turns on `use strict;` and `use warnings FATAL => 'all';`
There was even an emotional [discussion](http://blogs.perl.org/users/peter_rabbitson/2014/01/fatal-warnings-are-a-ticking-time-bomb-via-chromatic.html)
about the subject that I don't really agree with. Anyway, I could see it live now. This means the logging line needs to change to this code:
`$log->info('phrase: ' . ($to[0]->phrase // ''));`

Running this did not throw any exception, but when I looked at the results in the database, I noticed that
many entries had a `null` in the name.

```
  "To": [
    {
      "address": "foobar@qux.com",
      "name": null
    }
```

Of course, that's because in the `map` call we created the name field even when the value was undefined.

In order to this to work I had to change the whole section where we created the little hashes from
the Email::Address object:


in the add_from function:

```perl
    $doc->{From} = {
        address => lc $from[0]->address,
    };

    if (defined $from[0]->phrase) {
        $doc->{From}{name} = $from[0]->phrase;
    }
```

in the add_to function:

```perl
    foreach my $t (@to) {
        my %h = (address => lc $t->address);
        if (defined $t->phrase) {
            $h{name} = $t->phrase;
        }
        push @{ $doc->{To} }, \%h;
    }
```

I am not very happy with this code, but I did not have better idea how to write this.


## Remove e-mail as name

The third issue I encountered was when the To field looked like this:
`To: "foobar@qux.com" &lt;foobar@qux.com>`.

That is when the "phrase" and the "address" are the same.

Let's eliminate that case:

Now actually the previous code change came handy.
I just had to extend the conditions.


In the add_from function:

```perl
    if (defined $from[0]->phrase and $from[0]->phrase ne $from[0]->address) {
        $doc->{From}{name} = $from[0]->phrase;
    }
```

In the add_to function:

```perl
    if (defined $t->phrase and $t->phrase ne $t->address) {
        $h{name} = $t->phrase;
    }
```

## The full code

The current version of the code:

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
            #say $msg->header;
            # Use of uninitialized value $field in lc at .../5.18.1/Email/Simple/Header.pm line 123, <GEN0> line 14.
            #say $msg->header('From');
            my %doc;

            add_from(\%doc, $msg) or next;
            add_to(\%doc, $msg);

            #file => $file,
            $doc{Subject} = $msg->header('Subject'),
            $collection->insert(\%doc);
            exit if defined $self->limit and $count > $self->limit;
        }
        #last;
        #exit;
    }
    $log->info("Count: $count");
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
        $log->warn("Very strange. No email recognized in the To field! " . $msg->header('To'));
        return;
    }

    $log->info('name: ' . $to[0]->name);
    $log->info('phrase: ' . ($to[0]->phrase // ''));
    $log->info('address: ' . $to[0]->address);

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
    #say Dumper \@from;
    #say $from[0]->address;
    #say $from[0]->name;
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
