---
title: "GitLab pipelines and CI for Perl developers"
timestamp: 2025-01-21T09:30:01
tags:
  - GitLab
  - CI
published: true
types:
  - screencast
author: szabgab
archive: true
description: "GitLab pipelines"
show_related: true
---

In this virtual event we'll get an introduction to the GitLab pipelines that allow us to build a CI system.

The presentation have examples in Perl.

{% youtube id="RnXwP4I-vUs" file="2025-01-20-gitlab-pipelines-and-ci-for-perl-developers.mp4" %}

[register](https://www.meetup.com/code-mavens/events/304874972/)

* [The slides](https://slides.code-maven.com/gitlab/)
* [GitLab Pipelines demo](https://gitlab.com/szabgab/pipelines-demo) repository
* [CPAN Rocks](https://cpan.rocks/)
* [Linux-Systemd](https://gitlab.com/ioanrogers/Linux-Systemd) GitLab repository
* [Perl Game-Entities](https://gitlab.com/jjatria/perl-game-entities) GitLab repository
* [GitLab CI Pipeline for Perl DBD::Mock using Module::Build](/gitlab-ci-module-build)
* [GitLab CI for Perl projects](/gitlab-ci)

## Transcript

1
00:00:02.190 --> 00:00:24.969
Gabor Szabo: Hello, and welcome to the Perl Maven meeting in the Code Mavens Channel. This is part of the big Codemavens Channel. My name is Gabor, Gabor, Gabor, Sabo. I used to teach a lot of perl these days. I have a lot less work in Perl, so I do teach python and rush these days.

2
00:00:25.080 --> 00:00:45.209
Gabor Szabo: but I still run the Pearl weekly, and I still like pearl. So here and there I try to give presentations also about Pearl, and as I wrote earlier in the Pearl Weekly as well, I would be happy to have other people guests, speakers who would present something in the in these meetings

3
00:00:45.570 --> 00:01:00.760
Gabor Szabo: this time in this meeting I'll try to get a little bit of get out a little bit of information about gitlab, and more specifically, how to write pipelines, or how to use ci in gitlab. I'm going to share the screen now

4
00:01:01.640 --> 00:01:12.230
Gabor Szabo: and hopefully the right screen, and you're supposed to see my my slides now.

5
00:01:14.770 --> 00:01:23.559
Gabor Szabo: right? Which which are not very pretty, pretty, but useful. And and they are generated with various programs.

6
00:01:24.690 --> 00:01:50.010
Gabor Szabo: Okay, so we're going to. I'll have some slides, and and I also will show Demo a lot of things during this presentation, and feel free to all those people who are in the in the meeting. So thank you very much for for coming to the meeting. It's way better to for me to speak when there, when I see that there are people, and especially if they are giving some feedback. That's much easier than just speaking into the the camera.

7
00:01:50.010 --> 00:01:54.750
Gabor Szabo: So what I'm going to do now is I'll go over some of the slides and then

8
00:01:56.710 --> 00:02:09.580
Gabor Szabo: show a couple of examples. Let's actually show something different. First, st there is this website called Cpan Rocks. That gives you some statistics about cpan libraries.

9
00:02:09.580 --> 00:02:28.250
Gabor Szabo: modules, whatever we packages, whatever you would like to call them, and one of the things that actually something is missing from here, but partially is there, so we can see on the right hand side what version control system each module uses. So, as you know, if you when you are

10
00:02:28.690 --> 00:02:35.600
Gabor Szabo: package something and upload to pose and to cpan. Then in inside, you can tell where is the repository?

11
00:02:35.750 --> 00:02:37.180
Gabor Szabo: If

12
00:02:37.440 --> 00:03:06.247
Gabor Szabo: yeah, yeah, thank you for sharing. I'll share the if. Yeah, just remind me, and then I can share the links as well. This is the Cpan rocks, and thank you, Andrew for sharing it. So this is not my website. Actually, I don't know who is running it. Anyway. The thing is that you can see here what version control use each one of them uses. Unfortunately, it only says, Git, it doesn't say if it's Github or Gitlab, or something else.

13
00:03:07.210 --> 00:03:13.412
Gabor Szabo: on the other hand, here, on on the left hand side, there is a this

14
00:03:14.320 --> 00:03:36.129
Gabor Szabo: part where you can see the bug tracking system that can be also included in the in the Meta files of of a cpap package. And here we can actually see which one has a bug tracker on Github. So obviously there can be more that just don't. There can be more. I mean, you can see that there are

15
00:03:36.420 --> 00:04:04.389
Gabor Szabo: only 35, only I mean 64% doesn't even say what version control system they use. And so there might be many others who just don't include that information in the meta info in the Meta tabs here, too, about bug trackers. You can see the 60%. And doesn't. 62% doesn't say. And you can see that there are 101 cpan modules that use gitlab, and probably

16
00:04:04.954 --> 00:04:14.179
Gabor Szabo: for for bug tracking. So probably also for version control. And we can look at few of them. If any of them uses this.

17
00:04:14.700 --> 00:04:18.879
Gabor Szabo: the pipeline in order to run the tests,

18
00:04:23.620 --> 00:04:40.810
Gabor Szabo: Well, so Mark says that for version control system git is git is git hopefully, regardless of central hub or law. Right? Yes. So the version control system is git. I would really like to have a report saying which reposit which

19
00:04:41.400 --> 00:05:04.869
Gabor Szabo: module uses, which hosting pro git hosting service. I'll show you actually what I mean, because I do. I mean, I have the Cpan digger, and it should this one, the Cpan digger that is, collecting data about Cpan library Cpan modules. And I don't remember why the statistics is not there.

20
00:05:04.870 --> 00:05:28.120
Gabor Szabo: Maybe I have never created it, or I just don't remember the link. I have a sorry rust digger. I have a similar project for rust, and here you have a I already have this. It's newer. So maybe I added some features here that I didn't have back in the days when I wrote the Cp. On the digger. Here you can see

21
00:05:28.170 --> 00:05:37.400
Gabor Szabo: detailed information about which create in that case uses which repository. And we can even see, I think.

22
00:05:37.950 --> 00:05:50.639
Gabor Szabo: yeah. So you can see, for example, those who use gitlab directly. So they are using the hosting of gitlab. And then there are others that, using gitlab installed on their own server.

23
00:05:50.680 --> 00:06:19.360
Gabor Szabo: Okay, so here is the the platform. And then, once now, why is it interesting for for me and for purpose of this? Actually, this video and is the reason is because because we can go to these projects and see how they use github pipelines in order to run their Ci jobs. So it's not that there's not other consideration here. I think that just that

24
00:06:19.380 --> 00:06:22.919
Gabor Szabo: we can look at other projects, how they use it. And

25
00:06:23.380 --> 00:06:28.049
Gabor Szabo: actually, if I go back, so I'll I'll just bring this one as well.

26
00:06:28.500 --> 00:06:30.910
Gabor Szabo: Yeah, in case you're interested.

27
00:06:31.080 --> 00:06:59.050
Gabor Szabo: Anyway. If you are already. I want to show it later. But now that I also got into this, you can see here. Now, we are looking at the okay, the Perm event website that you might be familiar with. And then in the archive I could find gitlab. I was looking for this because I wasn't sure and sort of. I remember that I wrote about it. So I found 2 articles.

28
00:06:59.450 --> 00:07:18.260
Gabor Szabo: this one and this one. I'm going to open them. I'll put the links here as well in the chat. Okay? Because apparently a while ago I wrote an article on how to create a pipeline for

29
00:07:18.710 --> 00:07:46.730
Gabor Szabo: for these, what? Yeah, the the DVD mock module. But also I I created a list of back. Then there were 29 Cpan modules using gitlab according to the Cpan rocks. And now, as you might remember, there's 101. And this was the list of the ones that are that actually had a gitlab pipeline. So let we can actually take a look at now, if there are still the case, at least for our experiment.

30
00:07:46.890 --> 00:07:52.430
Gabor Szabo: So, Rx. And then we get to better Cpan. And here we have the link to the repository

31
00:07:53.070 --> 00:07:55.590
Gabor Szabo: which is still gitlab.

32
00:07:55.690 --> 00:08:15.800
Gabor Szabo: And you can see there is this gitlab dash ci dot yaml, which is the configuration file for Gitlab. I'm thinking of moving my project to Codeberg or another. How do you say it? Forget or forget, Joe? I don't know. It's Spanish or not

33
00:08:15.800 --> 00:08:37.530
Gabor Szabo: a host and interest in updating your diggers to track projects using it's Ci. There is interest. I don't know how much time I have. If you're talking about the Cp and digger. I was even thinking of rewriting it in in rust. So it's it's gonna be might be easier for me to maintain, because now I have like

34
00:08:38.860 --> 00:09:03.799
Gabor Szabo: 4 different versions of these diggers, each one. It's in all language the pearl ruby, the python, and the rust digger, and each one it's in in all language which was originally the consideration, so that people can contribute to it in their native language, which not not really happened. So maybe it would be easier for me to just maintain one thing, but we'll see.

35
00:09:04.240 --> 00:09:15.091
Gabor Szabo: anyway. Look at the Cpap digger and try to help. Is that so? I leave this open this, our explorer, because we maybe we look at the at the at its

36
00:09:16.240 --> 00:09:20.919
Gabor Szabo: configuration file to get some ideas.

37
00:09:21.600 --> 00:09:27.409
Gabor Szabo: Okay? So that's the sort of examples and background in

38
00:09:28.150 --> 00:09:33.770
Gabor Szabo: Hi, hi like 1 1 10,000 miles view, or whatever it is that and

39
00:09:34.910 --> 00:09:56.469
Gabor Szabo: the the thing is so, what is this thing. So 1st of all, Gitlab, I assume that those people who are here, they know what gitlab is, but in case someone is watching the video and doesn't know. So Gitlab is basically a platform, an open source, mostly open source platform that provides similar services to what Github

40
00:09:56.470 --> 00:10:09.140
Gabor Szabo: provides. It's open source. So you can download it, install it. And there are certain extensions. I think that you have to pay for and get a license for. But basically you can use. You run your own

41
00:10:09.260 --> 00:10:27.049
Gabor Szabo: gitlab service on your own public computer or on your private computer. And I think that's how they make a lot of make money that they sell this license or provide services to companies. So I saw a number of clients that they use the gitlab

42
00:10:27.850 --> 00:10:33.793
Gabor Szabo: in in their own installation, their own private installation, and

43
00:10:34.690 --> 00:10:53.860
Gabor Szabo: the pipeline. So if you are familiar with Github, there is the Github actions. Yeah. Mark says that his previous employer use self-hosted Github. It's always good that some people actually know the right words that self hosted which I just forgot. So I didn't say. But that's the right word. Thank you. So

44
00:10:53.980 --> 00:11:22.620
Gabor Szabo: so the thing is that just as there used to be this Travis Ci that is still around, maybe, but stopped serving open source projects that allowed people to write some configuration files and run Ci jobs, continuous integration jobs in Github. There are the Github actions that provide the same feature. And then, gitlab, there is what we call the gitlab pipelines. And that's the main focus of this presentation

45
00:11:22.710 --> 00:11:50.940
Gabor Szabo: to see how can we use configure? Ci job. So let's get to the slides. Maybe I have some things here that I forget otherwise. So 1st of all, what is Gitlab Org? That's the that's the Open source project, the complete Devops platform, all kind of things. So they provide all kinds of things that allow you allow you as a company to work.

46
00:11:52.220 --> 00:12:02.219
Gabor Szabo: That's gitlab gitlab.com is again gitlab.org sort of it actually redirects to github.com these days, I think. But gitlab.com is the

47
00:12:02.320 --> 00:12:16.669
Gabor Szabo: hosted version of this Open Source Project, where you can have an account and host your Gitlab Repository git Repository there and then. They include

48
00:12:16.990 --> 00:12:27.699
Gabor Szabo: many services, like issues like they call the merge request instead of pull, requests similar idea what you have in Github.

49
00:12:28.540 --> 00:12:33.339
Gabor Szabo: and they also provide these what they call pipelines that you can

50
00:12:33.700 --> 00:13:01.650
Gabor Szabo: do some configuration, and then on every event, let's say on. Every time you push out some code they will fire up some virtual machine inside. There they fire up, probably a docker container, and in there they will execute the code that you tell them to execute, and the most probably the most common thing to do is this, is to run your compilation. If your language needs compilation

51
00:13:01.650 --> 00:13:15.189
Gabor Szabo: and run your unit tests or integration tests, or whatever you you need, and then people can go on with this and even deploy their code. Or if you are writing an open source.

52
00:13:15.646 --> 00:13:33.430
Gabor Szabo: cpan module, then you might configure it, to upload, to pose, and eventually to cpan your library. Once it passed all the tests. Let's say, okay, so you can. You can. You could do that. I I never actually did that part the the Ci. The

53
00:13:33.870 --> 00:13:38.830
Gabor Szabo: CD part of this. So releasing to Cpam.

54
00:13:39.450 --> 00:14:05.880
Gabor Szabo: But it's okay. This is just an advertisement for someone who is running the local. Actually, it's not just local. He's running also globally. This company provides all kind of the service around all kind of open source technologies, including gitlab. So in case you need professional support, then maybe that's where you go. And then if you go there and help you. Please tell him to

55
00:14:06.000 --> 00:14:09.600
Gabor Szabo: and give me whatever percentage is. Anyway.

56
00:14:11.830 --> 00:14:30.469
Gabor Szabo: he's nice to me, usually. So it's okay. So ci continuous integration, the idea there is that you have hopefully some tests in your code base. And then you would like to make sure that every time you or someone else makes a change

57
00:14:30.470 --> 00:14:58.229
Gabor Szabo: in the code base. Then all these tests are running. Now again, if your language is also compiled, then you even need to compile it. And back in the old, good old days we had the nightly nightly builds. So once in a once a day, or once a night, actually everything was built, and then by the next morning you'll find out that there you forgot a semicolon somewhere, and the compilation failed.

58
00:14:58.240 --> 00:15:24.210
Gabor Szabo: The idea, because behind continuous integration, is that it happens all the time continuously. So on every push. And then, if you work like, I do that you do very frequent small changes and small commits, and then you frequently push that out to whatever cloud service you have. Then you will get. You will have a very fast

59
00:15:24.260 --> 00:15:45.330
Gabor Szabo: feedback loop, so we'll find out about any issues you might cause you or your coworkers cause very fast. Now, when you are more than one people, then the integration part is that if someone makes a change and you make a change, and even though they may maybe both changes in themselves

60
00:15:45.430 --> 00:16:02.559
Gabor Szabo: by by themselves, are good and correct, but once you combine them, they fail. Now, continuous integration will integrate these things and find out the problem much faster than than if you were waiting for the nightly build.

61
00:16:03.460 --> 00:16:08.920
Gabor Szabo: Okay, so this is sort of theory, part of this. And my buttons stop functioning.

62
00:16:10.110 --> 00:16:22.089
Gabor Szabo: Yeah, okay? Now, it moved some links to the documentation in case you're interested. So there are quite a lot of documentation. Actually, one of the nice things about Gitlab is that one of the

63
00:16:22.660 --> 00:16:26.040
Gabor Szabo: few companies that are

64
00:16:26.370 --> 00:16:46.949
Gabor Szabo: or they were originally distributed, so they didn't have any offices. I don't know if they're they have now something somewhere, so maybe they bought the company. I don't know, but the last time I I heard read about them is that they were totally distributed in some 60 or 70 countries. They had employees, and everyone was working from

65
00:16:47.160 --> 00:17:09.499
Gabor Szabo: home, or some office they rented or whatever. And so they document a lot. Okay, that's the sort of the connection that they that's why their documentation. That's probably part of the reason why their documentation is good, because they know that their real way to communicate between all these people is writing down whatever

66
00:17:09.630 --> 00:17:16.270
Gabor Szabo: needs to be communicated because they are in different time zones. They work at different hours whatever.

67
00:17:17.060 --> 00:17:24.039
Gabor Szabo: Specifically, there is a link to the to the documentation of Github pipelines as well. Actually, let's go there.

68
00:17:25.859 --> 00:17:31.219
Gabor Szabo: Hi, Hi, hi, hi, yeah, okay, let's open this one.

69
00:17:31.340 --> 00:17:35.840
Gabor Szabo: So I I'm not sure. And there's lots of words here. Okay?

70
00:17:37.040 --> 00:17:45.111
Gabor Szabo: And yeah, it's may. It's it's it's difficult to. So Mark says it's it's it's difficult to maintain.

71
00:17:45.740 --> 00:17:51.010
Gabor Szabo: And a self hosted version of gitlab. Yeah, I don't. Didn't have the

72
00:17:51.150 --> 00:18:00.089
Gabor Szabo: luck, or the whatever or the bad luck of maintaining actually one. So I don't know. But yeah. And

73
00:18:00.840 --> 00:18:03.899
Gabor Szabo: okay. So runners.

74
00:18:04.430 --> 00:18:21.659
Gabor Szabo: when you configure a a job, when you write a such configuration file. And and let me actually, actually, actually, where is my terminal? Okay, so here is my terminal. We are inside the repository of of one of these.

75
00:18:21.700 --> 00:18:36.689
Gabor Szabo: a project on Gitlab that I created specifically for this presentation, and I guess I will stick. Keep it around. So I'm going to show you right away what's going on. I comment out the rest of the things here.

76
00:18:37.457 --> 00:18:48.560
Gabor Szabo: So what we have now is we have this gitlab. I show you again this Co. This file called Git dot gitlab dash ci, yaml file.

77
00:18:48.800 --> 00:19:12.930
Gabor Szabo: And inside we have lots of comments. But what we have here is this default column and then indented script and some command. So basically, we are saying that there is a job which we called default. This is an arbitrary name here, and that job runs this echo, Hello, world. Now I get, add and get

78
00:19:13.280 --> 00:19:19.179
Gabor Szabo: commit the start. Okay, I I don't have much to say, and this

79
00:19:19.880 --> 00:19:22.750
Gabor Szabo: push out. But before I push out.

80
00:19:22.950 --> 00:19:42.970
Gabor Szabo: let me find this repository. So this is the repository. I made some changes earlier today, and in this repository you will see that on the left hand side and each repository there are the pipelines, and inside. There are the jobs. So I go to the pipelines to see what's going to happen.

81
00:19:44.630 --> 00:19:52.459
Gabor Szabo: So there are lots of failed things, and we'll get to there, why they are failed, and that's the example. But now I'm going to push out.

82
00:19:52.760 --> 00:19:59.480
Gabor Szabo: and as I pushed out I can come back and hopefully it will automatically update itself. This page.

83
00:20:00.893 --> 00:20:02.980
Gabor Szabo: Maybe I reload it.

84
00:20:03.550 --> 00:20:06.519
Gabor Szabo: I help to help it by reloading it.

85
00:20:07.390 --> 00:20:14.029
Gabor Szabo: Okay, yes. Okay. So maybe it was up. It would upload update automatically. I'm not sure.

86
00:20:14.320 --> 00:20:30.348
Gabor Szabo: I used to remember that it does. But whoever okay, whatever. So it's now says that there is this pipeline which is running. This is the the commit message. This is the, I guess, the id of this pipeline job sync

87
00:20:32.795 --> 00:20:42.304
Gabor Szabo: David says that the workspaces are the coolest thing in them. Okay, but you're not talking about workspaces right now.

88
00:20:43.000 --> 00:20:44.370
Gabor Szabo: anyway.

89
00:20:45.530 --> 00:20:51.910
Gabor Szabo: So it just says that this this thing passed. I can click on this one. And

90
00:20:52.330 --> 00:20:56.587
Gabor Szabo: and and yeah, so it's re refreshes automatically.

91
00:20:58.320 --> 00:21:04.770
Gabor Szabo: Victor says, Yeah, okay. So I clicked on the on the pipeline. Here, inside. You can see the jobs.

92
00:21:08.600 --> 00:21:14.980
Gabor Szabo: And so this is the job. And you can see the output of this job and you can see it printed out, Hello, world.

93
00:21:15.110 --> 00:21:37.970
Gabor Szabo: So what happens is that and I get back to the runners. So when I push out something or there might be other events like, maybe I can do manually, or I can call some Api and run this, or I can schedule something. So there are various events. But once that event happens. Then

94
00:21:38.350 --> 00:21:49.000
Gabor Szabo: Gitlab picks up this file, reads it, and executes whatever is written in there. Now, in this one

95
00:21:51.440 --> 00:22:01.569
Gabor Szabo: we only had said we had only had a job which called default, which has a single command called Hello, Word. So what it does. It

96
00:22:01.850 --> 00:22:13.989
Gabor Szabo: starts up a virtual machine called Giglub runner. So it calls a runner, which is in this case, I'm trying to look for the information.

97
00:22:14.780 --> 00:22:26.670
Gabor Szabo: I think this is the id of this or the tag of this runner. I don't see what is the exactly. I guess this is a Linux runner here. It says it's a Linux runner.

98
00:22:26.760 --> 00:22:54.110
Gabor Szabo: Okay? And then inside it starts a virtual machine. Sorry, a docker, image docker, container, and by default it runs this ruby 3.1 docker image, and then inside that image it executes your script, and of course there are lots of other things to do, but it executes the script. One of the thing is that it clones the repository, or

99
00:22:54.440 --> 00:22:57.070
Gabor Szabo: somewhere. I

100
00:22:57.660 --> 00:23:21.250
Gabor Szabo: checking out, okay, detached head, whatever. So it gets the that gets that that specific commit. And then here it executed the the command that was in that configuration file. So that's it. Basically that we are done. Someone is writing again within Github. You need to find some way to somehow organize the projects ending up, putting custom attributes

101
00:23:21.640 --> 00:23:38.220
Gabor Szabo: not cool, in my opinion. Okay, are you sure how docker image updates? Automatically, it depends on your setup? Okay, I don't think that the update was meant about the docker. Oh, I closed it. Sorry. Wait a second. I have to open again.

102
00:23:39.160 --> 00:23:51.639
Gabor Szabo: Chat. Okay, I close the chat. Okay, I don't know if the Docker image, so I don't know if the automatic update was related to that it was about. I think the the view of the list of of

103
00:23:52.080 --> 00:23:56.679
Gabor Szabo: jobs or pipelines running anyway. So

104
00:23:57.370 --> 00:24:26.409
Gabor Szabo: back to this point, we have these runners, which is the virtual machine, I guess, or hardware, or whatever where you are running, where where these jobs can run, and then you can. The jobs are usually actually running inside a container. It's not always, but it's usually they are running inside a docker container. So and and so you have a full control of which container which container

105
00:24:26.550 --> 00:24:35.349
Gabor Szabo: it keeps. Opening the reply window, anyway, which container you would like to pick. We'll see that soon.

106
00:24:36.015 --> 00:24:44.330
Gabor Szabo: So the runner is actually there is an operating system that can run on a virtual machine somewhere you rented.

107
00:24:44.460 --> 00:24:56.899
Gabor Szabo: There's an agent on it, and then the git lobby is talking to that agent, and by default, and let me get you to this point by default, if you, if you scroll down here

108
00:24:57.380 --> 00:25:03.450
Gabor Szabo: settings in. So I'm in the project. I scroll down to the settings, Cicd.

109
00:25:04.790 --> 00:25:07.290
Gabor Szabo: And then there are the runners here

110
00:25:07.850 --> 00:25:30.520
Gabor Szabo: by default. There are lots of lots of runners that gitlab provides. If you don't say what what runner to use. Then it will use the default one, the one that we saw. Now, I guess. Okay, I don't know if maybe it's picking one. So it's picking something small and cheap, I guess, relatively, you can also use these tags to

111
00:25:30.520 --> 00:25:50.400
Gabor Szabo: to say that you would like to use some other runner, so that by default. It's a small Linux machine, but you can also get a Mac OS. You can get windows machines in order to run on them, and then, of course, you probably are interested, not using a docker image inside, but running natively on that.

112
00:25:51.490 --> 00:26:09.750
Gabor Szabo: And in that, in addition these to these runners, you can actually configure your own runner. So at quite a few of my clients. What we had is that we were using gitlab.com. So the hosted service of gitlab. But we started our own

113
00:26:11.310 --> 00:26:17.190
Gabor Szabo: machine. We I don't know in in Google Cloud or Amazon Cloud doesn't really matter.

114
00:26:17.280 --> 00:26:24.439
Gabor Szabo: So we we used set up our own machine configured it to be a gitlab

115
00:26:24.500 --> 00:26:50.749
Gabor Szabo: runner. It was included in here, so you could see here in this project, runners. We connected them, and then we could use in our jobs in this configuration to tell them to run on these specific machines. And that's good. Because then our code doesn't go to the shared machines. Well, these are still shared, but less so, I guess.

116
00:26:52.390 --> 00:27:02.159
Gabor Szabo: And you, you might have some things that you configure up upfront. You might store some data there that you need to have for your

117
00:27:02.160 --> 00:27:22.759
Gabor Szabo: for your projects, and so on. And and theoretically, you can even have that that runner inside your office. So at one company, though, that wasn't gitlab, actually, but doesn't really matter. What we had is that we had a machine and a computer. And to it we connected all kind of interesting devices

118
00:27:22.760 --> 00:27:30.360
Gabor Szabo: that were rather unique, and we had to run the tests on these devices. So Gitlab was

119
00:27:30.580 --> 00:27:47.730
Gabor Szabo: call telling this runner to run the code, run the run, the job, and that runner had these devices connected to it so it could use run the jobs actually on those devices. So it's pretty cool, because because then

120
00:27:47.840 --> 00:28:16.310
Gabor Szabo: you're still using the the cloud based gitlab service. But your runner, you're totally in control of your runner, and obviously it can also has. It can also have a price impacts on price of if you have a runner constantly up that has some cost. If, on the other hand, you are using theirs, then you probably have to pay at 1 point, if you'd like to have more time spent on their runners, and so on.

121
00:28:16.850 --> 00:28:18.549
Gabor Szabo: So these are the rudders.

122
00:28:18.780 --> 00:28:32.819
Gabor Szabo: And on top of these runners, especially on top of the Linux runners, you're going to probably use a docker image. You saw that the default is ruby something 3.1, if I remember correctly. But we'll see how to configure it.

123
00:28:34.096 --> 00:28:35.689
Gabor Szabo: Well, okay.

124
00:28:36.380 --> 00:28:45.739
Gabor Szabo: I am talking about lots of theory, and I haven't really showed you yet, anyway. So we are. We got to the point of the Gitlab Ci just

125
00:28:45.960 --> 00:28:57.329
Gabor Szabo: link to Yaml. This is the configuration file. So here is the very 1st one that we actually saw already that has some name job name. And then inside. There is this script

126
00:28:57.640 --> 00:29:05.219
Gabor Szabo: strangely, or I don't know what the default, the word default is actually a totally arbitrary user, defined

127
00:29:05.350 --> 00:29:12.559
Gabor Szabo: word. You can use anything there the script is actually, on the other hand, is a

128
00:29:13.400 --> 00:29:16.644
Gabor Szabo: What is a is

129
00:29:17.600 --> 00:29:39.659
Gabor Szabo: required field that that's what will be executed. Okay, so in this script you can put what to execute. And here this is just a shell command, but of course you can run anything there, so you could pick an image which is perl something, and then you can run your perl script there, if that's what you are interested, or any other language, if that's

130
00:29:39.660 --> 00:29:48.910
Gabor Szabo: irrelevant. So we we what we already saw the same thing in this example, where we have this default and the the script.

131
00:29:49.980 --> 00:29:59.049
Gabor Szabo: Let's go on and see a couple of more examples. So the next example, actually, before I show the next example, let me get here. I'm going to comment this out.

132
00:30:00.350 --> 00:30:12.210
Gabor Szabo: and I'll show you this. So I organize these examples, so I won't have to comment out way too many lines, and we can have each file separately. So Gitlab allows

133
00:30:12.380 --> 00:30:25.460
Gabor Szabo: this configuration to include other yaml files, both locally and from other repositories here. In this case I show them locally. So I have these files in

134
00:30:25.600 --> 00:30:35.900
Gabor Szabo: a Ci, I just called a folder called Ci. And then I have this Hello world, Yaml, file. And and I should

135
00:30:36.210 --> 00:31:00.729
Gabor Szabo: open it this way. Okay, so this is basically the same, except the string is slightly different. And the point here was to show that you can include them. Now I want to skip this because I hope that you trust that I can do this. And so I'm going to switch to the next example. So in this one, you can see that the only change, basically is that I set up.

136
00:31:00.750 --> 00:31:11.209
Gabor Szabo: I configured the image, and so I can now get add and get the Ci image. And I push it out.

137
00:31:12.280 --> 00:31:13.310
Gabor Szabo: Oh, good.

138
00:31:13.510 --> 00:31:17.080
Gabor Szabo: So let's go back to the

139
00:31:17.640 --> 00:31:25.799
Gabor Szabo: to the not this page, not the this page, but not here to the build

140
00:31:25.980 --> 00:31:41.049
Gabor Szabo: pipeline. So here I could go directly to the actual jobs. So each pipeline is divided or can be divided in separate jobs. Right now. We only had one job, so doesn't really matter. But I can go to the pipelines and then inside the pipelines

141
00:31:41.200 --> 00:31:56.239
Gabor Szabo: you will see the job. So here I have one single job. If I scroll down here, you can see there were several things running. Stay, actually, these are stages. So let's not confuse. We'll see them. The difference between them.

142
00:31:57.350 --> 00:32:00.990
Gabor Szabo: So here we have this, and this one the the

143
00:32:01.270 --> 00:32:07.429
Gabor Szabo: commit image. If I click on this one, then I will be able to see.

144
00:32:09.060 --> 00:32:17.350
Gabor Szabo: I will be able to see the output, but which is more most interesting to me.

145
00:32:17.470 --> 00:32:29.860
Gabor Szabo: is seeing the image right here. So it says that it's running on Busybox latest, which is just a very small docker container. Okay, of course, you can pick anything there.

146
00:32:31.270 --> 00:32:35.420
Gabor Szabo: Let's go here. So Hub, Docker.

147
00:32:37.660 --> 00:32:54.730
Gabor Szabo: okay? So I guess you're familiar with this. You can pick any docker container. And then this basically will. You don't really need to understand what's what to do with the docker container. You just write the comments, and it will just run inside the docker. So let's say, if I go for a perl.

148
00:32:55.150 --> 00:33:14.570
Gabor Szabo: And then there are various of these docker containers. But you can say, let's say, Perl, 5.4 0 dot 0, and then it will pick that specific docker container that has this version of Perl already installed and compiled.

149
00:33:15.720 --> 00:33:41.560
Gabor Szabo: already installed in it. And you can get all kind of different ones. Okay, so it's really. And these are pure perl things, I guess, and then there are others, the Perl test image, and all kind of other other images that already contain lots of lots of modules, so your whole job will be much running much faster, because you don't have to install all kind all those things yourself every time you run your code.

150
00:33:43.182 --> 00:33:50.540
Gabor Szabo: If anyone can remember, remembers the Perl test. What was this? Perl? I think it's called test.

151
00:33:51.130 --> 00:33:59.000
Gabor Szabo: Anyone remembers Boom, maybe, is this one I don't remember.

152
00:34:01.750 --> 00:34:04.099
Gabor Szabo: No, it doesn't look like the one.

153
00:34:04.220 --> 00:34:20.902
Gabor Szabo: anyway. If anyone remembers which which is the Docker image, what other Docker images they are suggested now these days. Let me know, please, in the chat, and then we can. I can share it also. Look, we can look at it. Okay, so this is how we pick up the

154
00:34:22.040 --> 00:34:25.929
Gabor Szabo: container. Now, this one, maybe I won't even.

155
00:34:26.190 --> 00:34:37.600
Gabor Szabo: and I can run this. This example shows that I can run in the script several commands, not just one. So if I go back to this one, I can.

156
00:34:37.830 --> 00:34:42.430
Gabor Szabo: This enable disable. So I have this run. Shell commands

157
00:34:42.659 --> 00:34:46.960
Gabor Szabo: it will do this it. Add it.

158
00:34:47.090 --> 00:34:48.239
Gabor Szabo: See I.

159
00:34:48.909 --> 00:34:50.190
Gabor Szabo: And

160
00:34:50.690 --> 00:34:58.540
Gabor Szabo: I'm not very good at writing these comic messages this time, and not that in other times I am. But anyway.

161
00:34:58.780 --> 00:34:59.880
Gabor Szabo: so.

162
00:35:00.600 --> 00:35:06.759
Gabor Szabo: okay, I'm going to close this window because I don't need it. I can click now on the jobs.

163
00:35:06.950 --> 00:35:15.310
Gabor Szabo: And then I can see the new job which is called add, which was called add, it doesn't say, here.

164
00:35:15.830 --> 00:35:19.329
Gabor Szabo: I guess. Yeah, I guess this is the output.

165
00:35:21.360 --> 00:35:34.860
Gabor Szabo: So here you can see the output of the of all those shell commands, showing all, all the environment variables that you have there the you name. So you can see exactly what types of things you have, and

166
00:35:35.010 --> 00:35:42.450
Gabor Szabo: not that it. It can be useful for debugging later on. Okay, now, next thing. So

167
00:35:43.290 --> 00:35:48.509
Gabor Szabo: here, what you can see is, we have actually 3 different jobs.

168
00:35:49.090 --> 00:35:56.280
Gabor Szabo: And in each job there is a stage. Now, earlier, you might have noticed.

169
00:35:58.280 --> 00:36:02.339
Gabor Szabo: Let's see if it says exiting stage.

170
00:36:02.460 --> 00:36:04.390
Gabor Szabo: Yeah, it says here

171
00:36:05.060 --> 00:36:12.600
Gabor Szabo: it says actually that the Cic job stage is called test. And I think also outside, you could see.

172
00:36:13.800 --> 00:36:15.390
Gabor Szabo: and

173
00:36:15.720 --> 00:36:30.659
Gabor Szabo: that the stage is called tests. So the there are various stages of your process of your Ci job that can that your Ci job can go through various steps, stages and the default. One is called test.

174
00:36:30.670 --> 00:36:46.559
Gabor Szabo: and in this configuration, and I'll just get to the to to the point of Scott in a second. In this configuration. What we have is that we have these jobs, separate jobs. And each one I put in a different stage.

175
00:36:46.790 --> 00:36:59.539
Gabor Szabo: Now, I'm probably not. It wasn't a good idea to do both of these things at the same example. So I probably should have done. Only just set the the stages. But anyway.

176
00:37:01.960 --> 00:37:05.510
Gabor Szabo: see this.

177
00:37:08.470 --> 00:37:20.470
Gabor Szabo: Okay. So while it's running. Let me look at the comment. This may be converted, covered eventually. But what's the best method for syncing the Cpa modules on a development

178
00:37:20.720 --> 00:37:24.050
Gabor Szabo: machine to a docker image.

179
00:37:24.751 --> 00:37:29.389
Gabor Szabo: Sorry. A method for syncing the sipa modules on a develop.

180
00:37:31.187 --> 00:37:35.302
Gabor Szabo: Okay, goodbye. Whoever is leaving David. Okay,

181
00:37:36.270 --> 00:37:44.079
Gabor Szabo: I'm not sure I understand your your question, Scott. And do you? You probably have

182
00:37:45.191 --> 00:37:51.660
Gabor Szabo: in. I mean you you can have. There is the default way of telling your

183
00:37:54.117 --> 00:38:01.810
Gabor Szabo: okay? So the question is, what what is the best way method to syncing the Cpa modules on the development machine to a docker image.

184
00:38:02.615 --> 00:38:11.850
Gabor Szabo: I mean, if every time I wrote any project in Perl, even if it wasn't for Cpan, it had a make file, pl, or whatever you

185
00:38:11.990 --> 00:38:21.890
Gabor Szabo: manage, or a Cpan file, where I said which versions of the modules I needed, and

186
00:38:22.370 --> 00:38:36.919
Gabor Szabo: I wasn't very strict in these unfortunately, back in those days. And per, but you can actually really fix the versions of in in the Cpan file, if I if I'm not mistaken, and then it will pull those specific versions

187
00:38:37.950 --> 00:38:58.259
Gabor Szabo: whenever you need it, and and you verify that those are the versions, and then you can. You will have to maintain these versions and upgrade them, as those modules are advancing. And as you need to upgrade them, Carton camel, someone wrote, that's the the tool. Yeah.

188
00:38:58.400 --> 00:39:12.040
Gabor Szabo: Carvel. Sorry. Carton, Carton and Carvel. Okay, I mean building up a docker image that includes the Cpa modules and development machine like how to layer the image and export the installed modules.

189
00:39:12.550 --> 00:39:18.480
Gabor Szabo: Yeah, I I don't think I'm going to get into the how to build a docker image here.

190
00:39:19.490 --> 00:39:34.649
Gabor Szabo: but I get but I think I would. I would. I'm doing the same thing. So if you really want to stick, be strict, then go with this Carton. I don't know, Carmel, but, Carton, I I do so. These tools that were mentioned

191
00:39:35.116 --> 00:39:52.013
Gabor Szabo: in the chat. Go with them. They will allow you to exactly say what version you you need, and then that's how you you use the standard perl tools to install them into your docker image. But

192
00:39:56.305 --> 00:40:03.560
Gabor Szabo: Okay. So Carmel is the same as the updated version of Carton. Okay, thank you.

193
00:40:05.930 --> 00:40:12.819
Gabor Szabo: Okay, sorry. I. I'll get to back. So we are here. And it was upgraded to

194
00:40:14.890 --> 00:40:16.780
Gabor Szabo: where is the comment? Commit message?

195
00:40:16.920 --> 00:40:23.910
Gabor Szabo: There's no commit message here because we are in the jobs. Okay, I guess. I hope that this is the right one that I wanted to look at.

196
00:40:24.070 --> 00:40:27.420
Gabor Szabo: Actually no, no, no! Go to the pipelines, Gabor.

197
00:40:27.760 --> 00:40:30.829
Gabor Szabo: that's what I wanted to show you the pipelines.

198
00:40:31.160 --> 00:40:42.770
Gabor Szabo: So yes, this was the last commit and push that I made where you had 3 jobs. Each one is in a different stage. So like, if I put the mouse here, you can actually see this is the build

199
00:40:42.870 --> 00:41:05.350
Gabor Szabo: stage. This is the test stage, and this is the deploy stage. Now, these are just names. You can do whatever you like in them, but they help you to get the idea of what you're supposed to do in each each stage. They are also dependent on each other so, and then they will go off one after the other. So now, if I click on the

200
00:41:05.350 --> 00:41:21.409
Gabor Szabo: pipeline itself here, you can see the drawing clearer, and then you can get into each one of them and see the details detailed output of each one of them, and so and they are dependent on each other one. So if the build fails. Let's say, then, the test won't run.

201
00:41:21.540 --> 00:41:30.155
Gabor Szabo: and be it test. Deploy. That might be good naming convention for a more compiled

202
00:41:31.650 --> 00:41:42.939
Gabor Szabo: language, whatever even inside Perl, you might have separate some part of the commands into the build phase, and some, let's say in the build phase you put in all the

203
00:41:43.573 --> 00:41:55.980
Gabor Szabo: I thought about putting all the all the prerequisites. But but no. So so maybe. Okay. So here's an example you might do in the build phase. You actually run

204
00:41:56.210 --> 00:41:57.490
Gabor Szabo: the unit tests.

205
00:41:57.690 --> 00:42:10.509
Gabor Szabo: create your image, create your Cpap module, upload it somewhere as an artifact. And in the test phase you use it as an already created

206
00:42:10.670 --> 00:42:20.429
Gabor Szabo: and the zipped thing. So there you are! Actually you sip and install your own, the new release of your own

207
00:42:20.550 --> 00:42:21.620
Gabor Szabo: module

208
00:42:22.010 --> 00:42:32.990
Gabor Szabo: before not not not before even you upload it to Cpan. So this way. And actually, I have somewhere. But I think I did it for gitlab. The same idea.

209
00:42:33.470 --> 00:42:39.559
Gabor Szabo: I didn't do it for so I did it for Github, not for gitlab. So in the build phase I was

210
00:42:39.730 --> 00:42:49.579
Gabor Szabo: running the perl, the make test and the make and the make. This. It created a zip file that zip file. I

211
00:42:49.780 --> 00:43:08.190
Gabor Szabo: stored it under the artifacts of Github in that case, but also in gitlab. It stores it somewhere in the in its cloud. And in the test I would have several jobs on different versions of Perl, maybe even on different operating systems.

212
00:43:09.260 --> 00:43:28.560
Gabor Szabo: and they would use download that that zip file which is your module. And even if you're running it inside, if you're doing it in a company, and it's not public. That's fine. You can still package everything up as if it was a Cpa module, and then

213
00:43:30.170 --> 00:43:37.010
Gabor Szabo: install that and run the test of that, and it will pull in all the supposed to pull in all the dependencies.

214
00:43:37.722 --> 00:43:58.370
Gabor Szabo: Okay, and then the deploy would. I don't know. Maybe if everything works fine. The deploy would in this case, if it's a Cpa module would push it out to Cpap, or if it's something that you want to deploy. Then it would deploy, do the deploy. Okay, but that's just naming just a default naming convention.

215
00:43:59.640 --> 00:44:03.589
Gabor Szabo: And so this is what what we had here.

216
00:44:04.100 --> 00:44:13.349
Gabor Szabo: What time, is it? 15 already? So almost 3 quarter for an hour. I also have been talking way too much. Okay, manual stages.

217
00:44:13.710 --> 00:44:26.669
Gabor Szabo: Okay. So we saw the default stages. But you might not like these. Build, test deploy words so you can define your own stage names.

218
00:44:26.750 --> 00:44:54.617
Gabor Szabo: And so you have a keyword called stages. Then you list the names of the stages you like, let's say, prefer linked compile, unit test, integration test, acceptance test deploy okay, or whatever stages you would like to have. And then you can create jobs and associate each job with one of the stages. Or maybe you have several jobs associated with the same stage, so

219
00:44:55.270 --> 00:45:01.430
Gabor Szabo: I won't run this now, I think I I if I'm not mistaken, I already have it. The image here

220
00:45:02.430 --> 00:45:14.370
Gabor Szabo: and there is a slide. I didn't cover, so I'll get back to it in a second. So define your stages, and then it will look like this, so it will have this one after the other.

221
00:45:14.820 --> 00:45:37.459
Gabor Szabo: but I get back to the stage, to the slide. So you have the hierarchy of these words or names or entities. There's the pipeline in the pipeline there are stages, one after the other. In each stage you might have multiple jobs for each stage that will run in parallel or can run in parallel. Each stage

222
00:45:37.970 --> 00:46:00.069
Gabor Szabo: can have one or more jobs. Okay? And even if you define at the stages, you don't have to fill all the stages. Okay, so it will. If there are, there are stages that don't have any associated job, then then, okay, there is no. So and this is the association. So for inside the job you tell what stage it belongs to.

223
00:46:01.080 --> 00:46:10.220
Gabor Szabo: And then there are the scripts. So each of these jobs have a an entry called script, which runs something. Okay.

224
00:46:13.360 --> 00:46:14.580
Gabor Szabo: next one

225
00:46:15.410 --> 00:46:28.399
Gabor Szabo: parallel jobs. Oh, good one. So this one, how does it look like? And I got back to the default naming. So here I have a I called Build. Job is in the build stage.

226
00:46:28.400 --> 00:46:47.070
Gabor Szabo: Then I have a test job, a unit test job, an integration test job and an access test job. And they are all in this test stage, meaning that they will run in parallel. Okay, now, that might be a good idea a bad idea. It's up to you what is the right

227
00:46:47.130 --> 00:47:05.349
Gabor Szabo: hierarchy or order of these things? Because if you run them one after the other, it has the advantage that if the unit tests fail, you don't waste your resources on running the integration tests. Let's say, on the other hand, it will. The total time

228
00:47:05.470 --> 00:47:12.069
Gabor Szabo: will be longer, because this runs linearly. If they run in parallel, then maybe

229
00:47:12.230 --> 00:47:18.819
Gabor Szabo: the unit test fails and you wasted some time and energy on running the exit test at the same time.

230
00:47:19.210 --> 00:47:25.149
Gabor Szabo: But if everything passes, then the total time will be shorter. So that's

231
00:47:25.770 --> 00:47:50.730
Gabor Szabo: up to you. You can also have different types of tests running in parallel that can be also good. So you will. You might divide your tests, your unit tests into separate groups and then run them in parallel to make sure that again that they will run faster and you get the things done faster. So hopefully I have the slide already. With that.

232
00:47:53.910 --> 00:47:54.940
Gabor Szabo: I don't.

233
00:47:56.340 --> 00:48:03.410
Gabor Szabo: Apparently I don't. Okay. I'm sort of mixing these things up a little bit, anyway. So let's run this

234
00:48:04.100 --> 00:48:07.870
Gabor Szabo: and to see how it works. Okay, hit. Add

235
00:48:09.030 --> 00:48:13.930
Gabor Szabo: wrong. Git, add git ci windows. M cool.

236
00:48:16.880 --> 00:48:22.749
Gabor Szabo: I hope that I put the correct number of l's in that word in the right places.

237
00:48:24.160 --> 00:48:30.269
Gabor Szabo: Bit longer. Just let me just open this file. So

238
00:48:31.520 --> 00:48:34.819
Gabor Szabo: now, if I go to the pipelines.

239
00:48:37.760 --> 00:48:45.195
Gabor Szabo: it will show me that it's running C 3 stages in this one and

240
00:48:46.510 --> 00:49:12.780
Gabor Szabo: right? So you can see that in the builds there is the build stage. It's running, and once the build stage is ready. Then the 3 test stages that are in parallel. They all start to run. Now I don't know what is the limit. I guess there is some limit in the definitely in the free version, I'm using the free version of gitlab. But I guess if you pay, then you can have more of these running at the same time.

241
00:49:13.346 --> 00:49:18.763
Gabor Szabo: And I'm quite sure that there is some total time limit and and whatnot.

242
00:49:19.330 --> 00:49:20.580
Gabor Szabo: I don't. I don't.

243
00:49:21.250 --> 00:49:34.009
Gabor Szabo: Recently I don't build that that much with it. So anyway. So then, once you have, then you might have 2 different deployed jobs once the tests are have passed. So that's how you can run things in parallel.

244
00:49:34.330 --> 00:49:41.799
Gabor Szabo: And what else? What is the next thing here? The next thing is manual interaction.

245
00:49:43.630 --> 00:49:48.529
Gabor Szabo: Okay, so this is not the right one here in the slides.

246
00:49:52.850 --> 00:50:02.350
Gabor Szabo: Yeah. So there is a slight mix up between the slides and the order of the the examples I have in the file because the parallel jobs you can see here

247
00:50:02.917 --> 00:50:16.710
Gabor Szabo: in the slides. So let's let's see the next one in the slides. It's called jobs. So here, what we have is that in each job, so far, we had entry code.

248
00:50:18.570 --> 00:50:19.630
Gabor Szabo: It's not

249
00:50:23.150 --> 00:50:31.826
Gabor Szabo: okay. That's not what I okay. So each job forget about the slide for a second the each job we had.

250
00:50:32.780 --> 00:50:37.890
Gabor Szabo: let's see this one for each job.

251
00:50:39.010 --> 00:50:41.420
Gabor Szabo: We had a field called script

252
00:50:41.870 --> 00:51:10.990
Gabor Szabo: with some commands, but you can also add the before script, and then after script, and these are steps executed in this job, obviously before the script runs, and after the script drops, runs, and the interesting part, or the valuable part of it. Or why would you want to separate is because you probably put in the before script. Drop all the setup so think about is the setup and the tear down of the

253
00:51:11.190 --> 00:51:12.020
Gabor Szabo: job.

254
00:51:12.140 --> 00:51:23.589
Gabor Szabo: So you probably put in the before script all the installation of the dependencies. So you're not. That's not your test, but if that fails, you don't want to run your test because

255
00:51:23.950 --> 00:51:37.450
Gabor Szabo: but you would like to see, probably known separately, that whether your before script part stopped broke, or if your actual test, which is in the script part, or the main thing.

256
00:51:37.710 --> 00:51:53.690
Gabor Szabo: The after script is interesting, because that will run even in this case, when you see that the main script actually fails. So here on purpose. I wrote some spell script that will

257
00:51:53.910 --> 00:52:03.199
Gabor Szabo: exit with an exit code which is not 0, meaning that the Ci job will see it as a failure. So get add.

258
00:52:03.350 --> 00:52:12.720
Gabor Szabo: it's CI fail. This thing is just an alias for me. It love

259
00:52:12.950 --> 00:52:19.230
Gabor Szabo: for keep. Forgetting to that. I need to stay in the editor pipelines.

260
00:52:20.150 --> 00:52:27.160
Gabor Szabo: It was still blue, because I don't know why it didn't update properly. But now you can see this. This runs

261
00:52:27.670 --> 00:52:34.580
Gabor Szabo: and we can wait a little bit. Now. In the meantime, let's let's yeah. Okay.

262
00:52:39.820 --> 00:52:40.720
Gabor Szabo: Okay.

263
00:52:40.970 --> 00:52:55.500
Gabor Szabo: I'm getting getting to the almost an hour I've been talking so soon. I guess I'll have to finish, even though I wanted really to see one of the one of the examples. Let's in the meantime see? So what's going on here.

264
00:52:55.990 --> 00:53:07.360
Gabor Szabo: So just to concede. You can see the before script is Cpan. And this recommends no test. Manila. Okay, whatever installs Manila. And then it has various jobs.

265
00:53:07.460 --> 00:53:32.990
Gabor Szabo: Okay for the test stage, and it says in apparently it uses images, different versions of Perl. So this is the that image that I was looking for earlier, so that I mentioned that there is a Perl image with all kind of modules already inside, specifically for testing. So this is what is being done here before the script. So just to be clear

266
00:53:33.670 --> 00:53:37.100
Gabor Szabo: is my explanation. Let's get get back here

267
00:53:37.800 --> 00:53:48.540
Gabor Szabo: in this example. What we had that we had a job called default, and inside the job we had a before script, a script, and then after script.

268
00:53:50.720 --> 00:54:16.010
Gabor Szabo: This, in this case, outside of the jobs, there is a before script, which means that this will run before each one of the jobs. So basically, this before script is inherited by each one of the jobs you could overwrite it so you could have your own before script in one or more specific jobs. But if you want to have the same before script

269
00:54:16.030 --> 00:54:27.320
Gabor Szabo: for every job. Then this is what you do outside of it. You say this is the before script, and then you have these jobs, and in these jobs you can see that they are all in the test stage.

270
00:54:27.400 --> 00:54:36.259
Gabor Szabo: running on different versions of Perl. And it just runs mineral tests on each one of them. And that's it. Okay, that's the whole story here.

271
00:54:36.550 --> 00:54:44.230
Gabor Szabo: Okay, so it's not a very complex setup it uses, but it's a it's a nice one. Let's go to another one.

272
00:54:45.020 --> 00:54:50.959
Gabor Szabo: This is the game entities. I have no idea. What is this? Well, it looks a way more.

273
00:54:55.100 --> 00:54:59.793
Gabor Szabo: Oh, okay, there are some interesting things here.

274
00:55:00.510 --> 00:55:23.379
Gabor Szabo: so this is the job. It has some rules when to run. Okay, run always, but only if the condition is a merge request event. Okay, so by default. I think it only runs when you push out something, when you can say when, and you can say always, and then you can have these if statements, saying, Oh, but only if the

275
00:55:23.380 --> 00:55:34.819
Gabor Szabo: environment variable, ci pipeline source is merge request event, so it only runs on merge. Request this this workflow, and then there's another condition.

276
00:55:34.990 --> 00:55:40.943
Gabor Szabo: If the commit branch is the default branch of the project. Okay,

277
00:55:41.600 --> 00:55:53.700
Gabor Szabo: and then each one has some variable set, and I guess later on, somewhere, maybe in the code base, they you use these variable environment variables.

278
00:55:54.462 --> 00:56:04.099
Gabor Szabo: This one allows you this dot sub notation allows you to create to reduce duplication. So

279
00:56:04.610 --> 00:56:19.810
Gabor Szabo: that's actually the nice thing in this one in the rxpr, we saw that basically, this is copy paste. Okay? So the only difference between this and this well is the name of the job and the name of the image.

280
00:56:20.010 --> 00:56:25.839
Gabor Szabo: and the so there are duplications here.

281
00:56:27.020 --> 00:56:41.119
Gabor Szabo: This one solve this duplication by saying, Okay, this is basically the job. And each one of them is using this one. Now, you could or we could.

282
00:56:41.750 --> 00:56:43.309
Gabor Szabo: Does it have a

283
00:56:44.170 --> 00:57:01.179
Gabor Szabo: yes, lovely job. Name. Okay. So the image is picked up by the name of the job. So you don't even have to have this duplication in this case. Yeah, see, the name of the job has Perl version. And then here we also have the Perl version.

284
00:57:01.180 --> 00:57:18.639
Gabor Szabo: In this one. You only have the per version here and then inside the the job. Which is this, basically this star test. I think this says that use this this thing as if it was there. So think about this as the function call or whatever.

285
00:57:18.790 --> 00:57:24.769
Gabor Szabo: And then we are using this variable name to send the image

286
00:57:25.400 --> 00:57:30.649
Gabor Szabo: very nice. Okay. So I have a lot less duplication. And if I want to

287
00:57:31.750 --> 00:57:40.880
Gabor Szabo: add or remove a version of parallel, I just do it here, and that's it. I don't need to update anything else. This one also has a

288
00:57:42.030 --> 00:57:49.520
Gabor Szabo: and then they don't know. Don't know why it's in in the in the and roots.

289
00:57:50.410 --> 00:58:10.150
Gabor Szabo: Maybe coverage is also, I don't know. Why are these? Why is this a quote this one, I guess, because they are numbers. But okay, so this is the coverage job which runs on this image before script does all these things, and the script is actually running the cover.

290
00:58:10.270 --> 00:58:17.489
Gabor Szabo: and then there, somewhere. I I don't have it now, handy, but you can also.

291
00:58:19.340 --> 00:58:33.660
Gabor Szabo: and I'm not sure about per. I used it in python. You can have the coverage reporting tool print out something, and then the Ci job in gitlab pick up the results of the

292
00:58:34.280 --> 00:58:50.569
Gabor Szabo: the cumulative or total results of the of the coverage job, and then it will show on the right hand side. I think of the if you can it can. You can collect all the coverage report and have it uploaded so you can then open it in in a browser.

293
00:58:50.830 --> 00:58:53.289
Gabor Szabo: the the web page.

294
00:58:53.580 --> 00:59:04.590
Gabor Szabo: and you can easily see what is the coverage report for each run. So you can do that. And obviously you can do what is not done.

295
00:59:04.880 --> 00:59:12.426
Gabor Szabo: Yeah, it is actually done. It's show. It's pushes out to cover else. And then you can go to the cover, else

296
00:59:13.350 --> 00:59:16.339
Gabor Szabo: service and look your coverage report there.

297
00:59:18.260 --> 00:59:26.979
Gabor Szabo: This one, any comments, questions, okay? So this one has a a globally defined image.

298
00:59:30.740 --> 00:59:34.750
Gabor Szabo: some globally defined variables.

299
00:59:36.290 --> 00:59:41.580
Gabor Szabo: It uses caching, I guess so.

300
00:59:42.190 --> 00:59:46.019
Gabor Szabo: It will save time on repeatedly installing the same thing.

301
00:59:46.310 --> 00:59:57.100
Gabor Szabo: It installs some Linux packages right with up, get update up, get install this one

302
00:59:57.690 --> 01:00:06.309
Gabor Szabo: fine, then does all kind of comments. Okay, so these are the comments done before the actually testing. But and it's done globally.

303
01:00:06.680 --> 01:00:10.110
Gabor Szabo: Then this is the unit test job

304
01:00:10.490 --> 01:00:32.070
Gabor Szabo: which has variables. This is the script. And now nice. This is the artifact. I mentioned you right that I can upload artifacts. So here they are, uploading the Junit artifacts. Let me try to see if if we can get. I'll get to that later in a second test coverage.

305
01:00:32.981 --> 01:00:46.218
Gabor Szabo: This one is the one. Okay? So I didn't even have to copy paste my one mine. So this module actually uses this. So if you run this coverage

306
01:00:47.280 --> 01:00:53.820
Gabor Szabo: run this testing with the coverage report, it will print on the screen something that says.

307
01:00:54.030 --> 01:01:03.269
Gabor Szabo: total blah blah, okay, something. And then this key will probably, if I understand it correctly.

308
01:01:03.920 --> 01:01:08.950
Gabor Szabo: get that line and report it on the, on the, on on this website.

309
01:01:09.080 --> 01:01:19.530
Gabor Szabo: And then the builds phase is just uploading the artifact. So it is quite similar to what I explained that this uploads it generates the

310
01:01:19.700 --> 01:01:28.405
Gabor Szabo: with Zill. This Zilla. It generates the the target, Gzip, and and uploads it to

311
01:01:30.470 --> 01:01:37.579
Gabor Szabo: to the artifact library. So let's take a look at where these things are. If I go and go to the

312
01:01:37.710 --> 01:01:45.499
Gabor Szabo: pipelines. Well, it hasn't been built for a long time. It it seems so. Maybe all these things were cleared. But

313
01:01:46.090 --> 01:01:48.930
Gabor Szabo: so this one, this one paused

314
01:01:51.000 --> 01:01:53.619
Gabor Szabo: 4 years ago. Pretty long time.

315
01:01:54.250 --> 01:01:57.360
Gabor Szabo: So maybe all these things were clear since then.

316
01:01:57.810 --> 01:02:01.970
Gabor Szabo: Yeah, I don't see any of the details. Artifacts are here.

317
01:02:07.290 --> 01:02:15.069
Gabor Szabo: Yeah, these are the artifacts. So this is the the released or to be released zip files.

318
01:02:15.693 --> 01:02:23.950
Gabor Szabo: I don't see the coverage report here. Maybe that was removed, or or this thing was added later. I don't know.

319
01:02:24.370 --> 01:02:30.310
Gabor Szabo: It would have been nice if we had time to actually implement one of these things.

320
01:02:30.960 --> 01:02:32.030
Gabor Szabo: So

321
01:02:32.670 --> 01:02:42.079
Gabor Szabo: okay, this is not interesting anymore. Set stage of job. Okay, we see this. So this not interesting parallel jobs we saw already.

322
01:02:42.400 --> 01:02:43.460
Gabor Szabo: and

323
01:02:44.560 --> 01:02:51.450
Gabor Szabo: I I won't show this anymore. Oh, actually I will, I will! I will! I will. So let's get get back to it.

324
01:02:52.420 --> 01:02:55.039
Gabor Szabo: So we saw the before and after.

325
01:02:56.036 --> 01:03:01.490
Gabor Szabo: We have the manual interaction which looks like this.

326
01:03:01.810 --> 01:03:10.340
Gabor Szabo: I have a bill stage. Let me run this it add, see, I, Manuel.

327
01:03:12.450 --> 01:03:17.399
Gabor Szabo: before I push it out. Did I want? Was I in the middle of something?

328
01:03:18.810 --> 01:03:19.980
Gabor Szabo: This one?

329
01:03:20.430 --> 01:03:24.709
Gabor Szabo: Yeah, this one I wanted to show you. And I forgot.

330
01:03:24.890 --> 01:03:29.040
Gabor Szabo: If you remember, this was the before after thing.

331
01:03:29.200 --> 01:03:37.010
Gabor Szabo: let me go back and show that before I go to the next example. So that was this, the before and after.

332
01:03:37.180 --> 01:03:41.099
Gabor Szabo: where the interesting part was that the script itself failed

333
01:03:41.330 --> 01:04:11.170
Gabor Szabo: on purpose in this time, but failed. So this is how it looks like it, says the echo, before you can see it, there is the perl thing that fails, and then the echo, after which also works. But the whole job fails, because the main part failed, but the after part still runs. So if you need to do some cleanup or whatever, despite the fact that the test or the the main part of the job failed. Then you can do it.

334
01:04:12.470 --> 01:04:16.870
Gabor Szabo: Okay, so let me push this out. Now, the changes

335
01:04:20.510 --> 01:04:25.870
Gabor Szabo: and this is the one that we wanted to see the manual interaction.

336
01:04:26.070 --> 01:04:37.640
Gabor Szabo: So here we have just build. Just test nothing special here. And then there is the deploy. And then the deploy. You say, Okay, it runs manually

337
01:04:37.750 --> 01:04:42.069
Gabor Szabo: so it doesn't just run, and it will

338
01:04:42.260 --> 01:04:46.440
Gabor Szabo: even look for an environment variable called name.

339
01:04:46.660 --> 01:04:50.889
Gabor Szabo: which is not defined in this script, we'll have to provide it.

340
01:04:51.060 --> 01:04:53.859
Gabor Szabo: So what happens? I go to the pipelines.

341
01:04:57.960 --> 01:05:08.279
Gabor Szabo: It runs, okay. It went through the testing phase. It runs goes to the or build. This was build, this was testing. And it's still the testing.

342
01:05:08.650 --> 01:05:11.439
Gabor Szabo: Let me click on this one. Now

343
01:05:12.820 --> 01:05:18.409
Gabor Szabo: see, it's still testing. Let's wait for a second. So when would you want to use this?

344
01:05:18.900 --> 01:05:25.030
Gabor Szabo: If your regular thing, you would like to? Okay, you want to have all the jobs to have the Ci.

345
01:05:25.400 --> 01:05:54.080
Gabor Szabo: But you don't want them to be automatically deployed. You would like to be able to manually decide which one to deploy. So now you know, you see that? Oh, this was, maybe the deploy is going to up. Be uploaded to to Cpan. Okay, so this everything is done. Okay, you are happy. And now you would like to do the deploy so you can either click here to run it, or you can click on the gear, icon

346
01:05:55.190 --> 01:05:57.270
Gabor Szabo: and provide some input.

347
01:05:57.580 --> 01:06:07.080
Gabor Szabo: And so here we can provide the name field. And here you can provide full bar and run job.

348
01:06:08.110 --> 01:06:10.600
Gabor Szabo: And now you run that job

349
01:06:12.650 --> 01:06:16.310
Gabor Szabo: and I don't have experience in how to set the

350
01:06:17.350 --> 01:06:43.619
Gabor Szabo: rights on this. But if you're alone in this project, or if you are, meaning that if you are the only owner of the project unlike in the companies where you have multiple people, then it's easy, because many people can push and you can also push. But it's only you who can type these things in. And you don't have to have that that field. Okay, I only used it so you can see that

351
01:06:44.450 --> 01:07:05.000
Gabor Szabo: that now you can see it prints it out. Because if we go back to the thing, that's what it does. Okay, it just echoes the deploy, and you can see only one more thing here that's totally unrelated. In this case I had this pipeline, and then I had several shell commands. Earlier I had this one.

352
01:07:07.380 --> 01:07:22.740
Gabor Szabo: Okay, both are fine. If I'm not mistaken, the differences is that these run in separate commands, and if I have a pipeline and like this, that it is being saved as a single file and then executed as a

353
01:07:22.930 --> 01:07:37.330
Gabor Szabo: all the commands as a single executable. So that's basically the difference. So this is to allow you to manually do something, but we can also have another one.

354
01:07:39.120 --> 01:07:41.410
Gabor Szabo: Let's see a more secretive one.

355
01:07:45.360 --> 01:07:46.860
Gabor Szabo: Let's do this one.

356
01:07:50.675 --> 01:07:54.660
Gabor Szabo: How does it look like very similar

357
01:07:54.870 --> 01:08:07.990
Gabor Szabo: build, stage, test stage fine and the same here deploy manually, but this time I don't have the no, not that I don't have. I have a constraint

358
01:08:08.110 --> 01:08:13.640
Gabor Szabo: that's saying this script should only run if

359
01:08:13.920 --> 01:08:18.970
Gabor Szabo: the user provided a variable named code

360
01:08:19.410 --> 01:08:24.219
Gabor Szabo: that if you're running the shot 256 on it.

361
01:08:25.729 --> 01:08:28.059
Gabor Szabo: Then you will get this show.

362
01:08:28.450 --> 01:08:57.189
Gabor Szabo: So I guess. And the funny thing was that this I wrote a couple of years ago, and today I wanted to make sure that everything works and well, not everything works. But it's okay. So far, I've been talking more than an hour. So quite a few things work, and I didn't remember what was the actual word, the original word that created this Shah. But after like 10 experiments, I could figure it out.

363
01:08:58.062 --> 01:09:06.729
Gabor Szabo: It's not that. Wasn't that difficult? I have very few passwords.

364
01:09:07.260 --> 01:09:12.929
Gabor Szabo: So if you go back to the pipeline.

365
01:09:18.450 --> 01:09:23.993
Gabor Szabo: okay, now we are here. Okay, this push pause. And now I can.

366
01:09:24.640 --> 01:09:47.140
Gabor Szabo: I can think. I think I can click on this one and deploy manual action. And now I have to provide it. So I have to provide. I think it's caused the. It's it's a case sensitive. And here I provide. Now this is unfortunate that I can see it in clear text. But this is the secret.

367
01:09:47.740 --> 01:09:51.800
Gabor Szabo: It's very big secret. No, it's a small, small, small secret.

368
01:09:51.939 --> 01:09:55.090
Gabor Szabo: Okay. The code was big and

369
01:09:57.280 --> 01:10:05.079
Gabor Szabo: and so it's running, and then it will hopefully work. Now, if I go back to the slides, I think I put it there.

370
01:10:05.190 --> 01:10:15.379
Gabor Szabo: Manual approval. Yeah. So the way to generate this is basically this is the you, the command on Linux. So you just run this command with your

371
01:10:15.550 --> 01:10:33.479
Gabor Szabo: secret, and it will generate the shot, and then you can save it with the notice. There is this spaces and dash here. That's part of it. So part of at least this output. I have no idea. Maybe I just made the wrong command.

372
01:10:33.680 --> 01:10:41.029
Gabor Szabo: So this way in the in the Ci, you don't need to save a clear text version of your

373
01:10:41.460 --> 01:10:48.189
Gabor Szabo: password, or whatever secret you can have a show version, and then

374
01:10:49.654 --> 01:10:58.560
Gabor Szabo: type it in in, in the in this view. And I I it's unfortunately you can't type. You can't have a

375
01:10:58.680 --> 01:11:01.370
Gabor Szabo: secret one, or maybe you can. I just don't know.

376
01:11:01.920 --> 01:11:07.880
Gabor Szabo: Anyway, it succeeded. Okay, it it actually

377
01:11:09.920 --> 01:11:22.679
Gabor Szabo: it printed out the secret because I asked it to do. You probably don't want to do that. I just wanted to verify it for myself here, and it verified this condition, and everything was fine. So the job went on.

378
01:11:24.590 --> 01:11:32.950
Gabor Szabo: okay, and I keep closing it. It. Editor, I don't know why this was

379
01:11:33.410 --> 01:11:53.800
Gabor Szabo: pick runner. Okay? So I showed you how to that. There's a list of runners. This is how you can pick the runner. Okay, you say tags. And then you give it the name or names of the of the tags that that were there. If we go back, I think here in the configuration settings.

380
01:11:55.350 --> 01:11:56.930
Gabor Szabo: Cicd.

381
01:11:58.580 --> 01:12:01.160
Gabor Szabo: Yes, the secret is secret in this case.

382
01:12:01.850 --> 01:12:04.759
Gabor Szabo: and it's a very secret secret.

383
01:12:05.300 --> 01:12:18.474
Gabor Szabo: So these are the the runners that are available. So you can put the the tags. These are the tag. No, the blue ones are the tags, so you can put the blue ones there and

384
01:12:19.650 --> 01:12:38.970
Gabor Szabo: and then it will pick the right thing. And then just notice that this windows one. It's actually running natively on windows. So so your comments and that was a little confusion for me. It actually runs very slow, very slow. It takes a lot more time to start such a virtual machine than starting the Linux ones.

385
01:12:39.160 --> 01:12:41.699
Gabor Szabo: I don't know whether it's because

386
01:12:42.430 --> 01:12:53.769
Gabor Szabo: they're not running up front or or or it just takes longer. I don't know, anyway, so you can see here that I have 2 jobs, and one of them is running on windows, another one on on Mac OS.

387
01:12:54.030 --> 01:13:10.690
Gabor Szabo: Not that interesting. I won't try to show it, especially because it didn't work last time I tried, and there are some to do items here that I wanted to show. Actually, this one. I can show you the explanation here there was a

388
01:13:11.290 --> 01:13:22.979
Gabor Szabo: I copied it from some, from some job at the at the client. What we had here is that we had to run sometimes a specific job manually

389
01:13:23.080 --> 01:13:24.280
Gabor Szabo: to clean

390
01:13:25.033 --> 01:13:50.470
Gabor Szabo: the runner. Okay, remove all kind of files that were were there, and instead of going Ssh into the to the runner or own private runner. We had this job that would work, and it would work if the user provided a variable called clean runner with whatever value, which is not 0. So just cleaner runner one. Or if

391
01:13:50.590 --> 01:13:52.920
Gabor Szabo: any of these files changed.

392
01:13:53.330 --> 01:14:11.409
Gabor Szabo: okay, so we had a docker file because it was python. So we had a requirements and constraints file, and the which is like the the list of the requirements list of the dependencies and the pipeline itself. So in these cases it should run, and then

393
01:14:11.710 --> 01:14:23.149
Gabor Szabo: the rest is just doesn't really matter. Okay, so and it was running on our shell runner. So in our runner, we had one that was running inside a docker, and

394
01:14:23.330 --> 01:14:34.400
Gabor Szabo: 2 configurations, one that allowed us to run inside the container, and the other one that allowed us to run natively on our Linux box, and so this was called the shell runner.

395
01:14:34.650 --> 01:14:39.740
Gabor Szabo: And so these commands were running on. The native system

396
01:14:41.360 --> 01:14:44.220
Gabor Szabo: in this case is cleaning up all kind of things.

397
01:14:44.840 --> 01:15:04.080
Gabor Szabo: The details are not that important? The details of the script? What is important that we have to have these conditions that you can you can use. And then this one, I guess I have to find the slides because I couldn't finish the preparations. But we don't even have the time for that, either.

398
01:15:05.740 --> 01:15:07.640
Gabor Szabo: This one is the link.

399
01:15:08.140 --> 01:15:09.330
Gabor Szabo: So.

400
01:15:11.440 --> 01:15:21.799
Gabor Szabo: and let me show it a little bit here with the, with the documentation, so you can if you have, like, just a plain perl script that you want to test.

401
01:15:21.930 --> 01:15:23.520
Gabor Szabo: Nothing interesting.

402
01:15:23.700 --> 01:15:34.610
Gabor Szabo: You can do whatever we did so far. You just run, perl, make file, make, make test, and so on. Regular things. But what if you need to run your

403
01:15:34.900 --> 01:15:36.350
Gabor Szabo: and maybe that's the

404
01:15:41.280 --> 01:15:44.130
Gabor Szabo: yes. The Dbb mocking, is it?

405
01:15:46.710 --> 01:15:50.059
Gabor Szabo: No, I don't have a story. No, it's because it's mocking.

406
01:15:50.260 --> 01:15:53.390
Gabor Szabo: Okay, I don't have anything interesting here. I think.

407
01:15:55.460 --> 01:16:24.080
Gabor Szabo: No, this is not interesting, not more interesting that we already had earlier. So back to the stages. So maybe you need an actual postgres SQL. Database in order to run your test because you're running the DVD Pg, okay, which is actually on Github, and it has it, I think, already the Ci. Because I configured it. But whatever here, let's say you have some project that runs on postgres.

408
01:16:24.140 --> 01:16:28.619
Gabor Szabo: or there are a couple of other examples. It doesn't really matter what

409
01:16:28.750 --> 01:16:32.919
Gabor Szabo: anything that can run inside a docker. Okay? So

410
01:16:33.150 --> 01:16:51.180
Gabor Szabo: you can configure. Say, okay, default. This is the name of the job. And then that job has a service which is called postgres. So what will happen is that before running your job, or job, or any there before running this specific job.

411
01:16:51.440 --> 01:17:02.650
Gabor Szabo: and you before running your specific job, Gitlab will start a separate machine, basically. So separate docker container

412
01:17:04.500 --> 01:17:08.329
Gabor Szabo: on postgres. SQL, so this image

413
01:17:08.510 --> 01:17:19.669
Gabor Szabo: you will probably define some parameters. And then in your program, you will be able to access using the name postgres

414
01:17:20.260 --> 01:17:21.690
Gabor Szabo: that machine.

415
01:17:21.860 --> 01:17:28.809
Gabor Szabo: Okay? So you will have an actual postgres machine running next to your pearl code.

416
01:17:28.930 --> 01:17:37.469
Gabor Szabo: And so we can access that, and you can do it. It has explanations for Mysql. Postgressql readis.

417
01:17:37.660 --> 01:17:38.575
Gabor Szabo: But

418
01:17:39.770 --> 01:17:44.049
Gabor Szabo: And I don't know gitlab as a micro service. I have no idea. What is this?

419
01:17:44.950 --> 01:18:11.230
Gabor Szabo: I guess I I haven't. Yeah, I'm not guessing, really, because we do use it. And in in our, at one of my clients I just couldn't demo it here yet. I couldn't finish the demo. You can use anything. So we are using, for example. And I think here. I had the the beginning of it. I haven't finished the part we have. Mongodb. Okay? So it just says, Okay, run this.

420
01:18:12.565 --> 01:18:13.730
Gabor Szabo: image.

421
01:18:14.150 --> 01:18:20.010
Gabor Szabo: Okay, start it up, and this is going to be the name of it, and then

422
01:18:20.920 --> 01:18:33.019
Gabor Szabo: I don't have the rest of the code, which is a real job that should access this Mongodb server. Okay? And and so then you can. Code can use

423
01:18:33.260 --> 01:18:41.372
Gabor Szabo: one or more real services. And if you have several

424
01:18:42.751 --> 01:19:00.209
Gabor Szabo: services yourself. So not just these external ones. But your architecture is the micro service architecture. Then you're testing one piece, but maybe the others are, or the others are already available should be available for you

425
01:19:00.740 --> 01:19:10.280
Gabor Szabo: as a docker image. And so you could just need to configure to be so. This thing will be able to download that image which is another

426
01:19:10.400 --> 01:19:30.429
Gabor Szabo: set of things. But we don't go in, and then you can, if you download your the images of all of your micro services. And then you're testing one of these services against all of the rest of the system. So this is just a demo of of the Demo.

427
01:19:30.900 --> 01:19:34.379
Gabor Szabo: and that's it, I think.

428
01:19:34.840 --> 01:19:36.460
Gabor Szabo: And

429
01:19:36.770 --> 01:19:45.690
Gabor Szabo: do I have anything interesting? So it's a little bit of work to get this done to get it working. But but it's it's it's it's doable.

430
01:19:46.304 --> 01:19:55.500
Gabor Szabo: Yeah, the slide is empty. This I have already showed you a different way the before and after party.

431
01:19:57.040 --> 01:20:03.059
Gabor Szabo: You can have some variables defined globally or per job

432
01:20:03.840 --> 01:20:09.900
Gabor Szabo: or get it from the user. The extending is, we saw it in one of the examples that

433
01:20:11.520 --> 01:20:12.205
Gabor Szabo: that

434
01:20:13.975 --> 01:20:24.600
Gabor Szabo: basically, we have these jobs, and they are all extended with these information. So you can reuse the script part. And we saw this earlier.

435
01:20:25.210 --> 01:20:26.820
Gabor Szabo: And

436
01:20:31.490 --> 01:20:33.260
Gabor Szabo: yeah, but

437
01:20:34.980 --> 01:20:51.720
Gabor Szabo: yeah, so there is a docker hub that we saw where you have the public docker images gitlab. Also have its own registry. So the docker registry, so you can use that for your for your needs.

438
01:20:53.110 --> 01:20:59.169
Gabor Szabo: yeah, I guess. Oh, I didn't try this one. Apparently. I have this so it can how to run on on windows.

439
01:21:00.350 --> 01:21:07.800
Gabor Szabo: I haven't tried it recently, and these slides were created. The just a second.

440
01:21:08.420 --> 01:21:20.310
Gabor Szabo: But these slides were created couple of years ago, and I updated only the 1st few part of the slides and then wrote those examples. So I'm not sure about this.

441
01:21:20.430 --> 01:21:26.579
Gabor Szabo: And apparently this is old, because since then Mac OS is available.

442
01:21:26.970 --> 01:21:35.120
Gabor Szabo: And yeah, these are some questions. Anyway, let's go back to here and

443
01:21:35.710 --> 01:21:41.530
Gabor Szabo: and that's it. I think I I'm I'm way past what I planned

444
01:21:41.680 --> 01:21:45.600
Gabor Szabo: any questions before I finish the video.

445
01:21:49.180 --> 01:21:51.500
Gabor Szabo: Well, I can smile at you like this.

446
01:21:51.900 --> 01:22:03.129
Gabor Szabo: Any questions. I guess everyone or I either fell asleep already or ran out of questions. I can now stop the video now and then. We can

447
01:22:03.400 --> 01:22:17.953
Gabor Szabo: keep have some conversation, if you like for so for now thank you very much for all the people who participated and remained here. Most of the people, apparently we are like 18 now we started out, I think 22 and

448
01:22:18.530 --> 01:22:42.479
Gabor Szabo: those people who are watching the video, please. Also, you who watch live later on, go to the Youtube Channel when I upload it and like the video and follow the channel and let other people know that helps me get the word out. And it also encourages me to to make more videos and more presentations. So thank you very much. And

449
01:22:42.570 --> 01:22:49.379
Gabor Szabo: again, just like the video and follow the channel. Thank you very much, and bye bye.

