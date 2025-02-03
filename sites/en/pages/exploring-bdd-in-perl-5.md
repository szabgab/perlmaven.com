---
title: "Exploring BDD in Perl - using Test::BDD::Cucumber - part 5 - with Erik Hülsmann"
timestamp: 2021-04-02T08:30:01
tags:
  - testing
  - BDD
  - Cucumber
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


BDD - [Behavior Driven Development](https://en.wikipedia.org/wiki/Behavior-driven_development)
using [Test::BDD::Cucumber](https://metacpan.org/pod/Test::BDD::Cucumber)

This time it was together with [Erik Hülsmann](https://www.linkedin.com/in/erikhuelsmann/) the maintainer of the module.


We mostly workd on writing test for the [course management project](/course-management-app-in-mojolicious)
that has its source code [on GitHub](https://github.com/szabgab/course-management)

{% youtube id="Si-8SUEt0vA" file="english-live-perl-test-bdd-cucumber-part-5_1920x1080.mp4" %}


```
pherkin --theme light --tags ~@email_available t/
pherkin --theme light --tags @email_available t/
pherkin --theme light --tags @email_available @short t/
pherkin --theme light --tags @email_available --tags @short t/
```

```
prove --source Feature --ext=.feature  t/
prove -v --source Feature --ext=.feature  t/
prove -v --source Feature --ext=.feature --ext=.t t/
```


<!--
Scheduled for April 11: 12:00 Israel - Check out your time on the registration page.

<a class="btn btn-lg btn-success" href="https://us02web.zoom.us/meeting/register/tZAlde2vpz8jEt1ZIJgHEI3NVEbz9oQH0Lzl">Register here</a>
-->

Use this link to include the the schedule in your calendar: [https://code-maven.com/events.ics](https://code-maven.com/events.ics).

