---
title: "Add and retrieve items - MongoDB, Dancer and Testing!"
timestamp: 2016-05-16T22:50:01
tags:
  - MongoDB
  - Dancer2
  - config
  - POST
published: true
books:
  - dancer2
author: szabgab
archive: true
---


Now that we have the basics, it might be time to connect to a database, add items to it and fetch the items we have added.
We are going to use MongoDB as our database. In order to use that you'll need to install the
[MongoDB](https://metacpan.org/pod/MongoDB) driver.

This process will require several steps.


## Add an item in a POST route

Let's start with a route that accept a string and adds it to the database.

First of all we put the `use MongoDB ();` statement to the beginning of the file.
It will be loaded at compile time anyway. Unless we want to invest in lazy-loading,
it is better to put all the use-statements to the top.

We use a `POST` request here, that's probably better when you try to store data.
We are expecting the user to send the data in the 'text' field.
The first thing is some minor data sanitization and input checking. Actually these are quite
big words for what we actually do here:

We remove any leading and trailing spaces and then check if the resulting string is empty
we return a JSON with an error message.


Then we connect to the database server and then to the database called 'd2-ajax', and to a collection called 'items'.
We insert the data, and return a json indication success and containing the string we actually
added to the database. That is the original string without the leading and trailing spaces.

See the [getting started with MongoDB](/getting-started-with-mongodb-using-perl-insert-and-update)
article for a more detailed explanation.

```perl
use MongoDB ();

post '/api/v2/item' => sub {
    my $text = param('text') // '';
    $text =~ s/^\s+|\s+$//g;
    if ($text eq '') {
        return to_json { error => 'No text provided' };
    }

    my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    my $db   = $client->get_database( 'd2-ajax' );
    my $items = $db->get_collection('items');
    $items->insert({
        text => $text,
    });
    return to_json { ok => 1, text => $text };
};
```

Now that we have the route we should try to test it.

## Testing adding item

```perl
use JSON::MaybeXS qw(decode_json);

subtest v2_items => sub {
    plan tests => 4;

    my $app = D2::Ajax->to_app;

    my $test = Plack::Test->create($app);

    my $res  = $test->request( POST '/api/v2/item', {text => 'First Thing to do' } );
    ok $res->is_success, '[POST /] successful';
    is_deeply decode_json($res->content), { ok => 1, text  => 'First Thing to do' };
    is $res->header('Content-Type'), 'application/json';
    is $res->header('Access-Control-Allow-Origin'), '*';
};
```

This test is quite similar to the earlier test, except we send a `POST` request
passing the parameters as a reference to hash, and when we receive the response, then
instead of comparing the resulting stringified JSON to the expected string we first decode
the JSON using the `decode_json` function. Then we compare the resulting hash reference
to an expected hash reference using the `is_deeply` function.

We need to this because now because the resulting has now has two keys and two values and the
order in which they will stringified, and so the stringified representation of the result can
change between runs. So we had to convert the result to a hash and compare it that way.

We can run the test and it will show that everything is ok.

However, it does not check if the data is really entered the database.

Let's do that manually. We can run the `mongo` client on the command line and check
the content of the 'items' collection of the d2-ajax database:

```
$ mongo
(mongod-3.0.1) test> use d2-ajax
switched to db d2-ajax
(mongod-3.0.1) d2-ajax> db.items.find()
{
  "_id": ObjectId("55671d33a11460085a6cd701"),
  "text": "First Thing to do"
}
Fetched 1 record(s) in 2ms
```

Of course if we run the test a second time we'll see two entries that only differ in the ObjectId.

We have a few other problems as well.

How will we be able to check automatically if we indeed added the text to the database?
How will we avoid getting duplicates if we run the test again?
What will happen if we launch the application and try to access it from our Ajax-based web page?
Will we see the entries from the tests?

Anyway, let's [commit](https://github.com/szabgab/D2-Ajax/commit/8f1b462ad5d03692f50fc4022d57262ed4ceca72)
our changes before we tackle these issues.

## Use separate database for testing

In order to be able to use a different database for development (e.g. from the web pages), for testing and
later for production, we'd better move the name of the database to the configuration file `config.yml`. 
Then it will be easier to use a different database for testing.

So we edit `config.yml` and add the following entry:

```
app:
  mongodb: d2-ajax
```

We'll be able to access this data using the `config->{app}{mongodb}` expression.

So we also change the route in the `lib/D2/Ajax.pm` file to get the name of the database
from the configuration file:

```perl
    my $db   = $client->get_database( config->{app}{mongodb} );
```

The question then how can we override this for the tests. We could add
an entry to the `environment/test.yml` that we have [just created](/silencing-the-dancer-tests),
but that would mean if we run the test in parallel (two people on the same machine or even the same person
but two separate tests scripts), then they will use the same database. That will lead to very hard to debug conflicts.

Instead of that, we can create a database for each test execution and drop it when the test has finished.

We can add the following code to the subtest where we add items to the database:

```perl
    my $db_name = 'd2-ajax-' . $$ . '-' . time;
    diag $db_name;
    D2::Ajax->config->{app}{mongodb} = $db_name;
```

If we run the test now, it will print the name of the database which is created
from the current process-id and current timestamp and then use that database.

When I ran the tests it showed 'd2-ajax-2217-1432822679' so I could then check
manually if the data was inserted as expected.
In the end I even called `db.dropDatabase()` to drop the database.


$ mongo
(mongod-3.0.1) test> use d2-ajax-2217-1432822679
switched to db d2-ajax-2217-1432822679
(mongod-3.0.1) d2-ajax-2217-1432822679> db.items.find()
{
  "_id": ObjectId("55672397a1146008a90a5d51"),
  "text": "First Thing to do"
}
Fetched 1 record(s) in 3ms
air(mongod-3.0.1) d2-ajax-2217-1432822679> db.dropDatabase()
{
  "dropped": "d2-ajax-2217-1432822679",
  "ok": 1
}
```

So we are already using a separate database but we still need to be able to
automatically check if it received the data as expected and we still
need to drop the database automatically.

## Drop database automatically

For this we need to access the database from the test script so we load
MongoDB at the beginning of the script and at the end of the subtest we
connect to it and drop it:


```perl
use MongoDB ();
```


```perl
my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $db   = $client->get_database( $db_name );
$db->drop;
```

If we run the tests now they will pass and we won't see any new database in
MongoDB. We can even remove that `diag` call that shows the name of
the database.

[commit](https://github.com/szabgab/D2-Ajax/commit/93b9d6296fe002ba5d8011aa679e411958a6904e)

## Check if the insert worked

Now we should create some way to check if the insert worked as expected. We can do it in two major ways.

The so called "white-box approach" would be to have the test script access the database and fetch the data.
That would be useful, if we had to locate some bug in the code inserting the data, but at this point
I feel it would be a waste of energy.

Instead of that we are going with the so called "black-box approach" when we only test the application
using its API. For that, of course, we need to add an API call that allows us to fetch the items.

## Fetch all the items

For this to work we need to load a module to handle [JSON](/json):

```perl
use JSON::MaybeXS;
```

and then we have this code:

```perl
get '/api/v2/items' => sub {
    my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    my $db   = $client->get_database( config->{app}{mongodb} );
    my $items = $db->get_collection('items');

    my @data =  $items->find->all;
    my $json = JSON::MaybeXS->new;
    $json->convert_blessed(1);
    return $json->encode( { items =>  \@data } );
};
```

The first 3 lines are the same as in the previous route in which we inserted the item into
the database. We'll have to factor this out later to avoid this duplication.
For now we need it here to get access to the 'items' collection.

`$items->find</hl returns an iterator, calling `all` on it will return an array
of all the items. We need to convert this to JSON and send it back, however by default the
functions that encode data structures to JSON strings will not handle blessed objects.
That's why we had to load a separate module and we have to turn on the `convert_blessed`
attribute.

Now that we have an API call to fetch the list of items we can use that to test if 
there is exactly one inserted element, and if the 'text' of that element is the same as
the string we inserted.

```perl
    my $get1  = $test->request( GET '/api/v2/items');
    my $items1 = decode_json($get1->content);
    is scalar @{$items1->{items}}, 1;
    is $items1->{items}[0]{text}, 'First Thing to do';
```

We also had to update the planned number of tests.

We can run the test scripts now and they will report that everything is fine.

[commit](https://github.com/szabgab/D2-Ajax/commit/802ed43b84dbc78114b8e9dc55e0e57e6de4ae0c)

With this we have finished the back-end part of adding items and retrieving them, but I think we
can add a few more tests.

## Add more tests

First we send in empty data in two ways.

```perl
    my $res2  = $test->request( POST '/api/v2/item', { text => '' } );
    is $res2->content, '{"error":"No text provided"}';

    my $res3  = $test->request( POST '/api/v2/item' );
    is $res3->content, '{"error":"No text provided"}';
```

Then we check that they had no effect on the content of the database:

```perl
    my $get3  = $test->request( GET '/api/v2/items');
    my $items3 = decode_json($get3->content);
    is scalar @{$items3->{items}}, 1;
    is $items3->{items}[0]{text}, 'First Thing to do';
```

Finally we send in another item with some extra spaces on both ends
and check if the spaces were removed from the ends (but not from the middle)
and that the database now has both items.

```perl
    my $res4  = $test->request( POST '/api/v2/item', { text => '  one more  ' });
    is_deeply decode_json($res4->content), { ok => 1, text => 'one more' };

    my $get4  = $test->request( GET '/api/v2/items');
    my $items4 = decode_json($get4->content);
    is scalar @{$items4->{items}}, 2;
    is $items4->{items}[0]{text}, 'First Thing to do';
    is $items4->{items}[1]{text}, 'one more';
```


[commit](https://github.com/szabgab/D2-Ajax/commit/fe1cdb3a8a1ad83a6df1a890596f83d7aaf21471)


