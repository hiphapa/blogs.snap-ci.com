---
layout: post
title:  "Feature branching and Snap"
date:   2013-09-09
author: Akshay Karle
categories: Integration-branches Feature-branches Clones
---

When you are doing feature or user story branching you would create a branch for every feature or story you work on. These branches are then merged into the master branch once the feature is ready for release. When you merge your feature branch into master others working on different branches may have merge conflicts if they are touching the same piece of code. To avoid these conflicts an approach as suggested in Martin Fowler's [Feature branching](http://martinfowler.com/bliki/FeatureBranch.html) blog is to continuously merge your branch into master. However, you may want to ensure that your merge doesn't break any functionality on your master branch.

Snap can help you in this. Snap allows creation of clones that can also integrate with a specific branch. What this means is that, Snap performs a merge of your tracking branch with the integration branch and run a build with the merged code.

For example, if you have a project named MySuperbWebapp building on master branch and if you are working on a the login feature on a branch named "login" you can easily setup a new pipeline in Snap for the login branch by creating a clone for the login branch. When you are creating the clone you can optionally choose to integrate with the master branch. Creating an integration clone implies that Snap will setup two pipelines for your clone -- a default pipeline building against the login branch and an integration pipeline building against the merged code.

What the integration pipeline does is that it first merges the login branch into master and then runs build against the merged code. Running your build on an integration pipeline allows you to get immediate feedback of the implications of merging your feature branch as it stands into master. If the integration branch goes green you might choose to merge that branch into master. A green integration pipeline implies a branch good to merge into master. You can then merge frequently and small changes instead of the complete feature.
