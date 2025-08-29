---
title: "List authors where the PAUSEID starts with a given letter"
timestamp: 2018-04-17T12:30:01
tags:
  - SCO
  - Template::Toolkit
  - List::MoreUtils
  - natatime
published: true
author: szabgab
---


So far we've copied the [look-and-feel from search.cpan.org](/create-the-sco-look-and-feel),
added a few [static pages](/add-another-static-page), and added the look-and-feel to
[the 404 page](/add-404-not-found-page).


## update the README file

The next [commit](https://github.com/szabgab/MetaCPAN-SCO/commit/9852bd4188fe9bcff0c8e5b0fd9fee36264d5c2d) was just to
improve the content of the [README](https://github.com/szabgab/MetaCPAN-SCO/blob/9852bd4188fe9bcff0c8e5b0fd9fee36264d5c2d/README)
file in the root of the project. It is displayed on the main page of the [GitHub project](https://github.com/szabgab/MetaCPAN-SCO)
so it should contain information that is useful to potential contributors. I started to describe the development environemt.

## Add main authors page

The main [authors](http://search.cpan.org/author/) page looks like a static page, so
I add that too taking the same steps as for the [feedback page](/add-another-static-page)
and arriving to this
[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/d3e1400cb82c88548efe6ecec1d15d797dbc177a).

## list authors where the PAUSEID starts with a given letter

As I looked at the central authors page at [http://search.cpan.org/author/](http://search.cpan.org/author/) and clicked on the first letter
it turned out to load the same URL, but with a the letter passed after the question mark:
[http://search.cpan.org/author/?A](http://search.cpan.org/author/?A).
This is the part that is usually called the **QUERY_STRING**

That means these pages will be served by the same entry that serves the main authors page. After all, they have the same `path_info`.
Earlier we had this code in the `run` method of
[lib/MetaCPAN/SCO.pm](https://github.com/szabgab/MetaCPAN-SCO/blob/d7c0500cf1f5ea66670a9178be60766a68bc425b/lib/MetaCPAN/SCO.pm):

```perl
if ($request->path_info =~ m{^/author/?$}) {
    return template('author');
}
```

This is what we are going to change now. (Oh and BTW, the `?` at the end of that regular expression is there so it will match both
`/author` and `/author/`. Nothing to do with he `?` that might be in the URL.)


The [Plack::Request](https://metacpan.org/pod/Plack::Request) object we already used to fetch the `path_info` also
provides a method called `query_string` that will return the whole string after the `?` in the URL.
Then, if there was nothing in the  `$query_sting`,  we can return the main page immediately.

```perl
if ($request->path_info =~ m{^/author/?$}) {
    my $query_string = $request->query_string;
    return template('author') if not $query_string;
}
```

I [checked](/search-cpan-org-authors-and-recent) the real search.cpan.org site and found that this URL
will disregard any characters provided after the first character and that it serves the list both if the first character was lower-case
and when it was upper-case. I don't think this is really a good idea, it would be probably better to have pages with distinctive and
unique URLs for each data set. So in the future I thinks any of the pages /authors?ABC,   /authors/?a, /authors/?aXz should redirect to
a page like /authors/A. For now, let's implement what search.cpan.org has.

### Retreive the list of authors

The next step was to extract the first character, convert it to upper-case, and retreive the list of authors with a PAUSE ID
starting with that charcter.
In an attempt to make the code cleaner, I put the code that retreives from the MetaCPAN API into a subroutine called
`authors_starting_by` that will receive the upper-case latter and return a reference to a list with the necessary
information.

```perl
    my $lead = substr $query_string, 0, 1;
    my $authors = authors_starting_by(uc $lead);
```

In order to implement the `authors_starting_by` first I had to research the MetaCPAN API a bit. I got a few interesting requests
lined up that I can execute with `curl`:

```
    curl http://api.metacpan.org/v0/author/_search?size=10
    curl 'http://api.metacpan.org/v0/author/_search?q=author._id:S*&size=10'
    curl 'http://api.metacpan.org/v0/author/_search?size=10&fields=name'
    curl 'http://api.metacpan.org/v0/author/_search?q=author._id:S*&size=10&fields=name'

    or maybe use fetch to download and keep the full list locally:
    http://api.metacpan.org/v0/author/_search?pretty=true&q=*&size=100000 (from https://github.com/CPAN-API/cpan-api/wiki/API-docs )
```


```perl
sub authors_starting_by {
   my ($char) = @_;

   my @authors = [];
   if ($char =~ /[A-Z]/) {
       eval {
           my $json = get "http://api.metacpan.org/v0/author/_search?q=author._id:$char*&size=5000&fields=name";
           my $data = from_json $json;
           @authors =
               sort { $a->{id} cmp $b->{id} }
               map { { id => $_->{_id}, name => $_->{fields}{name} } } @{ $data->{hits}{hits} };
           1;
       } or do {
           my $err = $@  // 'Unknown error';
           warn $err if $err;
       };
   }
   return \@authors;
}
```

The JSON data returned by the MetaCPAN API server contains a hash. Two levels deep in that hash (both with the key 'hits')
we receive an array of the actual results. From that we extract the '_id' field and the 'name'
field that we requested specifically for us. This is probably far from the optimal way to fetch this data, but this worked,
and at this point I was more interested in getting something to work that to be optimal. If the applications starts to
take shape, I am sure there will be a few other people looking at the code and making suggestions. That one of the advantags
of writing Open Source code. Even if others won't look at it, either because of lack of interest or if you work on a similar
project which is closed source, you can still revisit the code and make improvements.
By that time we'll probably have much better understanding of the API and it will be easier to make improvement.

On the other hand if we try to make this absolutely perfect, we'll be stuck here for quite some time and we'll run out
of enthusiasm, or, if this is a closed source project, we might run out of budget.

So we used the `map` two extract the '_id', and 'name' fields, the latter of which came inside an extra layer of hash
with a key 'fields'. Then we took the resultng list of small hashes and sorted them according to their ID.
That's how they were presented on the original page on search.cpan.org.

The eval-block you see here might be strange.

Then came the question, how to turn this list into groups of 4 as they are represented on [search.cpan.org](http://search.cpan.org/author/?A)

Me, being the not sufficiently lazy programmer, decided to convert the array into an array of arrays, where each internal array will contain 4 elements
from the original array. It is quite an interesting problem for what there is an excellent solution in 
[List::MoreUtils](http://metacpan.org/pod/List::MoreUtils) called `natatime`.
Given a number n and a list, it returns an iterator. For each call, the iterator will return the next n element from the original list
until the it is exhausted. That's how we convert our array reference `$authors` into the array of arrays called `@table`.

Finally we call the `template() function and pass the `@table` array to the `authors` key.


### The template

The last thing we need here is to add the appropriate code to the template in
[tt/author.tt](https://github.com/szabgab/MetaCPAN-SCO/blob/d7c0500cf1f5ea66670a9178be60766a68bc425b/tt/author.tt):

```
<table width="100%">
<% FOR row IN authors %>
  <tr class="<% IF loop.index % 2 %>s<% ELSE %>r<% END %>">
     <% FOR a IN row %>
        <td>
          <a href="/~<% a.id %>/">**<% a.id %>**</a><br/><small><% a.name %></small>
        </td>
     <% END %>
  </tr>
<% END %>
</table>
```

Template::Toolkit provides the option to iterate over an array using the `FOR ... IN ...`  construct.
In our case the array, or rather the array reference arrives as the value of the `authors` key.
Each element represents a row that we need to display, that's why I called the iterator variable 'row'.
That variable itself contains a reference to an array, so internally we use another `FOR ... IN ...` loop
to iterate over each author (using an unfortunately undescriptive variable called 'a'). Each such variable
is a hash reference representing an author with two fields: `a.id` and `a.name`. We build
the link from that:

```
     <a href="/~<% a.id %>/">**<% a.id %>**</a><br/><small><% a.name %></small>
```

One more thing, you might have noticed. The lines displayed by search.cpan.org have alternating color.
The alternation is provided by two class-es: `class="s"` and `class="r"`

That's quite easy to create using Template::Toolkit: Inside every `FOR`-loop we can access
the current index of the loop via the `loop.index` variable provided by TT. We can then compute the
modulus 2 of that number which will be 0 and 1 alternating. Based on that value we can pick which class
to set for the current row:

```
  <tr class="<% IF loop.index % 2 %>s<% ELSE %>r<% END %>">
``` 

That brought us to the next
[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/d7c0500cf1f5ea66670a9178be60766a68bc425b)

```
$ git add .
$ git commit -m "list authors where the PAUSEID starts with a given letter"
```


