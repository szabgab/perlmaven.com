---
title: "Async, Type-Safe, and Secure: Perl's Answer to FastAPI"
timestamp: 2026-09-08T09:00:02
published: true
description: ""
archive: true
show_related: true
---

## Description

This is a practical exploration of PAGI::FastAPI and its latest addition PAGI::FastAPI::Security that introduces you to modern asynchronous Perl web development if you have been using FastAPI in Python asking yourself why this can't be done in Perl. (Spoiler: it can now)

## Bio

[Mohammad Sajid Anwar](https://www.linkedin.com/in/mohammadanwar/) is a CPAN author and White Camel award recipient, recognised for his sustained contributions to the Perl community. He is the author of "Design Patterns in Modern Perl" and the creator of "The Weekly Challenge", a long-running initiative since 2019. He is an editor of the Perl Weekly newsletter. He speaks regularly at Perl conferences and is an active mentor and contributor across the CPAN ecosystem.

## Length

30 min

{% youtube id="uWkalm3XIW0" file="2026-09-07-async-type-safe-and-secure-perls-answer-to-fastapi-with-mohammad-sajid-anwar.mp4" %}


## Participants Geo


David is a bit of geo-nerd so he collected the places that people joined from:

Ukraine (Kiev), Stockholm, UK (London & Norfolk), USA (New York, Minneapolis, Chicago, Lansing & Miami), Netherlands, Israel (Haifa & Modiin), Dublin, Barcelona, Munich, Hungary (Budapest), Germany and Nigeria (Lagos)!

## Questions and comments

* Is PAGI or PAGI::FastAPI reverse proxy aware? Like PAGI talking HTTP to HAProxy and HAProxy talks to clients over HTTPS
* How do I customise the automated docs? E.g. I want to add a description or request examples.

* What about nested data validation? A flaw in using Type::Tiny for schema validation is that there isn’t a way to model "presence" (afaik, I could be wrong though).
* I was a huge fan of Data::FormValidator (back in the day) :-)
* Is event loop an internal detail? Can the program hook to it to wait for other events, e.g. file system?
    * Yes, you can hook into IO::Async::Loop, but it doesn't happen automatically, you would have to use a filesystem module designed to work with IO::Async::Loop.
    * You need a loop to be async, when you make db/file system calls you can create a promise but that promise lives in the servers event loop (or should to be efficient async) Most async modules have a loop parameter.
    * This is why Mojo:Pg, Mojo::mysql, etc, were created. Because most things in Perl aren't asynchronous, you have to recreate everything to become async AND because there isn't a single standard event loop you have to design them to work with specific loops (e.g., IO::Async::Loop, Mojo::IOLoop, etc).
* Next to authentication, what about authorization and audit (AAA)?
* Does PAGI or PAGI::FastAPI allow 'under' like Mojolicous?
* I wanted to try it right now but unfortunately it's using Perl 5.38 and my system has 5.34. But definitely will try. I dont think its a big issue 🙂
* Thank you Mohammad. This has been very informative. And thank you for the Weekly Challenge. I have learned much from them.
* It encourages us to move upwards faster!
* Very cool Mohammad!
* Thank you Mohammad. Great work!
* Thank you, Mohammad! Great thing!
* Thank you
* Nice work, Mohammad. Many thanks.
* Thanks!
* Mohammad Anwar:	Thank you everyone

## Transcript


WEBVTT

1
00:00:00.000 --> 00:00:02.600
Mohammad Anwar: Hi everyone, this is Mohammad. Being recorded.

2
00:00:03.030 --> 00:00:18.229
Gabor Szabo: Okay, so hi everyone. My name is Gabor Szabo. Welcome to the Code Maven channel, if you're watching on YouTube, and to the Perl Maven subsection of it, if you're watching live.

3
00:00:18.380 --> 00:00:30.690
Gabor Szabo: Thank you for joining. It's absolutely great to have so many people interested in this topic, and thank you, Mohammad, for agreeing to giving this presentation.

4
00:00:30.690 --> 00:00:41.350
Gabor Szabo: As I said also earlier, the advantage of being here is that you can ask questions in the chat, and we had a nice

5
00:00:41.350 --> 00:00:53.630
Gabor Szabo: mutual introduction section before, and after the video, we stop the video recording, people can stay around, so next time, those people who are watching the video now, please join the…

6
00:00:53.630 --> 00:01:03.060
Gabor Szabo: the next event… the upcoming events. You can find below the video, you will find a link to the upcoming events, and also for notes

7
00:01:03.060 --> 00:01:13.760
Gabor Szabo: about this event, so check that out. With that said, I think I should welcome Mohammad again, and give you the

8
00:01:13.760 --> 00:01:15.530
Gabor Szabo: stage.

9
00:01:17.030 --> 00:01:20.620
Mohammad Anwar: Thank you, Gabor. Thank you for the opportunity, and…

10
00:01:21.910 --> 00:01:25.369
Mohammad Anwar: Do I need to share my screen first?

11
00:01:29.020 --> 00:01:33.609
Gabor Szabo: You can share the screen, you can introduce yourself as, in any order you like.

12
00:01:34.790 --> 00:01:35.810
Mohammad Anwar: Hi, good.

13
00:01:44.200 --> 00:01:51.699
Gabor Szabo: So while Mohammad is looking for the share, it's usually at the bottom, it's a… But,

14
00:01:51.700 --> 00:01:53.060
Mohammad Anwar: Yeah, I see ya.

15
00:01:53.060 --> 00:01:53.460
Gabor Szabo: Yeah.

16
00:01:53.540 --> 00:01:55.000
Mohammad Anwar: So if you have a…

17
00:01:55.000 --> 00:02:04.940
Gabor Szabo: all kinds of other events, and that's what I mentioned, both in Perl and in other languages, about other languages, so you can find all those sessions.

18
00:02:10.749 --> 00:02:11.299
Mohammad Anwar: Into…

19
00:02:18.210 --> 00:02:21.779
Gabor Szabo: Okay, I can see you now, I can see myself now in the screen.

20
00:02:22.230 --> 00:02:24.530
Mohammad Anwar: So, let me get this.

21
00:02:24.680 --> 00:02:25.800
Gabor Szabo: Yeah, okay.

22
00:02:26.030 --> 00:02:28.549
Mohammad Anwar: Alright, so, let's start this.

23
00:02:30.270 --> 00:02:31.050
Mohammad Anwar: But…

24
00:02:31.670 --> 00:02:38.339
Mohammad Anwar: Thing is, I'm not able to see anything, anybody, but it's alright. You guys can see my screen, right?

25
00:02:38.680 --> 00:02:42.110
Gabor Szabo: We can see your screen, what we'll cover, and…

26
00:02:42.430 --> 00:02:44.660
Gabor Szabo: If you really want, we can see you as well.

27
00:02:44.660 --> 00:02:45.540
Mohammad Anwar: Okay.

28
00:02:45.810 --> 00:02:47.879
Mohammad Anwar: So, yeah, thank you, everybody.

29
00:02:48.040 --> 00:02:57.430
Mohammad Anwar: for… Joining this session, and… Just to give a… the… the background, how and…

30
00:02:57.620 --> 00:03:01.630
Mohammad Anwar: how I started into this PHIE Forest API.

31
00:03:02.150 --> 00:03:02.939
Mohammad Anwar: And, I don't know.

