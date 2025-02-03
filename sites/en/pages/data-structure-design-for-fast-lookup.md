---
title: "Data structure design for fast lookup"
timestamp: 2015-07-14T07:30:01
tags:
  - opendir
published: true
author: szabgab
archive: true
---


For a beginner even deciding when to use a hash and when an array might be challenging, but when it
gets to more complex data structures, this can be a real challenge.


For example, let's say you have a system of lots of applications and you are doing part of the job of
Configuration Management or a build system. Each application has modules, in each module there are
source files, included file, libraries. Each one of these is in a separate directory.
Let's say you have a directory structure that looks like this:

```
DLL/
    libplatform_fib_mpls_ltrace/
        src/
            vkg_fib_mpls_ltrace_decoder.c
            vkg_fib_mpls_ltrace_encoder.c
        libs/
            libcerrno
            libinfra
            libltrace_show
            libltrace
            libsysmgr
            libim_debug_utils
    libimdr_cerrno/
        src/
            dnx_aib_print.c
        libs/
            libios
            libcerrno
            libdnx_fwdlib_utils
            keep_objects
Main/
    eint_udp_server/
        src/
            eint_udp_server.c
        libs/
            libsocket
            libinfra
    spm_synckeys/
        src/
            spm_sys.c
        libs/
            libnvram_secure
            libplatform
            libplatform_netio
            libnodeid
            lrdlib
```

Except that you have 200,000 files in thousands of projects.

You are required to load them into memory and then to answer some questions.

The immediate and seemingly obvious way is to create multi-level hash that where each level of the hash corresponds to the same level
in the directory structure and the files are elements of arrays deep in the data structure. So the first entry from the above
sample of the file system would look like this:

```perl
$data{'DLL'}{'libplatform_fib_mpls_ltrace'}{'src'} = [
            'vkg_fib_mpls_ltrace_decoder.c',
            'vkg_fib_mpls_ltrace_encoder.c',
];
```

Constructing this data structure is quite easy, if you know how to [traverse the file-system](/traversing-the-filesystem-using-a-queue).

This is a solution using only core perl and very simple perl script writing:

{% include file="examples/populate_hash.pl" %}

Then we are faced with various tasks.

For example there is a structure that looks something like this

```
DLL->libplatform_fib_mpls_ltrace->src->vkg_fib_mpls_ltrace_encoder.c
```

Given the values 'DLL', 'src', 'vkg_fib_mpls_ltrace_encoder.c' we are expected to return 'libplatform_fib_mpls_ltrace'.

Given the data structure we build the only way to achieve this is to go over all the keys in %{ $data{DLL} }
and for each key check if the rest of the data are in the subkeys.
We can create a function for this:

```perl
print get_library('DLL', 'src', 'vkg_fib_mpls_ltrace_encoder.c') , "\n";

sub get_library {
    my ($project, $type, $file) = @_;
    foreach my $library (keys %{ $data{$project} }) {
        foreach my $filename (@{ $data{$project}{$library}{$type} }) {
            if ($filename eq $file) {
                return $library;
            }
        }
    }
    return;
}
```

This works, but if we need to look up many pieces of information, the two foreach loops will make this code
very slow.

The full script is here, in case you'd like to run it:

{% include file="examples/read_project_dirs.pl" %}

## Designing the data structure

This happens because we mapped the data as it was laid out in the source. Each level of the filesystem was mapped
to a level in the hash. What we need to do instead is to create a data structure that will make it easy to look-up whatever we need to look up.

If we need to be able to look up data based on project, type, and file, then we should create a data then we should create a data structure
that has there three types as 3 levels of the hash.

Assuming the project-type-file triple is unique, (and that's what we assumed in our previous solution as well), then we can write this, in the 
most inner loop of the `collect_data` function instead of the call to `push`.

```perl
$data{$project}{$type}{$file} = $library;
```

If, as later I was told, we can assume that the files are unique throughout the whole system, then we don't even need to create such deep data structure.
We can create a really flat one using this:

```perl
$data{$file} = [$project, $library, $type];
```

Then, when someone wants to find out the library, based on project-type-file triple, we can disregard the project-name and type-name as they are
not necessary for the unique identification of the library.

In both cases the `get_library` function will be reduced to a single hash look-up. This is light years faster than those two foreach loops.

Even if we cannot be sure that the files have unique names through the whole system we could use something like this:

```perl
$data{$file}{$project}{$type} = $library;
```

Then if the user gives the project-type-file triple, we can look it up directly, and if the user gives us a single filename
we might have to provide multiple results. In that case we can write something like this:

```perl
sub get_library {
    my ($file) = @_;
    my @libraries;
    foreach my $project (keys %{ $data{$file} }) {
        foreach my $type (keys %{ $data{$file}{$project} }) {
            push @libraries, $data{$file}{$project}{$type};
        }
    }
    return @libraries;
}
```

Although in this case we have two foreach loops, but they are going to run much faster because there are going to be very few
projects and very few types where a given file is used, and we really need to go over those anyway as we need to return them all.

