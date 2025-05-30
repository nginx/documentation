---
title: Apollo
weight: 100
toc: true
---

To run the [Apollo](https://www.apollographql.com) GraphQL server
using Unit:

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with the
   **unit-dev/unit-devel** package. Next, [install]({{< relref "unit/installation.md#installation-nodejs-package" >}}) Unit's **unit-http** package. Run the following
   command as root:

   ```console
   # npm install -g --unsafe-perm unit-http
   ```

2. Create your app directory, [install](https://expressjs.com/en/starter/installing.html) Apollo, and link
   **unit-http**. Run the commands starting with a hash (#) as root:

   ```console
   $ mkdir -p /path/to/app/ # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ npm install @apollo/server graphql
   ```

   ```console
   # npm link unit-http
   ```

3. Create the [middleware](https://www.apollographql.com/docs/apollo-server/api/express-middleware/)
   module; let's store it as **/path/to/app/apollo.js**.
   First, initialize the directory:

   ```console
   $ cd /path/to/app/  # Path to the application directory; use a real path in your configuration
   ```

   ```console
   $ npm init
   ```

   Next, add the following code:

   ```javascript
   import { ApolloServer } from '@apollo/server';
   import { expressMiddleware } from '@apollo/server/express4';
   import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
   import express from 'express';
   import http from 'http';
   import cors from 'cors';
   import bodyParser from 'body-parser';
   //import { typeDefs, resolvers } from './schema';

   const typeDefs = `#graphql
     type Query {
       hello: String
     }
   `;

   // A map of functions which return data for the schema.
   const resolvers = {
     Query: {
       hello: () => 'world',
     },
   };


   // Required logic for integrating with Express
   const app = express();
   // Our httpServer handles incoming requests to our Express app.
   // Below, we tell Apollo Server to "drain" this httpServer,
   // enabling our servers to shut down gracefully.
   const httpServer = http.createServer(app);

   // Same ApolloServer initialization as before, plus the drain plugin
   // for our httpServer.
   const server = new ApolloServer({
     typeDefs,
     resolvers,
     plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
   });
   // Ensure we wait for our server to start
   await server.start();

   // Set up our Express middleware to handle CORS, body parsing,
   // and our expressMiddleware function.
   app.use(
     '/',
     cors(),
     bodyParser.json(),
     // expressMiddleware accepts the same arguments:
     // an Apollo Server instance and optional configuration options
     expressMiddleware(server, {
       context: async ({ req }) => ({ token: req.headers.token }),
     }),
   );

   // Modified server startup; port number is overridden by Unit config
   await new Promise((resolve) => httpServer.listen({ port: 80 }, resolve));
   ```

   Make sure your **package.json** resembles this
   (mind **"type": "module"**):

   ```json
   {
       "name": "unit-apollo",
       "version": "1.0.0",
       "description": "Running Apollo over Express on Unit",
       "main": "index.js",
       "type": "module",
       "scripts": {
           "test": "echo \"Error: no test specified\" && exit 1"
       },
       "author": "Unit Team",
       "license": "ISC",
       "dependencies": {
           "@apollo/server": "^4.7.5",
           "apollo-server": "^3.12.0",
           "body-parser": "^1.20.2",
           "cors": "^2.8.5",
           "express": "^4.18.2",
           "graphql": "^16.7.1",
           "unit-http": "^1.30.0"
       }
   }
   ```

4. Change ownership:

   {{< include "unit/howto_change_ownership.md" >}}


5. Next, [prepare]({{< relref "/unit/configuration.md#configuration-nodejs" >}}) the Apollo configuration for
   Unit:
   ```json
   {
      "listeners": {
         "*:80": {
               "pass": "applications/apollo"
         }
      },

      "applications": {
         "apollo": {
               "type": "external",
               "working_directory": "/path/to/app/",
               "_comment_working_directory": "Needed to use the installed NPM modules; use a real path in your configuration",
               "executable": "/usr/bin/env",
               "_comment_executable": "The external app type allows to run arbitrary executables, provided they establish communication with Unit",
               "arguments": [
                  "node",
                  "--loader",
                  "unit-http/loader.mjs",
                  "--require",
                  "unit-http/loader",
                  "apollo.js"
               ],
               "_comment_arguments": "The env executable runs Node.js, supplying Unit's loader module and your app code as arguments"
         }
      }
   }
   ```

6. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, your app should be available on the listener's IP
   address and port:

   ![Apollo on Unit](/unit/images/apollo.png)