32
00:03:02.940 --> 00:03:09.679
Gabor Szabo: Sorry, Mohammad, there is a note at the top of the screen. You are sharing your entire screen.

33
00:03:10.210 --> 00:03:10.830
Gabor Szabo: Okay.

34
00:03:10.830 --> 00:03:11.360
Mohammad Anwar: Yay.

35
00:03:11.360 --> 00:03:12.550
Gabor Szabo: Can you move that?

36
00:03:12.880 --> 00:03:17.709
Gabor Szabo: Maybe you can click on the minus sign and it will hopefully disappear.

37
00:03:25.120 --> 00:03:26.050
Gabor Szabo: Can you see it?

38
00:03:27.240 --> 00:03:29.650
Mohammad Anwar: I don't see a money sign anywhere.

39
00:03:30.060 --> 00:03:39.590
Gabor Szabo: Okay, well, I'll… it's not a problem right now, so go ahead, and then I'll tell you if it hides something on the screen, okay?

40
00:03:39.740 --> 00:03:40.989
Mohammad Anwar: Okay, fair enough.

41
00:03:42.420 --> 00:03:49.290
Mohammad Anwar: So, the whole idea for this… web framework was. Before…

42
00:03:50.320 --> 00:03:59.690
Mohammad Anwar: this, I was mostly into Donset 2, so whenever I had to build a web framework, I would just go… go to Donset 2, and my…

43
00:03:59.840 --> 00:04:12.540
Mohammad Anwar: job is done. It's… it's… it's quite easy to get… get a site up and running in no time, so… so when I… when I started working on, I believe, a couple of months, a few months ago, on

44
00:04:12.850 --> 00:04:15.499
Mohammad Anwar: DBIX class async.

45
00:04:15.660 --> 00:04:18.500
Mohammad Anwar: And I got into this whole async business.

46
00:04:19.550 --> 00:04:28.600
Mohammad Anwar: And I… every time I looked into my web application, I thought, what if I can turn this into a synchronous web framework?

47
00:04:29.420 --> 00:04:41.370
Mohammad Anwar: And I've been thinking about doing this, and then when somebody introduced me about the Python Fast API, I thought, wow, this is what I should be working on next, after my…

48
00:04:42.210 --> 00:04:50.680
Mohammad Anwar: DBIC async, project. So, even though I'm not, a Python developer, I…

49
00:04:51.190 --> 00:04:59.590
Mohammad Anwar: I know a little bit of Python, I can read Python, I can… but I'm not an expert in Python, but I still want to do

50
00:05:00.050 --> 00:05:08.699
Mohammad Anwar: understand what Fast API is doing, and how I can build in, in my Perl site, port it into Perl.

51
00:05:08.880 --> 00:05:09.830
Mohammad Anwar: So…

52
00:05:09.940 --> 00:05:21.680
Mohammad Anwar: Before that, I was… I had a little bit, like, introduction of PAGI. I'm sure you guys have known what is a synchronous Gateway Interface.

53
00:05:22.330 --> 00:05:29.349
Mohammad Anwar: And the guy who created this specification page is specification, John Napierogosi.

54
00:05:30.420 --> 00:05:38.690
Mohammad Anwar: I had a quick chat with him, and he kind of introduced me. He kind of guided me about the whole.

55
00:05:38.840 --> 00:05:47.380
Mohammad Anwar: specification, and how I can use that as a… as a foundation for my, this fast API port.

56
00:05:47.830 --> 00:05:53.140
Mohammad Anwar: two points, so… so the whole… web framework is…

57
00:05:53.370 --> 00:06:05.300
Mohammad Anwar: is based on… is a foundation on paging. So everything is… be, like, an asynchronous form using paging specifications, so… so that's where it all started, and…

58
00:06:06.510 --> 00:06:13.530
Mohammad Anwar: Even though it… from the feature point of view, I think I have covered almost everything that

59
00:06:14.000 --> 00:06:27.039
Mohammad Anwar: a Python Fast API has, but may not be complete. So, I must have just touched the surface, but not implemented everything that you find in Python FastAPI. So, probably you… if you know

60
00:06:27.110 --> 00:06:34.600
Mohammad Anwar: Python faster, you can probably tell me, okay, what bit is missing, and I probably… and maybe I next… next time, I'll try to…

61
00:06:34.930 --> 00:06:36.509
Mohammad Anwar: Fill the gap, gap.

62
00:06:36.790 --> 00:06:40.549
Mohammad Anwar: So, in this presentation, probably, I'm gonna go through

63
00:06:40.990 --> 00:06:48.630
Mohammad Anwar: this four-part session. First is going to be the foundation, where I'm gonna go through from the…

64
00:06:49.020 --> 00:06:54.580
Mohammad Anwar: Beginning from 0 to… Where we have now, and then we're gonna meet

65
00:06:54.770 --> 00:07:00.630
Mohammad Anwar: with my web framework, where I'm going to show you the basic,

66
00:07:00.950 --> 00:07:04.709
Mohammad Anwar: Routing and everything, and all the dependency injections, and

67
00:07:05.060 --> 00:07:10.190
Mohammad Anwar: And all other web frameworks, common web framework features, and all things.

68
00:07:11.340 --> 00:07:17.469
Mohammad Anwar: And one thing that really… got me into this. It was this security,

69
00:07:17.650 --> 00:07:28.190
Mohammad Anwar: features, security schemes that I had to build because FastAPI has those kind of schemes. So those… those are the interesting things that I'm going to show… share with you.

70
00:07:28.860 --> 00:07:34.810
Mohammad Anwar: And, yeah. So, let's start with the first… So…

71
00:07:37.410 --> 00:07:46.270
Mohammad Anwar: So, basically, so we start with the framework. I'm sure you all know what The framework is… is… Basically.

72
00:07:48.080 --> 00:07:50.889
Mohammad Anwar: You, you get a brother send a request.

73
00:07:51.940 --> 00:07:56.629
Mohammad Anwar: And then somebody accepts those requests and do something, and then you get a result back.

74
00:07:56.790 --> 00:08:00.750
Mohammad Anwar: So this… something in between is your web framework.

75
00:08:01.180 --> 00:08:05.720
Mohammad Anwar: So, this particular web framework, where…

76
00:08:06.380 --> 00:08:12.110
Mohammad Anwar: We are gonna… we… we're gonna deal… work with it. So, basically.

77
00:08:18.020 --> 00:08:18.880
Mohammad Anwar: Bear with me.

78
00:08:23.900 --> 00:08:29.159
Mohammad Anwar: So this whole asynchronous business is where you don't wait for any

79
00:08:30.730 --> 00:08:33.510
Mohammad Anwar: one, request to process. You can…

80
00:08:33.659 --> 00:08:41.679
Mohammad Anwar: fire off a request, and then you can move on to your next task without waiting for it to finish it. So, that's how the whole

81
00:08:43.250 --> 00:08:58.329
Mohammad Anwar: asynchronous web framework is based on. So, this is where the Pagy fast API is going to help us, where you have multiple requests coming through and not waiting for it to finish, and then you move on to your next, actions.

82
00:08:58.520 --> 00:09:00.660
Mohammad Anwar: That's where it's gonna work out.

83
00:09:03.180 --> 00:09:10.219
Mohammad Anwar: So… so… so… so what is Pager? It's this, like, per asynchronous gateway interface, which is… which is…

