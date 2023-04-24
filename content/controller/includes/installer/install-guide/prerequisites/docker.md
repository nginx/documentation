If you have Internet access, NGINX Controller will install Docker for you as part of the installation process.

If you prefer to install Docker on the host yourself, install the following:

* [Docker Community Edition (CE)](https://docs.docker.com/engine/install/) 18.09
* [Containerd.io](https://containerd.io/) 1.2.10

If you are using Ubuntu-20.04 and want to install Docker on your own, choose the following versions instead:

* [Docker Community Edition (CE)](https://docs.docker.com/engine/install/ubuntu/) 19.03
* [Containerd.io](https://containerd.io/) 1.2.13

{{< see-also >}}
For instructions on installing Docker in offline scenarios on CentOS/RHEL 7, refer to the AskF5 [K84431427](https://support.f5.com/csp/article/K84431427) knowledge base article.{{< /see-also >}}

{{< important >}} You need to enable Docker log rotation to ensure that the logs don't consume all the free disk space on the server. For instructions on how to enable Docker log rotation, see the Docker guides [Configure logging drivers](https://docs.docker.com/config/containers/logging/configure/) and [JSON File logging driver](https://docs.docker.com/config/containers/logging/json-file/).{{< /important >}}&nbsp;

#### Red Hat Enterprise Linux

To create container images on Red Hat Enterprise Linux, Red Hat requires you to register and entitle the host computer on which you'll build them. In this case, the host is where you're installing NGINX Controller. Once the host is registered with Red Hat, you can install Docker from the Red Hat Enterprise Linux Extras repository. See the [Red Hat "Getting Started with Containers"](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/index#getting_docker_in_rhel_7) guide for instructions.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-287 -->