# Overview

This folder contains source files for [NGINX.org](https://nginx.org), a [Hugo](https://gohugo.io/content-management/page-bundles/#about) site
built atop the [nginx-hugo-theme](https://github.com/nginxinc/nginx-hugo-theme/tree/main).

## Styling Utilities

This project utilizes Tailwind styling utilities for convenience in development. 

* Production builds only contain CSS for utilities actually in-use within the project
* Development builds do no treeshaking and include the entirety of the tailwind utility bundle

## Dependencies

* Tailwind v4 CLI in `PATH` ([Brew](https://formulae.brew.sh/formula/tailwindcss))

## Hot Reloading Development Environment

```sh
hugo server
```