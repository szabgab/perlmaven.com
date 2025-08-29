---
title: "Web Scraping TED - list of talks"
timestamp: 2016-02-06T12:00:01
tags:
  - Web::Query
published: true
author: szabgab
archive: true
---


A few days ago I've started to experiment with web scraping the web site of [TED](http://www.ted.com/).
The first article was about [fetching data of a single TED talk](/web-scraping-ted).

This time we are going to see how to retrieve the list of all the talks available on TED.


After a few minutes of browsing on the TED website I've found a page where I could
[search for TED talks](http://www.ted.com/talks). At the bottom of the page I saw pagination navigation link:
**Previous | 1 | 2 | 3 | 4 | 5 ... 60 | Next**.

Apparently once I've ran a search I could fetch the 2nd, 3rd, etc. pages.

Each such link looked like this: **http://www.ted.com/talks?page=2**. So the same page just passing the page number
as parameter.
After clicking through to the second page I could see that **http://www.ted.com/talks?page=1** work as the first page.

On every page I saw 6*6 = 36 talks and there were 60 pages. On the 60th page there were only 10 talks.
So this means there were 2134 talks when I looked at the site. By the time you read this the number will probably grow.

On every page there are links to the talks. Each link looks like this
**http://www.ted.com/talks/tim_berners_lee_the_year_open_data_went_worldwide** we have already dealt with in the
[previous article](/web-scraping-ted).

So apparently we'll be able to go through all the videos by just downloading the 'talks' pages.

For this we can use [Web::Query](https://metacpan.org/pod/Web::Query). It exports a function
called `wq` that given an URL will fetch the page and return a Web::Query object.

We can use the `find` method of this object to locate all the elements of a given name. In our case
we are fetching the 'talks' pages one-by-one and for each page we go over all the `a` elements.

the `each` method is actually the one that iterates over the elements and for each `a` element
it will call the function we pass to it, with two parameters. The first one is a counter. It isn't interesting to us,
the second represents the current 'a' element.

The `attr` method of this object is able to return the value of an attribute so we fetch the value
of the `href` attribute which should be the link to a talk.

We check if the URL is really pointing to something that looks like a talk (and not for another page in the list or some other
location on the site). We can there store the URL in a hash. We do that, because on the first run I noticed every talk has two links
and this way we can make sure the URLs we save are unique. Every duplicate mention will just fall in the same key of this hash.

We are also taking advantage of the fact that when `++` comes after the variable and acts a the post-increment operator,
then the value of the expression will be the value before, the increment.
This is the same technique that was used to [filter out duplicates from an array](/unique-values-in-an-array-in-perl).

Currently there are 60 pages, but as they keep publishing new talks the number of talks will grow and with that the number of pages.
So we cannot just fetch the pages 1..60. We need to increment the page counter beyond 60 and use some other way to find out if there
are no more talks.  at first I was hoping to get a [404 not found](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
error page when accessing page=61, but it turns out that TED return
a [200 success](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) page. So we cannot rely on that.

Then I had two ideas. In one of them I'd count the number of talks on a given page and if there are 0 talks then I know
we can stop fetching the pages. The second idea was to look for a string in page=61 and then after we fetched a page
check if the it contains this string.

This is the code:

```perl
   last if index($res->text, "Sorry. We couldn't find a talk quite like that.") > -1;
```

In addition, at the end of the loop you can see this:

```perl
    last if $page > 3;
```

I've added it only so when I try the script it won't run and download all the 60 pages.
A little courtesy towards TED.

{% include file="examples/scraping_ted/fetch_list_of_talks.pl" %}

