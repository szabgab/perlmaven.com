---
title: "Getting started with Perl Dancer on Digital Ocean"
timestamp: 2013-10-09T11:40:01
tags:
  - Dancer
  - nginx
  - Starman
  - Digital Ocean
  - VPS
published: true
books:
  - dancer
author: szabgab
---


[Digital Ocean](/digitalocean) offers Virtual Private Servers (VPS) for a very low monthly fee.
Recently I set up a server with them and I am quite satisfied. If you want to have a place where you can
experiment with building and running web applications, this can be a perfect starting point.

In this article I'll explain how to set up a [Perl Dancer](http://perldancer.org/) based web site
on a [Digital Ocean](/digitalocean) droplet.


<ol>
  <li>[Sign up to Digital Ocean and create a server](#signup)</li>
  <li>[Basic configuration of the server](#basic)</li>
  <li>[Installing packages](#aptitude)</li>
  <li>[Brewing Perl](#perlbrew)</li>
  <li>[Installing Perl Modules from CPAN](#cpan)</li>
  <li>[Creating a simple Dancer application](#dancer)</li>
  <li>[Configuring Starman](#starman)</li>
  <li>[Configure nginx as a proxy](#nginx)</li>
  <li>[Connecting a domain name](#domain)</li>
</ol>


<h2 id="signup">Sign up to Digital Ocean and create a server</h2>

First you need to visit [Digital Ocean](/digitalocean) (This is an affiliate link, I'll earn some credits
if you use this link to sign up.), provide your credit card information. Once you are in you need to create a
server instance. They call these <b>Droplets</b>. There is a big green button to <b>Create</b> droplets.

You need to supply the <b>Droplet hostname</b> which can be any word. You can pick <b>foo</b> or <b>web1</b> or whatever you like.
I picked <b>s12</b> for this server.
This is the internal name.

Then you need to <b>select the size</b>. I go with the smallest: 512 Mb / 1 CPU / 20 Gb SSD disk / 1 TB transfer that costs $5 / month.
I have not tried this yet, but if I understand correctly, I could create and destroy servers for much shorter periods and pay
by the hour. This could be a lot of fun playing with setup.

The third thing to select is the <b>region</b>. Unless there is some really important reason to pick a specific data-center, you
can go with any of those. I picked <b>Amsterdam 1</b>.

In the <b>Select Image</b> section, we need to select the Linux distribution we'll be using. You can pick your favorite one.
I'll use <b>Ubuntu 13.04 x64</b> for this article. This is the latest 64bit release of [Ubuntu](http://www.ubuntu.com/).

At the bottom you can then click on the big green button that says <b>Create Droplet</b>.

They will start building the server which takes about 60 seconds and send you an e-mail containing the IP address and the password of
root. This is not the most secure process, but we'll change the password very soon so I don't think this is a big issue.

If you are worried they also allow you to provide a public key <b>before</b> you create the droplet and then they will install that
key instead of sending you a password.

<h2 id="basic">Basic configuration of the server</h2>

In the e-mail you will see instructions how to ssh to the server.
If you are a command line user, you can use the <b>ssh root@1.2.3.4</b> command, with
the IP address of your server.

If you run Windows, you will need to install an SSH client. I'd recommend installing
[putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html).
You just need to download the <b>putty.exe</b> file and you can double-click on it as it is.
There is no need for any further "installation".
Once the initial window of Putty has opened, there is a field for <b>Host Name (or IP address)</b>
and a radio selector where you need to select <b>SSH</b>. Then press <b>Open</b>. This will get
you to a window asking for <b>Username:</b>. There you type in <b>root</b> and press ENTER.
It will then ask you for <b>Password:</b> and you type in the password you got in the e-mail.

The first thing we need to do is to change the password. So type in <b>passwd</b> and press ENTER. It will
ask for a password and then it will ask you to repeat it. Please give a long password that you can remember.
Something like <b>The secret of a secure server</b> is probably a good password. If you also add some numbers
and some strange characters, it will become even stronger.

```
root@s12:~# passwd
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
root@s12:~#
```

Once we set the new password we need to update the packages on the system.
A Linux distribution consists of thousands of separate packages.
Most Linux distributions constantly release fixes to these package and it is very likely that the droplet
we created used an earlier set of these packages. So we should update and upgrade those packages:

<b>aptitude update</b> will download the most recent list of packages and their version numbers. This is usually
done automatically, but we don't want to wait for that now.

```
root@s12:~# aptitude update

Get: 1 http://archive.ubuntu.com raring Release.gpg [933 B]
Get: 2 http://archive.ubuntu.com raring-updates Release.gpg [933 B]
...
```


<b>aptitude safe-upgrade</b> will first list the packages that need to be upgraded and ask:
<b>Do you want to continue? [Y/n/?]</b>. If we press ENTER it will download these packages
and install them on the system.


```
root@s12:~# aptitude safe-upgrade

Resolving dependencies...
The following NEW packages will be installed:
  linux-image-3.8.0-31-generic{a}
The following packages will be upgraded:
  apt apt-transport-https apt-utils apt-xapian-index bind9-host command-not-found
  language-selector-common libapt-inst1.5 libapt-pkg4.12 libasn1-8-heimdal libbind9-90
  libheimbase1-heimdal libheimntlm0-heimdal libhx509-5-heimdal libisc92 libisccc90
  libpython2.7-stdlib libpython3.3-minimal libpython3.3-stdlib libroken18-heimdal
  linux-image-virtual login lsb-base lsb-release openssl passwd plymouth
  python3.3-minimal rsyslog tzdata ubuntu-release-upgrader-core update-manager-core
74 packages upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 51.9 MB of archives. After unpacking 35.2 MB will be used.
Do you want to continue? [Y/n/?]
```

If it asks questions about keeping the current version of various configuration files, you can usually just press ENTER. At this point this does not really matter.

Once the upgrade has finished it is recommended to <b>reboot</b> the system. Type in <b>reboot</b>. As the machine restarts this will disconnect
you and you will need to connect to it via ssh (putty) again, after some time. (Maybe 30 sec?). Remember, you have changed the password!


<h2 id="aptitude">Installing packages</h2>

As I mentioned every Linux distribution, and so Ubuntu too, comes with a lot of packages. Some of them are installed by default.
Others need to be installed manually. Usually the way to install a package is to type <b>aptitude install package-name</b>.
We will need a few of them so we type:

```
root@s12:~# aptitude install nginx
```

In some cases it will install the package right away, in other cases it might list what other packages need
to be installed for the selected one to work (e.g. the dependencies on nginx) and it will ask you:
<b>Do you want to continue? [Y/n/?]</b>. Just press ENTER.

We have just installed the [nginx](http://nginx.org/) web server. We still need to start it for the first time.
Type:

```
root@s12:~# service nginx start
```

Now you can open your browser and browse to the IP address of the server. Don't forget to add http:// in front of the IP
address as some of the browsers will not add it automatically. So if your IP address is 1.2.3.4 then type in the
address bar of your server: http://1.2.3.4/
You will see <b>Welcome to nginx!</b> or some similar message.

We will need a few more packages, so let's install those as well:

```
root@s12:~# aptitude install make gcc htop vim
```

In order to have a better security model we are going to run Starman our "application server" as a separate user we call `starman`.
(We could have called it foobar, or any other name.)
In order to create the user we run:

```
root@s12:~# adduser --gecos '' --disabled-password  starman
```

It will create the user `starman` and the only way to to access it will be via the user `root`.
You can now switch to the `starman` user by typing:

```
root@s12:~# su - starman
```

Please note how the prompt changes from `root@s12:~#` to `starman@s12:~$`.

To return to the root user, just `exit` from the current user:

```
starman@s12:~$ exit
```



<h2 id="perlbrew">Brewing Perl</h2>

If you run <b>perl -v</b> you will see the server already has perl installed. It is usually referred to as <b>system perl</b>.
As we are going to install all kinds of modules from CPAN some of those might interfere with modules used by the system.
So the usual recommendation is to build a separate perl installation and use that for the application. That's what we are
going to do. We will use [Perlbrew](http://perlbrew.pl/) for this to make the operation smooth.

Let's switch to the `starman` user and then
follow the instructions on the [Perlbrew](http://perlbrew.pl/) web site and run:

```
root@s12:~# su - starman
starman@s12:~$ \curl -L http://install.perlbrew.pl | bash
```

This will install Perlbrew.

(BTW, if you wondering about the backslash prefix, it ensures that no local <b>alias</b> will
interfere with the command.
See [here](http://stackoverflow.com/questions/15691977/why-start-a-shell-command-with-a-backslash))

Then we need to add `source ~/perl5/perlbrew/etc/bashrc` to our start-up script which is the
`.bashrc` file:

```
starman@s12:~$ echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc
```

We do this so every time we login to the machine it will be already configured.
At this point you can either logout (exit) and login again, or you can load the
updated version of `.bashrc` using:

```
starman@s12:~$ source ~/.bashrc
```

Now that `perlbrew` has been installed we can use it to install another version of Perl:

```
starman@s12:~$ perlbrew available
```

This will list the versions of Perl [available from CPAN](http://www.cpan.org/src/README.html).
As of the time of this writing this was the list:

```
  perl-5.19.4
  perl-5.18.1
  perl-5.16.3
  perl-5.14.4
  perl-5.12.5
  perl-5.10.1
  perl-5.8.9
  perl-5.6.2
  perl5.005_04
  perl5.004_05
  perl5.003_07
```

<b>5.19.4</b> is a development release (19, the second part of the version number is an odd number) and the most recent stable release is
<b>5.18.1</b>. So we'll install that version:

```
starman@s12:~$ perlbrew install perl-5.18.1
```

This will download the source of perl, compile it and test it.
This can take quite some time. 10-20 minutes or even more.
So this might be a good time to stretch a bit.

Once perl was built we can first <b>list</b> all the installed versions of perl:

```
starman@s12:~$ perlbrew list
  perl-5.18.1
```

and we can <b>switch</b> to it using the following command:

```
starman@s12:~$ perlbrew switch perl-5.18.1
```

If we run `perl -v`, we'll see it already report 5.18.1
We can also try `which perl` and it will report
`/home/starman/perl5/perlbrew/perls/perl-5.18.1/bin/perl`.


<h2 id="cpan">Installing Perl Modules from CPAN</h2>

It is not enough to compile our own version of Perl we also need to
install a few modules. For this we need a configured CPAN client.
The traditional one is called `cpan`, but we are going to use
the newer and slicker [cpan minus](http://cpanmin.us/),
also known as `cpanm`. Perlbrew has its own command to install cpan minus:

```
starman@s12:~$ perlbrew install-cpanm
```

Once that's install we can install the required modules:

```
starman@s12:~$ cpanm Dancer2 Starman Daemon::Control
```

<h2 id="dancer">Creating a simple Dancer application</h2>

The command

```
starman@s12:~$ dancer2 -a Demo
```

will create a subdirectory called Demo and inside a skeleton of an application, called <b>Demo</b>.
You can of course use any name as the name of your application, but it is usually recommended to start
with a capital letter and then use lower case letters in the name.

We can change directory into the Demo directory and launch the web site with a development server on port 3000:

```
starman@s12:~$ cd Demo
starman@s12:~$ perl bin/app.pl

>> Dancer2 v0.10 server 29587 listening on http://0.0.0.0:3000
```

While it says 0.0.0.0 as the IP address, you can actually use your own IP address. So if your IP address was 1.2.3.4 then
browse to http://1.2.3.4:3000 and you will see the default page of Dancer.

You can go on and further improve the application by following the
[Getting started with Perl Dancer](/getting-started-with-perl-dancer) screencast,
but for now we'll focus on configuring the server.

So let's stop the development server by pressing `Ctrl-C` on the console.

<h2 id="starman">Configuring Starman</h2>

As user `starman` create `/home/starman/starman_daemon.pl` containing the following code:

{% include file="examples/starman_daemon.pl" %}


set the executable bit using

```
starman@s12:~$ chmod +x /home/starman/starman_daemon.pl
```

Then leave the `starman` user using `exit` and as user `root` create a symbolic link
to the newly created file and then start the Starman service:

```
root@s12:~# ln -s /home/starman/starman_daemon.pl /etc/init.d/starman
root@s12:~# service starman start
```


In order to make sure Starman will start when the system boot we should add it to the boot scrips
along with nginx. This is done by creating some more symbolic links.

This will list all the rc-directories where Nginx is listed. We should add the same set of
links to Starman

```
root@s12:~# find /etc/ | grep rc| grep nginx | xargs ls -l
```

These commands will create the symbolic links:

```
root@s12:~# ln -s ../init.d/starman /etc/rc0.d/K20starman
root@s12:~# ln -s ../init.d/starman /etc/rc1.d/K20starman
root@s12:~# ln -s ../init.d/starman /etc/rc2.d/S20starman
root@s12:~# ln -s ../init.d/starman /etc/rc3.d/S20starman
root@s12:~# ln -s ../init.d/starman /etc/rc4.d/S20starman
root@s12:~# ln -s ../init.d/starman /etc/rc5.d/S20starman
root@s12:~# ln -s ../init.d/starman /etc/rc6.d/K20starman
```


Once you launched starman you can access the web application on the same hostname but on port 5000:

http://1.2.3.4:5000


<h2 id="nginx">Configure nginx as a proxy</h2>

As user `starman` create the file <b>/home/starman/nginx-demo.conf</b> with the following content:

{% include file="examples/nginx-demo.conf" %}

Then `exit` from the user, and as `root` remove the default configuration file,
create a symbolic link to from the nginx configuration directory to the  nginx-demo.conf file.
Restart nginx.

```
root@s12:~# rm /etc/nginx/sites-enabled/default
root@s12:~# ln -s /home/starman/nginx-demo.conf /etc/nginx/sites-enabled/
root@s12:~# service nginx restart
```

Now you can visit http://1.2.3.4  replacing this with the IP address of your machine.


<h2 id="domain">Connecting a domain name</h2>

If you already have a domain name registered, then you only need to configure it to make sure
both www.domain.com and domain.com resolves to the IP address of your machine.

If you don't yet have one, you can [register a domain name](https://iwantmyname.com/)
and then configure it.

No further changes are required to your configuration for this.

## Further development

As you continue developing your application you will notice that the changes you make to files
are not automatically reflected on the web site. This is normal. After all we just set up the
<b>deployment environment</b> for your application.

If you want the new code to take effect, you'll need to restart Starman.
As `root` run:

```
root@s12:~# service starman restart
```


Enjoy the development!


