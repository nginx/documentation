---
title: The WebAssembly Component Model - Part 1
weight: 500
---

Are you interested in getting started with the WebAssembly Component Model but feel overwhelmed by the ecosystem and unsure where to begin? If so, this blog post is for you!

In this post, we'll share some of the lessons we learned and the "aha" moments we experienced while adding support for the WebAssembly Component Model to NGINX Unit, thanks to the assistance of the robust and active community.

If you're already familiar with the Wasm ecosystem or just would like to get started with code, feel free to jump directly to [Part 2](/news/2024/wasm-component-model-part-2) of this blog series.

## The WebAssembly Component Model and NGINX Unit

A lot has happened since we shipped the first version of our Wasm Language Module for Unit.
Back in September 2023 we said:

> We introduce WebAssembly support as a Technology Preview - we expect to replace it with WASI-HTTP support as soon as that is possible.

We have done just that with Unit 1.32.0. This release supports Wasm Components using the WASI 0.2 APIs and the wasi:http/proxy world as its main interface.

Let's pause here for a moment. If the previous sentence contained unfamiliar vocabulary, don't worry. This blog post will explain the concept of the Component Model for WebAssembly (Wasm) and the role that the WebAssembly System Interface (WASI) plays in this context. We will also discuss the significance of the "WebAssembly Interface Types."

As you can read in our first [Wasm blog post](https://www.nginx.com/blog/server-side-webassembly-nginx-unit/), the Wasm runtime shares data with the Wasm Module as raw bytes over shared memory. To make sense of this byte stream, the Host as well as the Wasm Module must speak about the same things or technically speaking, implementing the same interfaces. It is a core concept of NGINX Unit to create an application-specific context of an incoming HTTP request and share this set of bytes in memory with the runtime.

This is exactly what we did with **unit-wasm** and it was an interesting and necessary learning to add Wasm support to Unit. However, this is far away from implementing or using a standard. This is where the Wasm Component Model comes into play.

The WebAssembly (Wasm) Component Model outlines how different Wasm modules, or components, can communicate with each other and the runtime environment. It establishes specific contracts that must be met to ensure that code compiled into a Wasm component can be hosted on a compatible runtime and seamlessly exchange data with other Wasm components during runtime.

To provide a practical illustration of this theoretical framework, we can examine the implementation found in NGINX Unit, which serves as a textbook example of the Wasm Component Model in action.

The two essential parts of the Wasm Component Model are the WebAssembly System Interface (WASI) and WebAssembly Interface Types (WIT).
Let's have a closer look on the two standards.

## WASI and WIT

WASI is short for "WebAssembly System Interface" and was introduced by the Wasmtime project and was designed from the ground up for Wasm. WASI is a portable system interface for Wasm that provides access to several operating system-like features, including files and the file system, sockets, clocks, random numbers, and more. But why is that necessary?

As we are creating Wasm components for server-side runtimes, we cannot target browser-based Wasm runtimes anymore where Web APIs or JavaScript is used to provide this functionality. Code that is outside the browser needs a way to talk to the underlaying system. To better understand where WASI comes into play, we develop a very simple program, written in Rust that will print out "Hello World".

The code we write can be compiled into an executable binary file. After launching it, we will see "Hello World" printed on the command line. The magic behind this is a standard called POSIX, which defines system calls. System calls work differently on different operating systems.

WASI provides an abstraction layer for those syscalls, that can be targeted from the code that will be compiled to Wasm.
A WASI compatible runtime will be able to handle the execution of that code. We see this in action in our [Rust tutorial](/news/2024/wasm-component-model-part-2) further in part 2 of this blog series. Since Preview2 of the WASI proposal - [the WASI-APIs are defined in WIT-files](https://bytecodealliance.org/articles/webassembly-the-updated-roadmap-for-developers#webassembly-system-interface-wasi).

WIT (Wasm Interface Types) is a descriptive [interface description language (IDL)](<https://en.wikipedia.org/wiki/IDL_(programming_language)>) used to define interfaces. It isn't a general-purpose coding language. The written WIT files don't contain any business logic; they are pure definitions of contracts. Multiple interfaces can be further combined into worlds. While it is not required to deeply understand the way you can create your own WIT-files, it will help to track down issues or trouble-shoot them while building components. To learn more about the WIT programming language, see the official [documentation.](https://component-model.bytecodealliance.org/design/wit.html#structure-of-a-wit-file)

The WIT files used by the Wasm Component Model and the **wasi:http/proxy** world in specific, are created and maintained by the Bytecode Alliance. At the time of writing this blog post, the best way to make use of them are the Wasmtime project's GitHub repository and a manual pull.

One of the interesting facts about WIT-files is the versioning system. As the host implementing the Wasm runtime as well as the component we are about to build are creating bindings for the contracts defined by the WIT files, it is important to target the same version of those contracts or choose a runtime that supports multiple versions of those WIT files. But this is worth another blog post. For now, we should focus on the latest stable release, which it was published in February 2024 and is labeled as WASI 0.2.
This release included **wasi:cli** and the **wasi:http** worlds.

In the WebAssembly ecosystem, these contracts are referred to as "worlds." Therefore, we will use that term from now on. For the use cases of NGINX Unit, it was pretty clear we will be targeting the **wasi:http/proxy** world. You can think of the **wasi:http/proxy** world as the set of interfaces describing how a HTTP request and response will look like, including all its data (HTTP Method, Headers, Body, and more). If you are an old-school web developer, this might remind you of CGI.

## NGINX Unit, Wasmtime and Rust - A runtime implementation

After a brief investigation, we discovered that the WASI/WIT pair we'd already heard of plays a vital role in supporting the Component Model. As the host, Unit must implement the WASI HTTP proxy interfaces defined by WIT files to fulfill the contract. This isn't new information; we were already aware of this fact. Since we're using Wasmtime as the Wasm runtime, we could delegate this task to the runtime, right? Indeed, we could! However, there was a small but significant detail: our implementation at the time was written entirely in C using the Wasmtime C-APIs. Unfortunately, these APIs lack the necessary functions to support the Component Model.

As mentioned at the beginning of this article, any challenge, regardless of its complexity, can be solved when the right people and community share the same mindset.
Fermyon has been, and continues to be, a valuable and significant partner for us. After a late-night Slack and Zoom Session, we found it too complex to add native support for the Component Model to the Wasmtime C-API. Additionally, implementing the interfaces manually with WIT files without help from automation tools like **bindgen** would result in a significant amount of ongoing upkeep work.

While explaining how the internals of NGINX Unit and the current C-based Language Module work to Fermyon, they shared a prototype of a Rust-based Unit Language Module targeting the Rust API of Wasmtime. Not the C-API anymore.

Now we are equipped with the necessary knowledge to write some code.

## What's next?

In the next part we will covering the process of creating a Wasm Component using Rust and the WASI 0.2 APIs.

[Part 2]({{< relref "/unit/news/2024/wasm-component-model-part-2.md" >}})
