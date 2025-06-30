---
nd-docs: "DOCS-1598"
---

The supported Protocol Buffer version is 3 i.e. only proto3 is supported. Version 2 is not supported. Hence any obsolete feature of version 2, such as message extensions in the IDL files, will be rejected. IDL files that have the `syntax = "proto2";` statement is also rejected.