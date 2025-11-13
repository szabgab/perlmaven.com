---
title: "Shutter crashing"
timestamp: 2025-11-13T11:35:02
published: true
description: ""
archive: true
show_related: false
---

A long time ago I used Shutter and found it as an excellent tool. Now I get all kinds of crashes.

Actually "Now" was a while ago, since then I upgraded Ubuntu and now I get all kinds of other error messages.

However, I wonder.

## Why are there so many errors?

Who's fault is it?

* A failure of the Perl community?
* A failure of the Ubuntu or the Debian developers?
* A failure of the whole idea of Open Source?

* Maybe I broke the system?

It starts so badly and then it crashes. I don't want to spend time figuring out what is the problem.
I don't even have the energy to open a ticket. I am not even sure where should I do it. On Ubuntu?
On the Shutter project?

Here is the output:


```
$ shutter
Subroutine Pango::Layout::set_text redefined at /usr/share/perl5/Gtk3.pm line 2299.
	require Gtk3.pm called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
Subroutine Pango::Layout::set_markup redefined at /usr/share/perl5/Gtk3.pm line 2305.
	require Gtk3.pm called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
GLib-GObject-CRITICAL **: g_boxed_type_register_static: assertion 'g_type_from_name (name) == 0' failed at /usr/lib/x86_64-linux-gnu/perl5/5.36/Glib/Object/Introspection.pm line 110.
 at /usr/share/perl5/Gtk3.pm line 489.
	Gtk3::import("Gtk3", "-init") called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
GLib-CRITICAL **: g_once_init_leave: assertion 'result != 0' failed at /usr/lib/x86_64-linux-gnu/perl5/5.36/Glib/Object/Introspection.pm line 110.
 at /usr/share/perl5/Gtk3.pm line 489.
	Gtk3::import("Gtk3", "-init") called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
GLib-GObject-CRITICAL **: g_boxed_type_register_static: assertion 'g_type_from_name (name) == 0' failed at /usr/lib/x86_64-linux-gnu/perl5/5.36/Glib/Object/Introspection.pm line 110.
 at /usr/share/perl5/Gtk3.pm line 489.
	Gtk3::import("Gtk3", "-init") called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
GLib-CRITICAL **: g_once_init_leave: assertion 'result != 0' failed at /usr/lib/x86_64-linux-gnu/perl5/5.36/Glib/Object/Introspection.pm line 110.
 at /usr/share/perl5/Gtk3.pm line 489.
	Gtk3::import("Gtk3", "-init") called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
GLib-GObject-CRITICAL **: g_boxed_type_register_static: assertion 'g_type_from_name (name) == 0' failed at /usr/lib/x86_64-linux-gnu/perl5/5.36/Glib/Object/Introspection.pm line 110.
 at /usr/share/perl5/Gtk3.pm line 489.
	Gtk3::import("Gtk3", "-init") called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
GLib-CRITICAL **: g_once_init_leave: assertion 'result != 0' failed at /usr/lib/x86_64-linux-gnu/perl5/5.36/Glib/Object/Introspection.pm line 110.
 at /usr/share/perl5/Gtk3.pm line 489.
	Gtk3::import("Gtk3", "-init") called at /usr/bin/shutter line 72
	Shutter::App::BEGIN() called at /usr/bin/shutter line 72
	eval {...} called at /usr/bin/shutter line 72
Variable "$progname_active" will not stay shared at /usr/bin/shutter line 2778.
Variable "$progname" will not stay shared at /usr/bin/shutter line 2779.
Variable "$im_colors_active" will not stay shared at /usr/bin/shutter line 2787.
Variable "$combobox_im_colors" will not stay shared at /usr/bin/shutter line 2788.
Variable "$trans_check" will not stay shared at /usr/bin/shutter line 2798.


... About 700 similar error messages ...


Name "Gtk3::Gdk::SELECTION_CLIPBOARD" used only once: possible typo at /usr/bin/shutter line 291.
WARNING: gnome-web-photo is missing --> screenshots of websites will be disabled!

 at /usr/bin/shutter line 9038.
	Shutter::App::fct_init_depend() called at /usr/bin/shutter line 195
Useless use of hash element in void context at /usr/share/perl5/Shutter/App/Common.pm line 77.
	require Shutter/App/Common.pm called at /usr/bin/shutter line 206
Useless use of hash element in void context at /usr/share/perl5/Shutter/App/Common.pm line 80.
	require Shutter/App/Common.pm called at /usr/bin/shutter line 206
Subroutine lookup redefined at /usr/share/perl5/Shutter/Draw/DrawingTool.pm line 28.
	require Shutter/Draw/DrawingTool.pm called at /usr/bin/shutter line 228
Variable "$self" will not stay shared at /usr/share/perl5/Shutter/Draw/DrawingTool.pm line 671.
	require Shutter/Draw/DrawingTool.pm called at /usr/bin/shutter line 228
Variable "$self" will not stay shared at /usr/share/perl5/Shutter/Screenshot/SelectorAdvanced.pm line 840.
	require Shutter/Screenshot/SelectorAdvanced.pm called at /usr/bin/shutter line 233
Failed to register: GDBus.Error:org.freedesktop.DBus.Error.NoReply: Message recipient disconnected from message bus without replying
```

