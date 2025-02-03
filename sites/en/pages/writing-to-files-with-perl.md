---
title: "Writing to files with Perl"
timestamp: 2012-12-20T16:45:56
tags:
  - open
  - close
  - write
  - die
  - open or die
  - >
  - encoding
  - UTF-8
published: true
books:
  - beginner
author: szabgab
---


Lots of Perl programs deal with text files such as configuration files or
log files, so in order to make our knowledge useful it is important at
an early stage to learn about file handling.

Let's first see how can we write to a file, because that seems to be easier.


This article shows how to write to a file using core perl. There are much simpler
and more readable ways to do that
[using Path::Tiny](/use-path-tiny-to-read-and-write-file).

Before you can write to a file you need to <b>open</b> it, asking
the operating system (Windows, Linux, OSX, etc) to open a channel
for your program to "talk to" the file. For this Perl provides
the `open` function with a slightly strange syntax.

{% include file="examples/open_file_for_writing.pl" %}

This is a good working example and we'll get back to it, but let's start with a simpler example:


## Simple example

{% include file="examples/open_file_for_writing_simple.pl" %}

This still needs some explanation. The <b>open</b> function gets 3 parameters.

The first one, `$fh`, is a scalar variable we just defined inside the `open()` call.
We could have defined it earlier, but usually it is cleaner to do it inside,
even if it looks a bit awkward at first. The second parameter defines the
way we are opening the file.
In this case, this is the the greater-than sign (`&gt;`) that means we are opening
the file for writing.
The third parameter is the path to the file that we would like to open.

When this function is called it puts a special sign into the `$fh` variable.
It is called file-handle. We don't care much about the content of
this variable; we will just use the variable later. Just remember, the content of the file
is still only on the disk and <b>NOT</b> in the $fh variable.

Once the file is open we can use the `$fh` file-handle in a `print()` statement.
It looks almost the same as the `print()` in other parts of the tutorial,
but now the first parameter is the file-handle and there is <b>no</b>(!) comma after it.

The print() call above will print the text in the file.

Then with the next line we close the file handle. Strictly speaking this is not
required in Perl. Perl will automatically and properly close all the
file-handles when the variable goes out of scope, at the latest when the script ends.
In any case, explicitly closing the files can be considered as a good practice.

The last line `print "done\n"` is only there so the next example will be clearer:

## Error handling

Let's take the above example again and replace the filename with a path does not exist.
For example write:

```perl
open(my $fh, '>', 'some_strange_name/report.txt');
```

If you run the script now you will get an error message:

```
print() on closed file-handle $fh at ...
done
```

Actually this is only a warning; the script keeps running and that's why we
see the word "done" printed on the screen.

Furthermore, we only got the warning because we explicitly asked for warnings with
`use warnings` statement.
Try commenting out the `use warnings` and see the script is now silent when it
fails to create the file. So you won't even notice it until the customer, or - even worse -
your boss, complains.

Nevertheless it is a problem. We tried to open a file. We failed but then
still tried to print() something to it.

We'd better check if the `open()` was successful before proceeding.

Luckily the `open()` call itself returns
[TRUE on success and FALSE on failure](/boolean-values-in-perl), so we could write this:

## Open or die

```perl
open(my $fh, '>', 'some_strange_name/report.txt') or die;
```

This is the "standard" <b>open or die</b> idiom. Very common in Perl.

`die` is a function call that will throw an exception and
thus exit our script.

"open or die" is a logical expression. As you know from the previous
part of the tutorial, the "or" short-circuits in Perl (as in many other languages).
This means that if the left part is TRUE, we already know the whole expression will
be TRUE, and the right side is not executed. OTOH if the left hand side is FALSE
then the right hand side is also executed and the result of that is the result
of the whole expression.

In this case we use this short-circuit feature to write the expression.

If the `open()` is successful then it returns TRUE and thus the
right part never gets executed. The script goes on to the next line.

If the `open()` fails, then it returns FALSE. Then the right side of the
`or` is also executed. It throws an exception, which exits the script.

In the above code we don't check the actual resulting value of the logical expression.
We don't care. We only used it for the "side effect".

If you try the script with the above change you will get an error message:

```
Died at ...
```

and will NOT print "done".

## Better error reporting

Instead of just calling die without a parameter, we could add some explanation of what happened.

```perl
open(my $fh, '>', 'some_strange_name/report.txt')
  or die "Could not open file 'some_strange_name/report.txt'";
```

will print

```
Could not open file 'some_strange_name/report.txt' ...
```

It is better, but at some point someone will try to change the path to the correct directory ...

```perl
open(my $fh, '>', 'correct_directory_with_typo/report.txt')
  or die "Could not open file 'some_strange_name/report.txt'";
```

...but you will still get the old error message because they changed it
only in the open() call, and not in the error message.

```
Could not open file 'some_strange_name/report.txt' No such file or directory ...
```


It is probably better to use a variable for the filename:

```perl
my $filename = 'correct_directory_with_typo/report.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename'";
```

Now we get the correct error message, but we still don't know why it failed.
Going one step further we can use `$!` - a built-in variable of Perl - to print
out what the operating system told us about the failure:

```perl
my $filename = 'correct_directory_with_typo/report.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
```

This will print

```
Could not open file 'correct_directory_with_typo/report.txt' No such file or directory ...
```

That's much better.

With this we got back to the original example.

## Greater-than?

That greater-than sign in the open call might be a bit unclear,
but if you are familiar with command line redirection then this can be familiar to you too.
Otherwise just think about it as an arrow showing the direction of the data-flow:
into the file on the right hand side.

