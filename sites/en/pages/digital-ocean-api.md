---
title: "Digital Ocean API using Perl"
timestamp: 2021-04-19T07:50:01
tags:
  - DigitalOcean
published: true
author: szabgab
archive: true
show_related: true
---


I've been using [Digital Ocean](/digitalocean) for many years for some of my hosting needs. Besides the nice GUI they also have an API
and there is a Perl module called [DigitalOcean](https://metacpan.org/pod/DigitalOcean) that can be used to access it.


Before you get started you need to [generate a new Token](https://cloud.digitalocean.com/account/api/tokens).

Create a file called **.env** with the following content:
```
DIGITAL_OCEAN_TOKEN = THE_TOKEN
```

replacing **THE_TOKEN** by the token you generated.

Install the [DigitalOcean](https://metacpan.org/pod/DigitalOcean)
and the
[Dotenv](https://metacpan.org/pod/Dotenv)  modules:

```
cpanm DigitalOcean Dotenv
```

## List available images

This is a short example to **list the available images**:

{% include file="examples/digitalocean/list_images.pl" %}

## CLI

This is a longer example that will make it easy for you to list images, sizes, regions, ssh keys, or existing droplets.

It also allows you to create a new droplet. (That part currently has hard-coded values.)

This is currently primarily an experimental demo.

{% include file="examples/digitalocean/digitalocean.pl" %}

