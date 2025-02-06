---
title: Add "404 Not Found" page
timestamp: 2015-05-28T21:10:01
tags:
  - SCO
  - Template::Toolkit
  - 404
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


Now that we have added a [static page](/add-another-static-page) to the site we can turn our attention
to the 404 page. That too is a static page with another special need.

Let's convert that to use the SCO look-and-feel as well.


{% youtube id="5E3-zJe4dGg" file="add-404-not-found-page" %}

## Create the 404 template

The [PSGI skeleton](/create-skeleton-psgi-application) still has the code sending a plain
`404 Not Found` page for every other request:

```perl
return [ '404', [ 'Content-Type' => 'text/html' ], ['404 Not Found'], ];
```

The 404 page should look just like any other page on search.cpan.org, it even has the cpanstats at the bottom
we [worked so hard to try to replicate](http://search.cpan.org/xyz).

First thing is to create the template with the unique content of the 404 page.

We can visit a page that does not exists, for example http://search.cpan.org/xyz and click on view-source.
There we can find the content specific to this page and copy it tot a file called
[tt/404.tt](https://github.com/szabgab/MetaCPAN-SCO/blob/e865a6c2fd04ac3edb5026180de2b567c73a4763/tt/404.tt).
That was quite easy. Now we need to use that template to create the HTML file.

We can just replace

```perl
return [ '404', [ 'Content-Type' => 'text/html' ], ['404 Not Found'], ];
```

by

```perl
template('404');
```

and visit any [not existing page](http://localhost:5000/abc) to see the results.


## Change the HTTP response code

That looks good. The only problem is that the `template()` function returns
all the pages with a `200 Success` code and in the case of the 404 page,
we would like the HTTP status code to be 404.

In order to see what HTTP status code a page returns try `curl -I` (that's an upper case i)

Main page:

```
$ curl -I http://search.cpan.org/
HTTP/1.1 200 OK
Date: Wed, 19 Nov 2014 09:17:39 GMT
Server: Plack/Starman (Perl)
Content-Length: 3643
Content-Type: text/html
Connection: close
```

Not existing page on search.cpan.org:

```
$ curl -I http://search.cpan.org/abc
HTTP/1.1 404 Not Found
Date: Wed, 19 Nov 2014 09:17:42 GMT
Server: Plack/Starman (Perl)
Content-Length: 4006
Content-Type: text/html
Connection: close
```


Not existing page on the clone:
```
$ curl -I http://localhost:5000/abc
```

We could change the `template` function to accept a value for the status code, but
in almost every other page this should be 200. So making all other places pass 200 seemed
like a waste of clarity. Making the parameter optional and then setting it to default to 200
would work, but seemed a bit complex to implement.

Finally I settled with just calling `template()`, capturing its output, and replacing the
HTTP status code before returning the value to be displayed by the browser.

We know that `template()` will return a 3-element array reference in which the first value is the
status code, the second is the header, and the third is the content of the page.

So I wrote this:

```perl
   my $reply = template('404');
   return [ '404', [ 'Content-Type' => 'text/html' ], $reply->[2], ];
```

Instead of the hard-coded '404 Not Found' string I put in the content returned by the
`template()` function in the 3rd place.

Actually, looking at the code now, it might be cleaner to write this:

```perl
   my $reply = template('404');
   $reply->[0] = '404';
   return $reply;
```

but I Am not sure in that.

That is, replacing the status-code in the reply we received from the `template()` function.
We can visit the [page](http://localhost:5000/abc) again to make sure it still works
and we can look at its header:

```
$ curl -I http://localhost:5000/abc
```


That brings us to the next [commit](https://github.com/szabgab/MetaCPAN-SCO/commit/e865a6c2fd04ac3edb5026180de2b567c73a4763)

```
$ git add .
$ git commit -m "add 404 Not Found page based on the content on sco. Use template for it"
```


