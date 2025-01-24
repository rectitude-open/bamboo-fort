---
id: my-doc-id
title: Basic
description: My document description
slug: /basic
sidebar_position: 1
---

The following configuration is based on **Almalinux 9.5**.

### Enable Repositories

```bash
dnf config-manager --set-enabled crb
dnf install -y epel-release
dnf install -y ansible lrzsz screen
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