84
00:09:10.320 --> 00:09:15.880
Mohammad Anwar: Which is like a Act like a socket, where Anybody…

85
00:09:16.590 --> 00:09:19.819
Mohammad Anwar: Speaking, application can talk.

86
00:09:20.250 --> 00:09:26.750
Mohammad Anwar: You can plug into this socket where you can get your applications running.

87
00:09:28.120 --> 00:09:35.530
Mohammad Anwar: And also, you don't actually… create a page directly, and you… framework, like.

88
00:09:35.630 --> 00:09:41.569
Mohammad Anwar: the one I created, the PG files, API can… Help you… Talk to Beijing.

89
00:09:46.580 --> 00:09:50.679
Mohammad Anwar: So… These are the layers. So, first is your…

90
00:09:51.280 --> 00:09:58.550
Mohammad Anwar: routes and business logic, where your application, you create your applications. And then, FastAPI, PG FastAP, where we help you

91
00:09:58.710 --> 00:10:04.140
Mohammad Anwar: Create a routing, and all the type validations, dependency, injections.

92
00:10:04.520 --> 00:10:09.389
Mohammad Anwar: And also, you get, automated documentation, which I'm going to show you.

93
00:10:09.660 --> 00:10:10.610
Mohammad Anwar: Later.

94
00:10:12.410 --> 00:10:20.510
Mohammad Anwar: And the pay… the… the… the whole, Peggy First API are views, There's a…

95
00:10:21.200 --> 00:10:24.320
Mohammad Anwar: there's a Pagy server that comes with Pagy,

96
00:10:24.570 --> 00:10:34.180
Mohammad Anwar: tools, which I've used it, to run my page-y fast API applications, so… That's where I'm gonna see.

97
00:10:37.070 --> 00:10:47.180
Mohammad Anwar: So, this is what… this is how you can just create your Hello World kind of application, web application, if you want to start with the PG Fast API. So, just install it, and then…

98
00:10:47.490 --> 00:10:49.570
Mohammad Anwar: Create an op… create an,

99
00:10:49.960 --> 00:10:52.730
Mohammad Anwar: fast API applications, which is giving

100
00:10:53.490 --> 00:10:59.210
Mohammad Anwar: And start giving a route, and then have a handler where it's a synchronous subroutine.

101
00:10:59.660 --> 00:11:06.200
Mohammad Anwar: Which has a context, you get a context, and then you work… You worked with it.

102
00:11:06.840 --> 00:11:11.320
Mohammad Anwar: context, and then display it. So this is where you get the hello world message.

103
00:11:11.780 --> 00:11:14.680
Mohammad Anwar: And then, once you have this application.

104
00:11:14.910 --> 00:11:21.090
Mohammad Anwar: Run it as a PG server. By default, it listens to 5,000 port.

105
00:11:21.310 --> 00:11:26.060
Mohammad Anwar: And then, this is how you… you access your route.

106
00:11:26.920 --> 00:11:28.150
Mohammad Anwar: Underlooker has.

107
00:11:33.300 --> 00:11:38.510
Mohammad Anwar: Also, when you created a route, You… you can access the…

108
00:11:39.460 --> 00:11:42.990
Mohammad Anwar: The, the parameters, routing parameters.

109
00:11:43.250 --> 00:12:01.399
Mohammad Anwar: Just like this. And then, for example, here you're creating a route where you access a particular specific item, where you have an ID as a unique item ID, and that get access… you can access it in a context. This $C is the page E context.

110
00:12:01.890 --> 00:12:10.159
Mohammad Anwar: excuse me, page context, and then you can figure out what the ID is as a… that you received as a routing parameter.

111
00:12:10.290 --> 00:12:12.850
Mohammad Anwar: So, currently, you can create

112
00:12:13.200 --> 00:12:20.750
Mohammad Anwar: Get, post, boot, patch, and delete, and all these, actions that you can create in your applications.

113
00:12:21.550 --> 00:12:26.269
Mohammad Anwar: And they all are async by default, so it's non-blocking.

114
00:12:32.510 --> 00:12:38.900
Mohammad Anwar: The best thing about it is you get automatic validations, which is…

115
00:12:39.000 --> 00:12:47.269
Mohammad Anwar: built in, so you don't need to do any kind of validations manually, so just… just say, okay, so when you, when you…

116
00:12:47.610 --> 00:12:52.970
Mohammad Anwar: For example, in this example, I'm just saying, I'm posting data.

117
00:12:53.080 --> 00:13:00.600
Mohammad Anwar: something in these actions, and you… you can specify your key, and then your data type.

118
00:13:01.020 --> 00:13:03.660
Mohammad Anwar: For this, we are using type dining.

119
00:13:03.880 --> 00:13:11.780
Mohammad Anwar: For all the… The type validation is done by the type dining, so that's where you get the

120
00:13:12.350 --> 00:13:16.979
Mohammad Anwar: All the type dining, validations you get by default.

121
00:13:20.840 --> 00:13:25.330
Mohammad Anwar: Next is the dependency injection, which is, I think, one of the

122
00:13:26.680 --> 00:13:34.740
Mohammad Anwar: core feature of FastAPI. This was something new for me. I was… I never heard of this before.

123
00:13:34.850 --> 00:13:39.960
Mohammad Anwar: Which I find it very handy in case of, like, for example, when you

124
00:13:41.130 --> 00:13:47.940
Mohammad Anwar: When you have, like, a database connection that you want to inject, and every…

125
00:13:49.630 --> 00:13:53.420
Mohammad Anwar: And then that get injected, and then you can use it instead of…

126
00:13:54.890 --> 00:14:02.299
Mohammad Anwar: Doing, as global, so… so you just declare it once, and then you can inject in every method that you want.

127
00:14:02.650 --> 00:14:08.809
Mohammad Anwar: that object, to be available. So, for example, in… in an application where you…

128
00:14:08.830 --> 00:14:23.570
Mohammad Anwar: you will interact with database every time, so you can just inject that database handle, and then inside the handler, you can access that object, and then start… you can interact with the database. So this is quite handy if you have any kind of

129
00:14:23.950 --> 00:14:27.820
Mohammad Anwar: Code that you want to inject into any Rude.

130
00:14:31.640 --> 00:14:37.670
Mohammad Anwar: And also, You, you get the default, support for the middleware and the cores.

131
00:14:38.460 --> 00:14:42.290
Mohammad Anwar: So, for… if you want to add any middleware you have, you can just…

132
00:14:42.750 --> 00:14:46.029
Mohammad Anwar: Call this add middleware method, and then pass on your

133
00:14:46.150 --> 00:14:50.290
Mohammad Anwar: Your subroutine, and then you can work on

134
00:14:50.530 --> 00:14:57.350
Mohammad Anwar: this add middleware features. Also, similar way, you can add course as well, if you want to have

135
00:14:57.830 --> 00:15:05.369
Mohammad Anwar: anything, just call add course, and then you can pass whatever parameters you need to pass on. So this is how you can add the course.

136
00:15:06.760 --> 00:15:18.190
Mohammad Anwar: I'm just going through the basic thing. If you want a fully functional application, if you go to the CPAN and go to the Peggy First API, there's a… there's a whole bunch of,

137
00:15:19.220 --> 00:15:33.689
Mohammad Anwar: fully functional applications, where I'm going… I've gone through each of these features in detail, so you will have proper… for working core application, where you can see how it actually works in a toy application.

