---
title: "Course Management Application in Mojolicious"
timestamp: 2021-05-01T21:30:01
tags:
  - Mojolicous
published: true
books:
  - mojolicious
author: szabgab
archive: true
description: "Building a web application in Mojolicous for course management"
show_related: true
---


In my [training course](https://code-maven.com/courses) I give exercises to my students. They can (and in some of these course they must) submit them.
I can then review them and give comments. I would like to have a web application to keep track of all the exercises and the submission.

In this experimental project [Mark Gardner](https://phoenixtrap.com/) and myself will develop this application using live pair programming.


<!--
Part 6 is scheduled for <span id="localdate" x-schedule="2021-06-13T18:00:00+03:00"></span>

<a class="btn btn-lg btn-success" href="https://us02web.zoom.us/meeting/register/tZEvf-6pqjsrHdFJKQkP-cDG74BSaNSGmCxC">Register here</a>

(If you registered to the first event you are already registered to this one as well.)

Use this link to include the the schedule in your calendar: [https://code-maven.com/events.ics](https://code-maven.com/events.ics).
-->

## Plan

That will evolve.

A system to handle exercise submissions and reviews.

* Admin can create (schedule) a course. (CLI is acceptable)
* Admin can add a list of exercises to a course. An exercise can be just a link a page to the appropriate [slide](https://code-maven.com/slides/). (Some of them might be marked as mandatory.) (CLI is acceptable)
* Admin can add names and email addresses, and associate them with a course. (Same user might come back to another course. That should be possible.) (CLI is acceptable)
* Students can log in using the email address and a one-time code they get to the email that will keep them logged in for 24 hours from the last time they accessed the page. I think there is no need to store and manage passwords.
* Students can see the list of exercises.
* Students can upload the solutions, and see that they were uploaded. (Shall we allow uploading multiple exercises at once or is the individual upload a better idea?)
* Students can upload a new revision of the exercise. Both student and admin can see the list of revisions.
* Students can see the progress of others (as an average, or figures without names)
* Admin can mark exercises as "reviewed". (marking a specific revision of the exercise) GUI
* Admin can type in some answer that is shown on the page (to the logged in individual). Comments are also sent to the person by email. (associate with specific revision of the exercise.)
* Students might be also comment on my comment. (Do we need this?)
* Admin can prepare and use some canned answers. (preparing the answers can be CLI, but selecting and using them is on the GUI)
* The server must store the files in a place that is easy for the admin to sync using the command line. (e.g. Dropbox or Git)
* A student who has submitted an exercise can see the solutions of others of the same exercise and maybe even comment on them.

* [Git Repository](https://github.com/szabgab/course-management)

* [Part 1](/course-management-app-in-mojolicious-1)
* [BDD - Describing the project using Cucumber](/exploring-bdd-in-perl-5) with Erik Hülsmann
* [Part 2](/course-management-app-in-mojolicious-2)
* [Part 3](/course-management-app-in-mojolicious-3)
* [Part 4](/course-management-app-in-mojolicious-4)
* [DevOps work - setting up CI and Docker for the course management project](https://code-maven.com/setting-up-ci-and-docker-for-course-management-app) with Thomas Klausner
* [Part 5](/course-management-app-in-mojolicious-5)
* [Part 6](/course-management-app-in-mojolicious-6)
* [Part 7](/course-management-app-in-mojolicious-7)
<!--
* <a href=""></a>
-->
