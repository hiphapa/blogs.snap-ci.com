---
layout: post
title:  "Less intrusive Snap"
date:   2014-12-23
author: Akshay Karle
categories: announcements feature
---

Starting today, Snap users will have the ability to choose the level of access Snap has to their GitHub accounts.

![choose github scopes](/assets/images/screenshots/choose-github-scopes/choose-github-scopes.png){: .screenshot .big}

In the past we have received a number of queries asking why we require admin access to all repositories? The reason we needed admin access is because whenever you add a repository on Snap, we add a *Deploy Key* (for git clone in your build) and a *Web Hook* (to receive push, pull-request notifications from GitHub) to that repository on GitHub and to do so we need to have admin permissions.

With our new changes, this continues to be the same. However, when you join Snap for the first time you need not give complete admin access to all your repositories. If you wish to join Snap just to collaborate on some builds which have already been setup by other users, you can join Snap without giving any read or write access to any of your repositories. We will ask for elevated privileges on the public repositories or the private repositories only when you attempt to setup that repository.

If you are existing Snap user and would like to change your access level for GitHub visit the [GitHub scopes](https://snap-ci.com/choose_github_scopes) and select the appropriate scope. Please note, if you already have any builds which you have setup they will break if you reduce your scope. You can check the builds you've setup by visiting the [repository settings page](https://snap-ci.com/settings/repositories).
