---
title: "threads: Free to wrong pool"
timestamp: 2006-07-18T21:52:45
tags:
  - threads
published: true
archive: true
---



Posted on 2006-07-18 21:52:45-07 by dmb

In the last posting I overlooked the last message which is probably the cause of the crash.
The message was: Free to wrong pool 23856c8 not 222c80 during global destruction.
Is there a way of avoiding this problem?

Posted on 2006-07-18 23:04:15-07 by jdhedden in response to 2642

1. You need to ensure you're using the lastest version of the 'threads' module from CPAN.

2. Not all modules are thread-safe, especially modules that use XS code.
Therefore, whatever module you're getting the ->Documents method from may be at fault.

Posted on 2006-07-18 23:59:28-07 by dmb in response to 2643

1) I just downloaded the threads module from CPAN (associated with your name)
a few days ago. Is ther a way to confirm that I have the correct one?

2) I understand that other non-Perl modules may not be thread-safe.
By the time I get to the logic that is executed by the threads
I no longer need the parent context where the 'Documents' and other
strings were referenced. Is there a way to isolate the prior context (or quiesce it)
before initiating the execution of the threaded logic?
For instance is there a practical way of dividing the processing up into two steps in Perl
so that the step 1 context is discarded before starting the multi-threaded step?

Posted on 2006-07-19 13:50:39-07 by jdhedden in response to 2644

You can get the version number using:

```
perl -Mthreads -e 'print "$threads::VERSION\n"'
```

As of this posting, the lastest version is 1.36.

To keep non-thread-safe modules out of threads, you can create the threads
in a BEGIN block before including the non-thread-safe modules, and then feed
data to the threads using queues:

```perl
use threads;
use Thread::Queue;

# Thread function that gets data via a queue
# (NOTE:  Must be coded up before the BEGIN block.)
sub thr_func {
    my $que = shift;

    # Wait for data
    my $data = $que->dequeue();

    # Do work on $data
    ...
}


# Create threads and queues
# (NOTE:  Threads must be created in a BEGIN block before
#         'use'ing any non-thread-safe modules.)
my %threads;
BEGIN {
    for (1..5) {
        my $que = Thread::Queue->new();
        my $thr = threads->create('thr_func', $que);
        $threads{$thr->tid()} = [ $thr, $que ];
    }
}


# Get data using non-thread-safe modules
use Non::Thread::Safe::Module;

foreach my $tid (keys(%threads)) {
    # Get data
    my $data = ...

    # Give data to thread
    my ($thr, $que) = $threads{$tid};
    $que->enqueue($data);
}


# Wait for all threads to finish
$_->join() foreach threads->list();
```


Thread::Queue only works with scalars. If you need to pass anything more complex
to the threads, then use Thread::Queue::Any.

In regards to one of your earlier posts, note the last statement
for waiting on the threads. You don't have to worry about joining the main thread:
'threads->list()' only returns non-detached threads, and the main thread is detached.

Posted on 2006-07-19 14:01:31-07 by dmb in response to 2647

Thank you very much for the additional information.
I have downloaded threads version 1.36 and am have gone through the first
two intallation steps and appear to be stuck in the "make test" step with the
following line at the bottom: t/kill..........ok 13/19

Is this normal? The only way I know to break out of this condition is to use a CTRL-C.

Posted on 2006-07-19 14:11:13-07 by jdhedden in response to 2648

This does indicate a bug, but for your purposes it shouldn't matter.
Go ahead and install. As for me begin able to troubleshoot this issue,
please send me the output from the following:

```
perl -Mblib t/kill.t
perl -V
```

Don't post to the forum, but email me directly: jdhedden AT cpan DOT org

Posted on 2006-12-14 12:29:18-08 by imran in response to 2642

I read the previous messege of the problem with perl in threading
I am using Active perl version 5.8.8 Build 817 and with it the threading
version 1.3 i am using win32::ole module also to work with the excel sheets.
In my programe i am using four threads which are independent( made them to detach)
they start gives me output and then i start geting following errors:

