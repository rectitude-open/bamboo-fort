---
title: Postfix & S-nail
description: Postfix & S-nail
slug: /postfix-s-nail
sidebar_position: 7
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Prepare

| Variable           | Example1            | Example2                     |
| ------------------ | ------------------- | ---------------------------- |
| smtp-server        | mail.spacemail.com  | smtpdm.aliyun.com            |
| smtp-port          | 465                 | 465                          |
| sender-domain      | rectitude.cc        | no-reply.rectitude.cc        |
| user@sender-domain | server@rectitude.cc | server@no-reply.rectitude.cc |
| password           | \*\*\*\*            | \*\*\*\*                     |

### Install Postfix

```bash
dnf install -y postfix
systemctl enable --now postfix
```

### Set Default MTA (Mail Transfer Agent)

Run `alternatives --config mta`, and select `sendmail.postfix`

```bash
[root@webserver ~]# alternatives --config mta

There is 1 program that provides 'mta'.

  Selection    Command
-----------------------------------------------
*  1           /usr/sbin/sendmail.sendmail
 + 2           /usr/sbin/sendmail.postfix

Enter to keep the current selection[+], or type selection number: 2
```

### Configure Postfix

```ini title="/etc/postfix/main.cf"
# e.g. [smtpdm.aliyun.com]:465
relayhost = [<smtp-server>]:<smtp-port>
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
smtp_tls_wrappermode = yes
smtp_tls_security_level = encrypt
# e.g. webserver1.rectitude.cc
myhostname = <server-hostname.domain.com>
# e.g. noreply.rectitude.cc
myorigin = <sender-domain>
sender_canonical_maps = hash:/etc/postfix/sender_canonical
```

### Configure SMTP Authentication

```bash title="/etc/postfix/sasl_passwd"
# e.g. [smtpdm.aliyun.com]:465 server@noreply.rectitude.cc:password
[<smtp-server>]:<smtp-port> <user@sender-domain>:<password>
```

### Configure Sender Canonical

```bash title="/etc/postfix/sender_canonical"
# e.g. root@noreply.rectitude.cc server@noreply.rectitude.cc
root@<sender-domain> <user@sender-domain>
```

### Secure Files and Map Configurations

```bash
chmod 600 /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sender_canonical
postmap /etc/postfix/sasl_passwd
postmap /etc/postfix/sender_canonical
systemctl restart postfix
```

### Install S-nail

```bash
dnf install s-nail
```

### Configure S-nail

```bash title="~/.mailrc"
# e.g. set from="WebServer1 <server@noreply.rectitude.cc>"
set from="WebServer1 <<user@sender-domain>>"
```

### Send a Test Email

```bash
echo "Test Email Body" | s-nail -s "Test Subject" admin@rectitude.cc
```

### Useful Commands

```bash
# View mail logs
tail -f /var/log/maillog
# View emails in the queue
postqueue -p
# Retry immediately
postfix flush
# Delete email
postsuper -d <queue ID>
# Clear all
postsuper -d ALL
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="postfix-s-nail.yml" file=../playbooks/postfix-s-nail.yml

```

  </TabItem>
</Tabs>
