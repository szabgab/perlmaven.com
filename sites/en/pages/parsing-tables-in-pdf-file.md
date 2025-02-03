---
title: "Parsing tables in PDF files"
timestamp: 2011-12-19T12:39:30
tags:
  - CAM::PDF
published: true
archive: true
---



Posted on 2011-12-19 12:39:30.582827-08 by jesseb

Hi, I'm somewhat new to PERL and new to CAM-PDF. I'm trying to read the CAM-PDF documentation to learn how to parse pdfs, but it's a struggle.
I essentially want to parse the following PDF such that each cell is on one line in a text file: http://www.wvbom.wv.gov/List%20of%20Disciplinary%20Actions.pdf Any help would be great.

Posted on 2011-12-19 13:17:41.045708-08 by cdolan in response to 13581

CAM::PDF is a low-level library designed for high-performance manipulation of PDF syntax. It doesn't offer any help in deconstructing actual document content, unfortunately. I looked at your sample document a tiny bit, and with CAM::PDF, you'd be doing a lot of heuristic coding on the output of $pdf->getPageContentTree($pagenum)

Posted on 2012-01-07 06:06:07.91582-08 by jochenhayek in response to 13582

I have been using CAM::PDF and also "pdftohtml",
and I would like to suggest the latter for your task.
As Chris mentioned, "you'd be doing a lot of heuristic coding", but according to my experience you are better off with the output of "pdftohtml -xml", supposing you are fine with xml parsing.
I used XML::Simple for that purpose, but maybe you are more experienced.
There is no such concept as tables in PDF, and you would have to do a lot of guessing (-> heuristics) as to what are columns and rows and cells on these pages.
If you are really progressing on this, let us now!
Me personally, I am quite interested in that kind of utility as well, maybe I am going to work on it as well.

Posted on 2012-01-07 14:26:00.78895-08 by jochenhayek in response to 13581

Hi, I developed a perl script along the lines, that I described earlier,
(and some shell script for wrapping it,)
and I created a CSV file from your PDF file.

Are you interested in that (CSV+perl+shell -- only a 1st shot) ?
Let me know!

I leave the heuristics to "human intervention".

What do I mean by that?
The scripts lists per page and per document all the possible "physical" column numbers,
that you might want to specify.
Some of them do not really makes sense from the human perspective.
You tell the script at the 2nd run, which ones you regard as meaningful,
and the script creates "logical" columns for you.

Yes, this needs a more detailed description, I agree.
And maybe one by a native English speaker.


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/13581 -->

