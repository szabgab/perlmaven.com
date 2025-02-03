---
title: "Bitbucket Pipelines testing Perl projects"
timestamp: 2021-11-01T07:30:01
tags:
  - Bitbucket
  - make
  - Test::More
  - cpanm
published: true
author: szabgab
archive: true
---


We saw how to [get started with Bitbucket Pipelines for Perl](/bitbucket-pipelines-for-perl-projects).
The same can be used to run any perl code on Bitbucket, but in our next step we'll see how to run the tests
of a [Perl module with standard layout](/distribution-directory-layout).


For this we needed a [Makefile.PL](/packaging-with-makefile-pl), a module in the `lib` directory
and a test file in the `t/` directory. (You can read a lot more about [tesing Perl code](/testing))

The really interesting part is the content of the `bitbucket-pipelines.yml` file that lists the 3 steps
we usually run to prepare a module for testing and then running the tests.

```
image: perl:5.26

pipelines:
  default:
    - step:
        script:
          - perl Makefile.PL
          - make
          - make test
```

## Adding dependencies

In the first case I only used standard module in my code. That is, modules that are available in every decent installation of Perl. For the next step I added a module called Path::Tiny that is only available form CPAN.

I've included a `use Path::Tiny;` in the module and also added Path::Tiny to the list of dependencies we maintain in Makefile.PL. When I pushed the changes out Bitbucket reported that the pipeline failed at the `make test` stage
when we tried to load our module with the missing dependency.

We need to install the dependencies on the Docker image before running our tests.

On our own development machine we would use `cpanm --installdeps .` and so will we do in the pipeline.
We only ned to add that as an entry in the scripts.

```
image: perl:5.26

pipelines:
  default:
    - step:
        script:
          - cpanm --installdeps .
          - perl Makefile.PL
          - make
          - make test
```

After commit this change and pushing it to Bitbucket the pipeline runs fine.


## Comments

Did you ever do an article on how to do this for GitHub?


