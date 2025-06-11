---
title: Install via Package
description: Install PHP via package manager.
slug: /install-via-package
sidebar_position: 1
---

### Install PHP via Remi Repository

The simplest and most memory-efficient way to install PHP is by using precompiled packages provided by your operating system's package manager. However, the default repositories provided by most operating systems often do not include the latest PHP versions. In such cases, you need to use a third-party repository. Remi is a trusted third-party repository that allows you to install and manage different PHP versions easily.

```bash
# Enable the Remi repository
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm

# Install PHP 8.3
dnf module install php:remi-8.3

# Install PHP extensions
dnf install -y php-devel php-gd php-soap php-intl php-bcmath php-sockets php-opcache php-mbstring php-pcntl php-mysqlnd php-pdo php-openssl php-curl php-zip php-zlib php-bz2 php-pecl-zip php-xsl php-pear

# Check the installed PHP version
php --version
# Check out the installed extensions
php --modules
```

For more details and custom installation options, visit the [Remi Repository Wizard](https://rpms.remirepo.net/wizard/).

### Location of PHP Configuration Files

- PHP.ini location: `/etc/php.ini`
- PHP-FPM configuration file: `/etc/php-fpm.conf`
- PHP FPM configuration files directory: `/etc/php-fpm.d/`
