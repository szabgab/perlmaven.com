---
title: "Upgrade Vagrant Perl Development Environment"
timestamp: 2015-10-02T11:10:01
tags:
  - Vagrant
published: true
author: szabgab
archive: true
---


Since the release of the [Vagrant based Perl Development Environment](/vagrant-perl-development-environment) the VirtualBox
image has been updated. If you followed the instruction in that article and installed the PDE a
earlier, you might have an outdated version of the VirtualBox image.

In this article you'll see how can you check if your system is outdated and how can you upgrade it.


## Check automatically during vagrant up

The next time you run `vagrant up` it will check if there is a newer version of the box available and will tell you:

```
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'szabgab/pde' is up to date...
==> default: A newer version of the box 'szabgab/pde' is available! You currently
==> default: have version '1.0.0'. The latest is version '1.1.0'. Run
==> default: `vagrant box update` to update.
...
```

then it will go on and launch the VirtualBox image with the old box.


## Check manually if VirtualBox is outdated

Alternatively we can check it manually.

Open the terminal (or Command Window on MS Window) and cd to the directory where you have
created the Vagrant environment. (The directory with the `Vagrantfile`.)

In [original setup](/vagrant-perl-development-environment) I used a directory called `try`

Once in the directory type

```
$ vagrant box outdated
```

I got the following output:

```
Checking if box 'szabgab/pde' is up to date...
A newer version of the box 'szabgab/pde' is available! You currently
have version '1.0.0'. The latest is version '1.1.0'. Run
`vagrant box update` to update.
```

You will probably see some similar message.

This means the `box` you have is not the latest one.

## Update box

The following command will download the newest version of Perl Development Environment. It is a 1.25Gb file. It will take some time.

```
$ vagrant box update
```

This command has updated the box on your system, but your are still using a copy of the old box.

In order to start using the new copy you have to `destroy` your version of the old box.

## Warning!!!

This will destroy everything you put on the VirtualBox, excapt the files that you put in the `/vagrant` directory
which is actually on your host computer.

```
$ vagrant destroy
```

## Using new version

In order to start using the new version you have to type

```
$ vagrant up
```

again.

Then you can ssh to the machine again using

```
$ vagrant ssh
```

as you did earlier.


