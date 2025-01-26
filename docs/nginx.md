---
title: Install Nginx
description: Install Nginx.
slug: /install-nginx
sidebar_position: 3
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Main

### Install Nginx

```bash title="install-nginx.sh" file=../scripts/install-nginx.sh

```

### Create Nginx Service

```systemd title="/etc/systemd/system/nginx.service"
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

### Create Nginx Configuration

```nginx title="/usr/local/nginx/conf/nginx.conf" file=../conf/nginx/nginx.conf

```

### Start Nginx Service

```bash
mkdir -p /usr/local/nginx/conf/vhosts/
systemctl daemon-reload
systemctl enable --now nginx
systemctl status nginx
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="basic-server-configuration.yml" file=../playbooks/basic-server-configuration.yml

```

  </TabItem>
</Tabs>
