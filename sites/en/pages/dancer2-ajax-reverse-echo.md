---
title: "Reverse Echo with Ajax and Dancer 2"
timestamp: 2016-03-22T22:00:01
tags:
  - param
published: true
books:
  - dancer2
  - jquery
author: szabgab
archive: true
---


We have seen how to implement [sending data in JSON via an Ajax call](/ajax-and-dancer2)
to a [stand alone client](/stand-alone-ajax-client)
and handling that with jQuery. Let's now go a step forward and see how can we implement two-way communication between the client and the server.

Let's create a page with a text entry form where the user can type in some text and when the user clicks on the button "Reverse" the text will be sent to the server,
which will return the reversed version of the same text in a JSON data structure which then will be displayed by the code in the client.

Hmm, it sounds more complex than it really is.


## Reverse string in Dancer

Before implementing the clients side, let's implement the code for the server together with the tests as we had earlier.

This is how we can implement the route in the `lib/D2/Ajax.pm` file:

```perl
get '/api/v2/reverse' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    header 'Content-Type' => 'application/json';
    my $text = param('str');
    my $rev = reverse $text;
    return to_json { text => $rev };
};
```

The difference between this and the one implementing the greeting is that we accept a parameter called 'str' and
read it using the `param` function supplied by Dancer: `param('str')`.
Then we call the [reverse](/reverse) function of Perl and then we return a JSON including the
reversed string.

## Test the new API call

The test added to `t/v2.t` looks like this:

```perl
subtest v2_reverse => sub {
    plan tests => 6;

    my $app = D2::Ajax->to_app;

    my $test = Plack::Test->create($app);
    my $res  = $test->request( GET '/api/v2/reverse?str=Hello world' );

    ok $res->is_success, '[GET /] successful';
    is $res->content, '{"text":"dlrow olleH"}';
    is $res->header('Content-Type'), 'application/json';
    is $res->header('Access-Control-Allow-Origin'), '*';

    my $res2  = $test->request( GET '/api/v2/reverse?str=' );
    is $res2->content, '{"text":""}';

    my $res3  = $test->request( GET '/api/v2/reverse' );
    is $res3->content, '{"text":""}';
};
```

The first part of the test is quite similar to what we had earlier. The difference between this and the one we used for the greeting route is
that the URL where we send the method call which is `/api/v2/reverse`.
We also pass the argument: `/api/v2/reverse?str=Hello world`.
and we have hard-coded the expected result, which is the already reversed string.

Then there are 2 more calls testing some edge-cases. In those cases I've not added the testing of the headers any more.
Just making sure the content is what we expect.

We can run the tests now

```
$ make test
```

and it will tell us everything has passed.

[commit](https://github.com/szabgab/D2-Ajax/commit/b28f0c5bbabc19f7de61c111e0baa68627fe7e4a)

## Client side of string reversion using jQuery

We change the `client/v2.html` file add a simple HTML form to it:


```html
<form>
<input name="str" id="str">
<input type="submit" id="reverse" value="Reverse">
</form>
```

and the jQuery code as part of the document ready function:

```javascript
    $("#reverse").click(function() {
        var str = $("#str").val();
        jQuery.get('http://127.0.0.1:5000/api/v2/reverse?str=' + str , function(data) {
            console.log(data);
            $("#msg").html(data["text"]);
        });
       return false;
    });
```

This means that we locate the element that has the id "reverse" (which is the submit button in our form)
and attach a callback to it 'click' event. In the callback function first we fetch the value of the
element with the id "str" and assign it to the variable with the same name: `var str = $("#str").val();`
Then we use that variable to construct our `GET` request which will have the same callback
as the we had for the greeting route.

Finally we call `return false;`. This ensures that after we reacted to the click-event the browser will stop
handling this even and won't actually submit the form to the server. We don't want that as that would reload the
whole page and ruin our application.

Once this is saved we can open the `client/v2.html` in our browser and we can play with the form that looks like this:

<img src="/img/dancer2_ajax_reverse_echo.png" />

[commit](https://github.com/szabgab/D2-Ajax/commit/6fc6c1b5148b4d99e15c20236c323e83720b4c7f)

The files:
* [lib/D2/Ajax.pm](https://github.com/szabgab/D2-Ajax/blob/6fc6c1b5148b4d99e15c20236c323e83720b4c7f/lib/D2/Ajax.pm)
* [t/v2.t](https://github.com/szabgab/D2-Ajax/blob/6fc6c1b5148b4d99e15c20236c323e83720b4c7f/t/v2.t)
* [client/v2.html](https://github.com/szabgab/D2-Ajax/blob/6fc6c1b5148b4d99e15c20236c323e83720b4c7f/client/v2.html)

