---
layout: post
title:  "Choose your Github access levels"
date:   2014-12-24
author: Akshay Karle
categories: announcements feature
---

Starting today, Snap users will have the ability to limit what Snap can do with your GitHub account.

![choose github scopes](/assets/images/screenshots/choose-github-scopes/choose-github-scopes.png){: .screenshot .big}

In the past we have received a number of queries asking why Snap requires admin access to all repositories. The reason that we require admin access is because whenever you add a repository on Snap, we add a *Deploy Key* (so that Snap can clone your build) and a *Web Hook* (to be notified when someone pushes to the repository or submits a pull-request). To add deploy keys and web hooks to any GitHub repository, Snap requires to have admin permissions.

Starting now, you can login to Snap using a mimimal set of permissions, and if you decide to setup a public or a private repository Snap will ask for more permissions as needed.

If you are existing Snap user and would like to change your access level for GitHub visit the [GitHub scopes](https://snap-ci.com/choose_github_scopes) and select the appropriate scope. Please note, if you already have any builds which you have setup they will break if you reduce your scope. You can check the builds you've setup by visiting the [repository settings page](https://snap-ci.com/settings/repositories).
