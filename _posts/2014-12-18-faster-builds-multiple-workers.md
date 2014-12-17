---
layout: post
title:  "Warp speed, Scotty: Faster builds with multiple workers"
date:   2014-12-18
author: Ketan Padegaonkar
categories: announcements feature workers parallelism
---

Everybody loves faster feedback on their builds. We have been offering bigger boxes for some users who have asked for them. Starting today, we would now like to announce to you the ability to run your build across multiple "workers".

For users on the trial plan, small team plan and small business plans - you will now have the ability to run the same job on multiple workers.

![warp factor](/assets/images/screenshots/multiple-workers/warp-factor.png){: .screenshot .big}

In order to assist with making your tests go faster, we have provided a [ruby gem](https://github.com/snap-ci/parallel-tests) that will automatically partition your tests based on the number of tests you have, and the number of workers you are running your builds with.

If you are not running a ruby project, don't worry, we provide a quick howto on how you can go about quickly [splitting your test suite]({{ site.link.docs }}getting-started/multiple-workers).

As always, I would love to hear if you have any comments or tips to make your builds even better. Leave your comments below or [contact us]({{ site.link.contact_us }}) if you have any questions.
