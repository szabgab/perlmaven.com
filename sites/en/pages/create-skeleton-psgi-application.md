---
title: "Create skeleton PSGI application for the SCO project"
timestamp: 2015-04-17T11:30:01
tags:
  - PSGI
  - Plack::Request
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


I know it was short, but at this point I had enough from the testing. I like testing, but having lots of test withouth the real application (even if we are talking about a clone)
looks pointless. Besides, I had doubts about the reusability of [those tests](/add-some-acceptance-tests), so instead of writing more tests,
I switched gears, and started to write the web application.

I was wondering a bit which framework should I use for the project. The MetaCPAN Web is written using [Catalyst](/catalyst).
I know [Dancer](/dancer) quite well. I have some experience with [Mojolicious](/mojolicious), but in the end I thought:
Let's not use any of these. Let's start by implementing everything in plain [PSGI](/psgi). It is both a learning
experience and at least at this point, the project does not need fancy things the frameworks might provide.


{% youtube id="tqzdNkX8GDo" file="create-skeleton-psgi-application" %}

The first thing I wanted to create is a skeleton for the PSGI-based web application.
Something simple like when we once [started with PSGI](/getting-started-with-psgi), but with more robust layout.

So I created the [>app.psgi](https://github.com/szabgab/MetaCPAN-SCO/blob/94db29297470e00357f347bcd0deb54717393454/app.psgi) file in the root
of the project with the following content:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib';
use MetaCPAN::SCO;

my $app = MetaCPAN::SCO->run;
```

Instead of implementing the application in the app.psgi file, I am going to implement it in the MetaCPAN::SCO module and call its `run` method.

The interesting part of the code is in the [lib/MetaCPAN/SCO.pm](https://github.com/szabgab/MetaCPAN-SCO/blob/94db29297470e00357f347bcd0deb54717393454/lib/MetaCPAN/SCO.pm) file.

The run method creates, and implicitly returns a reference to a subroutine.
(Assigning the anonymous subroution to the `$app` variable is not required here, but it will be useful later on.)

Inside the anonymous subroutine we create a [Plack::Request](https://metacpan.org/pod/Plack::Request) object. Then using the
`path_info` method we can retreive part of the requested URL that does not contain the name of the machine. Just the path from `/`.
We can use this later to identify the various requests. (These are usually called "routes").

According to the [specs of PSGI](http://plackperl.org/), this anonymous subroution needs to return an array
reference with 3 values. The first one is the [HTTP status code](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes). 200 means success, 404 means "Not Found".
The 2nd element is the header. In our case we return only the Content-type. When the `path_info` equals to '/' we return `text/plain` which means our response
will be interpreted as plain text. In all other cases we return 404 - Not Found and the Content-Type is `text/html`. There is no particular reason for the differences.
At this point the content (which is the string in the 3rd element of the array is plain text. So either Content-Type will work.

Later, when both will return HTML, we'll have to make sure that the Content-Type is `text/html` in both cases.

```perl
package MetaCPAN::SCO;
use strict;
use warnings;

use Plack::Request;

our $VERSION = '0.01';

=head1 NAME

SCO - search.cpan.org clone

=cut

sub run {
    my $app = sub {
        my $env = shift;

        my $request = Plack::Request->new($env);
        if ($request->path_info eq '/') {
            return [ '200', [ 'Content-Type' => 'text/plain' ], ['Hello'], ];
        }

        return [ '404', [ 'Content-Type' => 'text/html' ], ['404 Not Found'], ];
    };
}


1;
```

Once we have this, we can launch the web-application by running `plackup` in the root directory of the project.
It will tell us we can browse to [http://localhost:5000/](http://localhost:5000/). Try that, and try adding something
to the end of the request to see the 404 error message.


To finish this change, we also need to add [Plack::Request](https://metacpan.org/pod/Plack::Request) to the list of prerequisites.
This is the change we make in the Makefile.PL:

```perl
    PREREQ_PM    => {
       'Plack::Request'   => '0',
    },
```

```
$ git add .
$ git commit -m "add app.psgi and some basic code to show a main page and to give 404 otherwise"
```

[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/94db29297470e00357f347bcd0deb54717393454)

