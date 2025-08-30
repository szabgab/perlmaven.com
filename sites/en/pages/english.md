---
title: "English"
timestamp: 2021-02-23T19:00:01
tags:
  - English
published: true
author: szabgab
archive: true
show_related: true
---


The [English](https://metacpan.org/pod/English) module allows you to replace the internal variables of Perl
that mostly use special characters to use variable names that look more like English words.


The recommended way is to write:

```perl
use English qw( -no_match_vars );
```

That will avoid the inclusion of some of the regex-related variables that slowed down Perl in version 5.18 and before.

## Examples

* [$$ - $PROCESS_ID - $PID](/process-id)
* [$| - $OUTPUT_AUTOFLUSH](/output-autoflush)
