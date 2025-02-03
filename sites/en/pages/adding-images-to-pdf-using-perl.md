---
title: "Adding images to PDF using Perl"
timestamp: 2010-07-22T09:25:24
tags:
  - PDF::Create
published: true
archive: true
---




Posted on 2010-07-22 09:25:24.095335-07 by kodo

Hi, now forgive me for being new, I have PDF-Create working just wonderfully,
but I cannot find an example of an image being added to a pdf anywhere,
and I've search all day. I have installed (and using)

PDF::Image::GIF PDF::Image::JPEG

I've created the image object

```perl
my $image1 = new PDF::Image::JPEG('testImage.jpg');
```


All works up to here and the PDF document gets created fine,
but as soon as I try to add the image (the next line) to the page it stops working


```perl
$page2->image($image1, 100, 100, 1, 2, 1.0, 1.0 ,0, 0, 0);
```

I'm totally lost now having tried everything I can think of, posting here is my last resort.

Thanks in advance..

Posted on 2010-07-23 03:05:57.166507-07 by kodo in response to 12828

You might want to see the entire script, almost 100% of it is cut n pasted
directly from the CPan page. The only differences are the includsion
of PDF::Image::GIF and PDF::Image::JPG, the extra two lines of code
mentioned above and three lines at the bottom. As mentioned above the
script works fine without the one line that actually adds the image to the page.
And before you ask the image definately does exist, in the same directory as the script.

Thanks for your help...

```perl
#!/usr/bin/perl
use CGI qw(:all);
use PDF::Create;
use PDF::Image::GIF;
use PDF::Image::JPEG;
my $pdf = new PDF::Create(
    'filename' => 'mypdf.pdf',
    'Version' => 1.2,
    'PageMode' => 'UseNone',
    'Author' => 'EPC4U',
    'Title' => 'My title',
);

my $root = $pdf->new_page('MediaBox' => [ 0, 0, 612, 792 ]);
# Add a page which inherits its attributes from $root

my $page = $root->new_page;
# Prepare 2 fonts
my $f1 = $pdf->font(
  'Subtype' => 'Type1',
  'Encoding' => 'WinAnsiEncoding',
  'BaseFont' => 'Helvetica'
);

my $f2 = $pdf->font(
  'Subtype' => 'Type1',
  'Encoding' => 'WinAnsiEncoding',
  'BaseFont' => 'Helvetica-Bold'
);

# Prepare a Table of Content
my $toc = $pdf->new_outline('Title' => 'Document', 'Destination' => $page);
$toc->new_outline('Title' => 'Section 1');
my $s2 = $toc->new_outline('Title' => 'Section 2', 'Status' => 'closed');
$s2->new_outline('Title' => 'Subsection 1');
$page->stringc($f2, 40, 306, 426, "PDF::Create");
$page->stringc($f1, 20, 306, 396, "version $PDF::Create::VERSION");

# Add another page
my $page2 = $root->new_page;
$page2->line(0, 0, 612, 792);
$page2->line(0, 792, 612, 0);
$toc->new_outline('Title' => 'Section 3');
$pdf->new_outline('Title' => 'Summary');

# Add something to the first page
$page->stringc($f1, 20, 306, 300, 'by Fabien Tassin <fta@oleane.net>');
# Add something to the page 2
$page2->stringc($f1, 12, 306, 100, 'Test Content');
my $image1 = new PDF::Image::JPEG('testImage.jpg');

# image( image_id, xpos, ypos, xalign, yalign, xscale, yscale, rotate, xskew, yskew)
$page2->image($image1, 100, 100, 1, 2, 1.0, 1.0 ,0, 0, 0);
# Add the missing PDF objects and a the footer then close the file
$pdf->close;
print header;
print qq(Done.);
exit;
```

Posted on 2010-07-23 04:28:30.537206-07 by markusb in response to 12828

Hi Kodo,

The POD of PDF-Create shows how to imbed images.

Here the essential two lines you need. There is no need to include PDF::Create:JPEG.

```perl
my $jpg1 = $pdf->image($jpgname);
$page->image(
  'image' => $jpg1,
  'xscale' => 0.2,
  'yscale' => 0.2,
  'xpos' => 350,
  'ypos' => 400
);
```

Markus

Posted on 2010-07-23 05:03:07.501647-07 by kodo in response to 12831

Fantastic, thanks very much Markus. I admit I've a lot to learn still,
sometimes I struggle a bit with the syntax on the odd CPAN modules.
On the POD (http://search.cpan.org/~markusb/PDF-Create-1.06/lib/PDF/Create.pm)
does mention adding images, but with no code example, just a
few lines that to a newby like me are cryptic :(

image(<filename>)

+ a bit of text about Preparing an XObject


image( image_id, xpos, ypos, xalign, yalign, xscale, yscale, rotate, xskew, yskew)

+ a bit about why small GIF images wont work and a small bit about each paramiter.

No actual examples. Looking back at my previous attempts
I did get close on one ooccation with the following code,
but as you can see (and as I see now) while it was close it was completely wrong!
It seems so obvious now I see the correct code!


```perl
$page2->image(
  image_id => "$image1",
  xpos => '300',
  ypos => '500',
  xalign => '1',
  yalign => '2',
  xscale => '1.0',
  yscale => '1.0',
  rotate => '0',
  xskew => '0',
  yskew => '0'
);
```

Thanks again for the help, much appreciated!

Posted on 2010-07-23 07:30:37.836624-07 by markusb in response to 12832

No problem, happy it is working for you.

As usual, documentation could be better. I'm planning, in the
back of my head, to supply sample programs for all features.
I don't know yet what the best way to supply them would be, though.

Markus

Posted on 2013-08-23 01:05:28.655556-07 by abigail111 in response to 12828

You can just add image to pdf according to the demo code,or you can
create an imaging SDK,which can process pdf

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/12828 -->

