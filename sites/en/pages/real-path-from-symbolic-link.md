---
title: "Get real path (absolute path) from symbolic link (aka. softlink)"
timestamp: 2020-04-09T07:30:01
tags:
  - readlink
  - ls -l
  - ln
  - abs_path
  - Cwd
published: true
author: szabgab
archive: true
---


On Linux/Unix/Mac systems one can create symbolic links (aka. softlinks) to a file or a directory using the
<b>ln -s TARGET</b> or <b>ln -s TARGET LINK</b>.

Behind the scenes a symbolic link is just a file that has the TARGET as the content.

If we open a symbolic link (e.g. using some text editor or <b>cat</b>) we see the content of the TARGET,
where the link points to.

How can we see the relative or absolute path to the TARGET?


## Create symbolic links

As an example I created a directory and in that directory I ran:

```
touch data
ln -s /etc/group
ln -s /etc/passwd secrets
ln -s ../work/perlmaven.com/sites
```

The first command created a plain file.

The second command created a symbolic link to <b>/etc/group</b> called <b>group</b>.

The third command created a symbolic link to <b>/etc/passwd</b> called <b>secrets</b>.

the 4th command created a symbolic link to <b>../work/perlmaven.com/sites</b> (which is a relative link) called <b>sites</b>.

If we run <b>ls</b> in this directory we see: <b>data  group  secrets</b>.
Based on this we don't know which might be a real file and which is a symbolic link.

We could use <b>cat</b> on each one of them and we would see the content of the "data" file
and the content of the <b>/etc/group</b> and <b>/etc/passwd</b> files respectively.

So how can we know which is a symbolic link and where do those links lead? What is their TARGET?

On the command line if we run <b>ls -l</b> we can see the symbolic links
and their TARGET on the right, after an arrow:

```
-rw-r--r-- 1 gabor gabor  0 Apr  9 10:16 data
lrwxrwxrwx 1 gabor gabor 10 Apr  9 10:17 group -> /etc/group
lrwxrwxrwx 1 gabor gabor 11 Apr  9 10:17 secrets -> /etc/passwd
lrwxrwxrwx 1 gabor gabor 27 Apr  9 10:37 sites -> ../work/perlmaven.com/sites/
```

We can also note that the first character on each row of a symbolic link is an <b>l</b> that also
indicates that these are symbolic links.

## How can I get the target of a symnlink in Perl?

If we open the file with the regular <b>open</b> function we will get access to the target.

The <b>readlink</b> function, however, will return the target. If there is any.

So here is a sample implementation:

{% include file="examples/symlinks.pl" %}

And the result if I run <b>perl ~/work/perlmaven.com/examples/symlinks.pl .</b>:

```
sites -> ../work/perlmaven.com/sites
group -> /etc/group
data
secrets -> /etc/passwd
```

Once you have the relative path to the target you can use the <b>abs_path</b> function from the <b>Cwd</b> module to get the absolute path.

{% include file="examples/symlinks_abs.pl" %}

<b>perl ~/work/perlmaven.com/examples/symlinks_abs.pl .</b>

```
sites -> /home/gabor/work/perlmaven.com/sites
group -> /etc/group
data
secrets -> /etc/passwd
```

