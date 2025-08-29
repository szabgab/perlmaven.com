---
title: "Perl/CGI script with Apache2"
timestamp: 2014-03-24T20:30:01
tags:
  - CGI
  - Apache2
published: true
books:
  - beginner
  - cgi
author: szabgab
---


While it is probably better to run a [PSGI](/perl-cgi-mod-perl-psgi) based server, than a CGI-based server
it can be also very useful to learn how to write CGI scripts. Especially if you need to maintain one.

This article will help you set up an Apache web server to run CGI scripts.


## Background start Linux, install Apache2

We will configure a [Digital Ocean droplet](/digitalocean), using Ubuntu 13.10 64bit.

After creating the Droplet, ssh to the server and update the installed packaged to the latest
and then reboot the machine.

(The droplet I was using to implement this had an IP address of 107.170.93.222 )

```
ssh root@107.170.93.222
# aptitude update
# aptitude safe-upgrade
```

Once the machine restarted ssh to it again and and install the MPM preforking version of Apache2.

```
ssh root@107.170.93.222
# aptitude install apache2-mpm-prefork
```

You can check if apache is running by executing `ps axuw`:

```
# ps axuw | grep apache
```

The output on my instance looked like this:

```
root      1961  0.0  0.5  71284  2608 ?        Ss   14:16   0:00 /usr/sbin/apache2 -k start
www-data  1964  0.0  0.4 360448  2220 ?        Sl   14:16   0:00 /usr/sbin/apache2 -k start
www-data  1965  0.0  0.4 360448  2220 ?        Sl   14:16   0:00 /usr/sbin/apache2 -k start
root      2091  0.0  0.1   9452   908 pts/0    S+   14:16   0:00 grep --color=auto apache
```

Now you can browse to the web-site by pointing your browser to the IP address of the
machine. In my case it was http://107.170.93.222/
Please note, some browsers will not work properly if you don't put the http:// in front of the IP address.

If everything works fine you will see something like this in the browser:

<img src="/img/apache2_default_page_on_ubuntu_1310.png" alt="Apache2 default page on Ubuntu 13.10">

This is the content of the /var/www/index.html file on the server.

You can edit that file, and reload the page in the browser.


## Creating the first CGI script in Perl

Create the /var/cgi-bin directory

(Please note, we don't create this inside the /var/www directory on purpose.
This way, even if misconfigured the server it won't serve the source code of the script.
Which is a good thing.)

```
mkdir /var/cgi-bin
```

and create a file called `/var/cgi-bin/echo.pl`
with the following content:

```perl
#!/usr/bin/perl
use strict;
use warnings;

print qq(Content-type: text/plain\n\n);

print "hi\n";
```

Make the file executable by 

```
chmod +x /var/cgi-bin/echo.pl
```

and run it on the command line:

```
# /var/cgi-bin/echo.pl
```

It should print:

```
Content-type: text/plain

hi
```

This is your first CGI-script in Perl.

Now we need to configure the Apache web server to server it properly.

## Configure Apache to serve CGI files

Open the configuration file of Apache `/etc/apache2/sites-enabled/000-default.conf`

It has the following in it with a bunch of comments between the lines:

```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Add the following lines after the DocumentRoot line:

```
         ScriptAlias /cgi-bin/ /var/cgi-bin/
         <Directory "/var/cgi-bin">
                 AllowOverride None
                 Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                 Require all granted
         </Directory>
```

Now you should have:

```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www

         ScriptAlias /cgi-bin/ /var/cgi-bin/
         <Directory "/var/cgi-bin">
                 AllowOverride None
                 Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                 Require all granted
         </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```


This will configure http. For a real public site consider using https.
Check out [the importance of using https](https://code-maven.com/the-importance-of-https)
if you'd like to know why.


By default this Apache instance does not have the CGI module enabled.
This we can see by noticing that the mods-enabled directory does not have any of the cgi files
that are available in the mods-available directory:

```
# ls -l /etc/apache2/mods-enabled/ | grep cgi
# ls -l /etc/apache2/mods-available/ | grep cgi
-rw-r--r-- 1 root root   115 Jul 20  2013 cgid.conf
-rw-r--r-- 1 root root    60 Jul 20  2013 cgid.load
-rw-r--r-- 1 root root    58 Jul 20  2013 cgi.load
-rw-r--r-- 1 root root    89 Jul 20  2013 proxy_fcgi.load
-rw-r--r-- 1 root root    89 Jul 20  2013 proxy_scgi.load
```

We create symbolic links from the mods-enabled to the mods-available directory
for the two cgid.* files, and then check again if the symbolic links were created properly
by running `ls -l` again:

```
# ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/
# ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/

