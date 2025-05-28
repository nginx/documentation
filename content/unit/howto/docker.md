---
title: Unit in Docker
weight: 200
toc: true
---

To run your apps in a containerized Unit using the
[images we provide]({{< relref "/unit/installation.md#installation-docker" >}}),
you need at least to:

- Mount your application files to a directory in your container.
- Publish Unit's listener port to the host machine.

For example:

```console
   $ export UNIT=$(                                             \
         docker run -d --mount type=bind,src="$(pwd)",dst=/www  \
         -p 8080:8000 unit:{{< param "unitversion" >}}-python3.11                 \
     )
```

The command mounts the host's current directory where your app files are stored
to the container's **/www/** directory and publishes the container's port
**8000** that the listener will use as port **8080** on the host,
saving the container's ID in the `UNIT` environment variable.

Next, upload a configuration to Unit via the control socket:

```console
$ docker exec -ti $UNIT curl -X PUT --data-binary @/www/config.json  \
      --unix-socket /var/run/control.unit.sock  \ # Socket path inside the container
      http://localhost/config
```

This command assumes your configuration is stored as **config.json** in the
container-mounted directory on the host; if the file defines a listener on port
**8000**, your app is now accessible on port **8080** of the host. For
details of the Unit configuration, see
[Configuration]({{< relref "/unit/controlapi.md#configuration-api" >}}).

{{< note >}}
For app containerization examples, refer to our sample [<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> Go](/unit/downloads/Dockerfile.go.txt),
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> Java](/unit/downloads/Dockerfile.java.txt),
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> Node.js](/unit/downloads/Dockerfile.nodejs.txt),
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> Perl](/unit/downloads/Dockerfile.perl.txt),
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> PHP](/unit/downloads/Dockerfile.php.txt),
[<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> Python](/unit/downloads/Dockerfile.python.txt),
and [<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> Ruby](/unit/downloads/Dockerfile.ruby.txt) Dockerfiles;
also, see a more elaborate discussion
[below]({{< relref "/unit/howto/docker.md#docker-apps" >}})
{{< /note >}}

Now for a few detailed scenarios.

## Apps in a containerized Unit {#docker-apps-containerized-unit}

