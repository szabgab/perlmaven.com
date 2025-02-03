---
title: "Out of memory!"
timestamp: 2018-05-05T10:30:01
tags:
  - memory
published: true
author: szabgab
archive: true
---


A recent discussion made me want to see what happens to my Perl script if it tries to use more memory that available to it.
I tried it on Mac OSX and Ubuntu Linux running in a VirtualBox launched using Vagrant.


## Simple string

The first test script was this:

{% include file="examples/memory_load_simple.pl" %}

In this example we create a very long sting of the same character.

On the Linux machine that has 2Gb memory and no swap-space allocated, the script started to die
printing <b>Out of memory!</b> on the terminal when I tried to allocate 1800 Mb memory. This is not surprising
as the operating system also takes some memory. So basically once we ran out of memory the script just died.

The same script on the host OSX that has 4 Gb memory and swap space, could allocate 20 Gb memory and was still working.
And it was not even using the swap space. The <b>Activity Monitor</b> of OSX reported 19.53 Gb Memory usage and 17.79 Gb Compressed Memory.

Apparently because the data I used to fill the memory was easily compressible, Mac did just that.


## Random string

So I tried another example. In this one we create a 1 kb string of random characters and then use that in our repetition.

{% include file="examples/memory_load_random.pl" %}

I have only tried in on OSX. As I gave it higher and higher numbers I could see the swap space growing as reported by
the Activity Monitor, but the script kept running. Or perhaps better to say crawling as it took a lot of time to
allocate all that memory. Especially once it started to use the Swap space.

The highest I ran was for 8Gb

`memory_load_random.pl 8000`

Activity Monitor reported that the Perl script uses 7.81Gb Memory and the same amount of Compressed Memory.
The Swap grew to 10.14.

After the process was finished the Swap space usage went back to 3.12 Gb.

## Conclusion

If you run out memory and have no more swap space Linux will just crash your application.
Once your script needs more memory than available in the computer it starts to use the swap space (if configured)
and will make the script really slow.


