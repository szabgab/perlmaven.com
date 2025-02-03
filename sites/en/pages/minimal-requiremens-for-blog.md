---
title: "Minimal requirements for a blog"
timestamp: 2020-09-23T11:30:01
tags:
  - Perl
  - blog
published: true
author: szabgab
archive: true
description: "Writing a blog engine can be an intersting exercise."
show_related: true
---


A while ago I've started to think about creating a project that could be used as a replacement for the blogs.perl.org site and as a
teaching tool to show various technologies. I asked a number of people about it. Many said they think it would be too big a project
and I would not be able to get enought people supporting it. They might be right.

Since then there was also a small movement agains having a shared blogging platform for Perl, so maybe I should not get in this project.

In any case, let me publish here a few notes I made as minimal requirements.

In case I, or someone else will like to pick up the idea later on.


* Authenticate with fixed usernames and passwords.
* Edit page. Page can be saved on disk.
* Accept free text escape any less than sign.
* Accept markdown.
* Embed videos.
* Upload images and show them.
* Archive of posts.
* Global RSS feed for new posts.
* Global RSS feed for everything, including posts and comments.
* Individual RSS feed.
* Admin hide post.
* Admin disable account.
* Commenting system with flat view.
* Commenting system with hierarchical view.
* Change password.
* Reset password.
* Register with email verification.
* Email notifications?
