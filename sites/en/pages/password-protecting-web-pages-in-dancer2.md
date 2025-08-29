---
title: "Password protecting web pages in Dancer 2"
timestamp: 2015-06-02T07:10:01
tags:
  - Dancer2
  - Dancer2::Plugin::Auth::Extensible
  - Term::ReadPassword::Win32
published: true
books:
  - dancer2
author: szabgab
archive: true
---


What if you'd like to have a web application, but you want to make sure certain pages can be only visible only by people with certain rights.
You need to somehow authenticate the visitors. This can be done with a full-blown user management system, but in the simple case it might
be enough, or even better to have the users and their passwords hard-coded in the application, or in the configuration files of the application.

In this article you'll see how to do that for a [Dancer](/dancer) based application.


## Use Case

A simple use case might be an in-house web application that is only needed by a very limited number of people.
In this application we'll have the main page `/` answer to every user, and we'll also have a page called
`/report` that will be only accessible to a user who provides a correct username/password pair.


In this article we are going to use [Dancer2::Plugin::Auth::Extensible](https://metacpan.org/pod/Dancer2::Plugin::Auth::Extensible)
and a very simple method of password protection.

We have already seen how to create a simple [single-file hello world in Dancer 2](/hello-world-with-dancer2).

As a start we do the same here:

{% include file="examples/dancer2/auth-v1/app.pl" %}

There is nothing special in this application, just two routes. We can launch the application by typing in

```
$ plackup -R . app.pl
```

This will launch a web server on port 5000 which is accessible from our browser.

### Vagrant

If you use the [Vagrant based Perl Development Environment](/vagrant-perl-development-environment) you'd
probably create the `app.pl` file on the host system in the directory where you also have the `Vagrantfile`.

Then you'd need to change the `Vagrantfile` itself to include the following line:

```
  config.vm.network "forwarded_port", guest: 5000, host:5000
```

this will map port 5000 of the VirtualBox machine to port 5000 of your desktop.
After doing this you'll need to (re)start the virtual machine:

```
$ vagrant halt
$ vagrant up
```

Then you'd ssh to the Virtualbox using the `vagrant ssh` command, switch to the `/vagrant` directory,
and launch the server there:

```
$ vagrant ssh                              (on your computer)

vagrant@perl-maven:~$ cd /vagrant          (already in the VirtualBox)

vagrant@perl-maven:/vagrant$ plackup -R . app.pl 
Watching . ./lib app.pl for file updates.
HTTP::Server::PSGI: Accepting connections at http://0:5000/
```

Then again you can use the browser of your desktop computer to access `http://127.0.0.1:5000/`

The main page will display

`This is a public page. Everyone can see it. Check out the report</a>

if you click on the **report** link it will lead you to `http://127.0.0.1:5000/report`
displaying `Only authenticated users should be able to see this page`.

## Limiting the access to the report page

What we would like to achieve is to limit the access to the `/report` page to only authenticated users.

We changed the application loading [Dancer2::Plugin::Auth::Extensible](https://metacpan.org/pod/Dancer2::Plugin::Auth::Extensible)
into memory and changing the `/report` route to this:

```
get '/report' => require_role Marketing => sub {
```

The file now looks like this:

{% include file="examples/dancer2/auth-v2/app.pl" %}

If we try to access `http://127.0.0.1:5000/` it will show the same page as earlier, but if we try to access the report page
at `http://127.0.0.1:5000/report` it will redirect us to `http://127.0.0.1:5000/login?return_url=%2Freport` and show
a plain login form:

<img src="/img/dancer2_auth_login_form.png" alt="Dancer2 plain login form" />

We did not have to restart the application for this to take effect because we launched it using the `plackup -R .` command
which means plackup will monitor the whole directory and if anything changes it will reload the whole application.

We have limited the access to the report page, but how can we now enable "Marketing" to access the page?

## Configure a user

The Authentication and Authorization plugin can use a number of back-ends to store the users, passwords and roles, but
we'll use the most simple one called [Config](https://metacpan.org/pod/Dancer2::Plugin::Auth::Extensible::Provider::Config)
that uses the regular configuration files of Dancer.

We create a simple `config.yml` file in the same directory where we have the `app.pl` file.

{% include file="examples/dancer2/auth-v2/config.yml" %}

We had to enable session-management using `session: simple` which means in-memory session management.
We also added two entries for the logging mostly just to divert the log messages from the console to a logfile.
Then we configured a user with username `foo` and password `secret_code` and mapped that user to have a role called `Marketing`.

The security conscious people will scream out at this point for the use of clear-text password in the configuration file. Don't worry this is
just an intermediate step. Next we'll going to encrypt that password.

For now, once we have saved the `config.yml` file, Plack will reload the application and we can go back to the browser and type in the username/password
pair in the login form. (foo and secret_code in this case). Once we do that, it will redirect us to `http://127.0.0.1:5000/report` where we intended
to go and we can see the page now.

We can now visit the main page and access the report page again, and all will work fine till we touch either the `app.pl` or the `config.yml`.
Once we touch either of those, if we try to access the report page again, we'll be prompted for the password again. This has baffled me for some time till
I understood that Plack has reloaded the application and because I used in-memory session management (meaning in the memory of the server process),
the session was lost.

## Session management

We can do two things to avoid this unpleasant thing. We can either stop using the `-R .` flag of `plackup`, but then we will have to
reload the application manually, still losing the session, but now also being required to do extra work. Instead of that I think a better approach would
be to change the session management to file-base sessions.

We change the `config.yml` file to have the following entry:

```
session: "YAML"
```

The next time we try to access the `/report` page we'll have to type in the username/password pair again, but this time, in addition
to letting us in, Dancer will also create a subdirectory called `sessions` in the same directory where the `app.pl` script is
and will put a YAML file in it representing the current session. We can now freely edit either the script or the configuration file
and even if Plack restarts the application our session will not be lost.

## Logging out

The [Dancer2::Plugin::Auth::Extensible](https://metacpan.org/pod/Dancer2::Plugin::Auth::Extensible) provides a default logout
route as well. If you access `http://127.0.0.1:5000/logout` it will log the user out and display:
`OK, logged out successfully.`.

If we try to access the report page again `http://127.0.0.1:5000/report` then we'll be prompted to type in a username/password pair again.

## Invalid login

If you type in an incorrect combination of username/password, the system will re-display the login page without giving any indication.
There is an open [issue](https://github.com/PerlDancer/Dancer2-Plugin-Auth-Extensible/issues/14) regarding this.

## Encrypted password

As mentioned earlier having the password in the configuration file in clear text is not a good idea. Anyone who might
access that file will be able to log in to the system. As that file might be included in a version control system or on a backup,
it can easily get in the hands of people who otherwise don't have access to this machine. It is better to keep an 
encrypted version of the password.

The [Dancer2::Plugin::Auth::Extensible](https://metacpan.org/pod/Dancer2::Plugin::Auth::Extensible) module comes with a command-line
script called `generate-crypted-password`. You can run this, it will prompt for a password and then it will print the encrypted
version of that password on the screen. For example I typed in `new_secret` and it printed `{SSHA}16SFBItoknJZZZ+iVeSVVxv/Xd+arT5/`.

I edited the config.yml and replaced the string `secret_code` by this string. Then I could log in with the new username password pair (foo/new_secret).

If you tried that script you might have noticed that the password you typed in was also displayed on the screen. This is another issue that
can be solved by installing [Term::ReadPassword::Win32](https://metacpan.org/pod/Term::ReadPassword::Win32) which, despite its name, will work on Linux and OSX as well.
See the article on [How to read a password on the command line](/how-to-read-a-password-on-the-command-line) for some explanation.

The new version of `config.yml` looks like this:

{% include file="examples/dancer2/auth-v3/config.yml" %}

## Add another role and another user

So far we have only had one user, one role and one page.

Let's add another page that can be only seen my `Management`.

{% include file="examples/dancer2/auth-v4/app.pl" %}

If we try to access this page while logged in as user `foo` we will be redirected to
`http://127.0.0.1:5000/login/denied?return_url=%2Fsalaries</h> which will look like this:

<img src="/img/dancer2_auth_permission_denied.png" alt="Permission Denied" />

Let's create a new user called `bar` with the encrypted version of her password `super secret`:
(Use the `generate-crypted-password` script.)

{% include file="examples/dancer2/auth-v4/config.yml" %}

Let's now log out by visiting `http://127.0.0.1:5000/logout` and then let's login with the new username password.

We can then try to visit either `http://127.0.0.1:5000/report` or `http://127.0.0.1:5000/salaries` and they
both will respond properly. The report page will let this user in because she has the `Marketing` role, and
the `salaries` route will let her in because she is also in the `Management` role.

## Conclusion

As you can see it is very easy to limit access to specific route to people who have authenticated themselves and who
have certain roles in the organization. The main limitation of this approach is that the administrator of the site
has to manually add the users and generate the passwords. This can be good in application where there is a very small number
of users.

Later we'll see how to use the same module with other back-ends to store the users, passwords and roles.

## Comments

I was trying to use the generate-crypted-password script but cannot figure out how to access it? (ubuntu 16)

I was able to workaround this by installing/using slappasswd (which was mentioned on the Auth::Extensible doc page) and complete the example.

But I'd still like to know how to use this script,

<hr>

The name of that script in Dancer2 is dancer2-generate-crypted-password. It uses Crypt::SaltedHash.

I found out that the random salt that is being used is simply part of the generated encrypted password. I did not notice that at first. So every time you ask for an encrypted password it will be different (because it carries the random salt).

It meens that's no problem. You do not have to store the salt seperately in a database. Just store the encrypted password and let Crypt::SaltedHash (I use Dancer2::Plugin::Auth::Extensible) figure out if it's correct. It will extract the salt first.




