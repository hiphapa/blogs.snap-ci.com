---
layout: post
title:  "Why Snap can’t simply use Docker containers to run your builds?"
date:   2015-03-25
author: Akshay Karle
---

Snap is a hosted Continuous Integration and Delivery service that allows users to setup their build pipelines for their repositories in GitHub. We provide users with the build machines that run these pipelines. Anyone setting up the pipeline has an expectation that as soon as they commits their code to GitHub, it starts building immediately on Snap. In order to do so we have to make sure that our build machines are always prepared and ready to build as soon as we receive any build requests from GitHub. These build machines should also be exactly identical to each other and should have the latest languages and libraries required by the wide customer base of Snap. In order to run a sustainable business it should also be easy to run and maintain these build machines without incurring a significant cost for the hardware.

In order to meet all these requirements of the build machines we chose to use containers as build machines. Back when Snap started there were only a few major container based virtualization technologies available for linux -

* [LXC](https://linuxcontainers.org/)
* [OpenVZ](https://openvz.org/Main_Page)

The development for LXC was still in full swing back in 2012 when Snap started but it wasn't production ready. So we decided to go with OpenVZ which proved to be quite stable. Over the time we have seen a lot of uproar in the evolving container technologies with [LXC becoming production ready](https://lwn.net/Articles/587545/) to new entrants like [Docker](https://www.docker.com/) and [Rocket](https://github.com/coreos/rocket). However, both docker and rocket are application containers. As the [docker website](https://www.docker.com/) quotes "An open platform for distributed applications". The intention of these technologies is to deploy applications as a containers and hence by design they don't have a few things that you take for granted in a normal Operating System. While they are similar to LXC or OpenVZ containers or virtual machines, they are quite different in the ways they function:

## Meant to be run a single service

Whenever a docker container is launched it runs a single process which is usually your application. This very different from the traditional OS where you have multiple services running on the same OS. But this approach plays very well when you want to deploy a distributed, multi-app system giving development teams the freedom to package their own applications as a single deployable container and the Ops teams the freedom of deploying the container on different distros of their choice as well scaling the different services (as every service is a container) as per the needs. The structure of the system is such that you have the different components running as different containers which then talk to each other.

To explain how dockerization of systems works, let's take an example of a 3 tier architecture in web development which has a `Postgres` data tier, a `Ruby on Rails` application tier and an `Nginx` as the front-end/presentation tier. When you would like to deploy this architecture as docker containers you would typically have a different container for each tier. So in this case you would create a container image for the Postgres database, another image for the Ruby on Rails server and one more for the Apache web server. You then deploy these images independently creating multiple containers each representing a single service. In the traditional approach you would put the database, the rails server and the apache server on the same Operating System.

<!-- [!typical 3-tier architecture with docker containers image](foo) -->

## Missing init (PID 1) process

One of the duties of the init process in Linux is to collect the exit status of any orphaned processes when they die there-by ensuring that there are no orphaned zombie processes left behind. By default, most of the base images for docker don't have the init (PID 1) process and when you run a docker container it will simply run your application and it becomes your application's responsibility to manage the lifecycle of any child processes it creates during the run since there is no init process to do so. To workaround this problem of having to manage the child processes many users have created docker images with an init process.

Both these approaches differentiate application containers like docker from the traditional OS containers which are exactly what virtual machines as well as LXC and OpenVZ containers provide. OpenVZ and LXC containers are more like Operating System containers which try to emulate a complete operating system like environment but share the kernel of the host machine. When we were re-considering the container technology to use for Snap, we took these points under consideration. For Snap builds users expect different databases, languages to be running and available locally. So we really wanted a full fledged Operating system which were meant to run multiple services on the same Operating system and we didn't really want to create big fat application containers. Snap allows users to run arbitrary commands in the build machines we provide with sudo access, so we needed to take security into account as well. Below I list some of security concerns with docker containers.

## Run as the root user

The docker daemon runs as root. Even the docker containers created need to be created by either root or by a user with sudo privileges to issue docker daemon commands. Although this is usually safe it can cause problems as docker still doesn't support User namespaces. Following is a quote from the [docker security documentation](https://docs.docker.com/articles/security/):

>Today, Docker does not directly support user namespaces, but they may still be utilized by Docker containers on supported kernels, by directly using the clone syscall, or utilizing the 'unshare' utility.

User namespaces gives the ability to isolate resources such as processes and filesystems in the containers and by mapping them to non-root users on the host. So even if a user breaks out of the container he doesn't get root access on the host machine. I would also recommend you to go through the [docker security documentation](https://docs.docker.com/articles/security/) thoroughly before you start using docker in production.

## Isolation using SELinux or AppArmor

Apparmor, selinux and the likes are useful when you know the application that is being run and know what resources and capabilities it needs access to.

So for e.g. if you know that an application needs access to a particular files or other resources, you can whitelist that program. Note that this is the complete opposite of what unix traditionally does, which is purely user based.

Snap is not in the application-in-the-cloud business. As such these security mechanisms don't work for us. What we really need is complete isolation between build machines, and the ability to do UID namespacing.
