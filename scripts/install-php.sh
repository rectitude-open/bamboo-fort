#!/bin/sh

# Interactive input for PHP version
read -p "Please enter the PHP version you want to install (e.g., 8.3.15): " php_version

# Install required dependencies
dnf install -y gcc gcc-c++ make libxml2-devel bzip2-devel curl-devel libpng-devel libjpeg-devel libXpm-devel freetype-devel gmp-devel libmcrypt-devel oniguruma-devel libxslt-devel libzip-devel libwebp-devel zip cronie sqlite sqlite-devel systemd-devel

# Download and compile PHP
cd /usr/local/src
wget https://www.php.net/distributions/php-${php_version}.tar.gz
tar -xzf php-${php_version}.tar.gz
cd php-${php_version}

make clean
./configure \
	--prefix=/usr/local/php \
	--enable-gd \
	--enable-soap \
	--enable-intl \
	--enable-bcmath \
	--enable-sockets \
	--enable-opcache \
	--enable-mbstring \
	--enable-pcntl \
	--enable-fpm \
	--with-config-file-path=/usr/local/php \
	--with-fpm-user=www \
	--with-fpm-group=www \
	--with-fpm-systemd \
	--with-mysqli \
	--with-pdo-mysql \
	--with-openssl \
	--with-curl \
	--with-zip \
	--with-zlib \
	--with-bz2 \
	--with-external-pcre \
	--with-jpeg \
	--with-freetype \
	--with-xsl \
	--with-pear

make -j$(nproc)
make install
cp php.ini-production /usr/local/php/php.ini
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
