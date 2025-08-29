---
title: "How to download a Perl module from CPAN"
timestamp: 2015-03-14T02:30:01
tags:
  - CPAN
  - WWW::Mechanize
published: true
author: szabgab
archive: true
---


Normally if you want to [install a Perl module from CPAN](/how-to-install-a-perl-module-from-cpan) you don't need
to manually download it, as there are clients for CPAN that will do it for you.

However when I research a module, for example to write an article about it, or to see how another module is using it, I often prefer to have
the whole distribution on my disk. That way I have the tests included with the distribution and, and if it contains examples
I have those too.


Let's say I'd like to download the distribution that contains the [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize) module.


## cpanm

If you have [CPAN Minus](http://cpanmin.us) installed you can type in `cpanm --look WWW::Mechanize`. It will download the distribution,
unzip it and open a subshell in the unzipped directory. That's cool, but in many cases I'd need to have several distributions to be around, and
I don't really like that subshell. I'd like the downloaded and unzipped directory to be easily accessible later on from my regular shell.

## cpan

As pointed out by dnmfarrell on [Reddit](http://www.reddit.com/r/perl/comments/2yzuf4/how_to_download_a_perl_module_from_cpan/),
the `cpan` command, which is the regular cpan client also has a usefule option.
`cpan -g WWW::Mechanize` would download the zip file of the latest distribution providing the WWW::Mechanize module and
would save it in the current directory. I would still need to unzip it, but this is also a great solution.

There might be some bug using this feature on a newly configured cpan client as I've reported [here](https://rt.cpan.org/Ticket/Display.html?id=102778),
but I think if you regularily use this cpan client then it will work fine.

## git-cpan

Then there is the [git-cpan](https://metacpan.org/pod/distribution/Git-CPAN-Patch/bin/git-cpan) command line tool
that comes with [Git::CPAN::Patch](https://metacpan.org/pod/Git::CPAN::Patch).
It seems to be everything I could want and more. It would fetch a distribution from CPAN, create a local Git repository
and let you hack on the code.

I tried `git-cpan clone WWW::Mechanize`. It recognized that WWW::Mechanize already has a repository on GitHub,
and cloned that repository. Unfortunately when I tried to run `git-cpan clone XML::DT` (a module that does not
declare its repository), I got several errors. I have [reported the issue](https://github.com/yanick/git-cpan-patch/issues/20).

## Using WWW::Mechanize

My main issue though is that I wanted something simple. So here is what I wrote:

{% include file="examples/download-cpan.pl" %}

A very simple and probably fragile solution.

The script accepts a URL on the command line. One that either leads to a module on MetaCPAN, such as this:
`https://metacpan.org/pod/WWW::Mechanize` or one that leads to a distribution. Such as this:
`https://metacpan.org/release/WWW-Mechanize`.

It looks for the link that says **Download ...**, take the URL where that link leads. Downloads the thing behind the link,
saves it to the **/tmp** directory an unzips it.

The script uses [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize) module to fetch the HTML page of MetaCPAN

Get the parameter from the command line. Exit with an error message if there was not parameter on the command line.:

```perl
my $url = shift or die "Usage: $0 URL\n";
```

Check if the given parameter is in the format of either of the pages mentioned above and extract the name of the
module or distribution into the `$name` variable. Both regexes start by matching a URL on the MetaCPAN
site and then containing letters, numbers and some extra characters.


```perl
my $name;
if ($url =~ m{^https://metacpan.org/pod/([a-zA-Z0-9:]+)$}) {
    $name = $1;
} elsif ($url =~ m{^https://metacpan.org/release/([a-zA-Z0-9-]+)$}) {
    $name = $1;
}
```

If `$name` is empty, exit the script with an error message. This was not one of the recognized URL formats:

```perl
die "Invalid URL\n" if not $name;
```


Create the WWW::Mechanzie object and fetch the URL the user gave us:

```perl
my $w = WWW::Mechanize->new;
$w->get($url);
```

On the downloaded page try to find a link that matches the regex `^Download`. That is a link that starts with the word `Download`
Exit the script with an error message if no such link could be found:

```perl
my $download_link = $w->find_link( text_regex => qr{^Download} );
die "Could not find download link\n" if not $download_link;
```

The value returned by the `find_link` method is either [undef](/undef-and-defined-in-perl), if no link was found,
or an instance of [WWW::Mechanize::Link](https://metacpan.org/pod/WWW::Mechanize::Link).

From the object we can extract the URL of the link using the `url` method and then using a regular expression we extract
the last part of the string. The regex itself will match `[^/]` (any character except slash, till the end of the string.
That is it will match the name of the file at the end of the URL:

```perl
my ($file) = $download_link->url =~ m{([^/]+)$};
say $download_link->url;
say $file;
```


From the filename and from the `$dir` variable we declared at the beginning of the script we create a local path
where we would like to save the downloaded zip file. We check if the file already exists and exit the script if the file is there.
Apparently we have already downloaded this version of this  distribution:

```perl
my $path = "$dir/$file";
if (-e $path) {
    say "Already downloaded to $path";
    exit;
}
```


The `follow_link` method will search for the link again and click on it. Effectively downloading the content of the file
but keeping it in memory as the `content` of the page.

```perl
$w->follow_link( text_regex => qr{^Download} );
```

The `save_content` method will save the content of the current page which should be the content of the content of the zip file.
Still zipped. In the `$path` variable we provide the local path where the content should be save and we also tell it to save the
content as a binary file. After all we are talking about a zip file.


```perl
$w->save_content( $path, binary => 1 );
```

Once that's done, we change to the directory where we saved this file and call the external `tar` command to unzip the file.

```perl
chdir $dir;
system "tar xzf $file";
```

A rather simple use of the [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize) module.

