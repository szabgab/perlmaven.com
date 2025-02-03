---
title: "Fetching Pictures from Flickr using Perl"
timestamp: 2015-05-06T15:30:01
tags:
  - Flickr::API
published: true
author: szabgab
---


[Flickr](http://flickr.com/) has tons of pictures and it has an API that allows
you to connect to it. [Cal Henderson](http://iamcal.com/) created the
[Perl client of the Flickr API](https://metacpan.org/pod/Flickr::API). We are going to use that to fetch a few pictures.


<img src="/img/flickr.png" />

## Version

The code of this article was tested with version 1.08 of
[Flickr::API](http://metacpan.org/pod/Flickr::API).

## Getting the API key

Visit the [Flickr App Garden](http://www.flickr.com/services/),
log in with your Yahoo account and ask for an API key:

Click on [Create an app](http://www.flickr.com/services/apps/create/),
there click on [Request an API Key](http://www.flickr.com/services/apps/create/apply/)

You will have to select if it is for non-commercial/SMB,
or if you are big corp/big money.
You'll also need to give a name of an application you are building. And a description.
I selected the non-commercial/SMB option and wrote that I am building examples
<b>how to use the Flickr API in Perl</b>.

As far as I can see you can get as many API keys as you'd like to, so you can build
multiple applications.

Once you applied you'll receive an API-key and an API-secret. For the examples
in this article we'll only need the API-key.

## Set up client

```perl
use strict;
use warnings;
use 5.010;

use Flickr::API;
use Data::Dumper qw(Dumper);

my $key = 'PUT_THE_API_KEY_HERE';

my $api = Flickr::API->new({
    key     => $key,
    #secret  => $secret,  # we don't use the secret in this example
    unicode => 1,
});
```

Nothing fancy so far.

## Search for pictures

Let's search for `cake`:

We need to create a
[Flickr::API::Request](http://metacpan.org/pod/Flickr::API::Request) object
with all the details of our request, and then pass it to the `execute_request`
method of the `$api`.

```perl
my $request = Flickr::API::Request->new({
    method => 'flickr.photos.search',
    args   => {
        text => 'cake',
    },
});
my $response = $api->execute_request($request);
```

The `$response` is a
[Flickr::API::Response](https://metacpan.org/pod/Flickr::API::Response)
object which is a subclass of
[HTTP::Response](https://metacpan.org/pod/HTTP::Response),
with a few extra keys in the hash: `tree`, `success`,
`error_code`, and `error_message`.

`success` is either [True or False](/boolean-values-in-perl).

The `tree` is the result of parsing by
[XML::Parser::Lite::Tree](http://metacpan.org/module/XML::Parser::Lite::Tree),
which has some strange behavior that makes it a bit difficult to use the module.

Before we go on we should check if the request was successful:

```perl
if (not $response->{success}) {
    die "failure";
}
```

Then comes the analysis of the data we received in the `tree`.

The Interesting stuff is in the array held by the children subkey of the tree: `$response->{tree}{children}`.

Strangely, the first child does not have any useful content. So we go for the second child
where all the interesting data can be found.

We print out the attributes key of the second child:

```perl
print Dumper $response->{tree}{children}[1]{attributes};
```

and this is the output we see:

```
$VAR1 = {
    'pages' => '41270',
    'perpage' => '100',
    'total' => '4126958',
    'page' => '1'
};
```

This means three are a total of 4,126,958 hits for the word `cake`.
The response is divided into 41,270 pages. Each page has 100 results (well, the last
one might have fewer). We received the first page.

Actually we are in control of the page size and which page we get, but because
we have not passed any parameter to the query besides the search string it
used the default which is 100 results per page and fetch the first page.

Using these values we can actually go over all the images.

## Go over the images of the current response

The following snippet will fetch the list of (100) images from the current response
and then we go over the images:

```perl
my @images = grep { $_->{attributes} } @{ $response->{tree}{children}[1]{children} };

foreach my $img (@images) {
    my $attr = $img->{attributes};
    print Dumper $attr;
    exit;
}
```

Actually, before going over all the images, let's see what attributes each image
provide in the search result. (That's why we call exit just after the first iteration.
The result is:

```
$VAR1 = {
    'farm' => '6',
    'owner' => '100072202@N05',
    'id' => '11050960463',
    'secret' => '7444f5813b',
    'isfamily' => '0',
    'title' => "I made a pretty mean birthday cake for Jeff! So much better than store bought 'cause it's made with LOVE! \x{2665}",
    'ispublic' => '1',
    'server' => '5513',
    'isfriend' => '0'
};
```

So from here we could get the title of the image: `$attr->{title};` and a
few other items. We could even construct the URL to one of the copies of the
actual image:

```perl
    my $url = sprintf('http://farm%s.staticflickr.com/%s/%s_%s_o.jpg',
        $attr->{farm}, $attr->{server}, $attr->{id}, $attr->{secret});
    say $url;
```

## Get the sizes

Instead of that we can use another query to fetch the available sizes
for this image:

```perl
    my $request = Flickr::API::Request->new({
        method => 'flickr.photos.getSizes',
        args   => {
            photo_id => $attr->{id},
        },
    });
    my $resp = $api->execute_request($request);
    if (not $response->{success}) {
        die "failure";
    }
    my @sizes = grep { $_->{attributes} } @{ $resp->{tree}{children}[1]{children} };
    print Dumper $sizes[0];
```

This is the data we get for a single size of an image:

```
$VAR1 = {
    'type' => 'element',
    'name' => 'size',
    'attributes' => {
        'height' => '75',
        'label' => 'Square',
        'media' => 'photo',
        'url' => 'http://www.flickr.com/photos/100072202@N05/11050960463/sizes/sq/',
        'source' => 'http://farm6.staticflickr.com/5513/11050960463_7444f5813b_s.jpg',
        'width' => '75'
    },
    'children' => []
};
```

the values that really interest me are height, width and the source, which is the actual URL to the image.

Now that we have image we can use something as simple as the `getstore` function of
[LWP::Simple](https://metacpan.org/pod/LWP::Simple).

## Putting it all together

Let's say we would like to download the smallest version of 20 cakes:
(Because the images can come in all kinds of aspect ratios, we go for the smallest
height.)


```perl
use strict;
use warnings;
use 5.010;

use Flickr::API;
use Data::Dumper qw(Dumper);
use LWP::Simple qw(getstore);

my $dir = "flickr";
mkdir $dir;

my $key = 'PUT_THE_API_KEY_HERE';

my $api = Flickr::API->new({
    key     => $key,
    unicode => 1,
});

my $request = Flickr::API::Request->new({
    method => 'flickr.photos.search',
    args   => {
        text => 'cake',
        per_page => 20,
        page => 1,
    },
});

my $response = $api->execute_request($request);
if (not $response->{success}) {
    die "failure";
}
my @images = grep { $_->{attributes} } @{ $response->{tree}{children}[1]{children} };
foreach my $img (@images) {
    my $attr = $img->{attributes};
    my $request = Flickr::API::Request->new({
        method => 'flickr.photos.getSizes',
        args   => {
            photo_id => $attr->{id},
        },
    });
    my $resp = $api->execute_request($request);
    if (not $response->{success}) {
        warn "failure";
        next;
    }
    my @sizes = grep { $_->{attributes} } @{ $resp->{tree}{children}[1]{children} };

    # sort the sizes according to height and get the fist one, the smallest
    my ($smallest) = sort { $a->{attributes}{height} <=> $b->{attributes}{height} } @sizes;

    # get the last part of the URL which is the filename
    my ($file) = ($smallest->{attributes}{source} =~ m{([^/]*)$});

    say "$smallest->{attributes}{source}, $dir/$file";
    getstore($smallest->{attributes}{source}, "$dir/$file");
}
```

