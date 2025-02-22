---
title: Koa
weight: 1100
toc: true
---

To run apps built with the [Koa](https://koajs.com) web framework using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
with the **unit-dev/unit-devel** package. Next,
[install]({{< relref "unit/installation.md#installation-nodejs-package" >}})
Unit's **unit-http** package. Run the following command as root:

   ```console
   # npm install -g --unsafe-perm unit-http
   ```

2. Create your app directory, [install](https://koajs.com/#introduction)
   Koa, and link **unit-http**:

   ```console
   $ mkdir -p /path/to/app/ #Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ cd /path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ npm install koa
   ```

   Run the following command as root:

   ```console
   # npm link unit-http
   ```

3. Let’s try a version of the [tutorial app](https://koajs.com/#application), saving it as
   **/path/to/app/app.js**:

   ```javascript
   const Koa = require('koa');
   const app = new Koa();

   // logger

   app.use(async (ctx, next) => {
     await next();
     const rt = ctx.response.get('X-Response-Time');
     console.log(`${ctx.method} ${ctx.url} - ${rt}`);
   });

   // x-response-time

   app.use(async (ctx, next) => {
     const start = Date.now();
     await next();
     const ms = Date.now() - start;
     ctx.set('X-Response-Time', `${ms}ms`);
   });

   // response

   app.use(async ctx => {
     ctx.body = 'Hello, Koa on Unit!';
   });

   app.listen();
   ```

   The file should be made executable so the application can run on Unit:

   ```console
   $ chmod +x app.js # Application file; use a real path in your configuration
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}

5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-nodejs" >}})
   the Koa configuration for Unit:

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/koa"
         }
      },
      "applications": {
         "koa": {
            "type": "external",
            "working_directory": "/path/to/app/",
            "working_directory_comment": "Needed to use the installed NPM modules; use a real path in your configuration",
            "executable": "/usr/bin/env",
            "executable_comment": "The external app type allows to run arbitrary executables, provided they establish communication with Unit",
            "arguments": [
            "node",
            "--loader",
            "unit-http/loader.mjs",
            "--require",
            "unit-http/loader",
            "app.js"
            ],
            "arguments_comment": "The env executable runs Node.js, supplying Unit's loader module and your app code as arguments",
            "app_js_comment": "Basename of the application file; be sure to make it executable"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener's IP
   address and port:

      ```console
      $ curl http://localhost -v

            *   Trying 127.0.0.1:80...
            * TCP_NODELAY set
            * Connected to localhost (127.0.0.1) port 80 (#0)
            > GET / HTTP/1.1
            > Host: localhost
            > User-Agent: curl/7.68.0
            > Accept: */*
            >
            * Mark bundle as not supporting multiuse
            < HTTP/1.1 200 OK
            < Content-Type: text/plain; charset=utf-8
            < Content-Length: 11
            < X-Response-Time: 0ms
            < Server: Unit/{{< param "unitversion" >}}

            Hello, Koa on Unit!
   ```
