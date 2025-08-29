---
title: "Basic Authentication without a Challenge"
timestamp: 2017-11-07T08:50:01
tags:
  - LWP::UserAgent
  - MIME::Base64
published: true
author: szabgab
---


In another article you can read how [how handle Basic Authentication using LWP::Simple](/lwp-useragent-and-basic-authentication).
In normal circumstances when accessing a site that uses [Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication)
to protect some pages, you'll see a "challenge". On the HTTP level it is a `401 Not Authorized` response with a header containing

```
WWW-Authenticate: Basic realm="insert realm"
```

Browsers usually show a pop-up window asking for username/password.

There are however sites that do not provide this challenge.


**This article is originally from 2014. Since then Gittip was renamed to be Gratipay and in November 2017 it was shut down. Nevertheless the technique is still useful.**


I am not even sure if it is according to the specification of [Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication),
to expect the credentials without sending the challenge but there are sites that work that way.

For example, recently I was trying to implement the [Perl API client of Gittip](http://metacpan.org/pod/WWW::Gittip).
The [API of Gittip](https://github.com/gittip/www.gittip.com#api) is described in their [GitHub](https://github.com/gittip/www.gittip.com/) repository.
There is a request, not even documented yet to [get the communities](https://www.gittip.com/for/communities.json). Currently, if it is accessed without
authentication it returns an empty list. If an authenticated user access it, it will return the list of all the communities and for each community a flag indicating if the
current user is member of that community or not. This worked in the browser when I was logged in.

It worked using `curl` on the command line:

```
curl -u 123-456: https://www.gittip.com/for/communities.json
```

(If the API KEY listed in [user account](https://gittip.com/about/me/account) is 123-456, we need to use that as the "user name"
and use an empty password. The <h>-u` parameter of `curl` allows us to pass a username:password pair as in this example: `curl -u username:password http://...`)

Unfortunately it did not work using [LWP::UserAgent](/lwp-useragent-and-basic-authentication) solution.

The reason that did not work is because LWP::UserAgent first tried to access the page without authentication and it received a `200 OK` answer with an empty list
instead of an authentication challenge. 

I took this as a personal challenge and started to read the code of LWP::Simple. First I was looking for the place where
the method `get_basic_credentials` is called.
Then I tried to determine the actual process from the place where we call the [>get](https://metacpan.org/source/MSCHILLI/libwww-perl-6.06/lib/LWP/UserAgent.pm#L407)
method on the UserAgent. That is a very short method that in the end calls the 
[request](https://metacpan.org/source/MSCHILLI/libwww-perl-6.06/lib/LWP/UserAgent.pm#L278) method.

Here I noticed the code mentioned `WWW-Authenticate` and further looking at the code I noticed the call to
`$class->authenticate` where the `$class` was built from `LWP::Authen::$scheme` The `$scheme` is actually "Basic" in our case
and thus the code implementing the `authenticate` method is in [LWP::Authen::Basic](https://metacpan.org/pod/LWP::Authen::Basic).
That's where `get_basic_credentials` is actually called, and that's where a new entry is added to the header of the request.
It is the `"Authorization"` and the value is created by `auth_header` method:

```perl
return "Basic " . MIME::Base64::encode("$user:$pass", "");
```

I was looking for, but I could not find a way to tell LWP::UserAgent to always send the credentials, even if there was no challenge
so I needed another way.

It turned out to be quite easy. All I had to do is to call the `default_header` method of the UserAgent object
before I call the `get` method. The `default_header` method gets two parameters. The first is the name of
the header, `Authorization` in our case, the second is a base64 encoded version of the "username:password" string.
According to the API documentation, Gittip expects the API_KEY to be the username and the password to be the empty string.

So this is what we had to add to our code:

```perl
use MIME::Base64;
$ua->default_header('Authorization',  "Basic " . MIME::Base64::encode('123-456:', '') );
```

This is the full script. (Of course instead of '123-345' we have to put out API_KEY there.

{% include file="examples/gittip.pl" %}

## Conclusion

While this is certainly a working solution, I wonder if there is a better solution with the tools already built in LWP::UserAgent,
and if not whether there should be. 

## Comments

I think it is perfectly fine to hack around some website that isn't compliant by itself. But feel free to write LWP::UserAgent::Authorization::Basic, which will always send the BASE64 encode username and password conform RFC7617.