Suppose we have a web app with a few dependencies, say
[Flask`s]({{< relref "/unit/howto/frameworks/flask.md" >}}) official **hello, world** app:

```console
$ cd /path/to/app/ # Directory where all app-related files will be stored; use a real path in your configuration
```

```console
$ mkdir webapp
```

```console
$ cat << EOF > webapp/wsgi.py

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'
EOF
```

However basic it is, there's already a dependency, so let's list it in a file
called **requirements.txt**:

```console
$ cat << EOF > requirements.txt

flask
EOF
```

Next, create a simple Unit
[configuration]({{< relref "/unit/configuration.md#configuration-python" >}})
file for the app:

```console
$ mkdir config
```

```console
$ cat << EOF > config/config.json

{
    "listeners": {
        "*:8000": {
            "pass": "applications/webapp"
        }
    },

    "applications": {
        "webapp": {
            "type": "python 3",
            "path": "/www",  # Directory inside the container where the app files will be stored
            "module": "wsgi",  # WSGI module basename with extension omitted
            "callable": "app"  # Name of the callable in the module to run
        }
    }
}
EOF

```

Finally, let's create **log/** and **state/** directories to store Unit
[log and state]({{< relref "/unit/howto/source.md#source-startup" >}})

```console
$ mkdir log
```

```console
$ touch log/unit.log
```

```console
$ mkdir state
```

Our file structure so far:

```none
/path/to/app # Directory where all app-related files are stored; use a real path in your configuration
├── config
│   └── config.json
├── log
│   └── unit.log
├── requirements.txt
├── state
└── webapp
    └── wsgi.py
```

Everything is ready for a containerized Unit. First, let's create a
**Dockerfile** to install app prerequisites:

```dockerfile
FROM unit:{{< param "unitversion" >}}-python3.11
COPY requirements.txt /config/requirements.txt
RUN python3 -m pip install -r /config/requirements.txt
```

```console
$ docker build --tag=unit-webapp . # Arbitrary image tag
```

Next, we start a container and map it to our directory structure:

```console
$ export UNIT=$(                                                         \
      docker run -d                                                      \
      --mount type=bind,src="$(pwd)/config/",dst=/docker-entrypoint.d/   \
      --mount type=bind,src="$(pwd)/log/unit.log",dst=/var/log/unit.log  \
      --mount type=bind,src="$(pwd)/state",dst=/var/lib/unit             \
      --mount type=bind,src="$(pwd)/webapp",dst=/www                     \
      -p 8080:8000 unit-webapp                                           \
  )
```

{{< note >}}
With this mapping, Unit stores its state and log in your file structure. By
default, our Docker images forward their log output to the [Docker log
collector](https://docs.docker.com/config/containers/logging/).
{{< /note >}}

We've mapped the source **config/** to **/docker-entrypoint.d/** in the
container; the official image
[uploads]({{< relref "/unit/installation.md#installation-docker-init" >}})
any **.json** files found there into Unit's **config** section if the
state is empty. Now we can test the app:

```console
$ curl -X GET localhost:8080

    Hello, World!
```

To relocate the app in your file system, you only need to move the file
structure:

```console
$ mv /path/to/app/  # Directory where all app-related files are stored
      /new/path/to/app/  # New directory; use a real path in your configuration
```

To switch your app to a different Unit image, prepare a corresponding
**Dockerfile** first:

```dockerfile
FROM unit:{{< param "unitversion" >}}-minimal
COPY requirements.txt /config/requirements.txt
# This time, we took a minimal Unit image to install a vanilla Python 3.9
# module, run PIP, and perform cleanup just like we did earlier.

# First, we install the required tooling and add Unit's repo.
RUN apt update && apt install -y curl apt-transport-https gnupg2 lsb-release  \
      &&  curl -o /usr/share/keyrings/nginx-keyring.gpg                         \
            https://unit.nginx.org/keys/nginx-keyring.gpg                      \
      && echo "deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg]            \
            https://packages.nginx.org/unit/debian/ `lsb_release -cs` unit"    \
            > /etc/apt/sources.list.d/unit.list

# Next, we install the module, download app requirements, and perform cleanup.
RUN apt update && apt install -y unit-python3.9 python3-pip                   \
      && python3 -m pip install -r /config/requirements.txt                     \
      && apt remove -y curl apt-transport-https gnupg2 lsb-release python3-pip  \
      && apt autoremove --purge -y                                              \
      && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*.list
```

```console
$ docker build --tag=unit-pruned-webapp .
```

Run a container from the new image; Unit picks up the mapped state
automatically:

```console
$ export UNIT=$(                                                         \
      docker run -d                                                      \
      --mount type=bind,src="$(pwd)/log/unit.log",dst=/var/log/unit.log  \
      --mount type=bind,src="$(pwd)/state",dst=/var/lib/unit             \
      --mount type=bind,src="$(pwd)/webapp",dst=/www                     \
      -p 8080:8000 unit-pruned-webapp                                    \
  )
```


## Containerized apps {#docker-apps}

Suppose you have a Unit-ready
[Express]({{< relref "/unit/howto/frameworks/express.md" >}})
app, stored in the **myapp/** directory as **app.js**:

```javascript
#!/usr/bin/env node

const http = require('http')
const express = require('express')
const app = express()

app.get('/', (req, res) => res.send('Hello, Unit!'))
http.createServer(app).listen()
```

Its Unit configuration, stored as **config.json** in the same directory:

```json
{
    "listeners": {
        "*:8080": {
            "pass": "applications/express"
        }
    },

    "applications": {
        "express": {
            "type": "external",
            "working_directory": "/www/",
            "comment_working_directory": "Directory inside the container where the app files will be stored",
            "executable": "/usr/bin/env",
            "comment_executable": "The external app type allows to run arbitrary executables, provided they establish communication with Unit",
            "arguments": [
                "node",
                "--loader",
                "unit-http/loader.mjs",
                "--require",
                "unit-http/loader",
                "app.js"
            ],
            "comment_arguments": "The env executable runs Node.js, supplying Unit's loader module and your app code as arguments",
            "comment_app.js": "Basename of the application file; be sure to make it executable"
        }
    }
}
```

The resulting file structure:

```none
myapp/
├── app.js
└── config.json
```

{{< note >}}
Don't forget to `chmod +x` the **app.js** file so Unit can run it.
{{< /note >}}

Let's prepare a **Dockerfile** to install and configure the app in an
image:

```dockerfile
# Keep our base image as specific as possible.
FROM unit:{{< param "unitversion" >}}-node15

# Same as "working_directory" in config.json.
COPY myapp/app.js /www/

# Install and link Express in the app directory.
RUN cd /www && npm install express && npm link unit-http

# Port used by the listener in config.json.
EXPOSE 8080
```

When you start a container based on this image, mount the **config.json** file to
[initialize]({{< relref "/unit/installation.md#installation-docker-init" >}})
Unit's state:

```console
$ docker build --tag=unit-expressapp . # Arbitrary image tag
```

```console
$ export UNIT=$(                                                                             \
      docker run -d                                                                          \
      --mount type=bind,src="$(pwd)/myapp/config.json",dst=/docker-entrypoint.d/config.json  \
      -p 8080:8080 unit-expressapp                                                           \
  )
```

```console
$ curl -X GET localhost:8080

     Hello, Unit!
```

{{< note >}}
This mechanism allows to initialize Unit at container startup only if its
state is empty; otherwise, the contents of **/docker-entrypoint.d/** is
ignored. Continuing the previous sample:

```console
$ docker commit $UNIT unit-expressapp  # Store a non-empty Unit state in the image.

# cat << EOF > myapp/new-config.json   # Let's attempt re-initialization.
  ...
  EOF

$ export UNIT=$(                                                                                     \
      docker run -d                                                                                  \
      --mount type=bind,src="$(pwd)/myapp/new-config.json",dst=/docker-entrypoint.d/new-config.json  \
      -p 8080:8080 unit-expressapp                                                                   \
  )
```

Here, Unit *does not* pick up the **new-config.json** from the
**/docker-entrypoint.d/** directory when we run a container from the
updated image because Unit's state was initialized and saved earlier.
{{< /note >}}

To configure the app after startup, supply a file or an explicit snippet via
the [control API]({{< relref "/unit/controlapi.md" >}}):

```console
$ cat << EOF > myapp/new-config.json
  ...
  EOF
```

```console
$ export UNIT=$(                                                                     \
      docker run -d                                                                  \
      --mount type=bind,src="$(pwd)/myapp/new-config.json",dst=/cfg/new-config.json  \
      unit-expressapp                                                                \
  )
```

```console
$ docker exec -ti $UNIT curl -X PUT --data-binary @/cfg/new-config.json  \
         --unix-socket /var/run/control.unit.sock  \
         http://localhost/config
```

```console
$ docker exec -ti $UNIT curl -X PUT -d '"/www/newapp/"'  \
         --unix-socket  /var/run/control.unit.sock  \
         http://localhost/config/applications/express/working_directory
```

This approach is applicable to any Unit-supported apps with external
dependencies.

## Multilanguage images {#docker-multi}

Earlier, Unit had a **-full** Docker image with modules for all supported
languages, but it was discontinued with version 1.22.0. If you still need a
multilanguage image, use the following **Dockerfile** template that starts
with the minimal Unit image based on
[Debian 11]({{< relref "/unit/installation.md#installation-debian-11" >}}):
and installs official language module packages:

```dockerfile
{
    "listeners": {
        "*:8080": {
            "pass": "applications/express"
        }
    },

    "applications": {
        "express": {
            "type": "external",
            "working_directory": "/www/",
            "comment_working_directory": "Directory inside the container where the app files will be stored",
            "executable": "/usr/bin/env",
            "comment_executable": "The external app type allows to run arbitrary executables, provided they establish communication with Unit",
            "arguments": [
                "node",
                "--loader",
                "unit-http/loader.mjs",
                "--require",
                "unit-http/loader",
                "app.js"
            ],
            "comment_arguments": "The env executable runs Node.js, supplying Unit's loader module and your app code as arguments",
            "comment_last_argument": "Basename of the application file; be sure to make it executable"
        }
    }
}
```

Instead of packages, you can build custom
[modules]({{< relref "/unit/howto/source.md#source-modules" >}});
use these **Dockerfile.\*** [templates](https://github.com/nginx/unit/tree/master/pkg/docker) as reference.

## Startup customization {#docker-startup}

Finally, you can customize the way Unit starts in a container by adding a new
Dockerfile layer:

```dockerfile
FROM unit:{{< param "unitversion" >}}-minimal

CMD ["unitd-debug","--no-daemon","--control","unix:/var/run/control.unit.sock"]
```

The **CMD** instruction above replaces the default `unitd`
executable with its debug version. Use Unit's
[command-line options]({{< relref "/unit/howto/source.md#source-startup" >}})
to alter its startup behavior, for example:

```dockerfile
FROM unit:{{< param "unitversion" >}}-minimal

CMD ["unitd","--no-daemon","--control","0.0.0.0:8080"]
```

This replaces Unit's default UNIX domain control socket with an IP socket
address.
