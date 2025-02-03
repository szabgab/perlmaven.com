---
title: "Levels of security using (R)?ex"
timestamp: 2014-11-14T07:30:01
tags:
  - Rex
  - DevOps
  - ssh
published: true
author: szabgab
---


Just recently I've started to play with [Rex](http://www.rexify.org/) which is a tool for automating server management.
Part of the <b>DevOps</b> revolution.
I have not used [Chef](https://www.getchef.com/) or [Puppet](http://puppetlabs.com/) before, so I did not know what to
expect, but so far I love it.

One of the big problems with unattended access to servers is the question of security. How can you make sure the script that
you wrote to access the server and, let's say install the latest security fixes, is itself secure?
More specifically, how can you make sure that if someone gets access to the script won't be able to damage your server?

In this article you'll see a couple of way to handle authentication. Each one with its own issues.


The part of my <b>Rexfile</b> that does the real work looks like this:

```perl
group myservers => "perlmaven.com", "perlide.org";

desc "Update all the packages";
task "update", group => "myservers", sub {
   my $update = run "aptitude update";
   say $?;
   my $upgrade = run "aptitude -y safe-upgrade";
};
```

The `group myservers ...` part declares a list of server names that the task can act upon.

The `desc` is, well, just a description of the task after it.

The `task` declares what is basically an anonymous function in Perl that will execute certain commands via an ssh connection.
In our case we would like to run `aptitude update` to update the list of packages available for our distribution.
Then we would run `aptitude -y safe-upgrade` to upgrade all the necessary packages, without the need to manually confirm
the upgrade.
The exit code from the last `run` is placed in the `$?` variable. We print it out with the `say` command.

<i>
This example was specially designed to work on Debian/Ubuntu by the author who is just getting started with Rex.
[Ferenc Erki](https://github.com/ferki), one of the core Rex developers pointed out, that a more generic solution would be to
use the built-in `update_package_db` command as that is the <a href="http://www.rexify.org/api/Rex/Commands/Pkg.pm.html">OS-agnostic
way to update package definitions</a>. There is also a command called `update_system` to update all packages on a system.
</i>

<i>He also pointed out that instead of `say $?;` one might activate the `verbose_run` feature flag.
See in [all the feature flags](http://www.rexify.org/howtos/backward_compatibility.html).</i>

And finally,

<i>Achieving unattendness can be a bit more complicated sometimes, than just adding -y.
Currently Rex is using `APT_LISTCHANGES_FRONTEND=text DEBIAN_FRONTEND=noninteractive apt-get -y -qq upgrade` in Rex with `update_system`.
</i>

Actually, in order to make the example run faster, and to get some feedback I ran a slightly different example:

```perl
group myserver => "perlmaven.com";

desc "Update all the packages";
task "update", group => "myserver", sub {
   my $output = run "uptime";
   say $output;
   my $update = run "aptitude update";
   say $?;
};
```

Here we just check the `uptime` of a single machine and run the `aptitude update` command.


The big question:

## How do we establish the ssh connection?

When you get a server from [Digital Ocean](/digitalocean) it comes with a single root user and a random password they generate.
Alternatively, you can pre-configure a public key to be deployed on the server so you can already access using your
private key. Let's see the various cases how can we get to the point to execute the commands:

In the above `Rexfile` we have not declared the user to be used for the ssh connection,
nor have we supplied a password.
In order to run the script anyway we can execute the following command:

```
rex -u root -p SecretPassword update
```

We supply the username and the password on the command line.
It has the advantage that we don't need to save the password as cleartext in the Rexfile, but we have to type it
in on the command line as cleartext. Someone can watch over our shoulder, or can check in the
history of commands. Even worse, the history is then saved on the disk and people, who gain access to my computer
might read it later.

## Username in the file

We can add the following entry to our Rexfile:

```perl
user "root";
```

and then it is enough to provide the password:

```
rex -p SecretPassword update
```

It might be more convenient, but the same problem with security.

## Password in the Rexfile

We can also add the password to the Rexfile like this:

```perl
user "root";
password "SecretPassword";
```

Then we can run our command without providing anything on the command line:

```
$ rex update
```

The problem, of course, is that the password can be found as cleartext in the Rexfile.

We can make it a bit more secure by setting the mode of the file so that only the owner
of the file has access to it:

```
$ chmod 600 Rexfile

$ ls -l Rexfile
-rw-------  1 gabor  staff  821 Nov  2 17:27 Rexfile
```

This is a slight improvement, but if we backup our file, or if we add it to version control system -
both of which are very much recommended practices - then the file can be exposed to all kinds
of untrusted people.


## Private/Public key based authentication

The above problem exist with any form of unattended access to a server, unless we use a private/public key-pair.
If we have such key-pair, we can make our Rexfile more secure.

First of all we need to manually ssh to the target server as user 'root' and create the .ssh directory.
Then we copy the public key which is usually stored as `.ssh/id_rsa.pub` on our machine, to the `.ssh/authorized_keys` file on the server.
If you already had such file with keys in it, make sure you <b>add</b> the new key to it instead of overwriting the whole file.

```
$ ssh root@perlmaven.com "mkdir .ssh"
$ scp ~/.ssh/id_rsa.pub root@perlmaven.com:.ssh/authorized_keys
```

This is actually the step that we can skip if we upload a public key to Digital Ocean and ask them to install the key when creating a new server.


Either way, once we have the public key in place, we can modify our Rexfile: we remove the "password" line and add the path to both the private and the public key
on our own computer where we are going to run rex.

```perl
user "root";
private_key "~/.ssh/id_rsa";
public_key "~/.ssh/id_rsa.pub";
```

( I am not sure why do we need to supply the `public_key` here, so [I asked](https://github.com/RexOps/Rex/issues/478). )

Then, if everything worked properly, we can run:

```
$ rex update
```

This will access the server as user 'root' and execute the commands without providing the password in cleartext.

Of course if someone can access the Rexfile on my local computer, then that person might also access the private and
public keys on my machine, copy them and use them to access the server.

Although you'd normally try to protect the private key file much more than any almost any other file in your account.

<i>As [Ferki](https://github.com/ferki) pointed out one can protect the private key using a
passphrase as well, but then the process will only be unattended if you include the passphrase in the Rexfile - which we would like to avoid.</i>

Nevertheless, this is still an improvement over the case when we had the password in the Rexfile.
If my user account on my local machine is compromised then there is no difference in the two approaches, but 
if someone manages to read the Rexfile from a backup or from the version control system we put it in, that still
won't allow accessing the server.

Normally one should not put the private key in version control or on a regular backup. Usually people keep that file much
more secure than simple source code. Such as the Rexfile.

## As a non-root user

A further improvement might be to create a non-privileged user on the server, give it limited extra rights
and let Rex use that user.

For this, first we create a user called `foobar` on the server and copy the public key to the ~/.ssh directory
of that user.

On the server execute:

```
# adduser --gecos "" --disabled-password foobar
# mkdir /home/foobar/.ssh
# cp .ssh/authorized_keys /home/foobar/.ssh/
```

<i>
You can also use Rex to create user accounts for you, with optionally deploying a specified public key for them upon creation
- see `account` or `create_user` in [the documentation](http://www.rexify.org/api/Rex/Commands/User.pm.html).
</i>

We also change the Rexfile to have user foobar instead of user root:

```
user "foobar";
```

If we try to run Rex now we'll get an error:

```
$ rex update

 15:43:48 up 18:04,  1 user,  load average: 0.00, 0.01, 0.05
255
```

That's a failure code. Of course, user foobar cannot execute the `aptitude update` command.

In order to allow foobar to do that we need to give it `sudo` rights on the server.

Unfortunately then we get in the same problem as earlier.

Usually `sudo` will require the user to type in their own password. That means we have to keep
it in the Rexfile as cleartext.

The alternative, which I think is better, is to allow foobar to have access to certain commands via
sudo without password.

Let's start by setting up sudo for foobar:

In order to allow sudo access we will need to create a file called
`/etc/sudoers.d/foobar` and set the mode to read only using the following command: `chmod 440 /etc/sudoers.d/foobar`

If we want to allow foobar to execute any command, but we want to require foobar to type in its password,
the content of the file will be this:

```
foobar   ALL=(ALL:ALL) ALL
```


If we want to allow foobar to execute any command via `sudo` without even providing a password, then this should be the content:

```
foobar   ALL=(ALL:ALL) NOPASSWD:ALL
```

In order to get Rex to use `sudo` we can add the following line to the <b>Rexfile</b>:

```perl
sudo TRUE;
```

Running `rex update` will work as expected.


This setup means that someone who finds the public key on my machine will be able to execute <b>any</b>
root command on the server(s). This is no improvement over the case when we directly used the `root`
account on the server.


## Limit the sudo-able commands

In order to reduce the exposure we could limit the commands that foobar can execute via sudo
without providing a password.

If we would like to let foobar execute specific commands, we can have the following line
in the `/etc/sudoers.d/foobar` file:

```
foobar   ALL=(ALL:ALL) NOPASSWD: /usr/bin/aptitude, /usr/bin/uptime, /bin/sh
```

Unfortunately, as of today, we have to allow the `/bin/sh` due to what I think
is a [bug](https://github.com/RexOps/Rex/issues/466), and this creates a security issue.
Allowing `sh` is like allowing everything. For example we could add the following call to
our Rexfile:

```
   run 'sh -c "echo crack-this > /root/oups"';
``` 

that will create the /root/oups file even though user 'foobar' is not supposed to have write access there.

<i>
Apparently there is also a `sudo_without_sh` [feature flag](http://www.rexify.org/howtos/backward_compatibility.html) we could use here,
but I did not know about it so I created another solution:
</i>

We can add "sudo" to each one of the individual calls where necessary.
So we remove the `sudo TRUE;` from the Rexfile and change the aptitude command to be

```perl
   my $update = run "sudo aptitude update";
```

In order to execute uptime, the user does not need to have root rights, so we don't change that command.

We also change the `/etc/sudoers.d/foobar` file to have the following content:

```
foobar   ALL=(ALL:ALL) NOPASSWD: /usr/bin/aptitude
```

foobar is only allowed to execute `sudo aptitude` without providing a password.
(Actually in this setup foobar cannot execute anything else with sudo, not even with password.)

Running `rex update` will work again as expected.


## TL;DR

On the remote machine create a user `foobar` (or your favorite name) and copy the public key.

```
# adduser --gecos "" --disabled-password foobar
# mkdir /home/foobar/.ssh
# cp .ssh/authorized_keys /home/foobar/.ssh/
```


Create a file called `/etc/sudoers.d/foobar` with the following commands:

```
# echo "foobar   ALL=(ALL:ALL) ALL"  >> /etc/sudoers.d/foobar
# echo "foobar   ALL=(ALL:ALL) NOPASSWD: /usr/bin/aptitude" >> /etc/sudoers.d/foobar
# chmod 440 /etc/sudoers.d/foobar
```

<i>
You might be in the opinion that every change related to sudoers must be validated with `visudo -c` first.
In that case disregard my suggestion using `echo` and just use `visudo` instead.
</i>

The `Rexfile`

```perl
user "foobar";
private_key "~/.ssh/id_rsa";
public_key "~/.ssh/id_rsa.pub";

group myservers => "perlmaven.com", "perlide.org";

desc "Update all the packages";
task "update", group => "myservers", sub {
   my $output = run "uptime";
   say $output;
   my $update = run "sudo aptitude update";
   say $?;
   my $upgrade = run "sudo aptitude -y safe-upgrade";
   say $?;
};
```

## Improvements

As mentioned in the opening, I've just started to use [Rex](http://www.rexify.org/) so I am sure there are a lot of improvement
that can be made to the above examples. (Some of them were already suggested and included as <i>comments</i> in the article.)
Make sure you visit the web-site of Rex and join their conversation on IRC.

