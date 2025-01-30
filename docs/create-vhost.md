---
title: Create Virtual Host
description: Create Virtual Host.
slug: /create-vhost
sidebar_position: 6
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Create Linux User/Group and Web Root

```bash
groupadd aaa && useradd -g aaa -s /sbin/nologin aaa

mkdir -p /home/wwwroot/aaa.com/{public,tmp}
chown -R aaa:www /home/wwwroot/aaa.com
chmod -R 750 /home/wwwroot/aaa.com
```

### Create Nginx Configuration

```nginx title="/usr/local/nginx/conf/vhosts/aaa.com.conf"
server {
    server_tokens off;
    listen 80;
    server_name aaa.com www.aaa.com;
    root /home/wwwroot/aaa.com/public;
    index index.php index.html index.htm;

    access_log /var/log/nginx/access_for_fail2ban.log combined if=$fail2banlog;
    access_log /home/wwwlogs/aaa.com/access.log;
    error_log /home/wwwlogs/aaa.com/error.log;

    modsecurity on;
    modsecurity_rules_file /etc/nginx/modsec/main.conf;

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2|ttf|otf|eot)$ {
        sendfile on;
        tcp_nopush on;
        expires 2d;
        access_log off;
    }

    location / {
        limit_req zone=req_limit_20 burst=50;
        try_files $uri $uri/ /index.php?$args;
        expires -1;
        add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate";
    }

    location ~ \.php$ {
        limit_req zone=req_limit_10 burst=30;
        sendfile off;
        tcp_nopush off;
        if ($request_method !~ ^(HEAD|OPTIONS|GET|POST|PUT|PATCH|DELETE)$ ) {
            return 405;
        }

        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm-aaa.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~ /\.(ht|git|svn|vscode|DS_Store|idea|env|project|settings|history) {
        deny all;
    }
}
```

### Create PHP-FPM Configuration

```ini title="/usr/local/php/etc/php-fpm.d/aaa.conf"
[aaa]
user = aaa
group = aaa
listen = /run/php-fpm-aaa.sock
listen.owner = aaa
listen.group = www
listen.mode = 0660
pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
php_admin_value[session.save_path] = /home/wwwroot/aaa.com/tmp
php_admin_flag[log_errors] = on
php_admin_value[error_log] = /home/wwwlogs/aaa.com/php-error.log
php_admin_value[open_basedir] = /home/wwwroot/aaa.com/:/tmp:/var/tmp/
security.limit_extensions = .php
```

### Create Database User and Database

```bash
mariadb -uroot
```

```sql
CREATE DATABASE aaa_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'aaa_user'@'localhost' IDENTIFIED BY 'aaa_db_password';

GRANT
    SELECT, INSERT, UPDATE, DELETE,
    CREATE, ALTER, INDEX, DROP,
    CREATE TEMPORARY TABLES, SHOW VIEW,
    CREATE ROUTINE, ALTER ROUTINE, EXECUTE,
    CREATE VIEW, EVENT, TRIGGER,
    LOCK TABLES, REFERENCES
ON aaa_db.* TO 'aaa_user'@'localhost';

FLUSH PRIVILEGES;
```

## Optional

### Enable SSL in Nginx Virtual Host

```nginx
server {
    listen 443 ssl http2;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers on;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:10m;
    ssl_stapling on;
    ssl_stapling_verify on;
}
```

### Deny access to sensitive files

```nginx
server {
    location ~* ^/wp-content/uploads/.*\.php$ { deny all; }
    location ~* ^/wp-content/cache/.*\.php$ { deny all; }
    location ~* ^/wp-content/backup/.*\.php$ { deny all; }
}
```

### Restrict Access to Admin Area

```nginx
server {
    location /admin {
        allow 192.168.1.0/24;
        deny all;
    }
}
```

## Extended

### Explanations of Nginx Settings

```nginx
# Prevent nginx version information from being displayed
server_tokens off;

# Reduce resource consumption by idle connections, improving server performance
keepalive_timeout 15s;

# Maximum time to wait for the client to send the complete request header, returning 408 on failure. This may interrupt access for slower clients or users with low network speeds.
client_header_timeout 10s;

# Prevent server resources from being occupied by slow clients. For clients with slower networks, this may cause response transmission failures.
send_timeout 10s;

# Set the timeout for reading the client's request body to prevent slow attacks (e.g., Slowloris).
client_body_timeout 10s;

# For users needing to upload large files or with slower networks, this may cause request failures. However, with client_max_body_size set to 8m, the request body timeout for large file uploads can be extended appropriately, for example, by overriding this setting in a specific location block.

# Prevent buffer overflow attacks, limiting the ability to upload large files.
client_max_body_size 10m;

# Buffer size for receiving the client's request body, reducing memory consumption.
client_body_buffer_size 1K;

# Buffer size for receiving the client's request header, preventing buffer overflow from large request headers.
client_header_buffer_size 1k;

# Allocate double the buffer size for very large client request headers.
large_client_header_buffers 2 1k;

# Disable outdated protocols (e.g., SSLv3, TLS 1.0, TLS 1.1).
ssl_protocols TLSv1.2 TLSv1.3;

# Use strong cipher suites.
ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES256-GCM-SHA384;

# Prefer the server's cipher suite order when selecting an encryption method.
ssl_prefer_server_ciphers on;

# Reuse previous SSL sessions to reduce handshake frequency.
ssl_session_timeout 1d;

# Cache SSL sessions in memory; 10M can store approximately 10,000 sessions.
ssl_session_cache shared:SSL:10m;

# Reduce certificate validation latency by verifying validity, slightly increasing server load.
ssl_stapling on;
ssl_stapling_verify on;

# Add HSTS header to enforce HTTPS for one year, preventing downgrade attacks.
# If your website or subdomains need to use HTTP in the future, they will be inaccessible.
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

# Prevent embedding in iframes (clickjacking attacks).
# If your business needs to embed third-party pages, this may be restricted.
add_header X-Frame-Options "SAMEORIGIN" always;

# Enable browser XSS filtering.
add_header X-XSS-Protection "1; mode=block" always;

# Only allow loading resources from the same origin, affecting the loading of JS libraries from other domains.
add_header Content-Security-Policy "default-src 'self';" always;

# Prevent the browser from guessing file types (e.g., .txt being parsed as .html).
add_header X-Content-Type-Options "nosniff" always;

```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="create-vhost.yml" file=../playbooks/create-vhost.yml

```

  </TabItem>
</Tabs>
