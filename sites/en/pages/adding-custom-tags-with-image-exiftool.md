---
title: "Adding custom tags with Image::ExifTool"
timestamp: 2008-03-19T14:56:14
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2008-03-19 14:56:14-07 by sparkie

hi all This is going well! Got Perl installed, got ExifTool installed.
Tested a few calls to ImageInfo. What a treat - up pops all the metadata for my jpeg.
Right, what I now need is to be able to add custom tags to my JPEGS.
If I understand Phil's post from yesterday correctly, custom means XMP?
I thought SetNewValue was the one, but this method seems to be for
writing new values to existing tags. So, a wee code snippet
where a custom (brand new) tag is added to file would see me right.
What a fab tool set! Thanks again, Mark

Posted on 2008-03-19 15:38:50-07 by exiftool in response to 7404

Hi Mark,

From the Image::ExifTool documentation:

User-defined tags can be added via the ExifTool configuration
file or by defining the %Image::ExifTool::UserDefined hash
before calling any ExifTool functions. See " ExifTool_config"
in the ExifTool distribution for more details.

- Phil

Posted on 2008-03-19 16:49:52-07 by sparkie in response to 7405

Phil, thank you again for the quick reply.
Yes, I'd started to look at the sample config file but being new to Perl
the syntax got the better of me. Not your job to teach me Perl, I know!
What's confusing me is the kind of hierarchy that we seem to adding to.
I'd like to define, say, Mytag1, Mytag2 and Mytag3 within an XMP namespace called, say, myNs.
How would the sample look? This is how far I've got. I'm not really
clear on what the GROUPS element is for

```
%Image::ExifTool::UserDefined::myNs = ( GROUPS => { 0 => 'XMP', 1 => 'XMP-myNs', 2 => 'Image' },
# not sure what the third leve 'image' is doing here
NAMESPACE => { 'myNs' => 'http://ns.myNs.com/xxx/1.0/' },
WRITABLE => 'string',
```

now I get stuck: Since I'm defining a tag (not its value) what else
do I have to put in the curly braces. Your sample seems to add a further
assoc array within the tag elements ?? Mytag1=> { }, Mytag1=> { }, Mytag1=> { }, );
Sorry to harrass but this is clearly the best tool for the job and
I'm super keen to get this demoable. Thanks again. Mark

Posted on 2008-03-19 17:11:29-07 by exiftool in response to 7407

Hi Mark,

What you have done is basically correct.

The sample config file gives examples of how to set various attributes.
The "2 => 'Image'" sets the family 2 group name for tags in the table
(and is "Other" unless specified). This is simply used for catagorizing tags
for your convenience and doesn't affect what is written.

You don't need anything inside the braces in the tag definition
for simple strings in XMP. The examples show how to specify a
different family 2 group name for an individual tag, and how to make a "List"-type tag.
The "List" tags are written differently, and multiple may contain multiple
values (like a keywords list).

If you want to do anything more complex, check lib/Image/ExifTool/XMP.pm
for examples of how it is done, and read lib/Image/ExifTool/README
for all the gory details. Basically though, there is almost none of
this that you need to know if you just want to add simple tags with no special formatting.

Just 2 points:

1) you have given all your tags the same name, so only one tag will be defined.

2) you still need to add the new namespace to the Image::ExifTool::XMP::Main
table as is done in the sample config file.

- Phil - Phil

Posted on 2008-03-19 17:18:20-07 by sparkie in response to 7409

Fantastic. Last question, I hope, for the moment: Does the namespace have to exist?
Thank you. Mark

Posted on 2008-03-19 17:27:02-07 by sparkie in response to 7412

aha! I knew I'd be back. Having defined my UserDefined hash, how do write
the call to WriteInfo. This doesn;t work ... alas:

```
$ExifTool->SetNewValue('Tag3','Val1');
$ExifTool->SetNewValue('Tag3','Val3');
$ExifTool->SetNewValue('Tag2','Val2');
$ExifTool->WriteInfo($picFile, $picFileMod);
```

merci mille fois

Posted on 2008-03-19 17:54:27-07 by exiftool in response to 7414

You define the namespace prefix and the namespace URI with the NAMESPACE entry.
It doesn't have to exist anywhere else beforehand.

Your code should work. Check with the exiftool application and read the
FAQ if you are having problems with the user-defined tags.

- Phil

Posted on 2008-03-20 10:24:51-07 by sparkie in response to 7416

Phil, is this OK for adding a namespace to the table. I'm still getting a
tag does not exist error. My namespace is 'defra'

```
%Image::ExifTool::UserDefined = (
   'Image::ExifTool::XMP::Main' => {
       defra => {
           SubDirectory => {
              TagTable =< 'Image::ExifTool::UserDefined::defra',
           },
       },
   }
);
```

Do I need to address the namespace when I call SetNewValue? Something like;

```
$ExifTool->SetNewValue('defra::Tag1','Val1');
```
???
Slowly getting there... Mark

Posted on 2008-03-20 11:55:24-07 by exiftool in response to 7421

Hi Mark,

