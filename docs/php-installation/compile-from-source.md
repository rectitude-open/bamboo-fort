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

Compiling PHP from source offers greater flexibility in tailoring the installation to your specific needs. However, this process can be quite memory-intensive. Based on our tests, if your system has less than 2GB of available RAM, we do not recommend compiling from source, as you may encounter performance issues or compilation failures.

### Install PHP

```bash title="install-php.sh" file=../../scripts/install-php.sh

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

### Directory and Permissions

```bash
# The 'www' user needs read access to the PHP installation directory to load core files, but should not have root-level write access.
chown -R root:www /usr/local/php
chmod -R 750 /usr/local/php

# PHP-FPM requires access to extension modules (e.g., redis.so).
chown -R root:www /usr/local/php/lib/php/extensions
chmod -R 750 /usr/local/php/lib/php/extensions

# The PHP-FPM master process needs to read global and pool configuration files.
chown -R www:www /usr/local/php/etc
chmod -R 750 /usr/local/php/etc
```

### Location of PHP Configuration Files

- PHP.ini location: `/usr/local/php/php.ini`
- PHP-FPM configuration file: `/usr/local/php/etc/php-fpm.conf`
- PHP FPM configuration directory: `/usr/local/php/etc/php-fpm.d/`

</TabItem>
<TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="install-php.yml" file=../../playbooks/install-php.yml

```

  </TabItem>
</Tabs>
