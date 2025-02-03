---
title: "Cloud automation at Digital Ocean using Perl"
timestamp: 2014-09-22T23:30:01
tags:
  - Config::Tiny
  - DigitalOcean
  - Digital Ocean
published: true
author: szabgab
---


[Digital Ocean](/digitalocean) is awesome. Not only can you get a Linux machine for $5/month, but you can even pay them by the hour.
That means you can rent a Virtual machine with 16GB memory and 8 cores for an hour and pay only $0.238. That can be great to test something
or to use the machine to build your project.

Not only that, but they will even give you some money back if you use the [affiliate link](/digitalocean).

In this article you'll see a number of examples to automatically create a DigitalOcean Droplet using a Perl script.


## Setup

Before you can do any of these, you first need to [create an account](/digitalocean) where I think you need to provide
the Credit Card information for when they need to charge you money.

Once you have done that you need to visit the [Apps & API](https://cloud.digitalocean.com/settings/applications).
Because the CPAN module currently (version 0.09) only supports the old API of DigitalOcean you will need to follow the link
that leads to [API v1.0 Page](https://cloud.digitalocean.com/api_access). There you'll see a <b>Client ID</b>
and a big blue button <b>Generate new key</b>.  You need to click on that button. Then you'll have both a <b>Client ID</b>
and an <b>API Key</b>.

## Configuration

In order to avoid having this private information in the source code, I prefer to have a configuration file which won't
be in a version control system seen by many other people. So I created a file called <b>.digitalocean</b> in my home directory.
On Windows, I'd probably create a file called <b>digitalocean.ini</b>.

The configuration file does not need to be complex. Mine looks like this:

```
[one]
client_id = u0_CRTY7o6VabadsefeERTA
api_key   = 4564aa4ljada998dlkadljahelliaeak67cef
```

Then I can use [Config::Tiny](https://metacpan.org/pod/Config::Tiny) to read this information
and Data::Dumper just to see how it is read by this module.

```perl
use strict;
use warnings;
use 5.010;

use Config::Tiny;
use Data::Dumper qw(Dumper);

my $Config = Config::Tiny->read( '/home/gabor/.digitalocean', 'utf8' );
die Dumper $Config;
```

```
$VAR1 = bless( {
    'one' => {
           'client_id' => 'u0_CRTY7o6VabadsefeERTA',
           'api_key' => '4564aa4ljada998dlkadljahelliaeak67cef'
    }
}, 'Config::Tiny' );
```

<h>$Config` is a reference to a two dimensional hash. 'one' which was just an arbitrary
section name to hold the real data is a key in that hash reference. Its values is a
reference to another hash where the keys are client_id and api_key.

The constructor of the [DigitalOcean](https://metacpan.org/pod/DigitalOcean) module
requires us to pass the client_id and the api_key so we can write the following code:

```perl
my $do = DigitalOcean->new(%{ $Config->{one} });
```

`$Config->{one}` is a reference to a hash.  Here we de-reference that reference by putting
a `%` in-front of it.

## List running droplets

The new DigitalOcean object in the `$do` variable can be used to fetch all kinds of information from
Digital Ocean. For example `$do->droplets` will return an array reference with all the Droplets
we currently have.

We can iterate over that array, each element is an instance of [DigitalOcean::Droplet](https://metacpan.org/pod/DigitalOcean::Droplet)
with various attributes. For example a name, id, and ip_address

```perl
for my $droplet (@{$do->droplets}) {
    printf "Droplet %s has id %s and IP address %s\n", $droplet->name, $droplet->id, $droplet->ip_address;
}
```

The full script in case you'd like to try it:

```perl
use strict;
use warnings;
use 5.010;

use Config::Tiny;
use Data::Dumper qw(Dumper);
use DigitalOcean;


my $Config = Config::Tiny->read( '/home/gabor/.digitalocean', 'utf8' );
#die Dumper $Config;

my $do = DigitalOcean->new(%{ $Config->{one} });

for my $droplet (@{$do->droplets}) {
    printf "Droplet %s has id %s and IP address %s\n", $droplet->name, $droplet->id, $droplet->ip_address;
}
```

## Create a Droplet - skeleton

Listing the existing droplets is one thing, but it would be much better if we could the whole cycle:

<ol>
  <li>Create a droplet</li>
  <li>Do something on it</li>
  <li>Destroy the droplet</li>
</ol>

The documentation of the [DigitalOcean Perl module](https://metacpan.org/pod/DigitalOcean) has an example
to create a droplet:

```perl
my $new_droplet = $do->create_droplet(
    name => 'new_droplet',
    size_id => $size_id,
    image_id => $image_id,
    region_id => $region_id,
);
```

The question, what values can be passed to <b>size_id</b>, <b>image_id</b>, and <b>region_id</b>?


## Droplet sizes

If you visit the web-site of [Digital Ocean](/digitalocean) (DO) you'll see you can create Droplets
starting from one with 512Mb memory up to 64GB memory. The ,`sizes` method asks the DO API to list all the available
sizes. It returns a reference to an array, in which every element is a [DigitalOcean::Size](https://metacpan.org/pod/DigitalOcean::Size) object:

```perl
my $sizes = $do->sizes;
foreach my $s (@$sizes) {
    printf "%6s  %s  %5s\n", $s->name, $s->id, $s->slug;
}
```

The result of the above code looks like this:

```
 512MB  66  512mb
   1GB  63    1gb
   2GB  62    2gb
   4GB  64    4gb
   8GB  65    8gb
  16GB  61   16gb
  32GB  60   32gb
  48GB  70   48gb
  64GB  69   64gb
``` 

From this table we can see that 66 is the ID of the smallest droplet.

## Droplet images

The next thing is to list the images. We can use the `images` method for this. Like above, this too returns
a reference to an array in which the elements are instances of [DigitalOcean::Image](https://metacpan.org/pod/DigitalOcean::Image).

```perl
my $images = $do->images;
foreach my $img (@$images) {
    printf "%-10s %7s  %-50s - %s\n", $img->distribution, $img->id, $img->name, ($img->slug || '');
}
```

Running this code will print the following output:
(I had to use an empty string as the default for the slug, as it is missing for some of the entries.)
 
```
Ubuntu      904632  basic                                              - 
CentOS        1601  CentOS 5.8 x64                                     - centos-5-8-x64
CentOS        1602  CentOS 5.8 x32                                     - centos-5-8-x32
Fedora     3102721  Fedora 19 x32                                      - fedora-19-x32
Fedora     3102879  Fedora 19 x64                                      - fedora-19-x64
CentOS     3448641  CentOS 6.5 x64                                     - centos-6-5-x64
CentOS     3448674  CentOS 6.5 x32                                     - centos-6-5-x32
CentOS     4856048  CentOS 7.0 x64                                     - centos-7-0-x64
CoreOS     6168550  CoreOS 440.0.0 (beta)                              - coreos-beta
CoreOS     6198091  CoreOS 444.0.0 (alpha)                             - coreos-alpha
CentOS      376568  CentOS 6.4 x32                                     - centos-6-4-x32
CentOS      562354  CentOS 6.4 x64                                     - centos-6-4-x64
Debian     5562742  Debian 7.0 x64                                     - debian-7-0-x64
Debian     5562760  Debian 7.0 x32                                     - debian-7-0-x32
Debian     5562916  Debian 6.0 x32                                     - debian-6-0-x32
Debian     5563026  Debian 6.0 x64                                     - debian-6-0-x64
Ubuntu     5566684  Ubuntu 10.04 x32                                   - ubuntu-10-04-x32
Ubuntu     5566812  Ubuntu 10.04 x64                                   - ubuntu-10-04-x64
Ubuntu     5588928  Ubuntu 12.04.5 x64                                 - ubuntu-12-04-x64
Fedora     3243143  Fedora 20 x32                                      - fedora-20-x32
Fedora     3243145  Fedora 20 x64                                      - fedora-20-x64
Ubuntu     5141286  Ubuntu 14.04 x64                                   - ubuntu-14-04-x64
Ubuntu     5142677  Ubuntu 14.04 x32                                   - ubuntu-14-04-x32
Ubuntu     5588929  Ubuntu 12.04.5 x32                                 - ubuntu-12-04-x32
Ubuntu     5505940  Django on Ubuntu 14.04                             - django
Ubuntu     4261622  Ruby on Rails on Ubuntu 14.04 (Nginx + Unicorn)    - ruby-on-rails
Ubuntu     5505824  node-v0.10.30 on Ubuntu 14.04                      - node
Ubuntu     5506000  LAMP on Ubuntu 14.04                               - lamp
Ubuntu     5506010  LEMP on Ubuntu 14.04                               - lemp
Ubuntu     5507160  MEAN on Ubuntu 14.04                               - mean
Ubuntu     5529453  Dokku v0.2.3 on Ubuntu 14.04 (w/ Docker 1.1.2)     - dokku
Ubuntu     4869208  Redmine on Ubuntu 14.04                            - redmine
Ubuntu     4991187  WordPress on Ubuntu 14.04                          - wordpress
Ubuntu     5899797  Ghost 0.5.1 on Ubuntu 14.04                        - ghost
Ubuntu     5900200  Docker 1.2.0 on Ubuntu 14.04                       - docker
Ubuntu     5900654  GitLab 7.2.1 CE on Ubuntu 14.04                    - gitlab
Ubuntu     5977624  Drupal 7.31 on Ubuntu 14.04                        - 
```

These are the currently available Operating System images that we can use to create our Droplets.
As we can see <b>5141286</b> is the ID of the <b>Ubuntu 14.04 x64</b> image.

## Regions

Digital Ocean has several server farms, they call them "Regions". When creating a droplet we also have
to decide in which region we would like to create it. The `regions` method returns an array
reference os [DigitalOcean::Region](https://metacpan.org/pod/DigitalOcean::Region) objects
that represent the currently available regions.

```perl
foreach my $r (@{ $do->regions }) {
    printf "%2s  %-15s - %s\n", $r->id, $r->name, $r->slug;
}
```

The results of the above code can be seen here:

```perl
 2  Amsterdam 1     - ams1
 3  San Francisco 1 - sfo1
 4  New York 2      - nyc2
 5  Amsterdam 2     - ams2
 6  Singapore 1     - sgp1
 7  London 1        - lon1
 8  New York 3      - nyc3
 9  Amsterdam 3     - ams3
```

So the ID of the "Singapore 1" server farm is 6.


## Create a Droplet - with values

Now that we have these 3 tables we can call again the `create_droplet` method:

```perl
my $server = $do->create_droplet(
    name       => 'demo1',
    size_id    => 66,
    image_id   => 5141286,
    region_id  => 6,
);
```

This will create a 512 Mb droplet with an Ubuntu 14.04 x64 image in Singapore 1.
It will launch the VPS and send an e-mail with the  IP address and the root password.

We can now manually check our e-mail, ssh to the droplet, do whatever we need to do
and then we can visit the list of [droplets](https://cloud.digitalocean.com/droplets)
and manually destroy it.

We have made some progress, but we need to improve our code.

## Use SSH keys

Digital Ocean allows us to upload public keys to their server, and when we create a new droplet
the public key will be automatically copied to `/root/.ssh/authorized_keys`. That means
we only need to know the IP address of the new Droplet and we can ssh to it without any password.
It is both safer (the password does not travel through the Internet in a clear-text email),
and simpler.

If I understood it correctly the API allow us to upload the SSH key, but I don't think I need to automate
that. After all, I only need to upload my key once. So I visited the
[SSH Keys](https://cloud.digitalocean.com/ssh_keys) menu option, clicked on the big blue button that say
<b>Add SSH Key</b> entered a name (just for identification in case there are several SSH keys) and copied the
content of `~/.ssh/id_rsa.pub` from my own machine.

Then I had to write some code to get the DigitalOcean ID of this SSH key.
The `ssh_keys` method is needed that returns an array reference of 
[DigitalOcean::SSH::Key](https://metacpan.org/pod/DigitalOcean::SSH::Key) objects.

```perl
foreach my $ssh (@{ $do->ssh_keys }) {
    printf "%s   %s \n", $ssh->id, $ssh->name;
}
```

The output listing the ID and name of my only public SSH Key:

```
56534   gabor
```

## Waiting for Digital Ocean

There is one more thing to do. By default the `create_droplet` method returns immediately. This can
be useful to avoid code that is blocking for a long time. That means our script keeps running even though the droplet is
not ready yet. That can be good, but in that case we will need to poll the DO API to see if the Droplet is ready.

The alternative is to pass `wait_on_event => 1,` to the `create_droplet` method. With that parameter
the method will block till the Droplet is ready to be used.

## Create a Droplet - for real

Here is the code that will create our desired Droplet. I even added a timestamp before and after the `create_droplet` call.
It showed me that this call takes about 60 seconds to finish.

```perl
my $t0 = time;
my $droplet = $do->create_droplet(
    name          => 'demo1',
    size_id       =>  66,
    image_id      => '5141286',
    ssh_key_ids   => 56534,
    region_id     => 6,
    wait_on_event => 1,
);
my $t1 = time;
say $t1-$t0;
```

Once the Droplet is ready we can print the details:

```perl
say $droplet->id;
say $droplet->name;
say $droplet->ip_address;
```

but unfortunately the ip_address is not included. (It will contain undef.)

In order to fetch the IP address of the newly created Droplet we have to make another call:

```perl
my $server = $do->droplet($droplet->id);
say $server->id;
say $server->name;
say $server->ip_address;
```

The `droplet` method receives the ID of a droplet and returns a 
[DigitalOcean::Droplet](https://metacpan.org/pod/DigitalOcean::Droplet) object
that already contains the <b>ip_address</b>


## SSH to the new Droplet

Given the IP address we could already SSH to the remote server, but there is a slight problem.
When we ssh to a new IP address, the ssh command of Linux and OSX will ask if we really want to
add the IP address to the list of known hosts. This would kill the automation. Luckily we can
tell ssh to avoid this question by passing `-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no` to it.

The full example looks like this:

```perl
my $cmd = sprintf 'ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@%s "uname -a; uptime; hostname"',  $server->ip_address;
say $cmd;
system $cmd;
```

Here we create the SSH command (and print it). We ssh to user 'root' on the remote machine and then execute these command:
`uname -a; uptime; hostname` just to see we are really on the new machine.

## Destroy the Droplet

Finally, as we don't need the droplet any more we just call the `destroy` method and that will shut-down and wipe clean the disk.

```perl
$server->destroy;
```

## Full working example

```perl
use strict;
use warnings;
use 5.010;

use Config::Tiny;
use Data::Dumper qw(Dumper);
use DigitalOcean;


my $Config = Config::Tiny->read( '/home/gabor/.digitalocean', 'utf8' );
my $do = DigitalOcean->new(%{ $Config->{one} });

my $t0 = time;
my $droplet = $do->create_droplet(
    name       => 'demo1',
    size_id    =>  66,
    image_id   => '5141286',
    ssh_key_ids => 56534,
    region_id  => 6,
    wait_on_event => 1,
);
my $t1 = time;
say $t1-$t0;
#say $droplet; DigitalOcean::Droplet
say $droplet->id;
say $droplet->name;
say $droplet->ip_address;

my $server = $do->droplet($droplet->id);
say $server->id;
say $server->name;
say $server->ip_address;

my $cmd = sprintf 'ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@%s "uname -a; uptime; hostname"',  $server->ip_address;
say $cmd;
system $cmd;

$server->destroy;
```

## Setting up a web application?

In another article I've described how to [get started with Perl Dancer on Digital Ocean](/getting-started-with-perl-dancer-on-digital-ocean).
You can now combine the two articles and create a script that will create a Droplet and set up a Dancer-based web application.

## Comments

Great article thanks Gabor

<hr>

Gabor - have always loved your work. FYI - DO has APIv2 now and there's a new CPAN library available. https://www.digitalocean.com/community/projects/webservice-digitalocean and

WebService::DigitalOcean
