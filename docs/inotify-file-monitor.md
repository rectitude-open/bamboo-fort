---
title: Inotify File Monitor
description: Inotify File Monitor is a tool to monitor specific files and directories for changes.
slug: /inotify-file-monitor
sidebar_position: 9
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Install Inotify Tools

```bash
dnf install inotify-tools
```

### Create Inotify File Monitor Script

```bash title="/usr/local/inotify-file-monitor/inotify-file-monitor.sh" file=../scripts/inotify-file-monitor.sh

```

### Create Systemd Service

```systemd title="/etc/systemd/system/inotify-file-monitor.service"
[Unit]
Description=Inotify File Monitor
After=network.target

[Service]
ExecStart=/usr/local/inotify-file-monitor/inotify-file-monitor.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

### Enable and Start Service

```bash
systemctl enable --now inotify-file-monitor
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="inotify-file-monitor.yml" file=../playbooks/inotify-file-monitor.yml

```

  </TabItem>
</Tabs>
