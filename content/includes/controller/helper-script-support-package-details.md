The support package is a tarball that includes NGINX Controller configuration information, logs, and system command output. Sensitive information, including certificate keys, is not included in the support package.

The support package gathers information from the following locations:

```md
.
├── database
│   ├── common.dump                                - full dump of the common database
│   ├── common.dump_stderr                         - any errors when dumping the database
│   ├── common-apimgmt-api-client-api-keys.txt     - contents of apimgmt_api_client_api_keys table from the common database
│   ├── common-apimgmt-api-client-groups.txt       - contents of apimgmt_api_client_groups table from the common database
│   ├── common-email-verification.txt              - contents of email_verification table from the common database
│   ├── common-oauth-clients.txt                   - contents of oauth_clients table from the common database
│   ├── common-settings-license.txt                - contents of settings_license table from the common database
│   ├── common-settings-nginx-plus.txt             - contents of settings_nginx_plus table from the common database
│   ├── common-table-size.txt                      - list of all tables and their size in the common database
│   ├── data-table-size.txt                        - list of all tables and their size in the data database
│   ├── postgres-database-size.txt                 - size of every database
│   ├── postgres-long-running-queries.txt          - all queries running longer than 10 seconds
│   ├── system.dump                                - full dump of the system database
│   ├── system-account-limits.txt                  - contents of account_limits table from the system database
│   ├── system-accounts.txt                        - contents of accounts table from the system database
│   ├── system-deleted-accounts.txt                - contents of deleted_accounts table from the system database
│   ├── system-deleted-users.txt                   - contents of deleted_users table from the system database
│   ├── system-users.txt                           - contents of users table from the system database
│   └── system-table-size.txt                      - list of all tables and their size in the system database
├── k8s                                            - output of `kubectl cluster-info dump -o yaml` augmented with some extra info
│   ├── apiservices.txt                            - output of `kubectl get apiservice`
│   ├── kube-system                                - contents of the kube-system namespace
│   │   ├── coredns-5c98db65d4-6flb9
│   │   │   ├── desc.txt                           - pod description
│   │   │   ├── logs.txt                           - current logs
│   │   │   └── previous-logs.txt                  - previous logs, if any
│   │   ├── ...
│   │   ├── daemonsets.yaml                        - list of daemonsets
│   │   ├── deployments.yaml                       - list of deployments
│   │   ├── events.yaml                            - all events in this namespace
│   │   ├── namespace.yaml                         - details of the namespace, including finalizers
│   │   ├── pods.txt                               - output of `kubectl get pods --show-kind=true -o wide`
│   │   ├── pods.yaml                              - list of all pods
│   │   ├── replicasets.yaml                       - list of replicasets
│   │   ├── replication-controllers.yaml           - list of replication controllers
│   │   ├── resources.txt                          - all Kubernetes resources in this namespace
│   │   └── services.yaml                          - list of services
│   ├── nginx-controller                           - contents of the nginx-controller namespace
│   │   ├── apigw-8fb64f768-9qwcm
│   │   │   ├── desc.txt                           - pod description
│   │   │   ├── logs.txt                           - current logs
│   │   │   └── previous-logs.txt                  - previous logs, if any
│   │   ├── ...
│   │   ├── daemonsets.yaml                        - list of daemonsets
│   │   ├── deployments.yaml                       - list of deployments
│   │   ├── events.yaml                            - all events in this namespace
│   │   ├── namespace.yaml                         - details of the namespace, including finalizers
│   │   ├── pods.txt                               - output of `kubectl get pods --show-kind=true -o wide`
│   │   ├── pods.yaml                              - list of all pods
│   │   ├── replicasets.yaml                       - list of replicasets
│   │   ├── replication-controllers.yaml           - list of replication controllers
│   │   ├── resources.txt                          - all Kubernetes resources in this namespace
│   │   ├── services.yaml                          - list of services
│   ├── nodes.txt                                  - output of `kubectl describe nodes`
│   ├── nodes.yaml                                 - list of nodes
│   ├── resources.txt                              - all non-namespaced Kubernetes resources (including PersistentVolumes)
│   └── version.yaml                               - Kubernetes version
├── logs                                           - copy of /var/log/nginx-controller/
│   └── nginx-controller-install.log
├── os
│   ├── cpuinfo.txt                                - output of `cat /proc/cpuinfo`
│   ├── df-h.txt                                   - output of `df -h`
│   ├── df-i.txt                                   - output of `df -i`
│   ├── docker-container-ps.txt                    - output of `docker container ps`
│   ├── docker-images.txt                          - output of `docker images`
│   ├── docker-info.txt                            - output of `docker info`
│   ├── docker-stats.txt                           - output of `docker stats --all --no-stream`
│   ├── docker-version.txt                         - output of `docker version`
│   ├── du-mcs.txt                                 - output of `du -mcs /opt/nginx-controller/* /var/log /var/lib`
│   ├── env.txt                                    - output of `env`
│   ├── firewall-cmd.txt                           - output of `firewall-cmd --list-all`
│   ├── free.txt                                   - output of `free -m`
│   ├── hostname-all-fqdns.txt                     - output of `hostname --all-fqdns`
│   ├── hostname-fqdn.txt                          - output of `hostname --fqdn`
│   ├── hostname.txt                               - output of `hostname`
│   ├── hostsfile.txt                              - output of `cat /etc/hosts`
│   ├── ip-address.txt                             - output of `ip address`
│   ├── ip-neigh.txt                               - output of `ip neigh`
│   ├── ip-route.txt                               - output of `ip route`
│   ├── iptables-filter.txt                        - output of `iptables -L -n -v`
│   ├── iptables-mangle.txt                        - output of `iptables -L -n -v -t mangle`
│   ├── iptables-nat.txt                           - output of `iptables -L -n -v -t nat`
│   ├── iptables-save.txt                          - output of `iptables-save`
│   ├── journal-kubelet.txt                        - output of `journalctl -q -u kubelet --no-pager`
│   ├── lspci.txt                                  - output of `lspci -vvv`
│   ├── netstat-nr.txt                             - output of `netstat -nr`
│   ├── ps-faux.txt                                - output of `ps faux`
│   ├── pstree.txt                                 - output of `pstree`
│   ├── ps.txt                                     - output of `ps aux --sort=-%mem`
│   ├── resolvconf.txt                             - output of `cat /etc/resolv.conf`
│   ├── selinux-mode.txt                           - output of `getenforce`
│   ├── ss-ltunp.txt                               - output of `ss -ltunp`
│   ├── swapon.txt                                 - output of `swapon -s`
│   ├── sysctl.txt                                 - output of `sysctl -a --ignore`
│   ├── systemd.txt                                - output of `journalctl -q --utc`
│   ├── top.txt                                    - output of `top -b -o +%CPU -n 3 -d 1 -w512 -c`
│   ├── uname.txt                                  - output of `uname -a`
│   ├── uptime.txt                                 - output of `cat /proc/uptime`
│   └── vmstat.txt                                 - output of `cat /proc/vmstat`
├── timeseries
│   ├── table-sizes.stat                           - stat table containing controller table sizes
│   ├── events.csv                                 - events table dump in csv
│   ├── events.sql                                 - events table schema
│   ├── metrics_1day.csv                           - metrics_1day table dump in csv
│   ├── metrics_1day.sql                           - metrics_1day table schema
│   ├── metrics_1hour.csv                          - metrics_1hour table dump in csv
│   ├── metrics_1hour.sql                          - metrics_1hour table schema
│   ├── metrics_5min.csv                           - metrics_5min table dump in csv
│   ├── metrics_5min.sql                           - metrics_5min table schema
│   ├── metrics.csv                                - metrics table dump in csv
│   ├── metrics.sql                                - metrics table schema
│   ├── system-asynchronous-metrics.stat           - shows info about currently executing events or consuming resources
│   ├── system-events.stat                         - information about the number of events that have occurred in the system
│   ├── system-metrics.stat                        - system metrics
│   ├── system-parts.stat                          - information about parts of a table in the MergeTree family
│   ├── system-settings.stat                       - information about settings that are currently in use
│   └── system-tables.stat                         - information about all the tables
└── version.txt                                    - Controller version information
```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-280 -->
