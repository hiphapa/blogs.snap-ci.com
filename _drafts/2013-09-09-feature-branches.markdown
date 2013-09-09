---
layout: post
title:  "Feature branching and Snap"
date:   2013-09-09
author: Akshay Karle
categories: Integration-branches Feature-branches Clones
---

[Feature branching](http://martinfowler.com/bliki/FeatureBranch.html) has been around for a while now. One of the major problems of feature branching is that merging your branch frequently and with small changes is difficult as you need some sort of feedback of whether your branch is good to merge into master.

Snap can help you in this. Snap allows creation of clones that can also integrate with a specific branch. What this means is that, Snap performs a merge of your tracking branch with the integration branch and run a build with the merged code.

For example, if you have a project named MySuperbWebapp building on master branch and if you are working on a the login feature on a branch named "login" you can easily setup a new pipeline in Snap for the login branch by creating a clone for the login branch. When you are creating the clone you can optionally choose to integrate with the master branch. Creating an integration clone implies that Snap will setup two pipelines for your clone -- a default pipeline building against the login branch and an integration pipeline building against the merged code.

What the integration pipeline does is that it first merges the login branch into master and then runs build against the merged code. Running your build on an integration pipeline allows you to get immediate feedback of the implications of merging your feature branch as it stands into master. If the integration branch goes green you might choose to merge that branch into master. A green integration pipeline implies a branch good to merge into master. You can then merge frequently and small changes instead of the complete feature.
