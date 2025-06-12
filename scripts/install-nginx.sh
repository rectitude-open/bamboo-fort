#!/bin/bash

set -e
set -u
set -o pipefail

read -p "Please enter the version of Nginx (e.g., 1.28.0): " nginx_version
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
dnf -y install tar wget git gcc gcc-c++ make zlib-devel pcre-devel openssl-devel libxml2-devel libxslt-devel gd gd-devel perl-ExtUtils-Embed


if [ ! -d "/usr/local/headers-more-nginx-module" ]; then
    git clone https://github.com/openresty/headers-more-nginx-module /usr/local/headers-more-nginx-module
fi

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

make -j"$(nproc)"
make install

mkdir -p /var/log/nginx/
touch /var/log/nginx/error.log
touch /var/log/nginx/access.log
chown -R "${run_user}":"${run_group}" /var/log/nginx
chmod -R 750 /var/log/nginx

NGINX_SERVICE_FILE="/etc/systemd/system/nginx.service"
cat > "${NGINX_SERVICE_FILE}" <<EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
Documentation=https://nginx.org/en/docs/
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/sbin/nginx -c /usr/local/nginx/conf/nginx.conf -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/usr/sbin/nginx -s stop
TimeoutStopSec=5s
LimitNOFILE=65536
Restart=on-failure
RestartSec=5s
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now nginx

echo "Nginx ${nginx_version} installed successfully."

systemctl status nginx
