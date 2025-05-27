---
title: Unit 1.32.1 Released
weight: 300
---

NGINX Unit 1.32.1 is a maintenance release that fixes bugs in the new WebAssembly Language Module and in our njs implementation.

## Resolved issues

This release fixes the following issues:

### Applications of type `wasm-wasi-component` can't be restarted

Applications deployed as `wasm-wasi-components` can't be restarted using the `restart` endpoint.

After deploying a new Wasm Component binary to disk, the restart will trigger a reload of the component in Unit without restarting the server.

As restarts will work independently of the application type, the behavior shipped with **1.32.0** was not right. It has been fixed in this release.

### Unit-variables in NGINX JavaScript are constantly cached

In **1.32.0** we added the possibility to access all Unit variables form inside njs.

As reported in GitHub issue [#1169](https://github.com/nginx/unit/issues/1169) the variables were cached and would hold the wrong value, which is not how this feature should work. With version 1.32.1, we have fixed this issue.

## Full Changelog

```none
Changes with Unit 1.32.1                                         26 Mar 2024

    *) Bugfix: NJS variables in templates may have incorrect values due to
       improper caching.

    *) Bugfix: Wasm application process hangs after receiving restart signal
       from the control.
```

For a full list of changes and bugfixes,
please see the [changelog]({{< relref "/unit/changes.md" >}}.
