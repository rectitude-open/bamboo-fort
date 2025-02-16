---
title: WWW Backup
description: WWW Backup
slug: /wwwbackup
sidebar_position: 13
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Install Duplicity

```bash
dnf install -y duplicity
```

### Create the backup script

```bash
touch /usr/local/bin/wwwbackup.sh && chmod 700 /usr/local/bin/wwwbackup.sh
```

```bash title="/usr/local/bin/wwwbackup.sh" file=../scripts/wwwbackup.sh

```

### Add the script to the crontab

```bash
crontab -e
30 00 * * * /usr/local/bin/wwwbackup.sh
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="wwwbackup.yml" file=../playbooks/wwwbackup.yml

```

  </TabItem>
</Tabs>
