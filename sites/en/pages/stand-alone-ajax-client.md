---
title: "Stand-alone Ajax client and the Access-Control-Allow-Origin issue"
timestamp: 2016-03-14T20:30:01
tags:
  - Access-Control-Allow-Origin
published: true
books:
  - dancer2
  - jquery
author: szabgab
archive: true
---


In the [first article](/ajax-and-dancer2) we have created a server and HTML page served from the same server that
sent an Ajax request to the server, received response and displayed it.

This time we are going to use the same back-end server, but will try to create a client that can be served from a different
server, or can be even loaded from the local disk. (The latter mostly for development purposes.)


We'll put our code in the same [GtiHub repository](https://github.com/szabgab/D2-Ajax/) just in a separate subdirectory.
We create a new directory called `client` and in it we put the file `client/v1.html` with the following content:

```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">

  <title>D2::Ajax - v1</title>
  <script type="text/javascript" src="../public/javascripts/jquery.js"></script>
</head>
<body>

<div id="msg"></div>

<script>
$(document).ready(function() {
    jQuery.get('http://127.0.0.1:5000/api/v1/greeting', function(data) {
        console.log(data);
        $("#msg").html(data["text"]);
    });
});
</script>

</body>
</html>

```

This is a simple HTML page with embedded JavaScript.

We load `jquery.js` from the same public directory where Dancer put it. We could have a copy of the file inside our own directory
or we could have loaded it from a CDN, but for the examples I think the best is to just reuse the one already in the repository.
Especially as we are going to use this on the local disk and we want to make sure it is available even if
I don't have Internet access.

In the `body` we have the same `div` element as we had in the [first version](/ajax-and-dancer2),
and the jQuery is also the same, except the URL which now needs to refer to the "remote" server  `http://127.0.0.1:5000/api/v1/greeting`
where the back-end runs.

If we open this file directly with a browser using the File/Open menu we'll get a blank page.
(In order to open this file we don't use a server, just access the disc directly.)
Only if we open the JavaScript console of our browser will we see the error message:

```
XMLHttpRequest cannot load http://127.0.0.1:5000/api/v1/greeting. No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'null' is therefore not allowed access.
```

## How to fix the Access-Control-Allow-Origin error?

In a nutshell, for security reasons browsers will only allow to handle Ajax request to the same server where your script comes from, unless the server where you want
to send the request to explicitly allows you by setting the Access-Control-Allow-Origin header and either declaring your site as one that can have the extra rights
or they allow **every** site to have these right.
If your plan was to offer a public API to your system, then allowing this seems totally reasonable. After all, once could set up a site that would proxy these requests
to your site. The only difference would be that it is slower.

For the long explanation check the 
[HTTP access control (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) of Mozilla.

In our case we only need to add one line to the code:

```perl
    header 'Access-Control-Allow-Origin' => '*';
```

and the new, stand-alone page  will suddenly start to work.

Instead of that though, we are going to leave the existing route as it is and we are going to create a new route. If for nothing else, so it might be
easier for us to later revisit this situation.

So we add a new route for version 2 of the API:

```perl
get '/api/v2/greeting' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    header 'Content-Type' => 'application/json';
    return to_json { text => 'Hello World' };
};
```

It is the same as we already had, except we have `v2` in the URL instead of `v1` and we have the extra line adding the
new entry to the header: Access-Control-Allow-Origin.

We won't add an extra route to see this page, as from now on we are going to develop the stand-alone client only.
On the other hand we create another html page called `client/v2.html` that has the exact same content as
`client/v1.html`, except that it will access the v2 API at `http://127.0.0.1:5000/api/v2/greeting`.

[commit](https://github.com/szabgab/D2-Ajax/commit/dc25f4faa18a4f85a3cccec73a573eb6992084a2)

## Testing the v1 and v2 API calls

It's nice that we ran ahead and fixed the Access-Control issue, but if we were following the big-book of TDD (Test Driven Development)
then we would first write the test. Of course in this case, we can't really test he failure without launching a real web server and
without using a real browser - even if we automate it - so let's test the code how it supposed to work.

We can replica the test for the v1 API call as the v2 API call, and that should still work, but then neither of the test would check
the real culprit of the solution. The Access-Control-Allow-Origin header. So we should test that the v2 API call includes that header
and that the v1 call does not include that header.

So I added the following assertion to `t/v1.t` and incremented the test plan in the subtest to 4.

```perl
    is $res->header('Access-Control-Allow-Origin'), undef;
```

Then I've copied `t/v1.t` to `t/v2.t` and made a few changes:

This is the diff:

```
$ diff t/v1.t t/v2.t 
9c9
< subtest v1_greeting => sub {
---
> subtest v2_greeting => sub {
15c15
<     my $res  = $test->request( GET '/api/v1/greeting' );
---
>     my $res  = $test->request( GET '/api/v2/greeting' );
20c20
<     is $res->header('Access-Control-Allow-Origin'), undef;
---
>     is $res->header('Access-Control-Allow-Origin'), '*';
```

after that I could run

```
$ perl Makefile.PL
$ make
$ make test
```

again, and all was OK.

[commit](https://github.com/szabgab/D2-Ajax/commit/df5a55714b02aaecb21a22f297840b887ae40c3a)

