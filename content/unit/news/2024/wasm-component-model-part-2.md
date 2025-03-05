---
title: The WebAssembly Component Model - Part 2
weight: 600
---

This is Part 2 of our blog series about the Wasm Component Model, it's ecosytem and how to use Wasm Components with NGINX Unit.
In [Part 1](/news/2024/wasm-component-model-part-1) we have covered all the conceptional parts. In this part, we will focus on the process of creating a Wasm Component.

## Tutorial - A Rust based Wasm Component

Rust is the premier language for WebAssembly development and the most mature in terms of support. In the example, we will use Rust and its ecosystem to create a Wasm Component that can be hosted directly on NGINX Unit.

This tutorial targets Linux-based operating systems and MacOS. If you are on Windows, we recommend using WSL2 (Windows Subsystem for Linux) to follow along. If you haven't already installed NGINX Unit alongside the WebAssembly language module, please refer to the [docs](https://docs.nginx.com/nginx-unit/installation/#official-packages) on how to do it or use the official [Docker Image](https://docs.nginx.com/nginx-unit/installation/#docker-images) **unit:wasm**.

### Rust Development Setup

Let's start by installing the Rust ecosystem, if not already done. At the time of writing, Rust 1.76 is the latest stable version.
To install Rust, see the instructions on their [website](https://www.rust-lang.org/tools/install).

After the installation completes, you can confirm the current version of Rust by running:

```bash
$ rustc -V
rustc 1.76.0 (07dca489a 2024-02-04)
```

To work with Wasm Components, we need some additional tooling. This is a one-time setup for you to be able to write Rust source code and compile it to a Wasm Component.

### Add the wasm32-wasi compiler target

The wasm32-wasi compiler target will provide general Wasm support to your rustc installation. Add the target by running:

```bash
$ rustup target add wasm32-wasi
```

### Install cargo-component

**cargo-component** will add a cargo subcommand to build Wasm Components without any intermediate steps from our Rust project.
To install the latest version, run the following command:

```bash
$ cargo install cargo-component
```

### Install wasmtime runtime and CLI for testing

The wasmtime-cli will be used to test and play around with the Wasm component. At the time of writing, we are using Wasmtime 18.
To install the latest version of Wasmtime, run:

```bash
$ curl https://wasmtime.dev/install.sh -sSf | bash
```

For more information about Wasmtime and installing it, see their [GitHub repository](https://github.com/bytecodealliance/wasmtime/)

Once we have all the tools in place, we can create the Rust projects.

<a name="tutorial-rust-based-wasm-component"></a>

### Using the **wasi** Rust library

Our experience with the official WASI Rust library was very interesting and exciting. The component build time was fascinating, and the library has a low dependency footprint. However, there are some costs in terms of developer experience. See for yourselves:

Start by creating a new Wasm Component using **cargo component**:

```bash
$ cargo component new --lib test-wasi-component
```

Navigate into the **test-wasi-component** directory.

Add the **wasi** crate:

```bash
$ cargo add wasi
```

Next, modify the **Cargo.toml** file with the text editor of your choice. Add the **proxy = true** configuration to the **[package.metadata.component]** section. After saving the changes, your **Cargo.toml** file should look like this:

```toml
[package]
name = "test-wasi-component"
version = "0.1.0"
edition = "2021"

[dependencies]
bitflags = "2.4.2"
wit-bindgen-rt = "0.21.0"
wasi = "0.13.0"

[lib]
crate-type = ["cdylib"]

[package.metadata.component]
package = "component:test-wasi-component"
proxy = true

[package.metadata.component.dependencies]
```

The actual code from **src/lib.rs** should look like this:

```rust
use wasi::http::types::{
   Fields, IncomingRequest, OutgoingBody, OutgoingResponse, ResponseOutparam,
};

wasi::http::proxy::export!(Component);

struct Component;

impl wasi::exports::http::incoming_handler::Guest for Component {
   fn handle(_request: IncomingRequest, response_out: ResponseOutparam) {

      let hdrs = Fields::new();
      let mesg = String::from("Hello, This is a Wasm Component using wasi/http:proxy!");
      let _try = hdrs.set(&"Content-Type".to_string(), &[b"plain/text".to_vec()]);
      let _try = hdrs.set(&"Content-Length".to_string(), &[mesg.len().to_string().as_bytes().to_vec()]);

      let resp = OutgoingResponse::new(hdrs);

      // Add the HTTP Response Status Code
      resp.set_status_code(200).unwrap();

      let body = resp.body().unwrap();
      ResponseOutparam::set(response_out, Ok(resp));

      let out = body.write().unwrap();
      out.blocking_write_and_flush(mesg.as_bytes()).unwrap();
      drop(out);

      OutgoingBody::finish(body, None).unwrap();
   }
}
```

Targeting the wasi crate requires some low-level Rust work by us. Not bad at all, but something to consider when choosing this option. For the **wasi:http/proxy** world there is an interface description available on [GitHub](https://github.com/WebAssembly/wasi-http/blob/main/proxy.md) which will help to write your code.

Let's build the component. Run the following command from the **test-wasi-component** directory:

```bash
$ cargo component build --release
```

The build shows a very small dependency footprint, so is a major benefit from the wasi crate.

To test the Component, we can use wasmtime serve.

```bash
$ wasmtime serve target/wasm32-wasi/release/test_wasi_component.wasm
```

The output should look like the following:

```bash
$ wasmtime serve target/wasm32-wasi/release/test_wasi_component.wasm
  Serving HTTP on http://0.0.0.0:8080/
```

Sending a request to the exposed endpoint will output something like this:

```bash
$ curl -v localhost:8080
…
> GET / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/8.4.0
> Accept: */*
>
< HTTP/1.1 200 OK
< content-type: plain/text
< content-length: 54
< date: Tue, 12 Mar 2024 12:28:56 GMT
<
* Connection #0 to host localhost left intact
Hello, This is a Wasm Component using wasi/http:proxy!
```

## NGINX Unit for production grade Wasm workloads

While the **wasmtime-cli** interface is good for testing Wasm components locally, there are more requirements for production workloads.

With NGINX Units Wasm runtime, you will be able to run your Wasm workloads next to other host applications on a single host and make use of all the other powerful Unit features. Given Units design and as we have decoupled the listeners from the application runtime, you can make full use of the Unit Router to make routing decisions before sharing a request with your Wasm Component or add HTTPS to your stack.

To run the component on NGINX Unit, start Unit, and send the initial configuration, make sure you point to the Wasm component by using an absolute path.

Create a **config.json** file:

```json
{
   "listeners": {
      "127.0.0.1:8085": {
         "pass": "applications/my-wasm-component"
      }
   },
   "applications": {
      "my-wasm-component": {
         "type": "wasm-wasi-component",
         "component": "path/target/wasm32-wasi/release/test_wasi_component.wasm"
      }
   }
}
```

Apply the configuration using **unitc**:

```bash
$ unitc config.json /config
```

Sending a request to the exposed endpoint will create the same output from a different runtime implementation:

```bash
$ curl -v localhost:8085
…
< HTTP/1.1 200 OK
< content-type: plain/text
< content-length: 54
< Server: Unit/1.32.0
< Date: Tue, 12 Mar 2024 15:16:13 GMT
<
* Connection #0 to host localhost left intact
Hello, This is a Wasm Component using wasi/http:proxy!
```

This is the full power of Wasm Components. Build once - run on every runtime.

## What's next?

The Wasm ecosystem and all its associated projects are undergoing rapid and positive changes. Every week brings new features and opportunities for innovation. NGINX Unit remains dedicated to Wasm and will continue implementing new features in our Wasmtime integration and publishing technical blog posts about Wasm.

Feel free to share your feedback about this blog post on our [GitHub discussions](https://github.com/nginx/unit/discussions) page. We'd love to know what you think is missing regarding the work with Wasm Components.
