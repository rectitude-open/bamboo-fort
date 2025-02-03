---
title: Linux Malware Detect
description: Install and configure Linux Malware Detect.
slug: /maldetect
sidebar_position: 10
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Compile and Install LMD

```bash
dnf install -y inotify-tools
cd /usr/local/src/
wget https://www.rfxn.com/downloads/maldetect-current.tar.gz
tar -zxvf maldetect-current.tar.gz
cd maldetect-<version>
./install.sh
```

### Configure LMD

```ini title="/usr/local/maldetect/conf.maldet"
email_alert="1"
email_addr="admin@rectitude.cc"
email_ignore_clean="0"
autoupdate_signatures="1"
cron_prune_days="35"
quarantine_hits="1"
quarantine_clean="1"
scan_clamscan="0"
inotify_docroot="/home/wwwroot"
```

### Log Files

```bash
# event log, include hit
tail -f /usr/local/maldetect/logs/event_log
# inotify log
tail -f /usr/local/maldetect/logs/inotify_log
```

### Test Malware Detection

```bash
cd /home/wwwroot/
# https://www.eicar.org/download-anti-malware-testfile/
wget https://www.eicar.org/download/eicar-com-2/?wpdmdl=8842&refresh=67848acef11891736739534
```

### Useful Commands

```bash
# scan a directory
/usr/local/maldetect/maldet -a /home/wwwroot/
# monitor a directory
/usr/local/maldetect/maldet --monitor /home/wwwroot/
# update signatures
maldet -u
# update version
maldet -d
# view quarantined files
ll /usr/local/maldetect/quarantine/
# clean quarantined files
rm -rf /usr/local/maldetect/quarantine/*
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="maldetect.yml" file=../playbooks/maldetect.yml

```

  </TabItem>
</Tabs>