# ls -l /etc/apache2/mods-enabled/ | grep cgi
lrwxrwxrwx 1 root root 37 Mar 19 14:39 cgid.conf -> /etc/apache2/mods-available/cgid.conf
lrwxrwxrwx 1 root root 37 Mar 19 14:39 cgid.load -> /etc/apache2/mods-available/cgid.load
```

At this point we can reload the Apache web server by the following command:

```
# service apache2 reload
```

This will tell Apache to read the configuration files again.

Then we can brows to http://107.170.93.222/cgi-bin/echo.pl
(after replacing the IP address by yours) and you will see it shows the word "hi".

Congratulations, your first CGI script is running.

## Dynamic results

This simple CGI script will show exactly the same content no matter who access it and when.
Let's make a little change to the script so that we can see it is really generated
dynamically.

```perl
#!/usr/bin/perl
use strict;
use warnings;

print qq(Content-type: text/plain\n\n);

print scalar localtime;
```

After changing the script if you access the page now it will display the current time on the server.
If you reload the page, it will show the new current time.


## Trouble shooting

If when you access the  http://107.170.93.222/cgi-bin/echo.pl URL you see
the content of the script instead of the word "hi" then you probably put the cgi-bin directory
inside the /var/www and/or probably forgot to create the symbolic links for the cgid.* files.
Move the cgi-bin directory outside the /var/www, update the configuration files, set up
the symbolic links, and reload the server.

<h3>500 Internal Server Error</h3>

If you get an `500 Internal Server Error` look at the error log in `/var/log/apache2/error.log`

```
[Wed Mar 19 15:19:15.740781 2014] [cgid:error] [pid 3493:tid 139896478103424] (8)Exec format error: AH01241: exec of '/var/cgi-bin/echo.pl' failed
[Wed Mar 19 15:19:15.741057 2014] [cgid:error] [pid 3413:tid 139896186423040] [client 192.120.120.120:62309] End of script output before headers: echo.pl
```

This can happen if the script does not start with a sh-bang line pointing to a correctly
installed perl. The first line of the file should be

```
#!/usr/bin/perl
```

```
[Wed Mar 19 15:24:33.504988 2014] [cgid:error] [pid 3781:tid 139896478103424] (2)No such file or directory: AH01241: exec of '/var/cgi-bin/echo.pl' failed
[Wed Mar 19 15:24:33.505429 2014] [cgid:error] [pid 3412:tid 139896261957376] [client 192.120.120.120:58087] End of script output before headers: echo.pl
```

This probably indicates that the file is in DOS format. This can happen if you have ftp-ed the file from a Windows machine in binary mode.
(You should not use ftp anyway.) You can fix this by running 

```
dos2unix /var/cgi-bin/echo.pl
```

```
[Wed Mar 19 15:40:31.179155 2014] [cgid:error] [pid 4796:tid 140208841959296] (13)Permission denied: AH01241: exec of '/var/cgi-bin/echo.pl' failed
[Wed Mar 19 15:40:31.179515 2014] [cgid:error] [pid 4702:tid 140208670504704] [client 192.120.120.120:60337] End of script output before headers: echo.pl
```

The above lines in the error.log, probably indicated that the script does not have the Unix executable bit. 

```
chmod +x /var/cgi-bin/echo.pl
```

```
Wed Mar 19 16:02:20.239624 2014] [cgid:error] [pid 4703:tid 140208594970368] [client 192.120.120.120:62841] malformed header from script 'echo.pl': Bad header: hi
```

This will be received if there is an output before the the Content-type. For example if you have written the two print-lines in reversed order like this:

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "hi\n";
print qq(Content-type: text/plain\n\n);
```


```
[Wed Mar 19 16:08:00.342999 2014] [cgid:error] [pid 4703:tid 140208536221440] [client 192.120.120.120:59319] End of script output before headers: echo.pl
```

