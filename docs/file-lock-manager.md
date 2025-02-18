---
title: File Lock Manager
description: File Lock Manager
slug: /file-lock-manager
sidebar_position: 9
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="linux" label="🐧 Linux Command Line">

### Create File Lock Manager Script

```bash title="/usr/local/file-lock-manager/file-lock-manager.sh" file=../scripts/file-lock-manager.sh

```

### Useful Commands

```bash
# Lock file/directory
chattr +i /path/to/file_or_dir

# Unlock file/directory
chattr -i /path/to/file_or_dir

# Lock all files/directories in a directory
find /path/to/dir -mindepth 1 -exec chattr +i {} \;

# View file/directory attributes
lsattr /path/to/file_or_dir
```

  </TabItem>
</Tabs>
