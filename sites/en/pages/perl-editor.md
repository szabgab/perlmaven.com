---
title: "Perl Editor"
timestamp: 2012-08-01T12:45:56
tags:
  - IDE
  - editor
  - Padre
  - vim
  - emacs
  - Eclipse
  - Komodo
published: true
books:
  - beginner
author: szabgab
---


Perl scripts or Perl programs are just simple [text files](/what-is-a-text-file). You can use any kind of text editor to create them, but you should not use any word processor. Let me suggest a couple of editors and IDEs you can use.


## Editor or IDE?

For Perl development you can either use a plain text editor or an <b>Integrated Development Environment</b>, also called IDE. An IDE usually has a longer an steeper learning curve, but it can provide you more help writing and debugging code. Text editors are usually a lot more generic and easier to learn, but have less language-specific help. First I'll describe the editors on the major platforms you might use, and then the IDEs which are usually platform independent. Finally I have a few suggestions for platform independent editors.

What I usually suggest is that you get started with whatever editor or IDE you are already familiar with, so you spend time learning the language instead of learning the editor/IDE.

## Unix / Linux

If you are working on Linux or Unix, then the most common editors used there are [Vim](http://www.vim.org/) and [Emacs](http://www.gnu.org/software/emacs/). They have very different philosophy, both from each other, and from most of the editors out there. If you are familiar with either one of those, I'd recommend using them. For each one of them there are special extensions or modes to provide better support for Perl. Even without those they are very good for Perl development.

Both of those editors are very powerful, but take a long time to master. If you are not familiar with those editors, then I'd probably recommend you separate your Perl learning curve from your editor learning experience. It is probably better to focus on your Perl studies now, and only later to learn one of these editors.

I can also recommend 2 super simple editors. One called Gedit the other called nano. They can be used for getting started, but I'd quickly look for a more powerful editor. See the list of the IDEs and the platform independent editors further down.

* [Vim](http://www.vim.org/)
* [Emacs](http://www.gnu.org/software/emacs/)
* [Gedit](https://wiki.gnome.org/Apps/Gedit)
* [nano](https://www.nano-editor.org/)

## Perl editors for Windows

On Windows, many people are using the so-called "programmer's editors".

* [Notepad++](http://notepad-plus-plus.org/) is an open source and free editor.
* [Ultra Edit](http://www.ultraedit.com/) is a commercial editor.
* [TextPad](http://www.textpad.com/) is share-ware.

I have been using <b>Notepad++</b> a lot and I keep it installed on my Windows machine as it can be very useful.

## Mac OSX

According to popular vote, [TextMate](http://macromates.com/) is the most often used Mac specific editor for Perl development. However as OSX is just a Unix machine you can probably use the same editors as you'd on a Linux box. Personally I use
vim even on Mac.

## Perl IDEs

Neither of the above are IDEs, that is, neither of them offer a built-in debugger for Perl. They also don't provide language specific help.

[Komodo](http://www.activestate.com/) from ActiveState costs a few hundreds of USD. It has a free version with limited capabilities.

People who are already [Eclipse](http://www.eclipse.org/) users might want to know that there is a Perl plug-in for Eclipse called EPIC. There is also a project called [Perlipse](https://github.com/skorg/perlipse).

There is also a Perl5 plugin for [Jetbrains IntelliJ IDEA](https://www.jetbrains.com/).

## Padre, the Perl IDE

In July 2008 I started to write an <b>IDE for Perl in Perl</b>. I called it Padre - Perl Application Development and Refactoring Environment or [Padre, the Perl IDE](http://padre.perlide.org/).

Many people joined the project. For some time it was distributed by the major Linux distributions and it could also be installed from CPAN. See the [download](http://padre.perlide.org/download.html) page for details. Unfortunately development has stopped at the end of 2013. I'd only recommend it if you would actually like to improve Padre itself.

## The big Perl editor poll

In October 2009 I ran a poll and asked [Which editor(s) or IDE(s) are you using for Perl development?](http://perlide.org/poll200910/) Now you can go with the crowd, against the crowd, or you can pick a Perl editor that fits you.

## Platform independent editors

* Alex Shatlovsky recommended [Sublime Text](http://www.sublimetext.com/), which is a platform independent editor, but one that costs some money.
* Peter Ulvskov recommended [Geany](https://www.geany.org/) which is a cross-platform Open Source editor.
* [Atom](https://atom.io/) is another cross-platform Open Source editor.
* [Visual Studio Code](https://code.visualstudio.com/) (aka. VSCode from Microsoft)

While they are native to Unix/Linux, both <b>Emacs</b> and <b>Vim</b> are available for all the other major operating systems.

## Comments

It's worth to mention that instead of Sublime there is also a free editor called Atom, very similar to Sublime in functionality. I'm not a user of it, because I still prefer vim.

<hr>
Perl plugin in intellij works well, I have been using it since quiet some time.

<hr>

VS code is also a great editor :)