This probably means that the script died before it managed to print the `Content-type`. The error.log, probably contains the
exception that was not caught just before the above line.

You can also turn of the buffering of STDOUT by setting `$|` to a [true](/boolean-values-in-perl) value.

```
$|  = 1;
```

I am not sure, but I think **Premature end of script headers**  is the same as **End of script output before headers**.

<h3>503 Service Unavailable</h3>

After I created the symbolic links to the cgid.* files and reloaded the Apache server,
I got **503 Service Unavailable** in the browser and the following line in the log file:

```
[Wed Mar 19 15:30:22.515457 2014] [cgid:error] [pid 3927:tid 140206699169536] (22)Invalid argument: [client 192.120.120.120:58349] AH01257: unable to connect to cgi daemon after multiple tries: /var/cgi-bin/echo.pl
```

I am not sure why did this happen, but it after restarting the apache server it started to work properly:

```
# service apache2 restart
```

In most of the situations a reload should be enough, but maybe not when a module is enabled/disabled.


<h3>404 Not Found</h3>

If you get a **404 Not Found** error in the browser and

```
[Wed Mar 19 15:35:13.487333 2014] [cgid:error] [pid 4194:tid 139911599433472] [client 192.120.120.120:58339] AH01264: script not found or unable to stat: /usr/lib/cgi-bin/echo.pl
```

in the error log, then maybe the `ScriptAlias` line is missing, or not pointing to the proper directory.


<h3>403 Forbidden</h3>

If you get a **403 Forbidden** error, the probably the `Directory` directive was not correctly configure
or does not point to the correct path.


## Summary

That's it. Hopefully, you have your first CGI script in Perl running.

Of course using PSGI is much more [modern](/modern-web-with-perl) and much more flexible 
than CGI. For that you might want to check out the [Perl Dancer](/dancer), or the [Mojolicious](/mojolicious) frameworks.
They provide a better experience.

## Comments

I just wanted to thank you for this detailed guide. I've been trying to get perl running correctly with Apache2 for so long I never thought i'd see it run. I think all the other guides must have assumed some other software was present, but this guide worked from a fresh install, thanks so much!

<hr>

Mirroring the previous comment; thanks so much. I went through a bunch of guides and posts but ultimately this was the one that got my Perl working.

Such a good job. I am definitely bookmarking this site!!

<hr>

This link is spot on and thanks to Gabor for this effort.

<hr>
Thanks for the hint about the AH01257 error in Apache; I just spun up a new DO droplet and was being vexed by that one.

<hr>
Thanks for the great guide!

I am running into an issue where test.pl never loads - no errors in the browser and no errors in the logs. Do you know what could cause this? The link is https://stroh.family/cgi-bin/test.pl


You'd probably need to describe the situation in more detail to get help. e.g. What if you run "perl test.pl" on the command line? What is in test.pl? What are the rights on that file? What is in the web server configuration file?


Can you run ./test.pl as well ? Without prefixing with perl.


Yep, that gives the same output as when using the Perl prefix.


Then I ran out of ideas for this remote debugging session.

I appreciate the help! I will keep working and will update my initial comment if I figure it out.

<hr>

How works that with nginx? Thank you very mich.

<hr>

It is really a great post. Things happen exactly as described and they are explained!. The "Trouble shooting" section is very usefull too. Thanks a lot Gabor. One question: why do you suggest creating /var/cgi-bin directory instead of using the existing one /usr/lib/cgi-bin (on Debian Jessie) ? And with your permission one suggestion: Nowadays most of the sites are secured with SSL certificates. Thus the virtual host configuration file to be modified concerns <virtualhost *:443=""> Maybe it's worth to be mentionned.


I think the reason was that I want to be sure it is not overwritten when an upgrade to the OS happens.

Regarding https, mentioning it might be a good idea, but configuring it would need another post. Maybe with a link here: https://code-maven.com/the-importance-of-https

<hr>

Am a perl developer and am following your page for improving my knowledge in perl.
During lockdown i started implementing perl projects in my personal computer. So i installed the Strawberry perl in my windows machine. Perl Script is running fine in cmd prompt. Could please guide me how to install apache in windows machine and configuring the conf files to run the perl files in website?

My suggestion would be to install Linux in a VirtualBox environment or to use Docker on that Windows.

Thanks for the info!
