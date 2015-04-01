---
layout: post
title:  "Why Snap can't simply use Docker containers to run your builds?"
date:   2015-03-25
author: Akshay Karle
---

# History and background

Snap is a hosted Continuous Integration and Delivery service that allows users to setup their build pipelines for repositories hosted on [GitHub](https://github.com). We provide users with virtual machines that run these builds.

Users that setup the builds expect their builds to start as soon as they push their code to GitHub. In order to achieve this goal, we make sure that our build machines are always prepared and ready to build as soon as we receive any build requests from GitHub. These build machines should also be identical to each other and should include the latest languages, databases and libraries required by the wide customer base that Snap has. We also need to run a sustainable business so it should be easy to run and maintain these build machines without incurring a significant hardware cost.

While virtualization technologies like [vmware](http://www.vmware.com/), [virtualbox](https://www.virtualbox.org/) and [Xen](http://www.xenproject.org/) provide full virtualization and can run multiple operating systems and different kernel versions, containers on the other hand use a single Linux kernel and therefore can run only Linux. All containers share the same kernel. It does not have the overhead of a true hypervisor, it is very fast, light and efficient.

Since we wanted to offer a fast, linux based CI system to our end users, containers seemed like the way forward as it met all our requirements. Back in early 2012 when Snap started there were only a few major container based virtualization technologies available for linux -

* [LXC](https://linuxcontainers.org/)
* [OpenVZ](https://openvz.org/Main_Page)
* [Linux-VServer](https://en.wikipedia.org/wiki/Linux-VServer)

LXC was still in its infancy and development was in full swing back in 2012 when Snap started. Linux-VServer although stable was running on a very old kernel and there was not very much of community support available at the time. OpenVZ had been stable for quite a few years and had most of the features that Snap needed.

# As things stand today

Over the past few years, we have seen a lot of uproar in the evolving container technologies -

 * [LXC became production ready](https://lwn.net/Articles/587545/)
 * [Docker](https://www.docker.com/) becomes [production ready](https://blog.docker.com/2014/06/its-here-docker-1-0/)
 * [Rocket](https://github.com/coreos/rocket), not yet production ready

After 3 years, we wanted to re-visit our choice of container technologies. OpenVZ is still running on 2.6.32 kernel and has first class support for RHEL/CentOS 6, and there are a few other container technologies that we've seen.

Docker has gained significant popularity in the last few months, and we've been getting numerous requests from our users to allow using of Docker to build and test their containers as part of their build pipelines. This is not something that OpenVZ, our current container technology offered; until the [last week](https://openvz.org/Docker_inside_CT).

LXC and Docker as container technologies have improved improved significantly over the last 1-2 years, and we took this opportunity to explore them. In this article we present our views about these new container technologies and our reasons for choosing the container technology going forward.

# Application Containers and how they are different from an Operating System

Both Docker and Rocket are application containers (that's what we like to call them). As the [Docker website](https://www.Docker.com/) quotes on "What is Docker?""

> "Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications"

The idea behind Docker is to deploy applications as a containers. As a result, by design, they do not have a lot of things make a "complete" Operating System. While Docker may be similar to LXC or OpenVZ containers or virtual machines, it is also quite different in the ways they function -

### Applications meant to be run as a single process

When a Docker container is launched, it runs a single process which is usually your application. This very different from the traditional OS where you have multiple services running on the same OS. This approach works very well when you want to deploy a distributed, multi-app system. The development team gets the freedom to package their own applications as a single deployable container, the operations teams gets the freedom of deploying the container on the operating system of their choice as well as the ability to scale both horizontally and vertically the different applications. The end state is a system that has different applications and services each running as a container which then talk to each other over using the APIs and protocols that each of them supports.

To explain how Dockerization of systems typically works, let's take an example of a 3 tier architecture in web development which has a `PostgreSQL` data tier, a `Ruby on Rails` application tier and an `Nginx` as the load balancer tier.

In the simplest of cases, using the traditional approach, one would put the database, the rails app and nginx on the same machine.

Deploying this architecture as Docker containers would involve building a container image for each of the tiers. You then deploy these images independently creating containers of varying sizes and capacity according to your needs.

![typical 3-tier architecture with Docker containers](/assets/images/screenshots/snap-containers/3-tier-architecture-using-docker.jpg){: .screenshot .big}


### Missing init and the zombie reaping problem

Init (PID 1) is a process is a direct or in-direct ancestor of all other processes. It adopts any [orphaned processes](https://en.wikipedia.org/wiki/Orphan_process) when their parents die, and ensures that there are no [zombie processes](https://en.wikipedia.org/wiki/Zombie_process) left behind. Most of the popular Docker base images don't have the init process. When you run such images, they will simply run your application and it becomes your application's responsibility to manage the lifecycle of any child processes it creates during the run since there is no init process to do so. To workaround this problem of having to manage the orphaned child processes many users have created Docker images with an init process. To read more about this problem and the workarounds have a look at this [blog post](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).

### Containers as VMs

In the spirit of [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle), Docker advocates running a single lightweight container for each service. However your application service may need ancillary services like cron, syslog among others inside the container, along with a correct init process, this sometimes necessitates the use of a fatter container.

So even though application containers (provided by Docker and Rocket) are very similar to the Operating System containers (provided by OpenVZ and LXC), in the sense that they also share the kernel of the host machine, they are meant to be run as a single service on the container which differentiates them from the Operating System containers which run multiple services (init, databases, application, etc.) on the same container just like a traditional Operating System.

Since most users are very familiar with linux distributions, these ancillary services also make it appealing to run a CI system.

# Root access on Snap build machines

An important aspect of having a hosted CI environment is that users would like to customise their build machines, install different packages, libraries and services not available on Snap. In order to support this Snap allows users to run arbitrary commands, some of these commands may need to be run as root. We also want to ensure that a root user in the container doesn't break out of the container and become the root user on the host machine. Below we list some of security concerns with Docker containers -

### Inability to create/manage containers as non-root users

The Docker daemon runs as root. Even the Docker containers created need to be created by either root or by a user with sudo privileges to issue Docker daemon commands. This may be safe when running trusted applications, but it may cause problems as Docker still doesn't support User namespaces. Following is a quote from the [Docker security documentation](https://docs.docker.com/articles/security/):

> Today, Docker does not directly support user namespaces, but they may still be utilized by Docker containers on supported kernels, by directly using the clone syscall, or utilizing the 'unshare' utility.

User namespaces gives the ability to run processes and access filesystems as a root user in the containers which can be mapped to a non-root user on the host. If a root user on a container were to find an exploit that allows them into the host, that user won't be root on the host machine and won't cause as much damage as a root user on the host. Docker currently does not support user namespacing, Snap therefore was not in a position to use Docker containers to run untrusted code. If we were to offer Docker containers as build machines, we would have to take away the ability to allow root access. To read more about what User namespaces have a look at [this blog by Serge Hallyn](https://s3hh.wordpress.com/2012/05/10/user-namespaces-available-to-play/).

### Isolation using SELinux or AppArmor

You can definitely work on hardening your container security by using systems like SELinux and AppArmor with Docker. These tools allow whitelisting of resources and capabilities that a process/user needs process. This whitelisting technique while works great for running your application, it is not so great when running a CI service that is meant to execute arbitrary code.

# What does all this mean for Snap?

We needed a build environment that would be capable of running multiple services on the same container. Users of the CI service expect different databases, languages and frameworks to be running and available locally. So we really wanted to offer a full-fledged OS that closely resembles a development machine that many of us are familiar with. Both LXC and OpenVZ met our needs for this as they provide OS containers.

Docker containers are, by default, quite secure; as long as processes inside the containers as are running as non-root users. But a lot of our users need to run as a root user in the container. So we couldn't really use Docker for running users builds.

SELinux or AppArmor was also not an option to secure Docker containers, because it is not possible, ahead of time to whitelist the resources a users builds may need. What Snap really needs is complete isolation between build machines, with the ability to do UID namespacing. LXC with [version 1.0.0 announced last year](https://lwn.net/Articles/587545/) does have support for [unprivileged containers](https://www.stgraber.org/2014/01/17/lxc-1-0-unprivileged-containers/) with User namespaces. This would now allow us to now run Docker containers inside LXC containers to make up for the missing user namespaces in Docker.

In the near future we may move to LXC which suites our needs for running a full OS container as a non-root user there-by meeting our user and security needs.
