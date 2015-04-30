---
layout: post
title:  Implementation Techniques for Canary Releases
date:   2015-04-06
author: Ketan Padegaonkar
categories: article deployments
index-image-url: /assets/images/place_holder.jpeg
---

In the previous article on [Continuous Deployment Strategies]({% post_url 2015-04-02-continuous-deployment-strategies %}), we explored at a high level some of the popular CD strategies.

This article describes some of the implementation techniques for performing Canary Releases.

![canary releases](/assets/images/screenshots/cd-strategies/canary.png){: .screenshot .big}

Just like [Blue/Green Deployments]({% post_url 2015-04-03-blue-green-deployments %}), one would start by deploying the application to a small subset of your servers.

Once the subset of servers is deployed to, you may then route requests for a few users to the new set of servers.

This strategy lets you do a lot of interesting things -

* test the performance of the application
* perform A/B tests based on demographics and user profiles, for example "users between the ages of 20-25 living in Iowa"
* get feedback from a subset of beta testers or users from your company

As your confidence in the deployment improves, you can deploy your application to more and more servers, and route more users to the new servers.

# Long running migration phase

Because one or more versions of your application may be running in production for some period of time, your application and its components (webservices, microservices, database) needs to be backward-compatible so that it works with at least one or two previous versions of your application. This [Parallel-Change Pattern](http://martinfowler.com/bliki/ParallelChange.html) is a simple and effective way to implement backward-incompatible changes between application interfaces.


