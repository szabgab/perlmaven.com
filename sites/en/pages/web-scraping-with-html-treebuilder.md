---
title: "Web scraping with HTML::TreeBuilder"
timestamp: 2017-11-08T20:15:01
tags:
  - HTML::TreeBuilder
  - WWW::Gittip
published: true
author: szabgab
---


Recently I have been working on [WWW::Gittip](http://metacpan.org/pod/WWW::Gittip), the Perl implementation of the [Gittip API](https://www.gittip.com/).
There are a number of public API calls that return JSON. Some required a little extra thinking as they were using
[Basic Authentication without a challenge](/basic-authentication-without-a-challenge), but there are also requests I'd like to make
that don't have a public JSON end-point yet.

For example currently there is no way to fetch the list of members of a community.


Luckily there is an HTML page for each such community, for example this is the page of the [Perl community](https://www.gittip.com/for/perl/).

So in order to make it easy for others to fetch the list of community members we need to parse the HTML page and extract the information ourself.

<b>This article is originally from 2014. Since then Gittip was renamed to be Gratipay and in November 2017 it was shut down. Nevertheless the technique is still useful.</b>

If you look at the [Perl community page](https://www.gittip.com/for/perl/) you'll see it say the number of members (at the time of writing this it was 516),
and list 3 groups of the members. 12 members in each group.

The 3 groups can have some overlap. The left-most group shows the members as they joined Gittip, the right-most group shows the
members ordered by the sum they receive, and the middle group show them ordered by the sum they give.

In order to show more members we can click on the "more" button at the bottom. It will send a new request with
[?limit=24](https://www.gittip.com/for/perl/?limit=24) attached to the end of the URL. This time we'll see up to 24 members in
each one of the 3 groups.

We can edit the URL to increase the limit to the total number of members as shown in the center top of the page, but it will only show up to 100 members.

After searching a bit among the [tickets on GitHub](https://github.com/gittip/www.gittip.com) I found that the URL will also accept another parameter:
`offset=100` that tells the site how many members to skip before showing the members. So
[limit=100&offset=0](https://www.gittip.com/for/perl/?limit=100&offset=0) will show the first 100 members, and
[limit=100&offset=100](https://www.gittip.com/for/perl/?limit=100&offset=100) will show the second hundred members. If we increase the offset enough times, we can fetch
all the members. 3 Times.

But how are we going to extract the actual values from the HTML files?

For the sake of the example we are going to use the `get` function of [LWP::Simple](https://metacpan.org/pod/LWP::Simple)
to fetch the web pages, and [HTML::TeeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) to parse the HTML and extract the
information we need.

## Extracting the number of members

As we will want to know how many pages we need to fetch, we should start by extracting the number of members.
We create the `$url` from 3 parameters that are currently embedded in the code. A better solution might
let the user supply them. At least the name of the community.

`get` will fetch the HTML page.

At this point you might want to save the HTML page in a local file to make it easier to analyze it manually,
or you can visit the web site and click on the "view source" that is usually provided as a right-click on your mouse.

In order to be able to locate the required data programmatically, we need to find the HTML construct that wraps it.
Because we are looking for a very specific piece of data here I just manually searched the source for the value 516
(the number of members) and found the following snippet of HTML:

```

<div class="on-community">
    <h2 class="pad-sign">Perl</h2>
    <div class="number">516</div>
    <div class="unit pad-sign">members</div>
</div>

```

The value we are looking for is wrapped in a `div` element that has a `class="number"` attribute.

[HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) inherits from 
[HTML::Element](https://metacpan.org/pod/HTML::Element) which provides a very nice tool to search for
elements. We can call the `look_down` method and provide it a name of an attribute and the value of that attribute,
and in SCALAR context it will return the first element matching our definition.
(In LIST context it will return all the matching elements.)

`my $e = $tree->look_down('class', 'number');` will return the first element that has a `class` attribute
with the value "number". The return object in `$e` is a new [HTML::Element](https://metacpan.org/pod/HTML::Element) object.
It has a method called `as_text` that will return the content of the element after stripping away all the HTML.
In our case that will be the desired number.

```perl
use strict;
use warnings;
use 5.010;

use LWP::Simple qw(get);
use HTML::TreeBuilder 5 -weak;

my $name = 'perl';
my $limit = 100;
my $offset = 0;

my $url = "https://www.gittip.com/for/$name?limit=$limit&offset=$offset";
my $html = get $url;

my $tree = HTML::TreeBuilder->new;
$tree->parse($html);

my $e = $tree->look_down('class', 'number');
say $e->as_text;
```

The actual solution I used in WWW::Gittip was a bit more complex. At first I used `look_down` to find the 
`div` element that has a `class="on-community"`, and once that was found a new search on that
element found the right element.

```perl
my $cl = $tree->look_down('class', 'on-community');
my $n = $cl->look_down('class', 'number');
my $total = $n->as_text;

say $total;
```

Probably the implementation in WWW::Gittip should be updated.


## Fetching the members

Looking at the web page that [lists the a few members of the "Perl community"](https://www.gittip.com/for/perl/)
we can see that there is a title "NEW MEMBERS". In order to understand the layout of the underlying HTML we
look at the source of the HTML again and look for that string. I found the following HTML snippet:

```
<div id="leaderboard">

    <div class="people">
        <h2>New Members</h2>
        <ul class="group">
            
            <li>
                <a href="/dwierenga/" class="mini-user tip"
                data-tip="">
                    <span class="inner">
                        <span class="avatar"
                            style="background-image: url(\'https://avatars.githubusercontent.com/u/272648?s=128\')">
                        </span>
                        <span class="age">14 <span class="unit">hours</span></span>
                        <span class="name">dwierenga</span>
                    </span>
                </a>
            </li>
```

That looks quite clean. Searching for "TOP GIVERS" shows us that the HTML of the 3 groups is the same.
The are all `ul` elements inside `div` elements that are all in a `div` with `id="leaderboard"`.

We can start by locating the leaderboard using `my $leaderboard = $tree->look_down('id', 'leaderboard');`.
We are looking for an element with an attribute `id` that has the value `leaderboard`.

Once we found that we fetch the child-elements of this `div` using the `content_list`.
Each such child is one of the 3 groups. We iterate over the child elements using
`foreach my $ch ($leaderboard->content_list) {`

In every iteration first we fetch the title, which is wrapped in `h2` elements. In addition to the regular attributes of the HTML elements, 
[HTML::Element](https://metacpan.org/pod/HTML::Element) also allows us to search for pseudo-attributes. For
example we can it pretends as if there was an attribute called `_tag` with the value being the name of the tag.
`p, a, h1`, or in this case `h2`.

`my $h2 = $ch->look_down('_tag', 'h2');` searches staring from the current child of the the leaderboard and locates the
first `h2` element. `$h2->as_text</h2> returns the title.

As we would like to provide a relatively stable interface for our users, we cannot use this text "New Members" as the keys in our hash listing the users.
We need to have keys that can remain the same even if the title at the web site changes. So we created a mapping from actual titles to internal keys and
saved the mapping in the `%NAMES` hash. When we extract the title of the group we immediately map it to one of the internal names using
`my $type = $NAMES{ $h2->as_text };`.

At this point I ran the script and it threw an exception. Apparently the leaderboard has 4 children. The three groups we see and probably a 4th child
that is invisible. Maybe a mistake. In order to avoid the exception, in each iteration we check if we really received a proper element by
this code: `next if not defined $ch or ref($ch) ne 'HTML::Element';`

The actual members are listed in an `ul` element that has `class="group"`
We locate this element by using `my $group = $ch->look_down('class', 'group');`

Inside we have another call to `content_list` and another `look_down` to locate the name of the user.
We collect the names in little hashes. (Maybe we'll be able to add the amount they give or receive later on.)


```perl
use strict;
use warnings;
use 5.010;

use LWP::Simple qw(get);
use HTML::TreeBuilder 5 -weak;

my $name = 'perl';
my $limit = 100;
my $offset = 0;

my $url = "https://www.gittip.com/for/$name?limit=$limit&offset=$offset";
my $html = get $url;

my $tree = HTML::TreeBuilder->new;
$tree->parse($html);

my $total = $tree->look_down('class', 'number')->as_text;
say $total;


my %NAMES = (
    'New Members'   => 'new',
    'Top Givers'    => 'give',
    'Top Receivers' => 'receive',
);

my %members;

my $leaderboard = $tree->look_down('id', 'leaderboard');
foreach my $ch ($leaderboard->content_list) {
    next if not defined $ch or ref($ch) ne 'HTML::Element';
    # The page had 4 columns, one of them was empty.
    my $h2 = $ch->look_down('_tag', 'h2');
    my $type = $NAMES{ $h2->as_text };

    my $group = $ch->look_down('class', 'group');
    foreach my $member ($group->content_list) {
        next if not defined $member or ref($member) ne 'HTML::Element';
        # I think these are the anonymous members.

        my $n = $member->look_down('class', 'name');
        push @{ $members{$type} }, {
            name => $n->as_text,
        };
    }
}

use Data::Dumper;
print Dumper \%members;
```

## Paging

The above code will fetch the total number of members, and list the members from the first page. We now need to fetch the other
pages as well providing the correct `offset`. Then we can collect all the members.

In order to do this I wrapped most of the code in an infinite `while-loop`. The `$url` to be fetched is created inside this
loop, but the variable `$total` and `%members` are declared before that.

As the total is not supposed to change between the pages we will only fill it once in the first page. Hence we wrap the assignment in
an `if-conditional`

At the end of the loop we increment the offset and then quite the loop if the `$offset` has already passed the `$total`.

```perl
my $total;
my %members;
while (1) {
    my $url = "https://www.gittip.com/for/$name?limit=$limit&offset=$offset";
    ...

    if (not $total) {
        $total = $tree->look_down('class', 'number')->as_text;
        say $total;
    }
    ...

    $offset += $limit;
    if (not $total) {
        warn "Could not find total number of members\n";
        last;
    }
    last if $offset >= $total;
}
```

The full code looks like this:

```perl
use strict;
use warnings;
use 5.010;

use LWP::Simple qw(get);
use HTML::TreeBuilder 5 -weak;

my $name = 'perl';
my $limit = 100;
my $offset = 0;


my $total;
my %members;
while (1) {
    my $url = "https://www.gittip.com/for/$name?limit=$limit&offset=$offset";
    my $html = get $url;
    
    my $tree = HTML::TreeBuilder->new;
    $tree->parse($html);

    if (not $total) {
        $total = $tree->look_down('class', 'number')->as_text;
        say $total;
    }
    
    
    my %NAMES = (
        'New Members'   => 'new',
        'Top Givers'    => 'give',
        'Top Receivers' => 'receive',
    );
    


    my $leaderboard = $tree->look_down('id', 'leaderboard');
    foreach my $ch ($leaderboard->content_list) {
        next if not defined $ch or ref($ch) ne 'HTML::Element';
        # The page had 4 columns, one of them was empty.
        my $h2 = $ch->look_down('_tag', 'h2');
        my $type = $NAMES{ $h2->as_text };
    
        my $group = $ch->look_down('class', 'group');
        foreach my $member ($group->content_list) {
            next if not defined $member or ref($member) ne 'HTML::Element';
            # I think these are the anonymous members.
    
            my $n = $member->look_down('class', 'name');
            push @{ $members{$type} }, {
                name => $n->as_text,
            };
        }
    }
    $offset += $limit;

    if (not $total) {
        warn "Could not find total number of members\n";
        last;
    }
    last if $offset >= $total;
}

use Data::Dumper;
#print Dumper \%members;
foreach my $k (keys %members) {
    say "$k  ", scalar @{ $members{$k}}
}
```

## Conclusion

Web scraping can be fun and it can provide solutions where no official API exists. It is also very frustrating:
Even small changes in the HTML supplied by the site can break our code. We better warn our users about it,
and if possible we better encourage the site owners to supply the necessary API.

Oh and if you rely on some CPAN modules, it would be nice to give the author/maintainer a few cents a week as a token of
appretiation.

