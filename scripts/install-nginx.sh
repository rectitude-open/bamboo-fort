#!/bin/sh

# Interactive input for variables
read -p "Please enter the version of Nginx (e.g., 1.26.2): " nginx_version
read -p "Please enter the run group name (default: www): " run_group
run_group=${run_group:-www}
read -p "Please enter the run user name (default: www): " run_user
run_user=${run_user:-www}

# Check if the specified group and user exist, create if not
id -g ${run_group} >/dev/null 2>&1
[ $? -ne 0 ] && groupadd ${run_group}
id -u ${run_user} >/dev/null 2>&1
[ $? -ne 0 ] && useradd -g ${run_group} -M -s /sbin/nologin ${run_user}

# Install required dependencies
dnf -y install tar wget gcc gcc-c++ make zlib-devel pcre-devel openssl-devel libxml2-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed

# Download headers-more-nginx-module
git clone https://github.com/openresty/headers-more-nginx-module /usr/local/headers-more-nginx-module

# Create Nginx cache directory and set permissions
mkdir -p /var/cache/nginx
chown ${run_user}:${run_group} /var/cache/nginx

# Download and compile Nginx
cd /usr/local/src/

wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar -xzf nginx-${nginx_version}.tar.gz

cd nginx-${nginx_version}

./configure \
	--prefix=/usr/local/nginx \
	--sbin-path=/usr/sbin/nginx \
	--pid-path=/run/nginx.pid \
	--lock-path=/run/nginx.lock \
	--user=${run_user} \
	--group=${run_group} \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--http-client-body-temp-path=/var/cache/nginx/client_body \
	--http-proxy-temp-path=/var/cache/nginx/proxy \
	--http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
	--http-uwsgi-temp-path=/var/cache/nginx/uwsgi \
	--http-scgi-temp-path=/var/cache/nginx/scgi \
	--with-compat \
	--with-debug \
	--with-file-aio \
	--with-http_addition_module \
	--with-http_auth_request_module \
	--with-http_dav_module \
	--with-http_degradation_module \
	--with-http_flv_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_image_filter_module=dynamic \
	--with-http_mp4_module \
	--with-http_perl_module=dynamic \
	--with-http_random_index_module \
	--with-http_realip_module \
	--with-http_secure_link_module \
	--with-http_slice_module \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-http_sub_module \
	--with-http_v2_module \
	--with-http_xslt_module=dynamic \
	--with-mail=dynamic \
	--with-mail_ssl_module \
	--with-pcre \
	--with-pcre-jit \
	--with-stream=dynamic \
	--with-stream_ssl_module \
	--with-stream_ssl_preread_module \
	--with-threads \
	--add-module=/usr/local/headers-more-nginx-module \
	--add-module=/usr/local/ModSecurity-nginx

make && make install

mkdir -p /var/log/nginx/
touch /var/log/nginx/error.log
touch /var/log/nginx/access.log
chown -R ${run_user}:${run_group} /var/log/nginx
chmod -R 750 /var/log/nginx
