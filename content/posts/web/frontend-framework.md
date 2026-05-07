---
title: Frontend Framework
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
- Browser: **Google Chrome** / **Mozilla Firefox** (with the extensions lised below)
  - React Developer Tools
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

## Quick Start

1. Using [vite](https://vite.dev/) to create a project:

```sh
$ npm create vite@latest
# if you use pnpm
$ pnpm create vite@latest
```

2. Install dependencies in project:

```sh
$ npm install   # or use: npm i
# if you use pnpm
$ pnpm install  # or use: pnpm i
```

3. Start the project in local server (see other commands in "scripts" part of project's package.json):

```sh
$ npm run dev
# if you use pnpm
$ pnpm run dev  # or use: pnpm dev
```

## Programming Basics

- Component
- Hooks
- Props
- Children

### React

- [Activity](https://react.dev/reference/react/Activity): `<Activity>` lets you hide and restore the UI and internal state of its children.
- [useState](https://react.dev/reference/react/useState): `useState` is a React Hook that lets you add a state variable to your component.
- [useEffect](https://react.dev/reference/react/useEffect): `useEffect` is a React Hook that lets you synchronize a component with an external system.
- [Reusing Logic with Custom Hooks](https://react.dev/learn/reusing-logic-with-custom-hooks): You might not find these Hooks in React, but you can create your own Hooks for your application’s needs.
- [Passing Props to a Component](https://react.dev/learn/passing-props-to-a-component): React components use _props_ to communicate with each other.

## Ecosystenms

- Router
- Statemanagement
- Typescript

## Third-Party API

- [OpenWeather](https://home.openweathermap.org/): Build with Weather Data

### React

- [SWR](https://swr.vercel.app/): Modern data fetching, built for React

## UI Component Libraries

### React

- [Material UI](https://mui.com/material-ui/): An open-source React component library that implements Google's Material Design.

## Deployment

- [Netlify](https://www.netlify.com/): Push your ideas to the web
- [Cloudflare](https://www.cloudflare.com/): Connect, protect, and build everywhere

## References

- [HDAlex_John](https://github.com/13RTK/): [React 教程](https://space.bilibili.com/337242418/lists/2492547)
- https://react.dev/
- https://en.wikipedia.org/wiki/JavaScript_XML
- Medium: [React CDN: Getting started](https://blog.stackademic.com/react-cdn-first-choice-for-building-simple-web-app-9feb62198b5c)
- [A Front-End Application Folder Structure that Makes Sense](https://fadamakis.com/a-front-end-application-folder-structure-that-makes-sense-ecc0b690968b)
- [Vite](https://vite.dev/): The Build Tool for the Web
  - [Env Variables and Modes](https://vite.dev/guide/env-and-mode)
  - [Import Aliases in Vite](https://vueschool.io/articles/vuejs-tutorials/import-aliases-in-vite/)
- Stack Overflow: [Visual Studio Code Intellisense and Autocomplete - Vite, JSconfig and Aliases - can't figure out the right combination](https://stackoverflow.com/questions/74768372/visual-studio-code-intellisense-and-autocomplete-vite-jsconfig-and-aliases)
