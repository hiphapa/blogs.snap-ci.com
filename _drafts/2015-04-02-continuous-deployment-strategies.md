---
layout: post
title:  Continuous Deployment Strategies
date:   2015-04-02
author: Ketan Padegaonkar
categories: article deployments
---

Not very long ago, during in the days of Perl/CGI and PHP (even today); deployments involved *ftp*ing your files to the webserver directory and running a bunch of migrations by shelling into the webserver.

Modern webapps and application servers have evolved quite a bit since then but a lot of developers continue to use a similar strategy to perform deployments. FTP is replaced by `git pull` followed by `bundle install` or `npm install` and restart the appserver that you use.

While this may work great for small webapps, this approach suffers a lot of pitfalls, staging environments, rollbacks, backups/restores in case of deployment failures, the list goes on. A lot of such servers are what is commonly known as [Snowflake Server](http://martinfowler.com/bliki/SnowflakeServer.html).

Some these issues can be addressed by using a bit of configuration management tools like [chef](https://www.chef.io/), [puppet](https://puppetlabs.com/), [ansible](http://www.ansible.com/home) among a few others.

Continuous Deployment requires that at a very minimum, you have -
* a solid foundation of tests that gives you confidence in your software
* a set of automation tools and scripts that give you confidence that your deployment will succeed, or rollback in case of issues.

In this series of articles, we'll talk a bit about some of the more popular continuous deployment strategies.

# Blue/Green deployments

This is one of the simplest CD strategies to implement and get started with.

![blue green](/assets/images/screenshots/cd-strategies/blue-green.png){: .screenshot .big}

Blue/green is a technique for deployments where the existing running deployment is left in place. A new version of the application is installed in parallel with the existing version. When the new version is ready, cut over to the new version by changing the load balancer configuration.

This makes rollback really simple and also gives plenty of time to make sure that the new version is working before putting it live.

# Canary Releases

This is named after the "canary in a coal mine" metaphor. The metaphor originates from the times when miners used to carry caged canaries while in the mine, if there were any dangerous gases (methane or carbon monoxide) in the mine, the canary would die before the levels of the gas reached levels that could be hazardous to humans.

![canary releases](/assets/images/screenshots/cd-strategies/canary.png){: .screenshot .big}

Canary releasing is similar to blue/green, although only a small amount of the servers are upgraded. Then, using a cookie or similar, a fraction of users are directed to the new version.

This allows for the load and functionality of the site can be tested with a small group of users. If the application behaves as expected, migrate more and more servers to the new version until all the users are on the new version.

This technique can also be used to do some interesting multi-variant testing and performance testing.
