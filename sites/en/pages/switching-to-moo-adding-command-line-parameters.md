---
title: "Switching to Moo - adding command line parameters"
timestamp: 2015-06-01T10:40:01
tags:
  - Moo
  - MooX::Options
published: true
books:
  - moo
  - mbox
author: szabgab
---


Returning to the project after 3 weeks break was not easy. I ran the script again and it finished within a few seconds.
I looked at the log file that only had two lines. What happened?


## Moo-based code

Oh, right, I still have the code that will limit the processing to 20 messages. I remember, this already bothered
me earlier that I have to change the code in order to do a limited run. So let's make that conditional on a command line parameter.

There is quite a nice way to do this with [Moo and MooX::Options](/command-line-scripts-with-moo) so we are going to do that.
Turn the whole script into a [Moo](/moo)-based class and then use MooX::Options for the command line.

```perl
use Moo;
use MooX::Options;
```

Replace `process($path_to_dir);` by 

```perl
main->new_with_options->process($path_to_dir);
```

And change the first line for the `process` function from `my ($dir) = @_;` to the following code:

```perl
my ($self, $dir) = @_;
```

to accept both the instance object and the directory.

Then I ran the script again. It was still running and still finishing in a few seconds.

## Command line parameters

The next step is to start really using `MooX::Options` for processing the command line options.
Currently the script expects exactly one parameter, the path to the mail directory.

We remove the line that gets the parameter from the command line, 
`my $path_to_dir = shift or die "Usage: $0 path/to/mail\n";`
we won't need to do it ourselves any more. 

Instead we add the declaration of the "path" option:

```perl
option path    => (is => 'ro', required => 1, format => 's',
    doc => 'path/to/mail');
```

Now we don't have the `$path_to_dir` in the main body of the script so we
stop passing it to the `process()` method:

```perl
main->new_with_options->process();
```

Also inside the `process` method we are now expecting only the instance object
while what we got in the `$dir` variable earlier will be found in the 
`path` attribute of the object:

Replace

```perl
sub process {
    my ($self, $dir) = @_;
```

by this:

```perl
sub process {
    my ($self) = @_;

    my $dir = $self->path;
```

If we run the script as `perl bin/mbox-indexer.pl /path/to/mail` we will get the usage message as now we have to
provide the `--path` command line option name and run the script like this:
`perl bin/mbox-indexer.pl --path /path/to/mail`.

And the script still runs. Great!

## Parameter for processing limit

Now the real thing. We add a command line option called `--limit` that will accept a number. If it is provided,
we will stop processing the mailboxes after the given number of messages.

First thing is that we add a command line option which accepts and integer (`format => 'i'`) and is not required.

```perl
option limit   => (is => 'ro', required => 0, format => 'i',
    doc => 'limit number of messages to be processed');
```

Then in the main loop we replace the hard coded limit: `exit if $count > 20;`

by this code:

```perl
exit if defined $self->limit and $count > $self->limit;
```

We only compare `$count` with limit if there was a limit set.

Now if we run the script as above it will take a long time (almost 4 minutes for me)
because it processes all the files. If we want to limit it to the first 20
we also need to pass `--limit 20` on the command line.

