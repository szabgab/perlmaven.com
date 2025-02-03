---
title: "Keep data in client and fetch only changes"
timestamp: 2016-10-04T08:50:01
tags:
  - Test::Deep
  - cmp_deeply
  - re
published: true
books:
  - dancer2
  - javascript
  - jquery
author: szabgab
archive: true
---


So far we have been fetching the full list of items on every change. Both when the user has
added a new item and when the user has deleted an item. If there are only a few
items this is not a big issue, but as more and more items are going to be in our
database, and if each item will contain all kinds of other data fields, then
fetching the full list will become a burden on the server and will generate
unnecessary network traffic.

So let's change how the system works. Send the full list only when first loaded
and from there on send only the updates.


## Store the list in a variable in javascript

Currently we have function called `show_items` that fetches
all the items from the server and then displays them.

We could split that function into two, one of them called `get_items`
that would fetch the list and store the results in a variable and `show_items`
that would show the items listed in that variable.

We create a global variable to hold the list of items:

```javascript
var items;
```

The new `get_items` function fetches the items from the server
and stores them in the `items` variable. Then it calls `show_items`.

I had to put the `show_items` in the call-back inside this function because
when we first load the application the `show_items` should be only called
after we got the list from the server.

```javascript
function get_items() {
    jQuery.get('http://127.0.0.1:5000/api/v2/items', function(data) {
        items = data;
        show_items();
    });
}
```

`show_items` is quite similar to what it was earlier, but instead
of using the data received in the call-back, it assumes the data is already
in the `items` variable and uses that.

Actually as a safety mechanism, I've added this snippet that would call the
`get_items` if the list of items has not been filled yet.

```javascript
if (items === undefined) {
    get_items()
    return;
}
```

In addition, at the places where we call `show_items` (after adding a new element or deleting one)
first we call

```javascript
items = undefined;
```

that will reset the list and force `show_items` to call `get_items`.
Once we finish the rest of the code, and both the "add item" and "delete item" will
be able to update the list in the memory, then we can remove this code, as `items`
will have the correct content.

We can try manually if the web application still works as earlier.

[commit: separate get_items from show_items, and use the items global variable ](https://github.com/szabgab/D2-Ajax/commit/44dcc6ffe67d1dc04c6343f2cd5e800fbf85e98d)

## Fetch information of individual element - backend code

The next step is to write the back-end code that will allow us to fetch details about an individual item.
This is important for us for the case when the user adds a new element.

When the user types in the text and clicks on the button to save the element we don't have all the information to
update the list of elements in the browser. First of all we don't have the exact timestamp the back-end saves in the database.
We could generate a timestamp in the browser, but they will be different. In addition, we also need the id from the database
in order to be able to delete the item. (In other, more complex applications we might need this id to change something about the item).

We might also want to receive confirmation from the server that the item was indeed saved before we display it
to the user.

All this could be sent back in the response to the "insert item" call, but just as in the case of the list,
I think it will be cleaner to have this in a separate API call. Even if this means another request to the server.
(Later, if we want to optimize, we can include this information in the response to the "insert item".)

The code in `lib/D2/Ajax.pm` implementing the back-end of the `GET` call to
fetch information of a single item.

```perl
get '/api/v2/item/:id' => sub {
    my $id = param('id');

    my $items = _mongodb('items');
    my $data = $items->find_one({ _id => MongoDB::OID->new($id) });
    my $json = JSON::MaybeXS->new;
    $json->convert_blessed(1);
    return $json->encode( { item =>  $data } );
};
```

The corresponding tests in `t/v2.t`

First we call the GET request with an ID number that does not exist
in the database to see what will be the response:

```perl
    my $get_item_0 =  $test->request( GET '/api/v2/item/12345' );
    my $item_0 = decode_json($get_item_0->content);
    is $item_0->{item}, undef;
```

Then we fetch the item based on the OID we've received in a request to
get all the existing items. The resulting data is then compared
to the data retrieved with the "/items" route.

```perl
    my $get_item_1 =  $test->request( GET '/api/v2/item/' . $items1->{items}[0]{_id}{'$oid'});
    my $item_1 = decode_json($get_item_1->content);
    is_deeply $item_1->{item}, $items1->{items}[0];
```

[commit: Fetch information on individual element - backend code ](https://github.com/szabgab/D2-Ajax/commit/786a14ae55f814b49a8c60c2b8bb0ecf1884095f)

## Include the OID in the reply to the insert call

Before I could go back working on the client, I had to make another change to the server. When we insert a new item,
the server sends a reply, but earlier it only included the corrected (!) text of the item and not the id.
I am not even sure why did we need the text there, but we definitely need the id now.

I could achieve that by changing the `post '/api/v2/item' => sub {` route to have
the following:

```perl
    my $obj = $items->insert({
        text => $text,
        date => DateTime::Tiny->now,
    });
    my $json = JSON::MaybeXS->new;
    $json->convert_blessed(1);
    return $json->encode( { ok => 1, text => $text, id => $obj->to_string } );
```

The `insert` method of MongoDB returns an OID object representing the id
that was inserted. We can use the `to_string` method of this object
to get the ID in string format.

The corresponding tests also had to change.

Because we can't know what the id is going to be, we will need to make our test case a bit more flexible.
The `is_deeply` function provided by Test::More does not allow more flexibility, but the corresponding
`cmp_deeply` function of [Test::Deep](https://metacpan.org/pod/Test::Deep) does.

So we load Test::Deep:

```perl
use Test::Deep;
```

Create a regex matching a stringified OID:

```perl
my  $OID = re('^[0-9a-f]{24}$');
```

and then use `cmp_deeply` to compare the received hash with one we are expecting:

```perl
cmp_deeply decode_json($res->content), { ok => 1, text  => 'First Thing to do', id => $OID };
```

[commit08include the oid in the reply to the insert call](https://github.com/szabgab/D2-Ajax/commit/7d4b302d9e81dee5356830e612928ca8b80bd51f)

## Front-End: insert single element into the list without full reload

Now that we have a back-end part finished, we can turn our attention to the front-end again and add a function called `get_item`
that fetches the information of a single item identified by its OID, adds the returned data to the list of `items` and calls
the `show_items` function to display the data.

```javascript
function get_item(id) {
    jQuery.get('http://127.0.0.1:5000/api/v2/item/' + id , function(data) {
        items["items"].push(data["item"]);
        show_items();
    });
}
```

We call this function once we received the confirmation from the server that the item was saved in the database.

```javascript
  get_item(data["id"]);
```

[commit: insert single element into the list, no full reload](https://github.com/szabgab/D2-Ajax/commit/23ddc21281bab629ed1118e8a5ca260ed4aca3f3)

## Remove deleted item

Before ending this article, let's add another change. When the user clicks on the [x] do delete an item, we send
and Ajax request to the server to delete the item from the database, clear the list of items and reload the whole
list again from the server. Here to we can make an improvement and we can remove the item from
the client by ourself.

For this, upon receiving confirmation that the item was deleted from the database on the server, we go over
all the items in our global variable `items` an remove the one with the same ID number:

```javascript
   var j;
   for ( j = 0; j < items["items"].length; j++) {
       if (items["items"][j]["_id"]["$oid"] === id) {
           items["items"].splice(j, 1)
           break;
       }
   }
```

[commit: remove deleted item](https://github.com/szabgab/D2-Ajax/commit/3e4d782ac76ef1d86386069d9b97c79ef7c7e254)