138
00:15:36.580 --> 00:15:38.720
Mohammad Anwar: Next is the rate limiting.

139
00:15:39.030 --> 00:15:43.250
Mohammad Anwar: So, the… the… This kind of thing, I…

140
00:15:43.400 --> 00:15:46.780
Mohammad Anwar: I really liked it, because I remember when

141
00:15:47.530 --> 00:15:54.509
Mohammad Anwar: I was building my personal website where I had to put some rate-limiting things, so…

142
00:15:54.620 --> 00:16:01.010
Mohammad Anwar: I had to do everything by hand. So this… this… this page… page… first API.

143
00:16:01.150 --> 00:16:06.500
Mohammad Anwar: help me not to create a boilerplate code, and then I just have everything

144
00:16:07.390 --> 00:16:16.159
Mohammad Anwar: handy, so you don't need to do anything manually. So just add limit rate, and then you can say… you can add limit rate.

145
00:16:16.320 --> 00:16:17.590
Mohammad Anwar: as, as an,

146
00:16:17.920 --> 00:16:23.129
Mohammad Anwar: Per route, or you can… you can do as an overall as well… as well.

147
00:16:23.300 --> 00:16:30.620
Mohammad Anwar: By default, the limiting is happening in memory, but you can create, other,

148
00:16:30.880 --> 00:16:44.919
Mohammad Anwar: schema as a driver as well. So there are two separate, distributions I've created, one in CHI and one in Redis, if you want… if you want, like, an extended driver for rate limited.

149
00:16:48.260 --> 00:16:49.730
Mohammad Anwar: Next is this.

150
00:16:49.830 --> 00:16:54.680
Mohammad Anwar: CSRRI protection, which is also built in. By default,

151
00:16:54.870 --> 00:16:57.219
Mohammad Anwar: It infosed, like, as a header.

152
00:16:57.930 --> 00:16:58.640
Mohammad Anwar: And…

153
00:16:58.870 --> 00:17:09.579
Mohammad Anwar: Now, also, it's like a double submit cookie, where it… it set the, header, and also set the token, token as well.

154
00:17:11.319 --> 00:17:17.989
Mohammad Anwar: And this is… that's… you just call enable CSRF, and you assign the secret, whatever secret it is.

155
00:17:21.060 --> 00:17:31.759
Mohammad Anwar: This one was… I think it's not part of the FOST API, but I added it because I thought it's quite handy if you're building a web framework and

156
00:17:32.170 --> 00:17:34.149
Mohammad Anwar: To have this boat protection.

157
00:17:34.450 --> 00:17:37.300
Mohammad Anwar: is… is not… Like, a complete,

158
00:17:37.760 --> 00:17:53.640
Mohammad Anwar: implementation. It's just a basic one for now. Probably, I'm going to extend it, as I go. So, you have a difficulty level, and you can assign a boat, environmental variable as a secret, and that is used,

159
00:17:53.860 --> 00:17:54.910
Mohammad Anwar: Every time.

160
00:17:55.160 --> 00:17:56.889
Mohammad Anwar: Somebody tried to attack.

161
00:18:00.190 --> 00:18:04.429
Mohammad Anwar: This is… next is the… the applications,

162
00:18:04.790 --> 00:18:07.469
Mohammad Anwar: Lifespan, where you can just have a…

163
00:18:07.740 --> 00:18:11.930
Mohammad Anwar: on startup and on shutdown. This is quite handy if you…

164
00:18:12.140 --> 00:18:28.930
Mohammad Anwar: If you have, like, a… if you have, database interaction, so mostly, like, on startup, you can just set up your database instance, and on shutdown, you can probably, clean up your database handle once everything is… is done, so you have a nice…

165
00:18:29.470 --> 00:18:36.829
Mohammad Anwar: like, entry point on startup and shutdown. So you can use this, on startup and on shutdown method.

166
00:18:36.970 --> 00:18:39.120
Mohammad Anwar: To do this kind of operation.

167
00:18:42.150 --> 00:18:47.720
Mohammad Anwar: Next is the WebSocket. I have been playing with the WebSocket.

168
00:18:48.110 --> 00:18:58.519
Mohammad Anwar: in the recent past. So, when I was doing this, I thought, why not implement a WebSocket as well on top of this PG FAST API? So, this is where

169
00:18:58.820 --> 00:19:06.020
Mohammad Anwar: Basically, I'm… I'm using, the, there's a Pagy WebSocket, distribution already.

170
00:19:06.360 --> 00:19:16.020
Mohammad Anwar: available from Pagey tools, from the PG specification, so nothing is done here. Everything is delegated to that PG web socket.

171
00:19:16.200 --> 00:19:19.719
Mohammad Anwar: And that's where everything is happening, so you just…

172
00:19:19.830 --> 00:19:25.929
Mohammad Anwar: create a web… call a WebSocket method, and just pass in the handler, and that will do.

173
00:19:26.260 --> 00:19:28.779
Mohammad Anwar: the WebSocket functionality for you.

174
00:19:31.990 --> 00:19:34.860
Mohammad Anwar: Next is SSE, again.

175
00:19:35.310 --> 00:19:40.150
Mohammad Anwar: This is, again, delegated to the PG SSI, which… from Pagey Tools.

176
00:19:40.690 --> 00:19:41.849
Mohammad Anwar: Not from the…

177
00:19:42.150 --> 00:19:48.910
Mohammad Anwar: PG Fast API, but this is quite handy, and you get, by default, if you… if you have

178
00:19:49.130 --> 00:19:59.359
Mohammad Anwar: if you want a SSE functionality in AGFAST API, you just create a method, and then root, and then you provide a handler where you can

179
00:19:59.460 --> 00:20:03.559
Mohammad Anwar: do all kind of SSE-related operations inside this handler.

180
00:20:03.740 --> 00:20:06.499
Mohammad Anwar: As an asynchronous, mode.

181
00:20:09.910 --> 00:20:27.520
Mohammad Anwar: this is something, I… was not 100% sure, but then, after talking to John, the creator of Pengie, and I thought, okay, basically, I did… I don't want to keep, like, a…

182
00:20:27.660 --> 00:20:28.610
Mohammad Anwar: Later, yes.

183
00:20:29.480 --> 00:20:33.680
Mohammad Anwar: Basic… I didn't want to have, like, a proper…

184
00:20:34.280 --> 00:20:43.400
Mohammad Anwar: whether to use a feature I.O. or iOSync. So, eventually, we decided that it's better to keep a feature I.O.

185
00:20:43.720 --> 00:20:45.369
Mohammad Anwar: As, as my,

186
00:20:45.670 --> 00:20:56.860
Mohammad Anwar: all the IO sync thingy. So it's… so for all the event loops, everything is dependent on feature I.O. as a baseline.

187
00:20:59.330 --> 00:21:07.900
Mohammad Anwar: are also… with, first, PG Fast API, you get the… by… by default, you get the…

188
00:21:09.100 --> 00:21:13.159
Mohammad Anwar: the documentation, so I get documentation for free.

189
00:21:13.470 --> 00:21:19.820
Mohammad Anwar: And… just get a slash docs and slash open API JSON you get by default.

190
00:21:20.370 --> 00:21:26.469
Mohammad Anwar: So it's quite handy if you have… if you… you don't need to build the Sawyer interface by hand, you just get

