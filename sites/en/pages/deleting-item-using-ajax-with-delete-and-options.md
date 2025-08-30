---
title: "Deleting item using Ajax request with DELETE and OPTIONS"
timestamp: 2016-07-29T10:10:01
tags:
  - Access-Control-Allow-Methods
  - OPTIONS
  - DELETE
  - remove
published: true
books:
  - dancer2
author: szabgab
archive: true
---


We can now [add new elements and list the existing elements](/add-and-retreive-items-jquery-ajax) from our list of items, but how can we delete an element?

For this we need another ajax request that will send in the ID of the item. For that we'll have to create a button on the HTML page that already has this ID. Before doing the front-end though, let's add the API call for deleting an item.


I could send another `GET` request for this, but if I understand [REST](http://en.wikipedia.org/wiki/Representational_state_transfer) correctly, this operation should be a `DELETE` request.


## Travis-CI

Before going on I wanted to turn on [Travis-CI](https://travis-ci.org/) for Continuous Integration and testing
in two commits:
[commit 1](https://github.com/szabgab/D2-Ajax/commit/c89a071c6919369eebdb88c2c297b10974845bd1)
and
[commit 2](https://github.com/szabgab/D2-Ajax/commit/e86b05b8c7e4480319311cbb5dc48ba7b41f60c6)

```
branches:
  except:
    - gh-pages
language: perl
perl:
  - "5.20"
  - "5.18"
  - "5.16"
  - "5.14"
  - "5.12"
  - "5.10"
before_install:
  - cpanm --notest MongoDB
services:
  - mongodb
```

Check out the post of Neil Bowers for more details on [how to set up Travis-CI](http://blogs.perl.org/users/neilb/2014/08/try-travis-ci-with-your-cpan-distributions.html).

## Refactoring the code

Then, before I implemented the `DELETE` feature I felt I have to do a little refactoring.
We had two places where we connected to MongoDB and accessed the collection. I wanted to unite
them and hide them in a single function. Hence I created the `_mongodb` function:

```perl
sub _mongodb {
    my ($collection) = @_;

    my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    my $db   = $client->get_database( config->{app}{mongodb} );
    return $db->get_collection($collection);
}
```

and in the two places where it was used, I replaced the same code snippet with a call to

```perl
my $items = _mongodb('items');
```

## The back-end in Dancer

[Dancer](/dancer) supports the implementation of the `DELETE` [HTTP method](http://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods), but instead of using the [delete](/search/delete) word, which is an existing built-in function in perl, it used the `del`
keyword.

Here we expect that the client will send in a url that looks like this: `/api/v2/item/913397349743`,
the last part being the OID of the object in the MongoDB. In MongoDB every document has a unique ID in the `_id`
field. If we don't supply one, MongodDB will create one for us. If you recall in the earlier articles when we wrote
the tests, we had to disregard these ids, because they are totally unpredictable and they change from test-run to test-run.

The `param` function of Dancer will return the string that was the last part of that URL which is expected to be the ID.

Then we call `_mongodb('items')` that we have just created with the refactoring and we call the `remove`
method passing the filter that will locate the document with the specific ID.

After that we return a hash reference indicating success.

As far as I understood, the current MongoDB driver for Perl won't be able to tell if there was anything deleted or
if the supplied ID did not match anything, though we could add some more robust error reporting.
For now I think we'll live with this code.

`lib/D2/Ajax.pm`

```perl
del '/api/v2/item/:id' => sub {
    my $id = param('id');

    my $items = _mongodb('items');
    $items->remove({ _id => MongoDB::OID->new($id) });

    my $json = JSON::MaybeXS->new;
    return to_json { ok  => 1 };
};
```

## Testing the API

Implementing the API without any test would not be full, so I edited `t/v2.t`
and added the following code to the `v2_items` subtest:

```perl
    my @items = ("One 1", "Two 2", "Three 3");
    foreach my $it (@items) {
        my $res = $test->request( POST '/api/v2/item', { text => $it });
        is_deeply decode_json($res->content), { ok => 1, text => $it };
    }
    my $get5  = $test->request( GET '/api/v2/items');
    my $items5 = decode_json($get5->content);
    is scalar @{$items5->{items}}, 5;

    my $del3  = $test->request( DELETE '/api/v2/item/' . $items5->{items}[3]{'_id'}{'$oid'} );
    is $del3->content, '{"ok":1}';

    my $get6  = $test->request( GET '/api/v2/items');
    my $items6 = decode_json($get6->content);
    is scalar @{$items6->{items}}, 4;
    is_deeply $items5->{items}[0], $items6->{items}[0];
    is_deeply $items5->{items}[1], $items6->{items}[1];
    is_deeply $items5->{items}[2], $items6->{items}[2];
    is_deeply $items5->{items}[4], $items6->{items}[3];
    is_deeply $items5->{items}[5], $items6->{items}[4];
```

At first this code adds 3 more items checking if they were added successfully.
Then it sends a "DELETE" request using the ID of the 4th element (index 3)
and checks if the returned JSON string represents the
expected `{ ok => 1 }` data structure from Perl.

Then we fetch the list of items again, check if there are only 4 left  and check if the 4 that were
left match the 4 we expected to be there. (Without the element we have deleted.)

This was not enough to run the tests though. Apparently
[HTTP::Request::Common](https://metacpan.org/pod/HTTP::Request::Common) exports
`GET` and `POST` automatically, but if we also want to use `DELETE`
we need to ask for it. Hence we also had to change the use-statement at the top of the test script to be:

```perl
use HTTP::Request::Common qw(GET POST DELETE);
```

After updating the "test plan" as well, the test ran successfully.

[commit](https://github.com/szabgab/D2-Ajax/commit/14112caddf8afda7c6c1f79a506e52148f0428df)

## Client side for DELETE-ing

Then I set out to implement the client-side code for deleting an item.
The first thing I had to do is to add a "delete" button next to each item that will
also hold the ID of that item. Luckily the Ajax request that retrieves the list of items
also sends over the ID of each item. We can modify the HTML we generate to include a button:

This is the new code:

```javascript
for (i = 0; i < data["items"].length; i++) {
    html += '<li>' + data["items"][i]["text"] + '<button class="delete" data-id="' +  data["items"][i]["_id"]["$oid"]  + '">x</a></li>';
}
```

This will add a `button` element at the end of each item with two attributes. One of them is `class="delete"`
will make it easy to locate all the delete buttons, the other one `data-id="....">` holds the id of the current element.

It will look like this:

![](/img/dancer2_ajax_list_with_delete.png)

Once the new HTML is injected in the existing page we also call

```javascript
    $(".delete").click(delete_item);
```

this will attach the `delete_item` function to each on of the buttons that are in the "delete" class.

The new code generating the HTML looks like this:

```javascript
function show_items() {
    jQuery.get('http://127.0.0.1:5000/api/v2/items', function(data) {
        var i, html;
        html  = '<ul>';
        console.log(data);
        for (i = 0; i < data["items"].length; i++) {
            html += '<li>' + data["items"][i]["text"] + '<button class="delete" data-id="' +  data["items"][i]["_id"]["$oid"]  + '">x</a></li>';
        }
        html += '</ul>';
        $("#items").html(html);
        $(".delete").click(delete_item);
    });
}
```

Now we only need to implement the `delete_item` function:

```javascript
function delete_item() {
    var id = $(this).attr('data-id');
    jQuery.ajax({
        url: 'http://127.0.0.1:5000/api/v2/item/' + id,
        type: 'DELETE',
        success: function(data) {
            show_items();
        }
    });
}
```

It is a simple Ajax call just like the `get` and the `post` calls we saw earlier, but jQuery does not have the nice syntactic sugar for sending a delete request and thus we had to write a few more lines. Nevertheless, here too we have a call-back that will be executed once the server replied. The only thing the callback does is calling the `show_items` function.
Actually I could have written `success: show_items` as well.

It was time to try it in the browser. I loaded the page, and clicked on one of the `x` buttons and nothing happened.

Looking at the console I saw this error:

```
XMLHttpRequest cannot load http://127.0.0.1:5000/api/v2/item/556db39fa114604bac0757d1. No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'null' is therefore not allowed access. The response had HTTP status code 404.
```

This baffled me for quite some time, after all I've already [fixed the Access-Control-Allow-Origin](/stand-alone-ajax-client) issue.

Looking at the error message more could have given me a clue, but it didn't.
The clue would been the fact the I also had `The response had HTTP status code 404.` which means the server could not find
the route and returned a 404 which does not have the Access-Control-Allow-Origin header.

There was also another clue I missed. In the console, just before this error, there was another error:

```
OPTIONS http://127.0.0.1:5000/api/v2/item/556db39fa114604bac0757d1
```

which shows that jQuery, instead of sending the `DELETE` request, it sends an `OPTIONS` request.

That was not enough for me. I looked at the console where I run the `plackup -R lib bin/app.psgi` which said,
among many other things:

```
looking for options /api/v2/item/556db39fa114604bac0757d1
```

That further confused me. Why is Dancer looking for the "options" HTTP method while I requested the "delete" method?

Apparently this is due to some safety feature of Chrome when using cross domain requests. If in a cross-domain request
we ask for anything else than basic GET or POST, Chrome will first send an "OPTIONS" request to the same URL and will look for the
`Access-Control-Allow-Methods` header that needs to list the HTTP methods the server will accept. The content of the response of that
request can be empty, just the header needs to be set. So I added


```perl
        header 'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS, DELETE';
```

to the `before` hook so it will send it on every request in the v2 API, and I've also added a route:

```perl
options '/api/v2/item/:id' => sub {
    return '';
};
```

After that the "delete" buttons started to function as I expected.

[commit](https://github.com/szabgab/D2-Ajax/commit/f0c2bf2d3a6a716726afdea7d8b421ca27050984)


## Updating the tests

Now both the client work and our tests are still passing, but I think I'd better update the tests to check
the latest changes to the back-end code.

I've added the test code:

```perl
    my $options  = $test->request( OPTIONS '/api/v2/item/anything' );
    ok $options->is_success, '[POST /] successful';
    is $options->header('Access-Control-Allow-Methods'), 'GET, POST, OPTIONS, DELETE';

```

and wanted to import the `OPTIONS` method from [HTTP::Request::Common](https://metacpan.org/pod/HTTP::Request::Common),
but apparently it does not support it. There is even an [open ticket](https://rt.cpan.org/Ticket/Display.html?id=68644) from 2011.

For now I am going to leave the test in, commented out and include the link to the ticket. Later we might revisit the issue.

[commit](https://github.com/szabgab/D2-Ajax/commit/bd94d5c1c0b1ccf228de43b704c2cf5d14e9de76)

## Comments

Hello, sir I try to delete the product id from session, it already deleted the data, but I still have problem that the data is still keep the old data until we click to other pages that it will not show on the view page. How make it smoothly to get new data after we deleted?

         function clearCart()
{
    var msgClear = confirm ("Are you sure you want to clear carts list?");
    if (msgClear) {
        $.ajax({
            type: "POST",
            url: "",
            data: "",
            success: function (response) {
                alert(response);
              
            }
        });
    }
}


