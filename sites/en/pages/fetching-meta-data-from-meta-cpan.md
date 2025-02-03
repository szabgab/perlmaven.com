---
title: "Fetching META data from Meta CPAN"
timestamp: 2013-01-08T10:45:56
tags:
  - CPAN
  - MetaCPAN
  - MetaCPAN::API
  - META
published: true
books:
  - metacpan
author: szabgab
---


In other articles you can learn <a
href="/how-to-add-link-to-version-control-system-of-a-cpan-distributions">how to add a link to
version control</a> and [how to add the license field](/how-to-add-the-license-field-to-meta-files-on-cpan) to a CPAN module.

So how many recently uploaded CPAN modules have this information? [Meta CPAN](https://metacpan.org/) already
has this information. In this article we'll use it to create a report.


## The full script

Using [MetaCPAN::API](https://metacpan.org/pod/MetaCPAN::API).

On the command line you have to pass the number of distributions you'd like to fetch,
and optionally you can also provide a PAUSE ID. (For example, when I check my own distributions
I run it with <b>perl metacpan_meta.pl 100 SZABGAB</b>.

```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Data::Dumper;
use MetaCPAN::API;
my $mcpan = MetaCPAN::API->new;

my ($size, $pauseid) = @ARGV;
die "Usage: $0 N [PAUSEID]  (N = number of most recent distributions)\n" if not $size;

my $q = 'status:latest';
if ($pauseid) {
    $q .= " AND author:$pauseid";
}

my $r = $mcpan->fetch( 'release/_search',
    q => $q,
    sort => 'date:desc',
    fields => 'distribution,date,license,author,resources.repository',
    size => $size,
);

my %licenses;
my @missing_license;
my @missing_repo;
my %repos;
my $found = 0;
my $hits = scalar @{ $r->{hits}{hits} };
foreach my $d (@{ $r->{hits}{hits} }) {
    my $license = $d->{fields}{license};
    my $distro  = $d->{fields}{distribution};
    my $author  = $d->{fields}{author};
    my $repo    = $d->{fields}{'resources.repository'};

    if ($license and $license ne 'unknown') {
        $found++;
        $licenses{$license}++;
    } else {
        push @missing_license, [$distro, $author];
    }

    if ($repo and $repo->{url}) {
        if ($repo->{url} =~ m{http://code.google.com/}) {
            $repos{google}++;
        } elsif ($repo->{url} =~ m{git://github.com/}) {
            $repos{github_git}++;
        } elsif ($repo->{url} =~ m{http://github.com/}) {
            $repos{github_http}++;
        } elsif ($repo->{url} =~ m{https://github.com/}) {
            $repos{github_https}++;
        } elsif ($repo->{url} =~ m{https://bitbucket.org/}) {
            $repos{bitbucket}++;
        } elsif ($repo->{url} =~ m{git://git.gnome.org/}) {
            $repos{git_gnome}++;
        } elsif ($repo->{url} =~ m{https://svn.perl.org/}) {
            $repos{svn_perl_org}++;
        } elsif ($repo->{url} =~ m{git://}) {
            $repos{other_git}++;
        } elsif ($repo->{url} =~ m{\.git$}) {
            $repos{other_git}++;
        } elsif ($repo->{url} =~ m{https?://svn\.}) {
            $repos{other_svn}++;
        } else {
            $repos{other}++;
            say "Other repo: $repo->{url}";
        }
    } else {
        push @missing_repo, [$distro, $author];
    }
}
@missing_license = sort {$a->[0] cmp $b->[0]} @missing_license;
@missing_repo    = sort {$a->[0] cmp $b->[0]} @missing_repo;
say "Total asked for: $size";
say "Total received : $hits";
say "License found: $found, missing " . scalar(@missing_license);
say "Repos missing: " . scalar(@missing_repo);
say "-" x 40;
print Dumper \%repos;
print Dumper \%licenses;
print 'missing_licenses: ' . Dumper \@missing_license;
print 'missing_repo: ' . Dumper \@missing_repo;
```

## Explanation of the Query

I think the most interesting part is how the query is built, so I'll explain that first.

```perl
my $q = 'status:latest';
if ($pauseid) {
    $q .= " AND author:$pauseid";
}

my $r = $mcpan->fetch( 'release/_search',
    q => $q,
    sort => 'date:desc',
    fields => 'distribution,date,license,author,resources.repository',
    size => $size,
);
```

We are calling the `fetch` method and we are searching for <b>release</b>-es (aka. distributions).
It takes a set of key-value pairs as parameters.

The first one we see is <b>q</b>. This filters the results based on various conditions.
We have the conditions in a variable called <b>$q</b>. By default we fetch all the distributions where
the status is "latest" using the `status:latest` string.
For this report we don't want to see earlier releases of the same distribution.

Then, if the user provided a PAUSE ID - the ID used to upload a distribution to CPAN
(via [PAUSE](https://pause.perl.org/)) -
we include that in the query. If the PAUSE ID is SZABGAB, you will have a query
`status:latest AND author:SZABGAB`.

The second field is optional. We instruct Meta CPAN to provide the results sorted based on the <b>date</b> field in a
descending order. Most recent first.

Another optional pair of parameters: <b>fields</b> can limit which fields we are actually interested in. If we leave out
the fields, Meta CPAN will return a lot of details for each distribution. IF we are not interested in those details,
then this is just a waste of resources. So we limit the fields we would like to see.

When I was creating this script I did not know which fields existed. So at first I fetched a single distribution
without setting the fields and printed the results using Data::Dumper. That helped me decide which fields to fetch
in the real script.

The last pair of parameters in our example sets the size of the "result set". The max number of results we would like to
fetch. Here again, I think it is better to limit this to the actual size we are interested in. There is no point in
fetching information about 20,000 distributions if we don't intend to use the most of that data.


## Collecting the data

Once the query returned, we go over all the hits and using a straight-forward way of filtering we collect the
results in several hashes. Then we print the report and dump the data. I am sure the report could be formatted
in a much nicer way, but it was good enough for my purposes.

## The script on CPAN

Since I wrote the article I packaged the script and uploaded it to CPAN.
Check out the [MetaCPAN-Clients](https://metacpan.org/release/MetaCPAN-Clients)
distribution.


