---
title: Firewalld & Fail2Ban
description: Firewalld & Fail2Ban
slug: /firewalld-fail2ban
sidebar_position: 8
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Disable IPTABLES and IP6TABLES

```bash
systemctl stop iptables
systemctl disable iptables
systemctl stop ip6tables
systemctl disable ip6tables
```

### Enable Firewalld and Add Basic Rules

```bash
systemctl start firewalld
firewall-cmd --permanent --zone=public --set-target=DROP
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
systemctl enable firewalld

# View all rules
firewall-cmd --list-all
```

### Install Fail2Ban

```
dnf install -y fail2ban GeoIP GeoIP-data python3-inotify
```

### Create Nginx 4xx/5xx Filter

```ini title="/etc/fail2ban/filter.d/nginx-4xx-5xx.conf"
[Definition]
failregex =  ^<HOST>.*"(GET|POST|HEAD|PUT|DELETE|OPTIONS|PATCH).*" (4\d{2}|5\d{2}) .*$
ignoreregex =.*(robots.txt|favicon.ico)
```

### Create Fail2Ban Jail

```ini title="/etc/fail2ban/jail.local"
[DEFAULT]
banaction = firewallcmd-rich-rules[actiontype=<multiport>]
banaction_allports = firewallcmd-rich-rules[actiontype=<allports>]
ignoreip = 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
action = sendmail-geoip-lines
dest = <receiver@domain.com>
sender = <sender@your-domain.com>
destemail =

[nginx-4xx-5xx]
enabled = true
logpath = /var/log/nginx/access_for_fail2ban.log
filter = nginx-4xx-5xx
action = firewallcmd-rich-rules[name=nginx-4xx-5xx, port="80,443", protocol=tcp]
          sendmail-geoip-lines
findtime = 10
maxretry = 20
bantime = 3600
bantime.increment = true
bantime.rndtime = 300
bantime.maxtime = 86400
bantime.overalljails = true


[sshd]
enabled = true
findtime = 3600
maxretry = 5
bantime = 7200
```

### Configure Sendmail

```ini title="/etc/fail2ban/action.d/sendmail-common.local"
[Definition]
actionstart =
actionstop =
actioncheck =
actionban =
actionunban =

[Init]
mailcmd = /usr/sbin/sendmail -f "<sender>" "<dest>"
dest = <receiver@domain.com>
sender = <sender@your-domain.com>
sendername = <server-name>-Fail2Ban
```

### Configure Sendmail GeoIP Template

```ini title="/etc/fail2ban/action.d/sendmail-geoip-lines.conf"
# Fail2Ban configuration file
#
# Author: Viktor Szépe
#
#

[INCLUDES]

before = sendmail-common.conf
         helpers-common.conf

[Definition]

# bypass ban/unban for restored tickets
norestored = 1

# Option:  actionban
# Notes.:  Command executed when banning an IP. Take care that the
#          command is executed with Fail2Ban user rights.
#          You need to install geoiplookup and the GeoLite or GeoIP databases.
#          (geoip-bin and geoip-database in Debian)
#          The host command comes from bind9-host package.
# Tags:    See jail.conf(5) man page
# Values:  CMD
#
actionban = ( printf %%b "Subject: [Fail2Ban] <name>: banned <ip> from <fq-hostname>
            Date: `LC_ALL=C date +"%%a, %%d %%h %%Y %%T %%z"`
            From: <sendername> <<sender>>
            To: <dest>\n
            Hi,\n
            The IP <ip> has just been banned by Fail2Ban after
            <failures> attempts against <name>.\n\n
            Country:`geoiplookup -f /usr/share/GeoIP/GeoIP.dat "<ip>" | cut -d':' -f2-`
            hostname: <ip-host>\n\n
            Information from ipinfo.io:\n
            `curl -s "https://ipinfo.io/<ip>" | jq '.'`\n\n
            Information from ip-api.com:\n
            `curl -s "http://ip-api.com/json/<ip>" | jq '.'`\n\n
            Lines containing failures of <ip> (max <grepmax>)\n";
            %(_grep_logs)s;
            printf %%b "\n
            Regards,\n
            Fail2Ban" ) | <mailcmd>

[Init]

# Default name of the chain
#
name = default

# Path to the log files which contain relevant lines for the abuser IP
#
logpath = /dev/null

# Number of log lines to include in the email
#
#grepmax = 1000
#grepopts = -m <grepmax>
```

### Start Fail2Ban

```bash
systemctl enable --now fail2ban
```

## Extended

### Useful Fail2Ban Commands

```bash
# check status
fail2ban-client status
fail2ban-client status nginx-4xx-5xx

# view log
tail -f /var/log/fail2ban.log

# reload after config change
fail2ban-client reload

# ban IP manually
fail2ban-client set sshd banip <ip-address>

# unban IP
fail2ban-client set nginx-4xx-5xx unbanip <ip-address>
```

### Fail2ban Official Documentation

https://github.com/fail2ban/fail2ban/wiki/Best-practice

### Find failed ssh login attempts

```bash
tail -f /var/log/secure
grep 'sshd.*Failed password for' /var/log/secure
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="fail2ban.yml" file=../playbooks/fail2ban.yml

```

  </TabItem>
</Tabs>
