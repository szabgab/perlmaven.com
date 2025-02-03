---
title: "3: Dave Rolsky, author of DateTime and tons of other modules"
timestamp: 2013-05-02T17:33:01
tags:
  - DateTime
  - Dave Rolsky
types:
  - interview
  - tv
books:
  - moose
mp3:
  file: /media/audio/dave-rolsky.mp3
  size: 18667488
  time: 19:19
published: true
---


What does a vegan music composer do when he wants to send e-mails?

Dave Rolsky is one of the most prolific CPAN authors. He created DateTime, Log::Dispatch and tons of other modules.
We talked about how he started with Perl and what he has been doing lately. We also discussed his work and
the Moose training he runs at YAPC::NA. (19:19 min)


{% youtube id="d-K_uoIrUKQ" file="daverolsky_2013-04-29_21-32-18.mp4" %}

<podcast>

<style>
.transcript              { }                           /* Container for transcription  */
.transcript-timeindex    { display: none }             /* Time indexes into the video  */
.speaker-section         { }                           /* Contains a single speaker    */
.speaker-gs              { }                           /* Gabor Szabo                  */
.speaker-dr              { }                           /* Dave Rolsky                  */
.speaker-name            { display: none }             /* Contains the speaker name    */
.speaker-gs[first] .speaker-name   {                   /* Display the first instance   */
    font-weight: bold;
    display: inline
}
.speaker-dr[first] .speaker-name   {                   /* Display the first instance   */
    font-weight: bold;
    display: inline
}
.speaker-initial         {                             /* Contains the speaker initial */
    font-weight: bold;
    display: inline
}
.speaker-gs[first] .speaker-initial { display: none }  /* Hide the first instance      */
.speaker-dr[first] .speaker-initial { display: none }  /* Hide the first instance      */
.speaker-info            { }                           /* Container for speaker info   */
.speaker-info:after      { content: ":" }              /* Container for speaker info   */
.transcript-garbled      { }                           /* Audio section was garbled    */
.transcript-editor       { }                           /* Section for editor note      */
.transcript-garbled      { font-style: italic }        /* Indicator for garbled text   */
</style>

