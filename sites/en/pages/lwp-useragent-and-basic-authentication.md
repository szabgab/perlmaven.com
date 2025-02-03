---
title: "LWP::UserAgent and Basic Authentication"
timestamp: 2015-06-25T15:00:01
tags:
  - LWP::UserAgent
published: true
author: szabgab
---


The so called [Basic access authentication](https://en.wikipedia.org/wiki/Basic_access_authentication) is a very simple way
to limit access to certain web pages.

Web servers can be configured to protect a given directory, or a whole site by a few lines of configuration.
Users are required to authenticate by providing a correct username/password pair which is checked by the web server against a
given set of such pairs.

How can we write a script using [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) that will authenticate
with such server and will be able to access the protected pages?


## PAUSE

First of all, let's see an example. [PAUSE](http://pause.perl.org/)
The Perl Authors Upload Server, which is basically the inbound gate of CPAN usess Basic Authentication.

If you click on [Login](https://pause.perl.org/pause/authenquery), you'll see a
"challenge", a pop-up that, depending on your browser, might look like this:

<img src="/img/pause_basic_authentication.png" alt="PAUSE Basic Authentication pop-up">

If you cancel it, you'll see and <b>Authorization Required</b> error. If you type in incorrect credentials
it will show you the pop-up again and again till you get tired of it.


## Access without authentication

In the first version of our script, we just create an [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)
object, and use the `get` method to fetch the page that requires authentication.

```perl
use strict;
use warnings;
use 5.010;

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;
my $resp = $ua->get( 'https://pause.perl.org/pause/authenquery' );
if ($resp->is_success) {
    say $resp->decoded_content;
} else {
    say $resp->status_line;
    say $resp->decoded_content;
}
```

We have not provided credentials (username/password) and thus the request fails. `is_success`
will return false.
 
The `status_line` method will return

```
401 Authorization Required
```

The `decoded_content` method will return the content of the page we saw after canceling the prompt:

```
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<HTML><HEAD>
<TITLE>401 Authorization Required</TITLE>
</HEAD><BODY>
<H1>Authorization Required</H1>
This server could not verify that you
are authorized to access the document
requested.  Either you supplied the wrong
credentials (e.g., bad password), or your
browser doesn't understand how to supply
the credentials required.<P>
</BODY></HTML>
```

## Providing credentials

Reading the documentation of [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) there seem
to be two ways to provide the credentials.

One of them is to subclass LWP::UserAgent, implement the `get_basic_credentials` method that will be
called when the credential are required. At that time the method will receive 3 parameters, two of which will
identify the web address (URL or URI), and the `$realm`. (See realm explained later.) The method will
need to return a list of `($username, $password)` that will be supplied as credentials to this challenge. 

The other way is to call the `credentials` method with 4 parameters:
`$ua->credentials( $netloc, $realm, $uname, $pass )` to set the challenge/response pairs of pairs.
The credentials method needs to receive the URL (here called $netloc), the realm, and the username/password pair.

The way this works in the background is that the UserAgent will always call the `get_basic_credentials`
method. If we have overridden in a subclass, than it is our responsibility to recognize the current URL/realm
pair and return the correct username/password pair. On the other hand, if we have left `get_basic_credentials`
alone then the already existing implementation of `get_basic_credentials` will be called. It will receive
the URL/Realm pair and look them up in an internal two-dimensional hash. Using the `credentials` method
we can fill up that internal hash with URL/Real pairs mapping to username/password pairs.

## The Realm

The "realm" is a string, sort of an identification string of the area protected by the basic authentication system.

The realm is usually displayed in the challenge pop-up box. In the case of the PAUSE server it has:

```
The site says: "PAUSE"
```

So the realm in this case is "PAUSE".

## How to find out the URL and realm?

As calling the `credentials` method seems much more simple than sub-classing LWP::UserAgent and overriding
`get_basic_credentials`, I wanted to do the former. I tried it several times passing various values as URL,
and "PAUSE" as the realm, but it did not work. So I decided to hack the system a bit to see what are the values
received by the `get_basic_credentials` method.

For this I added the following 3 lines to the original script,

```perl
sub LWP::UserAgent::get_basic_credentials {
    warn "@_\n";
}
```

and removed the code after the call to `get` as they were not needed.
The script looked like this:

```perl
use strict;
use warnings;
use 5.010;

use LWP::UserAgent;
sub LWP::UserAgent::get_basic_credentials {
    warn "@_\n";
}
my $ua = LWP::UserAgent->new;
my $resp = $ua->get( 'https://pause.perl.org/pause/authenquery' );
```

Running the script resulted in the following output:

```
$ perl pause.pl 
Subroutine LWP::UserAgent::get_basic_credentials redefined at pause.pl line 7.
LWP::UserAgent=HASH(0x7facb1027d40) PAUSE https://pause.perl.org/pause/authenquery 
```

What we did here, is defined the `get_basic_credentials` method in the LWP::UserAgent
[name-space](/packages-modules-and-namespace-in-perl). Our methods does not do much,
just prints the received parameters using `warn`. As that method already existed,
when we run the script, we'll get a warning `Subroutine LWP::UserAgent::get_basic_credentials redefined at ...`.
This is, as this is only a temporary solution while we do our little research.

This technique, of reaching inside another name-space and redefining functions there is called
[Monkey patching](https://en.wikipedia.org/wiki/Monkey_patch). It is one of the great flexibilities of
dynamic languages. It can be very useful as quick-and-dirty solution, as in our case, and can be very harmful if
overused.

Anyway, the second line of output is what really interests us. There are 4 values in the output. The first one
is the current LWP::UserAgent instance. It is always [passed as the first parameter](/getting-started-with-classic-perl-oop).
The second parameter (PAUSE) is the realm, and the third parameter (https://pause.perl.org/pause/authenquery) is the URL.

## Supply the credentials

The next step was to remove the newly added code (the monkey patch) and instead of that to add a
call to `credentials`. The resulting script looked like this (but it had my password hard-coded).

```perl
use strict;
use warnings;
use 5.010;

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;

$ua->credentials( 'https://pause.perl.org/pause/authenquery', 'PAUSE', 'szabgab', '**********');

my $resp = $ua->get( 'https://pause.perl.org/pause/authenquery' );
say $resp->status_line;
```

Running this script we get:

```
401 Authorization Required
```

oops.

Let's try just the hostname

```perl
$ua->credentials( 'pause.perl.org', 'PAUSE', 'szabgab', '**********');
```

Still no:

```
401 Authorization Required
```

Let's try to add the port number as well (The example in the documentation
had the port number :80 in, but this is an https request and the https requests
use port 443.)

```perl
$ua->credentials( 'pause.perl.org:443', 'PAUSE', 'szabgab', '**********');
```

Running the script again already yield:

```
200 OK
```

Heúrēka!

If we added a call to `say $resp->decoded_content;` we would get all the HTML that is on the internal, protect page.
We can now write our application to deal with the PAUSE server, or for that matter, any server protected by basic authentication.

## Monkey patching again

While we already have one solution, let's see the other ways.

We can go back to the Monkey-patching and redefine the `get_basic_credentials` method.

```perl
sub LWP::UserAgent::get_basic_credentials {
    my ($self, $realm, $url, $isproxy) = @_;

    return 'szabgab', '**********';
}
```

In this version we accept the 4 parameters passed to the method, but we have not actually used them.
(We have not seen it, but the $isproxy was in the documentation, so I added it here.)
In a real application we might use the parameters and return the correct username/password pair based on these
parameters and maybe based on some other information.

This version works, but it still gives us the `Subroutine LWP::UserAgent::get_basic_credentials redefined` warning.

We can use `no warnings 'redefine';` to turn off the redefine warning. This call will turn off
the specific warning till the end of the file or the end of the enclosing block. Hence we wrapped
the whole redefinition part in an anonymous block. It is a bit more writing, but it is much safer. This way
if we accidentally redefined another function later on, we'll still get the proper warning about those cases.
We have turned off warning only for the specific block of our code.

```perl
{
    no warnings 'redefine';

    sub LWP::UserAgent::get_basic_credentials {
        my ($self, $realm, $url) = @_;
    
        return 'szabgab', '**********';
    }
}
```


So this solution works. It does not warn, but it is still just a monkey-patch.

What about proper sub-classing?


## Sub-classing - in the script

In the beginning of this script we switch to a new name-space we called `My::Client`.
This is going to be the subclass of `LWP::UserAgent`.

The call `use base 'LWP::UserAgent';` arranges the sub-classing. It tells perl that
our current class (My::Client) inherits from the LWP::UserAgent base-class.
The we implement the `get_basic_credentials` method inside the My::Client package/name-space
and switch back to the default, `main` name-space using `package main;`.

In the main part of the code we create the UserAgent object using `My::Client->new;`.

There is no need to explicitly load `LWP::UserAgent` as the `use base 'LWP::UserAgent';`
will arrange the loading of that module.


```perl
use strict;
use warnings;
use 5.010;

package My::Client;
use strict;
use warnings;
use base 'LWP::UserAgent';

sub get_basic_credentials {
    my ($self, $realm, $url) = @_;
    
    return 'szabgab', '**********';
}

package main;

my $ua = My::Client->new;

my $resp = $ua->get( 'https://pause.perl.org/pause/authenquery' );
say $resp->status_line;
```

This works: (after typing in the real password, of course)

```
200 OK
```


## Sub-classing - in external file

The above sub-classing code works perfectly, but it is usually cleaner to put each package
in its own file. It also make reuse possible.

So we moved the implementation of the `My::Client` module to the file "lib/My/Client.pm".
We also had to add `1;` at the end to [make Perl happy](/getting-started-with-classic-perl-oop).

```perl
package My::Client;
use strict;
use warnings;
use base 'LWP::UserAgent';

sub get_basic_credentials {
    my ($self, $realm, $url) = @_;
    
    return 'szabgab', '**********';
}

1;
```

The script itself also had some changes:

First of all we now have to explicitly load `My::Client` with a use-statement. We preceded that with a
`use lib 'lib';` to [adjust @INC](/how-to-add-a-relative-directory-to-inc),
and we could remove the extra `package main;` as we are in the main package by default.

```perl
use strict;
use warnings;
use 5.010;

use lib 'lib';
use My::Client;
my $ua = My::Client->new;

my $resp = $ua->get( 'https://pause.perl.org/pause/authenquery' );
say $resp->status_line;
```

And the result is again:

```
200 OK
```

## A simpler solution with HTTP::Request::Common

There is an even simpler solution using [HTTP::Request::Common](/basic-authentication-with-lwp-useragent-and-http-request-common).

## Conclusion

We saw a number of ways to implement this. Using <h>credentials` is the quick way, but we can also properly subclass
LWP::UserAgent which provide a lot more flexibility and a potential to reuse our code.

## Comments

Gabor - thank you for the excellent article. I have tried both the above and HTTP::Request::Common.
I have a site that for logged-in users, allows getting 9 pages as a single page and allows access to each page one by one by providing a URI Query string like "?page=4".

The code never gets a calls to the credentials function - so the Perl script "acts" like it is unauthenticated and the query string is ignored.

Any ideas how I might approach this so the request WILL BE seen as authenticated?

An example URI is
http://seekingalpha.com/art...

This gives back a single long article page when logged in on the site, but only one page when not, and the same from Perl.

<hr>

Good article. I tried to use your information for POST + LWP. But there differences between POST and GET - credentials work different.

It was not simple to find working code examples for this.

Here my code for POST + LWP.

use LWP::UserAgent;
use HTTP::Request::Common;

my $ua = LWP::UserAgent->new;

my $req = POST( $url, [ data => $filedata, type => "userlist" ] );
$req->authorization_basic('gerd', 'mypassword');

my $res = $ua->request( $req );

print "respose-Code: " . $res->code . " reponse-Message: " . $res->message . "\n";

---

I appreciate your reply, it is indeed hard to find working POST requests for file uploads. I have a similar piece of code that I got working for a Canvas REST API. Feedback welcome. Love Perl Maven btw!

#Perl program to send up files to Canvas SIS Import API

use HTTP::Response;
use HTTP::Headers;
use HTTP::Request::Common;
use LWP::UserAgent;
use JSON qw{decode_json};

#Setup header
my $canvasAuthToken = 'Bearer <yourtoken>';
my $post_course_filename = 'test_course.csv';
my $post_course_URL = 'https://<your canvas="" instance="">/api/v1/accounts/self/sis_imports.json?import_type=instructure_csv';

my $post_course_header = HTTP::Headers->new(
'Authorization' => $canvasAuthToken,
'Content-Type' => 'text/csv',
);

#From CPAN: $request = HTTP::Request->new( $method, $uri, $header, $content )
#Build and post request
my $request = HTTP::Request->new( POST =>,$post_course_URL, $post_course_header, Content => $post_course_filename );
my $ua = LWP::UserAgent->new;
my $response = $ua->request($request);
if ( $response->is_success ) {
print( $response->decoded_content . "\n" );
my $json = decode_json( $response->decoded_content );
}
else {
print( STDERR $response->status_line() );
}


<hr>
fantastic article. very good ideas and executions.
