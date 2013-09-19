---
layout: post
title:  "Hack Scala/Play build on Snap CI"
date:   2013-09-18
author: Shishir Das
categories: java scala play deployments
---

Typically, we do not claim to offer first class support for a language/framework on Snap unless we provide some basic heuristics to help users set up their builds. Based on this defintion, Snap currently supports Ruby, Rails & Node.js builds. However, Snap can run any type on builds for any JVM based language. In this post, I will talk about how to set up a build for simple Scala/Play project that gets deployed to Heroku.

If you have your own project on GitHub you can use that. You would need to add sbt-laucher to your project if not present and a script to invoke it. This might look something like

    >> curl -LO http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch//0.12.4/sbt-launch.jar
    >> echo 'java -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M -jar `dirname $0`/sbt-launch.jar"$@"' > sbt
    >> chmod u+x sbt

For those you don't have a scala/play project you can follow the following instructions.

##Project Set Up.

1. You can find the instructions to setup a play/scala project [here](http://www.playframework.com/documentation/2.1.x/ScalaTodoList)
2. Add sbt-launcher(v0.12.4) to the root of the project project. You can download the binary from [here](http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch//0.12.4/sbt-launch.jar)

    >> cd ~/projects/todolist
    (todolist) >> curl -LO http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.12.4/sbt-launch.jar

3. Create script to invoke sbt-laucher in PROJECT_ROOT.

    (todolist) >> echo 'java -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M -jar `dirname $0`/sbt-launch.jar"$@"' > sbt
    (todolist) >> chmod u+x sbt

4. Run test on local machine.

    (todolist) >> sbt clean test

##Add the project to github

1. Create a [repository](https://help.github.com/articles/create-a-repo) on Github named todolist.
2. Push todolist to github

    (todolist) >> git init .
    (todolist) >> git add .
    (todolist) >> git commit -m "first commit"
    (todolist) >> git remote add origin git@github.com:<your_github_id>/todolist.git
    (todolist) >> git push -u origin master

##Setup build for todolist project on [Snap](https://snap-ci.com/)

1. Information about setting up a build in Snap could be found [here]().When reviewing the build plan structure, you would see a warning stating "Manually Configure a project"

![Manually configure build plan](/Users/shishir/Desktop)

2. Click "+ADD NEW". And select "Custom Stage" (Ignore the Ruby version drop down ;))

3. Enter "Build" in "STAGE NAME" and "./sbt clean test" in "Tasks to be executed".

![Add Build Stage](/Users/shishir/)

4. Click "Create Project"

And thats it.