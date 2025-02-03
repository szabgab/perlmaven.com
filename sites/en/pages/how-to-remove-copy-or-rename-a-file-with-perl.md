---
title: "How to remove, copy or rename a file with Perl"
timestamp: 2012-08-24T14:45:19
tags:
  - unlink
  - remove
  - rm
  - del
  - delete
  - copy
  - cp
  - rename
  - move
  - mv
  - File::Copy
published: true
books:
  - beginner
author: szabgab
---


Many people who come from the world of <b>system administration</b> and Unix or Linux scripting,
will try to keep using the regular unix commands of <b>rm</b>, <b>cp</b> and <b>mv</b>
for these operations. Calling them either with back-tick or with <b>system</b>,
even when writing Perl scripts.

That works on their current platform, but that gives up one of the key benefits
Perl brought to the world of Unix system administration.

Let's see how can we execute these operations with Perl in a platform-independent way,
and without <b>shelling out</b>.


## remove

The name of the respective built-in function in perl is `unlink`.

It removes one or more files from the file system.
It is similar to the `rm` command in Unix or the `del` command in Windows.

```perl
unlink $file;
unlink @files;
```

It uses `$_`, [the default variable of Perl](/the-default-variable-of-perl) if no parameter is given.

For full documentation see [perldoc -f unlink](http://perldoc.perl.org/functions/unlink.html).

## rename

Renames or moves a file. Similar to the `mv` command in Unix and `rename` command in DOS/Windows.

```perl
rename $old_name, $new_name;
```

As this does not always work across file systems the recommended alternative is the
`move` function of the `File::Copy` module:

```perl
use File::Copy qw(move);

move $old_name, $new_name;
```

Documentation:

[perldoc -f rename](http://perldoc.perl.org/functions/rename.html).

[perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).

## copy

There is no built-in copy function in core perl. The standard way to copy a file is
to use the `copy` function of File::Copy.

```perl
use File::Copy qw(copy);

copy $old_file, $new_file;
```

This is similar to the `cp` command in Unix and the `copy` command in Windows.

For documentation visit [perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).

## Comments

Hi!

Thanks for sharing this. It's really useful .I'm developing a site that handles a couple of files and when I try to delete and rename one of the files it simply doesn't work (while with other script with no mojolicious stuff it's working properly. Do you know if mojolicious is not letting me delete files on my computer for security reasons?

Greetings.

---

The browser enforces security by running your script in a sandbox.

<hr>

If using literal string with a dot (.) in the name, use quotes:

    rename "myFile.dat", "Your.fil";

Works in Redhat Linux.
---
This is perl ... all strings are quoted.

<hr>

Hello there,

I need some help with the following:

1. I have to get the hostname of a vm using ssh IPv4 and import it into /etc/hosts file.

2. I'm using the following perl script command to get the host name:

ssh -t $ip hostname > $local_instance_session_log_dir/$ip

it returns a file name: IPv4 (ie: 10.10.1.2) containing the hostame (ie: vm_name), which is good, I guess..
Now, I want to create a file named "hosts" containing the "IPv4 TAB|SPACEBAR hostname" line by line to include it into to "/etc/hosts" so I can later include all VMs IPv4 and Hostnames as of:
1. file: hosts
2. IPv4 10.10.1.2
Note: the "ssh $ip" command works only one way: from one vm machine to all other into VMs into the local network. I can't scp back from any of the remote VMs machines.

