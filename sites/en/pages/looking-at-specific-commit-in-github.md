---
title: "Looking at a specific commit in GitHub"
timestamp: 2015-05-14T06:30:01
tags:
  - GitHub
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


In order to follow the development of [search.cpan.org clone](/search-cpan-org) (or any other project using GitHub for that matter)
you might want to look at snapshots of the project at various commits.

Here is what you can do:


{% youtube id="0Ve6knIftYc" file="looking-at-specific-commit-in-github" %}

On the [main GitHub page](https://github.com/szabgab/MetaCPAN-SCO) of the project click on `NNN commits`
in the top left. You can see the list of commits from the most recent at the top, to older commits below that.
You can scroll down and click on "Older" to see older commits.


## Clone the repository

If you don't have a clone of the project yet, go get one.  Seriously, this is probably the easiest way to do this:

Go back to the [main page of the project](https://github.com/szabgab/MetaCPAN-SCO).
On the right hand side you'll see a box with a clone URL. It will probably have title "HTTPS clone URL".
Copy the URL from there and run

```
git clone https://github.com/szabgab/MetaCPAN-SCO.git
```

This will clone the whole project to your disk with all the history.

alternatively you can click on the **Clone in Desktop** button, but I have never tried that.

Clicking on **Download ZIP** at this point won't do what we want. So avoid that!

## Check out specific commit

If you have cloned the repository to your disk you have all the history there and by default you have the "master" branch checked out.
In other repositories the default branch might be called some other name. For example in the
[repository of perlmaven.com](https://github.com/szabgab/perlmaven.com) the default branch is called "main".

On commit history page we saw earlier, pick the commit for which you'd like to see the results.
On the right hand side of the listing you'll see 7 characters from the SHA
(the unique identifier) of this commit. Click on the icon to the left of the these 7 characters where it says "Copy the full SHA"
(if you hover the cursor over it).
This will copy the full SHA to your clipboard (e.g. e442f37a10291a7d93fd9c5068b4e10f554738ed).



Now you can go to the command line, change directory to the cloned project, and check out the result of the specific commit:

Make sure you are in a clean state by typing

```
git status
```


And then type in `git checkout ` and press Ctrl-V or (Command-V on OSX), whatever the "paste from clipboard" happens 
to be in your operating system.

It should look like this:

```
$ git checkout e442f37a10291a7d93fd9c5068b4e10f554738ed
```

Executing this command will switch the files on your disk to the state after that specific commit.

It will print something like this:

```
Note: checking out 'e442f37a10291a7d93fd9c5068b4e10f554738ed'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b new_branch_name

HEAD is now at e442f37... show PASS and FAIL only if they are not 0
```

Don't worry. If you don't make any changes here, nothing will go wrong.

At this point you can examine the content of the files and see if the application works
as explained in the articles.

If you make changes to the files you can revert them by typing

```
git checkout path/to/changed/file
```


After you've finished examining the files and made sure all the changes have been reverted
(you can do that by checking the status of the repository using `git status`)
you can get back to the most recent commit by typing

```
git checkout master
```



## No Git

What if you don't want to clone, or you don't even have Git on your system?
No worry, we'll handle that case now. Go back to the list of commit.

Select the appropriate commit but this time click on either commit message
or on the 7-character identifier. They both lead to the same place that displays
the diff of the specific commit.

In the above case this would be 
[this page](https://github.com/szabgab/MetaCPAN-SCO/commit/e442f37a10291a7d93fd9c5068b4e10f554738ed).

Click on the **Browse code** button in the top right corner. This will to
[this page](https://github.com/szabgab/MetaCPAN-SCO/tree/e442f37a10291a7d93fd9c5068b4e10f554738ed)
that is the representation of the whole tree after that commit. Now you can click on the "Download ZIP" button
on the right hand side to download a zipped version of the whole project at the specific time in its history.

You can then unzip the file and have the project without having Git on your system.

## Comments

Is it possible to clone your own repo at a certain point in history? Going backwords and choosing from which commit to clone your repo into your pc. Do you have any idea if it's possible?
I hope to hear from you soon.

---
Cloning means copying the whole db so I don't you can do what you outlined. You can clone the whole db and then check out a specific old version or you can even remove the newer commits if you wish, though you'd rarely need to make such drastic move.

<hr>
Useful article Gabor :-)
<hr>
Nice one

