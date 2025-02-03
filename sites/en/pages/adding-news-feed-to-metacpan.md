---
title: "Adding news feed to MetaCPAN"
timestamp: 2014-05-02T02:30:01
tags:
  - MetaCPAN
published: true
books:
  - catalyst
  - metacpan
author: szabgab
---


While [Meta CPAN](https://metacpan.org/) is constantly being developed, I think very few people notice the changes.
I hope that by providing a news feed, the developers of MetaCPAN will be able to communicate the changes in a simple way.

Writing the patch that will enable such news feed was very interesting, and I hope that
reading it will help you make another step towards [hacking MetaCPAN](/hacking-metacpan-the-first-steps).


## First steps

Git clone the [repository](https://github.com/CPAN-API/metacpan-web), install all the prerequisites,
launch the server using [plackup](http://plackperl.org/), browse to it at http://localhost:5000

<img src="/img/metacpan-logo.png" alt="MetaCPAN Logo" />

## Add the /news link to the top menu bar

[MetaCPAN](http://metacpan.com/) has a menu bar at the top that looks like this:

<img src="/img/metacpan_menu_bar.png" alt="MetaCPAN menu bar" />

The first thing I need to do is to add the <b>News</b> menu option.
In order to find the place I need to add this I had to search for something that is already in the menu.
So I searched for the word "Feedback in the source-tree using [ack](http://beyondgrep.com/).
It was found in the file [root/wrapper.html](https://github.com/CPAN-API/metacpan-web/blob/master/root/wrapper.html)
It seems that I just had to add the following code:

```
{
  title = "News",
  path = ["/news"],
  class = 'hidden-phone',
},
```

After reloading the page I got the News entry in the menu-bar:

<img src="/img/metacpan_menu_bar_news.png" alt="MetaCPAN menu bar with news" />

## Create a static page

Of course if I click on the link, MetaCPAN will report that page is not found.

So the next step is to create a static page for the news. But how?

Clicking on the link "FAQ" leads to [/about/faq](http://metacpan.org/about/faq)
which is a static page. The title is quite unique, so I can hope I searching for `FAQ's answered`
will help me locate the source of that page. Indeed  I found it in [root/about/faq.html](https://github.com/CPAN-API/metacpan-web/blob/master/root/about/faq.html)

Looking around the [root/](https://github.com/CPAN-API/metacpan-web/blob/master/root) directory, it seems that every page has a template there with .html extension.

Let's create  root/news.html based on the content of [root/about.html](https://github.com/CPAN-API/metacpan-web/blob/master/root/about.html),
and have the following in it:

```
<div class="content">
<% USE Markdown -%>
<% FILTER markdown %>
## News about MetaCPAN

Some text

* Item 1
* Item 2

<% END %> 

</div>
```

(This looks like some [Template Toolkit](http://template-toolkit.org/) that has some [Markdown](https://daringfireball.net/projects/markdown/) formatted
text in it.

After saving the file visiting http://localhost:5000/news still showed <b>Not Found</b>

<img src="/img/metacpan_news_not_found.png" alt="MetaCPAN news not found" />

Maybe I need to enable the file somehow? Let's search for `about.html`.
[ack](http://beyondgrep.com/) found one place, in
[lib/MetaCPAN/Web/Controller/About.pm](https://github.com/CPAN-API/metacpan-web/blob/master/lib/MetaCPAN/Web/Controller/About.pm)

I copied the file to lib/MetaCPAN/Web/Controller/News.pm
and simplified the content to the following:

```perl
package MetaCPAN::Web::Controller::News;

use Moose;

BEGIN { extends 'MetaCPAN::Web::Controller' }

sub news : Local : Path('/news') {
    my ( $self, $c ) = @_;
    $c->stash( template => 'news.html' );
}

1;
```

I had to stop and start the plack-based web server for this to take effect, but once I did that,
and reloaded the page /news showed me the content as expected.

<img src="/img/metacpan_news_static.png" alt="MetaCPAN news static page" />


## Create the News file and displaying its content

The next step was to create an external file for the News in Markdown format and then to
load it and display the content of that file instead of the static page.
I created a file called `News` and placed it in the root of the distribution.
After some trial and error, I reached the following solution:
In `root/news.html` that I created earlier, the static content was replaced
by a single Template Toolkit directive:

```
<% news %>
```

The whole file looked like this:

```
<div class="content">
<% USE Markdown -%>
<% FILTER markdown %>

<% news %>

<% END %>

</div>
```

To fill the field we also have to change the newly created `lib/MetaCPAN/Web/Controller/News.pm`

at first I only added a key-value pair to the call to `stash`. This provides a string as the
value for the Template Toolkit directive 'news';

```perl
package MetaCPAN::Web::Controller::News;

use Moose;

BEGIN { extends 'MetaCPAN::Web::Controller' }

sub news : Local : Path('/news') {
    my ( $self, $c ) = @_;

    $c->stash( template => 'news.html', news => 'Some text'  );
}

1;
```

I had to restart `plackup` and reload the page, but then I could see that the news page now
gets its content from the controller.

The next step is to read the content of the 'News' file and pass that to the template.
The `$c` variable in the subroutine represents the [Catalyst](http://www.catalystframework.org/) object.
Calling `config`
returns a hash with configuration parameters. The `home` field provides full path to the
root directory of the application. The 'News' file is right there.

We use the `path` function provided by [Path::Tiny](https://metacpan.org/pod/Path::Tiny),
and then we [slurp](/slurp) in the content.

At first I passed the content as it is to the `stash` method, but later it seemed more
convenient to add a `Title:` pre-tag to the title of each news-item that will make
it easier to separate the news items for the RSS feed. On the news page we don't need
this extra word, so we can remove it by a regex.

```perl
package MetaCPAN::Web::Controller::News;

use Moose;

BEGIN { extends 'MetaCPAN::Web::Controller' }

use Path::Tiny qw/path/;

sub news : Local : Path('/news') {
    my ( $self, $c ) = @_;

    my $file = $c->config->{home} . '/News';
    my $news = path($file)->slurp_utf8;
    $news =~ s/^Title:\s*//gm;

    $c->stash( template => 'news.html', news => $news  );
}

1;
```

After restarting `plackup` and reloading the page, we can see that the content
of the news page now comes from the News file.

## Adding RSS feed

A news page is not fun without an RSS feed. MetaCPAN already provide a number of such feeds
for [most recently uploaded modules](https://metacpan.org/recent), but where is the code?

After a bit of looking around I found all the RSS feed generation in
[lib/MetaCPAN/Web/Controller/Feed.pm](https://github.com/CPAN-API/metacpan-web/blob/master/lib/MetaCPAN/Web/Controller/Feed.pm)
and added the following method:

```perl
sub news : Chained('index') PathPart Args(0) {
    my ( $self, $c ) = @_;

    my $file = $c->config->{home} . '/News';
    my $news = path($file)->slurp_utf8;
    $news =~ s/^\s+|\s+$//g;
    my @entries;
    foreach my $str (split /^Title:\s*/m, $news) {
        next if $str =~ /^\s*$/;

        my %e;
        $e{name} = $str =~ s/\A(.+)$//m ? $1 : 'No title';
        $str =~ s/\A\s*-+//g;
        $e{date} = $str =~ s/^Date:\s*(.*)$//m ? $1 : '2014-01-01T00:00:00';
        $e{link} = "http://metacpan.org/news#$e{name}";
        $e{author} = 'METACPAN';
        $str =~ s/^\s*|\s*$//g;
        #$str =~ s{\[([^]]+)\]\(([^)]+)\)}{[$1]($2)}g;
        $e{abstract} = $str;
        $e{abstract} = markdown($str);

        push @entries, \%e;
    }

    $c->stash->{feed} = $self->build_feed(
        title => "Recent MetaCPAN News",
        entries => \@entries,
    );
}
```

This method starts the same way as the one in the News controller: We slurp in the content of the News file.
Then we need to split it up into individual news entries and extract the title, and the date from each piece.

The author field expected by the feed generator method gets a fixed string and the abstract is the text
converted from Markdown to HTML.

As these news items will show up on the same page the 'link' should always link to that page, but
in order to have distinct URLs, I added the title of the news item as an anchor. I am not sure if 
this is needed, or if the feed-readers can handle several news items that go to the exact same URL.

I also had to add this line:

```perl
        $entry->{link} //
```

to the `build_entry` method that now looks like this:

```perl
sub build_entry {
    my ( $self, $entry ) = @_;
    my $e = XML::Feed::Entry->new('RSS');
    $e->title( $entry->{name} );
    $e->link(
        $entry->{link} //
        join( '/',
            'http://metacpan.org', 'release',
            $entry->{author},      $entry->{name} )
    );
    $e->author( $entry->{author} );
    $e->issued( DateTime::Format::ISO8601->parse_datetime( $entry->{date} ) );
    $e->summary( escape_html( $entry->{abstract} ) );
    return $e;
}
```

After finishing this, I had to add and commit the changes. I had to push it out to GitHub and send a pull-request.
The core developers of MetaCPAN can then discuss the change, reject it, ask for improvements, but once it is accepted
and deployed, you'll be able to get news feed from the MetaCPAN developers.


