---
title: "Punk: Perl MVC, compiled at boot"
timestamp: 2026-11-17T08:00:02
published: true
description: ""
archive: true
show_related: true
---

## Future events

[Code Maven live](https://live.code-maven.com/)


In this presentation we will dive into the [Punk](https://punkperl.com) ecosystem: an open source MVC web framework with first class openAPI integration, template engine, job queue, json codec, non blocking data layer and http client all built on a highly optimised event-loop web server.

## Bio:

[Robert Acock](https://www.linkedin.com/in/lnation--/) ([LNATION](https://metacpan.org/author/LNATION)) is a CPAN author with over 250 contributions. They run their own contracting company, LNATION LTD. They like to experiment with C/XS, writing Perl as fast as it can be.

## Length

1 hour

## Links

* [Markdown::Simple](https://metacpan.org/pod/Markdown::Simple)
* [Punk: Fully Authed](https://lnation.org/blog/punk-fully-authed) blog post.
* [Applications with Mojolicious – Part One: Introduction](https://oliverguenther.de/2014/04/applications-with-mojolicious-part-one-introduction/)

{% youtube id="yhuWWShsUZ4" file="2026-11-16-punk-perl-mvc-compiled-at-boot-with-Robert-Acock-LNATION.mp4" %}


## Transcript

1
00:00:02.000 --> 00:00:11.810
Gabor Szabo: So, hello and welcome to this new meeting of the Code Maven channel, and specifically, now this is going to be a Perl Maven event.

2
00:00:11.810 --> 00:00:22.650
Gabor Szabo: or per event. Welcome, everyone, who joined us here now, and especially thank you, Robert, for agreeing to give this presentation about your project.

3
00:00:25.060 --> 00:00:41.019
Gabor Szabo: And thanks everyone who is watching the YouTube video, if you're watching it. Next time, please join us. Under the video, you can find a link to where you can find the future events, and also link to various things about this specific event.

4
00:00:41.120 --> 00:00:56.440
Gabor Szabo: maybe even to the slides, you'll see, but definitely some useful links are going to be there under the video. Please don't forget to like the video, and also to follow the channel, and definitely would like to see you at

5
00:00:56.620 --> 00:00:58.860
Gabor Szabo: One of our upcoming events.

6
00:00:58.970 --> 00:01:06.090
Gabor Szabo: As I mentioned earlier, people who are here, you can ask questions in the chat, and

7
00:01:06.130 --> 00:01:23.769
Gabor Szabo: after we stop the recording after the presentation, you can also stay on, and we can keep having a chat as long as you like. That's it for now. So, Robert, thanks again to…

8
00:01:23.780 --> 00:01:27.689
Gabor Szabo: agreeing to this presentation. The stage is yours.

9
00:01:29.570 --> 00:01:37.549
Robert Acock: Okay, hi everybody. Today I'm going to talk about Punk, Model View Controller Web Framework.

10
00:01:37.790 --> 00:01:39.040
Robert Acock: for Pearl.

11
00:01:39.860 --> 00:01:47.209
Robert Acock: So my thesis is that, Perl is a good glue language for C.

12
00:01:47.550 --> 00:01:51.490
Robert Acock: And I don't believe enough people, use it that way.

13
00:01:51.910 --> 00:01:58.810
Robert Acock: You can get real performance, improvements by writing XS and C.

14
00:01:59.170 --> 00:02:01.290
Robert Acock: Within your Pearl modules.

15
00:02:02.230 --> 00:02:08.139
Robert Acock: Today I'm going to talk about, free layers,

16
00:02:08.259 --> 00:02:12.440
Robert Acock: Hyperman, which is the event loop server.

17
00:02:12.860 --> 00:02:17.450
Robert Acock: Fetch, which is the client, or the user agent.

18
00:02:17.810 --> 00:02:23.680
Robert Acock: And then Punk, which is the ModelVue, controller web framework.

19
00:02:24.190 --> 00:02:29.310
Robert Acock: Hyperman, depends on a module called Shared Arena.

20
00:02:29.580 --> 00:02:36.430
Robert Acock: This gives it a shared memory arena that allows you to do things like rate limiting.

21
00:02:36.940 --> 00:02:40.520
Robert Acock: It also… has,

22
00:02:40.710 --> 00:02:57.339
Robert Acock: Frozen, which is like a freezer of data, so it makes data read lonely, and it reads it fast. Fetch depends on a JSON decoder, another module of mine, which is, FileRaw JSON.

23
00:02:57.820 --> 00:03:05.160
Robert Acock: The reason it's that is because that provides the CABI as well, so I can do JSON passing.

24
00:03:05.460 --> 00:03:08.749
Robert Acock: From within C.

25
00:03:09.280 --> 00:03:15.320
Robert Acock: Punk depends on both, and then 12 other, distributions.

26
00:03:15.990 --> 00:03:22.510
Robert Acock: So, we're gonna talk about Hyperman first, which is the server.

27
00:03:22.970 --> 00:03:26.670
Robert Acock: Or, actually, let's talk about the prequel.

28
00:03:26.940 --> 00:03:31.839
Robert Acock: Which was a module called Hypersonic that I shipped in January.

29
00:03:32.310 --> 00:03:43.680
Robert Acock: This was very experimental. In the synopsis, it says, blazing fast HTTV server with a just-in-time compiled C event loop.

30
00:03:43.940 --> 00:03:49.879
Robert Acock: The distribution actually had no access files, no C code in C.

31
00:03:49.990 --> 00:03:52.100
Robert Acock: It's all in pearl.

32
00:03:52.260 --> 00:03:58.019
Robert Acock: And it compiles, compile, subroutine.

33
00:03:58.130 --> 00:04:08.259
Robert Acock: And then that compiles a bunch of strings in Perl into a C file, opens it and runs it, for the result.

34
00:04:08.430 --> 00:04:14.669
Robert Acock: It's built on, as I say, XSJIT, which is another module of mine.

35
00:04:14.990 --> 00:04:34.379
Robert Acock: It's an alternative to inline C, but it invokes the compiler directly, so it's a bit different. Hypersonic is fast, it's really fast, it's faster than Hyperman. It does about 260,000 requests a second.

36
00:04:34.530 --> 00:04:41.010
Robert Acock: On my computer, but that's doing just a, a cached…

37
00:04:41.170 --> 00:04:50.439
Robert Acock: HTML string, let's say, and the way it does that is it's a poll… you define the string from a… you return a string from a poll function.

38
00:04:50.550 --> 00:04:55.880
Robert Acock: But it actually, at compile time, it writes that as a C constant in the file.

39
00:04:56.340 --> 00:05:08.409
Robert Acock: So you… it's basically reading… when the request comes in, the request handler is just reading a C constant and returning it. That's how it gets so fast,

40
00:05:08.520 --> 00:05:15.410
Robert Acock: But, as I say, it's flawed, though. It's fast, but it is flawed.

41
00:05:15.470 --> 00:05:34.689
Robert Acock: It's unpredictable in the sense that every time, you run or you start up, that's when the C code's compiled for the first time. So if you move your code into production, and you run for the first time, that's when it's compiled.

42
00:05:34.790 --> 00:05:44.259
Robert Acock: And that's when the C goes. And every request afterwards uses the C, but the first request is the one that builds. And based on your environment.

43
00:05:44.440 --> 00:05:48.940
Robert Acock: It can differ, so there's many…

44
00:05:49.040 --> 00:05:54.469
Robert Acock: Because it's just in time, it's compiled based on the environment variables, based on what's available.

45
00:05:54.600 --> 00:05:57.189
Robert Acock: Like, to it.

46
00:05:57.490 --> 00:06:00.700
Robert Acock: It will, it's…

47
00:06:00.980 --> 00:06:13.139
Robert Acock: it will always compile slightly differently, or it can compile slightly differently in different environments. It requires GCC, OpenSSL, NGHTV, all at runtime.

48
00:06:13.460 --> 00:06:16.359
Robert Acock: And as I say, deploying MIPS has become a gamble.

49
00:06:16.540 --> 00:06:22.820
Robert Acock: Testing is a real headache, because there's many variants from the same code that can be outputted.

50
00:06:23.970 --> 00:06:26.899
Robert Acock: Hmm… But I took that.

51
00:06:27.180 --> 00:06:35.719
Robert Acock: And then I built something called Hyperman, which is a pre-forking event loop PSGI server.

52
00:06:35.860 --> 00:06:45.219
Robert Acock: A supervisor forks a pool of workers. Each worker runs one single-threaded event loop written in C.

53
00:06:45.410 --> 00:06:50.979
Robert Acock: it accepts passes HDQ equals, your plaque app.

54
00:06:51.040 --> 00:07:08.919
Robert Acock: writes the response, none of it blocks, so one worker can juggle thousands of connections. You can run it using PlaqueUp against any Plaque application, including things like Catalyst and even Mojalicious. The latest version

55
00:07:09.230 --> 00:07:20.829
Robert Acock: which I released this morning is, I think, 0.70, and that has 100% test coverage using another module of mine, which is, Devil Access Cover.

56
00:07:20.980 --> 00:07:26.899
Robert Acock: That includes branch coverage using GCove on GCC14.

57
00:07:27.080 --> 00:07:35.069
Robert Acock: So I'm hoping the Burke Emmanuel, reported at the beginning is fixed, but I will confirm, later.

58
00:07:37.040 --> 00:07:45.520
Robert Acock: So, moving on from that, it has many backends, so it has many event loops that can be configured based on your environment.

59
00:07:45.520 --> 00:07:57.890
Robert Acock: So, KQ, for example, is only available on BST and Mac. I.O. Uri is, Linux. EPOL is Linux. Poll is a portable fullback on all of them.

60
00:07:57.980 --> 00:08:02.080
Robert Acock: And then, Windows has its own pole as well.

61
00:08:02.200 --> 00:08:10.440
Robert Acock: It's chosen in that order, so it will fall back to whichever one is available, but you can force one by setting the hyperman

62
00:08:10.780 --> 00:08:12.809
Robert Acock: Back-end end variable.

63
00:08:13.280 --> 00:08:21.199
Robert Acock: So the entire server looks something like this, and if you've ever written a plaque or PSGI,

64
00:08:21.210 --> 00:08:28.649
Robert Acock: server, service. You've probably understood that it's just a code reference.

65
00:08:28.650 --> 00:08:46.040
Robert Acock: and then an array ref with free values, the status, the headers, and then the response. And that compiles under hyperman as… as… like so, so you can go Hyperman, run, and then pass it to the app, the port, and the number of workers.

66
00:08:46.390 --> 00:08:52.740
Robert Acock: That you'd like to run. You can also do async, we've…

67
00:08:53.200 --> 00:09:00.369
Robert Acock: Hyperman, which you can't, really do with Plaque itself, it's an extension of.

68
00:09:00.500 --> 00:09:02.909
Robert Acock: The plaque standard, let's say.

69
00:09:03.840 --> 00:09:13.860
Robert Acock: And, what you can do is return, Hyperman Futures, from, a response, and there's some helper methods inside of Punk.

70
00:09:14.320 --> 00:09:17.360
Robert Acock: But from, just a Hyperman script.

71
00:09:17.550 --> 00:09:24.130
Robert Acock: You can say Hyperman timer returning 0.5 seconds,

72
00:09:24.300 --> 00:09:36.010
Robert Acock: then… then do the response. So, wait for 0.5 seconds to do the response, and it's any future, you can return from, your, plaque, subcode reference.

73
00:09:36.690 --> 00:09:39.309
Robert Acock: You can have multiple listeners.

74
00:09:39.690 --> 00:09:47.590
Robert Acock: On your server. So, for example, you combined port 80 and 443 to the same instance.

75
00:09:47.930 --> 00:09:51.699
Robert Acock: But in this case, we're redirecting, so we're saying.

76
00:09:51.860 --> 00:10:01.249
Robert Acock: When we receive traffic on port 80, redirect to 443 for SSL, TLAS, protection.

77
00:10:01.410 --> 00:10:17.219
Robert Acock: And then, we support the following protocols inside of HyperMan, so HTTP1, 2, and 3. One is, pretty much vanilla inside of C.

78
00:10:17.360 --> 00:10:27.899
Robert Acock: 2 and 3 use NGHTTP2 and NGTHCCP3. Openssl 3.5 is required.

79
00:10:28.010 --> 00:10:31.919
Robert Acock: For HTTP3 for some encryption.

80
00:10:32.220 --> 00:10:43.829
Robert Acock: For TLS, we use OpenSSL or Lib… LibreSL, kernel TLS,

81
00:10:43.970 --> 00:10:48.499
Robert Acock: Again, when it's available from OpenSSL.

82
00:10:48.930 --> 00:10:53.120
Robert Acock: There's WebSaw… WebSocket, support.

83
00:10:53.520 --> 00:11:02.590
Robert Acock: And there's also recently added trailers, on requests, so that you can do GRPC, correctly.

84
00:11:02.970 --> 00:11:15.209
Robert Acock: every one of these compiles out cleanly. If you don't have OpenSSL installed in your environment, it won't build, the Hyperman.

85
00:11:15.320 --> 00:11:17.699
Robert Acock: Enable error.

86
00:11:17.920 --> 00:11:21.800
Robert Acock: For you, if you try to start one with SSL.

87
00:11:21.930 --> 00:11:28.670
Robert Acock: And, plain HTTP will always remain working.

88
00:11:29.070 --> 00:11:35.359
Robert Acock: So, things you might need at 3am in the morning.

89
00:11:35.540 --> 00:11:40.600
Robert Acock: The workers respawn, with a crash loop back off.

90
00:11:40.940 --> 00:11:59.039
Robert Acock: Sigup, has zero downtime, recycles, and a graceful term drain. Idle header and slow requests do time out. It has rate limits, that uses the shared memory arena.

91
00:11:59.210 --> 00:12:08.989
Robert Acock: An IP deny list. Across work and message bus, so you can send, publish, and subscribe events.

92
00:12:09.360 --> 00:12:27.019
Robert Acock: Access to logging, all the logging is C, so when you log your access log, it's all written in C, it's not written by Perl. And, an upload costs less than the upload amount, not more, based on how it's streamed.

93
00:12:27.420 --> 00:12:30.849
Robert Acock: How the file's streamed and data's streamed through.

94
00:12:31.350 --> 00:12:38.030
Robert Acock: And the things, ops might ask for.

95
00:12:38.220 --> 00:12:49.109
Robert Acock: So the privileges, dropped after you've bind… bound the socket, so the user's the correct user.

96
00:12:49.240 --> 00:12:51.320
Robert Acock: That you pass into Hyperman.

97
00:12:51.950 --> 00:12:56.050
Robert Acock: A fresh compile adopts the sockets.

98
00:12:56.630 --> 00:13:08.579
Robert Acock: The Unix domain listeners and listen, FDS sockets activation. There's proxy support, for version 1 and version 2.

99
00:13:08.700 --> 00:13:18.290
Robert Acock: to do anything that was important. As I say, the access format Apache, logs to JSON, or…

100
00:13:18.560 --> 00:13:21.250
Robert Acock: plain Apache, format.

101
00:13:21.510 --> 00:13:28.620
Robert Acock: Error logs, body timeout, timed by progress, request line grammar.

102
00:13:29.210 --> 00:13:36.380
Robert Acock: So in production, you might start your Hyperman service, something like this.

103
00:13:36.510 --> 00:13:44.559
Robert Acock: Where you pass your app, you can say, workers 0, which will,

104
00:13:44.900 --> 00:13:52.330
Robert Acock: understand how many CPUs are available on the server, and then start one worker per CPU that's there.

105
00:13:52.770 --> 00:14:03.000
Robert Acock: your timeout on, requests, your deny lists, as I say, the user, because maybe when you're put…

106
00:14:03.000 --> 00:14:17.209
Robert Acock: when you, start, you might need to start as root, for example, if you're binding to port 80 and 443, but you won't want to keep the user as root, so you can drop it into that user, so change it to www.

107
00:14:17.580 --> 00:14:21.750
Robert Acock: And… yes,

108
00:14:22.210 --> 00:14:30.309
Robert Acock: proxy, as I say, you can turn on the proxy protocol, and you can change the log format by just access log format.

109
00:14:30.910 --> 00:14:36.220
Robert Acock: So, against… Starman.

110
00:14:36.480 --> 00:14:42.340
Robert Acock: Per worker, so Starman does 27,000 requests a second.

111
00:14:42.590 --> 00:14:52.489
Robert Acock: a Hyperman under PlaqueUp and its native are about equal these days. So 206,000 requests per second.

112
00:14:52.590 --> 00:14:57.300
Robert Acock: You can see, like, that's a huge improvement on… Starman.

113
00:14:57.450 --> 00:14:58.999
Robert Acock: As a, as a server.

114
00:14:59.480 --> 00:15:04.449
Robert Acock: Is there any questions before I move on to Fetch?

115
00:15:09.950 --> 00:15:17.479
Robert Acock: Silence, I take as no, so let's move on. Fetch is the client, and it needed to exist.

116
00:15:17.710 --> 00:15:23.119
Robert Acock: Because when you have a server that answers 200,000 requests a second.

117
00:15:23.230 --> 00:15:29.269
Robert Acock: it's only interesting if you can prove it, and unfortunately, I couldn't quite prove 200,000.

118
00:15:29.370 --> 00:15:33.270
Robert Acock: But… I'll explain shortly.

119
00:15:33.540 --> 00:15:41.890
Robert Acock: So most, most, Perl clients are blocking. So, for example, HTTP Tiny or Perl.

120
00:15:42.150 --> 00:15:57.460
Robert Acock: They'll do requests at around 18,000, 26,000, so at the time, the server I was testing did 186,000 requests a second via WRK, or work, as I always call it. But…

121
00:15:57.540 --> 00:16:07.749
Robert Acock: running from Pearl, you have a bottleneck, with sockets opening, and it being, synchronous, not asynchronous.

122
00:16:08.370 --> 00:16:21.070
Robert Acock: So fetch, socket, TLS, Quick, HTTP3, HTTP2, Framing, HTTP 1.1 passing, all in C.

123
00:16:21.440 --> 00:16:31.320
Robert Acock: every call returns a fetch future, so it's always synchronous. Get awaits it by pumping whichever loop is there and available.

124
00:16:32.290 --> 00:16:36.939
Robert Acock: It ships its own loops, well, its own loop.

125
00:16:37.090 --> 00:16:40.189
Robert Acock: So you don't need to have anything else installed.

126
00:16:40.360 --> 00:16:45.089
Robert Acock: But when you do have IO Async, any event, or even HyperMan.

127
00:16:45.440 --> 00:16:50.250
Robert Acock: You can plug it into Fetch, so it uses that loop.

128
00:16:50.730 --> 00:16:59.049
Robert Acock: And it has trailers now, so it does GRPC, that was new recently.

129
00:16:59.230 --> 00:17:06.809
Robert Acock: And it's only, dependency, as I say, is, file raw JSON.

130
00:17:07.140 --> 00:17:10.090
Robert Acock: Hype van, it is optional to it.

131
00:17:11.650 --> 00:17:21.780
Robert Acock: So the way you make calls is you use fetch, fetch new, get, and then get again to wait for the result.

132
00:17:21.990 --> 00:17:32.909
Robert Acock: You can use any, async or wait as well, if you prefer to say or wait, in front of the get instead of using the get.

133
00:17:33.170 --> 00:17:38.070
Robert Acock: And then it prints content if the response was successful.

134
00:17:38.620 --> 00:17:52.160
Robert Acock: You can make many requests concurrently using, Fetch future, and then it just returns all, and then waits until all are available, via the GET function.

135
00:17:52.660 --> 00:17:58.379
Robert Acock: And it also has WebSocket support,

136
00:17:59.500 --> 00:18:08.449
Robert Acock: As you can see, it's just connecting to the WebSocket, and then you can send messages and receive the next message on the queue, if there is one.

137
00:18:10.670 --> 00:18:21.300
Robert Acock: there is Fetch Loop Hyperman, which is a module that assists in linking in the Hyperloop, Hyperman Loop.

138
00:18:21.720 --> 00:18:24.840
Robert Acock: This is useful,

139
00:18:25.010 --> 00:18:33.600
Robert Acock: Because you can then, pump your events through the server's loop as well.

140
00:18:34.020 --> 00:18:40.190
Robert Acock: So, as it says, so a Hyperman worker can make concurrent outbound

141
00:18:40.480 --> 00:18:44.259
Robert Acock: Calls on the same loop as the serving inbound connections.

142
00:18:44.410 --> 00:18:48.809
Robert Acock: It has one process, one core, no threads.

143
00:18:48.990 --> 00:18:53.969
Robert Acock: A handler waiting on an upstream costs no capacity.

144
00:18:56.080 --> 00:19:04.619
Robert Acock: concurrent from one Pearl process. So if you were to do it in a blocking manner, it's 42,000,

145
00:19:04.780 --> 00:19:08.550
Robert Acock: Requests a second, so it's certainly increased unfurl.

146
00:19:08.750 --> 00:19:18.840
Robert Acock: But if you, make it non-blocking, as the previous example showed, using futures, you can,

147
00:19:19.080 --> 00:19:22.789
Robert Acock: Attain 153,000 requests a second.

148
00:19:23.180 --> 00:19:37.090
Robert Acock: This isn't 200,000 requests, and the reason why it struggles to match, work is because I am doing more, I am passing the headers, the body, the cookies.

149
00:19:37.150 --> 00:19:45.420
Robert Acock: It just does more, whereas work just prints, time and dumps all the data out. Doesn't actually pass anything.

150
00:19:46.000 --> 00:19:51.470
Robert Acock: So, we then move on to punk.

151
00:19:51.740 --> 00:19:54.980
Robert Acock: Again, do we have any questions before I move on?

152
00:19:54.980 --> 00:19:56.880
dragos trif: I have some.

153
00:19:57.280 --> 00:20:07.579
dragos trif: Do you have any way of setting the concurrency rules when you are doing the asynchronous requests, like…

154
00:20:07.930 --> 00:20:15.580
dragos trif: exit when one of the promises finishes, or wait for all to finish.

155
00:20:15.810 --> 00:20:18.890
dragos trif: Before you exit, things like that.

156
00:20:19.510 --> 00:20:34.780
Robert Acock: Yeah, so you use the Hyperman future, and then you can call all, and that will loop over the array of futures that you have, and only return true when all of them have, settled.

157
00:20:36.020 --> 00:20:42.189
Robert Acock: You can do one, and there's a bunch of other functions within, Hyperman Future.

158
00:20:43.370 --> 00:20:45.180
Robert Acock: Or fetch future, sorry.

159
00:20:45.340 --> 00:20:45.950
dragos trif: Thanks.

160
00:20:48.870 --> 00:20:58.900
Robert Acock: So… Punk is the MPC Pro framework, that was built afterwards,

161
00:20:59.930 --> 00:21:03.990
Robert Acock: And, I had the server.

162
00:21:04.200 --> 00:21:08.530
Robert Acock: I had the user agent, so I was like, let's make a framework on top of

163
00:21:08.970 --> 00:21:11.479
Robert Acock: All of this on the server as well.

164
00:21:11.650 --> 00:21:20.649
Robert Acock: It's not my first, framework. I've written something called TERS, which is… was in production at one point in time, doing…

165
00:21:20.870 --> 00:21:33.349
Robert Acock: Something very important in the world. I don't know whether it still exists in that production environment, but Terse was my first, framework that I wrote. So this is my second attempt, which is punk.

166
00:21:33.590 --> 00:21:39.830
Robert Acock: So, everything's, now,

167
00:21:42.040 --> 00:21:57.759
Robert Acock: Everything is resolved once. So, the routes, the guards, the handlers, and the mounts. They're all resolved at 2 app, and then they're frozen. Nothing is interpreted at, the request time.

168
00:21:58.190 --> 00:22:02.230
Robert Acock: So you can't add routes once the server's started.

169
00:22:02.350 --> 00:22:04.959
Robert Acock: Cause it's sealed and frozen.

170
00:22:05.440 --> 00:22:09.779
Robert Acock: You would have to restart the app, basically.

171
00:22:10.160 --> 00:22:15.569
Robert Acock: So an application looks something like this, so you go package my app.

172
00:22:15.900 --> 00:22:22.439
Robert Acock: use punk, and then you define a GET request for your route.

173
00:22:22.590 --> 00:22:26.669
Robert Acock: And then you link it to a controller, which is WebBook.

174
00:22:26.810 --> 00:22:34.240
Robert Acock: home, so this controller would actually be my app, controller web book.

175
00:22:34.850 --> 00:22:40.000
Robert Acock: And, then there's a request with an ID parameter.

176
00:22:40.270 --> 00:22:46.439
Robert Acock: capture, let's call it. And then there's a post request to create a book.

177
00:22:46.750 --> 00:22:49.569
Robert Acock: There's also under.

178
00:22:50.140 --> 00:22:55.909
Robert Acock: Which is for access control,

179
00:22:56.110 --> 00:23:04.679
Robert Acock: So it, well, it adds a subroutine that allows you to validate the request.

180
00:23:04.810 --> 00:23:11.860
Robert Acock: in this case, saying, if there's no authorization, then you redirect to route. It allows you to chain.

181
00:23:12.090 --> 00:23:16.679
Robert Acock: It's in Mojolicious, I can't remember the term I'm looking for.

182
00:23:16.870 --> 00:23:36.459
Robert Acock: But it's in Mode Relicious, and you call under, it creates the route, admin, and then the scope of admin, sorry, and then you can go admin get books, so the books endpoint has to run through the scope of the under, subroot code reference.

183
00:23:36.510 --> 00:23:50.329
Robert Acock: And, then it calls the controller, which is webbook adminList function. You can mount a static directory, that's for your assets, so your CSS, your JS,

184
00:23:50.990 --> 00:23:52.510
Robert Acock: And,

185
00:23:54.360 --> 00:24:09.549
Robert Acock: So yeah, so what 2App actually does, so it takes the controller endpoint, and that becomes a literal code ref under the scopes flatten, their guard chains into every route up beneath.

186
00:24:10.160 --> 00:24:15.930
Robert Acock: The few engines, the model classes, and the database handles are built

187
00:24:16.140 --> 00:24:23.050
Robert Acock: Open API documents are passed, the security schemas become guards.

188
00:24:23.150 --> 00:24:32.299
Robert Acock: Markdown sites are rendered, templates are compiled, the route validators are compiled, also,

189
00:24:32.400 --> 00:24:51.239
Robert Acock: JSON schema. So there's… there's a validate, that you define into Perl. It's… I think I've got a slide, I'll get there in a moment. Then it… then it is frozen, as I say. The closure's returned, and this is the only code on the request path.

190
00:24:52.790 --> 00:25:03.229
Robert Acock: So a typo, I hope, is a boot failure, not a 500 next Tuesday, when someone finally hits, that route.

191
00:25:03.640 --> 00:25:06.570
Robert Acock: The request path…

192
00:25:07.270 --> 00:25:16.180
Robert Acock: The proxy, re… when you have proxy set, it rewrites, the remote address field, header.

193
00:25:16.360 --> 00:25:23.460
Robert Acock: The cores, pre-flight and headers, outside the hook chain, so 404 gets them.

194
00:25:23.700 --> 00:25:36.800
Robert Acock: The CABI on request observers, so Punk, exposes a CABI for a bunch of functionalities, so you can extend it, in C, within XS modules.

195
00:25:37.020 --> 00:25:39.940
Robert Acock: The before request hook…

196
00:25:40.600 --> 00:25:53.530
Robert Acock: That's the only thing that certain things get, so it's… but it happens early, it allows you, it… basically, like, the 404 and the mount paths are…

197
00:25:53.630 --> 00:26:00.339
Robert Acock: Compiled, early in the, in, in the request chain.

198
00:26:00.560 --> 00:26:14.500
Robert Acock: So the before dispatch, method doesn't… they don't get called for them, so there needs to be, right at the beginning of the request, a callback hook, and that's, before request.

199
00:26:14.720 --> 00:26:19.659
Robert Acock: The route match, as I say, is a compiled hash lookup.

200
00:26:20.040 --> 00:26:24.590
Robert Acock: When there's, captures.

201
00:26:24.950 --> 00:26:32.790
Robert Acock: It's a small typed segment walk. The max body is all calculated in C.

202
00:26:32.990 --> 00:26:48.660
Robert Acock: There's a before dispatch hook that happens after the before request hook, before the actual dispatch to the controller endpoint. Guard chains, that's the… the guard is the word I was looking for with under.

203
00:26:48.900 --> 00:27:04.249
Robert Acock: route validation, that you can define, as I, types, for your routes, and validate the parameters, and that gets compiled into a JSON schema.

204
00:27:04.480 --> 00:27:13.139
Robert Acock: And, the handler is… When you compile, so when you,

205
00:27:13.970 --> 00:27:20.249
Robert Acock: Do my app, run, let's say, or new.

206
00:27:20.380 --> 00:27:25.880
Robert Acock: it compiles to the PSGI code reference that returns array references.

207
00:27:27.070 --> 00:27:33.390
Robert Acock: The response coercion hooks are in C after dispatch, right after response, they're all in C.

208
00:27:33.780 --> 00:27:40.720
Robert Acock: For routing, we have GET, POST, PUT, PATCH, Dell, any.

209
00:27:40.900 --> 00:27:45.560
Robert Acock: They're all… they all can be used, all those HTTP verbs.

210
00:27:46.120 --> 00:27:48.529
Robert Acock: We have named routes.

211
00:27:48.710 --> 00:27:56.100
Robert Acock: So you can… Say, get book's ID, so capture the ID,

212
00:27:56.260 --> 00:28:07.279
Robert Acock: And then say the name is book, and then from within the code, you can say, see URL for book, pass the ID, and that will generate the URL for that route.

213
00:28:07.670 --> 00:28:13.900
Robert Acock: Under nestable guard scopes, flattened at, compile time.

214
00:28:14.120 --> 00:28:17.960
Robert Acock: You can mount within Punk any other PSGI app.

215
00:28:18.160 --> 00:28:20.130
Robert Acock: Under a prefix.

216
00:28:21.350 --> 00:28:24.449
Robert Acock: And you can mount a Markdown directory as well.

217
00:28:24.680 --> 00:28:37.949
Robert Acock: Head falls back to get, trailing slashes are retried, so if you do books ID slash, and there's no end point for that, it will fall back to books, ID.

218
00:28:39.250 --> 00:28:51.890
Robert Acock: A controller looks something like this. As I say, my app controller web book, this is the list. This is calling the model book, and we'll get to the model in the next slide.

219
00:28:51.890 --> 00:29:00.269
Robert Acock: And it's just called in search on it, and then it returns a template where… which is called book list, and passes the book…

220
00:29:00.470 --> 00:29:02.010
Robert Acock: Rose to it.

221
00:29:02.810 --> 00:29:11.539
Robert Acock: The model… looks something like this. And this is for a database model.

222
00:29:11.680 --> 00:29:17.240
Robert Acock: And we define which table in the database and a list of fields.

223
00:29:17.540 --> 00:29:32.800
Robert Acock: And then inside the controller, you get a bunch of… it's… the CRUD functions, basically. It's kind of a lightweight DBIX class, but you can add sub, and then you have access to the, DBI,

224
00:29:33.650 --> 00:29:38.260
Robert Acock: DBIX did loop object, if you require one.

225
00:29:38.710 --> 00:29:47.890
Robert Acock: As I say, you can… DBIX Loop gives you, non-blocking, DBI calls.

226
00:29:48.380 --> 00:29:58.269
Robert Acock: So you can use the model, but you can also call DBI directly in a kind of non-blocking way.

227
00:29:58.530 --> 00:30:10.570
Robert Acock: a model that is not a database, you can use… you can handcraft your own, or you can use something I've created, which is called Model Computed.

228
00:30:10.820 --> 00:30:19.599
Robert Acock: And then you say… oh, sorry, I need to go backwards. You can say answers.

229
00:30:20.060 --> 00:30:30.449
Robert Acock: zones. Zones, is, the… the table name.

230
00:30:30.980 --> 00:30:43.579
Robert Acock: And then you can define, a bunch of functions, so you can do get zones, search zones, and then from within your controller, it works the same way as the other models.

231
00:30:43.750 --> 00:30:49.950
Robert Acock: You can define, custom backends when you say you… database is a key word.

232
00:30:50.060 --> 00:30:58.939
Robert Acock: And you can define custom backends, by passing the backend, and then which… this is the clock, for example.

233
00:31:02.200 --> 00:31:17.950
Robert Acock: Few request response, Fuse, template stencil by default. Template Stencil is another module of mine, and it's a very fast templating engine.

234
00:31:18.200 --> 00:31:24.370
Robert Acock: It has syntax, like this.

235
00:31:25.020 --> 00:31:33.219
Robert Acock: There is a context object, which has many functions on it.

236
00:31:33.440 --> 00:31:48.869
Robert Acock: So, CREC, is the request, and then on the request, you can have the body, the JSON of, the request, the XML of the request, the…

237
00:31:49.020 --> 00:31:59.290
Robert Acock: Params, the upload, the address, the header, the body to a body each for bodies that are too big to hold,

238
00:31:59.560 --> 00:32:10.199
Robert Acock: And XML refuses a doc type, so, XSE and BillionLaugh vulnerabilities aren't, are unreachable.

239
00:32:10.480 --> 00:32:22.019
Robert Acock: There's a C render to render, your templates, and it can render, fragments of HTML, JSON XML, text, HTML.

240
00:32:22.250 --> 00:32:25.130
Robert Acock: And, redirects.

241
00:32:25.510 --> 00:32:34.769
Robert Acock: There's response to… And send file, amongst other things.

242
00:32:35.600 --> 00:32:44.780
Robert Acock: Sessions and cookies, so, there's a HMAC Shard 256 signed cookie.

243
00:32:44.940 --> 00:32:49.289
Robert Acock: The default is punk.syd, S-I-D.

244
00:32:49.600 --> 00:32:56.420
Robert Acock: You can set a cache, a store, as your cache.

245
00:32:56.690 --> 00:33:07.219
Robert Acock: And then, your session cookie is only an ID, it's not the full data, so,

246
00:33:07.830 --> 00:33:14.479
Robert Acock: It comes back, and it retrieves the actual data of your session instead of storing it in the cookie.

247
00:33:14.750 --> 00:33:22.920
Robert Acock: There's Flush, FlashShoi, so you can send messages across requests.

248
00:33:23.120 --> 00:33:31.340
Robert Acock: Session rotate, to rotate the session, log in, this is when you're using the auth models.

249
00:33:31.710 --> 00:33:35.199
Robert Acock: There's a cookie function to set cookies.

250
00:33:37.400 --> 00:33:52.569
Robert Acock: And, there is secrets, so you can… the secret function here is, is, look, it will generate, based on, some configuration, the session key.

251
00:33:52.850 --> 00:33:56.950
Robert Acock: It doesn't store the plain session key in,

252
00:33:57.950 --> 00:34:01.700
Robert Acock: memory. It will… it's configurable.

253
00:34:01.880 --> 00:34:03.720
Robert Acock: On different backends.

254
00:34:06.270 --> 00:34:19.740
Robert Acock: security, mostly by construction, so you have built-in CSRF support, single-use tokens over the session. There's cause protection.

255
00:34:20.040 --> 00:34:37.399
Robert Acock: Headers, so set if absent security headers, per scope, overrides, and then this is an example of setting, the host name of your application, which is useful for some plugins, like, the sitemap.

256
00:34:37.760 --> 00:34:41.249
Robert Acock: And there's a proxy keyword as well.

257
00:34:41.400 --> 00:34:46.180
Robert Acock: And this… you'd want this, if, for example, you…

258
00:34:46.300 --> 00:34:57.490
Robert Acock: put, your punk applica- your Hyperman and Punk application behind something like, Apache, or Nginx, or something like that.

259
00:34:58.040 --> 00:35:09.719
Robert Acock: So… ORF and guards that never enter Pearl. So there is an auth keyword, and then you can supply a model.

260
00:35:09.800 --> 00:35:20.630
Robert Acock: If… And the default user model is, built-in, I believe, and,

261
00:35:21.230 --> 00:35:26.480
Robert Acock: it, gives you a bunch of functionality that is written in C already.

262
00:35:27.110 --> 00:35:30.230
Robert Acock: So it's fast, so log in, log out, for example.

263
00:35:32.070 --> 00:35:40.940
Robert Acock: There's off-guards as well, as you've seen before, and then you can say, does this use… this current user.

264
00:35:41.180 --> 00:35:45.330
Robert Acock: Have admin permission.

265
00:35:46.010 --> 00:35:52.450
Robert Acock: Based on… There's a schema that gets generated for the user.

266
00:35:53.190 --> 00:36:07.100
Robert Acock: Rate limiting, that actually counts, so there's a rate limit keyword, and you can pass it limit, and say, 100 requests in a window of, 60 seconds.

267
00:36:07.280 --> 00:36:11.159
Robert Acock: This is on Hyperman's Shared Arena.

268
00:36:11.420 --> 00:36:16.490
Robert Acock: So, it's across the pool.

269
00:36:16.680 --> 00:36:23.590
Robert Acock: So if you have 4 workers, it's across all 4 workers. It's not across one,

270
00:36:23.790 --> 00:36:26.069
Robert Acock: It's not only for that one worker.

271
00:36:26.600 --> 00:36:29.259
Robert Acock: Which is a flaw in some frameworks.

272
00:36:29.710 --> 00:36:37.430
Robert Acock: So… there's a 429 with the trif rate limit also available per…

273
00:36:37.900 --> 00:36:41.130
Robert Acock: option, there's a block IP.

274
00:36:41.630 --> 00:36:45.050
Robert Acock: And yeah, that will croak.

275
00:36:45.750 --> 00:36:54.399
Robert Acock: So there is also WebSocket support with inside of Punk, and you would define inside of app

276
00:36:54.870 --> 00:37:04.159
Robert Acock: your WebSocket to chat into the controller, and inside the controller, you're given a WebSocket object.

277
00:37:04.570 --> 00:37:10.469
Robert Acock: And, you can say on open, on message, and their event handles.

278
00:37:10.840 --> 00:37:20.549
Robert Acock: Websocket Room, is just a helper, to create rooms that you can broadcast to and join.

279
00:37:21.120 --> 00:37:27.200
Robert Acock: There is also server-side events, so SSE.

280
00:37:27.620 --> 00:37:32.430
Robert Acock: And this is when,

281
00:37:32.940 --> 00:37:44.969
Robert Acock: in JavaScript, let's say, or even another server, I guess, connects to your endpoint and waits for you to publish

282
00:37:45.210 --> 00:37:48.390
Robert Acock: Responses to it, and it will receive them.

283
00:37:49.090 --> 00:37:57.080
Robert Acock: And so, yes, so there is server-side sent events. Async…

284
00:37:57.820 --> 00:38:06.209
Robert Acock: Talking between workers, so there's a promise, function on context that you can pass a sub to, and…

285
00:38:06.310 --> 00:38:18.899
Robert Acock: You can end your, controller endpoint with Cpromise, with the sub, and then that returns, a punk future, which settles as expected.

286
00:38:19.100 --> 00:38:22.950
Robert Acock: There's timer after, or wait,

287
00:38:23.520 --> 00:38:41.140
Robert Acock: Handler may return any then on ready or get object, punk awaits it, as I've just said. Lexical asynchronous sub and await for apps, controllers, and models. So you can, subscribe and publish to a cache.

288
00:38:41.440 --> 00:38:44.920
Robert Acock: Let's say…

289
00:38:45.450 --> 00:38:54.169
Robert Acock: And then there is after response, for, like, audit rows, cache warms, off the response path.

290
00:38:55.670 --> 00:39:10.630
Robert Acock: Cache and static file uploads, so there is a cache keyword, it has a file and a memory backend. It doesn't have a database or, like, a Redis backend at the moment.

291
00:39:11.100 --> 00:39:16.739
Robert Acock: But a lot of the time, you want to cache things, because it makes…

292
00:39:16.990 --> 00:39:20.120
Robert Acock: Requests and responses faster.

293
00:39:20.400 --> 00:39:25.019
Robert Acock: Static keywords to mount static files.

294
00:39:25.590 --> 00:39:31.809
Robert Acock: There's an asset, function that will return,

295
00:39:32.000 --> 00:39:35.500
Robert Acock: It will return the asset, but it will… it will,

296
00:39:35.870 --> 00:39:40.740
Robert Acock: add, I don't know the word, but, like, a hex string.

297
00:39:40.860 --> 00:39:45.369
Robert Acock: Of the file, so it can be cached.

298
00:39:46.390 --> 00:39:51.350
Robert Acock: And upload spill to a temp file, when they arrive, not after.

299
00:39:52.390 --> 00:40:00.239
Robert Acock: So it's spec first, and we say that with the API, open API mount.

300
00:40:00.500 --> 00:40:04.720
Robert Acock: So it's very much open API friendly.

301
00:40:05.140 --> 00:40:08.730
Robert Acock: It allows us to,

302
00:40:09.280 --> 00:40:15.370
Robert Acock: let the spec describe the API, and the code implements it.

303
00:40:15.540 --> 00:40:25.259
Robert Acock: And they can drift sometimes, but with Punk, there's some useful features that help you, overcome that.

304
00:40:25.970 --> 00:40:38.049
Robert Acock: So, from Punk, you can mount, an open API document, with one line, API, and then the file.

305
00:40:38.230 --> 00:40:40.190
Robert Acock: Or path… the path to the file.

306
00:40:40.630 --> 00:40:48.260
Robert Acock: And then that's taking, the operation ID as the controller method.

307
00:40:48.950 --> 00:40:59.470
Robert Acock: So it will take… The getPet, for example, would… would be, the method, and…

308
00:41:00.050 --> 00:41:04.619
Robert Acock: With inside of there, inside of your controller, then you have…

309
00:41:04.820 --> 00:41:08.739
Robert Acock: a get pet, and that's your subroutine.

310
00:41:09.800 --> 00:41:14.920
Robert Acock: It has security schemas, and they become guards.

311
00:41:15.430 --> 00:41:18.239
Robert Acock: So, like, under, let's say.

312
00:41:18.670 --> 00:41:23.360
Robert Acock: And this one, for example, is just saying,

313
00:41:23.910 --> 00:41:26.849
Robert Acock: There needs to be a key…

314
00:41:27.770 --> 00:41:31.219
Robert Acock: Like, basic orph, Baraki.

315
00:41:31.560 --> 00:41:38.979
Robert Acock: And, if there is not one, return an error, sort of 401 error.

316
00:41:39.200 --> 00:41:42.540
Robert Acock: Early, before it reaches the main requests.

317
00:41:42.920 --> 00:41:46.500
Robert Acock: As I say, all of it is resolved at 2App.

318
00:41:47.250 --> 00:41:50.799
Robert Acock: controllers and the operation IDs mapped.

319
00:41:51.240 --> 00:41:55.900
Robert Acock: a class croak, croaks,

320
00:41:56.120 --> 00:42:00.539
Robert Acock: Security, requirements are compiled to guards.

321
00:42:01.600 --> 00:42:07.320
Robert Acock: Request schemas compiled once, not walked per request?

322
00:42:07.880 --> 00:42:18.889
Robert Acock: Per prefix cars assigned, longest prefix always wins. Operation ID becomes a route name, so URL4 works.

323
00:42:19.150 --> 00:42:27.309
Robert Acock: Per request match 1C call, guards max body validate is 1C call.

324
00:42:27.450 --> 00:42:29.200
Robert Acock: Than your method.

325
00:42:29.590 --> 00:42:32.410
Robert Acock: Under a scope, it inherits both.

326
00:42:34.420 --> 00:42:40.779
Robert Acock: So you… you can… you can, have an under, and then call…

327
00:42:40.930 --> 00:42:46.050
Robert Acock: So, V1 in Nick's example is under… Under a different scope.

328
00:42:46.280 --> 00:42:53.870
Robert Acock: And then you can call API, and then that gives it an extra layer of… Or, or forization.

329
00:42:55.200 --> 00:43:05.600
Robert Acock: start from the spec, and as I say, so, like, most times, your application and your API spec, drift.

330
00:43:05.730 --> 00:43:14.530
Robert Acock: But you can actually start a new, a new Punk application from an open API, JSON, and it will generate the app.

331
00:43:14.720 --> 00:43:22.620
Robert Acock: The controllers… And, the stop… the subroutines for you.

332
00:43:23.090 --> 00:43:29.200
Robert Acock: And then you can sync your later on, you could say, a punk API sync.

333
00:43:29.470 --> 00:43:33.320
Robert Acock: And any new methods you add to your OpenAPI schema.

334
00:43:33.470 --> 00:43:38.580
Robert Acock: We'll then become stop methods, and then you can go in and implement the rest of the code.

335
00:43:38.970 --> 00:43:46.190
Robert Acock: There's also, a U… a UI, like, Swagger UI, but it's not Swagger, it's custom-built.

336
00:43:46.540 --> 00:43:54.389
Robert Acock: And that mounts, so you can say docs, and then API, and then give it an endpoint, and then it'll render something like Swagger.

337
00:43:54.770 --> 00:44:04.580
Robert Acock: And so… An open API request costs around 200,000 requests a second.

338
00:44:04.880 --> 00:44:12.780
Robert Acock: For mounted, operations on OpenAPI, or the Markdown, requests.

339
00:44:13.380 --> 00:44:24.540
Robert Acock: We've, 98% of, what a pure punk, request costs.

340
00:44:25.340 --> 00:44:32.729
Robert Acock: And as I say, there is, a markdown keyword, this is where we're getting to.

341
00:44:33.210 --> 00:44:41.599
Robert Acock: And Markdown Keyword will mark, render a directory of Markdown files.

342
00:44:42.160 --> 00:44:49.080
Robert Acock: At that endpoint in… in a UI for you. So it's quite nice for documentation.

343
00:44:49.270 --> 00:44:59.900
Robert Acock: You just… you can just create a, directory of documentation in Markdown, and then it's as simple as saying in Markdown endpoint,

344
00:45:00.670 --> 00:45:02.929
Robert Acock: And it renders for you nicely.

345
00:45:03.500 --> 00:45:10.770
Robert Acock: Configs and, secrets, as I mentioned briefly earlier.

346
00:45:11.100 --> 00:45:18.009
Robert Acock: Configs, have some kind of inheritance, so there's a punk yaml.

347
00:45:18.270 --> 00:45:24.159
Robert Acock: And then you'd usually have an environment.yaml, and then local.yaml on top of that.

348
00:45:24.270 --> 00:45:33.790
Robert Acock: You can register inside of… your config, plugins.

349
00:45:33.970 --> 00:45:45.600
Robert Acock: That's what it means by DSL keyword registers. So you can configure things inside of your YAML, as well as inside of myapp.pm, there's two places.

350
00:45:45.820 --> 00:45:58.060
Robert Acock: Secrets inside of… The configs are references. So, you can say, it's an N variable.

351
00:45:58.290 --> 00:45:59.939
Robert Acock: It's within a file.

352
00:46:00.510 --> 00:46:04.229
Robert Acock: Or you can exec some command.

353
00:46:04.590 --> 00:46:09.250
Robert Acock: App config shows, redacted.

354
00:46:09.610 --> 00:46:13.829
Robert Acock: App Secret, gives you the value.

355
00:46:14.220 --> 00:46:16.000
Robert Acock: From your config.

356
00:46:18.620 --> 00:46:24.129
Robert Acock: And then there is testing, so there is a module called Punk Test.

357
00:46:24.650 --> 00:46:30.189
Robert Acock: And, you give it a mocked, or you give it your application.

358
00:46:30.360 --> 00:46:42.009
Robert Acock: And then you can make requests, so you can say, get OK the book's endpoint. Is the status 200? Yes. Is the JSON, matching?

359
00:46:42.380 --> 00:46:47.579
Robert Acock: And the same with WebSockets and Posts and SSE. There's a bunch of functions there.

360
00:46:47.820 --> 00:46:54.010
Robert Acock: As I mentioned briefly before, there's a command line application.

361
00:46:54.130 --> 00:47:00.580
Robert Acock: So you can generate… A new app from scratch.

362
00:47:01.280 --> 00:47:04.599
Robert Acock: Or you can generate a control or a model.

363
00:47:04.990 --> 00:47:12.530
Robert Acock: You can list your routes, you can sync your API, you can validate your config.

364
00:47:12.760 --> 00:47:18.639
Robert Acock: Doctor lists the current versions of the dependencies you have installed.

365
00:47:18.770 --> 00:47:26.069
Robert Acock: It ensures all the CAPIs are resolving, and it gives you some counts on the number of routes you have.

366
00:47:26.450 --> 00:47:33.080
Robert Acock: Punk Console is a REPL, we have two apps, so you can test.

367
00:47:33.330 --> 00:47:36.300
Robert Acock: Punk Dev…

368
00:47:36.500 --> 00:47:49.900
Robert Acock: is a dev environment of hype… of your environment, so it will restart on changes. I think it starts at Hyperman, and it will restart, each change.

369
00:47:50.420 --> 00:47:56.069
Robert Acock: Punk Test Secret… Serve and version are also there.

370
00:47:56.510 --> 00:48:06.889
Robert Acock: And the plugin brings their own, so there are a few plugins which we'll get to shortly. Punkq, for example, API Key, Sketch, MCP.

371
00:48:08.030 --> 00:48:21.140
Robert Acock: So… what this… Well, that counts, so… a bear… code wrath.

372
00:48:21.450 --> 00:48:22.860
Robert Acock: Pierre Platt call.

373
00:48:23.180 --> 00:48:40.550
Robert Acock: Is around, 1.8 nanoseconds. Punk hello is 1.96, Punk Dynamic Route is 2.05. A 50 route is 2.41, but just… modulation says hello is 78.

374
00:48:40.620 --> 00:48:44.449
Robert Acock: Second, so it's, a rare of a good improvement.

375
00:48:45.080 --> 00:48:54.719
Robert Acock: And in numbers in requests per second, that's, 201, 202, 999,000.

376
00:48:54.890 --> 00:49:07.150
Robert Acock: 997. And in here, I'm kind of cheating. So I'm saying Catalyst is fast for the modulation. It's not really true. Catalyst is actually very slow. It runs at, like.

377
00:49:08.630 --> 00:49:13.979
Robert Acock: 4,000 requests per second, but I wrote something called Callis Sealed.

378
00:49:14.220 --> 00:49:22.160
Robert Acock: And that… that bumps it up to 24,000, so these benchmarks are actually running catalyst sealed, not catalyst.

379
00:49:22.290 --> 00:49:28.319
Robert Acock: But anyway, it's around 200,000, so we haven't regressed, truthfully, that much.

380
00:49:28.620 --> 00:49:34.450
Robert Acock: So, the plugins, let's move on to them.

381
00:49:35.500 --> 00:49:38.929
Robert Acock: this is actually not truthful.

382
00:49:39.230 --> 00:49:46.309
Robert Acock: There is… Oh, yeah, there's 9 in core, and 17 on their own.

383
00:49:46.620 --> 00:49:57.770
Robert Acock: And that makes it 26 plugins currently. Orf and identity, so there's OAuth, SAML… Passkey.

384
00:49:57.800 --> 00:50:16.199
Robert Acock: TOTP, API key authorization, there's CSP, Challenge Requests, Clam AV, identotency, OpenTelemetry, Observe, which is, an observer of OTAL, an ingester, let's say.

385
00:50:16.200 --> 00:50:29.359
Robert Acock: metrics, health, request ID, RSS feed, sitemap, I1AN, locales, there's PunkQ, which is a job queue, skits, blob.

386
00:50:29.490 --> 00:50:35.709
Robert Acock: Conditional GET, Mailer, push, GraphQL, and there's also an MCP.

387
00:50:35.940 --> 00:50:41.860
Robert Acock: Plugin, which turns your plug caps into MCEP endpoints.

388
00:50:43.010 --> 00:50:47.139
Robert Acock: What a plugin gets to do.

389
00:50:47.590 --> 00:51:04.249
Robert Acock: So you can, define your plugin, and then you can say, plugin request ID, that loads it, with arguments. And then, from a plugin, you may install keywords.

390
00:51:04.500 --> 00:51:13.650
Robert Acock: So, for example, that would… that install keyword challenge would then allow you to just say, challenge from within your application spec.

391
00:51:13.850 --> 00:51:19.000
Robert Acock: And, there is Helper, blob put…

392
00:51:19.360 --> 00:51:23.010
Robert Acock: Helper is just a method you can add to the context.

393
00:51:23.950 --> 00:51:28.910
Robert Acock: So from your plugin, you can add helpers to the context,

394
00:51:29.740 --> 00:51:42.929
Robert Acock: You can extend it. So for auth and identity, there are 6 plugins. Plugin OAuth2, which gives you OAuth2 and OpenID Connect support.

395
00:51:43.250 --> 00:51:46.470
Robert Acock: It's a server as well as a client.

396
00:51:49.260 --> 00:51:58.140
Robert Acock: And it's as simple as saying, plug in OAuth2, and then this example is setting up OAuth2 for Google in your application.

397
00:51:59.210 --> 00:52:01.780
Robert Acock: There is Punk SAML,

398
00:52:02.440 --> 00:52:08.510
Robert Acock: Which gives you SAML authentication, and again, it's as simple as calling plugin SAML,

399
00:52:08.880 --> 00:52:15.070
Robert Acock: And then a bunch of your configuration, and your login subroutine to tell you what to do.

400
00:52:15.560 --> 00:52:19.860
Robert Acock: There is Punk Pass Key.

401
00:52:20.430 --> 00:52:27.419
Robert Acock: Which gives you pass… a modern authentication is passkey authentication.

402
00:52:27.550 --> 00:52:41.849
Robert Acock: I should have probably put some screenshots in of what this looks like, but you'll see this sometimes, and then it will add a passkey to your device, and when you log in, it uses the passkey that's saved, in your device.

403
00:52:41.990 --> 00:52:47.860
Robert Acock: And that's as simple as going, giving the session a secret.

404
00:52:48.150 --> 00:52:53.769
Robert Acock: And then it's calling, plugging Passkey and, your auth model.

405
00:52:54.130 --> 00:52:55.939
Robert Acock: Saying your off-model up.

406
00:52:56.270 --> 00:52:59.030
Robert Acock: And that will just work with that configuration.

407
00:52:59.580 --> 00:53:06.229
Robert Acock: Totp hopped, one-time, passcodes.

408
00:53:06.350 --> 00:53:13.180
Robert Acock: Again, this has QR… Rendering and scanning.

409
00:53:15.160 --> 00:53:28.499
Robert Acock: And it's as simple as plugging TOTP, issuer, where it's issued from, and then from within your code, you do… you get the secret, you can render, the QR code in that example.

410
00:53:28.850 --> 00:53:33.559
Robert Acock: And then you can do recovery also.

411
00:53:33.860 --> 00:53:44.259
Robert Acock: There's API key, so a lot of the time you just want a simple API key, and so this plugin exists to help you with that.

412
00:53:44.970 --> 00:53:49.880
Robert Acock: And then there's… authorization.

413
00:53:51.420 --> 00:54:02.060
Robert Acock: And authorization works a little differently. So, you define, like, my app authorization, and then inside of it, you can build a bunch of rules.

414
00:54:02.880 --> 00:54:07.210
Robert Acock: And then, from your application, you can call those rules.

415
00:54:07.430 --> 00:54:12.249
Robert Acock: So for example, here we're creating a rule called Key Revoke.

416
00:54:12.740 --> 00:54:20.489
Robert Acock: And if it does… and then within… within your code, you can validate, against your rules.

417
00:54:21.250 --> 00:54:27.700
Robert Acock: So, Security and Abuse, has 4 plugins.

418
00:54:28.090 --> 00:54:34.239
Robert Acock: There is CSP, so the Content Security, Policy.

419
00:54:34.580 --> 00:54:42.340
Robert Acock: The way this works is it validates, the nonce that is in your header.

420
00:54:42.480 --> 00:54:46.549
Robert Acock: Is the same as what's in the body of the request.

421
00:54:48.010 --> 00:54:56.919
Robert Acock: So that's how that works. Again, it's just plugin CSP, and then from within your template, you set up the script.

422
00:54:57.580 --> 00:55:04.540
Robert Acock: There is Punk Challenge, and this is, basically to slow down bots.

423
00:55:05.570 --> 00:55:19.469
Robert Acock: it adds a challenge request, which is like a puzzle. You don't actually do it yourself, it's like in the background, it will rent… it will redirect to a page, force you, or the bot, or your browser to…

424
00:55:19.610 --> 00:55:21.179
Robert Acock: perform a puzzle.

425
00:55:21.510 --> 00:55:28.540
Robert Acock: And it has a bunch of configuration to make that puzzle more difficult and to last longer.

426
00:55:29.180 --> 00:55:32.170
Robert Acock: Based on number of requests.

427
00:55:32.760 --> 00:55:43.999
Robert Acock: There is Clam AV as well, it's because of… a lot of people need to fire risk scan uploads, so you can,

428
00:55:45.600 --> 00:55:53.370
Robert Acock: plug in Clam AV, you name the sockets of where Clam AV is running.

429
00:55:53.640 --> 00:55:58.910
Robert Acock: And then from, there on out.

430
00:55:59.480 --> 00:56:05.370
Robert Acock: you have an uploadOK function, which performs…

431
00:56:06.550 --> 00:56:12.789
Robert Acock: Virus scanning on the file that's being uploaded, so you know it's secure.

432
00:56:13.450 --> 00:56:17.050
Robert Acock: And doesn't contain a virus, which is the point.

433
00:56:17.280 --> 00:56:22.280
Robert Acock: And then there's idempotency. And for this…

434
00:56:23.490 --> 00:56:32.419
Robert Acock: what this is, is say if you create an order, or you make a… if you make a post request and you're updating data.

435
00:56:32.610 --> 00:56:39.330
Robert Acock: You don't want that post request to happen twice. Say, for example, you're handling payment code.

436
00:56:39.480 --> 00:56:44.170
Robert Acock: What this does is it allows you to,

437
00:56:44.860 --> 00:56:49.170
Robert Acock: cache, that request, so if the…

438
00:56:49.290 --> 00:56:57.769
Robert Acock: User double, submits, the second submit, the third submit, will return the same result as the first.

439
00:56:58.160 --> 00:57:00.019
Robert Acock: It won't rerun the code.

440
00:57:00.570 --> 00:57:04.960
Robert Acock: Ops and observability.

441
00:57:05.350 --> 00:57:09.980
Robert Acock: So we have something called Punk OpenTelemetry.

442
00:57:10.820 --> 00:57:16.829
Robert Acock: Which is OTAL, and it supports traces, metrics, and logs over OTLP.

443
00:57:17.080 --> 00:57:26.139
Robert Acock: So… You… you provide OTAL service name, you call plugin open telemetry.

444
00:57:26.470 --> 00:57:31.289
Robert Acock: Or you can do it without setting up any code, just by passing in

445
00:57:31.590 --> 00:57:41.110
Robert Acock: The endpoint, the environments, variables. And what this will do is, if your code is configured.

446
00:57:41.310 --> 00:57:59.570
Robert Acock: with, well, it will give you some default open telemetry functionality, but you also can add, your own metrics and extend traces and spans from inside your controller, but this will add general, OTAL to

447
00:57:59.860 --> 00:58:10.400
Robert Acock: your access logs, so the full request cycle, basically, out of the box. It won't give you a breakdown of what happens with inside of the sub.

448
00:58:10.680 --> 00:58:16.129
Robert Acock: But it will give you the overview of how long, routing takes.

449
00:58:17.000 --> 00:58:22.650
Robert Acock: And then there is Punk Observe, which is very experimental.

450
00:58:22.980 --> 00:58:40.670
Robert Acock: But this is kind of like a new relic, so it's, it's where you send OTAL logs to, so OpenTelemetry. I wanted to test properly end-to-end, so I just built this. It ingests OTAL logs and has a nice, pretty UI that you can use.

451
00:58:40.730 --> 00:58:50.079
Robert Acock: And then there is Punk Plugging Metrics, that's for Prometheus endpoints, it just,

452
00:58:50.280 --> 00:58:55.359
Robert Acock: Adds, some endpoints that… they make some endpoints available.

453
00:58:55.640 --> 00:59:03.579
Robert Acock: And, adds the data that, Prometheus, can use.

454
00:59:04.340 --> 00:59:11.789
Robert Acock: Health, lifeness, and readiness, which make different things.

455
00:59:11.930 --> 00:59:25.720
Robert Acock: So this gives you a half endpoint and a radius. They mean different things, I should say. It gives you a house and a readiness endpoint, and this just returns some JSON around the health of the service.

456
00:59:26.090 --> 00:59:34.309
Robert Acock: And then there is the request ID, so most of the time when you're

457
00:59:34.470 --> 00:59:37.070
Robert Acock: Writing when you… with your,

458
00:59:37.600 --> 00:59:45.060
Robert Acock: application, you want a unique identifier, per request.

459
00:59:45.170 --> 00:59:52.350
Robert Acock: And that's what, request ID… the plug… the request ID plugin provides.

460
00:59:53.060 --> 00:59:59.340
Robert Acock: So for content and publishing, there are currently 3 plugins.

461
00:59:59.480 --> 01:00:13.500
Robert Acock: There's Punk Feed that provides Atom and RSS feeds, and again, it's just a plugin… the plugin keyword loading the feed plugin, and then that adds a keyword, feed.

462
01:00:13.740 --> 01:00:20.150
Robert Acock: And withinside of that, you can return an array reference of.

463
01:00:20.260 --> 01:00:32.299
Robert Acock: items, and that will then turn into your feed. So here, we're just… we're retrieving all, post messages from the post model.

464
01:00:33.040 --> 01:00:42.160
Robert Acock: We're using the database model, the post-database model, to receive all the recent, Posts.

465
01:00:43.420 --> 01:00:55.160
Robert Acock: And then there's a sitemap, so you don't want to manually map your sitemap, so there's a sitemap plugin, and adding that, generates the sitemap for you.

466
01:00:55.270 --> 01:01:02.439
Robert Acock: Yeah, you can exclude as well, by doing sitemap O…

467
01:01:03.410 --> 01:01:11.050
Robert Acock: And there is locale support, via the I18N, plugin.

468
01:01:11.440 --> 01:01:17.370
Robert Acock: And then within your code and your template, you can call locale and then reference.

469
01:01:17.490 --> 01:01:22.720
Robert Acock: And these go in… these are JSON catalogues.

470
01:01:22.880 --> 01:01:26.880
Robert Acock: And they're passed at Boo, and they're frozen, I believe.

471
01:01:27.520 --> 01:01:35.079
Robert Acock: And there are 4 plugins for data and storage, so there's a Q plugin.

472
01:01:35.230 --> 01:01:42.650
Robert Acock: Which has a C core. You… if you use the Modelicious, you've probably used Minion.

473
01:01:42.970 --> 01:01:48.449
Robert Acock: And this is, similar to that.

474
01:01:48.700 --> 01:01:52.359
Robert Acock: So you can, you can,

475
01:01:52.860 --> 01:01:58.160
Robert Acock: set call, to find the plugin with, the plugin keyword and the queue.

476
01:01:58.300 --> 01:02:00.200
Robert Acock: And,

477
01:02:00.540 --> 01:02:16.260
Robert Acock: within that, there's a queue keyword, there's a task keyword, there's a cron. So if you want to, within the job queue, you can have a cron, so you can say, run… run reports nightly, endpoint every…

478
01:02:16.600 --> 01:02:18.469
Robert Acock: X number of minutes.

479
01:02:19.370 --> 01:02:37.380
Robert Acock: Or ours. Schema change management under Sketch. I like Sketch. We use it at my current workplace. All the plugins, that require database tables.

480
01:02:37.460 --> 01:02:43.630
Robert Acock: use Sketch as well, and it kind of just works out of the box, and it tells you when you need to redeploy.

481
01:02:43.960 --> 01:02:47.129
Robert Acock: This looks something like that.

482
01:02:47.580 --> 01:02:52.230
Robert Acock: There is a blob plugin.

483
01:02:52.400 --> 01:03:03.890
Robert Acock: That assists you in blog-related, tasks, and it has content address storage by another of my modules.

484
01:03:05.090 --> 01:03:10.849
Robert Acock: There is conditional get as well,

485
01:03:11.200 --> 01:03:26.859
Robert Acock: So this uses e-tags, so it's just a way of caching an endpoint, essentially, and if the endpoint hasn't changed, or the data hasn't changed, then it just returns its previous request.

486
01:03:28.250 --> 01:03:34.020
Robert Acock: Integrations and delivery, there is 4 plugins for this.

487
01:03:34.610 --> 01:03:48.279
Robert Acock: Punk Mailer, so a mailing, plugin that then gives you a mail keyword, on your context object, so you can call to subject texts, for example.

488
01:03:48.440 --> 01:03:58.510
Robert Acock: There's… within Mailer as well, there's SMTP, but there's also, support for… Like, web service mailers.

489
01:03:58.890 --> 01:04:00.670
Robert Acock: Firefetch.

490
01:04:01.610 --> 01:04:04.110
Robert Acock: There is Punk Push.

491
01:04:04.450 --> 01:04:09.130
Robert Acock: Which give you, FAPID…

492
01:04:09.660 --> 01:04:24.040
Robert Acock: push notifications from your server to a device. For example, it gives you the native push notifications on the device. For example, you might… you want to use this,

493
01:04:24.260 --> 01:04:29.260
Robert Acock: Even from a job queue, you can probably use this to send a push notification out.

494
01:04:29.510 --> 01:04:33.630
Robert Acock: To notify them that the report is ready to download.

495
01:04:35.660 --> 01:04:50.710
Robert Acock: Then there is, GraphQL. So, as most of you have used GraphQL before, or some of you may have, this actually uses GraphQL Hutu, which is a module on CPAN.

496
01:04:51.090 --> 01:04:57.610
Robert Acock: But it's… it allows you to quickly, set up a GraphQL endpoint inside of Punk.

497
01:04:58.030 --> 01:05:07.640
Robert Acock: And I think we're nearly there, but there's Punk MCP, which is one of the more recent, plugins that I've added.

498
01:05:08.080 --> 01:05:14.019
Robert Acock: And that gives… that's a mod… that gives you… that makes you a punk model context protocol server.

499
01:05:14.350 --> 01:05:21.859
Robert Acock: So you can… call it… call the plugin as MCP,

500
01:05:21.980 --> 01:05:25.879
Robert Acock: Mount your path, and your name, and then,

501
01:05:26.070 --> 01:05:32.730
Robert Acock: configure tools. So here, we're setting up a search books tool, and that points to an endpoint.

502
01:05:32.870 --> 01:05:37.449
Robert Acock: You have to just describe, add a description and the input.

503
01:05:37.850 --> 01:05:39.619
Robert Acock: For it to work.

504
01:05:40.630 --> 01:05:47.400
Robert Acock: So… This is, like, the seam, so not… I think this is the only,

505
01:05:48.140 --> 01:06:01.370
Robert Acock: framework on, CPAN that has this. It has 20 CAPI APIs, which do various things, that make it fast.

506
01:06:01.770 --> 01:06:09.639
Robert Acock: It decodes a JSON request body, without ever entering Pearl.

507
01:06:09.850 --> 01:06:16.340
Robert Acock: But it also isn't always perfect, and things didn't always go…

508
01:06:16.610 --> 01:06:26.550
Robert Acock: the correct way. So, like, on Linux, an EPOL file descriptor is a shared kernel object across forks.

509
01:06:26.940 --> 01:06:33.370
Robert Acock: A child tidying up watches on the inherited loop was deregistering its parents' file descriptors.

510
01:06:33.560 --> 01:06:52.089
Robert Acock: the parent kept running in, it just stopped hearing about sockets it was still responsible for. That was back in, version 13 and 14. And then there's been a few CPEs as well along the way. So it's been a learning curve, but it's getting more and more stable.

511
01:06:52.160 --> 01:06:57.040
Robert Acock: And, I think both Punk and hyperman now.

512
01:06:57.210 --> 01:07:01.810
Robert Acock: are 100%, covered using Devil Access.

513
01:07:01.990 --> 01:07:15.560
Robert Acock: This is in the wild, so, my stack is used on two of my, two applications I host. So my own personal website, ournation.org, is running Punk and Hyperman.

514
01:07:15.840 --> 01:07:22.150
Robert Acock: And peer-to-peer games, as well, is also running, Punk and Hypermount.

515
01:07:22.730 --> 01:07:32.180
Robert Acock: And, yeah, that's it. You can install on CPAN, as CPANM Hypermanfection Punk.

516
01:07:33.170 --> 01:07:34.870
Robert Acock: Are there any questions?

517
01:07:38.320 --> 01:07:49.439
Gabor Szabo: You mentioned the two sites that you are running. Do you know any other projects that are built on Punk, either open source or

518
01:07:49.820 --> 01:07:53.860
Gabor Szabo: Or… proprietary sites?

519
01:07:53.860 --> 01:08:04.429
Robert Acock: Well, I think Emmanuel mentioned at the start that he has been looking at Punk and Hyperman, but found a bug within

520
01:08:04.970 --> 01:08:07.650
Robert Acock: relatively recent version of Hyperman.

521
01:08:07.800 --> 01:08:16.299
Robert Acock: That caused the memory leakage. So I'm hoping that is fixed. I will be investigating that afterwards.

522
01:08:18.760 --> 01:08:26.100
Gabor Szabo: Yeah, I mean, the whole thing that you showed is huge, and I don't know… Absolutely.

523
01:08:26.109 --> 01:08:35.949
Robert Acock: it was very difficult to prepare a presentation, because I didn't know whether to concentrate on everything I've written, which I just did.

524
01:08:35.949 --> 01:08:46.309
Robert Acock: And then that, that, like, that was already an hour. So I couldn't… I couldn't make these slides any longer, so I just kind of highlighted where I could… what things done.

525
01:08:46.319 --> 01:08:53.709
Robert Acock: But all of these modules… a lot of the plugins are standalone, so they're outside of the main distribution.

526
01:08:53.819 --> 01:08:57.459
Robert Acock: They all have example applications inside of them.

527
01:08:57.719 --> 01:09:01.259
Robert Acock: So, you can, take the distribution.

528
01:09:01.539 --> 01:09:06.939
Robert Acock: And there's an example directory, and that will, open.

529
01:09:07.269 --> 01:09:08.309
Robert Acock: something.

530
01:09:08.859 --> 01:09:14.879
Gabor Szabo: Yeah, yeah, I mean, it's extraordinary what you created here, that's what I'm trying to say.

531
01:09:16.289 --> 01:09:26.429
Gabor Szabo: And I looked at the documentation, or your website, during the presentation, and also you have tons of examples, and and

532
01:09:28.589 --> 01:09:33.869
Gabor Szabo: Documentation, and something that's missing in a lot of projects.

533
01:09:34.159 --> 01:09:37.549
Gabor Szabo: So it's excellent.

534
01:09:37.659 --> 01:09:43.029
Gabor Szabo: And, and, if, I mean, if anyone here, or…

535
01:09:43.349 --> 01:09:59.089
Gabor Szabo: watching the video, or anyone is building something around using Punk, please, especially if it's open source, then please let me know so we can share it in the Per Weekly newsletter, for example. But probably, Robert, you're also interested in

536
01:09:59.189 --> 01:10:06.099
Gabor Szabo: I don't know, your listing, maybe, create a list of all the open source projects that are using it, because

537
01:10:06.509 --> 01:10:08.079
Gabor Szabo: People can learn from that.

538
01:10:08.549 --> 01:10:10.009
Gabor Szabo: There's a question there.

539
01:10:12.349 --> 01:10:13.369
Gabor Szabo: In the chat.

540
01:10:13.730 --> 01:10:16.059
Robert Acock: Do you… do you mean GraphQL?

541
01:10:19.860 --> 01:10:25.159
Iva Popova: No, I mean, graph databases, like,

542
01:10:27.120 --> 01:10:31.680
Iva Popova: I'm not quite sure, like, new for Jay, if you heard.

543
01:10:32.870 --> 01:10:33.320
Robert Acock: No.

544
01:10:33.650 --> 01:10:37.630
Robert Acock: I don't… it has DBI and DBIX class.

545
01:10:37.630 --> 01:10:40.140
Iva Popova: It'll be on the side, DBI,

546
01:10:40.140 --> 01:10:42.640
Robert Acock: Yeah, so there's DBI adapters.

547
01:10:43.670 --> 01:10:45.870
Robert Acock: will work within punk.

548
01:10:45.870 --> 01:10:52.609
Iva Popova: Okay, so the same, I suppose, is with other NoSQL databases.

549
01:10:53.110 --> 01:10:55.050
Robert Acock: SQL, yeah, it was…

550
01:10:55.050 --> 01:10:56.590
Iva Popova: I mean, no SQL.

551
01:10:56.590 --> 01:11:04.730
Robert Acock: NoSQL is a bit different. So, you have to… there's no, like, generic DPI module.

552
01:11:05.700 --> 01:11:09.369
Robert Acock: So you have to create your own models.

553
01:11:09.710 --> 01:11:13.890
Robert Acock: wrappers. So, for example, if I was to use Elasticsearch.

554
01:11:13.890 --> 01:11:14.370
Iva Popova: No.

555
01:11:14.370 --> 01:11:23.590
Robert Acock: I'd have to create a backend for Elasticsearch for it to work, and I haven't done all of them yet. It's a bit difficult, and just to say.

556
01:11:23.590 --> 01:11:30.980
Iva Popova: Yes, there is time, and maybe we can raise a feature request or something.

557
01:11:30.980 --> 01:11:31.950
Robert Acock: Yeah, sure.

558
01:11:31.950 --> 01:11:33.500
Iva Popova: Okay, thank you, thank you.

559
01:11:39.710 --> 01:11:43.159
dragos trif: When you manage your schemas, can you dump

560
01:11:44.890 --> 01:11:52.810
dragos trif: Can you dump to generate the controllers, the tables you are using inside the application, like you would do with, I don't know.

561
01:11:53.030 --> 01:11:55.440
dragos trif: BBX cluster schema dump.

562
01:11:58.080 --> 01:11:58.640
Robert Acock: it doesn't.

563
01:11:58.640 --> 01:11:59.070
dragos trif: Is that right?

564
01:11:59.070 --> 01:12:06.209
Robert Acock: I don't… I don't think from the database layer, I don't think it generates…

565
01:12:06.380 --> 01:12:08.800
Robert Acock: It might generate the model, actually.

566
01:12:09.710 --> 01:12:12.989
Robert Acock: From the top of my mind, I can't remember, sorry.

567
01:12:13.160 --> 01:12:14.889
Robert Acock: But it won't…

568
01:12:15.040 --> 01:12:25.080
Robert Acock: it does definitely do the API schema, so it does… does the controller methods for the API. I don't think it does…

569
01:12:25.390 --> 01:12:26.800
Robert Acock: the database.

570
01:12:27.890 --> 01:12:36.850
dragos trif: Because that would be… For a small application, ideal to just dump everything and have it working.

571
01:12:40.950 --> 01:12:41.800
Robert Acock: Yeah.

572
01:12:43.610 --> 01:12:47.240
Robert Acock: I think it's difficult based on schemas.

573
01:12:48.080 --> 01:12:50.069
Robert Acock: And mapping of schemas.

574
01:12:53.900 --> 01:13:00.439
Robert Acock: Because of the… there is a small flaw with the DBI,

575
01:13:00.920 --> 01:13:09.280
Robert Acock: functionality that I've added with the types, and then you have to map. So, like, in SQL,

576
01:13:09.430 --> 01:13:13.730
Robert Acock: a light, and then in post-tress, then in…

577
01:13:13.860 --> 01:13:22.520
Robert Acock: MariaDB, let's say, they all have different types, so, like, int, a long int.

578
01:13:22.920 --> 01:13:24.190
Robert Acock: Text.

579
01:13:26.820 --> 01:13:29.909
Robert Acock: And you have to map those for every DBI.

580
01:13:30.520 --> 01:13:40.890
dragos trif: So… I played with DBX class, Maria DeBay and MySQL, and even between Maria DeBay and MySQL,

581
01:13:41.540 --> 01:13:42.830
dragos trif: There are issues.

582
01:13:44.010 --> 01:13:48.199
dragos trif: and beyond type, so if you dump a DBAX class.

583
01:13:48.840 --> 01:13:54.690
dragos trif: schema with MariaDB, it would look… bad, it will not…

584
01:13:54.890 --> 01:14:02.579
dragos trif: find all the relationship within the tables, but with MySQL drivers, it will work properly.

585
01:14:06.810 --> 01:14:07.540
dragos trif: 12…

586
01:14:07.920 --> 01:14:08.520
Robert Acock: Yeah.

587
01:14:08.520 --> 01:14:09.350
dragos trif: It can be…

588
01:14:09.350 --> 01:14:11.410
Robert Acock: It depends on the database.

589
01:14:22.980 --> 01:14:26.039
Robert Acock: Have we stopped recording? Can we stop recording?

590
01:14:26.040 --> 01:14:28.110
Gabor Szabo: No, no, we are still recording.

591
01:14:28.110 --> 01:14:28.910
Robert Acock: Okay.

592
01:14:29.630 --> 01:14:35.749
Emmanuel Thouraud: Yeah, I think it's impressive how many modules you have created. It's… the framework seems pretty complete.

593
01:14:35.940 --> 01:14:43.160
Emmanuel Thouraud: And I am wondering, when do you think it will be Reliable for production.

594
01:14:44.350 --> 01:14:47.360
Emmanuel Thouraud: one… Release.

595
01:14:47.360 --> 01:14:52.440
Robert Acock: It depends, it depends what your production is at the end of the day.

596
01:14:53.230 --> 01:15:13.199
Robert Acock: I… I'm running it in, let's say, my production, but my… it's, like, test cases. I don't have a business at the moment that would let me put that inside of their company. Like, my old job, I had a business that let me put software in their company, so I know, like, my TERS framework.

597
01:15:13.200 --> 01:15:16.880
Robert Acock: It's very much tested and running and heavily used.

598
01:15:17.190 --> 01:15:25.519
Robert Acock: This one is only used, really, on… by me, and I don't… I would say it's still being worked on.

599
01:15:25.770 --> 01:15:30.150
Robert Acock: Until my modules are at least version 1.0.

600
01:15:30.340 --> 01:15:47.620
Robert Acock: They're still being worked on, they're still not finished. Things may change slightly, but not drastically at this point. I'm fairly stable, I'm just making it work in environments and fixing bugs. There's not much more

601
01:15:48.100 --> 01:15:53.849
Robert Acock: that I really need in features. There's so much already, as we've just sat through an hour of…

602
01:15:54.120 --> 01:16:00.639
Robert Acock: Me skim-reading… skimming through plugins, because there's so many and so much functionality there.

603
01:16:00.930 --> 01:16:06.590
Robert Acock: So, yeah, I… I'm rather happy with it,

604
01:16:06.700 --> 01:16:14.109
Robert Acock: My environments have been running without me having to stop, without any downtime.

605
01:16:14.540 --> 01:16:16.190
Robert Acock: Since I started them.

606
01:16:16.540 --> 01:16:18.959
Robert Acock: So I've not had any issues.

607
01:16:19.420 --> 01:16:26.000
Robert Acock: But yeah, I will let… I will keep you posted, and when I do a 1.0, that's when…

608
01:16:27.250 --> 01:16:34.470
Robert Acock: It will be totally production ready, but if you want to try it, use it at your own,

609
01:16:35.340 --> 01:16:36.910
Robert Acock: Regression, let's say.

610
01:16:37.190 --> 01:16:40.510
dragos trif: I think we should mess with it a little bit.

611
01:16:40.880 --> 01:16:43.729
dragos trif: So… We can't give you feedback.

612
01:16:45.090 --> 01:16:45.780
Robert Acock: Mmm.

613
01:16:45.980 --> 01:16:46.580
Gabor Szabo: Yeah.

614
01:16:47.070 --> 01:16:54.629
Gabor Szabo: I would… that's what I'm… that's what I'm sort of trying to hint, that it would be lovely if people started to use it, create various

615
01:16:55.060 --> 01:17:00.139
Gabor Szabo: experimental things, and then that would be give you feedback, and…

616
01:17:00.740 --> 01:17:03.869
Gabor Szabo: Maybe showcases, if they are open source.

617
01:17:04.330 --> 01:17:07.980
Robert Acock: Yeah, so I had a third application that I was running.

618
01:17:08.130 --> 01:17:12.420
Robert Acock: which was, an open API proxy.

619
01:17:12.870 --> 01:17:23.519
Robert Acock: application, but it was running two servers, and it was costing money, and nobody used it, so I took it down. But that was a third toy application that I built with it.

620
01:17:23.790 --> 01:17:27.080
Robert Acock: So by building things, I find the bugs.

621
01:17:28.320 --> 01:17:28.700
Gabor Szabo: Have you…

622
01:17:28.700 --> 01:17:33.059
Robert Acock: And I find the features that I need that are shared.

623
01:17:34.560 --> 01:17:38.869
Gabor Szabo: Have you tried using any LLM to write a Punk application?

624
01:17:38.870 --> 01:17:46.989
Robert Acock: How does it work? Do you think I'm superhuman, and I write a million lines of code a second to do all of this?

625
01:17:47.150 --> 01:17:52.069
Robert Acock: I am not going to sit here and say I did not use AI.

626
01:17:52.070 --> 01:17:53.200
Gabor Szabo: No, no, no, what I'm asking you.

627
01:17:53.200 --> 01:17:54.269
Robert Acock: Very much, dude.

628
01:17:54.420 --> 01:18:00.399
Gabor Szabo: No, no, no, no, no. What I'm asking is, how good is LLM writing upon complication?

629
01:18:01.150 --> 01:18:05.120
Gabor Szabo: Yeah, because it's relatively new, so I don't know how much it learned already that…

630
01:18:05.700 --> 01:18:09.479
Robert Acock: Peer-to-peer games is AI-assisted.

631
01:18:09.620 --> 01:18:10.330
Robert Acock: unpunk.

632
01:18:11.870 --> 01:18:16.179
Emmanuel Thouraud: Yeah, and in my experience, at least Codex was,

633
01:18:16.780 --> 01:18:26.389
Emmanuel Thouraud: very powerful to use Punch, because the documentation is good. So, the AI was able to use it and code.

634
01:18:26.690 --> 01:18:33.210
Emmanuel Thouraud: Almost without error on the punk side, because the documentation and all the methods are clear.

635
01:18:36.190 --> 01:18:36.820
Gabor Szabo: Excellent.

636
01:18:37.230 --> 01:18:47.369
Emmanuel Thouraud: Yeah, and you, you said you use, Duck to render Markdown files, and which level of Mark Dunn, or which,

637
01:18:47.480 --> 01:18:50.460
Emmanuel Thouraud: framework you use to render the margin, it's,

638
01:18:50.790 --> 01:18:54.980
Emmanuel Thouraud: A standard per module, or something you also develop?

639
01:18:56.000 --> 01:18:58.700
Robert Acock: Sorry, can you repeat the question? I didn't quite get it.

640
01:18:59.060 --> 01:19:02.249
Emmanuel Thouraud: I think you use the… the dock.

641
01:19:02.770 --> 01:19:04.890
Emmanuel Thouraud: to render some marked on files.

642
01:19:06.010 --> 01:19:09.980
Emmanuel Thouraud: And I was wondering, which,

643
01:19:11.030 --> 01:19:14.550
Emmanuel Thouraud: tools are using to render. It's a module…

644
01:19:14.770 --> 01:19:18.490
Emmanuel Thouraud: You are reusing, or a new module you have created.

645
01:19:20.060 --> 01:19:22.650
Robert Acock: For testing, or doctor, or…

646
01:19:22.650 --> 01:19:25.919
Emmanuel Thouraud: For the rendering, the Mark Dunn files.

647
01:19:26.290 --> 01:19:27.740
Robert Acock: the rendering…

648
01:19:28.010 --> 01:19:28.530
Emmanuel Thouraud: Yup.

649
01:19:29.270 --> 01:19:32.680
Robert Acock: Of what, the HTML, or…

650
01:19:32.780 --> 01:19:35.389
Emmanuel Thouraud: Yes, from Markdown to HTML.

651
01:19:35.390 --> 01:19:40.040
Robert Acock: Oh, from Markdown to HTML, yeah. That uses a thing called Markdown Simple.

652
01:19:40.820 --> 01:19:41.450
Emmanuel Thouraud: Okay.

653
01:19:41.450 --> 01:19:59.929
Robert Acock: That's a… that's a module. I created a website, last year when I was experimenting, when AI was just starting to get good. So, like, Markdown Simple was one of my first experimental modules with AI.

654
01:20:00.060 --> 01:20:16.449
Robert Acock: And I was very rudimental with, the quotes that I used with it, as in the prompts that I used to create it, and I was like, wow, we've done all of this, right? It generated this module in XS&C, and…

655
01:20:16.450 --> 01:20:21.190
Robert Acock: It was… it was fast, but it was very bad code, and very flawed.

656
01:20:21.250 --> 01:20:25.019
Robert Acock: But then, Oprah's come around.

657
01:20:25.110 --> 01:20:34.649
Robert Acock: And I was working on this, and I tasked it to create a 100% compliant markdown to HTML.

658
01:20:34.970 --> 01:20:36.580
Robert Acock: Render.

659
01:20:36.750 --> 01:20:39.659
Robert Acock: So it's 100% compliant in Markdown.

660
01:20:40.380 --> 01:20:45.170
Robert Acock: And, yeah, it renders the HTML. It's quite nice.

661
01:20:46.260 --> 01:20:48.769
Robert Acock: And it's relatively fast as well.

662
01:20:49.660 --> 01:20:54.080
Robert Acock: Much faster than the other marks. I benchmarked a few marked down.

663
01:20:54.470 --> 01:20:57.779
Robert Acock: Modules, and they were rather slow.

664
01:20:59.090 --> 01:20:59.880
Robert Acock: So…

665
01:21:04.120 --> 01:21:08.610
Gabor Szabo: Well, I think we can stop recording now, right?

666
01:21:08.730 --> 01:21:13.500
Gabor Szabo: And then we can switch to off-the-record conversation.

667
01:21:14.040 --> 01:21:18.220
Gabor Szabo: So I just wanted to thank… really thank you for the presentation.

668
01:21:18.450 --> 01:21:21.070
Gabor Szabo: It was excellent, I really enjoyed it.

669
01:21:21.530 --> 01:21:36.950
Gabor Szabo: overwhelming, so we have to watch it again, or go into the documentation and actually play with this. That's the way to do it. And thanks everyone who participated and asked questions, and

670
01:21:37.230 --> 01:21:40.289
Gabor Szabo: those people who participated and didn't ask questions.

671
01:21:40.690 --> 01:21:58.989
Gabor Szabo: And, everyone who watched it, so please just like the video, follow the channel, look at the link below, and you'll find more events. I'm going to share also in the chat the link to all the events, so you can all go and already record, register.

672
01:21:59.680 --> 01:22:04.090
Gabor Szabo: And, that's it for today. Thank you very much. Goodbye.

