---
title: "What you need to know about CPAN"
timestamp: 2014-09-07T22:00:01
tags:
  - CPAN
published: true
author: szabgab
---


[CPAN](http://www.cpan.org/), the Comprehensive Perl Archive Network is the place where all the interesting Perl extension (libraries, modules) live.
This article collects some of the resources needed to understand what is CPAN and how to use it. Both as a "user" and as an "author".


## For users

[CPAN](http://www.cpan.org/) itself is just an ftp server holding files in a way that is convenient to the authors, but almost
unusable to users. Most people therefore use either Google, or one of the specialized search engines of CPAN. I recommend
you use [MetaCPAN](https://metacpan.org/).  You visit MetaCPAN and just type in something you are looking for.
Try giving words that might be part of the name of the module you are looking for, or part of the description of what it does.


There some extra tricks in using MetaCPAN. For example you can
[search for all Plack Middleware or Perl::Critic Policies](/listing-all-the-modules-in-a-namespace)
or you can [limit your search by distribution name, version number or author.](/metacpan-search-tricks)

<h3>Installing modules from CPAN</h3>

Once you found a module that you would like to install, you'll need to find out how to install it.

Before that though, you should probably understand that the unit of of installation is the "distribution" (a .tar.gz or sometimes .zip file)
for example [HTML-Form](https://metacpan.org/release/HTML-Form), while the unit of direct usage is a "module" (a .pm file).
(for example [HTML::Form](https://metacpan.org/pod/HTML::Form)). A single distribution can contain one or more modules.
(Well, it could also contain 0 modules, but that's rare.)

There is an article trying to explain the, sometimes overlapping, meaning of
[Packages, modules, distributions, and namespaces in Perl](/packages-modules-and-namespace-in-perl).

Two articles that you might find useful covering the process of module installation are:
* [Installing a Perl Module from CPAN on Windows, Linux and Mac OSX](/how-to-install-a-perl-module-from-cpan)
* [Install Perl modules without root rights on Linux Ubuntu 13.10 x64](/install-perl-modules-without-root-rights-on-linux-ubuntu-13-10)


## Contributors

You can contribute to a CPAN module without being an author. Without taking on the full responsibility of becoming a maintainer.
If you find a module on CPAN that has a bug that bothers you. Or one that you use, but a feature is missing. Or even if you have just
managed to understand how to use the module and would like to provide a few examples or some explanation.

If the module is currently maintained by someone you can usually "send a patch" to make that change.

This article and screencast might give you some ideas how to do that:

[Contributing to a Perl module on CPAN (using vim and Github)](/contributing-to-a-perl-module-on-cpan-using-vim-and-github)

## New authors

If you'd like to upload a module to CPAN you will need to create an account on [PAUSE](http://pause.perl.org/), The Perl Authors Upload Server.
Creating the account is a manual process, don't ask why it is the tradition. Anyway, you can click on "**Request PAUSE account**" link on that site,
fill out the form including the short explanation why you would like to have a PAUSE ID. Potential good answers include "I'd like to become the maintainer of module ABC"
and "I'd like to upload a module called ABC that will do DEF". Fill the placeholder with the appropriate information. You don't need to write an essay, but
the admins need to see you are not a bot.

The only thing that you won't be able to change late is the "Desired ID". That will become your "PAUSE ID". (For example my PAUSE ID is SZABGAB).
It is probably a good idea to check if the ID you are asking for isn't in use. You can check that by checking if the appropriate page exists on
MetaCPAN. For example [SZABGAB](https://metacpan.org/author/SZABGAB) is the link to my account.

As far as I know it can take up to a few weeks to on of the admins to approve the request, so don't leave this to the last minute.

Once you got your account approved, you are considered an author, and thus the rest is in the next section.

<!--

## Maintainers

There is a small distinction between the "original author" of a module (distribution) and the current maintainer.
-->

## Authors

If you'd like to discuss your plans for a new module there are two places for that: [PrePAN](http://prepan.org/),
and the [module-authors](http://lists.perl.org/list/module-authors.html) mailing list. The latter is also very good
for discussing on-going maintenance issues.

Assuming you already have a PAUSE account (or at least you have already requested one), you will need to create a "distribution" and upload it
The "distribution" is the tar.gz file, that CPAN authors upload to CPAN (or more precisely to [PAUSE](http://pause.perl.org/))
and that is the thing end-users download and install.

Some of the articles that will be relevant to you as an author:

[Minimal requirement to build a sane CPAN package](/minimal-requirement-to-build-a-sane-cpan-package)

[How to add images to the documentation of Perl modules on CPAN](/how-to-add-images-to-cpan)

[Adding list of contributors to the CPAN META files](/how-to-add-list-of-contributors-to-the-cpan-meta-files)

## Version Control

While it is not a requirement to have a public version control system (VCS) for your CPAN module, it is usually very useful. It allows others
to see your progress even between releases, it allows them to easily contribute to your effort and depending on which public VCS you are using
it makes it super-easy for you to integrate their contribution.
In the recent years Git became the de-facto leader for open source version control tools and [GitHub](https://github.com/) became the most popular site
where you can a have a public repository for your open source project. I'd strongly recommend you develop your perl module in such a repository.

It is also recommended to link to the public VCS from your module. You can add a link to the documentation of the module, but there is also a standardized way to do this
in the META files of the module. (or more precisely of the distribution.) Once you include the VCS link in your meta files, [MetaCPAN](https://metacpan.org/)
will be able to extract that information and display it next to your module. Having that link in the standard place will make it easier to anyone to contribute
to your work.

Here is an article that explains how can you do this:

[How to convince Meta CPAN to show a link to the version control system of a distribution?](/how-to-add-link-to-version-control-system-of-a-cpan-distributions)

Even if you don't have a public version control system, please use a private one.

## License

One of the key features of Open Source software is its license. There are certain [recommendations by TPF](http://www.perlfoundation.org/cpan_licensing_guidelines)
on how to add license information to your distribution, but one of the often overlooked aspect is to add the license to the META files. Again, to let MetaCPAN,
or any other program, easily extract it.

This article explains [how to add the license field to the META.yml and META.json files on CPAN](/how-to-add-the-license-field-to-meta-files-on-cpan).

## Caveat

This article is "in progress". I decided to share it in its current form as I think it already provides some valuable information.
If you'd like to get updates on this article and on plenty of other issues with Perl, make sure you subscribe to the
[newsletter](/perl-maven-newsletter). If you also would like to get the [Pro](/pro) articles and screencasts
(see the list in [the archive](/archive)) then go ahead and subscribe to the [Perl Maven Pro](/pro).