This looks good to me, but obviously something is wrong.
Could you post your full .ExifTool config file (inside a ``` </code> block in this forum)?

You don't need to specify the group when you call SetNewValue,
but if you do it is done like this:

```
$ExifTool->SetNewValue('XMP-defra:Tag1','Val1');
```

- Phil

Posted on 2008-03-20 12:52:36-07 by sparkie in response to 7422

Hello, Phil. Here's my code: I really appreciate this.
I'm running the config code inline for now:

```perl
#!usr/bin/perl
use warnings;
# ============================== Load modules ====================================
#use DBI;
use Image::ExifTool qw(:Public);

my $picFile, $picFileMod;
$picFile = 'C:\pics\pic2.jpg';
$picFileMod = 'C:\pics\pic2ModByExifTool.jpg';
#define ExifTool object;
my $ExifTool = new Image::ExifTool;

%$ExifTool::UserDefined::defra = (
    GROUPS => { 0 => 'XMP', 1 => 'XMP-defra', 2 => 'Image' },
    NAMESPACE => { 'defra' => 'http://ns.defra.com/' },
    WRITABLE => 'string',
    Tag1 => {},
    Tag2 => {},
    Tag3 => {}
);

%$ExifTool::UserDefined = (
      # new XMP namespaces (ie. XMP-xxx) must be added to the Main XMP table:
    'Image::ExifTool::XMP::Main' => {
        defra => {
            SubDirectory => {
                TagTable => '%$ExifTool::UserDefined::defra'
            },
        },
    }
);

if(-e $picFile)
{
    my $info = $ExifTool->ImageInfo($picFile);
    print '\n';
    print '\n';
    foreach (keys %$info) {
        print "$_ => $$info{$_}\n";
    }
    $ExifTool->SetNewValue('Tag1','Val1');
    $ExifTool->SetNewValue('Tag2','Val2');
    $ExifTool->SetNewValue('Tag3','Val3');

    $ExifTool->WriteInfo($picFile, $picFileMod);
}

print 'After mod=============================================== \n';
my $info = ImageInfo($picFileMod);
foreach (keys %$info) {
    print "$_ => $$info{$_}\n";
}
```

Posted on 2008-03-20 13:17:49-07 by exiftool in response to 7423

Hi Mark,

It is clear you are struggling a bit with Perl.
You have inserted a '$' symbol and removed the required "Image::" in the tag table names.
Also the '%' isn't used when giving the table name in the value for TagTable.
As well, you need brackets around your list of variables after "my",
and the "\n" needs to be in double quotes because it is taken literally
in single quotes. So try this:

```perl
#!/usr/bin/perl
use warnings;
# ============================== Load modules ====================================
#use DBI;
use Image::ExifTool qw(:Public);

my ($picFile, $picFileMod);
$picFile = 'a.jpg';
$picFileMod = 'b.jpg';
#define ExifTool object;
my $ExifTool = new Image::ExifTool;

%Image::ExifTool::UserDefined::defra = (
    GROUPS => { 0 => 'XMP', 1 => 'XMP-defra', 2 => 'Image' },
    NAMESPACE => { 'defra' => 'http://ns.defra.com/' },
    WRITABLE => 'string',
    Tag1 => {},
    Tag2 => {},
    Tag3 => {}
);

%Image::ExifTool::UserDefined = (
      # new XMP namespaces (ie. XMP-xxx) must be added to the Main XMP table:
    'Image::ExifTool::XMP::Main' => {
        defra => {
            SubDirectory => {
                TagTable => 'Image::ExifTool::UserDefined::defra'
            },
        },
    }
);

if(-e $picFile)
{
    my $info = $ExifTool->ImageInfo($picFile);
    print "\n\n";
    foreach (keys %$info) {
        print "$_ => $$info{$_}\n";
    }
    $ExifTool->SetNewValue('Tag1','Val1');
    $ExifTool->SetNewValue('Tag2','Val2');
    $ExifTool->SetNewValue('Tag3','Val3');

    $ExifTool->WriteInfo($picFile, $picFileMod);
}

print "After mod=============================================== \n";
my $info = ImageInfo($picFileMod);
foreach (keys %$info) {
    print "$_ => $$info{$_}\n";
}

#end
```

Also, you will save yourself a lot of headaches in the future
if you check the return value from WriteInfo() and Error and Warning
messages to see if there were any problems when writing the file.
The the API documentation on WriteInfo for details.

- Phil

Posted on 2008-03-20 14:10:02-07 by sparkie in response to 7424

Rock and Roll! I see my tags in the output. Yes.
Absolutely brand new to Perl and trying something a bit more ambitious than Hello World.
Running before I can walk! 4 years of PHP are no help to me at all!
I put the $ symbol in thinking that I could load the config to my $ExifTool object.
And in that logic, we no longer need the Image:: prefix?? The config elements
seem to address a static class. I had realised a Hash is designated with a %.
Sorry for that one. So for my first perl script it's been a journey.
The client is going to call me this afernoon to see if we can write metadata to his assets.
I will now be able to answer 'Yeah. Absolute walk in the park. No bother. ' .... ;-)

Phil, thank you very much indeed. It's a brilliant tool set.
Someone should actually write a book on it!

Regards Mark

Posted on 2008-12-01 16:19:25-08 by wanderingstan in response to 7425

Thanks Mark & Phil for sharing this conversation. It saved me a ton of trouble --
and saved my Perl-expert friends from incessant questioning.
And thanks Phil for this incredible tool. There's no way I would have attempted
my family's image-archiving project without it. -Stan

Posted on 2009-08-21 19:18:51-07 by gloubibou in response to 9471

Very interesting read!

Is it possible to achieve the same thing using exiftool at the command line?

Pierre

Posted on 2009-08-21 19:28:56-07 by exiftool in response to 11349

Hi Pierre,

User-defined tags can not be defined at the command line.
But after you define them in the exiftool config file you can use them at the command line.

- Phil

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/7404 ->


