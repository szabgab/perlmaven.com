---
title: "Web Scraping TED - information about a specific talk"
timestamp: 2016-01-31T23:00:01
tags:
  - LWP::UserAgent
  - JSON
  - Encode
published: true
author: szabgab
archive: true
---


In my [ideas for TED](http://code-maven.com/ted) I mentioned that currently they don't give access to their API to new users.
This should not necessarily stop us from getting the data from the web site. We can use the good old web scraping.


I've picked one of the videos almost randomly:
[The year open data went worldwide](http://www.ted.com/talks/tim_berners_lee_the_year_open_data_went_worldwide).
If you look at the page you'll see that it has "32 subtitle languages" (or maybe more by the time you look at it).
If you click on that text you'll see a modal display showing the list of the languages.
Clearly it is some JavaScript code that generates this modal display.

I looked at the source of the page (just by right-clicking on the page in the browser) trying to locate the data.
At first I searched for ""subtitle languages", but that did not lead me to the list of languages.

Then I searched for 'Chinese', the name of one of the translations I suspected won't show up in any other part of the page,
and I found it embedded in a json structure inside a JavaScript function embedded in a  `&lt;script&gt;` tag.

Equipted with information I started to write a small script that would fetch the page, find all the 'script' tags
and print the content of these script tags. At first I used [Web::Query](https://metacpan.org/pod/Web::Query)
to fetch the page, find the 'script' tags and extract their content. The first two steps when well, but the function I
was expecting to extract the 'text' inside the 'script' tags did not return anything. So I filed a
[bug-report/question](https://github.com/tokuhirom/Web-Query/issues/48).

I did not want to wait for a reply so to have a faster solution I turned to [Regular Expression](/regex-cheat-sheet).
Normally parsing HTML using Regexes is considered a sin, but in this case we had to extract a single tag that did not have any other tags in
it and is very unlikely to contain a string that looks like a closing 'script' tag.

{% include file="examples/scraping_ted/parse_with_regex.pl" %}

I used the `get` function of [LWP::Simple](https://metacpan.org/pod/LWP::Simple) to fetch the page and
then a regex to parse it and extract the content of every 'script' tag. In this regex I've use `.*?` a minimal
match, and the `s` modifier to change the behavior of `.` to match any characters. Including newlines.
The `g` modifier is only there to fetch `globally`, **all** the possible matches.

## Extract JSON

The next step was to extract the JSON from within the 'script' tag. For this I had to use a Regex again as
the JSON is embedded in a JavaScript function called 'q'. It looked something like this:

```perl
q("talkPage.init",({"talks" ... }))
```

except that there was a lot more code instead the 3 dots.

For this I used the following expression:

```perl
    my ($json) = $script =~ /^q\("talkPage\.init",(\{"talks".*)\)/s;
```

The left-hand side of the assignment must be in parentheses to create [LIST context](/scalar-and-list-context-in-perl)
and we again use `s` modifier again to change the behavior of `.`.

There are many 'script' tags on this page, but only one is expected to match this regex and that is expected to return a
[JSON](/json) string.
So we can skip the rest of the look if `$json` is empty.

If `$json` was not empty then we would like to convert it to a Perl data structure. For that we can use the
`decode_json` function of any of the [JSON modules](/json). Resulting in this code:

{% include file="examples/scraping_ted/extract_json.pl" %}

Unfortunately running this script will throw an exception:

`Wide character in subroutine entry at extract_json.pl line 18`

I've already seen this problem once. I had to mark the JSON string to be real UTF-8 string
using the `encode` function of the [Encode](https://metacpan.org/pod/Encode) module.

{% include file="examples/scraping_ted/get_and_extract_json.pl" %}

The output of this script looks like this:

{% include file="examples/scraping_ted/json_dump.pl" %}

There is lots of interesting data in that JSON dump that we might be able to use to build
nice [applications](http://code-maven.com/ted).


## TODO

In order to be able to implement either of the [ideas for TED](http://code-maven.com/ted)
I'll also need to fetch a large list of talks, but let's leave that for another day and another
article.



