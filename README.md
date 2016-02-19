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

`sudo` is a program that lets certain people run certain commands as
certain users, as according to its configuration. The farthest some
people get with `sudo` configuration is to let some set of people
(usually admins) execute any command as any user (including `root`).

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
`sudo`.

This module doesn't contain a lot of explicit portability, doesn't
manage the installation of `sudo`, and doesn't overwrite the `sudo`
configuration.


## Setup


### What sudo affects

* The sudoers file, usually `/etc/sudoers`
* The sudoers directory, usually `/etc/sudoers.d`


### Setup Requirements **OPTIONAL**

You must have `sudo` version 1.6.9 or later installed; Augeas,
ruby-augeas and a suitable `sudoers` lens (should come with Augeas);
and pluginsync enabled.


### Beginning with sudo

BOILERPLATE

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
