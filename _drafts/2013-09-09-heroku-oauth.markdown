---
layout: post
title:  "Setting up heroku deployments has never been so easy"
date:   2013-09-09
author: Akshay Karle
categories: heroku heroku-oauth
---

Snap in collaboration with Heroku has now started using [OAuth for Heroku](https://blog.heroku.com/archives/2013/7/22/oauth-for-platform-api-in-public-beta) for [setting up deployments](http://docs.snap-ci.com/deployments/heroku_deployments). Using Heroku OAuth makes Snap a single point of contact for deploying your code to an existing app on heroku or even creating a new app for deployments.

Using OAuth means that you no longer need to copy over the API key from Heroku. Authorize Snap on Heroku once and Snap takes care of the rest of the deployments.
