---
title: Rootkit Hunter
description: Rootkit Hunter.
slug: /rkhunter
sidebar_position: 11
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Install Rootkit Hunter

```bash
dnf install -y rkhunter
# update rkunter database
rkhunter --update
# update file properties database
rkhunter --propupd
```

### Configure Email Address for Warnings

```ini title="/etc/rkhunter.conf"
MAIL-ON-WARNING=<your-email-address>
```

### Run an Update and Check

```bash
rkhunter --update --check --skip-keypress
```

### Cron Job

Run `crontab -e`

```bash
0 2 * * * /usr/bin/rkhunter --update --check --skip-keypress --cronjob --nocolors
```

Optionally, you can use `taskset` and `nice` to run the cron job with low priority.

```bash
0 2 * * * taskset -c 0 nice -n 19 ionice -c3 /usr/bin/--update --check --skip-keypress --cronjob --nocolors
```

### View Logs

```bash
tail -f /var/log/rkhunter/rkhunter.log
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="rkhunter.yml" file=../playbooks/rkhunter.yml

```

  </TabItem>
</Tabs>
