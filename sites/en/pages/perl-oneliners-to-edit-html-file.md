---
title: "A bunch of Perl one-liners to edit HTML files"
timestamp: 2019-02-16T10:00:01
tags:
  - ..
  - flip-flop
  - -n
  - -p
  - -i
  - -e
published: true
author: szabgab
archive: true
---


At one point I set up a Wordpress server to allow my sister to edit her own web site about [Yiddish and Yoga](http://verele.com/).
I thought I'll use it as a way to force myself learn the ins and outs of Wordpress and Wordpress hosting.

My sister learned how to use Wordpress and even managed to create her own pages, but after 4 years of neglecting to upgrade the server
I finally made the decision to convert the site to a bunch of static pages.


I used `wget` to retrieve the existing pages, but then I had to clean up the HTML to remove all the unnecessary tags used by Wordpress.
I also found out that some of the URLs were hard-coded in the page. I am not sure if that was my sisters doing or Wordpress, or just the fact
that I did not know how to properly configure the server.

Normally you'd never ever want to parse HTML with regexes. There are plenty of good HTML parsers on CPAN for that,
but for small cases they might work. Especially if you have the files in version control and if you can easily check each change
using a `git diff` or some similar command.

I used a bunch of Perl one-liners to clear up the HTML.

## find the html files

Each one of the following commands start with

```
find . -name "*.html"
```

that (on a Linux system) will find all the HTML files in the current directory `.` and its subdirectories.
On its own this command will print the names of the files on the screen.


## pipe to xargs

Then each command continues with `| xargs perl ...`.
The vertical line, the pipe symbol, tells the Linux shell to take the output of the command on the left hand side
and connect it to be the input of the command on the right hand side. So we piped the output of the `find`
command into the `xargs` command.

```
find . -name "*.html" | xargs perl
```

The `xargs` command will take its input and on each line it will run the `perl ...` command that follows it.
So in the following examples each `perl` command has a list of HTML filenames on its command line as if they would look:

```
perl .... file1.html file2.html file3.html
```

Let's see those Perl one-liners.

## Remove certain lines from a file

```
find . -name "*.html" | xargs perl -i -n -e 'print if $_ !~ m{ie8}'
```

* `-i` means in-place editing. That is, open the file and whatever the perl command prints write back into the same file we have on the command line.
* `-n` go over the lines of the file(s) on the command line in a `while` loop and on each iteration put the current line in `$_`.
* `-e` execute the following Perl statement. Because of the `-n` this statement is executed for every line in every file on the command line.

In our case that means every html file in this directory tree.

The Perl command itself will print every line that does not match the regex `ie8`. That is, every line that does not contain the string `ie8`.

I needed this, and a bunch of similar commands as the HTML generated by Wordpress had a bunch of special-case lines for Internet Explorer 8 and other similar
old and unused browsers and I wanted to get rid of those lines.


## Remove line with closing curly brace

After removing a bunch of lines I found out that I've removed some embedded CSS code, but there was a line (in each HTML file) with a single closing curly brace on it
that also had to be removed. I could not just remove all the lines with a closing curly brace as some (most) of those line had to stay in the files.
I only had a special case of a single closing curly brace alone on a line with some spaces before and after.

So I used the same expression as above with a slightly modified regex that says: print the lines that don't match the spaces-closing-curly-spaces pattern:

```
find . -name "*.html" | xargs perl -i -n -e 'print if $_ !~ m{\A\s*\}\s*\z}'
```

## Remove the URL prefix

As I looked at the content of the HTML files I noticed that many links refer back to the web site using its full URL.
This had a disadvantage during the transition phase but it is also problematic in the production site.

During transition, when I was trying to make sure I have downloaded every image, CSS file and JavaScript snippet,
these URLs kept loading some of the files from the original URL even though I was serving the site from a temporary URL.

Specifically: I have set up a new server called new.verele.com and wanted t make sure it works fine before shutting down the old server
with the Wordpress installation. However because some of images were loaded from http://verele.com/ I could not verify that everything works fine.
So I wanted to eliminate any absolute URLs.

In the real environment it is also problematic to have these links as that means I cannot easily move from http to https.

So in order to eliminate the problem I wanted to remove all the URL prefixes:

```
find . -name "*.html" | xargs perl -i -p -e 's{http://verele.com}{}g'
```

* `-p` is used instead of `-n`. It works similarly going over the lines of the file one-by-one and assigning them to `$_`, but after every line it automatically prints the content of `$_`. So it is a better tool when we would like to change (some of) the lines of the file, and not eliminate some.

The Perl expression is a simple substitution, replacing `http://verele.com` with an empty string. The `g` at the end tells the regex engine to repeat the operation as many times as it can. This was needed as some of the lines in the HTML file had multiple URL references in the same line.


## Remove range of lines

In the last example we go back to the `-n` operator and the `print` statement as here again we are removing some lines from the HTML file.
This time, however, we wanted to remove several consecutive lines. A whole section that started with a `div` element that had an id="comments" up till the line
that had #comments on it.

Perl has a wonderful tool for this, called the <b>flip-flop</b> operator `..`.

```
find . -name "*.html" | xargs perl -i -n -e 'print unless $_ =~ m{<div id="comments">} .. $_ =~ m{#comments}'
```

In this we have two regexes separated by the `..` flip-flop operator. The expression start to be true on the line
where the left-side expression is true and it keeps being true till the right hand expression becomes true. So this expression
can be used to remove several lines identified only by the first line and the last line.

## Comments

's{http://verele\.com}{}g' or 's{\Qhttp://verele.com}{}g'


