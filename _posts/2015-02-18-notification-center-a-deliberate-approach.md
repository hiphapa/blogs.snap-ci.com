---
layout: post
title:  "A more deliberately designed notification center"
date:   2015-02-18
author: Badri Janakiraman
categories: announcements
---


Something was wrong. We had built many different ways for people to radiate the status of their build and share it with everyone. However, there wasn't a week that would go by without folks wondering if we had Github build badges or Slack support. Or wonder where they could configure which emails they got from Snap. Something had gone very wrong.

### Evolving into fragmentation

The first notification system we built in Snap was to notify users of build failures and fixes via email. This version of email notifications did not allow users to configure which emails Snap sent out, or where they received their emails. These issues and others were ones we subsequently remedied.

Following this, it is time to give credit where credit is due. [TravisCI](https://travis-ci.org/) did this incredibly clever/useful thing with build shields that could be embedded into the README of your repository. Like most great ideas, this was so simple- and to paraphrase the folks at Apple- so "inevitable" that we couldn't but pay homage to it. Imitation being the sincerest form of flattery, we added that  functionality essentially in unchanged form to Snap. I mean, if it ain't broke...

We also knew though that teams hung out on chat rooms and that integrating with the popular ones was going to not be far. With that in mind, we put in [Campfire](https://campfirenow.com/) and [HipChat](https://www.hipchat.com/) notifications next. Slack hadn't been released at this point.

Users of older CI tools had gotten used to the XML format of the cc-tray tool. In a sense, it had become the de-facto standard on the basis of which a bunch of build notification tools got built. [CCMenu](http://ccmenu.org/), [BuildReactor](https://chrome.google.com/webstore/detail/buildreactor/agfdekbncfakhgofmaacjfkpbhjhpjmp?hl=en) etc all used this format. This then became the next notification mechanism.

Following this, like many of you, one fine morning we found our own team all in a [Slack](https://slack.com/) room. Coming out of nowhere, Slack quickly became the cool-kid-on-the-block. We needed it before anyone else and so that's how Slack integration got in.

Last, but not the least, we always had web-hooks. Not because we wanted folks to do something specific with it. But precisely because we had no opinions on what should be done with it. We love tools that encourage hacking. We love the joy of serendipitous discovery and the ability to scratch an itch. Web-hooks and good quality APIs are a way to do that. So that's how they went in.

While each of these decisions makes a lot of sense by themselves, lacking an organization principle, they inevitably ended up getting scattered through out the application. This caused many of you to wonder which of these mechanisms we supported and how to configure them.

### From casual to deliberate.

Over the last few weeks, we have spent time consolidating all these mechanisms under one home on Snap. You can now access the notification center from the build history page. In addition to this consolidation, we have introduced the ability to specify exactly what aspects of your build you wish to be notified about.

![notification center](/assets/images/screenshots/notifications/notification-center.png){: .screenshot .big}

We would love to hear what you think of the new consolidated notification center. Do you see all the channels you expect to see? What do you think is missing? Let us know in the comments below.
