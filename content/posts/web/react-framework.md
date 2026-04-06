---
title: React Framework
subtitle:
date: 2026-03-29T21:40:11+08:00
slug: cc3a880
# draft: true
# author:
#   name:
#   link:
#   email:
#   avatar:
description:
keywords:
comment: false
weight: 0
tags:
  - Web
  - Frontend
  - React
categories:
  - Web
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
summary:
featuredImagePreview:
featuredImage:
password:
message:
repost:
  enable: false
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

React 19.2

开心就是效率

<!--more-->

## Tools

- Editor: **VS Code** (with the extensions lised below)
  - Prettier
  - Live Server
- Browser: **Google Chrome** / **Mozilla Firefox**
- Runtime environment: **NodeJS**
- Package manager: **npm** / **pnpm**

Install [nodejs](https://nodejs.org/) and [npm](https://www.npmjs.com/): https://nodejs.org/en/download

{{< admonition warning >}}
`nvm` 是 bash 脚本，不支持 fish
{{< /admonition >}}

And install [pnpm](https://pnpm.io/):

```sh
$ npm install -g pnpm@latest-10
```

## Process

1. Using [vite](https://vite.dev/) to create a project:

```sh
$ npm create vite@latest
```

2. Install dependencies in project:

```sh
$ npm install   # Or: npm i
# If using pnpm
$ pnpm install  # Or: pnpm i
```

3. Start the project in local server (see other commands in "scripts" part of project's package.json):

```sh
$ npm run dev
# If using pnpm
$ pnpm run dev  # Or: pnpm dev
```

## References

- [HDAlex_John](https://github.com/13RTK/): [React 教程](https://space.bilibili.com/337242418/lists/2492547)
- https://react.dev/
- https://nodejs.org/
- https://www.npmjs.com/
- https://pnpm.io/
- https://vite.dev/
- https://en.wikipedia.org/wiki/JavaScript_XML
- Medium: [React CDN: Getting started](https://blog.stackademic.com/react-cdn-first-choice-for-building-simple-web-app-9feb62198b5c)
