---
layout: post
title:  "Why Snap-CI and Travis-CI are not the same thing."
date:   2014-07-22
author: Marco Valtas
categories: continuous_delivery
---

Being on Snap-CI team lets you be certain of two thing. First, you will learn a
lot about how projects get built and deployed. Second, you will, sooner or
later, have to answer the following question:

> "What is the difference between Snap-CI and [Travis-CI](https://travis.org)
> ([CircleCI](http://circleci.com), [Codeship](https://www.codeship.io),
> [and](https://drone.io) [others](https://buildbox.io))? Why should I use
> Snap-CI?"

## Continuous Integration (CI) and Continuous Delivery (CD)

Often these two concepts get mixed together on people's speech, maybe because
there is a dependency between them. You can't practice Continuous Delivery
without first practicing Continuous Integration. Still, these are two
different concepts, in short:

* Continuous Integration - Automated build and test of your software when a
  change is made by anyone on the team.
* Continuous Delivery - Ability of deploying your software in an automated
  fashion by demand.

## Snap-CI and Travis-CI? What's the difference?

Yes, there's a fair similarity in the names and both basic features of
building and testing your software. But after that, this similarity goes down
quickly when you start to compare other features.

Build and test when a change happened is the basic idea of Continuous
Integration, both Snap and Travis have this feature. Nonetheless Snap uses the
idea of a **Deployment Pipeline** as stated on Part II of the Continuous
Delivery book.

## Snap and the Deployment Pipeline

Here's an example of a simple Deployment Pipeline:

![Snap Pipeline](/assets/images/screenshots/why-snapci-and-travisci-are-not-the-same-thing/snap_ci_pipeline.png)

The first rectangle show us which changes where introduced together with a link
to [Github](https://github.com) for more details. The rest are the **stages** of
this pipeline.

### What stages are and what they are for?

In short, stages are just a group of commands, a logic separation of a set of
commands. Mind all phases which a software needs to go through before is
deployed into production. Some need to be compiled, tested, analysed and so on.
On more advanced configurations we might consider the setup of its
infra-structure by one or more stages.

The ability of organizing these automation steps allows us to split different
concerns when we are preparing our software to step into production. Another
advantage of organizing this flow into steps is fast feedback. When the project
is going through the pipeline how soon can you tell that something went wrong?
Stages allows you to get that fast feedback, if the software fails to pass a
stage the pipeline is stopped and the team members are notified about the
failure. We can think about unit tests, code format verification, functional
tests, security checks and so on. Once our software goes through these stages,
one by one, it can be considered "good for production" when it pass all of
them.

### Deployment

By the end of a series of stages we can deploy our software into production. But
most development teams do not jump into production after all automated stages,
instead they use an environment similar to production for further testing and
verification (UAT).

An important aspect here is to control what, where and when things get deployed.
Coming back to the Continuous Delivery definition above:

* Continuous Delivery - Ability of deploying your software in an automated
  fashion by demand.

The translation of "by demand" on Snap is "manually triggered stages":

![Snap - Manually Triggered Stages](/assets/images/screenshots/why-snapci-and-travisci-are-not-the-same-thing/snap_ci_manual_stage.png)

What this means is that this stage, called "publish", won't be executed
automatically but only when someone manually clicks on it. In this example in
particular this means that any change made into the project won't be put in
production automatically, but only when we want to.

We can have any amount of manual stages, and between them, automatically
triggered stages. This is a key part of this feature, it gives us the
flexibility to create complex sequences of automation and deployment for our
project. One more detail, given the manual stages can be triggered multiple
times you can deploy old versions of your application. But for that it is
important to configure artifacts.

### Artifacts

Each stage executes a series of commands, by the end, we want to deploy on UAT
or production the changes which went through all stages. Still, what about our
compilation artifacts? Being more specific, if our project creates packages,
binaries and etc, do we have to created it again?

The answer is no. Here comes artifacts, setting one or more directories on Snap
you can tell it to save and restore its contents. The importance of this is to
abide with the first practice of deployment pipelines:

> "Compile your binaries only once"
> Continuous Delivery, Chapter 5, page 113.

As result, when you have a manual stage to deploy to production, we can deploy
the same binary which went through all stages.

### Continuous Integration

Among Continuous Delivery recommendations for Continuous Integration practices
there's a highlight on branch usage (Branches, Streams, and Continuous
Integration, Chapter 14, page 390). The basic idea is, if different teams work
on the same code but are split by branches, we can't assume that they are
integrating these changes continuously. The streams of work are diverging and we
are only postponing the merge conflicts. This doesn't mean that you can't use
branches, but just that they should be as short lived as possible, maybe a few
days.

Snap has a solution to help out on these code integrations and anticipate when
two or more streams of work are diverging, its called [_Automatic Branch
Tracking_](http://docs.snap-ci.com/working_with_branches/automatic_branch_tracking/).
When enabled, Snap will not only execute the pipeline on the branch but also
will attempt to merge (locally) with the main tree, and execute the pipeline
against the merged code. Like so:

![Snap - Automatic Branch Tracking](/assets/images/screenshots/why-snapci-and-travisci-are-not-the-same-thing/snap_ci_auto_branch_tracking.png)

By the end of the pipelines we not only know that our changes goes can pass
through the pipeline but also it also will pass if we perform a merge with the
main development tree. We are always aware if our changes are diverging from the
main tree.

### Auditing and Compliance

Finally I will bring a topic maybe not too popular among developers but
important for IT organizations in general, Auditing and Compliance. This topic
is briefly handled on Continuous Delivery, Chapter 15, page 436.

When we work on a team and we see that our deployment pipeline is ready for
deployment, if we start the deployment, what changes will be published?

For this question Snap give us the "Stage History" feature, where all changes
between stages can be visualized. Here's a example of some changes that will go
into production if we deploy:

![Snap - Stage History](/assets/images/screenshots/why-snapci-and-travisci-are-not-the-same-thing/snap_ci_stage_history.png)

This history allow us to check all previous changes that got deployed and which
will be deployed next. Not only this, but also when and who triggered the past
deployments, giving the information for traceability needed which medium and
large enterprises rely on.

## Conclusion

By these examples I hope I made more clear what differentiates Snap from other
similar offers. These similarities start with the naming and its basic features
but soon they go down as you start to compare other features. Snap is focused on
Continuous Delivery practices and not only Continuous Integration ones, this is
the difference about Snap.

