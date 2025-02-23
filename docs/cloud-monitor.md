---
title: Cloud Monitor
description: Cloud Monitor.
slug: /cloud-monitor
sidebar_position: 21
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

使用云服务商免费的监控和安全服务，检测服务器资源和安全情况，在 CPU、内存、磁盘、网络异常时发送警报，并提供适当的漏洞扫描和报警。

<Tabs className="type-tabs" groupId="type" queryString>
  <TabItem value="aliyun" label="Aliyun">
    **云监控免费版**
    
    - 网址：https://cloudmonitornext.console.aliyun.com/hostMonitor/
    - 免费功能：
      - 支持添加非阿里云服务器（云外主机）。
      - 支持CPU、内存、负载、磁盘、网络（流入/流出/TCP数）监控，自定义报警规则。

    **云安全中心（云盾）免费版**
    - 网址：https://yundun.console.aliyun.com/。
    - 免费功能：
      - 支持添加非阿里云服务器（非阿里云主机）。
      - 支持漏洞扫描（仅检测不修复）、应急漏洞扫描（需手动触发）、非常用地登录报警、AccessKey泄露，ISO 27001 / 等保合规检查。

  </TabItem>
</Tabs>
