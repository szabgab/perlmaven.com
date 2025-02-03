---
title: "Bitbucket Pipelines (the CI system) for Perl projects"
timestamp: 2021-10-25T10:30:01
tags:
  - Bitbucket
  - Pipelines
published: true
author: szabgab
archive: true
---


Bitbucket Pipelines (the CI system) for Perl projects


## Create a local git repository

## Create an empty repository on Bitbucket

## Enable Pipelines

You could visit the Pipelines entry on the web page and select a language, but I have not
seen Perl mentioned there so let's do it our way.

All you need to do is create a file called <b>bitbucket-pipelines.yml</b> with the proper content
and add it to the root of your repository and push it out to Bitbucket.

Sample content for the <b>bitbucket-pipelines.yml</b> file.

```
image: perl:5.26

pipelines:
  default:
    - step:
        script:
          - perl -v
```

Then visit the page of your repository on Bitbucket and click on the Pipelines entry on the left hand side.

<img src="/img/bitbucket_left_menu_pipelines.png" alt="" />

It will recognize your file, validate it, and ofer you to click on the "enable" button at the bottom of the
screen.

Once you did that everything is set. The pipeline will run every time you push out new code to your repository.

One strange thing is that despite having the bitbucket-pipelines.yml file already committed, Bibucket still added
an empty commit when I pressed the "enable" button. You'll have to pull it down to you local clone of the
repository.

## What is this configuration?

The above configuration tells Bitbucket to use the [Perl 5.26 Docker image](https://hub.docker.com/_/perl/)
and run `perl -v` on it. 

The listing of the results will looks something like this:

![](/img/bitbucket_pipelines_list_1.png)

If you click on the link you'll see the details:

![](/img/bitbucket_pipelines_results_1.png)

You can then click on the individual stages to see the output of each stage.

## Running a Perl script in the Bitbucket pipeline

For the next experiment we added a new file to the reposiitory called `try.pl` with the following content:

```
use strict;
use warnings;

exit(1);
```

and also changed the <b>bitbucket-pipelines.yml</b> file to execute the `try.pl` instead
of just showing the version number of Perl.

```
image: perl:5.26

pipelines:
  default:
    - step:
        script:
          - perl try.pl
```

Once we push this out to Bitbucket it will load the Docker image and run our script. The result looks like this:

![](/img/bitbucket_pipelines_2.png)

The pipeline reports failure as our script exited with 1 that indicates a failure. (0 indicates succcess any other number indicates failure.)

## Fixing the failure

Changing the `exit(1);` to `exit(0);`, commiting the code and pushing it out again.

This time the pipeline was succesful as you can also see in the listings:

![](/img/bitbucket_pipelines_3.png)


