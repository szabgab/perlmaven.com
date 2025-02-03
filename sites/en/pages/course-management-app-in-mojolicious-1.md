---
title: "Course Management Application in Mojolicious - part 1"
timestamp: 2021-04-12T08:30:01
tags:
  - Mojolicous
published: true
types:
  - screencast
books:
  - mojolicious
author: szabgab
archive: true
description: "Building a web application in Mojolicous for course management"
show_related: true
---


This is the first part of the [Course Management Application in Mojolicious](/course-management-app-in-mojolicious) project with  [Mark Gardner](https://phoenixtrap.com/).


* [Git Repository](https://github.com/szabgab/course-management)
* [Mojo::File](https://docs.mojolicious.org/Mojo/File)
* [How Upload file using Mojolicious?](https://stackoverflow.com/questions/10152973/how-upload-file-using-mojolicious)
* [Mojo::Upload](https://docs.mojolicious.org/Mojo/Upload)
* [Mojolicious::Routes::Route](https://docs.mojolicious.org/Mojolicious/Routes/Route)
* [The Stash](https://mojolicious.io/blog/2017/12/02/day-2-the-stash/)
* [NotYAMLConfig](https://docs.mojolicious.org/Mojolicious/Plugin/NotYAMLConfig)

```
perl -MMojolicious -E 'say $Mojolicious::VERSION'
cpanm Mojolicious

mojo generate app Course::Management
perl script/course_management daemon
morbo script/course_management
```

{% youtube id="_AInPp-dneQ" file="mojolicious-1-1920x1080.mp4" %}
