---
title: "1: Jeffrey Thalhammer, author of Perl::Critic and Pinto"
timestamp: 2013-04-25T22:33:01
tags:
  - Perl::Critic
  - Pinto
types:
  - interview
  - tv
mp3:
  file: /media/audio/jeffrey-thalhammer.mp3
  size: 18151104
  time: 18:47
published: true
---


This is the first Perl Maven interview. The guest is Jeffrey Thalhammer, who created Perl::Critic and more recently Pinto and Stratopan.
We talked about his project, about fund-raising and even about YAPC::NA.
(18:47 min)


{% youtube id="RVFc3yrwug0" file="thaljef_2013-04-25_20-49-53.mp4" %}

<podcast>

<div id="text">
Show notes:
* [@thaljef](http://twitter.com/thaljef) to reach Jeffrey via Twitter.
* [Perl::Critic](https://metacpan.org/module/Perl::Critic) on CPAN.
* [Perl::Critic](http://www.perlcritic.com/) on its own web site.
* [Pinto](https://metacpan.org/module/Pinto) on CPAN.
* [Stratopan](http://stratopan.com/) hosted Pinto service.
* [Crowd funding Pinto](http://blogs.perl.org/users/brian_d_foy/2013/04/crowd-funding-pinto.html) the article by brian d foy.
* <b>[Specify module version ranges in Pinto](http://www.crowdtilt.com/campaigns/specify-module-version-ranges-in-pint) the actual page where you can donate money.</b>
* [YAPC::NA](http://www.yapcna.org/) the Perl conference.
</div>

<p>The following is and experimental and partial transcription of the text.</p>

<div id="transcript">
  <div class="speaker-section speaker-gs">
   0:00
   Gabor: Hi, this is Gabor Szabo in the first episode of the Perl Maven show, or television, with me is Jeffrey Thalhammer.
   I am really happy that he volunteered to be the first guinea pig, in the first interview. He is the author of the
   [Perl::Critic](https://metacpan.org/pod/Perl::Critic) and more recently the
   [Pinto](https://metacpan.org/pod/Pinto) application, module
   and I'd like him to... hi Jeffrey.. now maybe I'll talk to him so hi
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: Hi Gabor, how are you doing today?
  </div>

  <div class="speaker-section speaker-gs">
   Gabor: I am a bit nervous, but I'll get over it, I think.
  </div>

  <div class="speaker-section speaker-jt">
   Jeffrey: I think you are doing a fine job. Thanks for having me on the show.
  </div>

  <div class="speaker-section speaker-gs">
    Gabor: OK, It's a pleasure to have you. So tell me a little bit about Pinto. This is your recent project
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: So Pinto has been my baby for the last year almost 2 years
    It started out as a project for a client actually. Genentech has hired me to build them a custom CPAN repository.
    This is something I have done at 3-4 other companies. Basically any shop that uses Perl modules
    wrestles with the problem of churn in the public CPAN. There is always new modules coming and going
    and if you build up your application by installing modules from the public CPAN you never know what are you going to
    get from one day to the next. So one workaround to that problem is to have a local private CPAN that has exactly
    the modules you want in the specific versions you want. And there are existing tools for this.
    This is not a new idea, or anything. But I didn't really like any of them. They were all kind of hard to work with.
    Each one of these CPAN that I have built seemed to be very customized and not very general purpose.
    So Genentech hired me and they gave me the opportunity to start from scratch. So Pinto is the result of that work.
  </div>

  <div class="speaker-section speaker-gs">
    2.08
    Gabor: That is awesome , both that there is that module or application and that there is a company that was OK
    with having this thing going out to open source and to implement something.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: The staff there is very progressive so the terms of the deal with them explicitly were that,
    anything that I did had to be released to CPAN and that is how they received their deliverable from me.
    Which is unusually I'd be happy if it happen more often.
  </div>

  <div class="speaker-section speaker-jt">
    2.50
    Gabor: I saw recently that you had this fund-raising that brian d foy started or he's doing for you.
    Can you tell me about that a little bit?
    I mean I saw that you're trying to raise 4,000 dollars and 3 quarters of them is already there?

  <div class="speaker-section speaker-jt">
    3.10
    Jeffrey: Yes, yes
  </div>

  <div class="speaker-section speaker-gs">
    Gabor: Why do you do with all this money?
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: Well I'll tell you the back story first. so brian d foy has been
    experimenting with using crowd-funding platforms to fund open source projects.
    So he was looking for candidate projects, things that he could run a
    campaign for and we could use the data or he could use the data to study where the
    interest is, where the community is and just generally to prove whether or not
    crowd funding was a viable way to finance this kind of projects.
    So he sort of put out a call for suggestions for campaigns or
    for projects to run campaigns for it and I stepped out a said
    hey how about Pinto, there were some key features that I thought we could do.
    It has been my primary work for the last couple of
    month I haven't been doing anything consulting, working full time on Pinto.
  </div>

  <div class="speaker-section speaker-gs">
   4.20
   Gabor: So you say that you don't actually have any income right now?
   So basically that would be the income? Right, OK.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: so this crowd funding project campaign is my income for this month anyway.
    It's not so much that I need the money, I'm not living on a crust of bread,
    at least not yet, but I think that the campaign is more about demonstrating whether or
    not you can fund open source development through crowd funding, whether you can bring
    together the open source community around these projects and particularly around Perl.
    It's kind of difficult to make money in the Perl community, it's sort of non-capitalist.
  </div>

  <div class="speaker-section speaker-gs">
   Gabor: Idealist, people are very idealist, I think.
  </div>

  <div class="speaker-section speaker-jt">
    5.29
    Jeffrey: That is a good way to say it, we are very idealist and the notion of directly financing
    these kinds of projects it's a little bit foreign to some of us.
    We wanted to see if this project could change that.
  </div>


  <div class="speaker-section speaker-gs">
    5.48
    Gabor: So are you satisfied so far? I mean it looks OK but I'm not sure what was your expectation really.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: I didn't know what to expect really, part of me thought that like if there was like
    maybe 6 people in the world who knew me personally, who would be willing to pitch into this,
    but there was also a part of me that thought well the world is a very big place and Perl is everywhere
    and I think the perl community wants to win, wants to succeed, it wants to see this campaign succeed.
    So I have been totally blown away by the results so far. Everyone has done a really good
    job of spreading the word through Twitter and social media and like you said the contributions
    were up to about 3200 or so, so we have about another 8 or 900 dollars to get to our
    goal and we have 2 weeks to get there, but I'm pretty sure that we will.
    I really have to thank everyone who made a contributions we have some large some small from
    all sorts of people, many of whom I have never met before, many of whom are probably not even
    Pinto users, but like I said they like would to see perl win and I hope that this is just
    the start of a trend in perl and in open source in general, where we see a lot more of
    thees crowd funding campaigns come out.
  </div>

  <div class="speaker-section speaker-gs">
    7.35
    Gabor: OK, so I saw that there are like a 90 people and you don't know them but do you know
    what kind of people or did you talk to them or can you say who do you expect, what kind of
    background of these people would you expect more likely to give you some money for this?
  </div>

  <div class="speaker-section speaker-jt">
    7.56
    Jeffrey: Some of them are Pinto users, some of them are probably Perl::Critic users
    and they are maybe using this as a way to say thank you for that, which I'm very grateful for.
  </div>

  <div class="speaker-section speaker-jt">
    Gabor: I'm in that camp actually.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: Well, thank you Gabor. and a lot of them I don't have a firm handle on exactly
    who the Pinto users are, so I can't really tell which ones are doing this directly to fund the
    project to get that feature implemented or if they are sort of in that other category of
    people that just want to help pitch into Perl.
    I actually think that a lot of money could be raised for Perl projects. The challenge is providing
    a specific deliverable, and I think that is why the Pinto campaign is a little bit different the
    the general fund raising that TPF does. I think it's an easier sell to people if you
    say you know, please give me some money this what I'm gonna do in return.
    Raising money to support general development purposes is a harder sell because
    people aren't really sure what they are getting in return for there donation.


  <div class="speaker-section speaker-gs">
    9.22
    Gabor: Well I can tell you that I had a couple of reasons way I gave a little money, and I
    checked that it's way less than the average, but I mean some people have to be below the average.
    So one of the main reasons was that I wanted to give a little money so I can go and tell
    people that: look I gave, so you can also give. Because without that it's like "go ahead and give money",
    a bit funny.
    And well I definitely would like to see Pinto succeed and be better and maybe I could use
    it for the [DWIM Perl](/dwimperl) packaging,
    but maybe the main reason was Perl::Critic actually,
    that I have been using Perl::Critic for a long time, I used it at a lot customers.
    So basically I think I made a lot of money or allowed me to earn some money,
    so that was just a little thank you token for this and thank you for Perl::Critic.
  </div>

  <div class="speaker-section speaker-jt">
    10.30
    Jeffrey: It's my pleasure, and that what leads to this bigger dream that I have.
    I love doing open source work, but I also like having an income.
  </div>

  <div class="speaker-section speaker-gs">
    10.45
    Gabor: Surprise
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: So I have been trying to find ways to marry the two, to achieve both goals. To have the
    freedom and the joy and the satisfaction that I get from doing open source work and at the same
    time paying the bills and putting my kids trough collage, which is several years away
    but the day will come. My ultimate goal is to be able to create some kind of infrastructure to
    allow people to monetize their open source work.
  </div>

  <div class="speaker-section speaker-gs">
    11.26
    Gabor: Yes, It's a bad word. It sounds bad, but I understand.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: I'll have to work on coming up with a better word for it. But you know you mentioned
    that Perl::Critic has enabled you to make some money from your clients and that is great.
    Think of the tens and thousands of developers and organizations that have all benefited
    from [Michael Schwern's](/michael-schwern-on-test-automation-and-git)
    [Test::More](http://metacpan.org/module/Test::More), every time that they
    run that and a test passes or
    actually when a test fails, then you know, they have profited from that somehow,
    or at least minimize a cost perhaps.
    So I would like to create a way for a little bit of that money to flow back to the authors.
    The open source community, CPAN authors create all this value in the work that they
    do but they don't get paid, directly any way for any of it.
    So I think there is a lot of money on the table in the open source community,
    if we could just find a way to channel it to the people who deserve it.
  </div>

  <div class="speaker-section speaker-gs">
    12.45
    Gabor: well, Pinto or this fund-raising is trying to get their money from mostly individuals I think,
    but probably the longer term goal would be to reach companies that need this software because after
    all companies usually have a lot more money available than individuals.
  </div>


  <div class="speaker-section speaker-jt">
    13.5
    Jeffrey: Right, most of the contributors to the campaign have been individuals, my plan to monetize
    Pinto even further is with this thing called [Stratopan](http://stratopan.com/),
    which is a hosting server
    built on top of Pinto, so you don't have to bother installing Pinto and managing user accounts
    and servers and all that sort of stuff, we will take care of that for you, Pinto repository will
    be in the cloud and you can build and install your applications from there anywhere and anytime.
    So it's a bit like Github hosts source codes repositories,
    Stratopan.com is going to host Pinto repositories for you.
  </div>

  <div class="speaker-section speaker-gs">
   13.54
   Gabor: That sounds interesting.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: It's interesting. We just announced the beta this week, we are looking for beta users to
    come on board and help us shake out some of the early kinks. We think that we
    are going to lunch, that the beta will start some time in the summer. So if you go to
    [Stratopan.com](http://stratopan.com/) you can leave your E-mail address and
    we will get in touch with you when the time comes.
  </div>

  <div class="speaker-section speaker-gs">
    14.20
    Gabor: You say we just because it sounds better or there are more people behind that?
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: Well I say we in the sense that it's me, it's the contributors to the Pinto project,
    brian d foy is also a part of Stratopan, he has been working on CPAN related issues for
    a very very long time so he has been helping me to sort out some of the technical
    details and giving me some insight into marketing, and how to reach out to the Perl community
    and make an impact.
  </div>

  <div class="speaker-section speaker-gs">
    14.57
    Gabor: OK, great. I wanted to ask you because YAPC is combing, and we actually met for the
    first time last year at YAPC North America. Are you planning to go?
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: I haven't committed yet but I would like to go, I went last year to YAPC at Madison and had a blast.
    Last year I stayed at a hostel which was kind of a first for me, usually when I travel with my wife her
    tastes are a little more particular than mine.
    So I was traveling alone, I stayed at a hostel and it really turned out to
    be the best part of the hole experience. I met
    [Sawyer](http://blogs.perl.org/users/sawyer_x/) there, he is a
    really talented guy, we had some late night conversations.
  </div>

  <div class="speaker-section speaker-gs">
    15.48
    Gabor: He is going to be there again as far as I know.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: I really want to get out to some of the YAPCs in Europe and Asia and try some of those,
    but yes YAPC is a blast, if you're thinking of going and haven't been before I highly recommend it.
  </div>


  <div class="speaker-section speaker-gs">
    16.06
    Gabor: I usually go to [YAPC Europe](http://yapc.eu/) because it's a lot closer then
    North America, but this year again
    I'm going to be in North America. I would like to go to Asia once,
    [YAPC::Asia](http://yapcasia.org/).
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: Austin is a great town, there is tons of music and it's quite a bit different from
    the rest of Texas. If you have a perception of what Texas is like,
    Austin is pretty much the exact opposite of that.
    It's this little island of liberal progressive thinking in an otherwise a very conservative state.
    I grew up in New Mexico, which is one state over and shares some similar characteristics.
  </div>

  <div class="speaker-section speaker-gs">
    17.00
    Gabor: Interesting, so I hope that I'll see you there and in the meantime thank you
    very much for combing to the show,
    would you like to say some more words about Pinto or give out a call action.
  </div>

  <div class="speaker-section speaker-jt">
   Jeffrey: Well, as I said the beta for Stratopan will start this summer if you go to
   [Stratopan.com](http://stratopan.com/) you
   can leave us your email address and we will make sure you are a part of that. The crowd-funding campaign
   for Pinto is been run on [Crowdtilt](https://www.crowdtilt.com/),
   which is another Perl shop they have been super helpful
   with helping us get the campaign setup and running I don't have the URL.
  </div>


  <div class="speaker-section speaker-gs">
    17.45
    Gabor: I'll but the URLs under the video.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffrey: So if you want to go there and help spread the word, tweet, blog, whatever you do
    I really appreciate it, contributions are good too. We are very close to tilting.
    If we don't reach the full amount then none of the money gets paid so we have to reach that
    4,096 goal in order to make this win.
  </div>


  <div class="speaker-section speaker-gs">
    18.13
    Gabor: Good. well I really hope that it will work out. As I said, I'm going to put all the notes,
    all the links under the video, and thank you very much for combing to this interview or show
    or I don't know what it's going to be called, and we will see you hopefully at YAPC or somewhere around.
    Thank you very much.
  </div>

  <div class="speaker-section speaker-jt">
    Jeffery: Thank you, it's a pleasure to be here, see you in Texas. bye
  </div>

</div>

