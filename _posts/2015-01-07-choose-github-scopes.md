---
layout: post
title:  "Choose your Github access levels"
date:   2015-01-07
author: Akshay Karle
categories: announcements
---

So- you might have noticed that when you login, Snap asks for a fairly surprising level of access to your Github repositories, both public and private. What's more, is that, once you set up a build, every one of your collaborators needed to grant Snap access to all their repositories too just to collaborate on your build. A lot of you felt, rather understandably, that this was a bit excessive.

Well, we agree!

Starting today, Snap users will have the ability to limit what Snap can do with your GitHub account.

![choose github scopes](/assets/images/screenshots/choose-github-scopes/choose-github-scopes.png){: .screenshot .big}

In the past we have received a number of queries asking why Snap requires admin access to all repositories. The reason that we require admin access is because whenever you add a repository on Snap, we add a *Deploy Key* (so that Snap can clone your build) and a *Web Hook* (to be notified when someone pushes to the repository or submits a pull-request). To add deploy keys and web hooks to any GitHub repository, Snap requires to have admin permissions.

Starting now, you can login to Snap using a mimimal set of permissions that we use to just get your email and profile information. These would be sufficient if all you wanted to do was poke around in Snap - or collaborate on a build that one of your colleagues set up.

Should you decide to setup a public or a private repository, Snap will progressively ask for more permissions as needed to do exactly what is needed and no more.

We hope that this addresses the concerns that a lot of you have expressed. After all, we cannnot compromoise privileges we haven't been granted.

If you are existing Snap user and would like to change the access level you have granted Snap [GitHub scopes](https://snap-ci.com/choose_github_scopes) and select the appropriate scope. A note of caution, however. If you already have any builds that you setup- they will start to break if you reduce your scope all the way down.You can check the builds you've setup by visiting the [repository settings page](https://snap-ci.com/settings/repositories).
