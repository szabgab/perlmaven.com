---
title: "Course Management Application in Mojolicious - part 3"
timestamp: 2021-04-19T09:30:01
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


The third part of the live development [course management application](/course-management-app-in-mojolicious) using Mojolicous together with [Mark Gardner](https://phoenixtrap.com/).


Mark wrote in [issue 1](https://github.com/szabgab/course-management/issues/1):
<quote>
I think we should take @jberger's advice from our first YouTube session and move our config retrieval into a set of helper functions.
The config file is basically our data model, and the templates know too much about how it's structured -- that's not good design.
We should instead have a helper function for listing the courses, another for listing the users in a course, another for the exercises, etc..
This will decouple our views (templates) from our model, and make our templates easier to write
(important if you're handing them off to designers) and not have to rewrite them even if we eventually replace the static config with another storage option (like a database).

We can discuss more in our next session.
</quote>

* [Git Repository](https://github.com/szabgab/course-management)
* [Mojolicious Session](https://docs.mojolicious.org/Mojolicious/Sessions)
* [Mojolicious Controller session](https://docs.mojolicious.org/Mojolicious/Controller#session)

```
morbo script/course_management

prove -vl
```

{% youtube id="eWh-hXTsumg" file="mojolicious-3-1920x1080.mp4" %}
