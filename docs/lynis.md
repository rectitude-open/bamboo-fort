---
title: Lynis
description: Lynis is a security auditing tool for Linux, macOS, and Unix systems. It performs an in-depth security scan and reports back any vulnerabilities found.
slug: /lynis
sidebar_position: 12
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Install Lynis

```bash
dfn install -y lynis
```

### Audit System

```bash
lynis audit system
# lynis audit system --nocolors > audit.txt
```

### Custom Scripts

```bash
mkdir -p /usr/local/lynis
```

```bash title="/usr/local/lynis/run_lynis.sh" file=../scripts/lynis/run_lynis.sh

```

```bash title="/usr/local/lynis/compare_lynis.sh" file=../scripts/lynis/compare_lynis.sh

```

```bash title="/usr/local/lynis/edit_latest_log.sh" file=../scripts/lynis/edit_latest_log.sh

```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="install-mariadb.yml" file=../playbooks/install-mariadb.yml

```

  </TabItem>
</Tabs>
