---
title: "File modify date - When was a file last changed?"
timestamp: 2019-11-09T15:30:01
tags:
  - stat
  - -M
  - DateTime
  - localtime
  - $^T
published: true
author: szabgab
archive: true
---


How to know when was a file changed the last time?


{% include file="examples/file_change_date.pl" %}

The most recommened way is to use the `stat` function that returns a 12-element array from the inode table of the
file.
The 9th element is the **mtime** field.
In this example first we called **stat** and assigned it to an array and then accessed the 9th
element. This form is useful if we need other information from the inode table.

If you only need the modification time, then a more compact way would be calling **stat** and without assigning to an
array, on-the-fly, extract the 9th element.

Then we see 3 ways we can format the result. The value we got back was the time since the epoch.
We can convert it into a more readable format either using the build-in **localtime** function
or the heavy-weight `DateTime` module.

The `-M` operator returns the script start time minus file modification time, in days.
So if the file is created after the script starts running this will be a negative number.

Lastly, just for fun you can see that the strange-looking `$^T` variable of Perl contains the start-time
of the script (seconds elapsed since the epoch) so using that and the value returned by `-M` we can also calculate the
modification time of the file.



Usage and output:

<pre>
perl examples/file_change_date.pl README.md

1546036223
1546036223
Sat Dec 29 00:30:23 2018
2018-12-28T22:30:23
309.25775462963
</pre>
