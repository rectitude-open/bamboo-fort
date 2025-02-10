---
title: Logrotate
description: Logrotate is a utility designed for administrators who manage servers producing a high volume of log files to help them save disk space and reduce the risk of data loss.
slug: /logrotate
sidebar_position: 13
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Install Logrotate

```bash
dnf install -y logrotate
```

### Nginx Logrotate

```title="/etc/logrotate.d/nginx" file=../conf/logrotate/nginx

```

### Modsecurity Logrotate

```title="/etc/logrotate.d/modsecurity" file=../conf/logrotate/modsecurity

```

### Useful Commands

```bash
# Test a configuration file
logrotate -d /etc/logrotate.d/nginx
# View service timer
less /var/lib/logrotate/logrotate.status
# View built-in services
ls /etc/logrotate.d/
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="install-mariadb.yml" file=../playbooks/install-mariadb.yml

```

  </TabItem>
</Tabs>
