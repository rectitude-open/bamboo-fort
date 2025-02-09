import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import path from 'path';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'BambooFort Collective',
  tagline:
    'A security implementation guide for web servers in low-resource environments.',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://bamboo-fort.rectitude.cc',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'rectitude-open', // Usually your GitHub org/user name.
  projectName: 'bamboo-fort', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: 'https://github.com/rectitude-open/bamboo-fort/',
          remarkPlugins: [[require('remark-code-snippets'), { sync: true }]],
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: 'img/social-card.png',
    navbar: {
      title: 'BambooFort Collective',
      logo: {
        alt: 'BambooFort Collective Logo',
        src: 'img/logo.png',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Documentation',
        },
        // {
        //   href: '#',
        //   position: 'left',
        //   label: 'Course',
        // },
        {
          href: 'https://github.com/rectitude-open/bamboo-fort',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      copyright: `Built with 🦖 <a href="https://docusaurus.io/" target="_blank">Docusaurus</a>.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: [
        'bash',
        'vim',
        'ini',
        'apacheconf',
        'diff',
        'systemd',
        'nginx',
        'perl',
      ],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
