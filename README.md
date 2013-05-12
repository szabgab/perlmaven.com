Perl Maven
==============

These are the source files of the articles published on http://perlmaven.com/ and its subdomains.

Copyright Gabor Szabo except where the =author field explicitly shows someone else.
Translations are copyright the translator (mentioned in the =translator field of each file) and Gabor Szabo.


FORMAT
=======
The format has evolved from POD, HTML and Docbook. It is now a mess. I know. I'll have to clean that up.

The overview:

In the header there are

    =key value

pairs of meta information. Currently the order is important, but I (Gabor) can check it and
rearrange it before publication. So don't worry about the order.

The text between

    =abstract start

    =abstract end

is displayed on the front pages and is included in the RSS/Atom feed.


`<h2>` is used for internal titles.

`<hl></hl>` stands for highlight and usually code-snippets inside the text are marked with these.

`<b></b>` is usde to mark other imporant pieces. 

Code snippets are wrapped in 

    <code lang="perl">
    </code>



CONTRIBUTIONS
==============

(both article writers and translators, please read  option 2 here: 
http://support.google.com/webmasters/bin/answer.py?hl=en&answer=1408986
and add the perlmaven.com site to the list of where you contribute.
Add an 128x128 image of you to the img/ folder and an entry for yourself
in the authors.txt file of your language.


Mailing list
-------------

There is an invitation only, but publicly archived mailing list
for the the people who would like to contribute to the Perl Maven
site. A couple of ways to contribute:
- translate an article to a language
- proofreading in any language (including English)
- promote the articles in one or more languages
- site design
- site code (once it becomes open source)
- write original content for the English site

The mailing list can be found here:

http://mail.perlmaven.com/mailman/listinfo/perlmaven-contributor

If you'd like to participate, please contact Gabor.


TRANSLATIONS - LOCALIZATION
---------------------------
Each language has a subdirectory in the sites/ folder.

Initial language codes were a bit random, but we will try to stick to
the way Wikipedia describes: https://meta.wikimedia.org/wiki/List_of_Wikipedias

* English                 en  (the 'original' files)
* Simplified Chinese      cn
* Traditional Chinese     tw
* Esperanto               eo
* French                  fr
* German                  de
* Hebrew                  he
* Indonesian              id
* Italian                 it
* Korean                  ko
* Nepali                  ne
* Portuguese (Brazilian)  br  (sorry Bretons)
* Romaninan               ro
* Russian                 ru
* Spanish                 es
* Telugu                  te


* The file names (that become the URLs) should be in LOCAL_LANGUAGE, but use only ASCII characters.
  Transliterated to English. (I am not sure in this. Maybe a better thing would be to use LOCAL_LANGUAGE in the URLs?)
  http://support.google.com/webmasters/bin/answer.py?hl=en&answer=182192 .
* The file names should more-or-less match the title of the page, they can contain words separated with dashes.
* Please add the header to each file (the meta information) including the planned publication date
* The links in the page should be working. If there is already a translation for the target page then link there,
  if it only exists in English, then please use full URLs including the hostname http://perlmaven.com/ .
* Please update the hidden(!) section of the perl-tutorial.tt to include the links to the entries.
* The text listing the author and the translator are added by the system and are driven from the header
  tags =author and =translator.
* Each author and translator has to have an entry in the authors.txt file listing a nickname (\w characters only),
  The full name, the name of the image file containing their picture, link to their G+ profiles.
* Each author and translator needs to provide a picture in jpg or png format approximately 128x128 pixel size 
  (an Avatar) to be shown at the bottom of each article.
* Each author and translator should set up authorship by linking their Google+ profile to the CC.perlmaven.com
  site. (e.g. br.perlmaven.com for the Brazilian Porguguese translators)
  See http://support.google.com/webmasters/bin/answer.py?hl=en&answer=1408986


The translation process:
* The translator creates a new file in the sites/CC/drafts folder.
* When s/he has finished the translations
* * if s/he wants to publish the article ASAP then: 
    adds the link to the translation in the perl-tutorials.tt file in the open part,
    and moves the translated file to the sites/CC/pages folder.
    and updates the =timestamp in the translated file to the current date/time.

* * if s/he wants to let Gabor schedule the publication then:
    adds the link to the translation in the perl-tutorials.tt file in a commented part,
    and moves the translated file to the sites/CC/done folder.
* Push to your repository and send a pull request.
* Gabor will periodically merge the pull requests and push the source to the live site.
  He will try to check for html issues, but cannot check the correctness of the translations.
  He can easily see which translations are ready (in the done/ folder) and he can move them
  one-by-one to the sites/CC/pages/ directory, enable the entry in the perl-tutorials.tt file,
  update the =timestam and publish the new article.
  Then he can include the article(s) in the mail sent to the subscribers of the Perl Maven site.



Comments
=========
We use https://disqus.com/ as the commenting system. The English version is moderated by Gabor.
If you'd like to enable comments on your language, and if you are willing to moderate it then
please create an account on https://disqus.com/ and tell Gabor about it.

Moderation requires that you follow all the comments that arrive to the site and see if they need
any attention. Spams are usually filtered by Disqus, but a few can slip through and there can be
an occassional false positive, something that is marked as spam but it isn't really.
The moderator also has to make sure that the comments stay civil and not hesitate to remove
irrelevant or offending comments.

Getting started with the translation
------------------------------------
* Sign up to Github, configure Git on your computer (name, email)
* Fork the https://github.com/szabgab/perl5maven.com repository and clone the fork to your computer
* Check on https://meta.wikimedia.org/wiki/List_of_Wikipediasi what sould be the hostname for the language
  and talk to Gabor about this.
* cp -r skeleton sites/CC     (where CC is the hostname selected)
* translate the first page sites/en/pages/installing-perl-and-getting-started.tt as
                           sites/CC/done/installing-perl-and-getting-started.tt
  or as                    sites/CC/done/TRANSLATD-BUT-TRANSLITERATED-TITLE.tt
  as is acceptable in other sites in your language.
* Add =original and =translator entries to the translated file
* Add yourself to the sites/CC/authors.txt file and add a picture of yourself to the sites/CC/img/ folder.
* Update sites/CC/pages/perl-tutorial.tt to include the page in the commented-out section.
* push your changes to your forked repository and send a pull request


PROMOTION
==========

When articles are published they are posted to Google+, Twitter and sometimes even to Facebook.
They are also posted on LinkedIN.

An e-mail is sent out to the people who registered on the Perl Maven site.

Many of the articles are included the Perl Weekly newsletter.


Once in a while I post a link to Reddit ( http://www.reddit.com/ )
but I'd rather see others post there if they find the article worth the mention.
The same with Hacker News: https://news.ycombinator.com/

The translators also need to take on themselves a large part of the promotion in the language communities.
Both in the Perl community - to get help from others - and to the general public.

This can be by posting on the language sub-Reddit (e.g. on http://www.reddit.com/r/Romania )

Sharing the articles on Google+, Twitter and Facebook should be almost automatic.

Getting the RSS feed of the site to be included in some local 'planets'.

SEO explained in 5 words
------------------------
"Get links from trusted sources" ~ Jon Morrow

The best promotion is if people find it worth to mention one
of the articles in a blog post or in some other form.


Git and Github
================

There is good and free book about Git called Git Pro http://git-scm.com/book

Install Git on you desktop
configure username and password
generate ssh key: https://help.github.com/articles/generating-ssh-keys


Create a Github account, let's say your username is USERNAME:
Upload the ssh key to your account
On Github 'fork' the https://github.com/szabgab/perl5maven.com repository
It will create another repository https://github.com/USERNAME/perl5maven.com

clone it to your desktop:
$ git clone git@github.com:USERNAME/perl5maven.com.git

It will create a directory called perl5maven.com inside all the source files.
There should be one called sites/CC  (where CC is your language code
based on this list: https://meta.wikimedia.org/wiki/List_of_Wikipedias
more or less).  If there is no such directory ask Gabor to create one.

Initially you will need to know about
    $ git add  filename
    $ git commit -m "message"
    $ git push

And on Github there is a button to "Send Pull request" that will
notify me to look at what you pushed, but of course I am also available
by e-mail and GTalk.

To follow the changes in the central repository and keep your own fork
up-to-date, do the following:

In your working copy do this once:

    $ git remote add upstream git://github.com/szabgab/perl5maven.com.git

Then every time you'd like to sync:

    $ git fetch upstream
    $ git merge upstream/main

