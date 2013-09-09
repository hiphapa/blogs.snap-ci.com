---
layout: post
title:  "Setting up heroku deployments has never been so easy"
date:   2013-09-09
author: Akshay Karle
categories: heroku heroku-oauth
---

With the launch of [Heroku Oauth](https://blog.heroku.com/archives/2013/7/22/oauth-for-platform-api-in-public-beta), deploying to heroku from Snap has become even more seamless. No longer do you require to remember your [api key](https://devcenter.heroku.com/articles/platform-api-quickstart#authentication)!

When setting up your first deployment you just have to login to heroku to authorise Snap. Once Snap is set-up with your heroku account, you can create further deployments on any project with signing into heroku again or copying over the api key.

One of the limitations we currently have is that every Snap user can have only one heroku account associated with him, so if you try to try to deploy to different accounts on heroku it won't work.