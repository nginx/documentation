---
# We use sentence case and present imperative tone
title: "Support"
# Weights are assigned in increments of 100: determines sorting order
weight: 700
# Creates a table of contents and sidebar, useful for large documents
toc: false
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

F5 WAF for NGINX adheres to the support policy detailed in the following MyF5 knowledge base article: [K000140156](https://my.f5.com/manage/s/article/K000140156).

## Contact F5 Support

For questions or assistance with installing, troubleshooting, or using F5 WAF for NGINX, contact support through the [MyF5 Customer Portal](https://account.f5.com/myf5).

### Collecting log information

As part of opening a support ticket, you will be asked to collect troubleshooting information for a customer support engineer.

The steps involved depend on your deployment type.

{{< tabs name="log-options" >}}

{{% tab name="Virtual environment" %}}

Get the operating system information:

```shell
cat /etc/os-release > system_version.txt && uname -r >> system_version.txt && cat /proc/version >> system_version.txt
```

Collect the package versions:

```shell
cat /opt/app_protect/VERSION /opt/app_protect/RELEASE > package_versions.txt
```

You may need a different command depending on the operating system.

```shell
# Alpine Linux
apk info -vv | grep -E 'nginx|app-protect' > package_versions.txt
# Debian / Ubuntu
apt list --installed | grep -E 'nginx|app-protect' > package_versions.txt
# RHEL / Amazon Linux / Oracle Linux
rpm -qa nginx* app-protect* > package_versions.txt
```

Create a list of files called _tarball-targets.txt_:

```text
system_version.txt
package_versions.txt
/var/log/app_protect/*
/var/log/nginx/*
/etc/nginx.conf
# Add any additional policy or log configuration files
```

Create a tarball using the list of files:

```shell
tar cvfz logs.tgz `cat tarball-targets.txt`
```

{{% /tab %}}

{{% tab name="Docker" %}}

Use _docker compose_ to create log files:

```shell
sudo docker compose logs > docker_compose_logs.txt
```

If a centralized logging system such as the ELK stack is used, you should retrieve them in CSV format instead:

```shell
sudo docker compose logs > docker_compose_logs.csv
```

Add the log files to a tarball:

```shell
tar cvfz logs.tgz docker_compose_logs.txt
```

{{% /tab %}}

{{% tab name="Kubernetes" %}}

In the following steps, replace `<example-ns>` with the namespace you used to deploy F5 WAF for NGINX.

Verify the pods in your deployment:

```shell
kubectl get pods -n <example-ns>
```

Use the following script to collect logs from every pod, which will create a timestamped directory with files after each pod and container:

```shell
#!/bin/bash

set -x

# Define the namespace variable
NAMESPACE="<example-ns>"

# Define a directory to store log files
log_dir="k8s_logs_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$log_dir"

# Loop through all pods and containers, saving logs to timestamped directories
for pod in $(kubectl get pods -n $NAMESPACE -o=name | sed 's|pod/||g'); do
    for container in $(kubectl get pod/$pod -n $NAMESPACE -o=jsonpath='{.spec.containers[*].name}'); do
        kubectl logs $pod -c $container -n $NAMESPACE > "${log_dir}/${pod}_${container}_logs.txt"
    done
done
```

Once the log files have been saved, run the following command to create a tarball:

```shell
tar cvfz logs.tgz .
```


{{% /tab %}}

{{< /tabs >}}

Attach the tarball named _logs.tgz_ to your support ticket.