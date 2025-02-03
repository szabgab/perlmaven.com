---
title: "Analyze Apache log file - video"
timestamp: 2015-04-11T11:01:02
tags:
  - Apache
  - substr
  - index
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


This is the solution for the exercise <a href="https://code-maven.com/exercise-analyze-apache-log-file-count-localhost">Analyze Apache log file</>.

See more [exercises](https://code-maven.com/exercises) on the Code Maven site</a>.


<slidecast file="beginner-perl/analyze-apache-log-file" youtube="xoBllrape9I" />

We have a log file of the Apache web server (or for that matter Nginx or any other web server).
Each line describes a request made to the server. Each line starts with the IP address of the client
that made the request. Then an empty field. Then the timestamp of the request in square brackets.

Then comes the request itself followed by the [HTTP status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes).
(200 being OK, 404 being file not found, 500 Internal server error, etc.) and more data at the end. That's not really interesting for this
example.

What is really important is that at the beginning of each row there is an IP address.

{% include file="examples/files/apache_access.log" %}

Our tasks is quite simple. We have to count how many requests came from 127.0.0.1 and how many from anywhere else.

For that we are going to have two scalar variables as counters. `$local` to count the requests from 127.0.0.1,
and `$remote` to count all the other requests.

{% include file="examples/files/apache_log_hosts.pl" %}

We have the filename in a variable called `$file` and then we use the `open` function to
[open the file for reading](/beginner-perl-maven-open-file) `or die` if we could not open the file.

Then using a `while` loop we go over the file line by line.

Inside the loop the first thing we do is call [chomp](/chomp) to remove the new-line from the end of the row
even though in our case this does not matter, but we are used to it.

Then we call the [index](/beginner-perl-maven-string-functions-index) function. If you recall, given two string
`index` will return the location of the second string in the first one or -1 if it is not a substring.
We call it giving the current row and a space. `" "` It will return the location of the first space right after
the IP address. Because the index starts counting from 0 this will actually return the length of the IP address. Hence
we assign the result to the `$length` variable.

The we use the [substr](/beginner-perl-maven-substr) function to extract the IP address from the string.

Then we use simple `eq` to check if the extracted IP adress is `127.0.0.1` and update the appropriate
counter accordingly.

That's it. Once we went over all the lines of the file we can print out the number of local and remote requets we had.

We could not just use a fixed length as some IP addresses are longer and some are shorter, and some, for example
127.0.0.11  has the same beginning as the 127.0.0.1 we are looking for.
So we have to make sure we extract the exact IP address.

## Other soultions

While the skeleton of the program would remain the same there are a lot of other solution for the part inside the loop.
We used `index` and `substr` to find out the length of the current IP and extract it from the string.

We could have used just `substr $line, 0, 10` and then compare it to "127.0.0.1 " (with that space at the end).

We could also use a regular expression, but usually when I show this example we have not learnt regexes yet.

```
if ($line =~ /^127\.0\.0\.1 /) {
    $local++;
} else {
    $remote++;
}
```




