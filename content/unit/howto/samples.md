---
title: App samples
toc: true
weight: 800
---


{{< note >}}
These steps assume Unit was already
[installed]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
with the language module for each app.

The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{< /note >}}

## Go {#sample-go}

Let's configure the following basic app, saved as **/www/app.go**:

```go
package main

import (
    "io"
    "net/http"
    "unit.nginx.org/go"
)

func main() {
    http.HandleFunc("/",func (w http.ResponseWriter, r *http.Request) {
        io.WriteString(w, "Hello, Go on Unit!")
    })
    unit.ListenAndServe(":8080", nil)
}
```

First, create a [Go module](https://go.dev/blog/using-go-modules), `go
get` Unit's package, and build your application:

```console
   $ go mod init example.com/app # Your Go module designation
   $ go get unit.nginx.org/go@{{< param "unitversion" >}}
   $ go build -o /www/app /www/app.go
```

Upload the
[app config]({{< relref "/unit/configuration.md#configuration-go" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
  "listeners": {
      "*:8080": {
          "pass": "applications/go"
      }
  },
  "applications": {
      "go": {
          "type": "external",
          "working_directory": "/www/",
          "executable": "/www/app"
      }
  }
  }' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation
```

```console
$ curl http://localhost:8080

    Hello, Go on Unit!
```

Try this sample out with the Dockerfile
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> here](/unit/downloads/Dockerfile.go.txt)
or use a more elaborate app example:

```go
   package main

   import (
       "crypto/sha256";
       "fmt";
       "io";
       "io/ioutil";
       "encoding/json";
       "net/http";
       "strings";
       "unit.nginx.org/go"
   )

   func formatRequest(r *http.Request) string {

       h := make(map[string]string)
       m := make(map[string]string)
       t := make(map[string]interface{})

       m["message"] = "Unit reporting"
       m["agent"] = "NGINX Unit {{< param "unitversion" >}}"

       body, _ := ioutil.ReadAll(r.Body)
       m["body"] = fmt.Sprintf("%s", body)

       m["sha256"] = fmt.Sprintf("%x", sha256.Sum256([]byte(m["body"])))

       data, _ := json.Marshal(m)
       for name, _ := range r.Header {
           h[strings.ToUpper(name)] = r.Header.Get(name)
       }
       _ = json.Unmarshal(data, &t)
       t["headers"] = h

       js, _ := json.MarshalIndent(t, "", "    ")

       return fmt.Sprintf("%s", js)
   }

   func main() {
       http.HandleFunc("/",func (w http.ResponseWriter, r *http.Request) {
           w.Header().Set("Content-Type", "application/json; charset=utf-8")
           io.WriteString(w, formatRequest(r))
       })
       unit.ListenAndServe(":8080", nil)
   }
```

## Java {#sample-java}

Let's configure the following basic app, saved as **/www/index.jsp**:

```jsp
<%@ page language="java" contentType="text/plain" %>
<%= "Hello, JSP on Unit!" %>
```

