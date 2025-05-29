---
title: Express
toc: true
weight: 700
---

To run apps built with the [Express](https://expressjs.com) web framework
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
   with the **unit-dev/unit-devel** package. Next, [install]({{< relref "unit/installation.md#installation-nodejs-package" >}}) Unit's **unit-http** package. Run the following
   command as root:

   ```console
   # npm install -g --unsafe-perm unit-http
   ```

2. Create your app directory, [install](https://expressjs.com/en/starter/installing.html) Express, and link **unit-http**:

   ```console
   $ mkdir -p :/path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ cd /path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ npm install express --save
   ```

   Run the following command as root:

   ```console
   # npm link unit-http
   ```

3. Create your Express [app](https://expressjs.com/en/starter/hello-world.html);
   let's store it as **/path/to/app/app.js**. First, initialize the directory:

   ```console
   $ cd /path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ npm init
   ```

   Next, add your application code:

   ```javascript
   #!/usr/bin/env node

   const http = require('http')
   const express = require('express')
   const app = express()

   app.get('/', (req, res) => res.send('Hello, Express on Unit!'))

   http.createServer(app).listen()
   ```

   The file should be made executable so the application can run on Unit:

   ```console
   $ chmod +x app.js # Application file; use a real path in your configuration
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-nodejs" >}})
the Express configuration for Unit:

   ```json
   {
      "listeners": {
         "*:80": {
            "pass": "applications/express"
         }
      },
      "applications": {
         "express": {
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

6.    {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener's IP
   address and port:

![Express on Unit - Welcome Screen](/unit/images/express.png)
