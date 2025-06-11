---
title: Compile from Source
description: Compile PHP from source.
slug: /compile-from-source
sidebar_position: 2
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Install PHP

```bash title="install-php.sh" file=../../scripts/install-php.sh

```

### Configure PHP

```ini title="/usr/local/php/php.ini"
include_path = ".:/usr/local/php/lib/php"
expose_php = Off
error_log = "/var/log/php-error.log"
max_execution_time = 30
memory_limit = 128M
upload_max_filesize = 2M
post_max_size = 8M
display_errors = Off
disable_functions = exec,passthru,shell_exec,system,proc_open,popen,show_source
mysqli.default_socket = /run/mysqld/mysqld.sock
pdo_mysql.default_socket = /run/mysqld/mysqld.sock
```

### Configure PHP-FPM

```ini title="/usr/local/php/etc/php-fpm.conf"
pid = /run/php-fpm.pid
error_log = /var/log/php-fpm.log
log_level = notice
```

### Directory and Permissions

```bash
# Directory and permissions for log files
mkdir -p /var/log
touch /var/log/php-fpm.log
touch /var/log/php-error.log
chown www:www /var/log/php-fpm.log
chown www:www /var/log/php-error.log
chmod 640 /var/log/php-fpm.log
chmod 640 /var/log/php-error.log

# The 'www' user needs read access to the PHP installation directory to load core files, but should not have root-level write access.
chown -R root:www /usr/local/php
chmod -R 750 /usr/local/php

# PHP-FPM requires access to extension modules (e.g., redis.so).
chown -R root:www /usr/local/php/lib/php/extensions
chmod -R 750 /usr/local/php/lib/php/extensions

# The PHP-FPM master process needs to read global and pool configuration files.
chown -R www:www /usr/local/php/etc
chmod -R 750 /usr/local/php/etc

# Write permissions are needed for PHP-FPM error and access logs.
mkdir -p /var/log/php-fpm
chown -R www:www /var/log/php-fpm
chmod -R 750 /var/log/php-fpm
```

### Create PHP-FPM Service

```systemd title="vi /etc/systemd/system/php-fpm.service"
[Unit]
Description=PHP FastCGI Process Manager
After=network.target

[Service]
Type=simple
RuntimeDirectory=php-fpm
RuntimeDirectoryMode=0750
RuntimeDirectoryOwner=www
RuntimeDirectoryGroup=www
PIDFile=/run/php-fpm.pid
ExecStart=/usr/local/php/sbin/php-fpm --nodaemonize --fpm-config /usr/local/php/etc/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -SIGQUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

### Start PHP-FPM Service

```bash
systemctl daemon-reload
systemctl enable --now php-fpm
systemctl status php-fpm
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="install-php.yml" file=../../playbooks/install-php.yml

```

  </TabItem>
</Tabs>
