---
title: "Add and retrieve elements - jQuery + Ajax"
timestamp: 2016-07-02T10:10:01
tags:
  - jQuery
  - Ajax
  - GET
  - POST
published: true
books:
  - dancer2
author: szabgab
archive: true
---


In the previous article we have implemented the Dancer routes to [Add item to MongoDB and retrieve them](/add-item-to-mongodb-database). We can now add the front-end code using HTML, jQuery and Ajax calls.



## HTML form and div

The first thing was to add a new HTML form to `client/v2.html` that will be used to enter new items. This is actually identical in structure to the form we already had: it has a text input box and a submit button. We also added a new `div` element we are going to fill with the list of elements fetched from the database.


```html
<hr>

<form>
<input name="text" id="text">
<input type="submit" id="add-item" value="Add item">
</form>

<div id="items"></div>
```

## Showing the items

We will want to show the existing items in two cases. When we load the page first, and after every
time we add a new item. (Actually, later we might also want to add the capability to remove an item
and we'll want to show the updated list after that too.)

```javascript
function show_items() {
    jQuery.get('http://127.0.0.1:5000/api/v2/items', function(data) {
        var i, html;
        html  = '<ul>';
        console.log(data);
        for (i = 0; i < data["items"].length; i++) {
            html += '<li>' + data["items"][i]["text"] + '</li>';
        }
        html += '</ul>';
        $("#items").html(html);
    });
}
```

First we send a GET request to the `/api/v2/items` end-point of the API we have created
and tested in the previous article. This looks the same as the GET request we used to fetch the
greeting. When the response arrives it will call the function supplied and pass, the already
parsed data. We sent a hash reference with a key "items" and a value which is an array of hashes.

In Perl the data structure we sent looked like this:

```perl
{
      'items' => [
        {
          '_id' => {
            '$oid' => '556d6735a11460452f6e7601'
          },
          'text' => 'First Thing to do'
        },
        {
          '_id' => {
            '$oid' => '556d6735a11460452f6e7602'
          },
          'text' => 'one more'
        }
      ]
    }
```

In this example we create the HTML manually by concatenating html tags. Later we'll switch to a templating
system. For now however we create a variable called `html` and then we loop through the elements
of the array we got via the `items` key. We use the "text" field to build an unordered list `ul`.

At the end, once the html is ready, we just inject the HTML in the DOM to the element with the id "items".
Just as we did with the greeting [at the beginning](/ajax-and-dancer2).

We also need to call the `show_items()` function somewhere in the document ready call:

```javascript
$(document).ready(function() {
    ...
    show_items();
    ...
})
```

So we could now display items if there were any items in the database, and if you'd like to see
this working, you could change the [tests from the previous episode](/add-item-to-mongodb-database)
to use the development database and not to delete the content.

Or you can just go on and add the JavaScript code that will insert a new item:

## Add a new item

We need to add this code to the document ready code as we need to make sure the "add-item"  element
is already loaded in the page before we can attach an action to it. This is the same as we did
when we [attached a click event handler](/dancer2-ajax-reverse-echo) to the button
reversing strings. Here too we grab a the content of the input box, but this time, instead of sending
a `GET` request, we are going to send a `POST` request. If for no other reasons, because
that's what the [API of the back-end requires](/add-item-to-mongodb-database).

A post request is slightly different from a get request. Instead of concatenating the parameters
at the end of the URL, we pass them as an additional parameter in the form of a JavaScript object:
`{ text: text }`.

The response handler function expects an object (that used to be a hash when it was still in Perl
on the server). In he object there is going to be either an "error" or and "ok" key.
In the case of the "error" key we'll want to display its content. This allows the back-end to send any
error message. If the back-end sent "ok", we grab the content of the "text" field and display it.
If you recall, we had the API send back the actual string that was inserted, that should be the same
as the string sent by the client, but without the leading and trailing spaces.

Once we are done with this we call the `show_items()` function that we have seen earlier.
It will send a separate Ajax request to fetch the current list of items and display them.

```javascript
    $("#add-item").click(function() {
        var text = $("#text").val();
        jQuery.post('http://127.0.0.1:5000/api/v2/item', { text: text } , function(data) {
            console.log(data);
            if (data["error"]) {
                $("#msg").html('Error: ' + data["error"]);
            }
            if (data["ok"]) {
                $("#msg").html('Item ' + data["text"] + ' added');
            }
            show_items();

        });
       return false;
    });
```

In order to test the client you'll need to have the server running `plackup -R lib/ bin/app.psgi`
and you'll need to open `t/v2.html` in your browser.

[commit](https://github.com/szabgab/D2-Ajax/commit/0198a126d364a0d1273460c52e02cb4b540431ce)


## Further thoughts

There could be a number of other ways to implement this.
For example, we could have the the call that inserts the "item" also fetch the current list
and send it back immediately. That would save us an Ajax call which means faster response and less
load on the server, but then the API is a bit more mixed up. I'd probably not reject this idea,
but I'd postpone it till a point when I am convinced this change has a substantial impact on performance.
Even then, I'd probably have a separate API call, or would include a parameter in the "item" API call
indicating if the user also wants to fetch the list or not.

An even more interesting solution could be to not fetch the list at all, and have the client add the
item to the list it keeps. That allows a much more "responsive" application, after all we won't need
to wait for the list to arrive and we won't have to rebuild the whole list. The problem might be if
there are other users or tools that might update the list on the server. In that case the list
in the client might not be in sync with the list on the server. For that case we'll have to implement
some kind of notification system so the server can let the client know when something has changed there.

