---
title: "Get CPANstats from MetaCPAN using cron"
timestamp: 2015-05-21T06:30:01
tags:
  - MetaCPAN
  - cron
  - LWP::Simple
  - get
  - JSON
  - from_json
  - to_json
  - Path::Tiny
  - path
  - spew_utf8
types:
  - screencast
published: true
books:
  - search_cpan_org
  - metacpan
author: szabgab
---


When we copied the [look-and-feel from search.cpan.org](/create-the-sco-look-and-feel), we also
copied the stats at the bottom of the page. We already knew back then that we'll have to change this to show
up-to-date data. It's time to do that.

We know that these numbers are displayed on every page of search-cpan-org, and we also know that these numbers
don't need to be totally up-to-date. so instead of fetching them from MetaCPAN on every request, we can
create a separate script that will fetch these numbers once a day and store them in a file.

The site can then fill the pages with the data from this file.


{% youtube id="43LBO9xUqq0" file="get-cpanstats-from-metacpan" %}

## cron-job to fetch the data via MetaCPAN API

The first step will be to fetch the data from MetaCPAN and store it in a file.

In order to create the script first I looked at [API-docs](https://github.com/CPAN-API/cpan-api/wiki/API-docs)
which has moved since then to the [repository](https://github.com/CPAN-API/cpan-api/blob/master/docs/API-docs.md)
and created a few requests using curl:

```
curl -XPOST api.metacpan.org/v0/author/_search -d '{
  "query": { "match_all": {} },
  "size":0
}'

curl http://api.metacpan.org/v0/author/_search?size=0


curl -XPOST api.metacpan.org/v0/distribution/_search -d '{
  "query": { "match_all": {} },
  "size":0
}'

curl http://api.metacpan.org/v0/distribution/_search?size=0


curl -XPOST api.metacpan.org/v0/module/_search -d '{
  "query": { "match_all": {} },
  "size":0
}'

curl http://api.metacpan.org/v0/module/_search?size=0
```

Each one of these returns a JSON response that we can parse.
From here I arrived to the conclusion that,  the 3 simple requests will return numbers related to the ones we saw
on search.cpan.org. They won't be the same, but I am not sure if we can even get the same numbers. Besides, I think
it is not critical for the site to show the same exact numbers. So at this point in the development we can rely
on the requests we found and the numbers they return. If later, when the more important parts of the project have
been implemented, we still have the urge to make these perfect, we can return to the queries and further research them.

So let's write the Perl code that will fetch these requests using [LWP::Simple](https://metacpan.org/pod/LWP::Simple),
convert the JSON strings into Perl data structures using the `from_json` function of the [JSON](https://metacpan.org/pod/JSON)
module, and then save the extracted and combined data in a new JSON file called `totals.json`.

I know, there are [faster JSON implementations](/comparing-the-speed-of-json-decoders),
but at this point I don't need to worry about that.


We added a script called [bin/fetch.pl](https://github.com/szabgab/MetaCPAN-SCO/blob/77619bd404df5733573871990294ac436468934c/bin/fetch.pl)
containing the following code:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Cwd qw(abs_path);
use File::Basename qw(dirname);

use MetaCPAN::SCO::Fetch;
MetaCPAN::SCO::Fetch->run( dirname(dirname( abs_path(__FILE__) )));
```

and the [lib/MetaCPAN/SCO/Fetch.pm](https://github.com/szabgab/MetaCPAN-SCO/blob/77619bd404df5733573871990294ac436468934c/lib/MetaCPAN/SCO/Fetch.pm)
module with the following code:

```perl
package MetaCPAN::SCO::Fetch;
use strict;
use warnings;

use LWP::Simple qw(get);
use JSON qw(from_json to_json);
use Path::Tiny qw(path);


sub run {
    my ($self, $root) = @_;

    my %totals;
    foreach my $name (qw(author distribution module)) {
        my $json = get "http://api.metacpan.org/v0/$name/_search?size=0";
        my $data = from_json $json;
        $totals{$name} = $data->{hits}{total};
    }
    path("$root/totals.json")->spew_utf8(to_json \%totals);
    return; 
}

1;
```

At this point no error handling was added, but surely we'll have to do that too.
The `path` function exported by [Path::Tiny](https://metacpan.org/pod/Path::Tiny),
returns an object representing the file and provides a method `spew_utf8` to write out the content
of any string to that file. Even if that string contains multiple newlines that was created by
the `to_json` function of the JSON module.

## cron-job

We can run the `bin/fetch.pl` manually to see it creates the `totals.json` file, and we can look at the content to verify it looks
as we expect it, but we need to make sure the file is updated in regular interval. For that we can use [cron](/how-to-run-a-perl-script-automatciall-every)
on Unix/Linux or the Scheduler if we use MS Windows.

This is how the crontab file looks like:

```
27 * * * * (cd ~/MetaCPAN-SCO; perl -Ilib bin/fetch.pl)
```


## Add prerequisites to Makefile.PL

We also had to add the new prerequisites to [Makefile.PL](https://github.com/szabgab/MetaCPAN-SCO/blob/77619bd404df5733573871990294ac436468934c/Makefile.PL)
and updated the [.gitignore](https://github.com/szabgab/MetaCPAN-SCO/blob/77619bd404df5733573871990294ac436468934c/.gitignore) file to ignore the
generated `totals.json` file.

This lead us to the next [commit](https://github.com/szabgab/MetaCPAN-SCO/commit/77619bd404df5733573871990294ac436468934c).

```
$ git add .
$ git commit -m "add script to be used in a cron-job that will periodically refresh so me data from MetaCPAN API"
```

