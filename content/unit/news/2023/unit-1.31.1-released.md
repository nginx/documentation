---
title: Unit 1.31.1 Released
weight: 100
---

We are delighted to announce Unit 1.31.1, a maintenance release that fixes
several bugs, enhances the WebAssembly technology preview, and updates tools
and packaging.

## WebAssembly Technology Preview Enhancements

After a very successful launch of our WebAssembly integration in
{doc}`1.31.0 <unit-1.31.0-released>`
[1.31.0]({{< relref "/unit/news/2023/unit-1.31.0-released.md" >}}),
,
we have made some minor improvements.With the `unit-wasm` SDK,
you can now explicitly set the HTTP return code of a given request.
Also, requests with payloads larger than 4 GB are now handled properly.

For more information, see the `unit-wasm` SDK
[documentation](https://github.com/nginx/unit-wasm).

## Updates to the Unit CLI Tool `unitc`

The
[unitc](https://github.com/nginx/unit/tree/master/tools)
command line tool is now able to convert Unit configuration
between JSON and YAML formats.
It also supports a new URI scheme `docker://`
to make it even easier to work with Unit running in a container.

## Full Changelog

```none
Changes with Unit 1.31.1                                         19 Oct 2023

    *) Feature: allow to set the HTTP response status in Wasm module.

    *) Feature: allow uploads larger than 4GiB in Wasm module.

    *) Bugfix: application process could crash while rewriting URLs with
       query strings.

    *) Bugfix: requests larger than about 64MiB could cause error in Wasm
       module.

    *) Bugfix: when using many headers in Java module some of them could be
       corrupted due to memory realocation issue.

    *) Bugfix: ServerRequest.destroy() implemented in Node.js module to make
       it compatible with some frameworks that might use it.

    *) Bugfix: chunk argument of ServerResponse.write() can now be a
       Uint8Array to improve compatibility with Node.js 15.0.0 and above.

    *) Bugfix: Node.JS unit-http NPM module now has appropriate default
       paths for macOS/arm64 systems.

    *) Bugfix: build on musl libc with clang.
```

For a full list of changes and bugfixes,
please see the [changelog]({{< relref "/unit/CHANGES.md" >}}).
