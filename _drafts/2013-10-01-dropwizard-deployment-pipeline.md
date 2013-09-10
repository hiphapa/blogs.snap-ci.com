---
layout: post
title:  "Setting up a deployment pipeline for Dropwizard services"
date:   2013-10-01
author: Sahil Muthoo
categories: java deployments
---

[Dropwizard](http://dropwizard.codahale.com/) is fast becoming the weapon of choice for deploying performant RESTful web services on the JVM platform. Snap makes it a breeze to fast track your Dropwizard services to Heroku with [deployment pipelines](http://martinfowler.com/bliki/DeploymentPipeline.html).

## Meet the sample Dropwizard service

For the purpose of this blog I have created a sample Dropwizard service, appropriately titled [dropwizard-snapci-sample](https://github.com/sahilm/dropwizard-snapci-sample). It's a simple microblogging service API with two resources, User and MicroBlog. It speaks to Postgresql using the light [jdbi](http://jdbi.org/) library with [Liquibase](http://www.liquibase.org/) database migrations. The sample service is covered with unit tests and one end to end integration test. To get started, fork this repository to your GitHub account.

## The first stage of our deployment pipeline - running unit tests and packaging the service

When you setup this repository in Snap for the first time, it will detect that it's a Maven project and create a single stage pipeline for you with an empty `mvn` command. Simply replace `mvn` with `mvn package` to run the unit tests and create a deployable microblog jar.

We're almost done with our first stage. Only exporting the build artifacts remain. See the documentation on [configuring and downloading artifacts]({{ site.docs }}artifacts/build_artifacts/#configuring-and-downloading-artifacts) for information on how to do this and why it's important. You'll want the `target` directory as an artifact for subsequent stages.

The stage task list should look like this

<img src="/assets/images/screenshots/dropwizard/test-stage.png" class="screenshot"/>

And the artifacts configuration

<img src="/assets/images/screenshots/dropwizard/test-stage-artifacts.png" class="screenshot"/>

## The second stage - end to end integration tests

Ensuring that the service works with a real database and web server is vital to a reliable deployment pipeline. Up until now, our unit tests were mocking out database calls and we had no need to connect to a database server. However our integration tests require a database. Thus we need to tweak our Dropwizard service to connect to a Snap's Postgresql server.

Snap follows Heroku's convention of injecting a `DATABASE_URL` environment variable into each stage's execution environment. It's highly recommended to check out the Heroku dev center article [Connecting to Relational Databases on Heroku with Java](https://devcenter.heroku.com/articles/connecting-to-relational-databases-on-heroku-with-java). Briefly the `DATABASE_URL` is formatted like this `[database type]://[username]:[password]@[host]:[port]/[database name]`.

Our sample service is already setup to leverage the `DATABASE_URL` environment variable. The code to do this is located in [MicroBlogDatabaseConfiguration.java](https://github.com/sahilm/dropwizard-snapci-sample/blob/master/src/main/java/com/snapci/microblog/MicroBlogDatabaseConfiguration.java). Here's the meat of it:

{% highlight java %}
URI dbUri = new URI(databaseUrl);
String user = dbUri.getUserInfo().split(":")[0];
String password = dbUri.getUserInfo().split(":")[1];
String url = "jdbc:postgresql://" + dbUri.getHost() + ':' + dbUri.getPort() + dbUri.getPath();
databaseConfiguration = new DatabaseConfiguration();
databaseConfiguration.setUser(user);
databaseConfiguration.setPassword(password);
databaseConfiguration.setUrl(url);
databaseConfiguration.setDriverClass("org.postgresql.Driver");
{% endhighlight %}

Next, setting up the actual stage is easy. Here's what you do:
- Select Postgresql from the database dropdown.
- Create a new stage by clicking on Add new stage.
- Select custom stage.
- `java -jar target/microblog-0.0.1-SNAPSHOT.jar db migrate microblog.yml` runs the database migrations.
- `java -jar target/microblog-0.0.1-SNAPSHOT.jar server microblog.yml &>log &` starts Jetty.
- `mvn failsafe:integration-test failsafe:verify` runs our integration tests.

The `target` directory already contains our build artifact which was propagated by Snap from the previous stage.

Your integration stage should look something like this

<img src="/assets/images/screenshots/dropwizard/integration-stage.png" class="screenshot"/>

## The final stage - deploying to Heroku

Deploying to Heroku is the easiest part. First we need to ensure is that the `web` task in the [Procfile](https://devcenter.heroku.com/articles/procfile) runs our database migrations and starts up Jetty. Check out the Procfile in [dropwizard-snapci-sample](https://github.com/sahilm/dropwizard-snapci-sample) if you're interested in how it's done.

With the right Procfile we're ready to roll. Just add a new Heroku deployment stage and Snap takes care of the rest. If you need any help you can head over to the [Heroku deployments]({{ site.docs }}deployments/heroku_deployments/) section in our documentation.

Your Heroku deployment stage should look something like this

<img src="/assets/images/screenshots/dropwizard/heroku-stage.png" class="screenshot"/>

That's all there is to it. Snap will now monitor your repository and run builds for all commits. Snap has a lot more to offer from CCTray, HipChat and Campfire build notifications to manual gated deployments to production environments. Also, we're just getting warmed up, if there's a feature you'd like to see or if you just want to say hi send us an email at <a href="mailto:snap-ci@thoughtworks.com">snap-ci@thoughtworks.com</a>.