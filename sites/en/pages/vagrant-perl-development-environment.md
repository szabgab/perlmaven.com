---
title: "Vagrant Perl Development Environment (VirtualBox)"
timestamp: 2015-08-24T15:30:01
tags:
  - Vagrant
  - VirtualBox
published: true
author: szabgab
archive: true
---


[Vagrant](https://www.vagrantup.com/) makes it super easy to create and distribute development environments.
The default is to create a [VirtualBox](https://www.virtualbox.org/) image and let everyone else use it.

I've created one especially for developing Perl-based applications. In this article you'll see how to use it.


## Setup

First you'll have to install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).
They are both open source and free.

I have the following versions:

```
$ vagrant -v
Vagrant 1.7.4
```

```
$ VirtualBox -h | grep Manager
Oracle VM VirtualBox Manager 5.0.2
```

though a while ago it was working like this:

```
$ VBoxManage -v
4.3.24r98716
```

and by the time you are reading this, the version numbers most likely are going to be higher.

## Get the image an launch it

Open the terminal (or Command Window if you use Microsoft Windows), create a directory for the environment and the cd into that directory.

```
$ mkdir try
$ cd try
```

Before going further, let's create a perl script here: Create a file called `hello_world.pl` with the following content:

```perl
use strict;
use warnings;
use 5.010;

say 'Hello World';
```


The following command will initialize the directory to use Vagrant with [the specific image I've created for Perl development](https://github.com/szabgab/PDE).

```
$ vagrant init szabgab/pde
```

The response looks like this:

```
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
```

## Port forwarding

Before we launch the VirtualBox image we need to make a small adjustment. Edit the `Vagrantfile`
and insert the following row just under the similar line that is commented out.

```
  config.vm.network "forwarded_port", guest: 3000, host:3000
  config.vm.network "forwarded_port", guest: 5000, host:5000
```

Then we have to launch the VirtualBox image using the `vagrant up` command. When you run this command for the fist time, Vagrant
will notice that you don't have the image on your hard-disk yet and will download it. The image itself is about 800 Mb so it
can take a while to download it. You will see the estimated remaining time on the console.

```
$ vagrant up
```

The response looks like this:

```
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'szabgab/pde' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'szabgab/pde'
    default: URL: https://atlas.hashicorp.com/szabgab/pde
==> default: Adding box 'szabgab/pde' (v1.1.0) for provider: virtualbox
    default: Downloading: https://atlas.hashicorp.com/szabgab/boxes/pde/versions/1.1.0/providers/virtualbox.box
    default: Progress: 6% (Rate: 236k/s, Estimated time remaining: 0:15:50)
```

and when the download has finished it shows this:

```
==> default: Successfully added box 'szabgab/pde' (v1.1.0) for 'virtualbox'!
==> default: Importing base box 'szabgab/pde'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'szabgab/pde' is up to date...
==> default: Setting the name of the VM: try_default_1427292263650_50259
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 => 2222 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection timeout. Retrying...
==> default: Machine booted and ready!
GuestAdditions 4.3.24 running --- OK.
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /Users/gabor/tmp/try
```


Now you have a Linux machine running in VirtualBox on your system.

## Connect to the VirtualBox image

We can access the machine via ssh:

```
$ vagrant ssh
```


## SSH to Vagrant on MS Windows

On MS Windows you can use [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
to connect to the Vagrant based VirtualBox image.

You will need to download both putty.exe and puttygen.exe
You can then follow [these instructions](http://www.sitepoint.com/getting-started-vagrant-windows/)
though the `private_ket` file I had to load was located in the `.vagrant/machines/default/virualbox`
subderectory of the directory where I ran `vagrant up` and it does not have any extension so I had to change
the filter in the "open private key" window.

Then I had to save it again as "private key", just this time it was in the format Putty can use.

Once you installed the private key, Putty will let you connect to the virtualbox. It will still prompt
for a username though, where you need to type in 'vagrant'.



This will get us inside the machine in the home directory of the 'vagrant' user. I think the best then is to

```
$ cd /vagrant
```

This directory of the Virtual machine is mapped to the directory you created for the whole project
on the host machine. That means, if you list the directory now we will see both the Vagrant file
that was created by the `vagrant init` command and the `hell_world.pl` file we have created
on the host machine.

```
$ ls -l
total 8
-rw-r--r-- 1 vagrant vagrant   58 Mar 25 14:25 hello_world.pl
-rw-r--r-- 1 vagrant vagrant 3024 Mar 25 13:50 Vagrantfile
```

We can run the perl script by typing

```
$ perl hello_world.pl
Hello World
```

From this point you can go on creating and editing files with any editor you have on your own computer
and as long as the file is in that subdirectory, you'll be able to run it on the virtual server.


## Warning

Later we'll see how to upgrade the VirtualBox image when a new one is released. That will involve destroying
your old machine which will delete everything except what you have in the `/vagrant` directory,
so I'd strongly recommend using only that directory.


## Installing modules

The image comes with perl 5.20.2 and `cpanm` and a bunch of other modules.
Still, you might want to install further modules. Just type in

```
$ cpanm Module::Name
```

and it should install the specific module with all its dependencies.

(Remember, because these modules are installed on the VirtualBox, when you will upgrade the box, these
will disappear. So you might also want to [let me know](https://github.com/szabgab/PDE) which other modules you need.
That way after the upgrade you might already have them installed.)


## Shutting the Machine down (suspend, halt, destroy)

When the VirtualBox runs it uses precious resources of your machine.
You might want to shut it down when you don't need it.

```
$ vagrant suspend
```

will suspend the machine saving its current state to your harddisk. This will take up some extra diskspace, but will make it fast to resume operation.

```
$ vagrant halt
```

This will shut down the machine. This way only the image of the hard-disk of this machine will be on your hard-disk, not its memory dump.
This uses less disk-space on your machine but will take longer time to start again.


```
$ vagrant destroy
```

This will remove even the hard-disk of your VirtualBox image leaving only the original box downloaded on your hard disk.
This uses even less disk space than when you halted the machine, but anything you put on the machine outside the `/vagrant` directory
will be gone too. (Including any modules you might have installed.) Starting the machine will take even longer than after running `halt`.


## Restarting the machine with up

In either of the 3 methods you used to stop the VirtualBox, running

```
$ vagrant up
```

will start it again.

Unlike the first time you ran this command, this time it won't need to download anything from the Internet and thus it will
be much faster than the first time you ran this command.

## Upgrade from older version

This article described the initial installation of the <b>Perl Development Environment</b>. Later as newer versions are released
you might want to follow the instructions to
[upgrade the Vagrant Perl Development Environment](/upgrade-vagrant-perl-development-environment).