## Transcript
(work in process)
<div id="transcript">

  <!--
      [2013-05-03 Fri 04:00]--[2013-05-03 Fri 04:45]: First pass 0:00--3:00
      [2013-05-03 Fri 06:00]--[2013-05-03 Fri 06:35]: First pass 3:00--6:17
      [2013-05-03 Fri 16:22]--[2013-05-03 Fri 17:06]: First pass 6:17--10:29
      [2013-05-05 Sun 04:31]--[2013-05-05 Sun 05:28]: HTMLize and spelling
      [2013-05-05 Sun 16:00]--[2013-05-05 Sun 16:34]: Minor fixes and research into CSS settings.
      [2013-05-05 Sun 16:44]--[2013-05-05 Sun 16:49]: More minor edits
      [2013-05-06 Mon 04:07]--[2013-05-06 Mon 05:13]: Style first names / first initials
      [2013-05-13 Mon 06:06]--[2013-05-13 Mon 06:12]: Change transcript container
      [2013-05-13 Mon 16:16]--[2013-05-13 Mon 17:04]: First pass 10:29--15:13
      [2013-05-14 Tue 16:33]--[2013-05-14 Tue 17:04]: First pass 15:13--18:40
      [2013-05-15 Wed 06:02]--[2013-05-15 Wed 06:16]: First pass 18:40--19:20 (end)
      [2013-05-15 Wed 06:17]--[2013-05-15 Wed 06:36]: Second pass (cleanup 10:29--19:20)
      
      TODO:
      - Complete authors linkage
      - Clean up transcription to improve reading flow
      - Add external links to transcript
      - Collect timing information for Gabor's use.
    -->

  <div class="speaker-section speaker-gs" first="first">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">0:00</span> Hi, this is
    Gabor Szabo speaking.  This is the Perl Maven TV show again, and
    with me is Dave Rolsky, who is the author of DateTime and tons
    of other modules on CPAN.  He is also the author of the, or of at
    least a large part of the Moose tutorial and documentation.  Hi
    Dave.  How are you?

  </div>

  <div class="speaker-section speaker-dr" first="first">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    Hi.  I am good how about you?

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    I am fine.  Still a bit nervous about these tv interviews, but
    hopefully I get over all this.
  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    What could go wrong with technology?  Hey, we're programmers, we
    know it always works, it's perfect, so...

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    I can tell you in one of my previous interviews, the aspect ratio
    of the camera of the other side was changing, so you can see that
    his head was going up and down.  Very interesting.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    Very psychedelic.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    Yeah.  Anyway.
    So.  <span class="transcript-timeindex">1:00</span> Welcome to
    the show, and I would like to start with you from the beginning,
    because you have these tons of modules on CPAN, but where do we
    start?  How did you get involved in Perl?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">1:13</span> OK, sure.  So,
    back in '95/'96, I think, I was in grad school for music
    composition, that's what my degree is in, and I was, at the time... I
    had recently met Matt Mackall, who people might recognize as the
    author of Mercurial, and he's also done Linux development, so I
    knew him back, way back then, actually through a local vegetarian
    group, and I wanted to write a web app for the composers at my
    school to list all of our pieces, so that performers could find
    what we had written and may be sort, and you know, "I want to find
    something that includes clarinet" or something like
    that, <span class="transcript-timeindex">2:00</span> and so I
    had done a little programming when I was a kid -- I got my first
    computer when I was young, 5 or 6, so I asked Matt, "what should I
    learn to do this?  What's the right language?"  So he pointed me
    at Perl. <span class="transcript-timeindex">2:15</span> I think
    I got a Perl book sometime when I was in grad school.  This app
    never materialized.  It was a good idea, but it didn't happen,
    like many projects, right?  So this should be familiar to
    everybody <span class="transcript-timeindex">2:24</span>
    watching this: "Projects You Never Did".  That got me started
    looking at Perl, which is very ironic, since Matt is totally a
    Python guy these days, anyway.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">2:35</span> Back then
    everyone was Perl.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">2:37</span> Exactly,
    exactly.  When I graduated from the masters program, I was kind of
    burned out on the whole academic thing, and so I decided to not
    get a Ph.D., so I end up getting a job in support at a local
    insurance company in St. Paul.  I lived in Minneapolis, Minnesota.
    <span class="transcript-timeindex">3:00</span> And there was
    kind of downtime.  When things weren't crashing, there was free
    time, because we weren't like a support line for Dell, it was just
    for the company, so if things there were working, we had time.  So
    I kind of taught myself more programming there, and I was actually
    working on another project that I never finished, which was a web
    UI for MajorDomo, if anybody remembers MajorDomo.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    People still use it.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    Oh wow.  Oh my God.  OK.  So I learned more of Perl there, and
    then eventually after about 15 months of that job, I got my first
    programming job, this was during the first dot-com boom, when
    anybody with a, I'll be polite, a butt, could get a seat, because
    that's all you needed was a butt to put in the seat to be a
    programmer, <span class="transcript-timeindex">3:50</span> so I
    had no idea what the heck I was doing, but I managed to get a
    programming job.  And it was a Perl place, and so that was kind of
    where it all started.  And actually, that job I met Ken Williams,
    who is the person who introduced me to Mason, and we eventually
    wrote the Mason book together, and he introduced me to more of the
    Perl community
    stuff, <span class="transcript-timeindex">4:10</span> pushed me
    to put stuff on CPAN, told me about YAPC, things like that.  So
    that's where it really got started.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">4:16</span> Great.  So you
    started, you started to learn Perl, you had this, you were involved
    in a lot of projects, right?  I mean, if you look at the CPAN
    directory, then you see all kinds of diverse things.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">4:33</span> Yeah, I've
    done... I think the first thing I uploaded was something that's
    kind of a predecessor to Log::Dispatch.  It was like a logging
    module I had written for the company I was working at, and I got
    permission to release it, and it was really terrible, but I
    uploaded that, and
    then <span class="transcript-timeindex">4:49</span> I think I
    wrote, I actually wrote a small bug tracking system for our
    support team, and I had done my own templating system, I think for
    that, I don't know, this was so long ago.  And then Ken was like
    "You should look at Mason".  So then I started using Mason, and
    then I started contributing to
    Mason, <span class="transcript-timeindex">5:05</span> So, I
    mean, for some of the things I worked on its projects that other
    people have started, probably most notably Mason and Moose, where
    I got excited about the project, and, you
    know, <span class="transcript-timeindex">5:19</span> if it
    doesn't work the way I want it, then patches welcome, and I am
    kind of a sucker for that, so I end up doing the patches, and then
    working on docs, and all of these other
    things, <span class="transcript-timeindex">5:29</span> and then
    for other stuff, I mean I have lots of stuff I have uploaded to
    CPAN that I don't think anybody has ever used, including me.
    There is stuff that is up there that is just experimental, or
    that's long
    abandoned. <span class="transcript-timeindex">5:39</span> so
    even though I have tons of CPAN modules, I suspect maybe, I don't
    know, 25% of them, 35% of them see any use, but some of them are
    used pretty heavily.  So it's kinda...

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">5:50</span> Yeah, I think I
    mean, it's like a trademark.  If I know that you wrote it, then I
    know that then it's "it's OK".  Maybe I shouldn't trust everything
    that you wrote.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">5:59</span> (laugh) I sure
    wouldn't trust everything!  I'm embarrassed by my old code.  I
    look at Log::Dispatch, which is one of the earliest ones, and I
    know lots of people use it, and I still use it, but whenever I
    have to hack on it, I'm like "Ugh, not this again".

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    Oh, you don't like it anymore.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    Someday I'll <span class="transcript-timeindex">6:13</span>
    <span class="transcript-garbled">[garbled]</span> to use Moo or
    something.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">6:17</span> OK.  But would
    you for.. if you had already mentioned Moo and would you help
    somebody if he wanted to rewrite it in Moo or start improving it
    and step by step.  It's not like from scratch.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    Sure! Sure.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">6:33</span> Because I think
    that would be crazy.  Probably it would be better, I don't know,
    class by class to turn it to Moo?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">6:43</span> Yeah.  It really
    wouldn't be hard.  Log::Dispatch, in particular, is really not
    much code.  It's a pretty simple module.  So the big things I want
    to do for that are just kind of clean it up, possibly use Moo,
    <span class="transcript-timeindex">6:54</span> and also to
    split it up into separate distros.  Right now its kind of an ugly
    distro where it ships all these output modules, like for Apache
    logs <span class="transcript-timeindex">7:04</span> whose using
    mod_perl anymore?  I'm not, so I don't need it.  It has a syslog
    output and four different ways to send email, and these should all
    be separate
    modules.  <span class="transcript-timeindex">7:12</span> Cause
    right now you install it and it doesn't have any of the prereqs
    declared, 'cause otherwise I'd need to declare tons of prereqs,
    and it would be a
    mess.  <span class="transcript-timeindex">7:21</span> So
    splitting up into different distros would be a nice thing to do
    too.  <span class="transcript-timeindex">7:26</span> and we
    could <span class="transcript-garbled">[garbled]</span>.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">7:26</span>
    <span class="transcript-garbled">[garbled]</span>
    <span class="transcript-timeindex">7:28</span> Sorry?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">7:30</span> It would just
    make it easier to manage, I think.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">7:32</span> Yeah.  Yeah,
    probably.  So actually, I didn't think about it earlier, but this
    could be a <span class="transcript-timeindex">7:39</span> way
    to introduce new programmers, or people who are not new to
    programming, maybe, but new to Perl and would like to have some
    project <span class="transcript-timeindex">7:49</span> and they
    think, well, "what can we do?", and here is a module that is
    heavily used, probably, I know I use it, and probably a lot of
    other people use
    it, <span class="transcript-timeindex">8:00</span> and can be
    refactored to something more modern.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">8:04</span> Yeah,
    definitely, and it's reasonably amenable to that since each
    subclass, each output class is pretty small, doesn't do much, you
    could convert them one at a time.  I think that's definitely a
    reasonable project.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">8:17</span> That's
    interesting.  So, what are you working these days?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">8:21</span> For paid work,
    or free for software stuff?

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">8:25</span> I don't know,
    start with free software?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">8:28</span> Not too much.
    The last couple of years have been, I just have a lot of stuff
    going on in my
    life. <span class="transcript-timeindex">8:38</span> Some
    health problems for me and my wife, which have been distracting,
    and also I am doing a lot of activism related to animal advocacy
    <span class="transcript-timeindex">8:47</span>, so last year,
    the group I work with, we did a big veg-fest in the Twin Cities,
    and I was kind of the lead organizer for that, so I spent a lot of
    time on that.  And now we're doing it
    again <span class="transcript-timeindex">8:58</span>, and I'm
    still the lead organizer.  So, you know, things like that can be
    distracting.  It's kind of like putting on a YAPC, basically, in
    terms of amount of work, to give people a sense of
    perspective. <span class="transcript-timeindex">9:08</span>
    Probably the biggest thing I've done recently, let's see, well,
    there's that module, I don't know if people have seen, called
    Courriel, which is a terrible pronunciation
    <span class="transcript-timeindex">9:16</span>, which is the
    French word, official French word for email, that France uses.
    But I just picked it because the Email:: name space was already
    taken, and it's kind of an attempt to improve on the
    email <span class="transcript-timeindex">9:27</span>
    Email::Mime modules, which I don't like the API of much, and just
    try to give it a more modern, easy to use
    API <span class="transcript-timeindex">9:35</span>.  So, we're
    using that at work, and it seems to work pretty well.  I think
    other people are using it, so that's something.  There's
    definitely work to be done on
    that.  <span class="transcript-timeindex">9:41</span> I've been
    working on some tools related to calling Postgres command line
    programs.  It's the Pg::CLI distro, which actually
    is <span class="transcript-timeindex">8:52</span> turned out to
    be something we need a lot at work as well.  We're trying to move
    to Postgres and for managing
    databases <span class="transcript-timeindex">9:59</span>.  And
    then I am working on something that I hope, I'm working on it
    slowly, very slowly, that I hope will eventually replaces Moose's
    built-in type system, but also be usable for Moo, and really be
    available standalone.  It's called Specio, or actually I think it
    <span class="transcript-timeindex">10:15</span> totally I
    should say Specio, but I don't know how to pronounce Latin.  It's
    kind of a standalone type
    system.  <span class="transcript-timeindex">10:24</span> I
    think those some of the most recent things.  I don't even
    remember.  What have I done on CPAN?  Who knows?

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">10:29</span>

    And you mentioned this event you lead-organized, right?  Is there
    any programming involved in that?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    Not too much.  I hate to admit it.  You know what programming
    there is?  Working on Wordpress, and tweaking Wordpress templates,
    and writing PHP code, which just - it's unpleasant but necessary.
    Wordpress is <span class="transcript-timeindex">10:53</span>, uh,
    usable.  It works pretty well for what we're doing, which is a
    small CMS with a little bit of blogging.  It's a shame there's no
    comparable Perl project that
    would <span class="transcript-timeindex">11:07</span> really do
    what we want, but writing a Perl project just to run our web site
    is probably out of the scope of putting on a
    veg-fest.  <span class="transcript-garbled">[garbled]</span>
    <span class="transcript-timeindex">11:19</span> There's sometimes
    little programs to do data analysis and stuff like that.  I'm
    definitely one of the more geeky activists I know.  I try to use
    my programming wherever I can.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">11:29</span> The point is that,
    myself, I think, almost all of the programming I've done is for
    other programmers.  It's not from the real world.  It's not
    solving the real problems, at least not directly.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">11:43</span> That's definitely
    what I put on CPAN, I think.  It's like libraries for other people
    to use in
    their <span class="transcript-garbled">programming</span>.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">11:49</span> Yeah.  Most of the
    CPAN is there for that, but I think it's much more interesting --
    it's probably a totally different thing if you can go and solve
    some real world problem and use the tools that you have.  That's
    why I was interested in
    that.  <span class="transcript-timeindex">12:15</span> OK.  That's
    your open source.  What's you business or work thing?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">12:20</span> So I work for a
    company called MaxMind.  It's a pretty small company, I can't
    remember how many people right now, 15, 18.  If people have heard
    of the GeoIP database, we produce that.  And we also have a
    transaction fraud detection service that's built on top of that.
    <span class="transcript-timeindex">12:40</span> and GeoIP is
    available both as downloadable databases and web services.  So
    those are kind of our two main things: the GeoIP stuff and then the
    fraud detection.  <span class="transcript-timeindex">12:49</span>
    And so I work for them.  We have, I think, 5 developers working on
    our various products.  Yeah, that's what I do full time.  It's
    pretty good.  I like working there.  We get to release free
    software.  We use tons of free software internally.  So yeah, I
    enjoy it.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">13:09</span> Yeah, I used this
    module.  I'd still like to use more of it, I think.  But if I
    remember correctly, only part of the database can be downloaded
    freely, at least, right?  Like more generic information.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">13:25</span> There's a couple
    free downloads, which are kind of a subset of the full data, and
    then there's more stuff you can pay for to subscribe to, and then
    there's even more stuff if you want to subscribe to the web
    service.  So there's kind of three tiers, basically.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">13:43</span> But you say that
    this company is using Perl mostly, right?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">13:46</span> Oh yeah.  I don't
    know what percentage.  The vast majority of our code is in Perl.
    We have a little bit of C code and C++ code for some of the things
    we needed to make fast, but yeah, the vast majority is.  All of
    the back end stuff is basically, all the web server stuff, most of
    the database generation, is in Perl.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">14:09</span> Are they located
    in where you live, or do you work remotely?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">14:15</span> Pretty much the
    whole dev team is remote.  Even the people who are at the office,
    there's only a couple of them, so they still have to effectively
    be remote.  The company is located in Waltham, Massachusetts.  But
    yeah, the whole dev team is remote.  One person who is on my team
    besides me people might know is Olaf Alders, who is one of the
    guys behind metacpan, so we hired him recently.  He's been great
    to work with.  It's definitely a real Perl shop.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">14:44</span> Interesting.  So
    now, there is the Moose things.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">14:53</span> Moo?  Did you say
    Moo or Moose?

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">14:55</span> Moose.  Moose.
    What is the Moose class?  You're going to run training at YAPC.
    Who is it for?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">15:13</span> Good question.
    The class I'm doing is Intro to Moose, and it's basically for
    people who already know perl -- it's not an Intro to Perl-type
    class -- and hopefully, at least, have some basic familiarity with
    object orientation principles, because I'm not going to really
    cover that too much either.  But really, its if you want to learn
    how Moose works.  You've seen it in other people's code, you've
    heard about it, you want to start using it for your stuff, I will
    teach you all the Moose principles, all the features it has.  It's
    a very interactive class, so what I do is I give a lecture
    section, that will last 20-40 minutes, and then there is a series
    of exercises that the students do, and the exercises are written.
    You write some code, and I've written tests for your code.  And
    you've run my test suite against your code, and once your test
    suite passes, you know you've done the exercise right.  It tries
    to give you a lot of feedback in the test about what's not done
    yet.  <span class="transcript-timeindex">16:21</span> I've given
    the class many times before.  Students really seem to like that
    format of how the exercises work.  I think it's good, because it
    forces you -- it's one thing to listen to me talk, but it's much
    more useful to be forced to actually use the things that I'm
    talking about.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">16:37</span> Yeah.  To do the
    exercises is definitely a good thing here.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">16:41</span> I'll also mention
    Steven Little's class -- maybe you'll interview him too -- he's
    doing an advanced Moose class the next day, which will go more
    into depth on some of the Moose features, and also cover maybe a
    bit more of how to use Moose well, how to use certain features
    appropriately, how to mix features together, whereas my class is
    more of like here's the basics of what you can do, and not get too
    far into here's how to do it really optimally.  I think the
    classes will compliment each other nicely, so if people want to
    take both I think
    that <span class="transcript-garbled">[garbled]</span>.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">17:15</span> Ok, that's great.
    So thank you for the interview.  Would you like to say some call
    to action or whatever?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">17:25</span> Call to action?

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">17:27</span> How people can get
    involved in Perl, or your stuff, helping your stuff?

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">17:34</span> If they want to
    get involved in Perl, I think the Perl community really spends a
    lot of time on IRC, so, if you join one of the channels on
    irc.perl.org, that's a good way to get involved.  If you're
    interested in Moose, the #moose channel is quite active, and you
    can get help with Moose, both Moose and Moo are discussed on that
    channel, so that's a great way, if you want to get involved.
    Anything Moose related, that's the place to
    go.  <span class="transcript-timeindex">18:06</span> If people
    want to help with some of my modules, there are a lot of bug
    reports, sadly, for them in rt.cpan.org, so that's always a good
    place to start if you want to fix some bugs.  I'm more than happy
    to look at patches.  I will warn people, sometimes I'm kind of slow
    to respond.  I tend to have a lot of stuff going on.  I felt
    guilty about it, but it's not that I'm ignoring you.  And feel
    free to poke me.  If you send a path and I haven't looked at it in
    a couple weeks, if you nag me politely, (politely, that's the
    key), if you nag me politely, I will respond, because then I'll
    feel guilty.  <span class="transcript-timeindex">18:40</span> So,
    absolutely feel free to do that.  You can also private message me
    on IRC.  I'm on IRC as autarch.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">18:48</span> Don't worry, we'll
    put it somewhere written down.  That's a bit easier.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    OK.  Sounds good.  And email is fine too, but if you have a bug
    report, send it to rt.cpan.org.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">18:58</span> That's the best.
    Including with
    tests.  <span class="transcript-garbled">[garbled]</span>, right?
    And a patch.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">19:01</span> That's always,
    <span class="transcript-garbled">nothing to encourage
    action</span> than tests and patches, yes.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">19:08</span> OK.  Thank you
    very much.  This was Dave Rolsky and Gabor Szabo on the Perl Maven
    tv show.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">19:16</span> Alright.  Thank
    you.

  </div>

  <div class="speaker-section speaker-gs">
    <span class="speaker-info">
      <span class="speaker-initial">GS</span>
      <span class="speaker-name">Gabor Szabo</span>
    </span>

    <span class="transcript-timeindex">19:17</span> Thank you.

  </div>

  <div class="speaker-section speaker-dr">
    <span class="speaker-info">
      <span class="speaker-initial">DR</span>
      <span class="speaker-name">Dave Rolsky</span>
    </span>

    <span class="transcript-timeindex">19:19</span> So are we all
    done?

  </div>

