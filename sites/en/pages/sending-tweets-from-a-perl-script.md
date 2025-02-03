---
title: "Using Twitter, sending Tweets from a Perl script"
timestamp: 2015-03-25T09:30:01
tags:
  - File::HomeDir
  - Config::Tiny
  - Net::Twitter
published: true
author: szabgab
---


Do you have an application that would benefit from posting status notes on a Twitter account? In this example we'll see how
to configure your Twitter account to be able to do so, and how to write a Perl script to send the Tweets using
[Net::Twitter](https://metacpan.org/pod/Net::Twitter)


## Prerequisites

* [File::HomeDir](http://metacpan.org/pod/File::HomeDir)
* [Config::Tiny](https://metacpan.org/pod/Config::Tiny)
* [Net::Twitter](https://metacpan.org/pod/Net::Twitter)

## Configure Twitter

The very first step is to create an account on [Twitter](http://twitter.com/) and gain followers. We won't go in
there as that is a whole other story. We'll assume there is already a Twitter account you control with plenty of followers
you'd like to update.

Apparently we have to
[add a  mobile phone to the Twitter profile](https://support.twitter.com/articles/110250-adding-your-mobile-number-to-your-account-via-web)
before we can create an application.


Start by visiting the [Application Management](https://apps.twitter.com/) site of Twitter.
If you are already signed in to Twitter it will show your avatar in the top right corner and will tell you that
"You don't currently have any Twitter Apps.".

<img src="/img/twitter_apps_empty.png" alt="Empty Twitter Apps" />

Click on the button that say "Create New App" and you will see a form:

<img src="/img/twitter_apps_create.png" alt="Create Twitter App" />

Fill in the form. I used the following:

```
Name: Perl Maven Example
Description: Test Application for Perl Maven
Website: https://perlmaven.com/
Callback URL:
```

Then I had to read the <b>Developer Rules of the Road</b> at the bottom of that page, click on the checkbox
and press "Create your Twitter application".

Apparently the "Name" must be unique across all the applications in Twitter.

Once you clicked on that button the application gets created and I see the details of the application:

<img src="/img/twitter_app_created.png" alt="Twitter app created" />

That page has 4 "tabs" and we are in the "Details" tab.

We need to click on the "API Keys" tab that will show both the API key and the API secret we need.

<img src="/img/twitter_apps_api_keys.png" alt="Twitter apps API keys" />

We need the values from both the <b>API key</b> and <b>API secret</b> fields. We could save them in the
source code of our script, but for security reasons it is usually much better to save these values
in a separate file.
We certainly don't want other people to see our API key so if we want to 
distribute our application we would not want to include our API key. Even version control can be problematic.
Our script is (hopefully) under version control that is pushed out to some server. It will be backed up.
Who knows where these files might end up.

So we save these values in a file called `.twitter` in the home directory of our user account.
Regardless of your operating system, this one-liner `perl -MFile::HomeDir -E "say File::HomeDir->my_home"`
will print your home-directory.

The format I used to save the two values is like this:

```
[perlmaven]
api_key=
api_secret=
```

In addition to the API key/secret pair, we will also need an <b>Access Token</b>. To obtain an access token scroll down
the web page where you found the API key/secret pair. You will see there is no access token created yet:

<img src="/img/twitter_no_access_token.png" alt="No access token" />

Click on the button <b>Create my access token</b>.

It will take you back to the top of the same page showing the following:

<img src="/img/twitter_access_token_creation.png" alt="Access token creation" />

After a few seconds I clicked on the <b>refresh</b> link and scrolled down the page to see
the freshly generated access token:

<img src="/img/twitter_access_token.png" alt="Twitter access token" />

We need to copy the values of <b>Access token</b> and <b>Access token secret</b>
to the same `.twitter` file

```
[perlmaven]
api_key=
api_secret=
access_token=
access_token_secret=
```


The file with the data looks like this for me:

```
[perlmaven]
api_key=qWxMFY2n3fxvVUhL8AhkhUDAJ
api_secret=isBFDEPB6uHhsYzBO6BRvNFiKgF0s3AJt6sVi8AfzeI3d1Tz8n
access_token=384919287-EradZFtD9v8QtTaAvN3s3TMeABE9MD51Lk4aQDRP
access_token_secret=Hgk9F3O8ype62b65oehuDr3P2Z3BXaTxIy7wd7PI8NlpB
```

## The script - setup

The first part of the `twitter.pl` script deals with the configuration parameters.
We use [File::HomeDir](http://metacpan.org/pod/File::HomeDir) to locate the
home directory of the current user in a platform independent way. It works at least on Linux/Unix/OSX/Windows.

Then we use [Config::Tiny](https://metacpan.org/pod/Config::Tiny) to load the configuration file
we just created. As you can see the name and the location of the file is totally arbitrary. You could decide you
save the configuration file in any other directory using any other name.

The final step in this part of the code is the creation of the [Net::Twitter](https://metacpan.org/pod/Net::Twitter)
object. We 

```perl
use strict;
use warnings;
use 5.010;

use Net::Twitter;
use Config::Tiny;
use Data::Dumper qw(Dumper);
use File::HomeDir;

my $config_file = File::HomeDir->my_home . "/.twitter";
die "$config_file is missing\n" if not -e $config_file;
my $config = Config::Tiny->read( $config_file, 'utf8' );

my $nt = Net::Twitter->new(
    ssl      => 1,
    traits   => [qw/API::RESTv1_1/],
    consumer_key        => $config->{perlmaven}{api_key},
    consumer_secret     => $config->{perlmaven}{api_secret},
    access_token        => $config->{perlmaven}{access_token},
    access_token_secret => $config->{perlmaven}{access_token_secret},
);
```

## Getting the latest posts

Before attempting to post, let's see the how can we fetch what others have posted.

This snippet of code, will fetch the latest posts from your timeline, the latest posts people you follow made:

```perl
my $r = $nt->home_timeline;
foreach my $e (@$r) {
    say "$e->{user}{screen_name}:  $e->{text}";
}
```

`home_timeline` returns an array reference to hashes.
Each hash represents a tweet. Each hash has several keys, for example
<b>text</b> and <b>user</b>. The value of the former is a string, the content of the tweet, 
the value of <b>user</b> is a hash reference itself containing details about the user who posted
this update.

If the <b>text</b> contains hashtags (words staring with `#`, or mentions other users by prefixing their name with `@`,
or has a shortened URL (e.g http://t.co/jKxH3vWMuh ), then the hash also contains a key called <b>entities</b>
that describe those special values. For example providing more details about other Twitter accounts mentioned in this update,
or the original URL of a shortened URL.

`print Dumper $r;` can reveal all the details.


## Searching for Tweets

The next snippet will search for the string `perlmaven` and return the most recent tweets containing that string:

```perl
my $r = $nt->search('perlmaven');
foreach my $e (@{ $r->{statuses} }) {
    say "$e->{user}{screen_name}:  $e->{text}";
}
```

The `search` method returns a hash reference with two keys:
`search_metadata` holds a few key/value pairs describing this search,
`statuses` holds an array reference similar to the one returned by the
`home_timeline` method mentioned above.

`print Dumper $r->{search_metadata};`  or `print Dumper $r->{statuses}[0];`
can help see the details.


## Posting an update

Finally, let's see how to post an update:

```perl
$nt->update('Hello world! This is my first tweet using Net::Twitter, thanks to @perlmaven https://perlmaven.com/');
```

Unfortunately when we run the script, we get an error: `Read-only application cannot POST. at...,/hl>

If we go back to web site where we created the application (or just look at the screenshots above) you'll see
the application has `Access level Read-only`. Click on the `Permissions` tab to see 

<img src="/img/twitter_permissions.png" alt="Twitter Permissions" />

Select `Read and Write` and click on `Update settings`.

I got an error there:

<img src="/img/twitter_mobile_phone_needed_error.png" alt="Twitter mobile phone needed error" />

I tried it, I even saw the mobile carrier I use listed there, but in the end I got an error `Sorry, we don't have a connection to your carrier yet!`.
So I cannot change the permission of this application. I hope you will be able to do it.

Anyway, luckily, I already had another Application registered that already had read/write permissions. I think when I created that application
Twitter did not require the mobile phone number yet. Using the details of that application I managed to
[post this tweet](https://twitter.com/szabgab/status/470089503554535424).

