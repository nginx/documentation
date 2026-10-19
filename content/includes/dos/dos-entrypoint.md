---
f5-docs: DOCS-46
f5-product: F5 DoS for NGINX
f5-files:
- content/nap-dos/deployment-guide/kubernetes-with-L4-accelerated-mitigation.md
- content/nap-dos/deployment-guide/kubernetes.md
---

```shell
    #!/usr/bin/env bash

    USER=nginx
    LOGDIR=/var/log/adm

    # prepare environment
    mkdir -p /var/run/adm /tmp/cores ${LOGDIR}
    chmod 755 /var/run/adm /tmp/cores ${LOGDIR}
    chown ${USER}:${USER} /var/run/adm /tmp/cores ${LOGDIR}

    # run processes
    /bin/su -s /bin/bash -c "/usr/bin/adminstall > ${LOGDIR}/adminstall.log 2>&1" ${USER}
    /bin/su -s /bin/bash -c "/usr/bin/admd -d --log info > ${LOGDIR}/admd.log 2>&1 &" ${USER}
    /usr/sbin/nginx -g 'daemon off;'
```