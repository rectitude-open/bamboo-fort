---
title: System Hardening
description: System hardening is the process of securing a system by reducing its surface of vulnerability.
slug: /system-hardening
sidebar_position: 12
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>

<TabItem value="linux" label="🐧 Linux Command Line">

## Core

### SSH

ATTENTION: Make sure ssh port is open in the firewall before applying these changes.

ATTENTION: Make sure you have another user with sudo privileges before disabling root login.

```bash title="/etc/ssh/sshd_config"
Port <ssh-port>
Protocol 2
MaxAuthTries 3
X11Forwarding no
AllowAgentForwarding no
LogLevel VERBOSE
MaxSessions 2
PermitRootLogin no
```

Restart the SSH service to apply the changes.

```bash
systemctl restart sshd
```

### File Permissions

```bash
chmod 700 /usr/bin/gcc
chmod 700 /usr/bin/g++
chmod 700 /usr/bin/make
chmod 700 /usr/bin/as
chmod 700 /usr/bin/ld
chmod 700 /usr/bin/cc
chmod 640 /etc/at.deny
chmod 640 /etc/cron.deny
chmod 600 /etc/crontab
chmod 700 /etc/cron.d
chmod 700 /etc/cron.daily
chmod 700 /etc/cron.hourly
chmod 700 /etc/cron.weekly
chmod 700 /etc/cron.monthly

rm -rf /etc/at.deny
touch /etc/at.allow
chown root:root /etc/at.allow
chmod 600 /etc/at.allow

rm -rf /etc/cron.deny
touch /etc/cron.allow
chown root:root /etc/cron.allow
chmod 600 /etc/cron.allow
```

### Kernel Hardening

```ini title="/etc/sysctl.conf"
vm.swappiness=1
net.ipv4.ip_forward=0
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.tcp_syncookies=1
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
dev.tty.ldisc_autoload = 0
fs.protected_fifos = 2
fs.protected_regular = 2
fs.suid_dumpable = 0
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.sysrq = 0
kernel.unprivileged_bpf_disabled = 1
kernel.yama.ptrace_scope = 2
net.core.bpf_jit_harden = 2
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.log_martians = 1
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
```

Apply the changes.

```bash
sysctl -p
```

### Disable core dumps

```bash title="/etc/security/limits.conf"
* hard core 0
```

### Set UMASK to restrict permissions

```bash title="/etc/login.defs"
UMASK 027
```

### Maps loopback address to hostname

```bash title="/etc/hosts"
127.0.1.1   <hostname> <FQDN>
# e.g.: 127.0.1.1   webserver1 webserver1.rectitude.cc
```

### Prevent unnecessary kernel modules

```bash title="/etc/modprobe.d/blacklist.conf"
blacklist usb-storage
options usb-storage modeset=0
install usb-storage /bin/true

blacklist firewire-core
options firewire-core modeset=0
install firewire-core /bin/true

blacklist dccp
options dccp modeset=0
install dccp /bin/true

blacklist sctp
options sctp modeset=0
install sctp /bin/true

blacklist rds
options rds modeset=0
install rds /bin/true

blacklist tipc
options tipc modeset=0
install tipc /bin/true
```

Apply the changes.

```bash
dracut -f
```

### Add Linux Audit Rules

```bash title="/etc/audit/rules.d/audit.rules"
-a always,exit -F arch=b64 -F euid=0 -S execve -k root_audit
-a always,exit -F arch=b64 -F path=/etc/passwd -F perm=wa -k passwd_changes
-a always,exit -F arch=b64 -F path=/etc/shadow -F perm=wa -k shadow_changes
-a always,exit -F arch=b64 -F path=/etc/group -F perm=wa -k group_changes
-a always,exit -F arch=b64 -F path=/etc/gshadow -F perm=wa -k gshadow_changes

-a always,exit -F arch=b64 -F path=/var/log/secure -F perm=wa -k secure_logs

-a always,exit -F arch=b64 -F path=/usr/sbin/useradd -F perm=x -k user_management
-a always,exit -F arch=b64 -F path=/usr/sbin/usermod -F perm=x -k user_management
-a always,exit -F arch=b64 -F path=/usr/sbin/userdel -F perm=x -k user_management
-a always,exit -F arch=b64 -F path=/usr/sbin/groupadd -F perm=x -k group_management
-a always,exit -F arch=b64 -F path=/usr/sbin/groupmod -F perm=x -k group_management
-a always,exit -F arch=b64 -F path=/usr/sbin/groupdel -F perm=x -k group_management
```

```bash
# Load the new rules
auditctl -R /etc/audit/rules.d/audit.rules
# List the loaded rules
auditctl -l
# Query the audit logs
ausearch -k root_audit
# Query the audit logs: ausearch -k user_management -i | grep usermod
```

### Stronger hashing for authentication

```bash
# view the current profile
authselect current
# create a custom profile based on the sssd profile
authselect create-profile custom-sssd --base-on=sssd
```

```bash title="/etc/authselect/custom/custom-sssd/system-auth"
password    sufficient    pam_unix.so sha512 shadow {if not "without-nullok":nullok} use_authtok rounds=50000
```

```bash
authselect select custom/custom-sssd
# change the current password to apply the new hashing
passwd
```

## Optional

### Disable promiscuous mode

Promiscuous mode allows a network device to intercept and read each network packet that arrives in its entirety. Disabling it helps prevent unauthorized network traffic monitoring.

```ini title="/etc/sysconfig/network-scripts/ifcfg-eth0"
PROMISC=no
```

## Extended

### Explanations of SSH Configuration Options

```bash
# Use a more secure SSH protocol
Protocol 2
# Disconnect clients after a set number of incorrect password attempts
MaxAuthTries 3
# Disable X11 forwarding to reduce the attack surface if GUI features are not needed
X11Forwarding no
# Disallow SSH agent forwarding to remote hosts, which may restrict some automated operations
AllowAgentForwarding no
# Record more detailed login activities
LogLevel VERBOSE
# Limit the number of simultaneous sessions per SSH connection
MaxSessions 2
# Prohibit root user login
PermitRootLogin no
# Disallow accounts with empty passwords from logging in
PermitEmptyPasswords no
# Change the default SSH port
Port 22222
```

### Other Useful SSH Configuration Options

```bash
# Disable TCP forwarding, preventing remote access to databases and internal services
AllowTcpForwarding no
# Disable password authentication
PasswordAuthentication no
```

### Tenable audit policies

https://www.tenable.com/audits

</TabItem>

<TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="system-hardening.yml" file=../playbooks/system-hardening.yml

```

</TabItem>

</Tabs>
