---
layout: post
title:  Continuous Deployment Strategies
date:   2015-04-02
author: Ketan Padegaonkar
categories: article deployments
---

Not very long ago, during the days of Perl/CGI and PHP (and even today); deployments involved *ftp*-ing your files to the webserver directory and running a bunch of migrations by shelling into the webserver.

Modern webapps and application servers have evolved quite a bit since then but a lot of developers continue to use a similar strategy to perform deployments. FTP is replaced by `git pull` followed by `bundle install` or `npm install` and then restarting the appserver that you use.

# [Snowflake servers](http://martinfowler.com/bliki/SnowflakeServer.html)

While this approach may work great for small webapps, it quickly falls apart when you're managing anything but a couple of servers.

It is generally difficult to set up a new server if your existing server has problems. If you're looking to scale by adding more servers, it's difficult to keep each server's software, configuration and services in sync. You may not be in a position to replicate a production (or production-like) environment for testing.

Over time, one loses track of the magic configuration files, packages and services that are installed on the production machines.


# [Phoenix servers](http://martinfowler.com/bliki/PhoenixServer.html)

Some these issues can be addressed by using a bit of configuration management tools like [chef](https://www.chef.io/), [puppet](https://puppetlabs.com/), or [ansible](http://www.ansible.com/home) among a few others.

These tools help avoid configuration drift, the sort of one-off changes that go unnoticed and undocumented.

An important point to note is that these tools only apply the configuration that they are asked to. If you applied any additional configuration outside of what these tools are aware of, or if you forgot to un-apply or remove some configuration, you'd be out of luck. This what [Ranjib Dey](https://github.com/ranjib) calls the [Accumulator Anti-Pattern](http://server.dzone.com/articles/infrastructure-tooling-anti).

A much better alternative is to tear down servers periodically and apply configuration changes every once in a while. This helps avoid and catch any configuration drift outside of configuration management tools.

# How does this apply to Continuous Deployment?

Continuous Deployment requires that at a very minimum, you have:
* a solid foundation of tests that gives you confidence in your software
* a set of automation tools and scripts that give you confidence that your deployment will succeed, or rollback in case of issues

In this post, we'll talk a bit about some of the more popular continuous deployment strategies. More detailed follow-up posts will get into implementation techniques for each strategy.

# Blue/green deployments

This is one of the simplest CD strategies to implement and get started with.

![blue green](/assets/images/screenshots/cd-strategies/blue-green.png){: .screenshot .big}

Blue/green is a technique for deployments where the existing running deployment is left in place. A new version of the application is installed in parallel with the existing version. When the new version is ready, cut over to the new version by changing the load balancer configuration.

This makes rollback really simple and gives time to make sure that the new version works as expected before putting it live.

# Canary releases

This is named after the "canary in a coal mine" metaphor. The metaphor originates from the times when miners used to carry caged canaries into the mines with them: if there were any dangerous gases (methane or carbon monoxide) in the mine, the canary would die before the gas levels reached levels hazardous to humans.

![canary releases](/assets/images/screenshots/cd-strategies/canary.png){: .screenshot .big}

Canary releasing is similar to blue/green, although only a small amount of the servers are upgraded. Then, using a cookie or similar, a fraction of users are directed to the new version.

This allows for the load and functionality of the site to be tested with a small group of users. If the application behaves as expected, migrate more and more servers to the new version until all the users are on the new version.

This technique can also be used to do some interesting multi-variant testing and performance testing.
