---
title: "Bitbucket pipelines with Perl and MySQL"
timestamp: 2018-01-01T07:30:01
tags:
  - DBD::mysql
published: false
author: szabgab
archive: true
---


If you have an application in Perl that uses MySQL and you with to use [BitBucket Pipelines for your Perl project](/bitbucket-pipelines-for-perl-projects) then this example might help you set up MySQL as well.


Bitbucket uses Docker images so the recommended way is to use a separate Docker image for mysql and to configure it as a service for the pipeline.

This is a version of the <b>bitbucket-pipelines.yml</b> file that worked for me:

{% include file="examples/bitbucket_mysql_57/bitbucket-pipelines.yml" %}

Here the main Docker image where our code will run is called <b>perl:5.26</b> from [Docker HUB](https://hub.docker.com/_/perl/).

Though given that this is a hash, the order does not matter, but I think it is more logical to have the <b>definitions</b> next.
In there we define a service called <b>mysql</b>



{% include file="examples/bitbucket_mysql_57/check_mysql.pl" %}

[MySQL on Docker HUB](https://hub.docker.com/_/mysql/)
