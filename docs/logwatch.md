---
title: Logwatch
description: Logwatch is a customizable log analysis system.
slug: /logwatch
sidebar_position: 20
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Install Logwatch

```bash
dnf install -y logwatch
```

### Use default configuration

```bash
cp -f /usr/share/logwatch/default.conf/logwatch.conf /etc/logwatch/conf/logwatch.conf
```

### Configure email address for dalily report

```ini title="/etc/logwatch/conf/logwatch.conf"
MailTo = support@rectitude.cc
MailFrom = server@noreply.rectitude.cc
Range = yesterday
Detail = Med
```

### Useful commands

```bash
# View report for yesterday
logwatch --range yesterday
# View report for today and send to email
logwatch --range yesterday --mailto support@rectitude.cc
# View report for today with medium detail and send to email
logwatch --range today --detail med --mailto support@rectitude.cc

# Built-in service configuration
cd /usr/share/logwatch/default.conf/
```

### Schedule a daily logwatch report

Run `crontab -e`

```bash
00 04 * * * /usr/sbin/logwatch --range yesterday --mailto support@rectitude.cc
```

<!-- TODO: ADD Folder Structure -->

## Custom Service Configuration

### Modsecurity

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/modsecurity.conf" file=../conf/logwatch/conf/services/modsecurity.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/modsecurity.conf" file=../conf/logwatch/conf/logfiles/modsecurity.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/modsecurity" file=../conf/logwatch/scripts/services/modsecurity
    ```
  </TabItem>
</Tabs>

### Inotify File Monitor

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/inotify-file-monitor.conf" file=../conf/logwatch/conf/services/inotify-file-monitor.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/inotify-file-monitor.conf" file=../conf/logwatch/conf/logfiles/inotify-file-monitor.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/inotify-file-monitor" file=../conf/logwatch/scripts/services/inotify-file-monitor
    ```
  </TabItem>
</Tabs>

### Linux Malware Detect

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/maldetect.conf" file=../conf/logwatch/conf/services/maldetect.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/maldetect.conf" file=../conf/logwatch/conf/logfiles/maldetect.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/maldetect" file=../conf/logwatch/scripts/services/maldetect
    ```
  </TabItem>
</Tabs>

### Rootkit Hunter

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/rkhunter.conf" file=../conf/logwatch/conf/services/rkhunter.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/rkhunter.conf" file=../conf/logwatch/conf/logfiles/rkhunter.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/rkhunter" file=../conf/logwatch/scripts/services/rkhunter
    ```
  </TabItem>
</Tabs>

### Monit

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/monit.conf" file=../conf/logwatch/conf/services/monit.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/monit.conf" file=../conf/logwatch/conf/logfiles/monit.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/monit" file=../conf/logwatch/scripts/services/monit
    ```
  </TabItem>
</Tabs>

### WWW Backup

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/wwwbackup.conf" file=../conf/logwatch/conf/services/wwwbackup.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/wwwbackup.conf" file=../conf/logwatch/conf/logfiles/wwwbackup.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/wwwbackup" file=../conf/logwatch/scripts/services/wwwbackup
    ```
  </TabItem>
</Tabs>

### Mariadb Slowlog

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/mariadb-slowlog.conf" file=../conf/logwatch/conf/services/mariadb-slowlog.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/mariadb-slowlog.conf" file=../conf/logwatch/conf/logfiles/mariadb-slowlog.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/mariadb-slowlog" file=../conf/logwatch/scripts/services/mariadb-slowlog
    ```
  </TabItem>
</Tabs>

### Mariadb Errorlog

<Tabs>
  <TabItem value="service" label="Service" default>
    ```ini title="/etc/logwatch/conf/services/mariadb-errorlog.conf" file=../conf/logwatch/conf/services/mariadb-errorlog.conf
    ```
  </TabItem>
  <TabItem value="log-file" label="Log File">
    ```ini title="/etc/logwatch/conf/logfiles/mariadb-errorlog.conf" file=../conf/logwatch/conf/logfiles/mariadb-errorlog.conf
    ```
  </TabItem>
  <TabItem value="script" label="Script">
    ```perl title="/etc/logwatch/scripts/services/mariadb-errorlog" file=../conf/logwatch/scripts/services/mariadb-errorlog
    ```
  </TabItem>
</Tabs>

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="logwatch.yml" file=../playbooks/logwatch.yml

```

  </TabItem>
</Tabs>