191
00:21:26.850 --> 00:21:27.969
Mohammad Anwar: by default.

192
00:21:31.800 --> 00:21:36.330
Mohammad Anwar: So… Again, as a recap, I'm going to say…

193
00:21:37.650 --> 00:21:44.389
Mohammad Anwar: Why picking FastAPI? Because it's async and it's non-blocking, which is the main features.

194
00:21:44.900 --> 00:21:49.740
Mohammad Anwar: You get a database injection, dependency injection, as a second feature.

195
00:21:50.110 --> 00:21:53.850
Mohammad Anwar: Third is this… is… is it type safe. You can… you can…

196
00:21:54.050 --> 00:21:56.699
Mohammad Anwar: You, you get a default,

197
00:21:56.870 --> 00:21:59.940
Mohammad Anwar: type checks using the TypeTiny module.

198
00:22:00.060 --> 00:22:02.830
Mohammad Anwar: And you get automated documentation.

199
00:22:06.280 --> 00:22:09.390
Mohammad Anwar: So one thing that was missing was this.

200
00:22:09.890 --> 00:22:11.250
Mohammad Anwar: security thing.

201
00:22:11.910 --> 00:22:21.050
Mohammad Anwar: So, so far, we never… we haven't touched the… The security pathway, how to…

202
00:22:21.200 --> 00:22:26.619
Mohammad Anwar: to process the session and everything. So, I really wanted to build in

203
00:22:27.420 --> 00:22:35.899
Mohammad Anwar: the authorizations. For this, I created a separate distribution called PG Fast API Security, which is

204
00:22:37.370 --> 00:22:48.440
Mohammad Anwar: separate distribution outside of PG FastAPI that handles all four common schemes that is in the Python Fast API.

205
00:22:49.290 --> 00:22:57.150
Mohammad Anwar: these are the four… the four schemes that for HTTP bearer, HTTP basic API key, and odd.

206
00:22:57.900 --> 00:22:59.980
Mohammad Anwar: And… These are…

207
00:23:00.590 --> 00:23:07.590
Mohammad Anwar: like, implemented as a separate distribution page for the API security. You can… you get all those

208
00:23:08.000 --> 00:23:11.199
Mohammad Anwar: Four schemes, depending on how you want to use it.

209
00:23:11.660 --> 00:23:18.060
Mohammad Anwar: One thing is there is the… and all… this PG8 Fast API Security, we… we actually

210
00:23:18.540 --> 00:23:28.109
Mohammad Anwar: don't do any verification. It's just… we do this, just extract. We just, find out what is in there, and we just…

211
00:23:30.120 --> 00:23:36.609
Mohammad Anwar: we just fetch the security details and doesn't do any checks. Checking is done by

212
00:23:36.950 --> 00:23:40.030
Mohammad Anwar: The applications on top of it.

213
00:23:41.710 --> 00:23:43.230
Mohammad Anwar: For example, here.

214
00:23:43.370 --> 00:23:43.840
Mohammad Anwar: And then…

215
00:23:43.840 --> 00:23:49.379
Gabor Szabo: Sorry. No, but actually, go on, I'll ask you the questions after.

216
00:23:51.030 --> 00:23:54.390
Mohammad Anwar: Okay, so for example, here in this,

217
00:23:54.750 --> 00:23:58.140
Mohammad Anwar: We're creating a STT bearer scheme.

218
00:23:58.600 --> 00:24:05.059
Mohammad Anwar: as there, and then we inject that, as the token gets injected as dependencies.

219
00:24:05.400 --> 00:24:06.090
Mohammad Anwar: And…

220
00:24:06.410 --> 00:24:20.119
Mohammad Anwar: Here, if you see, we're calling the verify JWT, which is Java token verification, which is outside of this… this framework. So you… this scheme doesn't

221
00:24:20.420 --> 00:24:39.389
Mohammad Anwar: give you this default, you have to create your own verification logic, and… and once you're done, and then you just… if… if it… if there is any issue, you just, you don't die, you actually set the status, and then return the details. That's how you… you handle the…

222
00:24:39.520 --> 00:24:45.460
Mohammad Anwar: any… Error, or any… any issue with the verifications. If anything.

223
00:24:46.330 --> 00:24:48.429
Mohammad Anwar: Anything, needs to be handled.

224
00:24:52.050 --> 00:24:55.499
Gabor Szabo: Okay, maybe now is the time to ask the questions, right?

225
00:24:55.670 --> 00:24:58.319
Gabor Szabo: Because you're in between two topics.

226
00:24:58.430 --> 00:25:06.179
Gabor Szabo: The first question was, is PUGI, I don't know, PAGI? Fast PAGI?

227
00:25:06.350 --> 00:25:09.149
Gabor Szabo: Fast API reverse proxy Aware.

228
00:25:11.220 --> 00:25:12.800
Mohammad Anwar: Right now, no.

229
00:25:14.680 --> 00:25:23.250
Gabor Szabo: So does it mean that you have to put it in front of the… so that that's the front first thing on the internet? So you can't put a reverse proxy in front of it?

230
00:25:24.480 --> 00:25:25.110
Gabor Szabo: Okay.

231
00:25:25.110 --> 00:25:26.589
Mohammad Anwar: At this point, no.

232
00:25:28.700 --> 00:25:37.100
Gabor Szabo: Okay, and then it continues, like, PHEI talking to… talking HTTP to a HA proxy.

233
00:25:37.330 --> 00:25:41.309
Gabor Szabo: And then HAProxy talks to clients over HTTPS.

234
00:25:42.130 --> 00:25:42.720
Mohammad Anwar: Yeah.

235
00:25:43.270 --> 00:25:44.660
Gabor Szabo: If that's possible?

236
00:25:45.930 --> 00:25:50.140
Mohammad Anwar: I've not tried it, maybe I'll give it a try, see if it's possible.

237
00:25:50.520 --> 00:25:51.789
Mohammad Anwar: I think it should be.

238
00:25:53.090 --> 00:25:58.979
Gabor Szabo: Okay. The other question is, how do I customize the automated docs?

239
00:25:59.380 --> 00:26:04.370
Gabor Szabo: E.g, I want to add a description or request example.

240
00:26:05.920 --> 00:26:13.899
Mohammad Anwar: You, you can. I'm going to show you later, where I have created another application where

241
00:26:14.430 --> 00:26:26.560
Mohammad Anwar: I'm going to show you how I've described all the description of the doc where you can see everything, how you can manage, set up everything in an application. I'm going to show you.

242
00:26:26.750 --> 00:26:27.500
Gabor Szabo: Okay.

243
00:26:28.800 --> 00:26:35.569
Mohammad Anwar: So… later, after this, security schemes, I even…

244
00:26:36.080 --> 00:26:38.409
Mohammad Anwar: I added these to type bot.

245
00:26:38.960 --> 00:26:43.639
Mohammad Anwar: and then response model, and all those features. So…

246
00:26:44.390 --> 00:26:51.309
Mohammad Anwar: with this type path, this… either this pagey fast API type path, where you can check the,

247
00:26:51.780 --> 00:27:00.850
Mohammad Anwar: the data type, as well, of the, of the, the root, Root, pathroot.

248
00:27:00.960 --> 00:27:06.700
Mohammad Anwar: So, for example, here I'm checking whether the item ID is integer,

