---
title: Basic Server Configuration
description: Basic server configuration for Linux systems.
slug: /basic-server-configuration
sidebar_position: 1
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

The following configuration is based on **Almalinux 9.5**.

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Enable Repositories and Install Packages

```bash
dnf config-manager --set-enabled crb
dnf install -y epel-release
dnf install -y lrzsz screen dnf-automatic htop vim
systemctl enable --now dnf-automatic.timer
hostnamectl set-hostname <host-name>
```

### Start a Screen Session

```bash
# Reattach to a screen session or create a new one
screen -R <session-name>

# Detach from the current screen session
# ctrl+a d

# List all sessions
# screen -ls
```

### Configure Vim Editor

```vim title="~/.vimrc"
syntax on
set hlsearch
set showmatch
set tabstop=4
set shiftwidth=4
set expandtab
```

### Add Bash History and Aliases

```bash
cat >> ~/.bashrc << EOF
HISTSIZE=1000
HISTFILESIZE=2000
alias ll='ls -alh'
EOF
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

### Update System Packages

```bash
dnf upgrade -y
# dnf upgrade -y = dnf update -y = yum update -y
```

### Reboot System

```bash
reboot
```

## Optional

### Enable Fastest Mirror Plugin

```ini title="/etc/dnf/dnf.conf"
fastestmirror=True
```

### Create Swap Space if Needed

```bash
yum install util-linux
## Create a 2GB swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# vi /etc/sysctl.conf, allow the system to use swap space when memory is low.
vm.swappiness=1

# vi /etc/fstab, add the following line to the end of the file
/swapfile    swap    swap    default    0    0

# uninstall: swapoff -v /swapfile
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```bash title="Install Ansible and start a screen session"
dnf config-manager --set-enabled crb
dnf install -y epel-release
dnf install -y ansible-core screen
screen -R setup
```

```ini title="vi /etc/ansible/hosts"
[local]
localhost ansible_connection=local
```

```bash title="Run Playbook"
ansible-playbook basic-server-configuration.yml

# Dry-run
# ansible-playbook --check basic-server-configuration.yml
```

```yml title="basic-server-configuration.yml" file=../playbooks/basic-server-configuration.yml

```

  </TabItem>
</Tabs>
