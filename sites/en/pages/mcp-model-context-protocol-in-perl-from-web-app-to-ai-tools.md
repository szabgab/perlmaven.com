---
title: "MCP - Model Context Protocol in Perl: From Web App to AI Tools with Dave Cross"
timestamp: 2026-10-21T07:40:02
published: true
description: ""
archive: true
show_related: true
---

## Description

The Model Context Protocol (MCP) has rapidly become the standard way for AI assistants to interact with external applications. But how do you add MCP support to an application that already exists?

In this practical workshop we'll take a real Dancer2 application and add an MCP server that exposes its existing functionality to AI clients. Along the way we'll look at the MCP protocol, JSON-RPC, tool discovery, schema design and request handling, while keeping the implementation cleanly separated from the application's existing business logic.

We'll see how a YAML-driven design allows a single source of truth for tool definitions and documentation, and why adding MCP often turns out to be far less work than you'd expect when your application's architecture is already sound.

By the end of the session you'll understand the MCP protocol, know how to implement an MCP server in Perl, and have a design you can adapt to your own applications.


## Speaker:

[Dave Cross](https://www.linkedin.com/in/davorg/) has been writing Perl professionally for more than thirty years. He is the author of several Perl books, including Data Munging with Perl (Manning) and Perl Template Toolkit (O'Reilly), and has been speaking at Perl conferences around the world since the late 1990s.

He builds web applications with Dancer2, contributes to open source, and has recently been exploring how established Perl applications can integrate with modern AI technologies such as the Model Context Protocol (MCP). His Line of Succession website now exposes its data through an MCP server, allowing AI assistants to query Britain's royal succession directly from the site's underlying database.

Dave believes the best way to learn a new technology is to build something real with it, and this workshop is based on exactly that experience.

## Length

1 hour


## Slides

Slides and other stuff available on the talks site of Dave Cross:

[Model Context Protocol in Perl: From Web App to AI Tools](https://talks.davecross.co.uk/talk/model-context-protocol-in-perl-from-web-app-to-ai-tools/)

{% youtube id="st_tZs5AJ0c" file="mcp-model-context-protocol-in-perl-from-web-app-to-ai-tools-by-dave-cross.mp4" %}


## Transcription

00:00:03.000 --> 00:00:15.000
Excellent. So welcome to the Code Maven channel. If you are watching on the YouTube, if you are here, thank you. Really. I'm so many people joined us.

00:00:15.000 --> 00:00:31.000
You are lucky because you can ask questions and we had a chat earlier, and you're going to have a chat after the presentation. But for now, let's welcome Dave Cross. Thank you very much for agreeing to give this presentation, although probably everyone in the Perl community knows you.

00:00:31.000 --> 00:00:35.000
We start with some introduction and then go ahead, the stage is yours.

00:00:35.000 --> 00:00:40.000
Okay, well, thanks for asking me to do this presentation.

00:00:40.000 --> 00:00:50.000
Yeah, so as Debor said, I'm Dave Cross. I've been using Perl for, I think it's probably 30 years now.

00:00:50.000 --> 00:00:52.000
Um, I…

00:00:52.000 --> 00:01:01.000
I worked for a huge number of different companies because I was a freelancer for the longest time.

00:01:01.000 --> 00:01:08.000
working for banks and startups and places like the BBC and The Guardian.

00:01:08.000 --> 00:01:13.000
But if you've been to a Pearl conference, particularly in Europe,

00:01:13.000 --> 00:01:17.000
Over the last 25 years or so, there's a good chance you've.

00:01:17.000 --> 00:01:22.000
seen me give a talk. I've written a few books.

00:01:22.000 --> 00:01:32.000
Um, most well known is probably data munging with Perl, and I should probably mention that there's a second edition of that.

00:01:32.000 --> 00:01:34.000
about.

00:01:34.000 --> 00:01:38.000
the next month, probably in a month's time.

00:01:38.000 --> 00:01:45.000
But yes, so today we are going to talk about.

00:01:45.000 --> 00:01:50.000
The model context, protocol, specifically putting it.

00:01:50.000 --> 00:02:00.000
on the front of an existing Perl application and the application that I chose to do it with was my.

00:02:00.000 --> 00:02:02.000
British royal…

00:02:02.000 --> 00:02:05.000
family line of succession website.

00:02:05.000 --> 00:02:14.000
But by the way, Dave, I think we are seeing the snipping tool on your screen. I'm not sure if that was the intention.

00:02:14.000 --> 00:02:16.000
Or it's my screen, I'm not worried. No, it's not.

00:02:16.000 --> 00:02:19.000
Uh, oh, hang on.

00:02:19.000 --> 00:02:20.000
Maybe.

00:02:20.000 --> 00:02:26.000
Maybe we are seeing a different screen that you wanted to share.

00:02:26.000 --> 00:02:30.000
Okay, let me see if I can.

00:02:30.000 --> 00:02:46.000
Work out how to stop sharing.

00:02:46.000 --> 00:02:50.000
There should be some way for me to.

00:02:50.000 --> 00:02:55.000
Stop sharing the screen.

00:02:55.000 --> 00:03:04.000
Oh.

00:03:04.000 --> 00:03:11.000
Is that better?

00:03:11.000 --> 00:03:19.000
Can you see the Zoom screen now?

00:03:19.000 --> 00:03:21.000
I'm getting loads of thumbs up.

00:03:21.000 --> 00:03:22.000
So, okay.

00:03:22.000 --> 00:03:26.000
Okay.

00:03:26.000 --> 00:03:27.000
Let's go back to this then.

00:03:27.000 --> 00:03:30.000
I was giving you feedback, but while I was on mute. So yeah.

00:03:30.000 --> 00:03:41.000
So we're all at, yeah, I can see green lines around that screen now, so that sounds like we're in the right place. Okay, so as I was saying, I have this web app.

00:03:41.000 --> 00:03:45.000
Um, which, um, deals with the, uh,

00:03:45.000 --> 00:03:57.000
British royal family, the line of succession to the throne, which enables you to answer questions like this, who was the sovereign?

00:03:57.000 --> 00:04:06.000
On the states, who are the first five people in line to the throne, for example.

00:04:06.000 --> 00:04:08.000
Um…

00:04:08.000 --> 00:04:21.000
So what we're going to talk about is I'm going to give you a brief introduction to the existing application. We're going to talk a bit about what MCP is and how that works. We will then

00:04:21.000 --> 00:04:28.000
have a bit of a look at the code and trace how one request goes through the code.

00:04:28.000 --> 00:04:41.000
And then we will look at what I learned whilst I was doing this, and what I might want to do next. And hopefully, we will have plenty of time at the end for you to ask.

00:04:41.000 --> 00:04:44.000
Any questions?

00:04:44.000 --> 00:04:47.000
Okay, so…

00:04:47.000 --> 00:04:58.000
Like so many websites, certainly like most of the websites that I've ever worked on, the line of succession is basically a database with.

00:04:58.000 --> 00:05:11.000
pretty front-end on it. And what it does is it gives you current and historical information about the British line of succession. Let me just

00:05:11.000 --> 00:05:13.000
see if I can…

00:05:13.000 --> 00:05:16.000
Bring it up so that you can.

00:05:16.000 --> 00:05:21.000
see it.

00:05:21.000 --> 00:05:27.000
So this is the home page of the website.

00:05:27.000 --> 00:05:33.000
And it's got a list of the people who are in the British line of succession. It does the top, it does the first 30.

00:05:33.000 --> 00:05:50.000
Um, and that's not very interesting because there are dozens of websites out there that do that. But the interesting thing here is if you notice every date that you see is a link. And if we click on one of these links.

00:05:50.000 --> 00:05:58.000
It goes back in time and shows you who was on the line of succession at that date.

00:05:58.000 --> 00:06:02.000
Now, I wrote it because…

00:06:02.000 --> 00:06:12.000
I found it an interesting problem to work on, to solve, but people do seem to find it interesting. It's of all the websites that I run.

00:06:12.000 --> 00:06:24.000
This has the most usage of any of my website. It has thousands of hits every month.

00:06:24.000 --> 00:06:36.000
Right. So, it's a dancer website, there's a SQLite database, because the data's actually pretty small.

00:06:36.000 --> 00:06:45.000
a number of you, when we were going through the introductions earlier, a number of you, um, indicated that you… that you knew what dancer was.

00:06:45.000 --> 00:06:50.000
But it's a web framework.

00:06:50.000 --> 00:06:56.000
It basically, it matches roots and a root is a…

00:06:56.000 --> 00:07:01.000
HTTP verb, so get, put.

00:07:01.000 --> 00:07:03.000
Delete.

00:07:03.000 --> 00:07:04.000
query.

00:07:04.000 --> 00:07:08.000
against a path, so the roots or

00:07:08.000 --> 00:07:10.000
some path.

00:07:10.000 --> 00:07:17.000
run some code, and at the end of that code, it produces some HTML.

00:07:17.000 --> 00:07:22.000
And then the important thing to bear in mind here is that

00:07:22.000 --> 00:07:25.000
like most

00:07:25.000 --> 00:07:33.000
applications that I write, web applications that I write, I'm very always careful to include a model layer.

00:07:33.000 --> 00:07:43.000
In the system. So that means I'm not putting raw DBIS class or DBI.

00:07:43.000 --> 00:07:44.000
Road.

00:07:44.000 --> 00:07:49.000
In the request handling code.

00:07:49.000 --> 00:07:50.000
Um…

00:07:50.000 --> 00:07:57.000
I'm putting it in a separate layer. Let's just…

00:07:57.000 --> 00:07:59.000
uh, show you a bit more of the code.

00:07:59.000 --> 00:08:01.000
Um…

00:08:01.000 --> 00:08:05.000
So for example,

00:08:05.000 --> 00:08:11.000
So here I think I'll have to ask you if you could enlarge a little bit the font.

00:08:11.000 --> 00:08:12.000
Probably.

00:08:12.000 --> 00:08:16.000
Do we won't see?

00:08:16.000 --> 00:08:17.000
Is that enough?

00:08:17.000 --> 00:08:18.000
Yeah, thanks. Thanks. Wow.

00:08:18.000 --> 00:08:25.000
That's, yeah.

00:08:25.000 --> 00:08:27.000
Um, right.

00:08:27.000 --> 00:08:29.000
So, let's

00:08:29.000 --> 00:08:31.000
All right.

00:08:31.000 --> 00:08:37.000
This rather complicated looking bit, uh, is the bit that does the main, the main page.

00:08:37.000 --> 00:08:41.000
Um, and so if you get a GET request,

00:08:41.000 --> 00:08:45.000
to something… this matches a date.

00:08:45.000 --> 00:08:50.000
or nothing, because that's all optional.

00:08:50.000 --> 00:08:54.000
Uh, then basically what it does.

00:08:54.000 --> 00:08:58.000
Is that we create an app,

00:08:58.000 --> 00:08:59.000
I.

00:08:59.000 --> 00:09:02.000
And the app is the thing that…

00:09:02.000 --> 00:09:04.000
goes on top of the model.

00:09:04.000 --> 00:09:11.000
allows you to get the useful information from the database. So there's actually very little code.

00:09:11.000 --> 00:09:14.000
in this, it just calls template.

00:09:14.000 --> 00:09:22.000
And if we…

00:09:22.000 --> 00:09:23.000
Find…

00:09:23.000 --> 00:09:26.000
the…

00:09:26.000 --> 00:09:29.000
index template.

00:09:29.000 --> 00:09:34.000
For example,

00:09:34.000 --> 00:09:35.000
Uh, yes, same.

00:09:35.000 --> 00:09:43.000
Here we are, we've asked the app for the rows that are in the succession.

00:09:43.000 --> 00:09:47.000
for the… for the current date that we're displaying.

00:09:47.000 --> 00:09:50.000
And so there's no database code.

00:09:50.000 --> 00:10:00.000
in either the request handler or the template. It's all in this model.

00:10:00.000 --> 00:10:02.000
Layer.

00:10:02.000 --> 00:10:05.000
And that turned out to be a real

00:10:05.000 --> 00:10:08.000
really useful idea.

00:10:08.000 --> 00:10:12.000
Um, so, because in the existing model,

00:10:12.000 --> 00:10:17.000
We have these, well, we have a number of methods, but in particular,

00:10:17.000 --> 00:10:28.000
We have these methods called sovereign on date, which you pass a date and it gives you back the name of the, well, the details of the person who was the sovereign on that date.

00:10:28.000 --> 00:10:40.000
And we have another method called getSuccessionData. Again, you pass it a date and you pass it a limit, which is the number of people that you're interested in seeing, and it returns you.

00:10:40.000 --> 00:10:51.000
data for all of the people who were in the line of succession in order on that date.

00:10:51.000 --> 00:10:56.000
And this turns out to be quite a powerful idea.

00:10:56.000 --> 00:11:04.000
Because it allows you to have different views on the same data.

00:11:04.000 --> 00:11:12.000
So we saw the web page and the web page serves hugely.

00:11:12.000 --> 00:11:17.000
humans that turn up and open their browser and look at the website?

00:11:17.000 --> 00:11:27.000
But we have a JSON API, actually it's turned off I think, at the moment because it's not particularly useful. But that's there for…

00:11:27.000 --> 00:11:30.000
Machines for software programs.

00:11:30.000 --> 00:11:48.000
programs, they can do similar queries to what humans do when they go to the website, but instead of getting back a web page with the navigation and the sidebars and all that kind of thing, the machines, when they call the API,

00:11:48.000 --> 00:11:56.000
get just the pure data back in a format that they understand stops them having to scrape the page.

00:11:56.000 --> 00:12:03.000
And then we have this new method. And bear in mind, the

00:12:03.000 --> 00:12:11.000
The Line of Succession website has been around for approaching 10 years now.

00:12:11.000 --> 00:12:21.000
So nobody knew about MCP when I first wrote the, this website.

00:12:21.000 --> 00:12:37.000
This shows the flexibility that because I have this model layer, I'm able to deal with something brand new that nobody had heard of a couple of years ago and just write an MCP layer.

00:12:37.000 --> 00:12:42.000
On top of it, which, so, I now have

00:12:42.000 --> 00:12:47.000
web service that can serve readers.

00:12:47.000 --> 00:12:55.000
serve pieces of software through the API, but can also serve AI clients.

00:12:55.000 --> 00:13:03.000
And when I say AI clients, we will see a bit later on the kind of things that can

00:13:03.000 --> 00:13:06.000
talk to it, but you can write

00:13:06.000 --> 00:13:08.000
uh, software.

00:13:08.000 --> 00:13:16.000
that uses, for example, the OpenAI API and ask that to include.

00:13:16.000 --> 00:13:19.000
by MCP tool.

00:13:19.000 --> 00:13:31.000
But you can also just include my MCP tool in your Claude or your OpenAI chat bot.

00:13:31.000 --> 00:13:38.000
And we'll see how all that works a bit later on.

00:13:38.000 --> 00:13:44.000
Okay, so put yourself in the mind of the…

00:13:44.000 --> 00:13:47.000
assistant, the LLM.

00:13:47.000 --> 00:13:52.000
the AI tool that wants to get to this information.

00:13:52.000 --> 00:13:58.000
It needs to know a number of things. It needs to know which operations are available.

00:13:58.000 --> 00:14:06.000
It needs to know, what does each operation do? Why would it use each operation?

00:14:06.000 --> 00:14:12.000
Um, which arguments does it need to pass in order to get useful information back?

00:14:12.000 --> 00:14:17.000
Um, and what's the format of the data?

00:14:17.000 --> 00:14:21.000
But it gets back.

00:14:21.000 --> 00:14:29.000
Um, so we need to set up definitions for the answer all of those four questions.

00:14:29.000 --> 00:14:33.000
And that is what…

00:14:33.000 --> 00:14:40.000
model context, protocol gives us. Now this was, I guess it's probably been around for

00:14:40.000 --> 00:14:48.000
two, maybe three years now. It came from Anthropic, the people behind Claude.

00:14:48.000 --> 00:14:56.000
Uh, and it's a protocol for connecting AI applications with any kind of external.

00:14:56.000 --> 00:15:03.000
capability, an external server. If you, um…

00:15:03.000 --> 00:15:12.000
If you access… if you use Claude or OpenAI or ChatGPT to

00:15:12.000 --> 00:15:25.000
interface with GitHub, for example. If you ask your ChatGPT agent to give you a list of the open issues on a GitHub.

00:15:25.000 --> 00:15:35.000
repo. It's using an MCP that GitHub have made available. If you

00:15:35.000 --> 00:15:37.000
Um, all.

00:15:37.000 --> 00:15:43.000
Claude to check your calendar and see if you've got room to add in.

00:15:43.000 --> 00:15:48.000
an appointment on a certain date.

00:15:48.000 --> 00:15:54.000
It can do that because Google have made available an MCP that allows.

00:15:54.000 --> 00:16:00.000
AI to talk to your Google Calendar. In fact, anything in your Google.

00:16:00.000 --> 00:16:04.000
workspace.

00:16:04.000 --> 00:16:09.000
So these are the four things that you need to.

00:16:09.000 --> 00:16:16.000
Implement if you're writing an MCP.

00:16:16.000 --> 00:16:19.000
You need to respond to an initialized call.

00:16:19.000 --> 00:16:34.000
So which is basically just the client talking to the server and saying, here I am, I'm going to be asking you some questions. You can do quite clever stuff in there, but to be honest, my use case

00:16:34.000 --> 00:16:41.000
I barely need that at all. I only need it because, um…

00:16:41.000 --> 00:16:45.000
the AI tools expect it to exist.

00:16:45.000 --> 00:16:52.000
There's notification initialized, which, to be honest, I haven't had to use at all in my.

00:16:52.000 --> 00:16:55.000
tool.

00:16:55.000 --> 00:16:57.000
And then there's tools list.

00:16:57.000 --> 00:16:59.000
Which…

00:16:59.000 --> 00:17:06.000
Gives you a list of tools, as you might expect. You make a request to it and you just get back.

00:17:06.000 --> 00:17:09.000
A data structure, JSON.

00:17:09.000 --> 00:17:17.000
which lists all the tools that are available in from that MCP.

00:17:17.000 --> 00:17:27.000
And then finally, you have Talk's call, which actually makes a call to one of your tools and

00:17:27.000 --> 00:17:34.000
sends back the data which the AI will then.

00:17:34.000 --> 00:17:41.000
Use.

00:17:41.000 --> 00:17:57.000
Uh, so we're going to write, I have written two domain tools for my application and purely coincidentally, they happen to map onto the tool, the two model methods that we

00:17:57.000 --> 00:18:01.000
talked about earlier, we're going to have

00:18:01.000 --> 00:18:17.000
sovereign on date, which gives us the name of the sovereign on a particular date and line of succession, which you can pass it in a date and you'll get back a list of information about the people who were on the line of succession.

00:18:17.000 --> 00:18:21.000
On that date.

00:18:21.000 --> 00:18:26.000
So the first thing you need to do is to define

00:18:26.000 --> 00:18:31.000
The way that these, um, tools are going to be called.

00:18:31.000 --> 00:18:43.000
Now there's a cut down version of it here, but if I bring up my

00:18:43.000 --> 00:18:50.000
VS Code, then in the public directory.

00:18:50.000 --> 00:18:53.000
Here's the entire…

00:18:53.000 --> 00:18:57.000
file and you can see it's got a description.

00:18:57.000 --> 00:19:06.000
It's got some hints which we don't need to worry about. We've got the actual documentation and then importantly, we have the input schema.

00:19:06.000 --> 00:19:14.000
which says, so this is sovereign on date we're looking at. You need to pass it an object, a JSON object.

00:19:14.000 --> 00:19:21.000
The properties that you can set, you can give it are a date.

00:19:21.000 --> 00:19:28.000
And it's expecting the day in ISO standard format, and it's also saying that date is required.

00:19:28.000 --> 00:19:34.000
Whereas the other tool, Line of Succession,

00:19:34.000 --> 00:19:38.000
Um, .

00:19:38.000 --> 00:19:49.000
It's got a date and it's also got a limit, but none of them are required. Neither of those are required. If you don't pass the date, it works on today.

00:19:49.000 --> 00:19:54.000
And if you don't pass the limit, it defaults to 10.

00:19:54.000 --> 00:19:56.000
And that's defined.

00:19:56.000 --> 00:20:05.000
that file.

00:20:05.000 --> 00:20:12.000
And interestingly, I was quite pleased when I worked out I could do this.

00:20:12.000 --> 00:20:15.000
I can use that file,

00:20:15.000 --> 00:20:19.000
In two ways, I can…

00:20:19.000 --> 00:20:24.000
Um, pass it to the.

00:20:24.000 --> 00:20:31.000
When a method, when a client calls tools list,

00:20:31.000 --> 00:20:36.000
I can extract useful information out of that file to

00:20:36.000 --> 00:20:39.000
return it to the…

00:20:39.000 --> 00:20:47.000
user, or to the client, but also I've got a documentation page on the

00:20:47.000 --> 00:20:54.000
On the website, and I can extract information from that.

00:20:54.000 --> 00:20:57.000
Uh…

00:20:57.000 --> 00:20:59.000
From that document to determine.

00:20:59.000 --> 00:21:05.000
displayed on the web page. If I go back to the website,

00:21:05.000 --> 00:21:15.000
I'm right at the bottom here, we have a link to MCP.

00:21:15.000 --> 00:21:18.000
And here we have documentation of the…

00:21:18.000 --> 00:21:21.000
of available tools.

00:21:21.000 --> 00:21:23.000
And there's the input schema.

00:21:23.000 --> 00:21:25.000
here.

00:21:25.000 --> 00:21:31.000
And if we look at the…

00:21:31.000 --> 00:21:34.000
Template for the MCP page.

00:21:34.000 --> 00:21:38.000
get to the available tools section.

00:21:38.000 --> 00:21:42.000
You can see it's just been passed in that YAML.

00:21:42.000 --> 00:21:54.000
the decoded version of that YAML and it just iterates across that. So as soon as if I go to add a new tool, as soon as I document it.

00:21:54.000 --> 00:21:56.000
And

00:21:56.000 --> 00:22:01.000
in the YAML file, it will automatically.

00:22:01.000 --> 00:22:02.000
appear.

00:22:02.000 --> 00:22:07.000
the documentation page, as well as.

00:22:07.000 --> 00:22:13.000
automatically appearing in response to the tools list.

00:22:13.000 --> 00:22:20.000
Call. The only thing I actually have to do is obviously implement that.

00:22:20.000 --> 00:22:30.000
new tool in whatever way seems appropriate to me.

00:22:30.000 --> 00:22:31.000
Um.

00:22:31.000 --> 00:22:37.000
So the MCP object, which we'll look at in a bit more detail soon.

00:22:37.000 --> 00:22:38.000
Um,

00:22:38.000 --> 00:22:44.000
Has two methods. Tools returns the actual.

00:22:44.000 --> 00:22:46.000
Object.

00:22:46.000 --> 00:22:50.000
for returning to the tools list.

00:22:50.000 --> 00:22:54.000
Um, cool, but tall docs.

00:22:54.000 --> 00:23:02.000
returns it in a slightly different format, which can be used on the web page.

00:23:02.000 --> 00:23:09.000
Um, but reusing things is…

00:23:09.000 --> 00:23:13.000
an idea that we've managed to use again.

00:23:13.000 --> 00:23:14.000
But in…

00:23:14.000 --> 00:23:18.000
our dancer code.

00:23:18.000 --> 00:23:27.000
So this is in the main…

00:23:27.000 --> 00:23:30.000
Library, which defines all of the.

00:23:30.000 --> 00:23:33.000
Um, .

00:23:33.000 --> 00:23:37.000
defines all of the roots.

00:23:37.000 --> 00:23:46.000
And obviously, so the page that I just showed you, the MCP documentation page, sits at…

00:23:46.000 --> 00:23:49.000
MCP.

00:23:49.000 --> 00:23:53.000
So when you do a GET on MCP, you

00:23:53.000 --> 00:23:56.000
want to be returned.

00:23:56.000 --> 00:23:58.000
that page.

00:23:58.000 --> 00:24:12.000
However, in some implementations of MCP, the MCP client will do a GET on MCP in order to work out whether.

00:24:12.000 --> 00:24:16.000
an event stream is defined.

00:24:16.000 --> 00:24:26.000
On that URL, on that path, um, and they do that by adding an accept header of text event string. Now,

00:24:26.000 --> 00:24:31.000
I don't know how event streams work.

00:24:31.000 --> 00:24:41.000
But I just know that you have to tell them that they don't… it doesn't exist if it doesn't exist. So I return a HTTP 405.

00:24:41.000 --> 00:24:46.000
and tell them to do a post instead.

00:24:46.000 --> 00:24:49.000
Otherwise,

00:24:49.000 --> 00:25:00.000
We just run the template, which is the template I showed you a couple of minutes ago and pass in the tools, which it then expands into the web page.

00:25:00.000 --> 00:25:01.000
But…

00:25:01.000 --> 00:25:06.000
the actual work of the MCP.

00:25:06.000 --> 00:25:10.000
Is all done behind a post.

00:25:10.000 --> 00:25:15.000
So this is this piece of code is a bit more complicated and we will look at that.

00:25:15.000 --> 00:25:20.000
Soon.

00:25:20.000 --> 00:25:25.000
Okay, so…

00:25:25.000 --> 00:25:34.000
The interaction, the request and the response are all done using JSON RPC.

00:25:34.000 --> 00:25:41.000
Uh, so we need to set the content type to return application JSON.

00:25:41.000 --> 00:25:44.000
And the

00:25:44.000 --> 00:25:50.000
the JSON that defines the call that the client is making.

00:25:50.000 --> 00:25:53.000
is in the

00:25:53.000 --> 00:25:56.000
body. So we get the request body.

00:25:56.000 --> 00:26:06.000
Parse it from JSON into a Perl data structure and store that in the request.

00:26:06.000 --> 00:26:07.000
variable.

00:26:07.000 --> 00:26:11.000
Make sure that we do a little bit of validation that what we've got is the correct thing.

00:26:11.000 --> 00:26:18.000
This minus 32,000 is a, uh,

00:26:18.000 --> 00:26:33.000
A value that is defined in the JSON RPC specification, and if you were to say to me, Dave, that's ridiculous having a magic number like that in your code, you should really have it as a symbolic

00:26:33.000 --> 00:26:44.000
constant, I would say you are absolutely right, and that's one of the issues that I need to fix very soon.

00:26:44.000 --> 00:26:50.000
Then we extract the method.

00:26:50.000 --> 00:26:53.000
From the request.

00:26:53.000 --> 00:26:55.000
Uh, and then we basically

00:26:55.000 --> 00:27:01.000
dispatch on whatever the method is and doing

00:27:01.000 --> 00:27:06.000
whatever clever stuff we need to do in order to get the data.

00:27:06.000 --> 00:27:19.000
which initialize, we get the initialize data and we'll return that. If it's tools list, we get the tools data and we return that. Both of these are pretty much hard coded.

00:27:19.000 --> 00:27:23.000
Or they're at least, um…

00:27:23.000 --> 00:27:27.000
uh, filled in from the…

00:27:27.000 --> 00:27:34.000
YAML file that we've talked about before.

00:27:34.000 --> 00:27:49.000
Something we should just quickly mention is all of these JSON RPC calls have an ID in them. Nothing magic to that at all. It's just an ID. It's just a string or a number that the…

00:27:49.000 --> 00:27:53.000
Client assigned to a request.

00:27:53.000 --> 00:27:58.000
And the server echoes that.

00:27:58.000 --> 00:28:02.000
ID back in the response so that the

00:28:02.000 --> 00:28:09.000
A client can tie up requests and responses, which allows them to fire off multiple requests.

00:28:09.000 --> 00:28:19.000
At the same time, and work out which response matches each request.

00:28:19.000 --> 00:28:23.000
So what does calling a…

00:28:23.000 --> 00:28:26.000
at all actually look like?

00:28:26.000 --> 00:28:31.000
This is the JSON that would be in the body of a call.

00:28:31.000 --> 00:28:35.000
Um, to find the version of JSON RPC that we're using.

00:28:35.000 --> 00:28:43.000
Give it an ID. Again, that's just a number that's made up by the client. Tell it which method we actually want to call.

00:28:43.000 --> 00:28:53.000
then give it the parameters and the essential parameter is obviously the name of the tool that we're calling.

00:28:53.000 --> 00:28:55.000
And then arguments.

00:28:55.000 --> 00:29:01.000
the arguments that were in the input specification, the input schema.

00:29:01.000 --> 00:29:05.000
Um…

00:29:05.000 --> 00:29:11.000
And then, in the code, and we'll dig into the code very soon.

00:29:11.000 --> 00:29:13.000
Uh…

00:29:13.000 --> 00:29:16.000
We have, um…

00:29:16.000 --> 00:29:20.000
a reference to the… to our model layer.

00:29:20.000 --> 00:29:25.000
And in the model layer, we just call these two methods.

00:29:25.000 --> 00:29:29.000
That we talked about.

00:29:29.000 --> 00:29:39.000
The methods that already existed in the model layer. So I haven't had to write any

00:29:39.000 --> 00:29:42.000
line of succession-specific code, because I'm just using code

00:29:42.000 --> 00:29:51.000
that already exists in the application. The only code that I'm writing here is

00:29:51.000 --> 00:29:55.000
scaffolding code for how the MCP.

00:29:55.000 --> 00:29:57.000
works. So…

00:29:57.000 --> 00:30:03.000
On that note, let's have a…

00:30:03.000 --> 00:30:05.000
We're going to look at two

00:30:05.000 --> 00:30:09.000
Modules here. Firstly,

00:30:09.000 --> 00:30:13.000
Succession.pm is the main.

00:30:13.000 --> 00:30:19.000
driver for the whole application.

00:30:19.000 --> 00:30:24.000
Um, and as I mentioned earlier, we do a post to the.

00:30:24.000 --> 00:30:29.000
MCP.

00:30:29.000 --> 00:30:33.000
root and that executes this code.

00:30:33.000 --> 00:30:37.000
We've got an MCP object, which we'll be looking at.

00:30:37.000 --> 00:30:40.000
in a second.

00:30:40.000 --> 00:30:42.000
And basically all it needs…

00:30:42.000 --> 00:30:44.000
is the…

00:30:44.000 --> 00:30:52.000
the tool file and we use path tiny to do clever things to get the tool file.

00:30:52.000 --> 00:31:00.000
Uh, we already saw the code that gets the request body and works out whether it's a valid request.

00:31:00.000 --> 00:31:02.000
We extract the ID and the method.

00:31:02.000 --> 00:31:05.000
Um, if there's no…

00:31:05.000 --> 00:31:13.000
if there's no ID, then something's gone wrong.

00:31:13.000 --> 00:31:20.000
If we call the initialize method, as I said, this is hard-coded. Actually, let's look in MCP.

00:31:20.000 --> 00:31:24.000
And here's the initialized data and it really is just hard coded.

00:31:24.000 --> 00:31:27.000
of a hash.

00:31:27.000 --> 00:31:37.000
Um, which basically I just copied from MCP specs.

00:31:37.000 --> 00:31:45.000
If it's calling tools list,

00:31:45.000 --> 00:31:47.000
That's, um…

00:31:47.000 --> 00:31:51.000
Up here, I think.

00:31:51.000 --> 00:31:54.000
Oh, no, calls tools.

00:31:54.000 --> 00:32:02.000
But again, it just looks at the tools, which is the data that we've got from the YAML file.

00:32:02.000 --> 00:32:05.000
runs a map that pulls out.

00:32:05.000 --> 00:32:09.000
useful pieces of information.

00:32:09.000 --> 00:32:12.000
Um.

00:32:12.000 --> 00:32:15.000
But the more interesting one is

00:32:15.000 --> 00:32:16.000
is cool.

00:32:16.000 --> 00:32:18.000
All tour…

00:32:18.000 --> 00:32:23.000
Which does a lot of the same kind of things.

00:32:23.000 --> 00:32:24.000
Um, for the bike.

00:32:24.000 --> 00:32:28.000
Basically, it needs to dispatch on the

00:32:28.000 --> 00:32:32.000
name of the tool that you're trying to call.

00:32:32.000 --> 00:32:36.000
Uh, so if the name is sovereign on date, it gets the sovereign on date.

00:32:36.000 --> 00:32:43.000
It extracts various useful pieces of information.

00:32:43.000 --> 00:32:45.000
Um.

00:32:45.000 --> 00:32:48.000
Um, one.

00:32:48.000 --> 00:32:54.000
Interesting thing to note here. So we've built up this.

00:32:54.000 --> 00:32:55.000
hash

00:32:55.000 --> 00:32:58.000
of all the interesting data.

00:32:58.000 --> 00:33:03.000
Well, then we convert it to text.

00:33:03.000 --> 00:33:06.000
And we return.

00:33:06.000 --> 00:33:17.000
We've got this method called tool result, which actually builds the result that we need to return to the client. And we pass it both the data version.

00:33:17.000 --> 00:33:19.000
and the textual version.

00:33:19.000 --> 00:33:22.000
We'll look at that in a second, but…

00:33:22.000 --> 00:33:26.000
The same thing is going on with the line of succession.

00:33:26.000 --> 00:33:35.000
tool. We get the data, which again is just calling a method that I already had.

00:33:35.000 --> 00:33:41.000
We can we convert it we sorry, we build a textual version.

00:33:41.000 --> 00:33:47.000
of that line of succession, and then we call tool result, passing both

00:33:47.000 --> 00:33:49.000
versions of the results.

00:33:49.000 --> 00:33:54.000
Because if we go into Tool Results.

00:33:54.000 --> 00:33:57.000
You see, it gets…

00:33:57.000 --> 00:33:59.000
data and text.

00:33:59.000 --> 00:34:09.000
Because it returns the text as content and the data as a thing called structured content.

00:34:09.000 --> 00:34:16.000
So the LLM or whatever AI tool it is that's calling this.

00:34:16.000 --> 00:34:22.000
back the data in two different…

00:34:22.000 --> 00:34:33.000
formats, it gets a plain text that it can pass, because it's a clever AI tool, or it gets structured data, which it can pull apart and

00:34:33.000 --> 00:34:42.000
Maybe get more useful information out of.

00:34:42.000 --> 00:34:45.000
Yeah, so the adapter is…

00:34:45.000 --> 00:34:49.000
uh, doing date passing, we saw that.

00:34:49.000 --> 00:34:57.000
The default date is today. The default list size is 10.

00:34:57.000 --> 00:35:04.000
Um, but because when I was showing you the actual website, you will see that

00:35:04.000 --> 00:35:06.000
Um, .

00:35:06.000 --> 00:35:09.000
We only store 30.

00:35:09.000 --> 00:35:15.000
people's names for each date, and that's something that I'll want to expand later.

00:35:15.000 --> 00:35:21.000
But currently, our maximum list size has to be 30 because that's all the data that I have.

00:35:21.000 --> 00:35:26.000
So yes, this is just reiterating.

00:35:26.000 --> 00:35:28.000
The response…

00:35:28.000 --> 00:35:30.000
structure.

00:35:30.000 --> 00:35:33.000
And as I said, we get…

00:35:33.000 --> 00:35:35.000
Content.

00:35:35.000 --> 00:35:38.000
And a textual version of it.

00:35:38.000 --> 00:35:50.000
I guess there might be some other way, some other values you can put for the type here. I don't know. I haven

00:35:50.000 --> 00:35:52.000
version, so that the…

00:35:52.000 --> 00:35:58.000
the AI tool, can choose what it wants to do.

00:35:58.000 --> 00:36:02.000
Which version of the data it finds most useful.

00:36:02.000 --> 00:36:06.000
We need to deal with errors at two different levels.

00:36:06.000 --> 00:36:14.000
JSON RPC has its own validation rules.

00:36:14.000 --> 00:36:27.000
those long numbers, 32,000 minus 32,000 something, we need to deal with those in a way that's defined by the JSON RPC spec.

00:36:27.000 --> 00:36:35.000
But also we have our own errors within the tool where we have to deal with.

00:36:35.000 --> 00:36:45.000
past an invalid date or a tool that we don't know anything about, things like that.

00:36:45.000 --> 00:36:47.000
Um, so, okay, we've written.

00:36:47.000 --> 00:36:49.000
I…

00:36:49.000 --> 00:36:51.000
MCP server.

00:36:51.000 --> 00:36:55.000
We've incorporated it in our.

00:36:55.000 --> 00:36:57.000
existing code.

00:36:57.000 --> 00:37:01.000
How do we actually, um,

00:37:01.000 --> 00:37:03.000
Get to use it.

00:37:03.000 --> 00:37:10.000
Um, and there are a number of ways that we can use it. We can use curl.

00:37:10.000 --> 00:37:14.000
Um, I saw that earlier this week.

00:37:14.000 --> 00:37:29.000
Mohammed had released appMCP CLI to CPAN. I had a quick try with it and I couldn't get it to work with my MCP. I don't know whether that's me or him that's broken stuff.

00:37:29.000 --> 00:37:43.000
Um, but that will… I mean, it was only version 0.01, so we'll see what happens with that. Or, and nice and easy is we can add the MCP to a

00:37:43.000 --> 00:37:45.000
Chat interface.

00:37:45.000 --> 00:37:49.000
Now let's have a look at some of these.

00:37:49.000 --> 00:37:53.000
Examples.

00:37:53.000 --> 00:37:57.000
I can never remember.

00:37:57.000 --> 00:38:00.000
Uh, detailed…

00:38:00.000 --> 00:38:02.000
Co. Come on.

00:38:02.000 --> 00:38:04.000
bones.

00:38:04.000 --> 00:38:07.000
So I've written a couple of

00:38:07.000 --> 00:38:09.000
Little programs.

00:38:09.000 --> 00:38:11.000
But cool.

00:38:11.000 --> 00:38:14.000
My.

00:38:14.000 --> 00:38:16.000
server.

00:38:16.000 --> 00:38:21.000
This one calls the initialize method.

00:38:21.000 --> 00:38:23.000
Here you can see the request.

00:38:23.000 --> 00:38:26.000
.

00:38:26.000 --> 00:38:30.000
Jason, that it builds up, calling the method initialize.

00:38:30.000 --> 00:38:37.000
Just some information about the protocol version and stuff like that. And then it just passes that to curl.

00:38:37.000 --> 00:38:43.000
with the correct content type and the correct accept.

00:38:43.000 --> 00:38:46.000
And so if we run…

00:38:46.000 --> 00:38:50.000
been initialized.

00:38:50.000 --> 00:39:00.000
That's the result coming back from my live server.

00:39:00.000 --> 00:39:03.000
Um, and as I said,

00:39:03.000 --> 00:39:16.000
In my use case, we don't do anything useful at the initialized stage, but we still need to have it. I've given this a dash P so that we can see

00:39:16.000 --> 00:39:22.000
Um, the payload that is passed into it.

00:39:22.000 --> 00:39:25.000
And then the response that comes back.

00:39:25.000 --> 00:39:33.000
Things get more interesting when you run.

00:39:33.000 --> 00:39:40.000
Tools list.

00:39:40.000 --> 00:39:46.000
Because you're getting back the list of the tools that we support.

00:39:46.000 --> 00:39:47.000
Um.

00:39:47.000 --> 00:39:52.000
There's a name sovereign on date. There's the description of it so that the…

00:39:52.000 --> 00:39:59.000
LLM knows why it might call that. And here's the information about the.

00:39:59.000 --> 00:40:01.000
Uh…

00:40:01.000 --> 00:40:03.000
The format, the…

00:40:03.000 --> 00:40:07.000
properties, so it accepts. And then down here we

00:40:07.000 --> 00:40:08.000
have.

00:40:08.000 --> 00:40:10.000
The line of succession.

00:40:10.000 --> 00:40:12.000
One.

00:40:12.000 --> 00:40:14.000
Um, and again,

00:40:14.000 --> 00:40:20.000
And well, we saw this in the YAML, didn't we?

00:40:20.000 --> 00:40:22.000
That it…

00:40:22.000 --> 00:40:24.000
that its properties are date,

00:40:24.000 --> 00:40:27.000
and limit.

00:40:27.000 --> 00:40:31.000
And again, if I give it a dot

00:40:31.000 --> 00:40:36.000
minus P.

00:40:36.000 --> 00:40:39.000
So that's the call.

00:40:39.000 --> 00:40:44.000
I've just given it a random number as an ID. Just…

00:40:44.000 --> 00:40:46.000
Tools list and

00:40:46.000 --> 00:40:47.000
gives me back.

00:40:47.000 --> 00:40:50.000
The list of the tools.

00:40:50.000 --> 00:40:59.000
And then, probably most interesting is what happens if we run tools.

00:40:59.000 --> 00:41:00.000
Cool.

00:41:00.000 --> 00:41:13.000
We need to give it at least the name of a tool. So we give it.

00:41:13.000 --> 00:41:22.000
And now that's going to default to today, I think.

00:41:22.000 --> 00:41:27.000
I'm sorry, yeah, here, so here you can see, as I said, we get the, we get a text version.

00:41:27.000 --> 00:41:34.000
that return data and then we get a structured version.

00:41:34.000 --> 00:41:38.000
And again, if we

00:41:38.000 --> 00:41:40.000
minus P.

00:41:40.000 --> 00:41:43.000
It shows us here the

00:41:43.000 --> 00:41:48.000
cool that it has made, and there are no arguments in this version.

00:41:48.000 --> 00:41:51.000
But we can again…

00:41:51.000 --> 00:41:54.000
Also…

00:41:54.000 --> 00:41:56.000
Give it.

00:41:56.000 --> 00:42:02.000
This is where I have to type raw JSON.

00:42:02.000 --> 00:42:06.000
Without making a mistake.

00:42:06.000 --> 00:42:11.000
1948.

00:42:11.000 --> 00:42:12.000
Stephanie.

00:42:12.000 --> 00:42:15.000
for change

00:42:15.000 --> 00:42:25.000
18.

00:42:25.000 --> 00:42:27.000
Yeah, and now it's filled in.

00:42:27.000 --> 00:42:30.000
State argument.

00:42:30.000 --> 00:42:32.000
And it tells you that

00:42:32.000 --> 00:42:35.000
George VI was the king.

00:42:35.000 --> 00:42:41.000
And if we change this to…

00:42:41.000 --> 00:42:42.000
9.

00:42:42.000 --> 00:42:43.000
of…

00:42:43.000 --> 00:42:45.000
Succession.

00:42:45.000 --> 00:42:49.000
And we add a…

00:42:49.000 --> 00:42:52.000
Limit.

00:42:52.000 --> 00:42:54.000
Ray.

00:42:54.000 --> 00:42:57.000
We will get the first

00:42:57.000 --> 00:43:02.000
three names on the line of succession.

00:43:02.000 --> 00:43:04.000
On that date.

00:43:04.000 --> 00:43:09.000
And you'll see the text just has these ugly.

00:43:09.000 --> 00:43:14.000
new lines, but the LLMs don't care about that.

00:43:14.000 --> 00:43:17.000
And down here we've got the proper.

00:43:17.000 --> 00:43:20.000
Uh, structured data.

00:43:20.000 --> 00:43:22.000
for the…

00:43:22.000 --> 00:43:27.000
Verse 3 people in the line of succession.

00:43:27.000 --> 00:43:30.000
So, yeah, we can call it…

00:43:30.000 --> 00:43:32.000
like this.

00:43:32.000 --> 00:43:35.000
But probably…

00:43:35.000 --> 00:43:37.000
Um,

00:43:37.000 --> 00:43:39.000
Most interesting.

00:43:39.000 --> 00:43:44.000
Uh, now here I have…

00:43:44.000 --> 00:43:46.000
Claude?

00:43:46.000 --> 00:43:50.000
And if you go to your…

00:43:50.000 --> 00:43:54.000
Settings in Claw and select connectors.

00:43:54.000 --> 00:44:02.000
Um, then you can look at the kind of tools that you've already got set up.

00:44:02.000 --> 00:44:05.000
And we can add a custom connector.

00:44:05.000 --> 00:44:08.000
Call it line of…

00:44:08.000 --> 00:44:10.000
succession.

00:44:10.000 --> 00:44:20.000
of it.

00:44:20.000 --> 00:44:28.000
The correct URL.

00:44:28.000 --> 00:44:35.000
Without a typo.

00:44:35.000 --> 00:44:38.000
There's no sign-in for this, because it's just public information.

00:44:38.000 --> 00:44:43.000
You've got the option to add new headers.

00:44:43.000 --> 00:44:47.000
So we add that.

00:44:47.000 --> 00:44:50.000
So now we've got a new connector.

00:44:50.000 --> 00:44:55.000
Listed, line of succession.

00:44:55.000 --> 00:44:59.000
If we…

00:44:59.000 --> 00:45:01.000
Who's that?

00:45:01.000 --> 00:45:06.000
and go to A.

00:45:06.000 --> 00:45:25.000
chat window, we can we can ask it.

00:45:25.000 --> 00:45:28.000
And you see it's using…

00:45:28.000 --> 00:45:31.000
of succession sovereign on date.

00:45:31.000 --> 00:45:35.000
It's told us that

00:45:35.000 --> 00:45:47.000
Queen Elizabeth, Elizabeth II, which is correct. Uh, and it's also grabbed some more information. This doesn't come from my tool.

00:45:47.000 --> 00:45:52.000
So it's mixed in some of its own knowledge.

00:45:52.000 --> 00:45:59.000
And we can also go.

00:45:59.000 --> 00:46:00.000
Tell me the…

00:46:00.000 --> 00:46:02.000
Top 10 people.

00:46:02.000 --> 00:46:06.000
people on the.

00:46:06.000 --> 00:46:15.000
Well, I know session on

00:46:15.000 --> 00:46:20.000
6th of Feb 1952, which I just happened to just happen.

00:46:20.000 --> 00:46:23.000
happen to know is the date that Queen Elizabeth II.

00:46:23.000 --> 00:46:26.000
to the throne.

00:46:26.000 --> 00:46:34.000
And again, it's loading my tool.

00:46:34.000 --> 00:46:40.000
And there are the names of the people. Now, I mean…

00:46:40.000 --> 00:46:46.000
Not that maybe you're interested, but it's interesting for me to note that it's got.

00:46:46.000 --> 00:46:54.000
It caused Prince Charles, the Duke of Cornwall, because that's the title that he held on that day because he hadn't been made Prince of Wales yet.

00:46:54.000 --> 00:46:56.000
Um.

00:46:56.000 --> 00:47:04.000
So yes, it's relatively easy to.

00:47:04.000 --> 00:47:14.000
add a connection to my MCP into your Claude chat. You can do exactly the same thing in a.

00:47:14.000 --> 00:47:20.000
ChatGPT chat, and I'm sure whatever you use.

00:47:20.000 --> 00:47:30.000
Brock or whatever the meta one's called or Gemini.

00:47:30.000 --> 00:47:35.000
Oh, right, yeah, so here's just an example.

00:47:35.000 --> 00:47:39.000
Uh, you add it.

00:47:39.000 --> 00:47:49.000
Um, so I was going to do a demo of a complete round trip.

00:47:49.000 --> 00:47:51.000
I mean, we…

00:47:51.000 --> 00:47:56.000
We've pretty much done this anyway.

00:47:56.000 --> 00:47:59.000
Oh, so there's the line of succession.

00:47:59.000 --> 00:48:04.000
On the 14th of November.

00:48:04.000 --> 00:48:14.000
1948, but that's not a random day, that's the day that Prince Charles was born. And so we've got Princess Elizabeth, the Queen.

00:48:14.000 --> 00:48:20.000
Charles and Princess Margaret and it says:

00:48:20.000 --> 00:48:29.000
Compare the answer with the website.

00:48:29.000 --> 00:48:33.000
The date that Charles was born.

00:48:33.000 --> 00:48:35.000
And there's the first three names.

00:48:35.000 --> 00:48:43.000
Miss Elizabeth, Prince Charles, Princess Mahal. Now, that shouldn't as a surprise, because as I've been

00:48:43.000 --> 00:48:46.000
At great pains to point out, the

00:48:46.000 --> 00:48:51.000
Data comes from exactly the same place. It comes from cooling exactly the same.

00:48:51.000 --> 00:48:56.000
methods.

00:48:56.000 --> 00:48:58.000
Um,

00:48:58.000 --> 00:49:07.000
So we can also do compare the first five successors on these two dates.

00:49:07.000 --> 00:49:14.000
Once you've typed one of these JSONs, it's easy enough to.

00:49:14.000 --> 00:49:16.000
Edit it to type other ones.

00:49:16.000 --> 00:49:24.000
Uh, what was February 7th.

00:49:24.000 --> 00:49:26.000
Five people.

00:49:26.000 --> 00:49:31.000
white people.

00:49:31.000 --> 00:49:35.000
Prince Charles, Princess Anne.

00:49:35.000 --> 00:49:42.000
Princess Margaret and then the Duke of Gloucester and Prince William of Gloucester.

00:49:42.000 --> 00:49:46.000
And then we've got the textual version.

00:49:46.000 --> 00:49:48.000
And then it says…

00:49:48.000 --> 00:49:56.000
Compare it with the 9th of September. Oh, so that it's chosen those two dates.

00:49:56.000 --> 00:50:00.000
Because they are the first and last dates of…

00:50:00.000 --> 00:50:03.000
Elizabeth's seconds.

00:50:03.000 --> 00:50:11.000
Rain. You're not interested in that, are you?

00:50:11.000 --> 00:50:15.000
Oh, and there I've got an error because I've got the date format wrong.

00:50:15.000 --> 00:50:20.000
Because 00 is not valid.

00:50:20.000 --> 00:50:24.000
Day of the month.

00:50:24.000 --> 00:50:26.000
And there you have…

00:50:26.000 --> 00:50:28.000
Prince William.

00:50:28.000 --> 00:50:32.000
Prince George, Princess Charlotte, Prince Louis.

00:50:32.000 --> 00:50:34.000
and Prince Henry, Prince Harry.

00:50:34.000 --> 00:50:40.000
He's obviously better known.

00:50:40.000 --> 00:50:54.000
Okay, so that was pretty much all I had to tell you. That's what made it straightforward was the fact that I got a domain model. If there's one lesson that you should take away from this.

00:50:54.000 --> 00:50:58.000
having a domain model is cool.

00:50:58.000 --> 00:51:09.000
Uh, so the tool definitions describe the kind of useful questions that you might want to ask, and then the adapter translates those requests and turns them into.

00:51:09.000 --> 00:51:12.000
into calls to the model.

00:51:12.000 --> 00:51:14.000
already exist.

00:51:14.000 --> 00:51:27.000
Some things that I might want to do to it next, most importantly, I realize that there's probably modules there on CPAM which handle the JSON RPC stuff for me.

00:51:27.000 --> 00:51:34.000
Whereas I'm writing it all myself from hand, by hand.

00:51:34.000 --> 00:51:40.000
Maybe I'll add some more tools, I'm not entirely sure what they'd be, but maybe people would find other.

00:51:40.000 --> 00:51:46.000
of information useful.

00:51:46.000 --> 00:52:03.000
I showed you writing up a connection to Claude. There's another layer above that that you can do in both ChatGPT and Claude. You can wrap it up in a plugin, which makes it just even easier for people that

00:52:03.000 --> 00:52:13.000
Don't really understand what a URL is. They don't need to have that, have a look at that slightly scary looking setup.

00:52:13.000 --> 00:52:14.000
uh, dial…

00:52:14.000 --> 00:52:16.000
lockbox.

00:52:16.000 --> 00:52:19.000
Uh, and then there's, um, I'm…

00:52:19.000 --> 00:52:27.000
I'm starting to wonder whether there's a way to write a dancer to plug in that

00:52:27.000 --> 00:52:38.000
does all the top-level scaffolding and just calls to callback functions to actually do the working out what the data is.

00:52:38.000 --> 00:52:41.000
I haven't really started thinking about that, but it's just…

00:52:41.000 --> 00:52:44.000
at the back of my mind.

00:52:44.000 --> 00:52:47.000
Um, so, in summary,

00:52:47.000 --> 00:52:53.000
watching existing models make writing new interfaces much easier.

00:52:53.000 --> 00:52:58.000
Write useful tools to give the assistants a reason to call.

00:52:58.000 --> 00:53:08.000
And the MCP standardizes discovery and invocation and makes it easy to

00:53:08.000 --> 00:53:12.000
put it on top of your existing model.

00:53:12.000 --> 00:53:17.000
We'll go to questions, uh…

00:53:17.000 --> 00:53:20.000
But some resources, so that's where the…

00:53:20.000 --> 00:53:29.000
where the MCP actually lives, the code for the whole website, including the MCP is on GitHub.

00:53:29.000 --> 00:53:36.000
And I wrote a blog post about it back in May when I first wrote the

00:53:36.000 --> 00:53:41.000
start the MCP so that you might find that interesting too.

00:53:41.000 --> 00:53:46.000
Um, how about that? That was just under…

00:53:46.000 --> 00:53:47.000
An hour.

00:53:47.000 --> 00:53:55.000
So I can't see any Zoom stuff.

00:53:55.000 --> 00:53:56.000
Oh, there you go.

00:53:56.000 --> 00:54:04.000
So Dave, that was. That's that was an excellent.

00:54:04.000 --> 00:54:05.000
I can see, questions.

00:54:05.000 --> 00:54:06.000
presentation. Thank you very much. There are, I think even I have.

00:54:06.000 --> 00:54:14.000
I have some questions and there are some questions in the chat, so I'm going to read you the questions so you don't have to open the

00:54:14.000 --> 00:54:23.000
window, the first came in a while ago. Do you put any AI scraping denial on your website?

00:54:23.000 --> 00:54:28.000
Um.

00:54:28.000 --> 00:54:36.000
Over the last year, when it's come round to renew all of my domains and I have far too many domains.

00:54:36.000 --> 00:54:37.000
I, uh…

00:54:37.000 --> 00:54:41.000
have been moving all my domains to Cloudflare.

00:54:41.000 --> 00:54:56.000
And that's part of their standard, um, offering, the standard service that they offer as your onboarding a domain, they ask you what the setting is, what setting you want to put for

00:54:56.000 --> 00:55:04.000
AI scrapers. Now, I know that.

00:55:04.000 --> 00:55:11.000
Even just in the Pearl community, we've had a lot of problems with.

00:55:11.000 --> 00:55:17.000
AI scrapers bringing websites down. I think Pearl Mugs has had that problem.

00:55:17.000 --> 00:55:20.000
Um, and…

00:55:20.000 --> 00:55:23.000
CPAN testers as well.

00:55:23.000 --> 00:55:25.000
But…

00:55:25.000 --> 00:55:28.000
My websites never get

00:55:28.000 --> 00:55:30.000
Hardly any traffic.

00:55:30.000 --> 00:55:34.000
Um, so, and I think given that…

00:55:34.000 --> 00:55:38.000
I'm a big fan of using AI to.

00:55:38.000 --> 00:55:49.000
Extract information from websites. It would be slightly hypocritical of me to stop other people from doing it on my websites. So, generally, I.

00:55:49.000 --> 00:55:51.000
um, allow.

00:55:51.000 --> 00:55:56.000
AI scrapers, access to most of my websites.

00:55:56.000 --> 00:56:04.000
But I am monitoring that. If it causes a problem, then obviously I will take action.

00:56:04.000 --> 00:56:10.000
Okay.

00:56:10.000 --> 00:56:11.000
Um.

00:56:11.000 --> 00:56:14.000
The MCP server side, do you have any rate limiting in place such as maximum number of requests per second?

00:56:14.000 --> 00:56:19.000
Same as the previous answer, I guess.

00:56:19.000 --> 00:56:22.000
I get, uh…

00:56:22.000 --> 00:56:28.000
My most popular website is the line of succession website.

00:56:28.000 --> 00:56:30.000
I get…

00:56:30.000 --> 00:56:37.000
A few thousand hits on that every day, so that's not troubling the server in the slightest.

00:56:37.000 --> 00:56:40.000
Uh…

00:56:40.000 --> 00:56:47.000
If I can be slightly stereotypical, I think my main

00:56:47.000 --> 00:56:55.000
My main visitor archetype on that website is middle age.

00:56:55.000 --> 00:57:08.000
American women who are interested in the British royal family. I don't know how much use they're going to be making of the MCP. So I haven't looked at…

00:57:08.000 --> 00:57:18.000
Rate limiting it yet. It's only been live a couple of months and it's caused no problems whatsoever. But again, something that I will monitor.

00:57:18.000 --> 00:57:22.000
Is it being used? Can you see that if it's being used?

00:57:22.000 --> 00:57:23.000
To be honest, I haven't…

00:57:23.000 --> 00:57:25.000
by others, except of you.

00:57:25.000 --> 00:57:31.000
Uh, I haven't looked at that. I haven't, um, the, the whole, um.

00:57:31.000 --> 00:57:44.000
The whole system is hosted in Cloud Run, Google Cloud Run. So yes, I need to look at I need to set up a report that shows me how.

00:57:44.000 --> 00:57:48.000
how often the MCP is being caught, and I haven't done that.

00:57:48.000 --> 00:57:54.000
How would people even know about the fact that you have an MCP server?

00:57:54.000 --> 00:57:56.000
Um…

00:57:56.000 --> 00:57:59.000
Well, it's advertised at the.

00:57:59.000 --> 00:58:03.000
Oh, we're on the wrong.

00:58:03.000 --> 00:58:07.000
Wrong, wrong, wrong, don't don't show. Yeah, private chats and things.

00:58:07.000 --> 00:58:10.000
No.

00:58:10.000 --> 00:58:15.000
Hang on.

00:58:15.000 --> 00:58:20.000
No, no, no, shut that down.

00:58:20.000 --> 00:58:27.000
Yeah.

00:58:27.000 --> 00:58:33.000
This should get me back to where I want to be.

00:58:33.000 --> 00:58:35.000
Yeah, sorry.

00:58:35.000 --> 00:58:43.000
Sorry, what was the question? Oh, how do people know? Oh, they know because

00:58:43.000 --> 00:58:44.000
of the enemy.

00:58:44.000 --> 00:58:56.000
I mean, it's on the slash MCP route. Okay, but

00:58:56.000 --> 00:58:57.000
Mm-hmm.

00:58:57.000 --> 00:58:58.000
I mean, there's a tiny link to it in the footer. So I haven't made a big song and dance of it. I have a line of succession blog.

00:58:58.000 --> 00:59:06.000
And I haven't even posted to it there because I don't think people are particularly going to be interested. It was an experiment for me to find out how

00:59:06.000 --> 00:59:11.000
easy it is to to do it more than anything.

00:59:11.000 --> 00:59:24.000
Yeah, I think it was more from me, it was more a little bit of theoretical question or generic question of how anyone would know about an MCP server.

00:59:24.000 --> 00:59:27.000
Oh, actually, um, there is…

00:59:27.000 --> 00:59:29.000
of a random website.

00:59:29.000 --> 00:59:38.000
Yeah, when I first set it up back in May, there are a couple of GitHub repos that list.

00:59:38.000 --> 00:59:50.000
But the power GitHub Pages websites that list MCP servers. So I've included it on there, but those are lists of hundreds of MTP servers.

00:59:50.000 --> 00:59:54.000
I don't know whether anybody would have found it through that.

00:59:54.000 --> 00:59:55.000
Yeah, so I know.

00:59:55.000 --> 01:00:03.000
You're right, I do have to set up a report to find out how used it's going to be or it's being.

01:00:03.000 --> 01:00:16.000
Yeah, so there is another question which is probably theoretical for not really relevant for you, but interesting in general. If a request takes 5 min to respond.

01:00:16.000 --> 01:00:21.000
How does one maintain the context of the conversation?

01:00:21.000 --> 01:00:25.000
Um…

01:00:25.000 --> 01:00:30.000
It's an interesting question. Like you say, for me, it's hypothetical, because

01:00:30.000 --> 01:00:33.000
my requests all come back in…

01:00:33.000 --> 01:00:37.000
A few seconds.

01:00:37.000 --> 01:00:38.000
Um…

01:00:38.000 --> 01:00:39.000
Okay.

01:00:39.000 --> 01:00:40.000
I mean, the ID would probably help.

01:00:40.000 --> 01:00:45.000
there, but…

01:00:45.000 --> 01:00:47.000
I don't…

01:00:47.000 --> 01:00:53.000
I don't think the concept of a conversation really exists at this level.

01:00:53.000 --> 01:00:57.000
The MCP is really answering one-off questions.

01:00:57.000 --> 01:01:01.000
the sovereign on this date.

01:01:01.000 --> 01:01:11.000
You don't, it doesn't have the concept of then saying, okay, and who was on the line of succession on the same day?

01:01:11.000 --> 01:01:13.000
That doesn't happen.

01:01:13.000 --> 01:01:14.000
Yeah, I mean.

01:01:14.000 --> 01:01:23.000
It would be up to the LLM or the AI client to hold that context and know that it's.

01:01:23.000 --> 01:01:25.000
Is it?

01:01:25.000 --> 01:01:31.000
It's like you've got a fining cabinet. You don't expect the filing cabinet to…

01:01:31.000 --> 01:01:40.000
remember which file you got out last time and give you the next file. It's just a dumb

01:01:40.000 --> 01:01:46.000
a dumb information store.

01:01:46.000 --> 01:01:48.000
Yeah.

01:01:48.000 --> 01:01:50.000
There was also question what is slug?

01:01:50.000 --> 01:01:55.000
Oh, so that's being asked because…

01:01:55.000 --> 01:02:00.000
Um, we get back slugs for every person.

01:02:00.000 --> 01:02:02.000
Oh, okay, I didn't even notice that one. Yeah.

01:02:02.000 --> 01:02:06.000
Um, and a slug is, uh,

01:02:06.000 --> 01:02:09.000
the unique identifier for

01:02:09.000 --> 01:02:14.000
the person on the website. If you

01:02:14.000 --> 01:02:19.000
If we look at the website,

01:02:19.000 --> 01:02:25.000
Not only are the dates all links, but the…

01:02:25.000 --> 01:02:32.000
names are all links as well, and if you… I don't know whether anyone can see, but if you look up here.

01:02:32.000 --> 01:02:39.000
The URL for a person page is P followed by the slug.

01:02:39.000 --> 01:02:40.000
Okay.

01:02:40.000 --> 01:02:45.000
So it's just a unique identifier for the page. And probably.

01:02:45.000 --> 01:02:55.000
Good API design would be to not return the slug, but to return the URL for the person.

01:02:55.000 --> 01:02:57.000
Yeah.

01:02:57.000 --> 01:03:07.000
So here's another question which I think, okay, whatever.

01:03:07.000 --> 01:03:08.000
Yes.

01:03:08.000 --> 01:03:18.000
Not related to your presentation, I think, but it's very interesting. Is Pearl an easy language for AI to master in your view? Have you tried Claude to implement line of suction?

01:03:18.000 --> 01:03:29.000
The line of succession website in Dancer 2 on its own, without looking at your code or looking it up on the internet.

01:03:29.000 --> 01:03:42.000
The thing is, that's the question. My comment here is that how would you even be able to do that, to tell.

01:03:42.000 --> 01:03:43.000
Well, I mean…

01:03:43.000 --> 01:03:50.000
Claude, or whoever, whatever, not to look at an existing one or not look at your existing one.

01:03:50.000 --> 01:04:00.000
I'm… I'm not about to throw away almost 10 years of work and replace it with vibe coding, but…

01:04:00.000 --> 01:04:06.000
I…

01:04:06.000 --> 01:04:08.000
I would say over the last…

01:04:08.000 --> 01:04:14.000
Couple of years, the amount of code that I actually write myself has fallen.

01:04:14.000 --> 01:04:19.000
fallen dramatically. I probably now write

01:04:19.000 --> 01:04:27.000
less than 5% of the code that I produce.

01:04:27.000 --> 01:04:28.000
Yeah.

01:04:28.000 --> 01:04:29.000
So,

01:04:29.000 --> 01:04:34.000
I'm… I'm not… well, I have tried vibe coding.

01:04:34.000 --> 01:04:41.000
But having got 30 years of experience of programming,

01:04:41.000 --> 01:04:44.000
Why?

01:04:44.000 --> 01:04:46.000
I'm happy to get…

01:04:46.000 --> 01:04:51.000
Claude or Codex to generate code for me.

01:04:51.000 --> 01:04:52.000
Um,

01:04:52.000 --> 01:04:57.000
But I like to read it. I like to understand what it is that I'm…

01:04:57.000 --> 01:05:03.000
put in live or uploading to CPAN or whatever. But if you've looked at code that I've written.

01:05:03.000 --> 01:05:08.000
Over the last two years probably, there is…

01:05:08.000 --> 01:05:15.000
Uh, only 20% and falling chance that it was actually written by

01:05:15.000 --> 01:05:19.000
me. Most of it would have been written by

01:05:19.000 --> 01:05:22.000
an agent.

01:05:22.000 --> 01:05:23.000
Hmm.

01:05:23.000 --> 01:05:33.000
Does that… I don't know whether that answers the question at all. I think Pearl is a perfectly easy eight, like, perfectly easy language for AIs to master.

01:05:33.000 --> 01:05:36.000
I sometimes have problems.

01:05:36.000 --> 01:05:38.000
Um, I have

01:05:38.000 --> 01:05:39.000
So…

01:05:39.000 --> 01:05:44.000
Keep in mind it that there are…

01:05:44.000 --> 01:05:50.000
modern Pearl con constructs, but once you put that

01:05:50.000 --> 01:05:53.000
the agent file.

01:05:53.000 --> 01:05:57.000
For a particular project, it knows that you want to use

01:05:57.000 --> 01:06:09.000
signature and postfix dereferencing and things like that, but left to its own devices.

01:06:09.000 --> 01:06:15.000
It would often write something that looks like it came from 1995.

01:06:15.000 --> 01:06:19.000
Yeah, that's good. Yeah, that's a problem too.

01:06:19.000 --> 01:06:26.000
Okay, you also need to write it, please write code without bugs.

01:06:26.000 --> 01:06:27.000
Like

01:06:27.000 --> 01:06:30.000
Yes, but I mean, one of the first experiments that

01:06:30.000 --> 01:06:35.000
did with AI coding and I wrote a blog post about it, it's probably four years ago now.

01:06:35.000 --> 01:06:42.000
And I thought I'd be really clever, and I would… and I asked it to write a…

01:06:42.000 --> 01:06:45.000
Um, oppose…

01:06:45.000 --> 01:06:47.000
Earth's CPAN module for…

01:06:47.000 --> 01:06:57.000
interfacing with the OpenAI API, like a wrapper, you know, so Curtis now.

01:06:57.000 --> 01:07:08.000
maintains a really complex module that does that, but I thought I'd be one of the first person on CPAN. And it wrote me code.

01:07:08.000 --> 01:07:12.000
That just it didn't come, it didn't even compile.

01:07:12.000 --> 01:07:17.000
Yeah.

01:07:17.000 --> 01:07:18.000
Yeah.

01:07:18.000 --> 01:07:22.000
But that's four years ago and we've come an awful long way since then. I think I'm perfectly happy to trust most of my coding.

01:07:22.000 --> 01:07:23.000
agent.

01:07:23.000 --> 01:07:28.000
It happened to… it happened to me two days ago on ChatGPT with Python.

01:07:28.000 --> 01:07:34.000
that it wrote some code, and that it has a button now on ChatGPT to run it.

01:07:34.000 --> 01:07:51.000
And it failed to run it on ChatGPT. The code was actually good. And when I moved it to correctly set up machine, it ran and did exactly what I was expecting to do. But it's their own environment couldn't handle it.

01:07:51.000 --> 01:07:52.000
Yes, yes, I mean.

01:07:52.000 --> 01:07:54.000
So it seems really strange things.

01:07:54.000 --> 01:08:01.000
What I'm… I mean, I'm… a lot of what I write is,

01:08:01.000 --> 01:08:11.000
web stuff, and I'm fine, I'm getting a lot braver with JavaScript than I used to be. I mean, I'd learnt.

01:08:11.000 --> 01:08:24.000
JavaScript over the last 10 years or so, but I've never been particularly confident in it. But now I just asked Claude to go away and write the JavaScript to do this clever thing on my web.

01:08:24.000 --> 01:08:29.000
And it mostly works most of the time.

01:08:29.000 --> 01:08:30.000
Very happy.

01:08:30.000 --> 01:08:31.000
Okay.

01:08:31.000 --> 01:08:51.000
Another comment is just a command that Michael says that my website biology database has been brought down by AI escapers.

01:08:51.000 --> 01:08:52.000
Mountbatten Windsor.

01:08:52.000 --> 01:08:55.000
Scrapers as well, then someone, Mark asks, and I'm going to mispronounce this name, Andrew Mountbutton visor still listed as number eight in the line of succession question.

01:08:55.000 --> 01:09:09.000
Yes, and that is accurate. I mean, let's not get into the politics of what's been going on with Andrew Mountbatten-Windsor over the last year.

01:09:09.000 --> 01:09:14.000
But His Royal.

01:09:14.000 --> 01:09:22.000
privileges have slowly been chipped away at over the last.

01:09:22.000 --> 01:09:34.000
Well, five years, because his mother started it. She said he wasn't going to be a working royal. She said he couldn't be an HRH anymore, but it took until when his.

01:09:34.000 --> 01:09:37.000
Brother.

01:09:37.000 --> 01:09:51.000
became king and the police raid that happened about a year ago, at which point he stopped being a prince, he stopped being referred to as the Duke of York,

01:09:51.000 --> 01:10:04.000
The last thing that he still has is that he's on the line of succession. But the point there is that if you're eighth on the line of succession,

01:10:04.000 --> 01:10:07.000
Um, you're not going to become king.

01:10:07.000 --> 01:10:12.000
Uh, because…

01:10:12.000 --> 01:10:25.000
Five of the people above you are young children who are going to grow up and have children of their own, and they will all be higher than you in the… every time that one of William or Harry's children

01:10:25.000 --> 01:10:29.000
a child with their own, Andrew will move down another level.

01:10:29.000 --> 01:10:37.000
He's never going to be king. And in order to remove him from the line of succession, it has to be an act of parliament.

01:10:37.000 --> 01:10:41.000
And it has to be an act of Parliament that is ratified by all

01:10:41.000 --> 01:10:47.000
All of the countries that use the British line of succession for their monarchs.

01:10:47.000 --> 01:10:59.000
So it needs to be ratified by the Australian Parliament, the New Zealand Parliament, the Canadian Parliament. There are 14 other countries. And honestly.

01:10:59.000 --> 01:11:07.000
It's just not worth the parliamentary time. I would personally far rather that my… that the Parliament spent

01:11:07.000 --> 01:11:12.000
their time doing much more useful things than

01:11:12.000 --> 01:11:15.000
Yeah, okay.

01:11:15.000 --> 01:11:16.000
Yeah. Okay.

01:11:16.000 --> 01:11:19.000
being anchor from the line of succession. Sorry, that was too long for a let's get back to technical things.

01:11:19.000 --> 01:11:31.000
Yeah, yeah, yeah. A possible way to tell AI readers that a website has MCP functionality is to add it to the slash dot well known.

01:11:31.000 --> 01:11:37.000
or slash MCP dash server.

01:11:37.000 --> 01:11:38.000
I, I mean…

01:11:38.000 --> 01:11:39.000
file, I guess.

01:11:39.000 --> 01:11:40.000
The only time I…

01:11:40.000 --> 01:11:48.000
And wait a second, sorry. These are just conventions, like having slash feeds at the website root. Okay.

01:11:48.000 --> 01:11:49.000
Um, I…

01:11:49.000 --> 01:12:02.000
I'm absolutely sure that that's all true. The only time I've ever used dot well known as it's part of the.

01:12:02.000 --> 01:12:12.000
Let's encrypt automatic.

01:12:12.000 --> 01:12:17.000
Yeah.

01:12:17.000 --> 01:12:18.000
Yeah, yeah.

01:12:18.000 --> 01:12:20.000
certificate renewal. I didn't know that there were other uses for it. I would be fascinated to hear more about that. Someone write a blog post and I'll read it.

01:12:20.000 --> 01:12:21.000
Okay.

01:12:21.000 --> 01:12:33.000
Um, similar for my pro development, I've had good success with ChatGPT and Claude for generating Perl code. And recently implemented a local.

01:12:33.000 --> 01:12:48.000
So when QWEN, I don't know what that is based RUG pipeline that has REG, if my pronunciation doesn't work, pipeline that has access to our legacy code base.

01:12:48.000 --> 01:13:04.000
That required quite a lot, quite a bit of custom code to get the relationships just right as three sitter Python library most turnkey solution use. But okay, doesn't quite.

01:13:04.000 --> 01:13:12.000
Understand paragraph enough. Use the custom PPI-based processor to get the parsing right.

01:13:12.000 --> 01:13:14.000
Okay, so that was mostly just a comment. I don't know if…

01:13:14.000 --> 01:13:22.000
Yes, I do have a comment I'd like to push in at this point that

01:13:22.000 --> 01:13:31.000
Obviously, the coding that I'm doing is just mostly me and my websites, me and my personal.

01:13:31.000 --> 01:13:37.000
projects, I care about quality.

01:13:37.000 --> 01:13:52.000
But I'm not putting production code into situations where people are going to lose millions of dollars or it's going to put people's lives in danger. Obviously, if you're…

01:13:52.000 --> 01:13:58.000
working in a system that has more important effects.

01:13:58.000 --> 01:14:05.000
And you're going to need to have a lot more important.

01:14:05.000 --> 01:14:16.000
rules in place in order to make sure that the code that you put live is doing the right thing. And there are a couple of things that I would love you to.

01:14:16.000 --> 01:14:28.000
investigate Curtis Poe, who you probably all know as a well-known Pell programmer, has a…

01:14:28.000 --> 01:14:36.000
A project that he calls PAD, that's P-A-A-D. Oh, I see someone's already mentioning it.

01:14:36.000 --> 01:14:38.000
.

01:14:38.000 --> 01:14:50.000
in the chat as a series of skills for your agent to

01:14:50.000 --> 01:14:51.000
Work.

01:14:51.000 --> 01:14:59.000
I guess the idea is it makes them work more how a real programmer works.

01:14:59.000 --> 01:15:06.000
Um, so that's well worth looking at. Um, the other thing, and also from somebody who used to be really, um,

01:15:06.000 --> 01:15:14.000
Uh, big in the Pearl community is Jesse Vincent. Uh, he used to be the pumpkin back in 5.

01:15:14.000 --> 01:15:17.000
0.10 or something like that.

01:15:17.000 --> 01:15:22.000
When he has a project on GitHub called Superpowers.

01:15:22.000 --> 01:15:27.000
Which adds a lot of software engineering.

01:15:27.000 --> 01:15:43.000
I'm not going to say magic because it's engineering, but software engineering power to your agents and the models. So PAD and superpowers, both from people who have been big in the Perl world.

01:15:43.000 --> 01:15:49.000
some time, but two of the.

01:15:49.000 --> 01:15:53.000
Most popular, uh,

01:15:53.000 --> 01:15:59.000
agentic programming add-ons around at the moment. I think I can't

01:15:59.000 --> 01:16:14.000
remember the exact number, but Jesse recently, I saw him post somewhere that superpowers had reached something like the top 20 most starred projects on GitHub of all time.

01:16:14.000 --> 01:16:17.000
So people like these tools. Well worth looking at.

01:16:17.000 --> 01:16:21.000
Yeah, I heard about it. I didn't realize that's him. Okay.

01:16:21.000 --> 01:16:38.000
Oh, and yeah, so Scott was talking about how it's working in his company. There was a interview that Jesse Vincent was interviewed by Tim O'Reilly.

01:16:38.000 --> 01:16:39.000
Hmm.

01:16:39.000 --> 01:16:49.000
It's an O'Reilly thing, so you should be able to find it on YouTube just by googling their names. And it's, it was in the last two or three weeks.

01:16:49.000 --> 01:16:54.000
Uh, and Tim was asking him about how.

01:16:54.000 --> 01:16:58.000
Yes, he uses agents in his.

01:16:58.000 --> 01:17:06.000
company. And Jesse has one of these people. He's taken the approach of they actually have

01:17:06.000 --> 01:17:16.000
AIs who are employees of the company. They are they are colleagues, they are non-human colleagues working on the project as full.

01:17:16.000 --> 01:17:29.000
participants in the…

01:17:29.000 --> 01:17:30.000
Yeah.

01:17:30.000 --> 01:17:31.000
projects, and it's very interesting the way that they've been doing that. So I recommend that interview to you all.

01:17:31.000 --> 01:17:44.000
That's fascinating. Next comment here. I use cloud code agent a lot nowadays. I have the same problems, but telling Claude isn't enough. You need harness engineering.

01:17:44.000 --> 01:17:54.000
as this poor critic with lots of custom rules. For example, do not use evil, use try catch.

01:17:54.000 --> 01:17:55.000
Yeah, yeah.

01:17:55.000 --> 01:17:57.000
The file has used V5.40.

01:17:57.000 --> 01:18:02.000
I think that's the same thing that I'm saying. I mean, yes.

01:18:02.000 --> 01:18:09.000
the agent to use Pearl Critic is a really good start.

01:18:09.000 --> 01:18:10.000
Yeah.

01:18:10.000 --> 01:18:16.000
Looking into Pad and superpowers takes it to the next level or three levels up.

01:18:16.000 --> 01:18:23.000
Yeah, I mean, I probably tell the agent first to write the test that uses per critic.

01:18:23.000 --> 01:18:28.000
And then also tell it to also run those tests.

01:18:28.000 --> 01:18:29.000
Oh

01:18:29.000 --> 01:18:31.000
Yes, yes. I mean, I think,

01:18:31.000 --> 01:18:33.000
the…

01:18:33.000 --> 01:18:44.000
Getting into, uh, AI-driven programming is at the very least a really good reason to bring back test-driven.

01:18:44.000 --> 01:18:45.000
programming.

01:18:45.000 --> 01:18:53.000
Yeah, yeah, yeah. Knowing JavaScript is hard, is very hard. Okay.

01:18:53.000 --> 01:19:08.000
Models have no issues writing Perl code. Both cloud models available through APIs like Anthropic Cloud or even local ones, my locally running Ornit.

01:19:08.000 --> 01:19:23.000
5 and later teal coder, write Pearl that is correct and works just fine. Regarding the tools slash extensions slash skills, I found Curtis Pose.

01:19:23.000 --> 01:19:30.000
God, okay, that was you mentioned earlier, really useful as well as ThoughtWorks.

01:19:30.000 --> 01:19:34.000
SPDD.

01:19:34.000 --> 01:19:42.000
I don't know, SPDD, but that's obviously, yes, something else along the same lines as superpowers.

01:19:42.000 --> 01:19:49.000
Okay, uh, thank you, I will bounce out, but greatly appreciate the teachings.

01:19:49.000 --> 01:19:55.000
I forget to say that I put all those pro-critic tests into GitHooks. Yeah.

01:19:55.000 --> 01:19:57.000
Yeah.

01:19:57.000 --> 01:19:59.000
Okay…

01:19:59.000 --> 01:20:03.000
And I think I don't know. Oh, there is one more now. Event.

01:20:03.000 --> 01:20:08.000
And even this one is broken for me. Oh, uh…

01:20:08.000 --> 01:20:09.000
Yeah, GitHooks.

01:20:09.000 --> 01:20:12.000
Sorry.

01:20:12.000 --> 01:20:15.000
Ah, okay.

01:20:15.000 --> 01:20:23.000
Only Git hooks are 100% safe and can prevent Claude from repeating its mistakes. Okay, yeah, sure.

01:20:23.000 --> 01:20:25.000
Yeah, uh…

01:20:25.000 --> 01:20:36.000
GitHooks, maybe, or definitely running tests and having all these things in the test, whether.

01:20:36.000 --> 01:20:47.000
for the client, for the agent, or during the agent running, or after it, it's always a good idea, or definitely after it is a good idea to protect yourself from everything.

01:20:47.000 --> 01:20:49.000
Definitely, yeah, yeah.

01:20:49.000 --> 01:20:54.000
I mean, I have…

01:20:54.000 --> 01:21:01.000
I have little time for the people who say,

01:21:01.000 --> 01:21:08.000
You shouldn't write. You shouldn't use AI to write your code because it's just going to be.

01:21:08.000 --> 01:21:15.000
rubbish and stolen from everybody else because I just think it's a useful tool.

01:21:15.000 --> 01:21:19.000
Anyone that thinks it's rubbish hasn't tried it in the last two years.

01:21:19.000 --> 01:21:26.000
But equally, I don't buy the people who say that.

01:21:26.000 --> 01:21:33.000
programmers are all going to be out of a job by the end of next year because I think at the moment,

01:21:33.000 --> 01:21:34.000
Um,

01:21:34.000 --> 01:21:36.000
People.

01:21:36.000 --> 01:21:40.000
You need to have the experience that we all have.

01:21:40.000 --> 01:21:43.000
Um, in order to understand.

01:21:43.000 --> 01:21:47.000
How bad the code is or how good or bad the code is.

01:21:47.000 --> 01:21:59.000
The code is every week I hear a horror story about someone that vibe coded an app that they put on the Apple Store and then got.

01:21:59.000 --> 01:22:02.000
annoyed because…

01:22:02.000 --> 01:22:11.000
Three days later, it got popular and their server melted because they had no clue about scaling.

01:22:11.000 --> 01:22:12.000
Yeah.

01:22:12.000 --> 01:22:26.000
So, I think programmers are going to be needed for a while, but on the other hand, I am also quite glad that I'm at the end of my career and I consider myself semi-retired and I don't need to have a job as a programmer.

01:22:26.000 --> 01:22:28.000
Yeah.

01:22:28.000 --> 01:22:35.000
Okay, it's one other comment we need agent. We need an agent that was originally was.

01:22:35.000 --> 01:22:38.000
trained to write pure code. And I

01:22:38.000 --> 01:22:40.000
Yeah.

01:22:40.000 --> 01:22:47.000
Will Brushwell was working on something like that.

01:22:47.000 --> 01:22:48.000
That as you like.

01:22:48.000 --> 01:22:50.000
Okay. I have written…

01:22:50.000 --> 01:22:58.000
I have written a few custom MCP servers for our systems here, but they have been via

01:22:58.000 --> 01:23:15.000
God is Python scripts. However, one is connected to our testing pipeline, which uses Loki and Mimir to track failing tests and running module usage by our CI pipelines.

01:23:15.000 --> 01:23:25.000
In addition, I have one that tracks source commits, subversion is neat because it has it.

01:23:25.000 --> 01:23:34.000
We ask what's changed when the test started failing.

01:23:34.000 --> 01:23:35.000
Yeah.

01:23:35.000 --> 01:23:38.000
It also allows for us to run ad hoc CI tests on code changes during the day.

01:23:38.000 --> 01:23:39.000
Okay.

01:23:39.000 --> 01:23:44.000
Yeah, I mean, I feel like I should point out that

01:23:44.000 --> 01:24:00.000
Gabor thought he wanted a talk on MCP, and so he invited me because he'd read my blog post. I said, I don't know that I'm the right person because I don't really know very much about MCP. And he came back and said, well.

01:24:00.000 --> 01:24:11.000
You know more than anybody else that I know, so that's why I was talked into it. So, maybe I am the Pearl Communities

01:24:11.000 --> 01:24:27.000
Expert on MCP at the moment, but I'm certainly not the Pearl Community's expert on agentic.

01:24:27.000 --> 01:24:28.000
Yeah.

01:24:28.000 --> 01:24:35.000
programming for that, you really should see if you can get Jesse or Curtis to give one of these talks.

01:24:35.000 --> 01:24:36.000
I do know that, um…

01:24:36.000 --> 01:24:38.000
That's a good idea. I'll ask them, and maybe we'll have a session with them. 2 sessions with them.

01:24:38.000 --> 01:24:44.000
If I can do a small plug, I do know that, uh…

01:24:44.000 --> 01:24:51.000
Curtis is giving a talk at the London Pearl Workshop, which is a month today on the 21st of November.

01:24:51.000 --> 01:24:54.000
Um, and, um…

01:24:54.000 --> 01:24:58.000
That will definitely be on.

01:24:58.000 --> 01:25:01.000
AI programming.

01:25:01.000 --> 01:25:02.000
So that will be worth…

01:25:02.000 --> 01:25:03.000
Thank you.

01:25:03.000 --> 01:25:04.000
That's excellent. So go to London.

01:25:04.000 --> 01:25:09.000
If anyone can get to London for the day, I recommend it.

01:25:09.000 --> 01:25:22.000
Uh, excellent.

01:25:22.000 --> 01:25:23.000
Yeah, yeah.

01:25:23.000 --> 01:25:24.000
.

01:25:24.000 --> 01:25:31.000
Okay, I think it seems that we ran out of questions. I hope that you ran out of questions, because we need to finish at one point this session and actually, if people want to stay around, they are welcome, and then we can keep having the conversation.

01:25:31.000 --> 01:25:39.000
I got that in real time so people are going to speak and so on. So I'm…

01:25:39.000 --> 01:25:43.000
I would like to thank you again, really.

01:25:43.000 --> 01:26:01.000
Okay, so really thank you for this presentation and all the responses. And I would like to thank also to the people who participated and asked questions or didn't ask questions.

01:26:01.000 --> 01:26:16.000
adjuster here and listened. It was excellent. And if someone is watching on YouTube, then please click on the like button and follow the channel and below the video you will find the link to

01:26:16.000 --> 01:26:35.000
Some notes about this session, and I think and to Dave Cross, of course, there is a web page and low profiles, and maybe also to the slide. The slides, we can add them, maybe.

01:26:35.000 --> 01:26:36.000
Yeah.

01:26:36.000 --> 01:26:46.000
Yeah, I'll get the slides up somewhere very soon. Um, I've just put my email address in the chat. It's not hard to guess, it's dave at pearlhacks.com. PearlHacks is where I blog about Pearl. Um, I'm happy to answer any questions.

01:26:46.000 --> 01:26:50.000
email if anybody.

01:26:50.000 --> 01:26:51.000
Yeah.

01:26:51.000 --> 01:26:52.000
Once we get in touch.

01:26:52.000 --> 01:26:53.000
And thinks I can help.

01:26:53.000 --> 01:27:08.000
Thank you very much. And and again, if you're watching the video and you don't you will find the link to all these things below the video. There will be a link, and then you can find that information there. So thank you very much again. Now, I'm trying to click on the stop record.

01:27:08.000 --> 01:27:22.000
But my computer has issues, so maybe it won't work. So again, thank you very much and see you at the next event.


