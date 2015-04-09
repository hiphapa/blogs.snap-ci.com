---
layout: post
title:  "Docker vs. LXC"
date:   2015-04-01
author: Akshay Karle
---

Docker has recently gained a lot of popularity, and has been talked about at many recent tech conferences. Everyone wants to know how to use Docker. There are quite a few misconceptions about containers in general, the different container technologies out there, and why so many like Docker. In this blog, I would like to define containers, what Docker offers and what differentiates it from other technologies such as LXC, OpenVZ, etc.

# What are containers?

A container isolates its processes from the different resources of the host system and from other containers while providing an operating system-like environment to those processes. For all practical purposes you can think of containers as VMs. You can install and run different packages, libraries, etc., just as you would on any OS.

The difference between a container and a VM is that all containers share the same kernel of the host system. This gives them the advantage of being very fast with almost [0 performance overhead](https://en.wikipedia.org/wiki/Operating-system-level_virtualization#Overhead) compared with VMs.

There have been a number of [container technologies](https://en.wikipedia.org/wiki/Operating-system-level_virtualization#Implementations) in the past which provide operating system containers. But very recently, one particular container technology -- [Docker](https://www.Docker.com/) -- has been gaining significant popularity in the Dev and Sys-Admin communities. So, what is Docker and what makes it so special?

# What is Docker?

According to the [Docker website](https://www.Docker.com/):

> "Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications."

The idea behind Docker is to package and deploy applications as containers. As a result, by design, they do not have a lot of things that make a "complete" operating system. While Docker containers may be similar to LXC containers or virtual machines, there are subtle differences.

### Application containers using Docker

The idea behind application containers is that you create different containers for each of the components in your application. This approach works especially well when you want to deploy a distributed, multi-component system using the microservice architecture. The development team gets the freedom to package their own applications as a single deployable container, the operations teams gets the freedom of deploying the container on the operating system of their choice as well as the ability to scale both horizontally and vertically the different applications. The end state is a system that has different applications and services each running as a container which then talk to each other using the APIs and protocols that each of them supports.

In order to explain what it means to run an application container using Docker, let's take a simple example of a three-tier architecture in web development which has a `PostgreSQL` data tier, a `Ruby on Rails` application tier and an `Nginx` as the load balancer tier.

In the simplest cases, using the traditional approach, one would put the database, the Rails app and nginx on the same machine.

Deploying this architecture as Docker containers would involve building a container image for each of the tiers. You then deploy these images independently, creating containers of varying sizes and capacity according to your needs.

![typical 3-tier architecture with Docker containers](/assets/images/screenshots/snap-containers/3-tier-architecture-using-docker.jpg){: .screenshot .big}

A bunch of conscious design decisions made by the Docker folks makes the creation of application containers easy:

#### Run a single service as a container

When a Docker container is launched, it [runs a single process](https://docs.docker.com/reference/run/). This process is usually the one that runs your application when you create containers per application. This very different from the traditional OS containers where you have multiple services running on the same OS.

#### Missing init and the zombie reaping problem

Init (PID 1) is a process is a direct or indirect ancestor of all other processes. It adopts any [orphaned processes](https://en.wikipedia.org/wiki/Orphan_process) when their parents die, and ensures that there are no [zombie processes](https://en.wikipedia.org/wiki/Zombie_process) left behind. Most of the popular Docker base images don't have the init process. When you run such images, they will simply run your application and it becomes your application's responsibility to manage the lifecycle of any child processes it creates during the run since there is no init process to do so. To workaround this problem of having to manage the orphaned child processes, many users have created Docker images with an init process. To read more about this problem and the workarounds have a look at this [blog post](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).

#### Layers of containers

![unprivileged containers](/assets/images/screenshots/snap-containers/docker-layers.png){: .screenshot .big}

Any `RUN` commands you specify in the [Dockerfile](https://docs.docker.com/reference/builder/) creates a new [layer](https://docs.docker.com/terms/layer/) for the container. At the end when you run your container, Docker combines these layers and runs your containers. Layering helps Docker to reduce duplication and increases the re-use. This is very helpful when you want to create different containers for your components, as you can start with a base image that is common for all the components and then just add layers that are specific to your component. Layering also helps when you want to rollback your changes as you can simply switch to the old layers and there is almost no overhead involved in doing so.

Given all these points, let's have a look at how application containers are different from OS containers provided by LXC, OpenVZ, etc.

![lxc vs. docker](/assets/images/screenshots/snap-containers/lxc-vs-docker.jpg){: .screenshot .big}

So in general when you want to package and distribute your application as components, Docker serves as a good resort because of all the above points. Whereas, if you just want an operating system in which you can install different libraries, languages, databases, etc., LXC is better as it provides a complete VM-like behavior. In addition to the OS-like behavior, there also some security concerns that I would like to address when running Docker.

# Security of Docker containers

# Inability to create/manage containers as non-root users

The Docker daemon runs as root. Even the Docker containers created need to be created by either root or by a user with sudo privileges to issue Docker daemon commands. This may be safe when running trusted applications, but it may cause problems as Docker still doesn't support user namespaces. Following is a quote from the [Docker security documentation](https://docs.docker.com/articles/security/):

> Today, Docker does not directly support user namespaces, but they may still be utilized by Docker containers on supported kernels, by directly using the clone syscall, or utilizing the 'unshare' utility.

User namespaces gives the ability to run processes and access filesystems as a root user in the containers which can be mapped to a non-root user on the host. If a root user on a container were to find an exploit that allows them into the host, that user won't be root on the host machine and won't cause as much damage as a root user on the host. Docker currently does not support user namespacing: [SaaS products like the one I maintain](https://www.snap-ci.com/) are therefore not in a position to use Docker containers to run untrusted code. If we were to offer Docker containers as build machines, we would have to take away the ability to allow root access. To read more about what user namespaces do, have a look at [this blog by Serge Hallyn](https://s3hh.wordpress.com/2012/05/10/user-namespaces-available-to-play/).

### Isolation using SELinux or AppArmor

You can definitely work on hardening your container security by using systems like SELinux and AppArmor with Docker. These tools allow whitelisting of resources and capabilities that a process/user needs process. This whitelisting technique while works great for running your application, it is not so great when handed to users who can run arbitrary commands as root.


![unprivileged containers](/assets/images/screenshots/snap-containers/unprivileged-containers.jpg){: .screenshot .big}

In such cases when you want to run untrusted commands running as the root user in the container, a better approach is to run unprivileged containers. Unprivileged containers are created and managed by non-root users and hence are considered relatively safer because even when a process breaks out of the container, it only has privileges as much as the non-root host user. Unfortunately, only LXC supports unprivileged containers as of now.

In the future, if Docker moves to support unprivileged containers, it may have wider applications. But for now, due to the security concerns, Docker's OS-like behavior, and other aspects, it is ideal for mass adoption as an application container mechanism for deployment into environments you control. It is not, in general, ready to serve as the basis for for a SaaS provider's infrastructure or those who rely on user namespacing.
