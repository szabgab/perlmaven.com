---
title: "Here documents - video"
timestamp: 2015-03-11T11:01:48
tags:
  - <<
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Here documents


{% youtube id="uXgnmhzwehQ" file="beginner-perl/here-documents" %}

A gotcha: The `END_STRING` we have put at the end of the string must be exactly the same as we have at the beginning.
You can't even have extra whitespaces! So make sure the `END_STRING` at the end of the here document starts at the first character of the line and has no spaces,
tabs, or other invisible characters at the end of the line.

