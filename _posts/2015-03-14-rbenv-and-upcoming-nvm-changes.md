---
layout: post
title:  "rbenv and upcoming nvm changes"
date:   2015-03-14
author: Ketan Padegaonkar
categories: announcements
---

In the past users have had to wait a few days after new versions of ruby, node and other languages while we deployed them to our build machines. This is because the build machines that Snap offers came pre-installed with a set of packages.

This was always an inconvenience for some of our users while they waited a few days for the latest and greatest languages and tools to become available. This was also an added disuption for the Snap team while some team members dropped what they were doing to re-build build machine images with the latest languages, tested them thoroughly and deployed them over for our end users.

Starting today we would like to announce that we've rolled out to using [rbenv](https://github.com/sstephenson/rbenv) to install rubies on your build machines.

This will improve the experience for users who are using to using rbenv or rvm on their local development machines. Users will no longer need to use `sudo` to manage rubygems anymore. For users who have any `sudo gem` commands in their tasks, we have already migrated those tasks to remove the `sudo` prefix on them.

We will soon be rolling out a similar change to move over to using [nvm](https://github.com/creationix/nvm) for managing nodejs and iojs versions.

If you have any comments or tips to help us improve, let us know by droppping a comment below or [contact us]({{ site.link.contact_us }}) if you have any questions.
