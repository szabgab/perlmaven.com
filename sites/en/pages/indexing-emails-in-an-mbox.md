---
title: "Indexing e-mails in an mbox"
timestamp: 2015-05-15T07:30:01
tags:
  - Path::Iterator::Rule
  - Email::Folder
books:
  - mbox
published: true
author: szabgab
---


After reading and answering e-mails I usually store them in a
hierarchy of mbox-es. Unfortunately finding something there is quite difficult.
I have tons of messages and sometimes I file messages under the sender, sometimes under the topic,
and I am sure there are also cases, probably lots of them, when I make a mistake and file a messaging in the wrong
mbox.

So I decided I'll write a small application to index all the e-mails, put the data in a Mongo database and write
a client to search among the messages. Let's start by processing the mailboxes.


There are probably other distribution on CPAN that can handle this job, but I found [Email::Folder](https://metacpan.org/pod/Email::Folder),
currently maintained by RJBS. Let's give it a try.

## Traversing the directory tree

Even before I do that I need a way to go over all the files. For  this
I used [Path::Iterator::Rule](https://metacpan.org/pod/Path::Iterator::Rule) that I have already [used](/finding-files-in-a-directory-using-perl).

{% include file="examples/traversing_directory_tree.pl" %}

I run this using `time` so I can see how long it takes:

```
$ time perl bin/mboxer.pl /home/gabor/mail/
real  0m0.119s
user  0m0.065s
sys   0m0.032s
```

I did not have to wait for that.

## Going over the messages

The next step is to load each file using [Email::Folder](https://metacpan.org/pod/Email::Folder).
Before I go into really processing the data, let's see how long does this take.

Inside the `while` I added the following code: to open the email-folder
and just go through all the messages:

```perl
    my $folder = Email::Folder->new($file);
    while (my $msg = $folder->next_message) {  # Email::Simple objects
    }
```

{% include file="examples/traversing_messages.pl" %}

I ran this again with `time` and it took almost 2 minutes. I even added a counter to see how many messages I have.
There are 119,026 messages in my folders. Clearly I can't just write a script to search things in these folders.
I'll need to index them and then search on those indexes.

```
$ time bin/mboxer.pl /home/gabor/mail/

119026

real  1m45.088s
user  1m11.283s
sys   0m1.501s
```

## Processing the headers

In most cases I'd like to search based on some of the header fields - not so much on the content of the mail.
Well, OK, I guess searching on the body will be very important, but that's a lot of data. Let's try to do something
with the header. But what headers are there? Surely there is a header called `From`. Let's see how can I fetch that?

I added the following line to the internal `while-loop`:

```perl
say $msg->header('From');
```

Running this would take another 2 minutes and after a few tens of addresses I am sure the same format would be repeated.
So I add a counter that after 20 entries will call exit.

```perl
say $msg->header('From');
exit if $main::cnt++ > 20;
```

I know I could have used the `$counter` I added to the code previously, but when I ran this experiment first
I did not have that counter yet. Besides, I find this counter a neat trick.

Instead of declaring a lexical variable I access a package variable in the `main` namespace.
`use strict` disregards such variable when accessed with a fully qualified package name.

(If you recall the error you would get if you wanted to use a variable without declaring it with `my`
say [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name).
With `$main::cnt` we provided that explicit package name.)

In addition `use warnings` does not complain when we call `++` on a variable that was `undef`.
So this code can be used with additional ceremony.

The results had 3 different types of address:

```
Foo Bar <foo@bar.com>
"Foo Bar" <Foo@Bar.com>
=?ISO-8859-1?Q?Foo_B=F6r?= <foo@bar.com>
```

I'll have to unify them before inserting into the database.

## What headers are there?

Another thing that I wanted to know is what kind of header are there?  
The [Email::Simple](https://metacpan.org/pod/Email::Simple) object we got back from
[Email::Folder](https://metacpan.org/pod/Email::Folder) has a `headers` method that will
return the list of header names. Such as `From`.

I replaced the `say $msg->header('From');` line with a loop to go over the header names
and print them:

```perl
    foreach my $h ($msg->headers) {
        say $h;
    }
```

Of course I got the same headers a lot of times, so I decided I'll collect the headers
in a hash, and at the same time I'll also count how many times each header appears.

```perl
        foreach my $h ($msg->headers) {
            $main::count{$h}++;
        }
```

At the end I put:

```perl
foreach my $k (sort keys %main::count) {
    say "$k  $main::count{$k}";
}
```


and after the internal `while` loop I added a call to `last`. That way
the process will stop just after the first file.

Even with that I got a **lot** of headers. Some of them only differ in case:

```
Accept-Language  11
Authentication-Results  74
CC  3
Cc  3
Content-Class  1
Content-Disposition  6
Content-Language  20
Content-Transfer-Encoding  34
Content-Type  101
Content-class  1
Content-type  1
DKIM-Signature  5
Date  103
Delivered-To  102
Delivery-date  7
Disposition-Notification-To  3
DomainKey-Signature  3
Envelope-to  7
From  103
Importance  9
In-Reply-To  38
MIME-Version  95
MIME-version  1
Message-ID  96
Message-Id  6
Message-id  1
Mime-Version  6
Organization  10
Priority  1
Received  102
Received-SPF  74
References  37
Reply-To  3
Reply-to  1
Return-Path  95
Return-path  7
Sender  9
Status  103
Subject  103
Thread-Index  26
Thread-Topic  13
To  102
User-Agent  17
X-AnalysisOut  1
X-AntiAbuse  4
X-Authenticated-Sender  2
X-Canit-Stats-ID  1
X-Gm-Message-State  6
X-Google-DKIM-Signature  6
X-Google-Sender-Auth  9
X-HDC-Scanned  2
X-IMAP  1
X-IronPort-AV  1
X-Keywords  102
X-MAIL-FROM  1
X-MIMEOLE  1
X-MS-Has-Attach  13
X-MS-TNEF-Correlator  13
X-MSMail-Priority  1
X-MSMail-priority  1
X-MXL-Hash  1
X-Mailer  24
X-MimeOLE  9
X-Original-To  95
X-OriginalArrivalTime  6
X-Originating-IP  13
X-Priority  6
X-Provags-ID  5
X-Received  4
X-SOURCE-IP  1
X-Scanned-By  1
X-Source  4
X-Source-Args  4
X-Source-Dir  4
X-Spam  1
X-Spam-CTCH-RefID  2
X-Spam-Checker-Version  1
X-Spam-Level  1
X-Spam-Report  2
X-Spam-Score  3
X-Spam-Status  1
X-Stationery  1
X-Status  102
X-UID  102
X-Virus-Scanned  7
acceptlanguage  7
thread-index  3
x-cr-hashedpuzzle  3
x-cr-puzzleid  3
x-mimeole  1
x-originating-ip  2
x-tm-as-product-ver  2
x-tm-as-result  2
x-tm-as-user-approved-sender  2
x-tm-as-user-blocked-sender  2
```

I think that's enough for the first step. I'll probably have to pick some of the most important header
fields and start with those.

Probably: From, To, Date, CC (and Cc), Subject.

## The whole series

1. [Indexing e-mails in an mbox](/indexing-emails-in-an-mbox) (this article)
1. [Putting the email in MongoDB - part 1](/putting-emails-into-mongodb)
1. [Refactoring the script and add logging](/some-refactoring-and-add-logging-to-mail-boxer)
1. [Switching to Moo - adding command line parameters](/switching-to-moo-adding-command-line-parameters)
1. [Adding the To: field to the MongoDB database](/adding-the-to-field-to-the-mongodb-database)
1. [Adding Date, Size, CC, and Message-ID](/adding-date-size-cc-and-message-id)