```
Attempt to free non-existent shared string 'Selection',
Perl interpreter: 0x25a6ba4 during global destruction
Attempt to free non-existent shared string 'Workbooks',
Perl interpreter: 0x25a6ba4 during global destruction
Attempt to free unreferenced scalar: SV 0x23bd058,
Perl interpreter: 0x58baebc during global destruction
Win32::OLE(0.1707): GetOleObject() Not a Win32::OLE object during global destruction
Attempt to free non-existent shared string 'Worksheets',
Perl interpreter: 0x5b650dc during global destruction.
Free to wrong pool 5b636a0 not 15d26e8 during global destruction.
Thread 8 terminated abnormally: Undefined subroutine &Carp::shortmess_heavy called at
c:/Perl1/lib/Carp.pm line 258
```

Can any 1 please help in in this regard i am attaching the snipet of code dealing with thread as

```perl
for ($j=1; $j<=$col1; $j++) {
            for ($i=1; $i<=$row1; $i++) {
                if ($ram1->Cells($i,$j)->{Value} =~ /^.*$table[$z].*$/) {
                    print "$i\t$j...\n";
                    $sheet = $ram1;
                    my $thread1 =  threads->new( &table11,$i,$j,$k,$l,$sheet,$ram1);
                    $retval1 = $thread1->detach();
                    print"Going in table11 thread\n";
                    #table11 ($i,$j,$k,$l,$sheet);
                    last;
                }
            }
        }


sub req {

    $a = $_[0];
    $b = $_[1];
    $c = $_[2];
    $d = $_[3];
    $sheet = $_[4];

    $a1 = $a+2;
    $b1 = $b;
    $c1 = $c+2;
    $d1 = $d+1;

    print "req $c1\t$d1\n";

    if ($sheet->Cells(($a+1),$b)->{Value} =~ /^.*US.*$/) {

        while ($sheet->Cells($a1,$b1)->{Value} !~ /^\s*$/) {
            $ram3->Cells($c1++,$d1)->{Value} = $sheet->Cells($a1++,$b1)->{Value};
        }
    }elsif ($sheet->Cells(($a+1),$b)->{Value} =~ /^.*DS.*$/) {
        while ($sheet->Cells($a1,$b1)->{Value} !~ /^\s*$/) {
            $ram3->Cells($c1++,$d1+1)->{Value} = $sheet->Cells($a1++,$b1)->{Value};
        }
        }
    }

sub table11 {
#    local $i,$j,$k,$l,$sheet;
#    $a = i;
#    local$b = $j;
#    $c = $k;
#    $d = $l;
#    $sheet = $sheet;
#    local $a = $_[0];
#    local $b = $_[1];
#    local $c = $_[2];
#    local $d = $_[3];
#    local $sheet = $_[4];

    $a = $_[0];
    $b = $_[1];
    $c = $_[2];
    $d = $_[3];
    $sheet = $_[4];


    print "table11 $c\t$d\n";

    # For copying the loop lengths
    $a1 = $a+2;
    $c1 = $c+2;

    while ($sheet->Cells($a1,$b)->{Value} !~ /^\s*$/) {
        $ram3->Cells($c1++,$d)->{Value} = $sheet->Cells($a1++,$b)->{Value};
    }

    # For copying the required data rates...
    $b1 = $b;

    while ($sheet->Cells($a,$b1)->{Value} !~ /^\s*$/) {
        if (($sheet->Cells($a,$b1)->{Value} =~ /^.*Req.*$/) && ($sheet == $ram1)) {
            my $thread2 =  threads->new( \&req,$a,$b1,$c,$d,$sheet);
            $retval2 = $thread2->detach();
            #$retval = $thread1->eval;   # catch join errors

        }

        elsif ($sheet->Cells($a,$b1)->{Value} =~ /^.*Act.*$/) {

            my $thread3 =  threads->new( \&act ,$a,$b1,$c,$d,$sheet);
            $retva3 = $thread3->detach;   # catch join errors
            #act ($a,$b1,$c,$d,$sheet);

        } elsif ($sheet->Cells($a,$b1)->{Value} =~ /^.*Mrg.*$/) {
           my $thread4 =  threads->new( \&mrg ,$a,$b1,$c,$d,$sheet);
           $retva3 = $thread4->detach();   # catch join errors
            #mrg ($a,$b1,$c,$d,$sheet);

        }

        $b1++;

    }



    $ram1 -> Activate;
    $ram1 -> Cells(2,1) -> Select;
    $ram2 -> Activate;
    $ram2 -> Cells(2,1) -> Select;
    $ram3 -> Activate;
    $ram3 -> Cells(2,1) -> Select;

    # Output file path...
    $fille11 ="test_danube";
    $oldfirm = "Amz";
    $comp = $file11."-".$oldfirm.".xls";
    $workbook3->SaveAs($comp);
    $workbook3->Close;

    $workbook->Save;
    $workbook->Close;

    $workbook1->Save;
    $workbook1->Close;

    $workbook2->Save;
    $workbook2->Close;

    $application->Quit(); # leave excel
    undef $application;
    undef $workbook1;
    undef $workbook,
    undef $workbook2;
    undef $workbook3;

    print "\nAnnex-A NA Comparison finished.....\n";

  }
    sub mrg {

    $a = $_[0];
    $b = $_[1];
    $c = $_[2];
    $d = $_[3];
    $sheet = $_[4];
    $a1 = $a+2;

    $b1 = $b;

    $c1 = $c+2;

    $d1 = $d+9;

    if ($sheet == $ram2) {
        $d1++;
    }

    print "mrg $c1\t$d1\n";

    if ($sheet->Cells(($a+1),$b)->{Value} =~ /^.*US.*$/) {
        while ($sheet->Cells($a1,$b1)->{Value} !~ /^\s*$/) {
            $ram3->Cells($c1++,$d1)->{Value} = $sheet->Cells($a1++,$b1)->{Value};
        }
    } elsif ($sheet->Cells(($a+1),$b)->{Value} =~ /^.*DS.*$/) {
        while ($sheet->Cells($a1,$b1)->{Value} !~ /^\s*$/) {
            $ram3->Cells($c1++,$d1+3)->{Value} = $sheet->Cells($a1++,$b1)->{Value};
        }
    }
}
# For the actual data rate fields
sub act {


    $a = $_[0];
    $b = $_[1];
    $c = $_[2];
    $d = $_[3];
    $sheet = $_[4];

    $a1 = $a+2;

    $b1 = $b;

    $c1 = $c+2;

    $d1 = $d+3;

    if ($sheet == $ram2) {
        $d1++;
    }

    print "act $c1\t$d1\n";

    if ($sheet->Cells(($a+1),$b)->{Value} =~ /^.*US.*$/) {
        while ($sheet->Cells($a1,$b1)->{Value} !~ /^\s*$/) {
            $ram3->Cells($c1++,$d1)->{Value} = $sheet->Cells($a1++,$b1)->{Value};
        }
    } elsif ($sheet->Cells(($a+1),$b)->{Value} =~ /^.*DS.*$/) {
        while ($sheet->Cells($a1,$b1)->{Value} !~ /^\s*$/) {
            $ram3->Cells($c1++,$d1+3)->{Value} = $sheet->Cells($a1++,$b1)->{Value};
        }
    }
}
```

waiting for prompt reply Regards Imran Khalid

Posted on 2006-12-14 14:06:39-08 by jdhedden in response to 3763

Win32::OLE is not thread-safe. You may be able to rewrite your
code using the fork module from CPAN.

In any case, you should also upgrade to the latest versions of
the 'threads' and 'threads::shared' modules off of CPAN.

Posted on 2006-12-14 14:27:12-08 by imran in response to 3766

thanks for the reply but the thing is that i am using win2000
and fork cannot be installed on windows as stated by description of fork here
Using this module only makes sense if you run on a system that has an implementation
of the fork function by the Operating System. Windows is currently
the only known system on which Perl runs which does not have an implementation of fork.
Therefore, it doesn't make any sense to use this module on a Windows system.
And therefore, a check is made during installation barring you from installing on a Windows system.
Can you please suggest me something else to get out of this problem
it is getting on my nerves regards Imran khalid

Posted on 2006-12-14 14:46:48-08 by jdhedden in response to 3770

One approach that is documented in the POD discusses loading
non-threadsafe modules inside the threads themselves,
and/or after all threads have been created.
If that doesn't work, I think you may be out of luck.

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/2642 -->
