---
title: "Add a date stamp to the items in the database"
timestamp: 2016-09-17T07:30:01
tags:
  - DateTime::Tiny
  - TO_JSON
published: true
books:
  - dancer2
  - javascript
author: szabgab
archive: true
---


In order to expand the example, first we will add a timestamp to each item as it
is inserted in the database and list the date on the web page when listing the items.



## Adding timestamp to item (insert)

MongoDB can automatically convert [DateTime](https://metacpan.org/pod/DateTime) objects to its own
native Date data-type, but DateTime is big and slow. A much smaller and faster
module that works well in a lot of cases is [DataTime::Tiny](https://metacpan.org/pod/DateTime::Tiny).
(According to the [MongoDB](https://metacpan.org/pod/distribution/MongoDB/lib/MongoDB/DataTypes.pod) documentation it can 10 times faster)
MongoDB can convert DateTime::Tiny objects to its own format, and if we configure
it properly it will also convert its own Date formate to a DateTime::Tiny object
when we retrieve the data.

The first thing is to add

```perl
'DateTime::Tiny' => 0,
```

to Makefile.PL to make sure the module is installed..

Then we load DateTime::Tiny

```perl
use DateTime::Tiny;
```


The `post '/api/v2/item'` route, where we insert the element in the database,
also gets a new line:

```perl
date => DateTime::Tiny->now,
```

We create a new DateTime::Tiny object with the current timestamp and we immediately
include it in structure that gets inserted into the database.

```perl
post '/api/v2/item' => sub {
    my $text = param('text') // '';
    $text =~ s/^\s+|\s+$//g;
    if ($text eq '') {
        return to_json { error => 'No text provided' };
    }

    my $items = _mongodb('items');
    $items->insert({
        text => $text,
        date => DateTime::Tiny->now,
    });
    return to_json { ok => 1, text => $text };
};
```

With this we can already try the application manually and observe the data
inserted to the database having a new field.

Make sure the server runs (`plackup -R lib bin/app.psgi`)
and visit `file:///Users/gabor/work/D2-Ajax/client/v2.html`

I typed in "new item" and clicked on the "Add item" button.
I was surprised to see that it confirmed "Item new item added" , but have not
showed the list of items. (We'll see why in a second.) For now we can just
switch to the command line, launch the command line mongo client,
connect to the "d2-ajax" database and list the items:

```
$ mongo
test> use d2-ajax
d2-ajax> db.items.find()
{
  "_id": ObjectId("557593b5a114607aa9188b91"),
  "date": ISODate("2015-06-08T16:08:05Z"),
  "text": "new item"
}
Fetched 1 record(s) in 3ms
```

As you can see we have a single item (I've deleted the other items earlier),
and the we have, has a key "date" with a value of ISODate type.


## Route exception

Let's now see why have the application not display the list. We can switch to the terminal
where we ran `plackup` and we can see that it show an error message:

```
Route exception: encountered object '2015-06-08T16:08:05',
but neither allow_blessed, convert_blessed nor allow_tags settings are enabled
(or TO_JSON/FREEZE method missing
```

The problem seems to be that when we would like to retrieve the data and send
it back to the client as JSON, the JSON-ification fails and throws an exception.

## Run the tests

In order to understand what's the problem with the web application, why
does it not show the list, we can also run the test:

```
$ perl Makefile.PL
$ make
$ make test

t/v2.t ............... 1/4 [D2::Ajax:31818] error @2015-06-08 16:16:58> Route exception: encountered object '2015-06-08T16:16:57', but neither allow_blessed, convert_blessed nor allow_tags settings are enabled (or TO_JSON/FREEZE method missing) at /Users/gabor/work/D2-Ajax/blib/lib/D2/Ajax.pm line 71. in /Users/gabor/perl5/perlbrew/perls/perl-5.22.0_WITH_THREADS/lib/site_perl/5.22.0/Return/MultiLevel.pm l. 36
malformed JSON string, neither tag, array, object, number, string or atom, at character offset 0 (before "<!DOCTYPE html PUBLI...") at t/v2.t line 67.
    # Child (v2_items) exited without calling finalize()
```

The error is similar. Line 71 of D2/Ajax.pm is

```perl
return $json->encode( { items =>  \@data } );
```

The problem is when we convert the date object from perl to JSON.

Because the previous line is

```perl
$json->convert_blessed(1);
```

it seems the problem is that the object representing the date does not have a `TO_JSON` method.

But which object represents it?
In order to find that out I've added

```perl
$_->{date} = ref($_->{date}) for @data;
```

to the `get '/api/v2/items' => sub {` route to convert each object representing the date
to its type. If I run the test now `prove -lv t/v2.t` they will all pass and I won't learn
anything from it, but if I also change the test script a bit adding

```perl
diag explain $items1;
```

to the place where create `$items1` it will print me the whole returned list:

```
$ prove -vl t/v2.t

ok 1 - v2_greeting
ok 2 - v2_reverse
    # {
    #   'items' => [
    #     {
    #       '_id' => {
    #         '$oid' => '5575974aa114607c78523711'
    #       },
    #       'date' => 'DateTime',
    #       'text' => 'First Thing to do'
    #     }
    #   ]
    # }
ok 3 - v2_items
ok 4 - no warnings
ok
All tests successful.
Files=1, Tests=4,  2 wallclock secs ( 0.04 usr  0.01 sys +  1.45 cusr  0.12 csys =  1.62 CPU)
Result: PASS
```

So it is a DateTime object even though we wanted to use a DateTime::Tiny object.

## Tell MongoDB to use DateTime::Tiny

We need to configure MongoDB to use DateTime::Tiny as its default format when converting
the internal ISODate object the perl-ish object. We can do this by adding the following line
to the `_mongodb` function:

```perl
$client->dt_type( 'DateTime::Tiny' );
```

to have:

```perl
sub _mongodb {
    my ($collection) = @_;

    my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    $client->dt_type( 'DateTime::Tiny' );
    my $db   = $client->get_database( config->{app}{mongodb} );
    return $db->get_collection($collection);
}
```

If we run the test  again we get:

```
$ prove -vl t/v2.t

ok 1 - v2_greeting
ok 2 - v2_reverse
    # {
    #   'items' => [
    #     {
    #       '_id' => {
    #         '$oid' => '557598d0a114607c945d5021'
    #       },
    #       'date' => 'DateTime::Tiny',
    #       'text' => 'First Thing to do'
    #     }
    #   ]
    # }
ok 3 - v2_items
ok 4 - no warnings
ok
All tests successful.
Files=1, Tests=4,  3 wallclock secs ( 0.05 usr  0.01 sys +  1.52 cusr  0.15 csys =  1.73 CPU)
Result: PASS
```

So it now creates a DateTime::Tiny object.

Let's remove the code converting the date to its `ref` and let's run the test again:

it blows up with the same error message as earlier:

```
[D2::Ajax:31902] error @2015-06-08 16:31:09> Route exception: encountered object '2015-06-08T16:31:09', but neither allow_blessed, convert_blessed nor allow_tags settings are enabled (or TO_JSON/FREEZE method missing) at /Users/gabor/work/D2-Ajax/lib/D2/Ajax.pm line 72. in /Users/gabor/perl5/perlbrew/perls/perl-5.22.0_WITH_THREADS/lib/site_perl/5.22.0/Return/MultiLevel.pm l. 36
malformed JSON string, neither tag, array, object, number, string or atom, at character offset 0 (before "<!DOCTYPE html PUBLI...") at t/v2.t line 67.
```

but now we know the object that is missing the `TO_JSON` method is in the `DateTime::Tiny` class.

So we can add a TO_JSON function by ourself.
We can add the following line, right after the line where we load DateTime::Tiny.

```perl
sub DateTime::Tiny::TO_JSON { shift->as_string };
```

If we run the tests now we get:

```
$ prove -vl t/v2.t

ok 1 - v2_greeting
ok 2 - v2_reverse
    # {
    #   'items' => [
    #     {
    #       '_id' => {
    #         '$oid' => '557599a1a114607cad788481'
    #       },
    #       'date' => '2015-06-08T16:33:21',
    #       'text' => 'First Thing to do'
    #     }
    #   ]
    # }
ok 3 - v2_items
ok 4 - no warnings
ok
All tests successful.
Files=1, Tests=4,  2 wallclock secs ( 0.04 usr  0.00 sys +  1.52 cusr  0.14 csys =  1.70 CPU)
Result: PASS
```

So the test now passes and the "date" field contains a stringified version of the date.
We can comment out the call to print out the result:

```perl
diag explain $items1;
```

and instead of that we can add a single test that will check if the `date`
has the expected format.

```perl
like $items1->{items}[0]{date}, qr/^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d$/;
```

We could test if the time-stamp is more-or less the same time we ran the script,
but I did not want to invest energy in that. I trust that the MongoDB module and the DateTime::Tiny
module are properly tested.

[commit: Add a date stamp to the items in the database](https://github.com/szabgab/D2-Ajax/commit/7b33ea7e8e6368fa1a2d5c07acaa49f514f88651)

## Check in the browser

Now I could go back to the brower, reload the page and make sure I can see the listing of the "new item" I've added earlier.
I've also tried to add another item, cleverly called "other item". It showed up on the page as expected.


## Add date to the HTML page

It is quite simple. The `date` field is already included in the JSON sent to the client, I just had to add it to the template
that can be found in the `clients/v2.html`:

```
  <script id="show-items-template" type="text/x-handlebars-template">
  <ul>
  {{#each data.items}}
      <li>{{ text }} {{ date }} <button class="delete" data-id="{{ _id.$oid }}">x</a></li>
  {{/each}}
  </ul>
  </script>
```

Then reloading the web-page again it shows the dates:

<img src="/img/dancer2_ajax_list_with_date.png" />

in a rather unpleasant way.

We'll need to fix that later.


[commit: Add date to the HTML page](https://github.com/szabgab/D2-Ajax/commit/16dc0f811b11f05479184762f4e808053fcd7e14)
