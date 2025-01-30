---
title: Install MariaDB
description: Install MariaDB.
slug: /install-mariadb
sidebar_position: 5
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Install MariaDB

```bash
# Add MariaDB repository
curl -sSL https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
dnf install -y MariaDB-server MariaDB-client
systemctl enable --now mariadb
```

### Run Secure MariaDB script

```
[root@webserver ~]# mariadb-secure-installation

- Enter current password for root (enter for none): <enter>

- Switch to unix_socket authentication [Y/n] n

- Change the root password? [Y/n] Y

- New password: <enter-your-root-password>

- Re-enter new password: <enter-your-root-password>

- Remove anonymous users? [Y/n] Y

- Disallow root login remotely? [Y/n] Y

- Remove test database and access to it? [Y/n] Y

- Reload privilege tables now? [Y/n] Y
```

### Configure MariaDB

```ini title="/etc/my.cnf"
[mysqld]
log_warnings=1
pid-file=/run/mariadb.pid
socket = /run/mysqld.sock
collation-server=utf8mb4_general_ci
character-set-server=utf8mb4
init_connect=SET NAMES utf8mb4
innodb_buffer_pool_size = 200M
query_cache_size = 8M
max_connections = 200
default_storage_engine = InnoDB
slow_query_log = 1
slow_query_log_file = /var/log/mariadb/slow.log
long_query_time = 2
log_error = /var/log/mariadb/error.log
# skip-networking
bind-address = 127.0.0.1
skip-symbolic-links
local-infile=0

[client]
default-character-set=utf8mb4
socket = /run/mysqld.sock

#
# This group is read both by the client and the server
# use it for options that affect everything
#
[client-server]

#
# include *.cnf from the config directory
#
!includedir /etc/my.cnf.d
```

### Directory and Permissions

```bash
mkdir -p /var/log/mariadb
touch /var/log/mariadb/slow.log
touch /var/log/mariadb/error.log
chown -R mysql:mysql /var/log/mariadb/
```

### Restart MariaDB

```bash
systemctl restart mariadb
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="install-mariadb.yml" file=../playbooks/install-mariadb.yml

```

  </TabItem>
</Tabs>
