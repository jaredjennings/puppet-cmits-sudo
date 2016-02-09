# The `sudo` module from CMITS

[![Build Status](https://travis-ci.org/jaredjennings/puppet-cmits-sudo.svg?branch=master)](https://travis-ci.org/jaredjennings/puppet-cmits-sudo)

What this `sudo` module does that all the others don't is to implement
the suggestions in the `sudo` `man` page about trying to make it
auditable, i.e. making administrators sudo to do each individual
thing, thus generating a log entry, rather than being able to run
multiple commands as root via a shell or editor.
