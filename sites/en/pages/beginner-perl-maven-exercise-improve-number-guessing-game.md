---
title: "Exercise: improve number guessing game - video"
timestamp: 2015-06-23T05:30:33
tags:
  - exercise
published: true
books:
  - beginner_video
author: szabgab
---


Exercise: improve number guessing game


This exercise also has several steps.

First of all, let the user guess several times (with responses each time), until she finds the hidden number.

Allow various special keys too:
* n - skip the rest of this game (give up) and start a new game with new hidden number.
* s - show the hidden value (cheat).
* m - toggle: turn on/off move mode: When the move mode is on, after every guess the number can change by 2 in either direction.
* d - toggle: turn on / off debug mode. In debug mode show the hidden number every time before you are asked to supply the guess.
* x - exit

Now I can tell you that this is actually a 1 dimensional space fight. The number is your distance from the enemy space ship.

For training purposes limit the outer space to be between 0-100 so even when the move mode is on the space-ship won't fly off this area.

Finaly, keep track of the minimum and maximum score (number of guesses till hit) in a file.

