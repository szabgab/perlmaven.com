---
title: "Show CPANstats on every page"
timestamp: 2015-05-27T10:30:01
tags:
  - SCO
  - Template::Toolkit
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


Now that we have these generic stats on our system, we should replace the hard-coded numbers we have on the front page.
As we know these numbers will have to be displayed on every page, we don't add it to the code that displays only the main page.
Instead we add our code to the `template()` function that will be called for every page.


{% youtube id="SG3sUB8S6b4" file="show-cpanstats-on-every-page" %}

Earlier we had this code generating the HTML page from the template and from the lack of (!) parameters passed to it.
That empty hash in the middle is where we need to pass the parameters.

```perl
$tt->process( "$file.tt", {}, \$out )
```

so instead of that we write the following code:


```perl
    my $root = root();
    my $totals = from_json path("$root/totals.json")->slurp_utf8;
    $tt->process( "$file.tt", {totals => $totals}, \$out )
```

We also need to change the templates. We remove the hard-coded cpanstats numbers from the
[tt/incl/header.tt](https://github.com/szabgab/MetaCPAN-SCO/blob/35c35625c67e43877090dfc22be8ba8324b45f25/tt/incl/header.tt)
and instead of that we add [Template::Toolkit](http://template-toolkit.org/) tags. Actually, instead of putting those
in the header file, I went ahead and put the tags in the
[tt/incl/footer.tt](https://github.com/szabgab/MetaCPAN-SCO/blob/35c35625c67e43877090dfc22be8ba8324b45f25/tt/incl/footer.tt)
as they will be at the bottom of other pages as well.

This is the HTML code with the Template::Toolkit (TT) tags:

```
<div class="footer"><div class="cpanstats">
<% totals.distribution %> Distributions, <% totals.module %> Modules, <% totals.author %> Authors
</div></div>
```

The data we passed looked like this:

```perl
{
  totals => {
     distribution => 36252,
     module      => 15533974,
     author      => 11829,
  }
} 
```

TT allows us to refer to keys of a hash and if there are internal hash-es we can also access the values of those
keys by separating the levels with dots. So What in perl we would write
`$data->{totals}{distribution}`, in Template::Toolkit we write `totals.distribution`.
That's how the above code was reached.

The only missing thing for this to work was to load the necessary modules in the `lib/MetaCPAN/SCO.pm`

```perl
use JSON qw(from_json);
use Path::Tiny qw(path);
```

## Commit

This leads us to the next [commit](https://github.com/szabgab/MetaCPAN-SCO/commit/35c35625c67e43877090dfc22be8ba8324b45f25).

```
$ git add .
$ git commit -m "load cpanstats from the totals.json file"
```


