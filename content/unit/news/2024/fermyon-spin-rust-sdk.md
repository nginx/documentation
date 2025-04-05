---
title: "Wasm Components: Working with the Spin SDK for Rust"
weight: 500
---

In our blog series [Part 1]({{< relref "/unit/news/2024/wasm-component-model-part-1.md" >}}) and [Part 2]({{< relref "/unit/news/2024/wasm-component-model-part-2.md" >}}) , we have covered the core mechanism of the WebAssembly Component Model and showcased how to create a Wasm Component using WASI 0.2 APIs and the **wasi/http:proxy** world.

In this blog post, we will have a look at the [Fermyon's Spin](https://www.fermyon.com/spin) SDK for [Rust](https://fermyon.github.io/rust-docs/spin/main/spin_sdk/index.html) and create a Wasm Component that can be hosted on NGINX Unit.

The Spin SDKs provide a great developer experience, as they wrap a lot of the manual work in easy to consume APIs. In this blog post we will focus on Rust, but if you would like to learn more about the other language SDKs, please see the official [documentation](https://developer.fermyon.com/spin/v2/language-support-overview).

Let's start by creating a new Rust library using **cargo new**. This will create a new library project in a sub-directory **test-spin-component** of our current work directory.

```bash
$ cargo new --lib test-spin-component
$ cd test-spin-component
```

Add the latest version of the "spin-sdk" and "anyhow" (Flexible Error Types and a dependency of the Spin SDK) crates to the project by running the following command:

```bash
$ cargo add spin-sdk anyhow
```

Before we implement the actual functionality, we must modify our **Cargo.toml** file. Open the **Cargo.toml** with an editor of your choice and append the following to the bottom of your existing **Cargo.toml** file.

```toml
[lib]
crate-type = ["cdylib"]

[package.metadata.component]
package = "component:test-component"
proxy = true

[package.metadata.component.dependencies]
```

Next, replace the content of **src/lib.rs** file with the following code:

```rust
use spin_sdk::http::{IntoResponse, Request, Response};
use spin_sdk::http_component;

#[http_component]
fn handle_hello_world(_req: Request) -> anyhow::Result<impl IntoResponse> {
    let body_string = String::from("Hello, this is a Wasm Component using Spin SDK");

    Ok(Response::builder()
        .status(200)
        .header("Content-Type", "text/plain")
        .header("Content-Lenght", body_string.len().to_string())
        .body(body_string)
        .build())
}
```

Compile the Rust Library into a Wasm Component using **cargo component**:

```bash
$ cargo component build --release
```

To run the Wasm Component on NGINX Unit, start up Unit and use this initial configuration.

{{< note >}}
Make sure you point to the Wasm component by using an absolute path.
{{< /note >}}

```json
{
    "listeners": {
        "127.0.0.1:8085": {
        "pass": "applications/my-spin-component"
        }
    },
    "applications": {
        "my-spin-component": {
        "type": "wasm-wasi-component",
        "component": "target/wasm32-wasi/release/test_spin_component.wasm"
        }
    }
}
```

As the Wasm Component we have just created uses the request and response interfaces defined by the **wasi:http/proxy**, it can easily be deployed on NGINX Unit.
