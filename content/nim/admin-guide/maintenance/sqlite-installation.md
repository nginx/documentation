---
docs: DOCS-1270
title: Install SQLite (for NGINX Instance Manager 2.14.1 and earlier)
toc: true
weight: 10
---

## Install SQLite for your Linux distribution

If you're using **NGINX Instance Manager version 2.14.1 or earlier**, you'll need to install SQLite to run the [backup and recovery scripts]({{< ref "/nim/admin-guide/maintenance/backup-and-recovery.md" >}}).
Follow the steps to install SQLite for your operating system. Note that some older versions of Linux might require additional steps, explained below.

### CentOS, RHEL, and RPM-based distributions

To install SQLite on your system, run the appropriate command(s) for your Linux distribution:

#### For RHEL and RPM-based distributions (excluding CentOS 7, Amazon Linux 2, and Oracle Linux 7):

```bash
sudo yum install -y sqlite
```

#### For CentOS 7, Amazon Linux 2, and Oracle Linux 7:

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

### Debian, Ubuntu, and Deb-based distributions

To install SQLite on your system, run the appropriate command(s) for your Linux distribution:

#### For Debian, Ubuntu, and Deb-based distributions (excluding Debian (buster/sid) and Ubuntu 18.04):

```bash
sudo apt-get update
sudo apt-get install -y sqlite3
```

#### For Debian (buster/sid) and Ubuntu 18.04:

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
