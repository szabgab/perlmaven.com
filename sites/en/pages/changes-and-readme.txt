=title Changes and README files in a Perl distribution
=timestamp 2017-03-17T07:00:11
=indexes Changes, README
=tags screencast
=books advanced
=status show
=author szabgab
=comments_disqus_enable 0

=abstract start

The <hl>Changes</hl> and <hl>README</hl> files are two free-form files, though the the <hl>Changes</hl> files
usually have a common form. Recently work has been done to
create a <a href="https://metacpan.org/pod/CPAN::Changes::Spec">specification for the Changes file</a>.

=abstract end

<slidecast file="advanced-perl/libraries-and-modules/changes-and-readme" youtube="tlrm0Zm3Lr8" />

Even the name of the Changes file is not standardizd. Some people write <hl>CHANGES</hl>,
others write <hl>Changes</hl>, yet others write <hl>ChangeLog</hl>.

It usualy includes entries for each release with the version number and date of release,
and then a list of major changes. Sometime indicating the bug number that were fixed or
the person who sent in those changes.

<code>
v0.02 2007.11.23

    Added feature for doing something
    Fixed strange bug causing trouble (#7)


v0.01 2007.10.12

    Releasing first version of Application
</code>


The README file used to be important before CPAN had a web interface, today it
is quite unclear what should be in it.

brian d foy had an
<a href="http://blogs.perl.org/users/brian_d_foy/2015/01/what-should-be-in-a-cpan-distro-readme.html">article discussing this</a>


