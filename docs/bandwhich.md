---
title: Bandwhich
description: Bandwidth is a CLI utility for monitoring network bandwidth usage in real-time.
slug: /bandwhich
sidebar_position: 15
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Install Bandwhich

```bash
dnf copr enable atim/bandwhich
dnf install bandwhich
```

### Usage

```bash
# Run bandwhich
bandwhich

# Monitor a specific interface
bandwhich -i eth0

# Monitor Remote Host
bandwhich -a

# Monitor cumulative bandwidth usage for remote host
bandwhich -at
```

  </TabItem>
</Tabs>
