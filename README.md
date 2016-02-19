# sudo

[![Build Status](https://travis-ci.org/jaredjennings/puppet-cmits-sudo.svg?branch=master)](https://travis-ci.org/jaredjennings/puppet-cmits-sudo)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with sudo](#setup)
    * [What sudo affects](#what-sudo-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sudo](#beginning-with-sudo)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module helps you make `sudo` more auditable, by compelling admins
to use it to run single commands, rather than a whole root shell. This
involves going into some detail regarding the commands admins can run;
this module helps you deal with that granularity.

It's made for Red Hat, CentOS, Fedora and Mac OS X. It'll probably
work elsewhere too. 


## Module Description

[sudo](https://www.sudo.ws) is a program that lets certain people
run certain commands as certain users, as according to its
configuration. The farthest some people get with `sudo` configuration
is to let some set of people (usually admins) execute any command as
any user (including `root`).

`sudo` logs who ran a command, what it was, and as what user it was
run. But if someone runs `sudo -s`, the log will only show that that
user ran a shell. Commands given inside the shell are not logged.  It
may be important to know these commands for security reasons, or
because admins need to know what was done to the server, whether to
fix it, or to automate the steps taken, or something else.

As suggested in the `sudo` man page, to improve the quality of the
log, it's necessary to stop admins from running anything with `sudo`
that will execute something else, whether that's an arbitrary script,
a shell, or an editor (editors tend to have shell escapes). But there
are some programs that execute other programs as part of their job,
like `mount`; and any site might have scripts that admins should be
able to run using `sudo`.

This module contains a list of programs that come with the operating
system and need to execute other programs. And it contains a way for
you to specify programs and scripts that should be executable using
`sudo` -- anywhere in your manifest.

This module doesn't contain a lot of explicit portability, doesn't
manage the installation of `sudo`, and doesn't overwrite the `sudo`
configuration. It can let some people sudo to some *users* and not
others, but it's no good at letting different people run different
sets of *commands*.


## Setup


### What sudo affects

* The sudoers file, usually `/etc/sudoers`
* The sudoers directory, usually `/etc/sudoers.d`


### Setup Requirements **OPTIONAL**

You must have `sudo` version 1.6.9 or later installed; Augeas,
ruby-augeas and a suitable `sudoers` lens (should come with Augeas);
and pluginsync enabled.


### Beginning with sudo

```
include sudo
```

This will enable those in the `wheel` group to run a command as any
user, subject to the constraints of auditability, and with no password
required when sudo is run.



## Usage

### Basic customization

If you need certain specific users or groups to be able to run a
command as any user, use the `users_to_all` and `groups_to_all`
parameters to the `sudo` class. These should be lists of usernames and
group names, respectively. If you want to require a password, give the
parameter `require_password => true`.

```
  class { 'sudo':
    users_to_all     => ['jay', 'miko'],
    groups_to_all    => ['developers'],
    require_password => true,
  }
```

### Allowing new commands

```
  sudo::auditable::command_alias { "OUR_SCRIPTS":
    commands => ["/n/the_server/admin_scripts/",
                 "/usr/local/bin/launch_missiles"],
    type => 'exec',
  }
```

The `sudo::auditable::command_alias` defined resource type sets up a
command alias in the sudo configuration. It's quite a thin layer over
the `sudoers(5)` syntax; see the man page for details.

The `commands` parameter is a list of `Cmnd`s. See the man page for
all a `Cmnd` could be.

The `type` parameter is one of `noexec`, `exec`, `setenv_noexec`, or
`setenv_exec`. The meanings of these terms are to be found in
`sudoers(5)` by searching for the term `Tag_Spec`.

If `enable` is false, the command alias will have a bang in front of
its name when it is included in the configuration, with the effect
that the commands given will be disallowed instead of being
allowed. See *Other special characters and reserved words* in
`sudoers(5)`.


### sudo to different users

Let's say you have a PostgreSQL DBA, who needs to execute commands as
the `postgres` user. But you don't want this person running things as
root. First set up a group for DBAs, let's say `dba`, because you
shouldn't ever grant permissions to people directly, but to the roles
they play. Group management is outside the scope of this module. Then:

```
  sudo::auditable::for_group { 'dba':
    run_as => 'postgres',
  }
```

This will let DBAs run any command (subject to auditablity
constraints) as `postgres`. For example, the DBA might:

```
sudo -u postgres createdb the_new_db
```


## Reference

FIXME

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Battle-tested on RHEL6, RHEL7, Mac OS X 10.6 Snow Leopard, Mac OS
X 10.9 Mavericks. Ought to work most anywhere else with a sudo. You
need a sudo newer than 1.6.9 (2004): around this version is when the
`#include` directive was first settled.

See all the "don'ts" and "doesn'ts" in
[Module Description](#moduledescription) above.

## Development

Please file issues and send pull requests
[on GitHub](https://github.com/jaredjennings/puppet-cmits-sudo).

## Release Notes/Contributors/Etc **Optional**

FIXME

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