249
00:27:07.410 --> 00:27:14.099
Mohammad Anwar: So this kind of validation can be done as a part of dependency. You can check all those… the key.

250
00:27:14.370 --> 00:27:27.059
Mohammad Anwar: And with the response model, with this, another distribution, which is PG Fast API response model, with this method, with response model, we can add… we can… we can add and make it as a handler, and then

251
00:27:27.390 --> 00:27:33.179
Mohammad Anwar: that further checks can be done, like, for example, ID should be in an integer, name should be in a string.

252
00:27:33.810 --> 00:27:41.220
Mohammad Anwar: So, that can be done as well, with these two handy path and response model distribution package.

253
00:27:45.140 --> 00:27:53.470
Mohammad Anwar: So… The full picture is, basically, you create your application where you define your rules and business logic.

254
00:27:54.010 --> 00:27:58.970
Mohammad Anwar: And then Fast API… page… PG-fast API security.

255
00:27:59.140 --> 00:28:03.209
Mohammad Anwar: Help you with, with the defense and,

256
00:28:03.350 --> 00:28:09.420
Mohammad Anwar: And you can check the… extract the auth key, auth token, everything.

257
00:28:09.530 --> 00:28:18.030
Mohammad Anwar: And then, first API, FastAPI, PG Fast API can help you doing the routing and all validations and injections.

258
00:28:18.370 --> 00:28:20.959
Mohammad Anwar: And finally, with a PG server.

259
00:28:21.410 --> 00:28:26.240
Mohammad Anwar: Your application can start… you can restart running your application there.

260
00:28:29.030 --> 00:28:30.840
Mohammad Anwar: Okay… Food.

261
00:28:31.730 --> 00:28:34.539
Mohammad Anwar: These are my common questions, okay.

262
00:28:35.700 --> 00:28:39.990
Mohammad Anwar: how does this compare? I mean, it's exactly the same thing,

263
00:28:40.260 --> 00:28:45.120
Mohammad Anwar: what I have found out in Python FastAPI. I might have missed something.

264
00:28:45.820 --> 00:28:51.910
Mohammad Anwar: So if you find anything missing, probably you can tell me, and then I can… Fill those gaps.

265
00:28:53.260 --> 00:29:00.130
Mohammad Anwar: And… as I say, maybe you don't need to learn iOS or feature async deeply, so just

266
00:29:01.960 --> 00:29:08.749
Mohammad Anwar: Peggy Sabo owns all the event loops, so everything is done, so you don't need to be worrying anything.

267
00:29:09.870 --> 00:29:12.310
Mohammad Anwar: And… Authentication built in.

268
00:29:12.700 --> 00:29:16.200
Mohammad Anwar: Not by design, but you can create a schema.

269
00:29:16.660 --> 00:29:20.120
Mohammad Anwar: And then use a middleware, and depends.

270
00:29:20.610 --> 00:29:21.950
Mohammad Anwar: For security ads.

271
00:29:26.240 --> 00:29:36.500
Mohammad Anwar: for Perl version, I… the whole, the whole framework are used The latest world-class field… world-class…

272
00:29:37.120 --> 00:29:39.420
Mohammad Anwar: New per class, so, method.

273
00:29:40.280 --> 00:29:49.000
Mohammad Anwar: Feature, experimental feature, or… And for that, I see… the minimum is 538 is what you need, and then…

274
00:29:49.220 --> 00:29:54.289
Mohammad Anwar: That's the minimum is… you can… you have to have to run this PGA.

275
00:29:54.520 --> 00:29:55.710
Mohammad Anwar: Bonsai APA.

276
00:29:57.680 --> 00:30:03.380
Mohammad Anwar: And also for… For rate limit, by default,

277
00:30:03.910 --> 00:30:13.609
Mohammad Anwar: By default, you get an in-memory rate limit, but you can have a ready source CHI as well, if you want to have that backend for rate limit.

278
00:30:15.830 --> 00:30:21.800
Mohammad Anwar: You can, of course, you can ask any bug… you can report your bug to the GitHub repository.

279
00:30:22.020 --> 00:30:29.730
Mohammad Anwar: Which is a pagey-fast API issues, where you can… you can report any issues or any requests you have, yeah.

280
00:30:31.710 --> 00:30:32.679
Mohammad Anwar: the… the name?

281
00:30:32.680 --> 00:30:34.060
Gabor Szabo: Another question.

282
00:30:34.250 --> 00:30:46.500
Gabor Szabo: Sorry, another question. What about nested data validation? A flow in using TypeTiny for schema validation is that there isn't a way to model presence.

283
00:30:47.810 --> 00:30:54.319
Gabor Szabo: As far… if I… as far as I know. I could be wrong, though. That's the com… that's the question.

284
00:30:55.780 --> 00:30:58.190
Mohammad Anwar: So you're saying… sorry, I didn't get the question.

285
00:30:59.050 --> 00:31:03.230
Gabor Szabo: Yeah, so the question is, is there nested data validation?

286
00:31:04.400 --> 00:31:06.910
Mohammad Anwar: No, no, not at the moment, not currently.

287
00:31:07.320 --> 00:31:08.100
Gabor Szabo: Okay.

288
00:31:08.360 --> 00:31:11.490
Mohammad Anwar: So it's just… just key value, key value.

289
00:31:13.040 --> 00:31:18.620
Mohammad Anwar: Not as an estate one right now, but yeah, maybe in future we can support that.

290
00:31:19.950 --> 00:31:26.509
Mohammad Anwar: So, I think the latest version is 1.73 is the latest on CPAN.

291
00:31:27.360 --> 00:31:32.740
Mohammad Anwar: And we… Yes.

292
00:31:34.090 --> 00:31:37.480
Mohammad Anwar: Does the type path replace query? No, it's parameter.

293
00:31:38.270 --> 00:31:41.110
Mohammad Anwar: So you're still using type R, type training.

294
00:31:41.930 --> 00:31:52.819
Mohammad Anwar: Exception Handler? Yes, we have Exception Handler, this package, for… For this… That's it.

295
00:31:55.140 --> 00:31:56.370
Mohammad Anwar: I'm sure.

296
00:31:58.190 --> 00:31:59.440
Mohammad Anwar: to desire them.

297
00:32:01.260 --> 00:32:08.500
Mohammad Anwar: my GitHub repository for Fast API… PG Fast API, and PG Fast API Security.

298
00:32:09.860 --> 00:32:13.110
Mohammad Anwar: And before I cut that, let me…

299
00:32:16.550 --> 00:32:18.810
Mohammad Anwar: Can… can I… can you see my screen?

300
00:32:22.280 --> 00:32:23.720
Mohammad Anwar: Can you see my screen?

301
00:32:23.720 --> 00:32:25.420
Gabor Szabo: Yes, we can see him at the CPU.

302
00:32:25.420 --> 00:32:30.100
Mohammad Anwar: So, this is my, C-pen, metal C-pen, where…

303
00:32:30.240 --> 00:32:32.540
Mohammad Anwar: first API. I'm going to show you

304
00:32:33.440 --> 00:32:36.819
Mohammad Anwar: In my presentation, I've only touched

305
00:32:38.010 --> 00:32:41.909
Mohammad Anwar: this, surface. So, if you want to go in details.

306
00:32:41.910 --> 00:32:53.690
Gabor Szabo: Wait a second, there is a very… another question here. Is the event loop an internal detail? Can the program hook to it to wait for other events, like file system?

