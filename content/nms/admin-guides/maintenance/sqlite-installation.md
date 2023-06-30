---
title: "Sqlite Installation"
date: 2022-12-13T13:17:52-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Follow the steps in this guide to install sqlite for your respective operating system."
# Assign weights in increments of 100
weight: 
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: 

---

{{< custom-styles >}}

## Overview

- Sqlite can be installed for each supported operating system. However, for some of the older operating systems a different approach must be taken. Please
  see the relevant sections for your operating system.
---
To complete the instructions in this guide, you need the following:

- To install SQLite, run the following command(s):

    - CentOS, RHEL, RPM-Based distributions, <u>excluding CentOS-7, AmazonLinux-2 and Oracle Linux 7</u>:

        ```bash
        sudo yum install -y sqlite
        ```

    - Debian, Ubuntu, Deb-Based distributions, <u>excluding Debian (buster/sid), Ubuntu 18.04</u>:

        ```bash
        sudo apt-get update
        sudo apt-get install -y sqlite3
        ```
    - Debian (buster/sid), Ubuntu 18.04
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
    - CentOS-7, AmazonLinux-2 and Oracle Linux 7
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