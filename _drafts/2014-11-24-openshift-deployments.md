---
layout: post
title:  "OpenShift Deployments"
date:   2014-11-24
author: Kelvin Nicholson
categories: how-to deployments
---

Snap has built in support for several Platforms-as-a-Services, yet it is easy
to add any provider that accepts git push deployments. In this example we will
add a deploy step for OpenShift, an open source Platform-as-a-Service from RedHat,
which includes a free tier for small projects. This example should take less than
10 minutes, depending on your experience with SSH.

#### Step 1: Add SSH Keys

You will need to add your private SSH key (i.e. id_rsa) to Snap, and your public
key to OpenShift (i.e. id_rsa.pub)

You can create the keys on another machine with the ssh-keygen command, and
copy/paste them into them into the corresponding places. In OpenShift, this is
under Settings > Add a new key. Once open, paste in the contents of your id_rsa.pub key.

![OpenShift Key Image](/assets/images/screenshots/openshift-deploy/openshift.jpg "OpenShift Image")

In Snap, edit your configuration, navigate to your Deploy step, and look for "Secure Files" and "Add new"

![Add Files Image](/assets/images/screenshots/openshift-deploy/AddFiles.jpg "OpenShift Add Files")

Get the content of the id_rsa key you generated earlier and post it in the content box. It should look like this, with "id_rsa" as the name, "/var/go/.ssh" as the file location, "0600" as the permissions, and a real key:

![id_rsa](/assets/images/screenshots/openshift-deploy/AddIdRSA.jpg "OpenShift Add id_rsa")

The name and location are important, as these are the default locations that git will use.

#### Step 2: Configure Deploy

With your keys in place it is now possible to perform a git push with this single line to your Deploy stage:

{% highlight bash %}

git push ssh://ABCDEFGHIJK123@example.yourdomain.rhcloud.com/~/git/example.git/

{% endhighlight %}

Re-run the build, check your logs, and it should deploy. Good luck!
