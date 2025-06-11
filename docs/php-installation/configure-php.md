---
title: Configure PHP
description: Configure PHP and PHP-FPM for your web server.
slug: /configure-php
sidebar_position: 3
---

### Configure PHP

```ini title="/etc/php.ini or /usr/local/php/php.ini"
expose_php = Off
error_log = "/var/log/php-error.log"
max_execution_time = 30
memory_limit = 128M
upload_max_filesize = 2M
post_max_size = 8M
display_errors = Off
disable_functions = exec,passthru,shell_exec,system,popen,show_source
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
mkdir -p /var/log
touch /var/log/php-fpm.log
touch /var/log/php-error.log
chown www:www /var/log/php-fpm.log
chown www:www /var/log/php-error.log
chmod 640 /var/log/php-fpm.log
chmod 640 /var/log/php-error.log
```

### Start PHP-FPM Service

```bash
systemctl daemon-reload
systemctl enable --now php-fpm
systemctl status php-fpm
```
