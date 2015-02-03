---
layout: post
title:  "Faster builds with bigger sized workers"
date:   2015-02-04
author: Ketan Padegaonkar
categories: announcements feature workers
---

The standard workers on Snap come with 2GB of memory and 2 cores, while this is good enough for most users. Some users have had the need to use more memory or cpu cores for some of their tests that require using multiple browsers, jvms and android emulators.

To follow up with our story about using multiple workers to get [faster feedback]({% post_url 2014-12-19-faster-builds-multiple-workers %}). Starting today, we would now like to announce the ability to run your build using bigger sized workers.

For users on the trial plan, small team plan and small business plans - you will now have the ability to run your build on bigger sized workers. Read more about it on our [docs site]({{ site.link.docs }}workers/configuring-workers/).

![bigger workers](/assets/images/screenshots/bigger-workers/bigger-worker-configuation.png){: .screenshot .big}

As always, we would love to hear if you have any comments or tips to make your builds even better. Leave your comments below or [contact us]({{ site.link.contact_us }}) if you have any questions.
