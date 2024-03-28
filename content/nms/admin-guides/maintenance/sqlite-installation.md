---
description: Follow the steps in this guide to install SQLite for your specific Linux
  operating system.
docs: DOCS-1270
tags:
- docs
title: Install SQLite
toc: true
weight: 10
---

## Installing SQLite for Your Linux Distribution

To [back up NGINX Management Suite]({{< relref "/nms/admin-guides/maintenance/backup-and-recovery.md" >}}), you need to have SQLite installed. Follow the steps to install SQLite for your operating system. Note that some older versions of Linux might require additional special steps, explained below.

<br>

{{<tabs name="sqlite-installation">}}

{{%tab name="CentOS, RHEL, RPM-Based"%}}

To install SQLite on your system, run the appropriate command(s) for your Linux distribution:

- For RHEL and RPM-Based distributions (excluding CentOS7, AmazonLinux 2 and Oracle Linux 7):

    ```bash
    sudo yum install -y sqlite
    ```

- For CentOS 7, AmazonLinux 2, and Oracle Linux 7:

    ```bash
    sudo su
    yum install -y gcc \
        make \
        automake \
        lz4-devel \
        libtool \
        diffutils \
        file

    LIBUV=1.30.0
    RAFT=0.10.0
    SQLITE3=3410100

    curl -L -o libuv.tar.gz https://github.com/libuv/libuv/archive/refs/tags/v${LIBUV}.tar.gz && \
        tar -zxf libuv.tar.gz && cd libuv-${LIBUV} && sh autogen.sh && ./configure --prefix=/usr --enable-shared=no && make && make install && cd .. && rm -rf libuv.tar.gz libuv-${LIBUV}
    curl -L -o raft.tar.gz https://github.com/canonical/raft/archive/refs/tags/v${RAFT}.tar.gz && \
        tar -zxf raft.tar.gz && cd raft-${RAFT} && autoreconf -i && ./configure --disable-lz4 --prefix=/usr --enable-shared=no && make && make install && cd .. && rm -rf raft.tar.gz raft-${RAFT}
    curl -L -o sqlite3.tar.gz https://sqlite.org/2023/sqlite-autoconf-${SQLITE3}.tar.gz && \
        tar -zxf sqlite3.tar.gz && cd sqlite-autoconf-${SQLITE3} && ./configure --prefix=/usr --enable-shared=no && make && make install && cd .. && rm -rf sqlite3.tar.gz sqlite-autoconf-${SQLITE3}
    ```

{{%/tab%}}

{{%tab name="Debian, Ubuntu, Deb-Based"%}}

To install SQLite on your system, run the appropriate command(s) for your Linux distribution:


- For Debian, Ubuntu, and Deb-Based distributions (excluding Debian (buster/sid) and Ubuntu 18.04):

    ```bash
    sudo apt-get update
    sudo apt-get install -y sqlite3
    ```

- For Debian (buster/sid) and Ubuntu 18.04:

    ```bash
    sudo su
    apt-get install -y gcc \
          make \
          automake \
          liblz4-dev \
          pkg-config \
          libtool \
          diffutils \
          file

    LIBUV=1.43.0
    RAFT=0.16.0
    SQLITE3=3410100

    curl -L -o libuv.tar.gz https://github.com/libuv/libuv/archive/refs/tags/v${LIBUV}.tar.gz && \
        tar -zxf libuv.tar.gz && cd libuv-${LIBUV} && sh autogen.sh && ./configure --prefix=/usr --enable-shared=no && make && make install && cd .. && rm -rf libuv.tar.gz libuv-${LIBUV}
    curl -L -o raft.tar.gz https://github.com/canonical/raft/archive/refs/tags/v${RAFT}.tar.gz && \
        tar -zxf raft.tar.gz && cd raft-${RAFT} && autoreconf -i && ./configure --disable-lz4 --prefix=/usr --enable-shared=no && make && make install && cd .. && rm -rf raft.tar.gz raft-${RAFT}
    curl -L -o sqlite3.tar.gz https://sqlite.org/2023/sqlite-autoconf-${SQLITE3}.tar.gz && \
        tar -zxf sqlite3.tar.gz && cd sqlite-autoconf-${SQLITE3} && ./configure --prefix=/usr --enable-shared=no && make && make install && cd .. && rm -rf sqlite3.tar.gz sqlite-autoconf-${SQLITE3}
    ```


{{%/tab%}}

{{</tabs>}}




