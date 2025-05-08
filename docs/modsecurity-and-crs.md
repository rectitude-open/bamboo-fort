---
title: ModSecurity and CRS
description: ModSecurity and OWASP Core Rule Set (CRS) installation and configuration.
slug: /modsecurity-and-crs
sidebar_position: 2
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

## Core

### Install ModSecurity

https://github.com/owasp-modsecurity/ModSecurity/wiki/Compilation-recipes-for-v3.x

```bash wordWrap=true title="Install dependencies"
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf install -y git gcc-c++ automake flex bison yajl yajl-devel curl curl-devel GeoIP GeoIP-devel zlib-devel pcre-devel pcre2-devel ssdeep ssdeep-devel autoconf automake libtool
```

```bash title="Clone and install ModSecurity"
cd /usr/local/
git clone https://github.com/SpiderLabs/ModSecurity
cd ModSecurity
./build.sh

git submodule init
git submodule update
./configure
make && make install
```

```bash title="Install ModSecurity-nginx"
cd /usr/local/
git clone https://github.com/owasp-modsecurity/ModSecurity-nginx
```

### Install OWASP Core Rule Set (CRS)

https://coreruleset.org/docs/deployment/extended_install/#downloading-the-owasp-core-rule-set

```bash
git clone https://github.com/coreruleset/coreruleset /usr/local/modsecurity-crs
cd /usr/local/modsecurity-crs
mv crs-setup.conf.example crs-setup.conf
mv rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
mv rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
```

Create ModSecurity configuration file

```bash
mkdir -p /etc/nginx/modsec
cp /usr/local/ModSecurity/unicode.mapping /etc/nginx/modsec
cp /usr/local/ModSecurity/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
```

Enable CRS rules

```diff title="/etc/nginx/modsec/modsecurity.conf"
- SecRuleEngine DetectionOnly
+ SecRuleEngine On
```

Create a ModSecurity configuration for use in Nginx

```apacheconf title="/etc/nginx/modsec/main.conf"
Include /etc/nginx/modsec/modsecurity.conf
Include /usr/local/modsecurity-crs/crs-setup.conf
Include /usr/local/modsecurity-crs/rules/*.conf
```

### Manage ModSecurity

View audit logs

```bash
tail -f /var/log/modsec_audit.log
```

Update CRS rules

```bash
cd /usr/local/modsecurity-crs
git pull
```

## Optional

### Install CRS Plugins

https://coreruleset.org/docs/4-about-plugins/4-1-plugins/

```
mkdir /usr/local/modsecurity-crs/rules/plugins
```

```diff title="/etc/nginx/modsec/main.conf"
Include /etc/nginx/modsec/modsecurity.conf
Include /usr/local/modsecurity-crs/crs-setup.conf
+ Include /usr/local/modsecurity-crs/plugins/*-config.conf
+ Include /usr/local/modsecurity-crs/plugins/*-before.conf
Include /usr/local/modsecurity-crs/rules/*.conf
+ Include /usr/local/modsecurity-crs/plugins/*-after.conf
```

https://github.com/coreruleset/plugin-registry

```bash
cd /usr/local/modsecurity-crs/plugins
wget https://raw.githubusercontent.com/coreruleset/wordpress-rule-exclusions-plugin/refs/heads/master/plugins/wordpress-rule-exclusions-config.conf
wget https://raw.githubusercontent.com/coreruleset/wordpress-rule-exclusions-plugin/refs/heads/master/plugins/wordpress-rule-exclusions-before.conf
wget https://raw.githubusercontent.com/coreruleset/phpmyadmin-rule-exclusions-plugin/refs/heads/master/plugins/phpmyadmin-rule-exclusions-config.conf
wget https://raw.githubusercontent.com/coreruleset/phpmyadmin-rule-exclusions-plugin/refs/heads/master/plugins/phpmyadmin-rule-exclusions-before.conf
wget https://raw.githubusercontent.com/coreruleset/phpmyadmin-rule-exclusions-plugin/refs/heads/master/plugins/phpmyadmin-rule-exclusions-after.conf
```

### Custom CRS rules

https://access.redhat.com/documentation/zh-cn/red_hat_jboss_core_services/2.4.37/html/red_hat_jboss_core_services_modsecurity_guide/rules_making

5 phases for the request cycle

```
Request headers → REQUEST_HEADERS
Request body → REQUEST_BODY
Response headers → RESPONSE_HEADERS
Response body → RESPONSE_BODY
Logging → LOGGING
```

Example:

```
SecRule REQUEST_URI "@beginsWith /sync/hostKey" \
    "id:1000,\
    phase:1,\
    pass,\
    nolog,\
    ctl:ruleEngine=Off"


SecRule REQUEST_URI "@beginsWith /sync/hostKey" \
    "id:1001,\
    phase:1,\
    pass,\
    nolog,\
    ctl:ruleRemoveById=920420"


SecRule REQUEST_URI "@beginsWith /sync/hostKey" \
    "id:1002,\
    phase:1,\
    pass,\
    nolog,\
    setvar:'tx.allowed_request_content_type=|application/x-www-form-urlencoded| |multipart/form-data| |multipart/related| |text/xml| |application/xml| |application/soap+xml| |application/json| |application/cloudevents+json| |application/cloudevents-batch+json|application/octet-stream|'"


SecRule REQUEST_URI "@beginsWith /notifications/hub" \
    "id:1001,\
    phase:1,\
    pass,\
    nolog,\
    ctl:ruleRemoveById=920100"
```

  </TabItem>
  <TabItem value="ansible" label={<><img src="/img/ansible-icon.svg" className="ansible-icon" />Ansible Playbook</>}>

```yml title="modsecurity-and-crs.yml" file=../playbooks/modsecurity-and-crs.yml

```

  </TabItem>
</Tabs>
