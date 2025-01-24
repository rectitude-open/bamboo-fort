---
title: Server Configuration
description: Basic server configuration for Linux systems.
slug: /server-configuration
sidebar_position: 1
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

The following configuration is based on **Almalinux 9.5**.

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Enable Repositories

```bash
dnf config-manager --set-enabled crb
dnf install -y epel-release
dnf install -y ansible lrzsz screen dnf-automatic
systemctl enable --now dnf-automatic.timer
hostnamectl set-hostname <host-name>
```

### Enable Fastest Mirror Plugin

```ini title="/etc/dnf/dnf.conf"
fastestmirror=True
```

### Configure Vim Editor

```vim title="~/.vimrc"
syntax on
set autoindent
set smartindent
set hlsearch
set showmatch
set tabstop=4
set shiftwidth=4
set expandtab
```

### Add Bash Aliases

```bash
echo "alias ll='ls -alh'" >> ~/.bashrc
source ~/.bashrc
```

### Configure Automatic Updates

```ini title="/etc/dnf/automatic.conf"
upgrade_type = security
apply_updates = yes
```

### Set Login Warning Message

```bash
tee /etc/issue /etc/issue.net /etc/motd << EOF
*** Warning ***
Authorized access only! This is a private system.
All connections are monitored and recorded.
Unauthorized access or use may lead to prosecution.
Disconnect IMMEDIATELY if you are not an authorized user!
EOF
```

### Manage Screen Sessions

```bash
# Reattach to a screen session or create a new one
screen -R <session-name>

# Detach from the current screen session
ctrl+a d

# List all sessions
screen -ls
```

### Update System Packages

```bash
dnf upgrade -y
```

### Reboot System

```bash
reboot
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>
  ```yml file=../playbook/server-configuration.yml
  ```
  </TabItem>
</Tabs>