307
00:32:59.830 --> 00:33:02.159
Mohammad Anwar: Sorry, I didn't… I didn't understand whatsoever's question.

308
00:33:02.160 --> 00:33:16.559
Gabor Szabo: Yeah, I'm not sure that I understand totally the question, but the question is, is the event loop internal… an internal detail? And then the continuation is, can the program hook to it to wait for other events?

309
00:33:16.840 --> 00:33:17.290
Mohammad Anwar: None.

310
00:33:17.290 --> 00:33:17.730
Gabor Szabo: by, you know.

311
00:33:17.960 --> 00:33:20.840
Mohammad Anwar: N-No, no, no, not at the moment.

312
00:33:21.120 --> 00:33:31.379
Gabor Szabo: No, I mean, okay, so that's strange to me. So if you have a… so it's only async on the website? If you go to the database, it's not a sync?

313
00:33:32.030 --> 00:33:35.059
Mohammad Anwar: It is… no, from the database side, yes, it is a sync, yeah.

314
00:33:35.310 --> 00:33:42.309
Gabor Szabo: And if you want… so also, if you have an async database access… sorry, file system access, that's also async, right?

315
00:33:43.420 --> 00:33:45.010
Mohammad Anwar: Yes, that's true, yeah.

316
00:33:45.010 --> 00:33:49.509
Gabor Szabo: Yeah, so, yeah, but you don't hook into the… into the event loop.

317
00:33:50.020 --> 00:33:50.750
Mohammad Anwar: No, you don.

318
00:33:50.750 --> 00:33:57.969
Gabor Szabo: you can have the… you can have async methods, so I'm not sure I understand the question totally.

319
00:33:58.760 --> 00:34:03.329
Gabor Szabo: But you can… can have… use other async methods, right?

320
00:34:03.840 --> 00:34:09.160
Mohammad Anwar: Yes. So, for example, in this application, you can find it on the…

321
00:34:09.280 --> 00:34:14.239
Mohammad Anwar: in the distribution, where I am… I'm showing,

322
00:34:15.370 --> 00:34:21.460
Mohammad Anwar: So, if… if you can see, I… have a DBIC async,

323
00:34:22.570 --> 00:34:30.899
Mohammad Anwar: handler, class, where I'm having a database connection to a SQLite, and running as an async, Divic.

324
00:34:31.480 --> 00:34:42.260
Mohammad Anwar: And then… I bought… one route which I'm posting data, and second is on Fitching a user ID.

325
00:34:44.310 --> 00:34:48.580
Mohammad Anwar: If I can… maybe I can run this application.

326
00:34:48.909 --> 00:34:50.059
Mohammad Anwar: Maybe not.

327
00:34:50.300 --> 00:34:55.679
Mohammad Anwar: So, so, for example, so these are the examples you can find, And the…

328
00:34:56.080 --> 00:35:00.030
Mohammad Anwar: in the MetaCPN, distribution, for all this.

329
00:35:00.980 --> 00:35:14.800
Mohammad Anwar: CSRF, if you want to look into the details how you can implement CSRF using PG Fast API, you can look into these examples, or if you're looking at the DBK Sync integration, or you can look into the

330
00:35:14.860 --> 00:35:21.229
Mohammad Anwar: the docs, how the docs get created for… that's what the Giver was asking. So, for example, if I…

331
00:35:21.910 --> 00:35:29.170
Mohammad Anwar: Open up here, so… this… this is quite, this is interesting, and I got quite a…

332
00:35:29.470 --> 00:35:45.790
Mohammad Anwar: nice, working example. So you can go into the details in these examples where you can find, exactly how you can implement. There's another example called where you have a rate limit, how you implement the rate limit using the pages.

333
00:35:46.340 --> 00:35:47.540
Mohammad Anwar: first API.

334
00:35:47.670 --> 00:35:53.200
Mohammad Anwar: Similarly, you have an example, complete application where you can implement the SSE.

335
00:35:54.120 --> 00:36:14.030
Mohammad Anwar: and all the webhook examples, WebSocket examples. So, quite a lot of working examples here, where you can explore how this fast API, PG Fast API, can be used to build, like, fully functional applications, where you have an asynchronous, operations.

336
00:36:14.350 --> 00:36:32.030
Mohammad Anwar: and integrate it with the database as well. If the database… database can be asynchronous as well, like what the Gabor was saying. So, you can… you can use… you can use, like, a regular database, or you can use an asynchronous, like, DB class async as well, with your web applications.

337
00:36:32.650 --> 00:36:34.430
Mohammad Anwar: That's why you can use it.

338
00:36:34.710 --> 00:36:38.579
Mohammad Anwar: And if… if you really want to… I've got this,

339
00:36:39.940 --> 00:36:43.149
Mohammad Anwar: my blog web, page, where I…

340
00:36:44.070 --> 00:36:57.510
Mohammad Anwar: gone through individual, features of FastAPI. For example, if you're interested to know how Webhook works with Pagey FastAPI, you can go through individual blog posts where I have webhook, MessageQ,

341
00:36:57.570 --> 00:37:08.879
Mohammad Anwar: API Gateway you can build with FastAPI, and then WebSocket, and also how to integrate your DBIX class async, with the Fast API, PG Fast API. So all…

342
00:37:09.290 --> 00:37:15.169
Mohammad Anwar: This… this blog post, can take you through the details, how you can

343
00:37:15.690 --> 00:37:22.719
Mohammad Anwar: and go through buildup from the scratch using the PG Fast API, these features.

344
00:37:25.120 --> 00:37:27.950
Mohammad Anwar: So, these are… these are the first API.

345
00:37:28.400 --> 00:37:32.530
Mohammad Anwar: And… you have a security where I have…

346
00:37:32.670 --> 00:37:36.590
Mohammad Anwar: these are the schemes currently. We've got API key.

347
00:37:36.820 --> 00:37:40.019
Mohammad Anwar: basics, barrier, and OAuth schemes.

348
00:37:40.920 --> 00:37:48.979
Mohammad Anwar: And again, you have working examples here where you can go through, because S… The examples are…

349
00:37:49.300 --> 00:38:01.890
Mohammad Anwar: It's a complete application, so you can go through how everything can be plugged together to give you a complete application using all these different schemes, security schemes you have.

350
00:38:03.720 --> 00:38:04.680
Mohammad Anwar: So, yeah.

351
00:38:04.880 --> 00:38:07.560
Mohammad Anwar: So that's… that's what I have so far.

352
00:38:07.850 --> 00:38:08.770
Mohammad Anwar: Thank you.

353
00:38:20.690 --> 00:38:23.400
Mohammad Anwar: So that's it for me. Any questions?

354
00:38:24.350 --> 00:38:26.050
Gabor Szabo: Then please stop sharing.

355
00:38:29.140 --> 00:38:30.010
Gabor Szabo: Okay.

356
00:38:30.430 --> 00:38:43.479
Gabor Szabo: If there are questions, please ask in the chat. There are some comments, so I can read them out in the meantime. So there was a comment that, yes, you can hook into the IO async loop.

357
00:38:43.560 --> 00:38:52.090
Gabor Szabo: But it doesn't happen automatically. You would have to use a file system module designed to work with iOSync Loop.

