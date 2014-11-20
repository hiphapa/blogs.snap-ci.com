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

You will need to add your private SSH key (e.g. id_rsa) to Snap, and your public
key to OpenShift (i.e. id_rsa.pub)

You can create the keys on another machine with the ssh-keygen command, and
copy/paste them into them into the corresponding places. In OpenShift, this is
under Settings > Add a new key. Once open, paste in the contents of your id_rsa.pub key


![OpenShift Key Image](/assets/images/screenshots/openshift-deploy/openshift.jpg "OpenShift Image")

In Snap, edit your configuration, navigate to your Deploy step, and look for "Secure Files" and "Add new"

![Add Files](/assets/images/screenshots/openshift-deploy/AddFiles.jpg "OpenShift Add Files")

Get the content of the id_rsa key you generated earlier and post it in the content box. It should look like this, with "/var/go" as the file location, except with a real key:

![id_rsa](/assets/images/screenshots/openshift-deploy/AddIdRSA.jpg "OpenShift Add id_rsa")

#### Step 2: Enable Git Push from Snap

If you've used ssh much, you are probably aware that that you can specify an identify file with the "-i" flag. The git command has no such flag, yet, but we can create a simple bash script that emulates this (script courtesy of <a href="http://alvinabad.wordpress.com/2013/03/23/how-to-specify-an-ssh-key-file-with-the-git-command/">Alvin Abad</a>).

Add another New File in Snap and paste in the below script:

{% highlight bash %}
#!/bin/bash

# The MIT License (MIT)
# Copyright (c) 2013 Alvin Abad

if [ $# -eq 0 ]; then
    echo "Git wrapper script that can specify an ssh-key file
Usage:
    git.sh -i ssh-key-file git-command
    "
    exit 1
fi

# remove temporary file on exit
trap 'rm -f /tmp/.git_ssh.$$' 0

if [ "$1" = "-i" ]; then
    SSH_KEY=$2; shift; shift
    echo "ssh -i $SSH_KEY \$@" &gt; /tmp/.git_ssh.$$
    chmod +x /tmp/.git_ssh.$$
    export GIT_SSH=/tmp/.git_ssh.$$
fi

# in case the git command is repeated
[ "$1" = "git" ] &amp;&amp; shift

# Run the git command
git "$@"
{% endhighlight %}

Give this script the name "git.sh", set the file permissions to "0755", and update the file location to "/var/go".

![gitssh](/assets/images/screenshots/openshift-deploy/gitsh.jpg "OpenShift gitssh")


#### Step 3: Profit

With all these parts configured correctly you can add this single line to your Deploy script:

{% highlight bash %}

/var/go/git.sh -i /var/go/id_rsa push ssh://ABCDEFGHIJK123@example.yourdomain.rhcloud.com/~/git/example.git/

{% endhighlight %}

Re-run the build, check your logs, and it should deploy. Good luck!
