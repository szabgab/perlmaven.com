---
title: "Building a static blog using Blio and Github"
timestamp: 2013-03-28T14:30:01
tags:
  - Blio
  - blog
  - Github
published: true
author: szabgab
---


Blio is a simple static blogging engine written by [Thomas Klausner](http://domm.plix.at/) (aka. domm).
If you'd like to build your own site, you can use this together with Github and you get free hosting.

As of this writing Blio has not been released to CPAN yet, and it has some rough edges, but if you are the
adventurous type, here you will see how to set it up.


## Getting from Github

As I mentioned Blio, has not been released yet so the way to install
it is to get the latest version from [Github](https://github.com/domm/Blio).

If you have git installed you can use `git clone git://github.com/domm/Blio.git` to fetch
the latest version. Alternatively, there is a button <b>ZIP</b> on the
[Github page of Blio](https://github.com/domm/Blio). You can download the latest version
of the source code using that button, and then you can unzip it.

## Installing Prerequisites

Blio uses [Dist::Zilla](http://dzil.org/) for packaging so probably the best thing is to
first install Dist::Zilla using `cpanm Dist::Zilla`.
Then you can type `dzil install`. It will install all the pre-requisites and Blio itself as well.

Alternatively, you can install the following modules, that are the pre-requisites of Blio:

```
DateTime
DateTime::Format::ISO8601
DateTime::Format::RFC3339
Digest::SHA1
Encode
File::Copy
File::ShareDir
File::Temp
Imager
Markup::Unified
Module::Build
Module::Pluggable
Moose
Moose::Util::TypeConstraints
MooseX::Getopt
MooseX::SimpleConfig
MooseX::Types::Path::Class
namespace::autoclean
Path::Class
Path::Class::Iterator
Template
Test::File
Test::Most
XML::Atom::SimpleFeed
```


Once you have installed everything you can go ahead and build your first site:

## Simple setup

Create an empty directory, let's call it <b>perl_blog</b>.

Inside the <b>perl_blog</b> directory, you have to create a file called <b>blio.ini</b>.
It can be empty, but it must exist. (If using a Linux system, you can just type <b>touch blio.ini</b>.)

In addition, create a subdirectory called <b>src</b> and create a file called <b>src/index.txt</b>
with the following content:

```
title: Experimenting with Blio

Hello world
```

Pay attention that the filename is all lower case. The extension is <b>.txt</b>.
The first part of the file is the header, there are more parts of it but, the title is required. After the empty line comes the content of the page.

Once you have this you can run <b>blio.pl</b> (while being in the perl_blog directory) that was installed when you installed Blio.
It will create a directory called <b>out</b> and a file called <b>index.html</b> that was generated from the index.txt file.

The directory layout looks like this now:

```
 |-- perl_blog
     |-- blio.ini
     |-- src
         |-- index.txt
      -- out
         |-- index.html
```

You can now open the html file using your favorite web browser.

While this is a very simple "blog" so far, let's create a Github repository for the source of this site and then we can see
how to deploy the site to Github.

## Create Git repository for the source

The <b>out</b> directory should not be in the source repository so let's remove it for now: `rm -rf out`
Create a git repository `git init`. Add all the necessary files: `git add blio.ini src` and commit this:
`git commit -m "initial version"`.

Optionally you can create a Github repository for this project and push it there. I have created one called
[perl_blog_with_blio](https://github.com/szabgab/perl_blog_with_blio). You can check it out to see the
history of this article as well.

## Deployment to Github

Github allows you to create a static web site driven from a repository in several ways. The one I am showing
now is the nicest.
You can create a github repository called USERNAME.github.com (where USERNAME is your username on Github) and
it will be accessible as http://USERNAME.github.com/. Not only that, but you can even ask Github to serve the
same pages when someone visits www.yourdomain.com.

In my case, I created a directory next to the perl_blog directory called <b>szabgab.github.com</b>. That directory
will contain all the files needed on the web site. Both the generated files and other static files (e.g. CSS).

Now you can run `blio.pl --output_dir ../szabgab.github.com` (replacing szabgab with your username).
That will generate the index.html file in the target directory and you will get this layout:

```
 |-- some_directory
     |-- perl_blog
         |-- blio.ini
         |-- src
             |-- index.txt
     |-- szabgab.github.com
         |-- index.html
```

In order to eliminate the need to pass the output_dir parameter every time you can add it to the blio.ini file
like this:

```
output_dir=../szabgab.github.com/
```

Now go over to the output directory (`cd ../szabgab.github.com`), create a git repository there too,
create a Github repository called USERNAME.github.com (with you username!) and push the local repository out.
Mine is called [szabgab.github.com](https://github.com/szabgab/szabgab.github.com).
At this point, it has a single file called index.html in its root.
(By the time you look at the repository there will be more files in my repository, but as a start there is only this one).

Once you pushed the output repository to Github you can got and drink a tea, or you can visit your favorite social network
and share this article. In any case, Github needs a few minutes till it makes your site live.

After the break you can visit http://USERNAME.github.com/ and see the result. It is not very pretty, but it works!

## Setting up a domain name

In order to avoid loosing your incoming links when you move your site to some other place, I strongly recommend
setting up your own domain. It only costs 10-20 USD/year. A very good investment.

Once you have a domain you can set it up to point to Github and tell github to serve your pages when someone
is accessing Github via that domain. For this you need to tell your DNS provider to point your host names
to Github and you have to add a file called <b>CNAME</b> in your repository (containing the output files)
with the hostname as the content.

As I only use the [Github Pages](http://pages.github.com/) for these experiments, I will use
a hostname in my personal domain. So I set up github.szabgab.com to point to the github server as
described in [Setting up a custom domain with Github Pages](https://help.github.com/articles/setting-up-a-custom-domain-with-pages)
and added a file called CNAME with one line in it: <b>github.szabgab.com</b>.

After another tea (and some more sharing of this article) you can check visit USERNAME.github.com again. It will automatically
redirect to the hostname you set up and it will show the same demo page we created.

In my case you try [szabgab.github.com](http://szabgab.github.com/) that will redirect to [github.szabgab.com](http://github.szabgab.com/).

## More and nicer pages

Obviously this is only the first step in creating your on blog, but I hope this little tutorial will help you get started.
You can read more details about Blio in its documentation. Both [blio.pl](https://github.com/domm/Blio/blob/master/bin/blio.pl)
and [Blio.pm](https://github.com/domm/Blio/blob/master/lib/Blio.pm) have some documentation.

If you have any question, comments, don't hesitate to post them here and don't forget to share this article.
If enough people share it, I'll consider myself encouraged to extend the article...


