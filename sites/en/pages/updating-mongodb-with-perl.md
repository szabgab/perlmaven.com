---
title: "Updating MongoDB using Perl"
timestamp: 2015-05-18T10:30:01
tags:
  - MongoDB
  - update
  - delete
published: true
books:
  - mongodb
author: szabgab
---


Previously we started to build a [command line phonebook](/phonebook-with-mongodb-and-moo).
We could add new people with their phone number and list all of them
or a specific person.

Let's now see how can we update an entry.


We need some way to identify the document in the database we would like
to update.

First, given the name of he person, let's change the phone number:

At the top of our script we added a new attribute:

```perl
option update => (is => 'ro');
```

We expect the user to run the script:

```
perl phonebook.pl --update --name Foo --phone 789
```

meaning we would like to update the phone number of Foo to be 789.


The code that implements the actual change looks like this:

```perl
    } elsif ($self->update) {
        die "--name is needed" if not $self->name;
        die "--phone is needed" if not $self->phone;

        $people_coll->update(
            { name => $self->name },
            { '$set' => { phone => $self->phone }},
        );
    }
```

After 2 lines of very basic input validation we call the
`update` method on the **collection**. It receives
two hash references as parameters. The first one selects the
documents that need to be updated.
`{ name => $self->name }` means to select the document
with the given name.

The second has tells MongoDB what changes to make. In our case
we use the `$set` operator that will set the phone field
to the new value. (The leading $ sign is part of the dialect of
MongoDB.)

That's it.

## Duplicate people

By default MongoDB does not enforce uniqueness on the documents,
so we can add several people called Borg:

```
$ perl phonebook.pl --add --name Borg --phone 123
$ perl phonebook.pl --add --name Borg --phone 456
$ perl phonebook.pl --add --name Borg --phone 789
$ perl phonebook.pl --list --name Borg
Borg  123
Borg  456
Borg  789
```

In general this is good, as we might have several friends with the
exact same name.
There is a problem with this though.
First of all, when we list the information about Borg it will not be
clear which one is which. We'll deal with this later.

First lets' see what happens when we try to change the phone of Borg:

```
$ perl phonebook.pl --update --name Borg --phone 1111
$ perl phonebook.pl --list --name Borg
Borg  1111
Borg  456
Borg  789
```

By default, the `update` method of MongoDB will only change one
document. The first one it finds. In many cases this is the correct behavior,
but if we would like to change the phone numbers of all the Borgs we need
to tell that to MongoDB.

The `update` method can get a third reference to a hash with options.
Setting the `multiple` option to be true will tell MongoDB to update all
the documents that match the criteria.

```perl
        $people_coll->update(
            { name => $self->name },
            { '$set' => { phone => $self->phone }},
            { multiple => 1 },
        );
```

See also the MongoDB reference about
[update](http://docs.mongodb.org/manual/reference/method/db.collection.update/)
and the Perl documentation of
[MongoDB::Collection](https://metacpan.org/pod/MongoDB::Collection)

```
$ perl phonebook.pl --update --name Borg --phone 2223
$ perl phonebook.pl --list --name Borg
Borg  2223
Borg  2223
Borg  2223
```

That's wonderful, except that now we have really no way to differentiate among the Borgs.

Let's start from scratch.

## Delete a document

MongoDB provide the `remove` method. It accepts a hash reference
describing one or more documents (just as in the case of `update`)
and removes **all** matches.


```perl
    } elsif ($self->delete) {
        die "--name is needed" if not $self->name;
        $people_coll->remove({ name => $self->name });
```

We also need to add the attribute at the top:

```perl
option delete => (is => 'ro');
```


```
$ perl phonebook.pl --delete --name Borg
$ perl phonebook.pl --list --name Borg
```

## Exercise

Now that we got rid of the old Borgs, we can change the script
to let the user supply a nickname as well. In the listing
we should also mention the nickname and then we can also
change the part of the `update` to rely on both the
name and the nickname.

The latest version of our script can be found in
[GitHub](https://github.com/PerlMaven/mongodb-update-phone).
Please fork it, and send a pull request with your solution.