Upload the
[app config]({{< relref "/unit/configuration.md#configuration-java" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
  "listeners": {
      "*:8080": {
          "pass": "applications/java"
      }
  },
  "applications": {
      "java": {
          "type": "java",
          "webapp": "/www/"
      }
  }
  }' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation
```

```console
$ curl http://localhost:8080

    Hello, JSP on Unit!
```

Try this sample out with the Dockerfile
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> here](/unit/downloads/Dockerfile.java.txt)
or use a more elaborate app example (you'll
need to [download](https://cliftonlabs.github.io/json-simple/) and
[add]({{< relref "/unit/configuration.md#configuration-java" >}}) the
`json-simple` library to your app's **classpath** option):

```jsp
   <%@ page language="java" contentType="application/json; charset=utf-8" %>
   <%@ page import="com.github.cliftonlabs.json_simple.JsonObject" %>
   <%@ page import="com.github.cliftonlabs.json_simple.Jsoner" %>
   <%@ page import="java.io.BufferedReader" %>
   <%@ page import="java.math.BigInteger" %>
   <%@ page import="java.nio.charset.StandardCharsets" %>
   <%@ page import="java.security.MessageDigest" %>
   <%@ page import="java.util.Enumeration" %>
   <%
   JsonObject r = new JsonObject();

   r.put("message", "Unit reporting");
   r.put("agent", "NGINX Unit {{< param "unitversion" >}}");

   JsonObject headers = new JsonObject();
   Enumeration h = request.getHeaderNames();
   while (h.hasMoreElements()) {
       String name = (String)h.nextElement();
       headers.put(name, request.getHeader(name));
   }
   r.put("headers", headers);

   BufferedReader  br = request.getReader();
   String          body = "";
   String          line = br.readLine();
   while (line != null) {
       body += line;
       line = br.readLine();
   }
   r.put("body", body);

   MessageDigest   md = MessageDigest.getInstance("SHA-256");
   byte[]          bytes = md.digest(body.getBytes(StandardCharsets.UTF_8));
   BigInteger      number = new BigInteger(1, bytes);
   StringBuilder   hex = new StringBuilder(number.toString(16));
   r.put("sha256", hex.toString());

   out.println(Jsoner.prettyPrint((Jsoner.serialize(r))));
   %>
```

## Node.js {#sample-nodejs}

Let's configure the following basic app, saved as **/www/app.js**:

```javascript
#!/usr/bin/env node

require("unit-http").createServer(function (req, res) {
    res.writeHead(200, {"Content-Type": "text/plain"});
    res.end("Hello, Node.js on Unit!")
}).listen()
```

It's important to use unit-http instead of the regular http module.

Make it executable and link the Node.js language package you've
[installed]({{< relref "/unit/installation.md#installation-nodejs-package" >}})

```console
$ cd /www
```

```console
$ chmod +x app.js
```

```console
$ npm link unit-http
```

Upload the [app config]({{< relref "/unit/configuration.md#configuration-nodejs" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
  "listeners": {
      "*:8080": {
          "pass": "applications/node"
      }
  },
  "applications": {
      "node": {
          "type": "external",
          "working_directory": "/www/",
          "executable": "app.js"
      }
  }
  }' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation
```

```console
$ curl http://localhost:8080

    Hello, Node.js on Unit!
```

Try this sample out with the Dockerfile
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> here](/unit/downloads/Dockerfile.nodejs.txt)
or use a more elaborate app example:

```javascript
   #!/usr/bin/env node

   const cr = require("crypto")
   const bd = require("body")
   require("unit-http").createServer(function (req, res) {
       bd (req, res, function (err, body) {
           res.writeHead(200, {"Content-Type": "application/json; charset=utf-8"})

           var r = {
               "agent":    "NGINX Unit {{< param "unitversion" >}}",
               "message":  "Unit reporting"
           }

           r["headers"] = req.headers
           r["body"] = body
           r["sha256"] = cr.createHash("sha256").update(r["body"]).digest("hex")

           res.end(JSON.stringify(r, null, "    ").toString("utf8"))
       })
   }).listen()
```

{{< note >}}
You can run a version of the same app
[without]({{< relref "/unit/configuration.md#configuration-nodejs-loader" >}})
requiring the **unit-http** module explicitly.
{{< /note >}}

## Perl {#sample-perl}

Let's configure the following basic app, saved as **/www/app.psgi**:

```perl
my $app = sub {
    return [
        "200",
        [ "Content-Type" => "text/plain" ],
        [ "Hello, Perl on Unit!" ],
    ];
};
```

Upload the
[app config]({{< relref "/unit/configuration.md#configuration-perl" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
  "listeners": {
      "*:8080": {
          "pass": "applications/perl"
      }
  },
  "applications": {
      "perl": {
          "type": "perl",
          "working_directory": "/www/",
          "script": "/www/app.psgi"
      }
  }
  }' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation
```

```console
$ curl http://localhost:8080

    Hello, Perl on Unit!
```

Try this sample out with the Dockerfile
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> here](/unit/downloads/Dockerfile.perl.txt)
or use a more elaborate app example:

```perl
   use strict;

   use Digest::SHA qw(sha256_hex);
   use JSON;
   use Plack;
   use Plack::Request;

   my $app = sub {
       my $env = shift;
       my $req = Plack::Request->new($env);
       my $res = $req->new_response(200);
       $res->header("Content-Type" => "application/json; charset=utf-8");

       my $r = {
           "message"   => "Unit reporting",
           "agent"     => "NGINX Unit {{< param "unitversion" >}}",
           "headers"   => $req->headers->psgi_flatten(),
           "body"      => $req->content,
           "sha256"    => sha256_hex($req->content),
       };

       my $json = JSON->new();
       $res->body($json->utf8->pretty->encode($r));

       return $res->finalize();
   };
```

## PHP {#sample-php}

Let's configure the following basic app, saved as **/www/index.php**:

```php
<?php echo "Hello, PHP on Unit!"; ?>
```

Upload the
[app config]({{< relref "/unit/configuration.md#configuration-php" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
  "listeners": {
      "*:8080": {
          "pass": "applications/php"
      }
  },
  "applications": {
      "php": {
          "type": "php",
          "root": "/www/"
      }
  }
  }' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation

$ curl http://localhost:8080

    Hello, PHP on Unit!
```

Try this sample out with the Dockerfile
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> here](/unit/downloads/Dockerfile.php.txt)
or use a more elaborate app example:

```php
   <?php

   header("Content-Type: application/json; charset=utf-8");

   $r = array (
      "message" => "Unit reporting",
      "agent"   => "NGINX Unit {{< param "unitversion" >}}"
   );

   foreach ($_SERVER as $header => $value)
      if (strpos($header, "HTTP_") === 0)
         $r["headers"][$header] = $value;

   $r["body"] = file_get_contents("php://input");
   $r["sha256"] = hash("sha256", $r["body"]);

   echo json_encode($r, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

   ?>
```

## Python {#sample-python}

Let's configure the following basic app, saved as **/www/wsgi.py**:

```python
def application(environ, start_response):
    start_response("200 OK", [("Content-Type", "text/plain")])
    return (b"Hello, Python on Unit!")
```

Upload the
[app config]({{< relref "/unit/configuration.md#configuration-python" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
  "listeners": {
      "*:8080": {
          "pass": "applications/python"
      }
  },
  "applications": {
      "python": {
          "type": "python",
          "path": "/www/",
          "module": "wsgi"
      }
  }
  }' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation
```

```console
$ curl http://localhost:8080

    Hello, Python on Unit!
```

Try this sample out with the Dockerfile
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> here](/unit/downloads/Dockerfile.python.txt)
or use a more elaborate app example:

```python
   import hashlib, json

   def application(env, start_response):
       start_response("200 OK", [("Content-Type",
                                  "application/json; charset=utf-8")])

       r = {}

       r["message"] = "Unit reporting"
       r["agent"] = "NGINX Unit {{< param "unitversion" >}}"

       r["headers"] = {}
       for header in [_ for _ in env.keys() if _.startswith("HTTP_")]:
           r["headers"][header] = env[header]

       bytes = env["wsgi.input"].read()
       r["body"] = bytes.decode("utf-8")
       r["sha256"] = hashlib.sha256(bytes).hexdigest()

       return json.dumps(r, indent=4).encode("utf-8")
```

## Ruby {#sample-ruby}

Let's configure the following basic app, saved as **/www/config.ru**:

```ruby
app = Proc.new do |env|
    ["200", {
        "Content-Type" => "text/plain",
    }, ["Hello, Ruby on Unit!"]]
end

run app
```

Upload the
[app config]({{< relref "/unit/configuration.md#configuration-ruby" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
  "listeners": {
      "*:8080": {
          "pass": "applications/ruby"
      }
  },
  "applications": {
      "ruby": {
          "type": "ruby",
          "working_directory": "/www/",
          "script": "config.ru"
      }
  }
  }' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation
```

```console
$ curl http://localhost:8080

    Hello, Ruby on Unit!
```

Try this sample out with the Dockerfile
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> here](/unit/downloads/Dockerfile.ruby.txt)
or use a more elaborate app example:

```ruby
   require "digest"
   require "json"

   app = Proc.new do |env|
       body = env["rack.input"].read
       r = {
           "message" => "Unit reporting",
           "agent"   => "NGINX Unit {{< param "unitversion" >}}",
           "body"    => body,
           "headers" => env.select { |key, value| key.include?("HTTP_") },
           "sha256"  => Digest::SHA256.hexdigest(body)
       }

       ["200", {
           "Content-Type" => "application/json; charset=utf-8",
       }, [JSON.pretty_generate(r)]]
   end;

   run app
```

## WebAssembly (Wasm) {#sample-wasm}

{{< tabs name="web-assembly" >}}
{{% tab name="wasm-wasi-component" %}}

Instead of dealing with bytecode, let's build a Unit-capable Rust app
and compile it into a WebAssembly (Wasm) component.

Make sure you have the Rust toolchain (cargo, rustc, etc.) installed.
We recommend using [rustup](https://rustup.rs/) to get started.

This example was built with **rustc** version 1.76.0.

Start by adding the wasm32-wasi support as a compilation target for **rustc**

```console
$ rustup target add wasm32-wasi
```

Next, install cargo component. This simplifies building a WebAssembly
component from Rust Code, making it the recommended method.

```console
$ cargo install cargo-component
```

Currently, the fastest way to get started with WebAssembly components using WASI
0.2 wasi-http API is the **hello-wasi-http** demo application by
Dan Gohman. Clone the repository and build the component running
the following command:

```console
$ git clone https://github.com/sunfishcode/hello-wasi-http
```

```console
$ cd hello-wasi-http
```

```console
$ cargo component build
```

The output of the build command should be similar to this:

```console
$ cargo component build
Compiling hello-wasi-http v0.0.0 (/home/unit-build/hello-wasi-http)
Finished dev [unoptimized + debuginfo] target(s) in 0.17s
Creating component /home/unit-build/hello-wasi-http/target/wasm32-wasi/debug/hello_wasi_http.wasm
$
```

This creates a WebAssembly component you can deploy on Unit using the
following Unit configuration. Make sure you point the **component** path
to the WebAssembly component you have just created. Create a
**config.json** file:

```json
{
   "listeners": {
      "127.0.0.1:8080": {
         "pass": "applications/wasm"
      }
   },
   "applications": {
      "wasm": {
         "type": "wasm-wasi-component",
         "component": "/home/unit-build/hello-wasi-http/target/wasm32-wasi/debug/hello_wasi_http.wasm"
      }
   }
}
```

Apply the Unit configuration by using the CLI:

```console
$ unitc /config < config.json
```

Or by sending it manually to Units control API:

```console
$ cat config.json | curl -X PUT -d @- --unix-socket /path/to/control.unit.sock http://localhost/config/
```

Congratulations! You have created your very first WebAssembly component
on Unit! Send a GET Request to your configured listener.

```console
$ curl http://localhost:8080
```

{{% /tab %}}
{{% tab name="unit-wasm" %}}

{{< warning >}}
Unit 1.32.0 and later support the WebAssembly component
Model and WASI 0.2 APIs.
We recommend to use the new implementation.
{{< /warning >}}

Instead of dealing with bytecode, let's build a Unit-capable
Rust app and compile it into WebAssembly.

{{< note >}}
Currently, WebAssembly support is provided as a Technology Preview.
This includes support for compiling Rust and C code into Unit-compatible WebAssembly,
using our SDK in the form of the the `libunit-wasm` library.
For details, see our `unit-wasm` [repository](https://github.com/nginx/unit-wasm)
on GitHub.
{{< /note >}}

First, install the WebAssembly-specific Rust tooling:

```console
$ rustup target add wasm32-wasi
```

Next, initialize a new Rust project with a library target
(apps are loaded by Unit's WebAssembly module as dynamic libraries).
Then, add our **unit-wasm** crate to enable the `libunit-wasm` library:

```console
$ cargo init --lib wasm_on_unit
```

```console
$ cd wasm_on_unit/
```

```console
$ cargo add unit-wasm
```

Append the following to **Cargo.toml**:

```toml
[lib]
crate-type = ["cdylib"]
```

Save some sample code from our `unit-wasm` repo as **src/lib.rs**:

```console
wget -O src/lib.rs https://raw.githubusercontent.com/nginx/unit-wasm/main/examples/rust/echo-request/src/lib.rs
```

Build the Rust module with WebAssembly as the target:

```console
$ cargo build --target wasm32-wasi
```

This yields the **target/wasm32-wasi/debug/wasm_on_unit.wasm** file
(path may depend on other options).

Upload the [app config]({{< relref "/unit/configuration.md#configuration-wasm" >}})
to Unit and test it:

```console
# curl -X PUT --data-binary '{
   "listeners": {
      "127.0.0.1:8080": {
         "pass": "applications/wasm"
      }
   },

   "applications": {
      "wasm": {
         "type": "wasm",
         "module": "/path/to/wasm_on_unit/target/wasm32-wasi/debug/wasm_on_unit.wasm",
         "request_handler": "uwr_request_handler",
         "malloc_handler": "luw_malloc_handler",
         "free_handler": "luw_free_handler",
         "module_init_handler": "uwr_module_init_handler",
         "module_end_handler": "uwr_module_end_handler"
      }
   }
}' --unix-socket /path/to/control.unit.sock http://localhost/config/ # Path to Unit's control socket in your installation
```

```console
$ curl http://localhost:8080

   * Welcome to WebAssembly in Rust on Unit! [libunit-wasm (0.3.0/0x00030000)] *

   [Request Info]
   REQUEST_PATH = /
   METHOD       = GET
   VERSION      = HTTP/1.1
   QUERY        =
   REMOTE       = 127.0.0.1
   LOCAL_ADDR   = 127.0.0.1
   LOCAL_PORT   = 8080
   SERVER_NAME  = localhost

   [Request Headers]
   Host = localhost:8080
   User-Agent = curl/8.2.1
   Accept = */*
```

Further, you can research the Unit-based WebAssembly app internals in more depth.
Clone the `unit-wasm` repository and build the examples in C and Rust
(may require `clang` and `lld`):

```console
$ git clone https://github.com/nginx/unit-wasm/
```

```console
$ cd unit-wasm
```

```console
$ make help                                               # Explore your options first
```

```console
$ make WASI_SYSROOT=/path/to/wasi-sysroot/ examples       # C examples
```

```console
$ make WASI_SYSROOT=/path/to/wasi-sysroot/  examples-rust  # Rust examples
```

{{< note >}}
If the above commands fail like this:

```console
wasm-ld: error: cannot open .../lib/wasi/libclang_rt.builtins-wasm32.a: No such file or directory
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

Download and install the library to `clang`'s run-time dependency directory:

```console
$ wget -O- https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-20/libclang_rt.builtins-wasm32-wasi-20.0.tar.gz \
      | tar zxf -                  # Unpacks to lib/wasi/ in the current directory
```

```console
$ clang -print-runtime-dir         # Double-check the run-time directory, which is OS-dependent

      /path/to/runtime/dir/linux
```

```console
# mkdir /path/to/runtime/dir/wasi  # Note the last part of the pathname
```

```console
# cp lib/wasi/libclang_rt.builtins-wasm32.a /path/to/runtime/dir/wasi/
```

{{< /note >}}

{{% /tab %}}
{{< /tabs >}}