</div>

<div id="text">
## Show notes
* [House Absolute(ly) Pointless](http://blog.urth.org/), Dave,s blog.
* [House Absolute Consulting](http://www.houseabsolute.com/)
* [Ken Williams](http://www.linkedin.com/in/kenahoo), [Mason](http://www.masonhq.com/), [Mason book](http://www.masonbook.com/)
* [Mercurial VCS](http://mercurial.selenic.com/)
* [Matt Mackall](http://twitter.com/mpmselenic)
* [Majordomo](http://en.wikipedia.org/wiki/Majordomo)
* [IRC](http://irc.perl.org/)    Check the #moose channel. Dave is known as <i>autarch</i> on IRC.
* [Bug reports in RT](http://rt.cpan.org/)
* [Compassionate Action for Animals](http://www.exploreveg.org)
* [Twin Cities Veg Fest](http://2013.tcvegfest.com/) where Dave is the lead organizer.
* [DateTime](http://datetime.perl.org/)

Dave works for [MaxMind](http://www.maxmind.com/), a Perl shop that provides GeoIP databases, web services and fraud detection.
Dave works with [Olaf Alders](https://metacpan.org/author/OALDERS), one of the people behind [MetaCPAN](http://metacpan.org/).

## CPAN modules
* [Dave Rolsky on CPAN](http://metacpan.org/author/DROLSKY)
* [Log::Dispatch](http://metacpan.org/module/Log::Dispatch)
* [Moose](http://metacpan.org/module/Moose)
* [Courriel](http://metacpan.org/module/Courriel), a modern email parsing and building library.
* [Pg::CLI](http://metacpan.org/module/Pg::CLI) for calling PostgreSQL command line programs.
* [Specio](http://metacpan.org/module/Specio) is an attempt to replace the built-in type system for Moose, and to provide something that works with Moo as well as stand-alone.

## Moose training at YAPC::NA 2013
* [Intro to Moose training at YAPC::NA](http://www.yapcna.org/yn2013/training.html#moose1)
* [Advanced Moose by Stevan Little at YAPC::NA](http://www.yapcna.org/yn2013/training.html#moose2)
</div>






