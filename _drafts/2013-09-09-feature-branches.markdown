---
layout: post
title:  "Leveraging Snap for feature branching"
date:   2013-09-09
author: Akshay Karle
categories: Integration-branches Feature-branches Clones
---

With VCS like git, working with [branches](http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging) has become fairly straight-forward. Techniques such as [Feature branching](http://martinfowler.com/bliki/FeatureBranch.html) are now being practiced. One of the major problems of feature branching is that merging your branch frequently and with small changes is difficult as you need some sort of feedback of whether your branch is good to merge into master.

Snap tries to help you overcome this problem. Snap allows creation of clones of a build that can also integrate with a specific branch. What this means is that, Snap performs a merge of your integration branch with the tracking branch and runs a build with the merged code.

For example, if you have a project named OnlineCakeShop building on *master* branch and if you are working on a the login story on a branch named *login* you can easily setup a new pipeline in Snap for the login branch by creating a clone from master. When you are creating the clone you can optionally choose to integrate with the master branch. Creating an integration clone implies that Snap will setup two pipelines for your clone -- a default pipeline building against the login branch and an integration pipeline building against the merged code.

What the integration pipeline does is that it first merges the master branch into login and then runs build against the merged code. Running your build on an integration pipeline allows you to get immediate feedback of the implications of merging your feature branch as it stands into master. A green integration pipeline implies that a branch in its current state is good to merge into master. You can then merge frequently and small changes instead of the complete feature.
