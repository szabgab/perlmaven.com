---
title: "GitLab CI Pipeline for Perl DBD::Mock using Module::Build"
timestamp: 2020-11-20T07:30:01
tags:
  - GitLab
  - CLI
  - DBD::Mock
  - Module::Build
published: true
author: szabgab
archive: true
description: "Annotated explanation of a GitLab CI Pipeline for the Perl DBD::Mock module that uses Module::Build"
show_related: true
---


[GitLab](https://gitlab.com/) provides an integrated [CI system](/ci) that is driven by a single [YAML](/yaml) based configuration.
This example is based on the configuration file of the [DBD::Mock](https://metacpan.org/pod/DBD::Mock) module.

I have copied it here and removed some of the repetitions. Visit the repo of that project to see the file they have.


The only thing you need to enable a GitLab Pipeline is to create a correctly formatted YAML  file called
**.gitlab-ci.yml** in the root of your git repository. And push it out to GitLab.

## GitLab CI Pipeline of DBD::Mock

{% include file="examples/gitlab/dbd-mock/.gitlab-ci.yml" %}

## stages

```
stages:
  - test
```


They declare a single stage called "test". Strictly speaking this is unnecessary as by default GitLab CI provides three
[default stages](https://docs.gitlab.com/ee/ci/yaml/#stages): "build", "test", and "deploy" and if a stage is not
implemented GitLab won't complain.


## before_script

The global **before_script:** key lists 4 commands that will run in each one of the jobs. In this file there are 3 jobs further below
called unitTestsLatest, unitTestsV5.30, and unitTestsV5.28. In the original file there were many more.

Slightly confusingly some of the main keys of the GitLab CI config files are reserved words that are
[not available as job names](https://docs.gitlab.com/ee/ci/yaml/#unavailable-names-for-jobs).
In our example we saw two: **stages** and **before_script**.

This project is apparently using [Module::Build](https://metacpan.org/pod/Module::Build) and so before the actual tests
the CI installs Module::Build and a few other prerequisites needed to run the release of the module.
Interestingly it also installed a specific version of [DBI](https://metacpan.org/pod/DBI) using the '@' notation. It installs 1.627 while the current most recent version is
1.643.

Then, using the **--installdeps** flag of cpanm, all the prerequisites are installed and the regular sequence of preparing the build is executed.


## The jobs

All the 3 jobs here, and all the other 15 or so I have removed for clarity, are almost identical. The only difference is the version of the
perl base image they use. So basically these 3 will use 3 different versions of the official [perl Docker image](https://hub.docker.com/_/perl)
to run the code.

The names of the jobs in GitLab CI can be arbitrary (except of the few reserved words), they can even include spaces and dots.
Each job declares which Docker image (and which tag) to use.
They each declare which stage they are in. This is also slightly unnecessary in this case because "test" is assumed to be the default stage
for every job that does not explicitly say it. (This is regardless of what stages are actually available in the pipeline.)

The "script" part is required.

What I understand from this is that for some reason the author of DBD::Mock wanted to test the code on version 1.627 of DBI as well as the most recent
recent version of DBI. No idea why it is necessary, but I like the idea and the implementation.