## Non-latin character?

In case you need to handle characters that are not in the ASCII table, you'll probably want to save them
as UTF-8. To do that you need to tell Perl, you are opening the file with UTF-8 encoding.

```perl
open(my $fh, '>:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename'";
```


## Comments

Why is it that there is always error checking on open and close, but never on print? Even the examples in perldoc don't check the print for success. I had to modify a script that opens a pipe to another process, then forks some children, who all at one point or another write to the pipe. The process that is piped to happens to do some validation on the input, and at one point actually died (it printed the error, but then the process disappeared). I would have expected the next write to the piped process to throw a Broken pipe error, but it did not. Instead, all of the forked processes went on their merry way, attempting to write to the closed pipe, and then completed normally. I've set autoflush on the pipe, and do some rudimentary locking/unlocking to ensure no two children write to the pipe at the same time, and that seems to fix the immediate issue, but why don't people do print or die?

---

I think it is a mix of laziness, the lower chance of problems happening during a print (to a file) than at the time of calling open(), and copy-paste examples. Probably the best solution though would be to use "autodie" so you won't need to add "or die" to every systemcall.

----

I finally had some time to run some tests on this. I created a script that would die on the first input record. The I wrote a script that opens a pipe to the first script, and then printed to it (with or die - and autoflush on). Then, the script printed to it again (with or die). I expected the second to throw a broken pipe error, but it did not. I saw my debug message indicating the first print, as well as a message from the child process indicating it was dying, and then a second debug message for the second print, then my completion message from the parent. No indication that the second print did not succeed.
So, I added a signal handler to trap the broken pipe signal, and here's where things started to happen. At first, it completed with success as before. But then, I added a sleep after the first print, so I could see if the child process was still running. With the sleep, the broken pipe signal does get thrown, and trapped, but only by the signal handler - not with print or die. So, where would this delay in throwing the broken pipe signal be happening?

<br>
Hello, I'm so weak when it comes to Linux programming, could you help me out to print the size of multiple to a text file?

<br>

Hi I have doubt

Im Running the below script and i have deleted the report.txt file after running in background but still script is running and i dont have report .txt file and may i know where the output will save

Script:
my $filename = 'report.txt';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
for($i=1;$i<=20;$i++)
{
print $fh "My $i report generated by perl\n";
sleep 1;
}
close $fh;
print "done\n";

perl i.pl &

rm report.txt

tail: cannot open `report.txt' for reading: No such file or directory

I just want to exit the script

<br>

My perl script runs for a long time (days). It occasionally gives output to a file, but perl collects a larger chunk of output before writing it to the file. I would like to see the output asap to modify the script if necessary. Is there a way to print immediately? (I'm thinking of something like TeX's \immediate\write.) Googled in vain. Thanks for any hints.

---

One way is to close the filehandle after every write and then reopen it in append mode for the next write. The other way is to "flush" the filehandle $fh->flush; every time you want to make sure it writes to the disk or to set up autoflush after you opened the file: $fh->autoflush.

For older versions of Perl you might need to "use IO::Handle;" for this.

<br>
Hi Gabor - I've inherited many scripts from my late co-dev who was a Perl monk, and I keep finding your useful pages, One point here I can't fathom is what permissions to give (say) the file to write to, and where that should be in the file system - I have one inside a directory in the user directory but outside the public html, but even with permissions at 777 (and owner/group as that user, same as all the files in his directory) the script returns "Permission denied". Can you add something to the article about getting this to run in a user's home folder on Linux? I was going to use this tutorial as a test, but need that information.

---
The problem is usually that the user who runs the script does not have the permissions to some part of the path where you'd like to write to.
If it is a RedHat system then you probably also have to overcome the SELinux permission as well.

Are you talking about the permissions of the script itself or the file where you are writing to? Is this a web application? Who runs the script and where are you trying to write to?


----
First, long delay - company suspended work on their site after Covid, not sure when it will resume! Second, thanks for the reply. It's not about the script permissions. It's a Debian server we maintain. The script (in ./cgi-bin) is 755 and called from a web page, the path to the document (666, in ./documents) is all within the user's home directory, all files are owner/group that user, and I've also tried www-data as user/group on the documents. Other scripts on the site work okay. Not so urgent now, but be good to get it working.

<br>

This thread came up in a search I was doing for a PERL/SSH problem I've been working so here goes, maybe you might be able to answer. I've been working on an SSH problem where a PERL script, running on Windows Server 2012, is using SSH to access an older OpenVMS system in order to be able to transfer some real-time files to the Windows Server for local processing. The PERL script, on the Windows side, is returning a "Permission Denied..." when it tries to access the service account's .ssh\config file. According to Windows the service account in question has full control of the .ssh directory and files within it so this shouldn't even be an issue. I eventually noticed that all the Archive bits were set on the files within the directory. Out of desperation and really, just for the heck of it I entered "attrib -a config" on the command line clearing the archive attribute on that file. When I ran the PERL script again after that it worked and has continued to work ever since.

What the heck does the archive bit have to do with file permissions? Is PERL confusing the Windows file Mode bits with the Unix/Linux file attributes and somehow coming up with the erroneous "Permission Denied..." error condition?

<br>

Just wondering. If you open a file so that it can be read or written too, do you also have to set the permissions with a CHMOD, or are they created with a 644? (I have about 12 scripts that create / open about 100+ files between them - not all running at same time - and don't really relish the thought of having to add "CHMOD 0644" to each entry!


