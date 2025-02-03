---
title: "Dancer2: Hello World"
timestamp: 2022-02-07T08:00:01
tags:
  - Dancer2
  - plackup
published: true
books:
  - dancer2
author: szabgab
types:
  - screencast
archive: true
show_related: true
---


Part of the Dancer2 video course available both to [Pro](/pro) subscribers and attendees of the [Perl Dancer course](https://leanpub.com/c/dancer) on Leanpub.


[Hello World](https://code-maven.com/slides/dancer/hello-world-with-dancer)

{% youtube id="qK9tDFTvHlo" file="english-dancer2-hello-world.mkv" %}

In this video first we check what happened to the installation and then if it was successful then we are going to write our first Dancer-based web application.

Then I can go to the Command Prompt or the Power Shell if I was on Windows, or if I was on Linux or Mac I'd go to the terminal and type in the following:

```
perl -MDancer2 -e1
```

This will run <b>perl</b>. <b>-MDancer2</b> will make it try to load the <b>Dancer2</b> module into memory and <b>-e1</b> just tells perl to execute the program
consisting of the number <b>1</b> which is a non-operation. It basically tells perl to do nothing.
The goal here is to see if perl can find and load the Dancer2 module.

If there is no output to the screen that means everything is fine. Unlike in the previous case when this command failed.

This, not having any output, means that Dancer2 is installed.

If, however, we try

```
perl -MDancer3 -e1
```

We'll get something like:

```
Can't locate Dancer3.pm in @INC (you may need to install the Dancer3 module) (@INC contains:
/home/gabor/perl5/lib/perl5/5.34.0/x86_64-linux-gnu-thread-multi
/home/gabor/perl5/lib/perl5/5.34.0
/home/gabor/perl5/lib/perl5/x86_64-linux-gnu-thread-multi
/home/gabor/perl5/lib/perl5
/etc/perl
/usr/local/lib/x86_64-linux-gnu/perl/5.34.0
/usr/local/share/perl/5.34.0
/usr/lib/x86_64-linux-gnu/perl5/5.34
/usr/share/perl5
/usr/lib/x86_64-linux-gnu/perl-base
/usr/lib/x86_64-linux-gnu/perl/5.34
/usr/share/perl/5.34
/usr/local/lib/site_perl).
BEGIN failed--compilation aborted.
```

This failed obviously because Dancer3 is not installed because it does not even exist.

It told me that it can't locate Dancer3 and that I should install it.

Of course perl does not know that my problem here is not the lack of installation, but that I made a mistake (on purpose) in the name of the module.


## Course slides

The other thing that we left at the end of the previous video was the unzipping of the course material.
If you switch to the other window - the file explorer - where you started the unzip, you'll see a folder (directory) called <b>slides-main</b>.

Within the <b>slides-main<b> you will find a folder for each training course I have.

The Dancer2 course material is within the <b>perl</b> course and thus in the <b>perl</b> folder.

Within the <b>perl</b> folder you'll find the example files from the slides by following the path that you can see above each example on the slides.
For example [here](https://code-maven.com/slides/dancer/hello-world-with-dancer).

Then I switched to the Command Prompt/Terminal and typed in <b>cd</b> (change directory) and then the path where I wanted to switch to.

I can go to the file-explorer, click on the "address bar" and then it will show me the full path to the directory I am viewing.
I can copy that by pressing <b>Ctrl-C</b> then I can paste it to the terminal window my clicking on the right button of the mouse.

Then I can press the `Home` key to jump to the beginning of the line and type in <b>cd</b>.

```
cd c:\course\slides-main\perl\examples\dancer\hello_world
```

By pressing `ENTER` I'll jump to the selected folder.

If now I type in

```
dir
```

I can see the files that are in that directory.

```
... app.psgi
... test.out
... test.t
```


Switching to the file-explorer I can see the same.

Among the 3 files in the directory: <b>app.psgi</b> is the file that we'll actually need now. That's where our "application" is.
<b>test.t</b> is the test file that is checking that our code works properly.

Then you'll find all kinds of extra files with <b>.out</b> extension that you won't have in a real application.
I only have them to store the output of various commands so I can include it in the slides.
You don't have to worry about those files.

## Hello World

The content of the <b>app.psgi</b> file can be seen here:

{% include file="examples/dancer/hello_world/app.psgi" %}

What you need to do at this point is type in the Command Prompt:

```
plackup
```

It will print something like this on the screen:

```
HTTP::Server::PSGI: Accepting connections at http://0:5000/
```

This tells us that the server is running and accepting connection on port 5000.

If you are using Windows, you'll probably also see a pop-up of the <b>Windows Defender Firewall</b> saying that it has blocked
some features of this app.

This happens if you have the Windows Firewall on your computer that will limit the access to your computer.

It has two checkboxes, one to enable access on <b>Private networks</b>, the other to enable access on <b>Public networks</b>

For some reason on my computer the Public networks was checked. I prefer to only allow access on Private networks so I checked that box
and unchecked the box of the Public networks.

Then I clicked <b>Allow access</b>. It took a couple of seconds to make the pop-up disappear.
It might have been slow because I was recording the video on a Windows running in a Virtual Box while the video-recording was running.
So my computer was already busy.

Then I can open my browser to the URL that was listed on the terminal window: [http://0:5000/](http://0:5000/). (you should be able to just click on this link)

If that does not work you can also try to type in [http://127.0.0.1:5000/](http://127.0.0.1:5000/) which is going to "localhost" which is your computer.

Finally you can try [http://localhost:5000/](http://localhost:5000/).

In the video you can see that I tried all of these using the browser that came with Windows (I think it was Edge).

## Install Firefox or Chrome

So because I could not convince Edge to work I decided to download [Firefox](https://www.mozilla.org/en-US/firefox/new/). Which is Open Source so I like it.

While I was waiting for Firefox to be installed I tried Edge again and this time it worked.

Either I did something incorrectly earlier or Edge just got scared when it saw I am downloading Firefox and started to work.

## Finally it works!

So we can see in the browser <b>Hello World1</b>. It's not much of a web application, but it works and it is ours!

In the terminal/Command Prompt window you can see the access log. Apparently also the previous attempts showed up even though we did not
get a response in the browser.

## The code

Let's go over the code now.

```
package App;
```

This is just the declaration of the Perl package. The name <b>App</b> isn't really important here. You can put there virtually anything.
As long as at the end of the code you use the same name.


```
use Dancer2;
```

This loads the Dancer2 module. (This is what the <b>-MDaner2</b> did on the command line.)

```
get '/' => sub {
    return 'Hello World!';
};
```

This is called a <b>route</b>.

The way Dancer works is that we need to map URL pathes to anonymous functions. (You could also use named functions, but they are usually anonymous.)

The "path" is the part that comes in the URL after the name of web site. So in case of this URL: "https://code-maven.com/slides/dancer/hello-world-with-dancer"
The part "/slides/dancer/hello-world-with-dancer" is the path.

In case of "http://localhost:5000/"  the path is just "/" though when I typed it in the browser hid it.

I could also type in some longer path, for example I tried "http://localhost:5000/hello" and I got a <b>Error 404 - Not Found</b> message.
That's because the path <b>/hello</b> has not been defined in this application.

After the <b>get</b> keyword is the path we are mapping.

After the fat-arrow <b>=&gt;</b> you can see the anonymous subroutine. Whatever it returns is sent back to the browser.

It can return some HTML to make a nice page, but in our case we only returned the plain text "Hello World!" and the browser displayed it.

The code with the fat-arrow might look a bit strange, especially if you know Perl, but it is basically just a key-value pair
where the path is the key and the anonymous function is the value.

Just don't forget the semi-colon at the end of that block! This is one of the cases when after the closing of curly braces you have to put a semi-colon
because this is a statement and not just a block.

The same as this code written slightly differently might help you understand what's really going on here.

```
get('/', sub {
    return 'Hello World!';
});
```

We imported the <b>get</b> function from the Dancer2 module. This function gets two parameters. The first one is the path and the second one is the function
to be executed when someone requests that path.


## Stop the application

To stop the application you need to switch to the terminal/command prompt again and press <b>Ctrl-C</b>. Windows will ask you for confirmation. Type Y.

## Testing

Then remains the question, how do we know that this actually works. Without manually starting the whole thing and then visiting the web site?
This is what we'll see in the next video.

