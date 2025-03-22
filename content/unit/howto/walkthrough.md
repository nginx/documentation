---
title: Walkthrough
weight: 900
toc: true
---

OK, so you've decided to give Unit a try with your web app of choice. You may
be looking for ways to run it faster with less config overhead, streamlining
your technology stack, or simply be tech-curious. In any case:

## Check the prerequisites

1. Verify that Unit
   [supports]({{< relref "/unit/installation.md#source-prereqs" >}})
   your platform and app language version.

1. If possible, ensure the app can run beside Unit to rule out
   external issues.

## Get Unit on the system

 Install Unit with the language modules you need. Your options:

   - Official .deb/.rpm
   [packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})

   - Docker
   [images]({{< relref "/unit/installation.md#installation-docker" >}})

   - Third-party
   [packages]({{< relref "/unit/installation.md#installation-community-repos" >}})

   - Source
   [build]({{< relref "/unit/installation.md#source" >}})

1. Configure and launch Unit on your system:

   - Our own and third-party packages
   [rely on]({{< relref "/unit/installation.md#installation-precomp-startup" >}})
   `systemctl` or `service`.

   - Containerized Unit can be
   [run]({{< relref "/unit/howto/docker.md" >}}) with common `docker` commands.

   - If none of the above applies, customize Unit's
   [startup]({{< relref "/unit/howto/source.md#source-startup" >}})
   manually.

## Prepare the app for Unit

1. *(Only applies to
   [Go]({{< relref "/unit/configuration.md#configuration-go" >}}))* Patch
   your app to run on Unit.

1. Choose
   [common]({{< relref "/unit/configuration.md#configuration-applications" >}})
   options such as app type, working directory, user/group.

1. Add
   [language-specific]({{< relref "/unit/configuration.md#configuration-languages" >}})
   settings such as index, entry module, or executable.

## Plug the app into Unit

1. *(Optional)* Add Unit-wide [settings]({{< relref "/unit/configuration.md#configuration-stngs" >}}). to
   your app's config to run it smoothly.

1. [Upload]({{< relref "/unit/controlapi.md#configuration-mgmt" >}})
   your config into Unit to spin up the app.

1. *(Optional)* Set up a
   [route]({{< relref "/unit/configuration.md#configuration-routes" >}})
   to your app to benefit from internal routing.

1. *(Optional)* Upload a
   [certificate bundle]({{< relref "/unit/certificates.md#configuration-ssl" >}})
   if you want to support SSL/TLS.

1. Finally, set up a
   [listener]({{< relref "/unit/configuration.md#configuration-listeners" >}})
   to make your app publicly available.


For the details of each step, see specific documentation sections.
