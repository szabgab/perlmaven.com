---
title: "Enable Appveyor (CI on Windows) for the Perl 5 Markua Parser"
timestamp: 2018-03-15T21:30:01
tags:
  - Markua
published: true
author: szabgab
archive: true
---


[Travis-CI](/travis-ci-for-markua-parser) runs the test on a Linux box and I think it could also run on OSX, but I never tried that. [Appveyor](https://www.appveyor.com/) on the other hand is a cloud-based Continuous Integration that runs your tests on MS Windows. (Actually I just saw an e-mail from them inviting me to try their Linux servers as well. For now let's stick to the Windows machines.)

The Markua parser should have no platform dependent part. So our could is expected to run on MS Windows as well. I only have an old Windows 7 at home and I'd avoid using it. Luckily Appveyor can provide the platform to test the code.


## Enable Appveyor

Visit [Appveyor](https://www.appveyor.com/), click on "Sign up for free".
Here I've created my own account by typing in my name, e-mail address and a password.

Then I clicked on the "+ New Project" link, selected Github, I think back when I first did this
I had to authenticate at GitHub at this point, but now it just lists all the project I have.

I searched for perl5-markua-parser and as I hovered over the name the "+ add" link appeared
on the right hand side. Clicking that I told Appveyor to start monitoring the project.


## Configure Appveyor

In order to tell Appveyor what to do you need to create a file called `appveyor.yml` or
`.appveyor.yml` (with a leading dot). It needs to include some instructions installing
[Strawberry Perl](http://strawberryperl.com/), installing any prerequisites, and then
running the tests with `gmake test`.

The full file can be seen here: {% include file="examples/markua-parser/6564d15/.appveyor.yml" %}.appveyor.yml</a>.

```
$ git add .appveyor.yml
$ git commit -m "add appveyor configuration file"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/6564d15bf98c0fe5ee08d34fbc36bea92e4e0c29)

Once I pushed out the changes both Travis and Appveyor started to build the project. Coveralls was updated by Travis
and we got an e-mail from Appveyor:

<img src="/img/markua-parser-appveyor-first-mail.png" alt="Appveyor success e-mail" />

To tell the truth this is the first project where I manage to get Appveyor succeed in the first attempt. In many cases
the project did not even started to run.
The success is probably due to the fact that the project itself is really simple. So if Appveyor fails for you don't worry. It might take some tweaking in the appveyor.yml and in your code till the tests starts to pass.

The link in the e-mail leads to the full report of the process:
[appveyor build report](https://ci.appveyor.com/project/szabgab/perl5-markua-parser/build/1.0.1)

## Appveyor Badge

There is a canonical link to the [latest report](https://ci.appveyor.com/project/szabgab/perl5-markua-parser), but even there I could not see any recommendation on how to add an Appveyor badge to my project. Luckily I already have it in a few of my projects so I copied it from one of them, tweaked it to refer to the current project and added this to the README.md file:

```
[![Build status](https://ci.appveyor.com/api/projects/status/github/szabgab/perl5-markua-parser?svg=true)](https://ci.appveyor.com/project/szabgab/perl5-markua-parser/branch/master)
```

The new file is this: 
{% include file="examples/markua-parser/d370818/README.md" %}

Then the usual:

```
$ git add .
$ git commit -m "add Appveyor badge"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/d3708181fc8934d7c0d2e0bd2abbd58c702c2903)

If you visit the project now [perl5-markua-parser](https://github.com/szabgab/perl5-markua-parser) and scroll down where the content of the README.md is displayed then you will see the badges. (By the time you visit it, you might see additional badges. So don't be surprised.


Now that we have enabled Continuous Integration both on Linux and on Windows, and we also monitor our test coverage
we can proceed with the actual code.