358
00:38:52.700 --> 00:39:09.909
Gabor Szabo: And then, this is why Mojo PG, or Mojo MySQL, and so on, were created, because most things in Perl aren't asynchronous. You have to recreate everything to become a sync, and because there isn't a single standard event loop.

359
00:39:09.910 --> 00:39:18.109
Gabor Szabo: You have to design them to work with the specific loops, for example, the IO async loop, or the module I.O. loop, and so on.

360
00:39:18.610 --> 00:39:33.189
Gabor Szabo: And then another comment here related to this, you need a loop to be a sync. When you make DB file system calls, you can create a promise, but that promise lives in the server's event loop.

361
00:39:33.550 --> 00:39:38.870
Gabor Szabo: Or should be, or should to be efficient, I think.

362
00:39:39.130 --> 00:39:42.630
Gabor Szabo: Most async modules have a loop barometer.

363
00:39:44.120 --> 00:39:45.389
Gabor Szabo: That's the comment.

364
00:39:47.030 --> 00:39:50.960
Mohammad Anwar: I think this… I think this is… Very well explained by…

365
00:39:52.160 --> 00:39:55.589
Mohammad Anwar: Yeah, Newkirk… I don't know how you call it, Newk.

366
00:39:55.590 --> 00:39:57.199
Gabor Szabo: Yeah, yeah, yeah.

367
00:39:57.200 --> 00:39:57.840
Mohammad Anwar: Yeah.

368
00:39:58.120 --> 00:40:07.219
Gabor Szabo: Yeah, we can discuss it afterwards. If there are any more comments that you would like to ask, anything else you would like to say, Mohammad, I think…

369
00:40:08.030 --> 00:40:11.950
Gabor Szabo: From my side, I really enjoyed it. I learned how to

370
00:40:12.330 --> 00:40:27.980
Gabor Szabo: I should now go and play with it. I don't know if I will have the time. I would really like to see a bunch of applications, and some people demoing how to, how to use that. Okay, someone says that ask two questions.

371
00:40:28.340 --> 00:40:30.050
Gabor Szabo: But,

372
00:40:30.940 --> 00:40:31.390
Mohammad Anwar: Yeah, dude.

373
00:40:31.390 --> 00:40:33.159
Gabor Szabo: After that, yeah, yeah, I owe them.

374
00:40:33.160 --> 00:40:37.780
Mohammad Anwar: If you really want to play with it, I would suggest

375
00:40:38.140 --> 00:40:57.390
Mohammad Anwar: to look into the examples that are… that's shipped with the distributions. They are quite… they're quite a good starting point if you want to explore how to do certain features in using Peggy FastAPI. They are, like, complete applications. Like, it's… it's a toy application, but it's complete.

376
00:40:57.390 --> 00:41:08.980
Mohammad Anwar: So you get to know exactly how to… to bring in all the features that are supported by the Pagey Fast API, and how you can plug in each other, and then you get a final, like, feature function.

377
00:41:09.020 --> 00:41:09.610
Mohammad Anwar: So, yeah.

378
00:41:09.610 --> 00:41:16.390
Gabor Szabo: I sort of meant, like, real-world application deployed, making tons of money.

379
00:41:16.650 --> 00:41:22.390
Gabor Szabo: That's what I meant. Not just examples, but that's a good start.

380
00:41:24.420 --> 00:41:29.920
Gabor Szabo: I'm just calling for all the other people who are here, so…

381
00:41:30.450 --> 00:41:39.230
Gabor Szabo: Okay, maybe I missed those questions. Next to authentication, what about authorization and audit AA? That's another question.

382
00:41:39.790 --> 00:41:45.389
Gabor Szabo: Next to authentication, what about authorization and audit?

383
00:41:46.920 --> 00:41:53.539
Mohammad Anwar: Okay, so… Is, right now, we don't do that.

384
00:41:53.750 --> 00:41:57.420
Mohammad Anwar: We're also only doing authentication, not authorization at the moment.

385
00:41:59.190 --> 00:42:07.140
Gabor Szabo: Okay, and does PAGI or PAGI FastAPI allow under, like in modularysis? There's an under…

386
00:42:07.420 --> 00:42:09.849
Gabor Szabo: I don't know, it's method or whatever, it's a feature.

387
00:42:11.180 --> 00:42:17.369
Mohammad Anwar: I've not… I've not tried it. I don't know whether it's gonna… how it's gonna behave. I have to try, see if…

388
00:42:20.540 --> 00:42:25.860
Gabor Szabo: Okay, then someone is, has a 538, and so…

389
00:42:25.860 --> 00:42:26.470
Mohammad Anwar: Yeah.

390
00:42:26.470 --> 00:42:27.400
Gabor Szabo: They can't use it.

391
00:42:27.400 --> 00:42:35.470
Mohammad Anwar: I don't know, I don't know why I picked 538, it's just because I want to try the new class syntax.

392
00:42:35.940 --> 00:42:36.690
Mohammad Anwar: I mean…

393
00:42:36.690 --> 00:42:56.630
Gabor Szabo: It shouldn't be a big issue at the end. You can use Docker if you just want to make a totally isolated version of Perl that you can get rid of easily. I have this Docker image that I use for all the things that I play with.

394
00:42:57.090 --> 00:43:03.399
Gabor Szabo: when I play with various things with Sperm, so they will be separated from my regular.

395
00:43:03.400 --> 00:43:14.249
Mohammad Anwar: If it becomes a blocker, I'll probably drop this restriction and go back to, like, a regular, like, a piled object, rather than using this new

396
00:43:14.620 --> 00:43:20.040
Mohammad Anwar: shiny Perl class syntax, if that is, like, a big issue.

397
00:43:20.300 --> 00:43:29.749
Mohammad Anwar: It's just for fun, I said, okay, why not? Because I've never used this in my… any of my distributions. So I thought, let's… let's try. So I… I started using this class.

398
00:43:31.590 --> 00:43:32.510
Gabor Szabo: Okay.

399
00:43:32.540 --> 00:43:55.939
Gabor Szabo: Well, thank you very much. I think we can finish the video recording at least now. Thank you very much for this presentation. Those people who are here in the live session, you can stay around after the session is over, after I stop the recording, then I will turn on the videos again, so you can turn on your video and your mic.

400
00:43:55.940 --> 00:44:06.669
Gabor Szabo: And then we can go and have a conversation. And those people who are watching the video, please like it and follow the channel, and below the video, you will find links to future events.

401
00:44:06.670 --> 00:44:16.310
Gabor Szabo: And also for details about this event that links and whatever, for example, to the profile of Mohammad, in case you would like to get in touch with him.

402
00:44:17.790 --> 00:44:19.019
Gabor Szabo: Thank you very much.

403
00:44:20.590 --> 00:44:31.880
Mohammad Anwar: Thank you, everybody, thank you. As I said, I was nervous when I saw so many people register, and you could tell from my presentation, I did.

404
00:44:32.000 --> 00:44:32.920
Mohammad Anwar: Pause.

405
00:44:33.140 --> 00:44:35.880
Mohammad Anwar: And I was… you can tell I was quite…

406
00:44:36.100 --> 00:44:42.510
Mohammad Anwar: having anxiety, I mean, I didn't know what I'm talking about, but… Very fair, brother.

407
00:44:42.580 --> 00:44:45.670
Gabor Szabo: It worked well. Thank you very much. Goodbye for everyone.

