---
title: "Add some acceptance tests using search.cpan.org"
timestamp: 2015-04-02T11:30:01
tags:
  - Test::WWW::Mechanize
  - SCO
types:
  - screencast
published: true
books:
  - testing
  - search_cpan_org
author: szabgab
---


The plan is, that I am going to write a lot of tests accessing the live [search.cpan.org](http://search.cpan.org/) web site and use those
tests as a suite of <b>acceptance tests</b> for the [search.cpan.org clone](/search-cpan-org) project.


{% youtube id="Puzc9QkV_Vg" file="add-some-acceptance-tests" %}

While working on the next step, I noticed that the swap-files used by vim show up as untracked file by git. In order to avoid adding
them to Git, I added `*.swp` to the `.gitignore file. [commit](https://github.com/szabgab/MetaCPAN-SCO/commit/a87232f428308f93b45ab70009d3254cde77f9cb).

## Testing search.cpan.org

There are a couple of ways to test web site, and using [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize)
is a great way to do that. WWW::Mechanize is basically a web client (it is a subclass of [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)
that understand HTML. So you can tell it to click on a link or fill a form.

In itself WWW::Mechanize is great to automate interaction with web sites, but if we want to write <b>unit-test</b> (even if in this case we call them <b>acceptance tests</b>)
it is much better to use [Test::WWW::Mechanize](https://metacpan.org/pod/Test::WWW::Mechanize) which is a wrapper around Mechanize providing test-functions
using [Test::Builder](https://metacpan.org/pod/Test::Builder) backend. Exactly the same way as it was explained in the testing mini-series that ended
when we [created a test module](/is-any-create-test-module).


Using [Test::WWW::Mechanize](https://metacpan.org/pod/Test::WWW::Mechanize) is a bit different than the test module we created. This module provides an object
oriented interface. First we create an instance of this class and then use its methods to interact with a web site. As a start we call `get_ok` with a URL.
This will fetch the page on that URL and check if the fetching was successful. (If it returned `200 ok`.) Then we can use all kinds of methods
to check the content of this page. In this case I went for a very minimalistic test, I used the `title_is` method to check if the page has the expected title.

At this point I already started to have concerns: In the clone, am I going to have the same title or will it explicitly say it is a clone? Am I going to
be able to reuse these tests with the clone? I did not have an answer to these, but I kept going and added another
[subtest](/subtest). The `follow_link_ok` method clicks on the link that says "Authors", checks if there was such a link and
if the new page was loaded successfully.

```perl
use strict;
use warnings;

use Test::More;
use Test::WWW::Mechanize;

plan tests => 2;

my $w = Test::WWW::Mechanize->new;

my $url = 'http://search.cpan.org/';

subtest home => sub {
    $w->get_ok($url);
    $w->title_is('The CPAN Search Site - search.cpan.org');
};

subtest authors => sub {
    $w->follow_link_ok( {text => 'Authors'}, 'Authors link' );
};
```

```
$ git add .
$ git commit -m "first tests of live search.cpan.org site"
```

[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/9f6dba883c3263ae744d546a9b8485595386719e)


## Add some more tests


Once I had the skeleton of the tests  I could add some more checks.

On the home-page there is a form. The parameters of `submit_form_ok` method gets help identify one specific form.
In our case it is quite easy, as there is only one form on this page. (I checked it by looking at the HTML source of
the page and looking for the word "form".) So we identify the form by being the first (and only) form on this page:
`form_number => 1`. Then we supply the values to the fields. In order to know the names of the fields I had
to look at the HTML source of the page again. The `query` is some free-text field, while the `mode` is a
selector. The `submit_form_ok` method will fill the form, click on the submit button, and check if the
resulting page returned `200 ok`.

Then we have two methods checking the content of the resulting page. `content_contains` check if the given string
can be found in the source of the HTML file and `content_lacks` checks if the given string is <b>not</b> in the HTML.

This test actually is even more problematic than the one checking the title. When searching for "sz" among the authors,
I was expecting to see all the authors that have "sz" in their name. It turns out search.cpan.org does not show all of them.
Specifically I did not see my own name. This is disturbing on many levels, besides hurting my ago. Does this mean there is a
bug in search.cpan.org or is there something more subtle in this search, I am not aware of. Should the clone try to
show the exact same list, or shall we consider this a bug and fix it?

Can we even understand why specific people are listed here and others not?

How can I write a test that will pass on both search.cpan.org and on the clone, if they will show different results?

```perl
use strict;
use warnings;

use Test::More;
use Test::WWW::Mechanize;

plan tests => 2;

my $w = Test::WWW::Mechanize->new;

my $url = 'http://search.cpan.org/';

subtest home => sub {
    $w->get_ok($url);
    $w->title_is('The CPAN Search Site - search.cpan.org');
    $w->submit_form_ok( {
            form_number => 1,
            fields      => {
                query => 'sz',
                mode  => 'author', 
            },
        }, 'search "sz" in author'
    );
    $w->content_contains('Arpad Szasz');
    $w->content_lacks('Szabo');
};

subtest authors => sub {
    $w->follow_link_ok( {text => 'Authors'}, 'Authors link' );
    $w->title_is('The CPAN Search Site - search.cpan.org');
    $w->follow_link_ok( {text => 'A'}, 'A link' );
    $w->title_is('The CPAN Search Site - search.cpan.org');
    $w->content_contains('Andy Adler');
    $w->content_contains('Sasha Kovar');

    $w->follow_link_ok( {text => 'AADLER'}, 'Link to author AADLER');
};
```

The second subtest was also extended with a couple of additional checks.
I checked the title here too, and then followed the link that has <b>A</b> on it. Checked the title again
and used `content_contains` to make sure two names appear in the list. Then followed one of the links.

These tests are also slightly problematic. What if one of the people changes her name. Will the test fail then?
Is this ok to have test that are dependent on the environment?

```
$ git add .
$ git commit -m "add some more tests"
```

[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/0a6b97396145f8a109ee3647f2aa5b3e9200892e)


