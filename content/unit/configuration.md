---
title: Configuration
weight: 600
toc: true
---

{{<note>}}
The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{</note>}}

The **/config** section of the
[control API]({{< relref "/unit/controlapi.md#configuration-api" >}})
handles Unit's general configuration with entities such as
[listeners]({{< relref "/unit/configuration.md#configuration-listeners" >}}),
[routes]({{< relref "/unit/configuration.md#configuration-routes" >}}),
[applications]({{< relref "/unit/configuration.md#configuration-applications" >}}),
or
[upstreams]({{< relref "/unit/configuration.md#configuration-upstreams" >}}).

## Listeners {#configuration-listeners}

To accept requests,
add a listener object in the **config/listeners** API section;
the object's name can be:

- A unique IP socket:
  **127.0.0.1:80**, **\[::1\]:8080**
- A wildcard that matches any host IPs on the port:
  **\*:80**
- On Linux-based systems, [abstract UNIX sockets](https://man7.org/linux/man-pages/man7/unix.7.html)
can be used as well: **unix:@abstract_socket**.

{{< note >}}
Also on Linux-based systems, wildcard listeners can't overlap with other listeners
on the same port due to rules imposed by the kernel.
For example, **\*:8080** conflicts with **127.0.0.1:8080**;
in particular, this means **\*:8080** can't be *immediately* replaced
by **127.0.0.1:8080** (or vice versa) without deleting it first.
{{< /note >}}

Unit dispatches the requests it receives to destinations referenced by listeners.
You can plug several listeners into one destination or use a single listener
and hot-swap it between multiple destinations.

Available listener options:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option     | Description                                                                                                                                                       |
|------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **pass** (required)  | Destination to which the listener passes incoming requests. Possible alternatives: <br><br> - [Application](< relref "/unit/configuration.md#configuration-applications">): **applications/qwk2mart** <br><br> - [PHP target]({{< relref "/unit/configuration.md#configuration-php-targets" >}}) or [Python target]({{< relref "/unit/configuration.md#configuration-python-targets" >}}): **applications/myapp/section** <br><br> - [Route]({{< relref "/unit/configuration.md#configuration-routes" >}}): **routes/route66**, **routes** <br><br> - [Upstream]({{< relref "/unit/configuration.md#configuration-upstreams" >}}): **upstreams/rr-lb** <br><br> The value is [variable]({{< relref "/unit/configuration.md#configuration-variables-native" >}})-interpolated; if it matches no configuration entities after interpolation, a 404 "Not Found" response is returned. |
| **forwarded**         | Object; configures client IP address and protocol [replacement]({{< relref "/unit/configuration.md#configuration-listeners-forwarded" >}}).                                                                                   |
| **tls**               | Object; defines SSL/TLS [settings]({{< relref "/unit/configuration.md#configuration-listeners-ssl" >}}).                                                                                                                               |
| **backlog**           | Integer; controls the 'backlog' parameter to the *listen(2)* system-call. This essentially limits the number of pending connections waiting to be accepted. The default varies by system. <br><br> On Linux, FreeBSD, OpenBSD, and macOS, the default is **-1** which means use the OS default. For example, on Linux since 5.4, this is **4096** (previously **128**) and on FreeBSD it's **128**. On other systems, the default is **511**. <br><br> NOTE: Whatever limit you set here will be limited by the OS system-wide sysctl. For example, on Linux that is `net.core.somaxconn` and on BSD it's `kern.ipc.somaxconn`. *(since 1.33.0)*  |
{{</bootstrap-table>}}

Here, a local listener accepts requests at port 8300 and passes them to the **blogs** app
[target]({{< relref "/unit/configuration.md#configuration-php-targets" >}})
identified by the **uri** [variable]({{< relref "/unit/configuration.md#configuration-variables-native" >}}).
The wildcard listener on port 8400 relays requests at any host IPs to the **main**
[route]({{< relref "/unit/configuration.md#configuration-routes" >}}):

```json
{
    "127.0.0.1:8300": {
        "pass": "applications/blogs$uri"
    },

    "*:8400": {
        "pass": "routes/main"
    }
}
```

Also, **pass** values can be
[percent encoded](https://datatracker.ietf.org/doc/html/rfc3986#section-2.1).
For example, you can escape slashes in entity names:

```json
{
    "listeners": {
         "*:80": {
             "pass": "routes/slashes%2Fin%2Froute%2Fname"
         }
    },

    "routes": {
         "slashes/in/route/name": []
    }
}
```

### SSL/TLS configuration {#configuration-listeners-ssl}

The **tls** object provides the following options:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option           | Description                                                                                                                                                                                                                                                                          |
|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **certificate** (required) | String or an array of strings; refers to one or more [certificate bundles]({{< relref "/unit/certificates.md">}}) uploaded earlier, enabling secure communication via the listener.                                                                                           |
| **conf_commands**         | Object; defines the OpenSSL [configuration commands](https://www.openssl.org/docs/manmaster/man3/SSL_CONF_cmd.html) to be set for the listener. <br><br> To have this option, Unit must be built and run with OpenSSL 1.0.2 or later. <br><br> Also, make sure your OpenSSL version supports the commands set by this option. |
| **session**           | Object; configures the TLS session cache and tickets for the listener.                                                                                                                                                                                                                      |
{{</bootstrap-table>}}

To use a certificate bundle you
[uploaded]({{< relref "/unit/certificates.md#configuration-ssl" >}})
earlier,
name it in the **certificate** option of the **tls** object:

```json
{
    "listeners": {
        "127.0.0.1:443": {
            "pass": "applications/wsgi-app",
            "tls": {
                "certificate": "bundle",
                "comment_certificate": "Certificate bundle name"
            }
        }
    }
}
```

<details>
<summary>Configuring multiple bundles</summary>

Since version 1.23.0, Unit supports configuring
[Server Name Indication (SNI)](https://datatracker.ietf.org/doc/html/rfc6066#section-3)
on a listener by supplying an array of certificate bundle names for the
**certificate** option value:

   ```json
      {
          "*:443": {
              "pass": "routes",
              "tls": {
                  "certificate": [
                      "bundleA",
                      "bundleB",
                      "bundleC"
                  ]
              }
          }
      }
   ```

- If the connecting client sends a server name,
   Unit responds with the matching certificate bundle.
- If the name matches several bundles,
   exact matches have priority over wildcards;
   if this doesn't help, the one listed first is used.
- If there's no match or no server name was sent, Unit uses
   the first bundle on the list.
</details>

To set custom OpenSSL
[configuration commands](https://www.openssl.org/docs/manmaster/man3/SSL_CONF_cmd.html)
for a listener,
use the **conf_commands** object in **tls**:

```json
{
    "tls": {
        "certificate": "bundle",
        "comment_certificate": "Certificate bundle name",
        "conf_commands": {
            "ciphersuites": "TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256",
            "comment_ciphersuites": "Mandatory cipher suites as per RFC8446, section 9.1",
            "minprotocol": "TLSv1.3"
        }
    }
}
```

<a name="configuration-listeners-ssl-sessions"></a>

The **session** object in **tls**
configures the session settings of the listener:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option       | Description                                                                                                                                                                                                                                        |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **cache_size** | Integer; sets the number of sessions in the TLS session cache. <br><br> The default is **0** (caching is disabled).                                                                                                                                                           |
| **tickets**   | Boolean, string, or an array of strings; configures TLS session tickets. <br><br> The default is **false** (tickets are disabled).                                                                                                                                                       |
| **timeout**   | Integer; sets the session timeout for the TLS session cache. <br><br> When a new session is created, its lifetime derives from current time and **timeout**. If a cached session is requested past its lifetime, it is not reused. <br><br> The default is **300** (5 minutes). |
{{</bootstrap-table>}}

#### Example:

```json
{
    "tls": {
        "certificate": "bundle",
        "comment_certificate": "Certificate bundle name",
        "session": {
            "cache_size": 10240,
            "timeout": 60,
            "tickets": [
                "k5qMHi7IMC7ktrPY3lZ+sL0Zm8oC0yz6re+y/zCj0H0/sGZ7yPBwGcb77i5vw6vCx8vsQDyuvmFb6PZbf03Auj/cs5IHDTYkKIcfbwz6zSU=",
                "3Cy+xMFsCjAek3TvXQNmCyfXCnFNAcAOyH5xtEaxvrvyyCS8PJnjOiq2t4Rtf/Gq",
                "8dUI0x3LRnxfN0miaYla46LFslJJiBDNdFiPJdqr37mYQVIzOWr+ROhyb1hpmg/QCM2qkIEWJfrJX3I+rwm0t0p4EGdEVOXQj7Z8vHFcbiA="
            ]
        }
    }
}
```

The **tickets** option works as follows:

- Boolean values enable or disable session tickets;
  with **true**, a random session ticket key is used:

  ```json
   {
      "session": {
         "tickets": true,
         "comment_tickets": "Enables session tickets"
      }
   }
  ```

- A string enables tickets and explicitly sets the session ticket key:

   ```json
   {
      "session": {
         "tickets": "IAMkP16P8OBuqsijSDGKTpmxrzfFNPP4EdRovXH2mqstXsodPC6MqIce5NlMzHLP",
         "comment_tickets": "Enables session tickets, sets a single session ticket key"
      }
   }
   ```

   This enables ticket reuse in scenarios
   where the key is shared between individual servers.

   <details>
   <summary>Shared key rotation</summary>
   If multiple Unit instances need to recognize tickets
   issued by each other
   (for example, when running behind a load balancer),
   they should share session ticket keys.

   For example,
   consider three SSH-enabled servers named `unit*.example.com`,
   with Unit installed and identical `:443` listeners configured.
   To configure a single set of three initial keys on each server:

   ```console
   SERVERS="unit1.example.com
         unit2.example.com
         unit3.example.com"

   KEY1=$(openssl rand -base64 48)
   KEY2=$(openssl rand -base64 48)
   KEY3=$(openssl rand -base64 48)

   for SRV in $SERVERS; do
      ssh root@$SRV \ # Assuming Unit runs as root on each server
         curl -X PUT -d '["$KEY1", "$KEY2", "$KEY3"]' --unix-socket /path/to/control.unit.sock \ # Path to the remote control socket
         'http://localhost/config/listeners/*:443/tls/session/tickets/'
   done
   ```

   To add a new key on each server:

   ```shell
   NEWKEY=$(openssl rand -base64 48)

   for SRV in $SERVERS; do
      ssh root@$SRV \ # Assuming Unit runs as root on each server
         curl -X POST -d "\"$NEWKEY\"" --unix-socket /path/to/control.unit.sock \ # Path to the remote control socket
            'http://localhost/config/listeners/*:443/tls/session/tickets/'
   done
   ```

   To delete the oldest key after adding the new one:

   ```shell
   for SRV in $SERVERS; do
      ssh root@$SRV \ # Assuming Unit runs as root on each server
         curl -X DELETE --unix-socket /path/to/control.unit.sock \ # Path to the remote control socket
            'http://localhost/config/listeners/*:443/tls/session/tickets/0'
   done
   ```

   This scheme enables safely sharing session ticket keys
   between individual Unit instances.
   ---

   </details>

  Unit supports AES256 (80-byte keys) or AES128 (48-byte keys);
  the bytes should be encoded in Base64:

  ```console
  $ openssl rand -base64 48

        LoYjFVxpUFFOj4TzGkr5MsSIRMjhuh8RCsVvtIJiQ12FGhn0nhvvQsEND1+OugQ7
  ```

  ```console
  $ openssl rand -base64 80

        GQczhdXawyhTrWrtOXI7l3YYUY98PrFYzjGhBbiQsAWgaxm+mbkm4MmZZpDw0tkK
        YTqYWxofDtDC4VBznbBwTJTCgYkJXknJc4Gk2zqD1YA=
  ```

- An array of strings just like the one above:

  ```json
   {
      "session": {
         "tickets": [
               "IAMkP16P8OBuqsijSDGKTpmxrzfFNPP4EdRovXH2mqstXsodPC6MqIce5NlMzHLP",
               "Ax4bv/JvMWoQG+BfH0feeM9Qb32wSaVVKOj1+1hmyU8ORMPHnf3Tio8gLkqm2ifC"
         ],
         "comment_tickets": "Enables session tickets, sets two session ticket keys"
      }
   }
  ```

  Unit uses these keys to decrypt the tickets submitted by clients
  who want to recover their session state;
  the last key is always used to create new session tickets
  and update the tickets created earlier.

  {{< note >}}
  An empty array effectively disables session tickets,
  same as setting **tickets** to **false**.
  {{< /note >}}

### IP, protocol forwarding {#configuration-listeners-forwarded}

Unit enables the **X-Forwarded-\*** header fields
with the **forwarded** object and its options:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option        | Description                                                                                                                                                                                                                                                                                                       |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **source** (required)   | String or an array of strings; defines [address-based patterns]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns" >}}) for trusted addresses. Replacement occurs only if the source IP of the request is a [match](configuration-routes-matching-resolution). <br><br> A special case here is the **"unix"** string; it matches *any* UNIX domain sockets. |
| **client_ip**           | String; names the HTTP header fields to expect in the request. They should use the [X-Forwarded-For](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For>) format where the value is a comma- or space-separated list of IPv4s or IPv6s.                        |
| **protocol**            | String; defines the relevant HTTP header field to look for in the request. Unit expects it to follow the [X-Forwarded-Proto](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Proto>) notation, with the field value itself being **http**, **https**, or **on**. |
| **recursive**           | Boolean; controls how the **client_ip** fields are traversed. <br><br> The default is **false** (no recursion).                                                                                                                                                      |
{{</bootstrap-table>}}

{{< note >}}
Besides **source**, the **forwarded** object must specify
**client_ip**, **protocol**, or both.
{{< /note >}}

{{< warning >}}
Before version 1.28.0, Unit provided the **client_ip** object
that evolved into **forwarded**:

{{<bootstrap-table "table table-striped table-bordered">}}
| **client_ip** (pre-1.28.0) | **forwarded** (post-1.28.0) |
|----------------------------|-----------------------------|
| **header**                  | **client_ip**               |
| **recursive**               | **recursive**               |
| **source**                  | **source**                  |
| N/A                        | **protocol**                |
{{</bootstrap-table>}}

This old syntax still works but will be eventually deprecated,
though not earlier than version 1.30.0.
{{< /warning >}}

When **forwarded** is set, Unit respects the appropriate header fields
only if the immediate source IP of the request
[matches]({{< relref "/unit/configuration.md#configuration-routes-matching-resolution" >}})
the **source** option. Mind that it can use not only subnets but any
[address-based patterns]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns" >}}):

```json
{
    "forwarded": {
        "client_ip": "X-Forwarded-For",
        "source": [
            "198.51.100.1-198.51.100.254",
            "comment_source_1": "Ranges can be specified explicitly",
            "!198.51.100.128/26",
            "comment_source_2": "Negation rejects any addresses originating here",
            "203.0.113.195",
            "comment_source_3": "Individual addresses are supported as well"
        ]
    }
}
```

#### Overwriting protocol scheme {#configuration-listeners-xfp}

The **protocol** option enables overwriting the incoming request's protocol scheme
based on the header field it specifies. Consider the following **forwarded** configuration:

```json
{
    "forwarded": {
        "protocol": "X-Forwarded-Proto",
        "source": [
            "192.0.2.0/24",
            "198.51.100.0/24"
        ]
    }
}
```

Suppose a request arrives with the following header field:

```none
X-Forwarded-Proto: https
```

If the source IP of the request matches **source**,
Unit handles this request as an **https** one.

#### Originating IP identification {#configuration-listeners-xff}

Unit also supports identifying the clients' originating IPs
with the **client_ip** option:

```json
{
    "forwarded": {
        "client_ip": "X-Forwarded-For",
        "recursive": false,
        "source": [
            "192.0.2.0/24",
            "198.51.100.0/24"
        ]
    }
}
```

Suppose a request arrives with the following header fields:

```none
X-Forwarded-For: 192.0.2.18
X-Forwarded-For: 203.0.113.195, 198.51.100.178
```

If **recursive** is set to **false** (default), Unit chooses the *rightmost*
address of the *last* field named in **client_ip** as the originating IP of the
request.
In the example, it's set to 198.51.100.178 for requests from 192.0.2.0/24 or 198.51.100.0/24.

If **recursive** is set to **true**, Unit inspects all **client_ip** fields in reverse order.
Each is traversed from right to left until the first non-trusted address;
if found, it's chosen as the originating IP. In the previous example with **"recursive": true**,
the client IP would be set to 203.0.113.195 because 198.51.100.178 is also trusted;
this simplifies working behind multiple reverse proxies.

## Routes {#configuration-routes}

The **config/routes** configuration entity defines internal request routing.
It receives requests
from [listeners]({{< relref "/unit/configuration.md#configuration-listeners" >}})
and filters them through
[sets of conditions]({{< relref "/unit/configuration.md#configuration-routes-matching" >}})
to be processed by
[apps]({{< relref "/unit/configuration.md#configuration-applications" >}}),
[proxied]({{< relref "/unit/configuration.md#configuration-proxy" >}})
to external servers or
[load-balanced]({{< relref "/unit/configuration.md#configuration-upstreams" >}})
between them,
served with
[static content]({{< relref "/unit/configuration.md#configuration-static" >}}),
[answered]({{< relref "/unit/configuration.md#configuration-return" >}})
with arbitrary status codes, or
[redirected]({{< relref "/unit/configuration.md#configuration-return" >}}).

In its simplest form, **routes** is an array that defines a single route:

```json
{
   "listeners": {
      "*:8300": {
         "pass": "routes"
      }
   },
   "routes": [],
   "comment_routes": {
      "hint": "Array-mode routes, simply referred to as 'routes'",
      "placeholder": "Any acceptable route array may go here; see the 'Route Steps' section for details"
   }
}
```

Another form is an object with one or more named route arrays as members:

```json
{
   "listeners": {
      "*:8300": {
         "pass": "routes/main"
      }
   },
   "routes": {
      "main": {
         "value": [
            "..."
         ],
         "comment": "Any acceptable route array may go here; see the 'Route Steps' section for details"
      },
      "comment_main": "Named route, referred to as 'routes/main'",
      "route66": {
         "value": [
            "..."
         ],
         "comment": "Any acceptable route array may go here; see the 'Route Steps' section for details"
      },
      "comment_route66": "Named route, referred to as 'routes/route66'"
   }
}
```

### Route steps {#configuration-routes-step}

A
[route]({{< relref "/unit/configuration.md#configuration-routes" >}})
array contains step objects as elements; they accept the following options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option        | Description                                                                                                        |
|---------------|--------------------------------------------------------------------------------------------------------------------|
| **action** (required) | Object; defines how matching requests are [handled]({{< relref "/unit/configuration.md#configuration-routes-action" >}}). |
| **match**     | Object; defines the step's [conditions]({{< relref "/unit/configuration.md#configuration-routes-matching" >}}). |
{{</bootstrap-table>}}

A request passed to a route traverses its steps sequentially:

- If all **match** conditions in a step are met, the traversal ends
  and the step's **action** is performed.
- If a step's condition isn't met, Unit proceeds to the next step of the route.
- If no steps of the route match, a 404 "Not Found" response is returned.

{{< warning >}}
If a step omits the **match** option, its **action** occurs automatically.
Thus, use no more than one such step per route, always placing it last to
avoid potential routing issues.
{{< /warning >}}

<details>
<summary>Ad-Hoc examples</summary>
A basic one:

```json
{
      "routes": [
         {
            "match": {
                  "host": "example.com",
                  "scheme": "https",
                  "uri": "/php/*"
            },

            "action": {
                  "pass": "applications/php_version"
            }
         },
         {
            "action": {
                  "share": "/www/static_version$uri"
            }
         }
      ]
}
```

This route passes all HTTPS requests to the **/php/** subsection of the
**example.com** website to the **php_version** app.
All other requests are served with static content from the **/www/static_version/**
directory. If there's no matching content,a 404 "Not Found" response is returned.

A more elaborate example with chained routes and proxying:

```json
{
      "routes": {
         "main": [
            {
                  "match": {
                     "scheme": "http"
                  },

                  "action": {
                     "pass": "routes/http_site"
                  }
            },
            {
                  "match": {
                     "host": "blog.example.com"
                  },

                  "action": {
                     "pass": "applications/blog"
                  }
            },
            {
                  "match": {
                     "uri": [
                        "*.css",
                        "*.jpg",
                        "*.js"
                     ]
                  },

                  "action": {
                     "share": "/www/static$uri"
                  }
            }
         ],

         "http_site": [
            {
                  "match": {
                     "uri": "/v2_site/*"
                  },

                  "action": {
                     "pass": "applications/v2_site"
                  }
            },
            {
                  "action": {
                     "proxy": "http://127.0.0.1:9000"
                  }
            }
         ]
      }
}
```

Here, a route called **main** is explicitly defined, so **routes** is an object
instead of an array. The first step of the route passes all HTTP requests
to the **http_site** app. The second step passes all requests that target
**blog.example.com** to the **blog** app. The final step serves requests for
certain file types from the **/www/static/** directory.
If no steps match, a 404 "Not Found" response is returned.

---
</details>

### Matching conditions {#configuration-routes-matching}

Conditions in a
[route step]({{< relref "/unit/configuration.md#configuration-routes-step" >}})'s
**match** object
define patterns to be compared to the request's properties:

{{<bootstrap-table "table table-striped table-bordered">}}
| Property   | Patterns Are Matched Against | Case |
|------------|------------------------------|------|
| **arguments** | Arguments supplied with the request's [query string](https://datatracker.ietf.org/doc/html/rfc3986#section-3.4); these names and value pairs are [percent decoded](https://datatracker.ietf.org/doc/html/rfc3986#section-2.1), with plus signs (**+**) replaced by spaces. | Yes |
| **cookies**   | Cookies supplied with the request. | Yes |
| **destination** | Target IP address and optional port of the request. | No |
| **headers**    | [Header fields](https://datatracker.ietf.org/doc/html/rfc9110#section-6.3) supplied with the request. | No |
| **host**       | **Host** [header field](https://datatracker.ietf.org/doc/html/rfc9110#section-7.2), converted to lower case and normalized by removing the port number and the trailing period (if any). | No |
| **method**     | [Method](https://datatracker.ietf.org/doc/html/rfc7231#section-4) from the request line, uppercased. | No |
| **query**      | [Query string](https://datatracker.ietf.org/doc/html/rfc3986#section-3.4), [percent decoded](https://datatracker.ietf.org/doc/html/rfc3986#section-2.1), with plus signs (**+**) replaced by spaces. | Yes |
| **scheme**     | URI [scheme](https://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml). Accepts only two patterns, either **http** or **https**. | No |
| **source**     | Source IP address and optional port of the request. | No |
| **uri**        | [Request target](https://datatracker.ietf.org/doc/html/rfc9110#target.resource), [percent decoded](https://datatracker.ietf.org/doc/html/rfc3986#section-2.1) and normalized by removing the [query string](https://datatracker.ietf.org/doc/html/rfc3986#section-3.4) and resolving [relative references](https://datatracker.ietf.org/doc/html/rfc3986#section-4.2) ("." and "..", "//"). | Yes |
{{</bootstrap-table>}}

<details>
<summary>Arguments vs. query</summary>

Both **arguments** and **query** operate on the query string,
but **query** is matched against the entire string whereas **arguments** considers
only the key-value pairs such as **key1=4861&key2=a4f3**.

Use **arguments** to define conditions based on key-value pairs in the query string:

```json
"arguments": {
   "key1": "4861",
   "key2": "a4f3"
}
```

Argument order is irrelevant: **key1=4861&key2=a4f3** and **key2=a4f3&key1=4861**
are considered the same. Also, multiple occurrences of an argument must all match,
so **key=4861&key=a4f3** matches this:

```json
"arguments":{
      "key": "*"
}
```

But not this:

```json
"arguments":{
      "key": "a*"
}
```

To the contrary, use **query** if your conditions concern query strings
but don't rely on key-value pairs:

```json
"query": [
      "utf8",
      "utf16"
]
```

This only matches query strings of the form
**https://example.com?utf8** or **https://example.com?utf16**.

---
</details>

#### Match resolution {#configuration-routes-matching-resolution}

To be a match,
the property must meet two requirements:

- If there are patterns without negation
  (the **!** prefix),
  at least one of them matches the property value.
- No negated patterns match the property value.

<details>
<summary>Formal explanation</summary>

This logic can be described with set operations.
Suppose set *U* comprises all possible values of a property;
set *P* comprises strings that match any patterns without negation;
set *N* comprises strings that match any negation-based patterns.
In this scheme,
the matching set is:

*U* ∩ *P* \\ *N* if *P* ≠ ∅

*U* \\ *N* if *P* = ∅

---
</details>

Here, the URI of the request must fit **pattern3**,
but must not match **pattern1** or **pattern2**:

```json
{
    "match": {
        "uri": [
            "!pattern1",
            "!pattern2",
            "pattern3"
        ]
    },

    "action": {
    "pass": "...",
    "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
    }
}
```

Additionally, special matching logic applies to **arguments**, **cookies**,
and **headers**. Each of these can be either a single object that lists
custom-named properties and their patterns or an array of such objects.

To match a single object, the request must match *all* properties named in the object.
To match an object array, it's enough to match *any* single one of its item objects.
The following condition matches only if the request arguments include **arg1** and **arg2**,
and both match their patterns:

```json
{
    "match": {
        "arguments": {
            "arg1": "pattern",
            "arg2": "pattern"
        }
    },

    "action": {
    "pass": "...",
    "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
    }
}
```

With an object array, the condition matches if the request's arguments include
**arg1** or **arg2** (or both) that matches the respective pattern:

```json
{
    "match": {
        "arguments": [
            {
                "arg1": "pattern"
            },
            {
                "arg2": "pattern"
            }
        ]
    },

    "action": {
    "pass": "...",
    "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
    }
}
```

The following example combines all matching types. Here, **host**, **method**, **uri**,
**arg1** *and* **arg2**, either **cookie1** or **cookie2**, and either **header1**
or **header2** *and* **header3** must be matched for the **action** to be taken
(**host & method & uri & arg1 & arg2 & (cookie1 | cookie2)
& (header1 | (header2 & header3))**):

```json
{
    "match": {
        "host": "pattern",
        "method": "!pattern",
        "uri": [
            "pattern",
            "!pattern"
        ],

        "arguments": {
            "arg1": "pattern",
            "arg2": "!pattern"
        },

        "cookies": [
            {
                "cookie1": "pattern",
            },
            {
                "cookie2": "pattern",
            }
        ],

        "headers": [
            {
                "header1": "pattern",
            },
            {
                "header2": "pattern",
                "header3": "pattern"
            }
        ]
    },

    "action": {
    "pass": "...",
    "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
    }
}
```

<details>
<summary>Object pattern examples</summary>

This requires **mode=strict** and any **access** argument other than **access=full**
in the URI query:

```json
{
      "match": {
         "arguments": {
            "mode": "strict",
            "access": "!full"
         }
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

This matches requests that either use **gzip** and identify as **Mozilla/5.0**
or list **curl** as the user agent:

```json
{
      "match": {
         "headers": [
            {
                  "Accept-Encoding": "*gzip*",
                  "User-Agent": "Mozilla/5.0*"
            },
            {
                  "User-Agent": "curl*"
            }
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

---
</details>

#### Pattern syntax {#configuration-routes-matching-patterns}

Individual patterns can be address-based (**source** and **destination**)
or string-based (other properties).

String-based patterns must match the property to a character; wildcards or
regexes (Available only if Unit was built with PCRE support enabled,
which is the default for the official packages) modify this behavior:

- A wildcard pattern may contain any combination of wildcards
  (**\***),
  each standing for an arbitrary number of characters:
  **How\*s\*that\*to\*you**.

<a name="configuration-routes-matching-patterns-regex"></a>

- A regex pattern starts with a tilde
  (**~**):
  **~^\\d+\\.\\d+\\.\\d+\\.\\d+**
  (escaping backslashes is a
  [JSON requirement](https://www.json.org/json-en.html)).
  The regexes are
  [PCRE](https://www.pcre.org/current/doc/html/pcre2syntax.html)-flavored.

<details>
<summary>Percent encoding in arguments, query, and URI patterns</summary>
<a name="percent-encoding"></a>

Argument names, non-regex string patterns in **arguments**,
**query**, and **uri** can be `percent encoded
(https://datatracker.ietf.org/doc/html/rfc3986#section-2.1)
to mask special characters (**!** is **%21**, **~** is **%7E**,
***** is **%2A**, **%** is **%25**) or even target single bytes.
For example, you can select diacritics such as Ö or Å by their starting byte
**0xC3** in UTF-8:

```json
{
      "match": {
         "arguments": {
            "word": "*%C3*"
         }
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

Unit decodes such strings and matches them against respective request entities,
decoding these as well:

```json
{
      "routes": [
         {
            "match": {
                  "query": "`%7Efuzzy word search"
            },

            "action": {
                  "return": 200
            }
         }
      ]
}
```

This condition matches the following percent-encoded request:

```console
$ curl http://127.0.0.1/?~fuzzy%20word%20search -v

      > GET /?~fuzzy%20word%20search HTTP/1.1
      ...
      < HTTP/1.1 200 OK
      ...
```

Note that the encoded spaces (**%20**) in the request match their unencoded
counterparts in the pattern; vice versa, the encoded tilde (**%7E**)
in the condition matches **~** in the request.

---
</details>

<details>
<summary>String pattern examples</summary>

<a name="conf-str-pattern-examples"></a>

A regular expression that matches any **.php** files in the **/data/www/**
directory and its subdirectories. Note the backslashes; escaping is a
JSON-specific requirement:

```json
{
      "match": {
         "uri": "~^/data/www/.*\\.php(/.*)?$"
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

Only subdomains of **example.com** match:

```json
{
      "match": {
         "host": "*.example.com"
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

Only requests for **.php** files
located in **/admin/**'s subdirectories
match:

```json
{
      "match": {
         "uri": "/admin/*/*.php"
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

Here, any **eu-** subdomains of **example.com** match except **eu-5.example.com**:

```json
{
      "match": {
         "host": [
            "eu-*.example.com",
            "!eu-5.example.com"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

Any methods match except **HEAD** and **GET**:

```json
{
      "match": {
         "method": [
            "!HEAD",
            "!GET"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

You can also combine certain special characters in a pattern. Here, any URIs match
except the ones containing **/api/**:

```json
{
      "match": {
         "uri": "!*/api/*"
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

Here, URIs of any articles that don't look like **YYYY-MM-DD** dates match.
Again, note the backslashes; they are a JSON requirement:

```json
{
      "match": {
         "uri": [
            "/articles/*",
            "!~/articles/\\d{4}-\\d{2}-\\d{2}"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```
---

</details>

Address-based patterns define individual IPv4
(dot-decimal or
[CIDR](https://datatracker.ietf.org/doc/html/rfc4632)),
IPv6 (hexadecimal or
[CIDR](https://datatracker.ietf.org/doc/html/rfc4291#section-2.3)),
or any
[UNIX domain socket](https://en.wikipedia.org/wiki/Unix_domain_socket)
addresses
that must exactly match the property;
wildcards and ranges modify this behavior:

- Wildcards
  (**\***)
  can only match arbitrary IPs
  (**\*:\<port>**).
- Ranges
  (**-**)
  work with both IPs
  (in respective notation)
  and ports
  (**\<start_port>-\<end_port>**).

<details>
<summary>Address-based allow-deny lists</summary>

<a name="allow-deny"></a>

Addresses come in handy when implementing an allow-deny mechanism
with routes, for instance:

```json
"routes": [
      {
         "match": {
            "source": [
                  "!192.168.1.1",
                  "!10.1.1.0/16",
                  "192.168.1.0/24",
                  "2001:0db8::/32"
            ]
         },

         "action": {
            "share": "/www/data$uri"
         }
      }
]
```

See
[here]({{< relref "/unit/configuration.md#configuration-routes-matching-resolution" >}})
for details of pattern resolution order; this corresponds to the following
`nginx` directive:

```nginx
location / {
      deny  10.1.1.0/16;
      deny  192.168.1.1;
      allow 192.168.1.0/24;
      allow 2001:0db8::/32;
      deny  all;

      root /www/data;
}
```
---
</details>

<details>
<summary> Address pattern examples</summary>
<a name="conf-addr-pattern-examples"></a>

This uses IPv4-based matching with wildcards and ranges:

```json
{
      "match": {
         "source": [
            "192.0.2.1-192.0.2.200",
            "198.51.100.1-198.51.100.200:8000",
            "203.0.113.1-203.0.113.200:8080-8090",
            "*:80"
         ],

         "destination": [
            "192.0.2.0/24",
            "198.51.100.0/24:8000",
            "203.0.113.0/24:8080-8090",
            "*:80"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

This uses IPv6-based matching with wildcards and ranges:

```json
{
      "match": {
         "source": [
               "2001:0db8::-2001:0db8:aaa9:ffff:ffff:ffff:ffff:ffff",
               "[2001:0db8:aaaa::-2001:0db8:bbbb::]:8000",
               "[2001:0db8:bbbb::1-2001:0db8:cccc::]:8080-8090",
               "*:80"
         ],

         "destination": [
               "2001:0db8:cccd::/48",
               "[2001:0db8:ccce::/48]:8000",
               "[2001:0db8:ccce:ffff::/64]:8080-8090",
               "*:80"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

This matches any of the listed IPv4 or IPv6 addresses:

```json
{
      "match": {
         "destination": [
            "127.0.0.1",
            "192.168.0.1",
            "::1",
            "2001:0db8:1::c0a8:1"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

Here, any IPs from the range match except **192.0.2.9**:

```json
{
      "match": {
         "source": [
            "192.0.2.1-192.0.2.10",
            "!192.0.2.9"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

This matches any IPs but limits the acceptable ports:

```json
{
      "match": {
         "source": [
            "*:80",
            "*:443",
            "*:8000-8080"
         ]
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```

This matches any UNIX domain sockets:

```json
{
      "match": {
         "source": "unix"
      },

      "action": {
     "pass": "...",
     "_comment_pass": "Any acceptable 'pass' value may go here; see the 'Listeners' section for details"
      }
}
```
---
</details>

### Handling actions {#configuration-routes-action}

If a request matches all
[conditions]({{< relref "/unit/configuration.md#configuration-routes-matching" >}})
of a route step
or the step itself omits the **match** object,
Unit handles the request with the respective **action**.
The mutually exclusive **action** types are:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option   | Description                                                                                                      | Details                                 |
|----------|------------------------------------------------------------------------------------------------------------------|-----------------------------------------|
| **pass**   | Destination for the request, identical to a listener's **pass** option.                                           | [Listeners]({{< relref "/unit/configuration.md#configuration-listeners" >}}) |
| **proxy**  | Socket address of an HTTP server to where the request is proxied.                                               | [Proxying]({{< relref "/unit/configuration.md#configuration-proxy" >}}) |
| **return** | HTTP status code with a context-dependent redirect location.                                                    | [Instant responses, redirects]({{< relref "/unit/configuration.md#configuration-return" >}}) |
| **share**  | File paths that serve the request with static content.                                                           | [Static files]({{< relref "/unit/configuration.md#configuration-static" >}}) |

{{</bootstrap-table>}}


An additional option is applicable to any of these actions:
{{<bootstrap-table "table table-striped table-bordered">}}
| Option            | Description                                       | Details                                    |
|-------------------|---------------------------------------------------|--------------------------------------------|
| **response_headers** | Updates the header fields of the upcoming response. | [Response headers]({{< relref "/unit/configuration.md#configuration-response-headers" >}}) |
| **rewrite**         | Updated the request URI, preserving the query string. | [URI rewrite]({{< relref "/unit/configuration.md#configuration-rewrite" >}}) |
{{</bootstrap-table>}}

An example:

```json
{
    "routes": [
        {
            "match": {
                "uri": [
                    "/v1/*",
                    "/v2/*"
                ]
            },

            "action": {
                "rewrite": "/app/$uri",
                "pass": "applications/app"
            }
        },
        {
            "match": {
                "uri": "~\\.jpe?g$"
            },

            "action": {
                "share": [
                    "/var/www/static$uri",
                    "/var/www/static/assets$uri"
                 ],

                "fallback": {
                     "pass": "upstreams/cdn"
                }
            }
        },
        {
            "match": {
                "uri": "/proxy/*"
            },

            "action": {
                "proxy": "http://192.168.0.100:80"
            }
        },
        {
            "match": {
                "uri": "/return/*"
            },

            "action": {
                "return": 301,
                "location": "https://www.example.com"
            }
        }
    ]
}
```

<a name="configuration-variables"></a>

## Variables {#configuration-variables-native}

Some options in Unit configuration allow the use ofvariables whose values are
calculated at runtime. There's a number of built-in variables available:

{{<bootstrap-table "table table-striped table-bordered">}}
| Variable                | Description                                                                                                                                                                                                                                       |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **arg_***, **cookie_***, **header_*** | Variables that store [request arguments, cookies, and header fields]({{< relref "/unit/configuration.md#configuration-routes-matching" >}}), such as **arg_queryTimeout**, **cookie_sessionId**, or **header_Accept_Encoding**. The names of the **header_*** variables are case insensitive. |
| **body_bytes_sent**      | Number of bytes sent in the response body.                                                                                                                                                                                                          |
| **dollar**               | Literal dollar sign (**$**), used for escaping.                                                                                                                                                                                                     |
| **header_referer**       | Contents of the **Referer** request [header field](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer).                                                                                                                         |
| **header_user_agent**    | Contents of the **User-Agent** request [header field](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent).                                                                                                                  |
| **host**                 | **Host** [header field](https://datatracker.ietf.org/doc/html/rfc9110#section-7.2), converted to lower case and normalized by removing the port number and the trailing period (if any).                                                   |
| **method**               | [Method](https://datatracker.ietf.org/doc/html/rfc7231#section-4) from the request line.                                                                                                                                                         |
| **remote_addr**          | Remote IP address of the request.                                                                                                                                                                                                                   |
| **request_id**           | Contains a string generated with random data. Can be used as a unique request identifier.                                                                                                                                                           |
| **request_line**         | Entire [request line](https://datatracker.ietf.org/doc/html/rfc9112#section-3).                                                                                                                                                                 |
| **request_time**         | Request processing time in milliseconds, formatted as follows: **1.234**.                                                                                                                                                                          |
| **request_uri**          | Request target [path](https://datatracker.ietf.org/doc/html/rfc3986#section-3.3) *including* the [query](https://datatracker.ietf.org/doc/html/rfc3986#section-3.4), normalized by resolving relative path references ("." and "..") and collapsing adjacent slashes. |
| **response_header_***    | Variables that store [response header fields]({{< relref "/unit/configuration.md#configuration-response-headers" >}}), such as **response_header_content_type**. The names of these variables are case insensitive.                                                                     |
| **status**               | HTTP [status code](https://datatracker.ietf.org/doc/html/rfc7231#section-6) of the response.                                                                                                                                                     |
| **time_local**           | Local time, formatted as follows: **31/Dec/1986:19:40:00 +0300**.                                                                                                                                                                                  |
| **uri**                  | Request target [path](https://datatracker.ietf.org/doc/html/rfc3986#section-3.3) *without* the [query](https://datatracker.ietf.org/doc/html/rfc3986#section-3.4) part, normalized by resolving relative path references ("." and "..") and collapsing adjacent slashes. The value is [percent decoded](https://datatracker.ietf.org/doc/html/rfc3986#section-2.1): Unit interpolates all percent-encoded entities in the request target [path](https://datatracker.ietf.org/doc/html/rfc3986#section-3.3). |
{{</bootstrap-table>}}

These variables can be used with:

- **pass** in
  [listeners]({{< relref "/unit/configuration.md#configuration-listeners" >}})
  and
  [actions]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
  to choose between routes, applications, app targets, or upstreams.
- **rewrite** in
  [actions]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
  to enable [URI rewriting]({{< relref "/unit/configuration.md#configuration-rewrite" >}}).
- **share** and **chroot** in
  [actions]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
  to control
  [static content serving]({{< relref "/unit/configuration.md#configuration-static" >}}).
- **location** in **return**
  [actions]({{< relref "/unit/configuration.md#configuration-return" >}})
  to enable HTTP redirects.
- **format** in the
  [access log]({{< relref "/unit/configuration.md#configuration-access-log" >}})
  to customize Unit's log output.

To reference a variable, prefix its name with the dollar sign character
(**\$**), optionally enclosing the name in curly brackets (**{}**) to separate it
from adjacent text or enhance visibility. Variable names can contain letters and
underscores (**\_**), so use the brackets if the variable is immediately followed
by such characters:

```json
{
    "listeners": {
        "*:80": {
            "pass": "routes/${method}_route",
            "comment_pass": "The method variable is thus separated from the '_route' postfix"
        }
    },

    "routes": {
        "GET_route": [
            {
                "action": {
                    "return": 201
                }
            }
        ],

        "PUT_route": [
            {
                "action": {
                    "return": 202
                }
            }
        ],

        "POST_route": [
            {
                "action": {
                    "return": 203
                }
            }
        ]
    }
}
```

To reference an **arg\_\***, **cookie\_\***, or **header\_\*** variable, add
the name you need to the prefix. A query string of **Type=car&Color=red**
yields two variables: **\$arg_Type** and **\$arg_Color**. Unit additionally
normalizes capitalization and hyphenation in header field names, so the
**Accept-Encoding** header field can also be referred to as **\$header_Accept_Encoding**,
**\$header_accept-encoding**, or **\$header_accept_encoding**.

{{< note >}}
With multiple argument instances (think **Color=Red&Color=Blue**),the rightmost
one is used (**Blue**).
{{< /note >}}

At runtime, variables expand into dynamically computed values (at your risk!).
The previous example targets an entire set of routes, picking individual
ones by HTTP verbs from the incoming requests:

```console
curl -i -X GET http://localhost

    HTTP/1.1 201 Created
```

```console
curl -i -X PUT http://localhost

    HTTP/1.1 202 Accepted
```

```console
curl -i -X POST http://localhost

    HTTP/1.1 203 Non-Authoritative Information
```

```console
curl -i --head http://localhost  # Bumpy ride ahead, no route defined

    HTTP/1.1 404 Not Found
```

If you reference a non-existing variable, it is considered empty.

<details>
<summary>Examples</summary>
<a name="variables-examples"></a>

This configuration selects the static file location based on the requested
hostname; if nothing's found, it attempts to retrieve the requested file
from a common storage:

```json
{
    "listeners": {
        "*:80": {
            "pass": "routes"
        }
    },

    "routes": [
        {
            "action": {
                "share": [
                    "/www/$host$uri",
                    "comment_share_1": "Note that the $uri variable value always includes a starting slash",
                    "/www/storage$uri"
                ]
            }
        }
    ]
}
```

Another use case is employing the URI to choose between applications:

```json
{
      "listeners": {
         "*:80": {
            "pass": "applications$uri"
         }
      },

      "applications": {
         "blog": {
            "root": "/path/to/blog_app/",
            "script": "index.php"
         },

         "sandbox": {
            "type": "php",
            "root": "/path/to/sandbox_app/",
            "script": "index.php"
         }
      }
}
```

This way, requests are routed between applications by their target URIs:

```console
curl http://localhost/blog     # Targets the 'blog' app
```

```console
curl http://localhost/sandbox  # Targets the 'sandbox' app
```

A different approach puts the **Host** header field received from the client
to the same use:

```json
{
      "listeners": {
         "*:80": {
            "pass": "applications/$host"
         }
      },

      "applications": {
         "localhost": {
            "root": "/path/to/admin_section/",
            "script": "index.php"
         },

         "www.example.com": {
            "type": "php",
            "root": "/path/to/public_app/",
            "script": "index.php"
         }
      }
}
```

You can use multiple variables in a string, repeating and placing them
arbitrarily. This configuration picks an app target (supported for
[PHP]({{< relref "/unit/configuration.md#configuration-php-targets" >}})
and [Python]({{< relref "/unit/configuration.md#configuration-python-targets" >}}))
based on the requested hostname and URI:


```json
{
      "listeners": {
         "*:80": {
            "pass": "applications/app_$host$uri"
         }
      }
}
```

Note that the $uri value doesn't include the request's query part.

At runtime,a request for **example.com/myapp** is passed to
**applications/app_example.com/myapp**.

To select a share directory based on an **app_session** cookie:

```json
{
      "action": {
         "share": "/data/www/$cookie_app_session"
      }
}
```

Here, if **$uri** in **share** resolves to a directory, the choice of an index
file to be served is dictated by **index**:

```json
{
      "action": {
         "share": "/www/data$uri",
         "index": "index.htm"
      }
}
```

Note that the $uri variable value always includes a starting slash.

Here, a redirect uses the **$request_uri** variable value to relay the
request, *including* the query part, to the same website over HTTPS:

```json
{
      "action": {
         "return": 301,
         "location": "https://$host$request_uri"
      }
}
```
---
</details>


## URI rewrite {#configuration-rewrite}

All route step [actions]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
support the **rewrite** option that updates the URI of the incoming request
before the action is applied. It does not affect the [query](https://datatracker.ietf.org/doc/html/rfc3986#section-3.4)
but changes the **uri** and **\$request_uri** [variables]({{< relref "/unit/configuration.md#configuration-variables-native" >}}).

This **match**-less action prefixes the request URI with **/v1** and returns
it to routing:

```json
{
    "action": {
        "rewrite": "/v1$uri",
        "pass": "routes"
    }
}
```

{{< warning >}}
Avoid infinite loops when you **pass** requests back to **routes**.
{{< /warning >}}

This action normalizes the request URI and passes it to an application:

```json
{
    "match": {
        "uri": [
            "/fancyAppA",
            "/fancyAppB"
        ]
    },

    "action": {
        "rewrite": "/commonBackend",
        "pass": "applications/backend"
    }
}
```

## Response headers {#configuration-response-headers}

All route step
[actions]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
support the **response_headers** option that updates the header fields of Unit's response
before the action is taken:

```json
{
    "action": {
        "share": "/www/static/$uri",
        "response_headers": {
            "Cache-Control": "max-age=60, s-maxage=120",
            "CDN-Cache-Control": "max-age=600"
        }
    }
}
```

This works only for the **2XX** and **3XX** responses;
also, **Date**, **Server**, and **Content-Length** can't be set.

The option sets given string values for the header fields of the response
that Unit will send for the specific request:

- If there's no header field associated with the name (regardless of the case),
  the value is set.
- If a header field with this name is already set, its value is updated.
- If **null** is supplied for the value, the header field is *deleted*.

If the action is taken and Unit issues a response, it sends the header
fields *this specific* action specifies. Only the last action along the
entire routing path of a request affects the resulting response headers.

The values support [variables]({{< relref "/unit/configuration.md#configuration-variables-native" >}})
and [template literals]({{< relref "/unit/scripting.md" >}}), which enables
arbitrary runtime logic:

```json
"response_headers": {
    "Content-Language": "`${ uri.startsWith('/uk') ? 'en-GB' : 'en-US' }`"
}
```

Finally, there are the **response_header\_\*** variables that evaluate to the
header field values set with the response (by the app, upstream, or Unit
itself; the latter is the case with **\$response_header_connection**,
**\$response_header_content_length**, and **\$response_header_transfer_encoding**).

One use is to update the headers in the final response; this extends the
**Content-Type** issued by the app:


```json
"action": {
    "pass": "applications/converter",
        "response_headers": {
            "Content-Type": "${response_header_content_type};charset=iso-8859-1"
        }
    }
}
```

Alternatively, they will come in handy with
[custom log formatting]({{< relref "/unit/configuration.md#configuration-access-log" >}}).


## Instant responses, redirects {#configuration-return}

You can use route step
[actions]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
to instantly handle certain conditions with arbitrary
[HTTP status codes](https://datatracker.ietf.org/doc/html/rfc7231#section-6):

```json
{
    "match": {
        "uri": "/admin_console/*"
    },

    "action": {
        "return": 403
    }
}
```

The **return** action provides the following options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option      | Description                                                                                                                |
|-------------|----------------------------------------------------------------------------------------------------------------------------|
| **return**  | (required)<br>Integer (000–999); defines the HTTP response status code to be returned.                                      |
| **location**| String URI; used if the **return** value implies redirection.                                                               |

{{</bootstrap-table>}}


Use the codes according to their intended [semantics](https://datatracker.ietf.org/doc/html/rfc7231#section-6);
if you use custom codes, make sure that user agents can understand them.

If you specify a redirect code (3xx), supply the destination using the
**location** option alongside **return**:

```json
{
    "action": {
        "return": 301,
        "location": "https://www.example.com"
    }
}
```

Besides enriching the response semantics, **return** simplifies
[allow-deny lists]({{< relref "/unit/configuration.md#allow-deny" >}}):
instead of guarding each action with a filter, add [conditions]({{< relref
"/unit/configuration.md#configuration-routes-matching" >}}) to deny unwanted
requests as early as possible, for example:


```json
"routes": [
    {
        "match": {
            "scheme": "http"
        },

        "action": {
            "return": 403
        }
    },
    {
        "match": {
            "source": [
                "!192.168.1.1",
                "!10.1.1.0/16",
                "192.168.1.0/24",
                "2001:0db8::/32"
            ]
        },

        "action": {
            "return": 403
        }
    }
]
```

## Static files {#configuration-static}

Unit is capable of acting as a standalone web server, efficiently serving
static files from the local file system; to use the feature, list the file
paths in the **share** option of a route step [action]({{< relref
"/unit/configuration.md#configuration-routes-action" >}}).


A **share**-based action provides the following options:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option              | Description            |
|---------------------|------------------------|
| **share** (required) | String or an array of strings; lists file paths that are tried until a file is found. When no file is found, **fallback** is used if set.<br><br> The value is [variable]({{< relref "/unit/configuration.md#configuration-variables" >}})-interpolated.    |
| **index**            | Filename; tried if **share** is a directory. When no file is found, **fallback** is used if set.<br><br> The default is **index.html**.                |
| **fallback**         | Action-like [object]({{< relref "/unit/configuration.md#configuration-fallback" >}}); used if the request can't be served by **share** or **index**. |
| **types**            | [Array]({{< relref "/unit/configuration.md#configuration-share-mime" >}}) of [MIME type](https://www.iana.org/assignments/media-types/media-types.xhtml) patterns; used to filter the shared files.     |
| **chroot**           | Directory pathname that [restricts]({{< relref "/unit/configuration.md#configuration-share-path" >}}) the shareable paths. <br><br> The value is [variable]({{< relref "/unit/configuration.md#configuration-variables" >}})-interpolated.                                            |
| **follow_symlinks**, **traverse_mounts** | Booleans; turn on and off symbolic link and mount point [resolution]({{< relref "/unit/configuration.md#configuration-share-resolution">}}) respectively; if **chroot** is set, they only [affect]({{< relref "/unit/configuration.md#configuration-share-path" >}}) the insides of **chroot**. <br><br> The default for both options is **true** (resolve links and mounts). |

{{</bootstrap-table>}}


{{< note >}}
To serve the files, Unit's router process must be able to access them;
thus, the account this process runs as must have proper permissions
[assigned]({{< relref "/unit/configuration.md#security-apps" >}}). When
Unit is installed from the [official packages]({{< relref
"/unit/installation.md#installation-precomp-pkgs" >}}), the process runs
as **unit:unit**; for details of other installation methods, see
[installation]({{< relref "/unit/installation/">}}).
{{< /note >}}

Consider the following configuration:

```json
{
    "listeners": {
        "*:80": {
            "pass": "routes"
        }
     },

    "routes": [
        {
            "action": {
                "share": "/www/static/$uri"
            }
        }
    ]
}
```

It uses
[variable interpolation]({{< relref "/unit/configuration.md#configuration-variables-native" >}}):
Unit replaces the **\$uri** reference with its current value and tries the
resulting path. If this doesn't yield a servable file, a 404 "Not Found"
response is returned.


{{< warning >}}
Before version 1.26.0, Unit used **share** as the document root. This was
changed for flexibility, so now **share** must resolve to specific files.
A common solution is to append **\$uri** to your document root.

Pre-1.26, the snippet above would've looked like this:

```json
"action": {
    "share": "/www/static/"
}
```

Mind that URI paths always start with a slash, so there's no need to separate
the directory from **\$uri**; even if you do, Unit compacts adjacent slashes
during path resolution, so there won't be an issue.
{{< /warning >}}

If **share** is an array, its items are searched in order of appearance
until a servable file is found:

```json
"share": [
    "/www/$host$uri",
    "/www/error_pages/not_found.html"
]
```

This snippet tries a **\$host**-based directory first; if a suitable file
isn't found there, the **not_found.html** file is tried. If neither is
accessible, a 404 "Not Found" response is returned.

Finally, if a file path points to a directory, Unit attempts to serve an
**index**-indicated file from it. Suppose we have the following directory
structure and share configuration:


```none
/www/static/
├── ...
└──default.html
```

```json
"action": {
    "share": "/www/static$uri",
    "index": "default.html"
}
```

The following request returns **default.html** even though the file isn't named
explicitly:

```console
curl http://localhost/ -v

   ...
   < HTTP/1.1 200 OK
   < Last-Modified: Fri, 20 Sep 2021 04:14:43 GMT
   < ETag: "5d66459d-d"
   < Content-Type: text/html
   < Server: Unit/{{< param "unitversion" >}}
   ...
```

{{< note >}}
Unit's ETag response header fields use the **MTIME-FILESIZE** format, where
**MTIME** stands for file modification timestamp and **FILESIZE** stands for
file size in bytes, both in hexadecimal.
{{< /note >}}

### MIME filtering {#configuration-share-mime}

To filter the files a **share** serves by their [MIME types](https://www.iana.org/assignments/media-types/media-types.xhtml),
define a **types** array of string patterns. They work like [route patterns]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns" >}})
but are compared to the MIME type of each file; the request is served only if
it's a [match]({{< relref "/unit/configuration.md#configuration-routes-matching-resolution" >}}):


```json
{
    "share": "/www/data/static$uri",
    "types": [
        "!text/javascript",
        "!text/css",
        "text/*",
        "~video/3gpp2?"
    ]
}
```

This sample configuration blocks JS and CSS files with
[negation]({{< relref "/unit/configuration.md#configuration-routes-matching-resolution" >}})
but allows all other text-based MIME types with a
[wildcard pattern]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns" >}}).
Additionally, the **.3gpp** and **.3gpp2** file types are allowed by a
[regex pattern]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns" >}}).

If no MIME types match the request, a 403 "Forbidden" response is returned. You
can pair that behavior with a
[fallback]({{< relref "/unit/configuration.md#configuration-fallback" >}}) option that will be called
when a 40x response would be returned.

```json
{
    "share": "/www/data/static$uri",
    "types": ["image/*", "font/*", "text/*"],
    "response_headers": {
        "Cache-Control": "max-age=1209600"
    },
    "fallback": {
        "share": "/www/data/static$uri",
    }
}
```

Here, all requests to images, fonts, and any text-based files will have a
cache control header added to the response. Any other requests will still
serve the files, but this time without the header. This is useful for
serving common web page resources that do not change; web browsers and
proxies are informed that this content should be cached.

If the MIME type of a requested file isn't recognized, it's considered
empty (**""**). Thus, the **"!"** pattern ("deny empty strings") can be
used to restrict all file types [unknown]({{< relref "/unit/configuration.md#configuration-mime" >}})
to Unit:


```json
{
    "share": "/www/data/known-types-only$uri",
    "types": [
        "!"
    ]
}
```

If a share path specifies only the directory name, Unit *doesn't* apply MIME filtering.

### Path restrictions {#configuration-share-path}

{{< note >}}
To have these options, Unit must be built and run on a system with Linux kernel
version 5.6+.
{{< /note >}}

The **chroot** option confines the path resolution within a share to a
certain directory. First, it affects symbolic links: any attempts to go up
the directory tree with relative symlinks like **../../var/log** stop at
the **chroot** directory, and absolute symlinks are treated as relative
to this directory to avoid breaking out:


```json
{
    "action": {
        "share": "/www/data$uri",
        "chroot": "/www/data/",
        "comment_chroot": "Now, any paths accessible via the share are confined to this directory"
    }
}
```

Here, a request for **/log** initially resolves to **/www/data/log**; however,
if that's an absolute symlink to **/var/log/app.log**, the resulting path
is **/www/data/var/log/app.log**.

Another effect is that any requests for paths that resolve outside the
**chroot** directory are forbidden:


```json
{
    "action": {
        "share": "/www$uri",
        "chroot": "/www/data/"
    }
}
```

Now, any paths accessible via the share are confined to the `/www/data/` directory

Here, a request for **/index.xml** elicits a 403 "Forbidden" response
because it resolves to **/www/index.xml**, which is outside **chroot**.

<a name="configuration-share-resolution"></a>

The **follow_symlinks** and **traverse_mounts** options disable resolution
of symlinks and traversal of mount points when set to **false** (both default
to **true**):


```json
{
    "action": {
        "share": "/www/$host/static$uri",
        "follow_symlinks": false,
        "comment_follow_symlinks": "Disables symlink traversal",
        "traverse_mounts": false,
        "comment_traverse_mounts": "Disables mount point traversal"
    }
}
```

Here, any symlink or mount point in the entire **share** path results in a
403 "Forbidden" response.

With **chroot** set, **follow_symlinks** and **traverse_mounts** only affect
portions of the path *after* **chroot**:


```json
{
    "action": {
        "share": "/www/$host/static$uri",
        "chroot": "/www/$host/",
        "follow_symlinks": false,
        "traverse_mounts": false
    }
}
```

Here, **www/** and interpolated **\$host** can be symlinks or mount points,
but any symlinks and mount points beyond them, including the **static/**
portion, won't be resolved.

<details>
<summary>Details</summary>

<a name="chroot-details"></a>

Suppose you want to serve files from a share  that itself includes a symlink
(let's assume **$host** always resolves to **localhost** and make it a symlink
in our example) but disable any symlinks inside the share.

Initial configuration:

```json
{
      "action": {
         "share": "/www/$host/static$uri",
         "chroot": "/www/$host/",
         "comment_chroot": "Now, any paths accessible via the share are confined to this directory"
      }
}
```

Create a symlink to **/www/localhost/static/index.html**:

```console
mkdir -p /www/localhost/static/ && cd /www/localhost/static/
```

```console
cat > index.html << EOF
   > index.html
   > EOF
```

```console
ln -s index.html /www/localhost/static/symlink
```

If symlink resolution is enabled (with or without **chroot**), a request that
targets the symlink works:

```console
curl http://localhost/index.html

   index.html
```

```console
curl http://localhost/symlink

   index.html
```

Now set **follow_symlinks** to **false**:

```json
{
"action": {
   "share": "/www/$host/static$uri",
   "chroot": "/www/$host/",
   "comment_chroot": "Now, any paths accessible via the share are confined to this directory",
   "follow_symlinks": false
}
}
```

The symlink request is forbidden, which is presumably the desired effect:

```console
curl http://localhost/index.html

   index.html
```

```console
curl http://localhost/symlink

   <!DOCTYPE html><title>Error 403</title><p>Error 403.
```

Finally, what difference does **chroot** make? To see, remove it:

```json
{
   "action": {
      "share": "/www/$host/static$uri",
      "follow_symlinks": false
   }
}
```

Now, **"follow_symlinks": false** affects the entire share, and **localhost**
is a symlink, so it's forbidden:

```console
curl http://localhost/index.html

   <!DOCTYPE html><title>Error 403</title><p>Error 403.
```

---
</details>

### Fallback action {#configuration-fallback}

Finally, within an **action**, you can supply a **fallback** option beside
a **share**. It specifies the [action]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
to be taken if the requested file can't be served from the **share** path:


```json
{
    "share": "/www/data/static$uri",
    "fallback": {
        "pass": "applications/php"
    }
}
```

Serving a file can be impossible for different reasons, such as:

- The request's HTTP method isn't **GET** or **HEAD**.
- The file's MIME type doesn't match the **types**
  [array]({{< relref "/unit/configuration.md#configuration-share-mime" >}}).
- The file isn't found at the **share** path.
- The router process has
  [insufficient permissions]({{< relref "/unit/configuration.md#security-apps" >}})
  to access the file or an underlying directory.

In the previous example, an attempt to serve the requested file from the
**/www/data/static/** directory is made first. Only if the file can't be
served, the request is passed to the **php** application.

If the **fallback** itself is a **share**, it can also contain a nested
**fallback**:


```json
{
    "share": "/www/data/static$uri",
    "fallback": {
        "share": "/www/cache$uri",
        "chroot": "/www/",
        "fallback": {
            "proxy": "http://127.0.0.1:9000"
        }
    }
}
```

The first **share** tries to serve the request from **/www/data/static/**;
on failure, the second **share** tries the **/www/cache/** path with
**chroot** enabled. If both attempts fail, the request is proxied elsewhere.

<details>
<summary>Examples</summary>

<a name="conf-variable-examples"></a>

One common use case that this feature enables is the separation of requests
for static and dynamic content into independent routes. The following example
relays all requests that target **.php** files to an application and uses a
catch-all static **share** with a **fallback**:

```json
{
      "routes": [
         {
            "match": {
                  "uri": "*.php"
            },

            "action": {
                  "pass": "applications/php-app"
            }
         },
         {
            "action": {
                  "share": "/www/php-app/assets/files$uri",
                  "fallback": {
                     "proxy": "http://127.0.0.1:9000"
                  }
            }
         }

      ],

      "applications": {
         "php-app": {
            "type": "php",
            "root": "/www/php-app/scripts/"
         }
      }
}
```

You can reverse this scheme for apps that avoid filenames in dynamic URIs,
listing all types of static content to be served from a **share** in a
**match** condition and adding an unconditional application path:

```json
{
      "routes": [
         {
            "match": {
                  "uri": [
                     "*.css",
                     "*.ico",
                     "*.jpg",
                     "*.js",
                     "*.png",
                     "*.xml"
                  ]
            },

            "action": {
                  "share": "/www/php-app/assets/files$uri",
                  "fallback": {
                     "proxy": "http://127.0.0.1:9000"
                  }
            }
         },
         {
            "action": {
                  "pass": "applications/php-app"
            }
         }

      ],

      "applications": {
         "php-app": {
            "type": "php",
            "root": "/www/php-app/scripts/"
         }
      }
}
```

If image files should be served locally and other proxied, use the **types**
array in the first route step:


```json
{
      "match": {
         "uri": [
            "*.css",
            "*.ico",
            "*.jpg",
            "*.js",
            "*.png",
            "*.xml"
         ]
      },

      "action": {
         "share": "/www/php-app/assets/files$uri",
         "types": [
            "image/*"
         ],

         "fallback": {
            "proxy": "http://127.0.0.1:9000"
         }
      }
}
```

Another way to combine **share**, **types**, and **fallback**
is exemplified by the following compact pattern:

```json
{
      "share": "/www/php-app/assets/files$uri",
      "types": [
         "!application/x-httpd-php"
      ],

      "fallback": {
         "pass": "applications/php-app"
      }
}
```

It forwards explicit requests for PHP files to the app while serving all
other types of files from the share; note that a **match** object isn't
needed here to achieve this effect.

---
</details>


## Proxying {#configuration-proxy}

Unit's routes support HTTP proxying to socket addresses using the **proxy**
option of a route step [action]({{< relref "/unit/configuration.md#configuration-routes-action" >}}):

```json
{
    "routes": [
        {
            "match": {
                "uri": "/ipv4/*"
            },
            "action": {
                "proxy": "http://127.0.0.1:8080",
                "comment_proxy": "Note that the http:// scheme is required"
            }
        },
        {
            "match": {
                "uri": "/ipv6/*"
            },
            "action": {
                "proxy": "http://[::1]:8080",
                "comment_proxy": "Note that the http:// scheme is required"
            }
        },
        {
            "match": {
                "uri": "/unix/*"
            },
            "action": {
                "proxy": "http://unix:/path/to/unix.sock",
                "comment_proxy": "Note that the http:// scheme is required, followed by the unix: prefix"
            }
        }
    ]
}
```

As the example suggests, you can use UNIX, IPv4, and IPv6 socket addresses
for proxy destinations.

{{< note >}}
The HTTPS scheme is not supported yet.
{{< /note >}}

### Load balancing {#configuration-upstreams}

Besides proxying requests to individual servers, Unit can also relay incoming
requests to *upstreams*. An upstream is a group of servers that comprise a single
logical entityand may be used as a **pass** destination for incoming requests in a
[listener]({{< relref "/unit/configuration.md#configuration-listeners" >}})
or a [route]({{< relref "/unit/configuration.md#configuration-routes" >}}).

Upstreams are defined in the eponymous **/config/upstreams** section of the API:

```json
{
   "listeners": {
      "*:80": {
         "pass": "upstreams/rr-lb"
      }
   },
   "upstreams": {
      "rr-lb": {
         "comment_rr-lb": "Upstream object",
         "servers": {
            "comment_servers": "Lists individual servers as object-valued options",
            "192.168.0.100:8080": {
               "comment_192.168.0.100:8080": "Empty object needed due to JSON requirements"
            },
            "192.168.0.101:8080": {
               "weight": 0.5
            }
         }
      }
   }
}
```

An upstream must define a **servers** object that lists socket addresses as
server object names. Unit dispatches requests between the upstream's servers
in a round-robin fashion, acting as a load balancer. Each server object can
set a numeric **weight** to adjust the share of requests it receives via the
upstream. In the above example, **192.168.0.100:8080** receives twice as many
requests as **192.168.0.101:8080**.

Weights can be specified as integers or fractions in decimal or scientific
notation:


```json
{
    "servers": {
        "192.168.0.100:8080": {
            "weight": 1e1,
            "comment_weight": "All three values are equal"
        },
        "192.168.0.101:8080": {
            "weight": 10.0,
            "comment_weight": "All three values are equal"
        },
        "192.168.0.102:8080": {
            "weight": 10,
            "comment_weight": "All three values are equal"
        }
    }
}
```

The maximum weight is **1000000**, the minimum is **0** (such servers receive
no requests); the default is **1**.


## Applications {#configuration-applications}

Each app that Unit runs is defined as an object in the **/config/applications**
section of the control API; it lists the app's language and settings, its
runtime limits, process model, and various language-specific options.

{{< note >}}
Our official
[language-specific packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
include end-to-end examples of application configuration, available for your
reference at **/usr/share/doc/\<module name>/examples/** after package installation.
{{< /note >}}

Here, Unit runs 20 processes of a PHP app called **blogs**, stored in the
**/www/blogs/scripts/** directory:

```json
{
    "blogs": {
        "type": "php",
        "processes": 20,
        "root": "/www/blogs/scripts/"
    }
}
```

<a name="configuration-apps-common"></a>
App objects have a number of options shared between all application languages:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option           | Description                                                                                                                                                                                                                                                                                         |
|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **type** (required)   | Application type: **external** (Go and Node.js), **java**, **perl**, **php**, **python**, **ruby**, or **wasm** (WebAssembly).<br><br>Except for **external** and **wasm**, you can detail the runtime version: **"type": "python 3"**, **"type": "python 3.4"**, or even **"type": "python 3.4.9rc1"**.<br><br>Unit searches its modules and uses the latest matching one, reporting an error if none match.<br><br>For example, if you have only one PHP module, 7.1.9, it matches **"php"**, **"php 7"**, **"php 7.1"**, and **"php 7.1.9"**.<br><br>If you have modules for versions 7.0.2 and 7.0.23, set **"type": "php 7.0.2"** to specify the former; otherwise, PHP 7.0.23 will be used. |
| **environment**      | String-valued object; environment variables to be passed to the app.<br><br>Unit passes the environment variables to the app without modification, even if no environment configuration object is specified.<br><br>Any data specified in the **environment** object gets merged to the existing environment variables.<br><br>If an environment variable already exists in the system and gets declared in this object, the object's value takes precedence and gets passed to the application. |
| **group**            | String; group name that runs the [app process]({{< relref "/unit/howto/security.md#sec-processes" >}}).<br><br>The default is the **user**'s primary group.                                                                                                                                  |
| **isolation**        | Object; manages the isolation of an application process.<br><br>For details, see [here]({{< relref "/unit/configuration.md#configuration-proc-mgmt-isolation" >}}).                                                                                                                                                  |
| **limits**           | Object; accepts two integer options, **timeout** and **requests**.<br><br>Their values govern the life cycle of an application process.<br><br>For details, see [here]({{< relref "/unit/configuration.md#configuration-proc-mgmt-lmts" >}}).                                                                                                                                                                        |
| **processes**        | Integer or object; integer sets a static number of app processes, and object options **max**, **spare**, and **idle_timeout** enable dynamic management.<br><br>For details, see [here]({{< relref "/unit/configuration.md#configuration-proc-mgmt-prcs" >}}).<br><br>The default is 1.                                                                                              |
| **stderr**, **stdout** | Strings; filenames where Unit redirects the application's output.<br><br>The default when running *with* **--no-daemon** is to send *stdout* to the *console* and *stderr* to Unit's *log*.<br><br>The default when running *without* **--no-daemon** is to send *stdout* to */dev/null* and *stderr* to Unit's *log*.<br><br>These options have *no* effect when running with **--no-daemon**. |
| **user**             | String; username that runs the [app process]({{< relref "/unit/howto/security.md#sec-processes" >}}).<br><br>The default is the username configured at [build time]({{< relref "/unit/howto/source.md#source-config-src" >}}) or at [startup]({{< relref "/unit/howto/source.md#source-startup" >}}).            |
| **working_directory** | String; the app's working directory.<br><br>The default is the working directory of Unit's [main process]({{< relref "/unit/howto/security.md#sec-processes" >}}).                                                                                                                                                       |

{{</bootstrap-table>}}

Also, you need to set **type**-specific options
to run the app. This
[Python app]({{< relref "/unit/configuration.md#configuration-python" >}})
sets **path** and **module**:

```json
{
    "type": "python 3.6",
    "processes": 16,
    "working_directory": "/www/python-apps",
    "path": "blog",
    "module": "blog.wsgi",
    "user": "blog",
    "group": "blog",
    "environment": {
        "DJANGO_SETTINGS_MODULE": "blog.settings.prod",
        "DB_ENGINE": "django.db.backends.postgresql",
        "DB_NAME": "blog",
        "DB_HOST": "127.0.0.1",
        "DB_PORT": "5432"
    }
}
```

### Process management {#configuration-proc-mgmt}

Unit has three per-app options that control how the app's processes behave:
**isolation**, **limits**, and **processes**. Also, you can **GET** the
**/control/applications/** section of the API to restart an app:


```console
# curl -X GET --unix-socket /path/to/control.unit.sock  \ # Path to Unit's control socket in your installation
      http://localhost/control/applications/app_name/restart # Your application's name as defined in the /config/applications/ section
```

Unit handles the rollover gracefully, allowing the old processes to deal
with existing requests and starting a new set of processes (as defined by
the **processes** [option]({{< relref "/unit/configuration.md#configuration-proc-mgmt-prcs" >}}))
to accept new requests.



#### Process isolation {#configuration-proc-mgmt-isolation}

You can use
[namespace](https://man7.org/linux/man-pages/man7/namespaces.7.html)
and
[file system](https://man7.org/linux/man-pages/man2/chroot.2.html)
isolation for your apps if Unit's underlying OS supports them:

```console
ls /proc/self/ns/

    cgroup mnt \ # The mount namespace
    net \ # The network namespace
    pid ... \
    user \ # The credential namespace
    uts \ # The uname namespace
```

The **isolation** application option has the following members:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option            | Description                                                                                                                                                                                                                                                                                                                                                                      |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **automount**      | Object; controls mount behavior if **rootfs** is enabled. By default, Unit automatically mounts the [language runtime dependencies]({{< relref "/unit/configuration.md#conf-rootfs" >}}), a [procfs](https://man7.org/linux/man-pages/man5/procfs.5.html) at **/proc/**, and a [tmpfs](https://man7.org/linux/man-pages/man5/tmpfs.5.html) at **/tmp/**, but you can [disable]({{< relref "/unit/configuration.md#disable-automounts" >}}) any of these default mounts. |
| **cgroup**         | Object; defines the app's [cgroup]({{< relref "/unit/configuration.md#conf-app-cgroup" >}}).<br><br>  **Options:**<br><br>&nbsp;&nbsp; - **path** (required): String; configures absolute or relative path of the app in the [cgroups v2 hierarchy](https://man7.org/linux/man-pages/man7/cgroups.7.html#CGROUPS_VERSION_2). The limits trickle down the hierarchy, so child cgroups can't exceed parental thresholds.                                                                                                                        |
| **gidmap**         | Same as **uidmap**, but configures group IDs instead of user IDs.                                                                                                                                                                                                                                                                                                               |
| **namespaces**     | Object; configures [namespace](https://man7.org/linux/man-pages/man7/namespaces.7.html) isolation scheme for the application.<br><br>  **Options (system-dependent; check your OS manual for guidance):**<br><br>&nbsp;&nbsp; - **cgroup**: Creates a new cgroup namespace for the app. <br><br>&nbsp;&nbsp; - **credential**: Creates a new user namespace for the app. <br><br>&nbsp;&nbsp; - **mount**: Creates a new mount namespace for the app. <br><br> &nbsp;&nbsp; - **network**: Creates a new network namespace for the app. <br><br>&nbsp;&nbsp; - **pid**: Creates a new PID namespace for the app. <br><br>&nbsp;&nbsp; - **uname**: Creates a new UTS namespace for the app.                                                                                                                                                                                                                  |
|                   |                   |                   | All options listed above are Boolean; to isolate the app, set the corresponding namespace option to **true**; to disable isolation, set the option to **false** (default).                                                                                                                                                            |
| **rootfs**         | String; pathname of the directory to be used as the new [file system root]({{< relref "/unit/configuration.md#conf-rootfs">}}) for the app.                                                                                                                                                                                                                                                                |
| **uidmap**         | Array of user ID [mapping objects]({{< relref "/unit/configuration.md#conf-uidgid-mapping" >}}); each array item must define the following:<br><br>- **container**: Integer; starts the user ID mapping range in the app's namespace.<br><br>- **host**: Integer; starts the user ID mapping range in the OS namespace.<br><br>- **size**: Integer; size of the ID range in both namespaces.                                                                                                                                                                                                                                                                       |
{{</bootstrap-table>}}

To disable automounts:
<a name="disable-automounts"></a>


```json
{
    "isolation": {
        "automount": {
            "procfs": false,
            "tmpfs": false
        }
    }
}
```




A sample **isolation** object that enables all namespaces and sets mappings for
user and group IDs:

```json
{
    "namespaces": {
        "cgroup": true,
        "credential": true,
        "mount": true,
        "network": true,
        "pid": true,
        "uname": true
    },

    "cgroup": {
        "path": "/unit/appcgroup"
    },

    "uidmap": [
        {
            "host": 1000,
            "container": 0,
            "size": 1000
        }
    ],

    "gidmap": [
        {
            "host": 1000,
            "container": 0,
            "size": 1000
        }
    ]
}
```

##### Using control groups {#conf-app-cgroup}

A control group (cgroup) commands the use of computational resources by a
group of processes in a unified hierarchy. Cgroups are defined by their
*paths* in the cgroups file system.

The **cgroup** object defines the cgroup for a Unit app; its **path** option
can set an absolute (starting with **/**) or a relative value. If the path
doesn't exist in the cgroups file system, Unit creates it.

Relative paths are implicitly placed inside the cgroup of Unit's
[main process]({{< relref "/unit/howto/security.md#sec-processes" >}});
this setting effectively puts the app to the **/\<main Unit process cgroup>/production/app**
cgroup:

```json
{
    "isolation": {
        "cgroup": {
            "path": "production/app"
        }
    }
}
```

An absolute pathname places the application under a separate cgroup subtree;
this configuration puts the app under **/staging/app**:

```json
{
    "isolation": {
        "cgroup": {
            "path": "/staging/app"
        }
    }
}
```

A basic use case would be to set a memory limit on a cgroup.
First, find the cgroup mount point:

```console
mount -l | grep cgroup

    cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot)
```

Next, check the available controllers and set the **memory.high** limit:

```console
cat /sys/fs/cgroup/staging/app/cgroup.controllers # cgroup's path set in Unit configuration

    cpuset cpu io memory pids
```

As root, run the following command:

```console
echo 1G > /sys/fs/cgroup/staging/app/memory.high # cgroup's path set in Unit configuration
```

For more details and possible options,refer to the
[admin guide](https://docs.kernel.org/admin-guide/cgroup-v2.html).

{{< note >}}
To avoid confusion, mind that the **namespaces/cgroups** option
controls the application's cgroup *namespace*; instead, the **cgroup/path** option
specifies the cgroup where Unit puts the application.
{{< /note >}}

##### Changing root directory {#conf-rootfs}

The **rootfs** option confines the app to the directory you provide, making
it the new [file system root](https://man7.org/linux/man-pages/man2/chroot.2.html).
To use it, your app should have the corresponding privilege (effectively, run
as **root** in most cases).

The root directory is changed before the language module starts the app, so
any path options for the app should be relative to the new root. Note the
**path** and **home** settings:


```json
{
    "type": "python 2.7",
    "path": "/",
    "comment_path": "Without rootfs, this would be /var/app/sandbox/",
    "home": "/venv/",
    "comment_home": "Without rootfs, this would be /var/app/sandbox/venv/",
    "module": "wsgi",
    "isolation": {
        "rootfs": "/var/app/sandbox/"
    }
}
```

{{< warning >}}
When using **rootfs** with **credential** set to **true**:

```json
"isolation": {
    "rootfs": "/var/app/sandbox/",
    "namespaces": {
        "credential": true
    }
}
```

Ensure that the user the app *runs as* can access the **rootfs** directory.
{{< /warning >}}

Unit mounts language-specific files and directories to the new root
so the app stays operational:

{{<bootstrap-table "table table-striped table-bordered">}}
| Language         | Language-Specific Mounts                                                                                                                                                                                                                                                                                                           |
|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Java**         | - JVM's **libc.so** directory<br><br> - Java module's [home]({{< relref "/unit/howto/source.md#modules-java" >}}) directory                                                                                                                                   |
| **Python**       | Python's **sys.path** [directories](https://docs.python.org/3/library/sys.html#sys.path)                                                                                                                                                                                                                                        |
| **Ruby**         | - Ruby's header, interpreter, and library [directories](https://idiosyncratic-ruby.com/42-ruby-config.html): **rubyarchhdrdir**, **rubyhdrdir**, **rubylibdir**, **rubylibprefix**, **sitedir**, and **topdir**<br><br> - Ruby's gem installation directory (**gem env gemdir**)<br><br> - Ruby's entire gem path list (**gem env gempath**) |
{{</bootstrap-table>}}


<details>
<summary>Using "uidmap", "gidmap"</summary>
<a name="conf-uidgid-mapping"></a>

The **uidmap** and **gidmap** options are available only if the underlying OS
supports [user namespaces](https://man7.org/linux/man-pages/man7/user_namespaces.7.html)

If **uidmap** is omitted but **credential** isolation is enabled,the effective
UID (EUID) of the application process in the host namespace is mapped to the
same UID in the container namespace; the same applies to **gidmap** and GID,
respectively. This means that the configuration below:

```json
{
      "user": "some_user",
      "isolation": {
         "namespaces": {
            "credential": true
         }
      }
}
```

Is equivalent to the following (assuming **some_user**'s EUID and EGID are
both equal to 1000):

```json
{
      "user": "some_user",
      "isolation": {
         "namespaces": {
            "credential": true
         },

         "uidmap": [
            {
                  "host": "1000",
                  "container": "1000",
                  "size": 1
            }
         ],

         "gidmap": [
            {
                  "host": "1000",
                  "container": "1000",
                  "size": 1
            }
         ]
      }
}
```
---
</details>

#### Request limits {#configuration-proc-mgmt-lmts}

The **limits** object controls request handling by the app process and has two
integer options:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option      | Description                                                                                                                                                                                                                                                                                                                                                  |
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **requests** | Integer; maximum number of requests an app process can serve. When the limit is reached, the process restarts; this mitigates possible memory leaks or other cumulative issues.                                                                                                                                                                               |
| **timeout**  | Integer; request timeout in seconds. If an app process exceeds it while handling a request, Unit cancels the request and returns a 503 "Service Unavailable" response to the client.<br><br> <i class="fa-solid fa-triangle-exclamation" style="color: orange"></i> Unit doesn't detect freezes, so the hanging process stays on the app's process pool. |
{{</bootstrap-table>}}


#### Example:

```json
{
    "type": "python",
    "working_directory": "/www/python-apps",
    "module": "blog.wsgi",
    "limits": {
        "timeout": 10,
        "requests": 1000
    }
}
```

#### Application processes {#configuration-proc-mgmt-prcs}

The **processes** option offers a choice between static and dynamic process
management. If you set it to an integer, Unit immediately launches the given
number of app processes and keeps them without scaling.

To enable a dynamic prefork model for your app, supply a **processes** object
with the following options:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option        | Description                                                                                                                                                                                                                                                                                                            |
|---------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **idle_timeout** | Number of seconds Unit waits for before terminating an idle process that exceeds **spare**.                                                                                                                                                                                                                         |
| **max**         | Maximum number of application processes that Unit maintains (busy and idle).<br><br> The default is 1.                                                                                                                                                                                                               |
| **spare**       | Minimum number of idle processes that Unit tries to maintain for an app. When the app is started, **spare** idles are launched; Unit passes new requests to existing idles, forking new idles to keep the **spare** level if **max** allows. When busy processes complete their work and turn idle again, Unit terminates extra idles after **idle_timeout**. |
{{</bootstrap-table>}}

If **processes** is omitted entirely, Unit creates 1 static process. If an
empty object is provided: **"processes": {}**, dynamic behavior with default
option values is assumed.

Here, Unit allows 10 processes maximum, keeps 5 idles, and terminates extra
idles after 20 seconds:


```json
{
    "max": 10,
    "spare": 5,
    "idle_timeout": 20
}
```

{{< note >}}
For details of manual application process restart, see the
[process management]({{< relref "/unit/configuration.md#configuration-proc-mgmt" >}})
documentation.
{{< /note >}}

<a name="configuration-languages"></a>

### Go {#configuration-go}

To run a Go app on Unit, modify its source to make it Unit-aware and rebuild
the app.

<details>
<summary>Updating Go apps to run on Unit</summary>

<a name="updating-go-apps"></a>

Unit uses [cgo](https://pkg.go.dev/cmd/cgo) to invoke C code from Go,
so check the following prerequisites:

- The `CGO_ENABLED` variable is set to **1**:

   ```console
   go env CGO_ENABLED

         0
   ```

   ```console
   go env -w CGO_ENABLED=1
   ```

- If you installed Unit from the
   [official packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}),
   install the development package:

   - Debian, Ubuntu

      ```console
      apt install unit-dev
      ```

   - Amazon, Fedora, RHEL

      ```console
      yum install unit-devel
      ```

- If you installed Unit from
   [source]({{< relref "/unit/howto/source/" >}}),
   install the include files and libraries:

   ```console
   make libunit-install
   ```

In the **import** section, list the **unit.nginx.org/go** package:

```go
import (
      ...
      "unit.nginx.org/go"
      ...
)
```

Replace the **http.ListenAndServe** call with **unit.ListenAndServe**:

```go
func main() {
      ...
      http.HandleFunc("/", handler)
      ...
      // http.ListenAndServe(":8080", nil)
      unit.ListenAndServe(":8080", nil)
      ...
}
```

If you haven't done so yet, initialize the Go module for your app:

```console
go mod init example.com/app # Arbitrary module designation

      go: creating new go.mod: module example.com/app
```

Install the newly added dependency and build your application:

```console
go get unit.nginx.org/go@{{< param "unitversion" >}}

      go: downloading unit.nginx.org

go build -o app app.go # Executable name and Application source code
```

If you update Unit to a newer version, repeat the two commands above
to rebuild your app.

The resulting executable works as follows:

- When you run it standalone, the **unit.ListenAndServe** call
   falls back to **http** functionality.

- When Unit runs it, **unit.ListenAndServe** directly communicates
   with Unit's router process, ignoring the address supplied as its first argument
   and relying on the
   [listener's settings]({{< relref "/unit/configuration.md#configuration-listeners" >}})
   instead.

---

</details>

Next, configure the app on Unit; besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option        | Description                                                                                                                                                                      |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **executable** (required) | String; pathname of the application, absolute or relative to **working_directory**.                                                                                       |
| **arguments**  | Array of strings; command-line arguments to be passed to the application. The example below is equivalent to **/www/chat/bin/chat_app --tmp-files /tmp/go-cache**.                |
{{</bootstrap-table>}}


#### Example:

```json
{
    "type": "external",
    "working_directory": "/www/chat",
    "executable": "bin/chat_app",
    "user": "www-go",
    "group": "www-go",
    "arguments": [
        "--tmp-files",
        "/tmp/go-cache"
    ]
}
```

{{< note >}}
For Go-based examples, see our [grafana]({{< relref "/unit/howto/apps/grafana/">}})
howto or a basic
[sample]({{< relref "/unit/howto/samples.md#sample-go" >}}).
{{< /note >}}

### Java {#configuration-java}

First, make sure to install Unit along with the
[Java language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option               | Description                                                                                                                                                                     |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **webapp** (required) | String; pathname of the application's **.war** file (packaged or unpackaged).                                                                                                 |
| **classpath**         | Array of strings; paths to your app's required libraries (may point to directories or individual **.jar** files).                                                                |
| **options**           | Array of strings; defines JVM runtime options. Unit itself exposes the **-Dnginx.unit.context.path** option that defaults to **/**; use it to customize the [context path](https://javaee.github.io/javaee-spec/javadocs/javax/servlet/ServletContext.html#getContextPath--).      |
| **thread_stack_size** | Integer; stack size of a worker thread (in bytes, multiple of memory page size; the minimum value is usually architecture specific). The default is usually system dependent.  |
| **threads**           | Integer; number of worker threads per [app process]({{< relref "/unit/howto/security.md#sec-processes" >}}). When started, each app process creates this number of threads to handle requests. The default is **1**. |
{{</bootstrap-table>}}


#### Example:

```json
{
    "type": "java",
    "classpath": [
        "/www/qwk2mart/lib/qwk2mart-2.0.0.jar"
    ],

    "options": [
        "-Dlog_path=/var/log/qwk2mart.log"
    ],

    "webapp": "/www/qwk2mart/qwk2mart.war"
}
```

{{< note >}}
For Java-based examples, see our
[Jira]({{< relref "/unit/howto/apps/jira/">}}),
[OpenGrok]({{< relref "/unit/howto/apps/opengrok/">}}),
and
[Springbook]({{< relref "/unit/howto/frameworks/springboot/">}})
howtos or a basic
[sample]({{< relref "/unit/configuration.md#sample-java" >}}).
{{< /note >}}

### Node.js {#configuration-nodejs}

First, you need to have the `unit-http` module
[installed]({{< relref "/unit/installation.md#installation-nodejs-package" >}}).
If it's global, symlink it in your project directory:

```console
npm link unit-http
```

Do the same if you move a Unit-hosted app to a new system where `unit-http` is
installed globally. Also, if you update Unit later, update the Node.js module as
well according to your
[installation method]({{< relref "/unit/installation.md#installation-nodejs-package" >}}).

Next, to run your Node.js apps on Unit, you need to configure them.
Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option        | Description                                                                                                        |
|---------------|--------------------------------------------------------------------------------------------------------------------|
| **executable** (required) | String; pathname of the app, absolute or relative to **working_directory**.<br><br>Supply your **.js** pathname here and start the file itself with a proper shebang:<br><br>`#!/usr/bin/env node`<br><br>**Note:** Make sure to `chmod +x` the file you list here so Unit can start it. |
| **arguments** | Array of strings; command-line arguments to be passed to the app. The example below is equivalent to **/www/apps/node-app/app.js --tmp-files /tmp/node-cache**. |

{{</bootstrap-table>}}


#### Example:

```json
{
    "type": "external",
    "working_directory": "/www/app/node-app/",
    "executable": "app.js",
    "user": "www-node",
    "group": "www-node",
    "arguments": [
        "--tmp-files",
        "/tmp/node-cache"
    ]
}
```

<a name="configuration-nodejs-loader"></a>

You can run Node.js apps without altering their code, using a loader module
we provide with `unit-http`. Apply the following app configuration,
depending on your version of Node.js:

{{<tabs name="Node.js">}}

{{%tab name="14.16.x and later"%}}

```json
{
    "type": "external",
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
    "comment_arguments_last": "Application script name"
}
```

{{%/tab%}}

{{%tab name="14.15.x and earlier"%}}

```json
{
    "type": "external",
    "executable": "/usr/bin/env",
    "comment_executable": "The external app type allows to run arbitrary executables, provided they establish communication with Unit",
    "arguments": [
        "node",
        "--require",
        "unit-http/loader",
        "app.js"
    ],
    "comment_arguments_last": "Application script name"
}
```

{{%/tab%}}

{{</tabs>}}

The loader overrides the **http** and **websocket** modules with their Unit-aware versions
and starts the app.

You can also run your Node.js apps without the loader by updating the application source code.
For that, use **unit-http** instead of **http** in your code:

```javascript
var http = require('unit-http');
```

To use the WebSocket protocol, your app only needs to replace the default **websocket**:

```javascript
var webSocketServer = require('unit-http/websocket').server;
```

{{< note >}}
For Node.js-based examples, see our
[apollo]({{< relref "/unit/howto/apps/apollo/">}}),
[express]({{< relref "/unit/howto/frameworks/express/">}}),
[koa]({{< relref "/unit/howto/frameworks/koa/">}}),
and
[Docker]({{< relref "/unit/howto/docker" >}})
howtos or a basic
[sample]({{< relref "/unit/configuration.md#sample-nodejs" >}}).
{{< /note >}}

### Perl {#configuration-perl}

First, make sure to install Unit along with the
[Perl language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option               | Description                                                                                                                                                                     |
|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **script** (required) | String; PSGI script path.                                                                                                                                                        |
| **thread_stack_size** | Integer; stack size of a worker thread (in bytes, multiple of memory page size; the minimum value is usually architecture specific). The default is usually system dependent and can be set with `ulimit -s <SIZE_KB>`. |
| **threads**           | Integer; number of worker threads per [app process]({{< relref "/unit/howto/security.md#sec-processes" >}}). When started, each app process creates this number of threads to handle requests. The default is **1**. |
{{</bootstrap-table>}}

#### Example:

```json
{
    "type": "perl",
    "script": "/www/bugtracker/app.psgi",
    "working_directory": "/www/bugtracker",
    "processes": 10,
    "user": "www",
    "group": "www"
}
```

{{< note >}}
For Perl-based examples of Perl,
see our
[Bugzilla]({{< relref "/unit/howto/apps/bugzilla/">}})
and
[Catalyst]({{< relref "/unit/howto/frameworks/catalyst/">}})
howtos or a basic
[sample]({{< relref "/unit/configuration.md#sample-perl" >}}).
{{< /note >}}

### PHP {#configuration-php}

First, make sure to install Unit along with the
[PHP language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}), you have:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option        | Description                                                                                                        |
|---------------|--------------------------------------------------------------------------------------------------------------------|
| **root** (required) | String; base directory of the app's file structure. All URI paths are relative to it.                               |
| **index**     | String; filename added to URI paths that point to directories if no **script** is set.<br><br>The default is **index.php**. |
| **options**   | Object; [defines]({{< relref "/unit/configuration.md#configuration-php-options" >}}) the **php.ini** location and options. |
| **script**    | String; filename of a **root**-based PHP script that serves all requests to the app.                                |
| **targets**   | Object; defines application sections with [custom]({{< relref "/unit/configuration.md#configuration-php-targets" >}}) **root**, **script**, and **index** values. |

{{</bootstrap-table>}}


The **index** and **script** options enable two modes of operation:

- If **script** is set, all requests to the application are handled
  by the script you specify in this option.
- Otherwise, the requests are served  according to their URI paths;
  if they point to directories, **index** is used.

<a name="configuration-php-options"></a>

You can customize **php.ini** via the **options** object:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option                | Description                                                                                                            |
|-----------------------|------------------------------------------------------------------------------------------------------------------------|
| **admin**, **user**    | Objects for extra directives. Values in **admin** are set in **PHP_INI_SYSTEM** mode, so the app can't alter them; **user** values are set in **PHP_INI_USER** mode and can be [updated](https://www.php.net/manual/en/function.ini-set.php) at runtime.<br><br>- The objects override the settings from any ***.ini** files<br><br>- The **admin** object can only set what's [listed](https://www.php.net/manual/en/ini.list.php) as **PHP_INI_SYSTEM**; for other modes, set **user**<br><br>- Neither **admin** nor **user** can set directives listed as [php.ini only](https://www.php.net/manual/en/ini.list.php) except for **disable_classes** and **disable_functions** |
| **file**              | String; pathname of the **php.ini** file with [PHP configuration directives](https://www.php.net/manual/en/ini.list.php). |

{{</bootstrap-table>}}


To load multiple **.ini** files, use **environment** with `PHP_INI_SCAN_DIR` to
[scan a custom directory](https://www.php.net/manual/en/configuration.file.php):

```json
{
    "applications": {
        "hello-world": {
            "type": "php",
            "root": "/www/public/",
            "script": "index.php",
            "environment": {
                "PHP_INI_SCAN_DIR": ":/tmp/php.inis/"
            },
            "comment_PHP_INI_SCAN_DIR": "Path separator"
        }
    }
}
```

Mind that the colon that prefixes the value here is a path separator;
it causes PHP to scan the directory preconfigured with the
{option}`!--with-config-file-scan-dir` option, which is usually **/etc/php.d/**,
and then the directory you set here, which is **/tmp/php.inis/**.
To skip the preconfigured directory, drop the **:** prefix.

{{< note >}}
Values in **options** must be strings (for example, **"max_file_uploads": "4"**,
not **"max_file_uploads": 4**); for boolean flags, use **"0"** and **"1"** only.
For details aof **PHP_INI\_\*** modes, see the
[PHP docs](https://www.php.net/manual/en/configuration.changes.modes.php).
{{< /note >}}

{{< note >}}
Unit implements the **fastcgi_finish_request()** [function](https://www.php.net/manual/en/function.fastcgi-finish-request.php) in a manner similar to PHP-FPM.
{{< /note >}}

#### Example:

```json
{
    "type": "php",
    "processes": 20,
    "root": "/www/blogs/scripts/",
    "user": "www-blogs",
    "group": "www-blogs",
    "options": {
        "file": "/etc/php.ini",
        "admin": {
            "memory_limit": "256M",
            "variables_order": "EGPCS"
        },

        "user": {
            "display_errors": "0"
        }
    }
}
```

#### Targets {#configuration-php-targets}

You can configure up to 254 individual entry points for a single PHP app:

```json
{
    "applications": {
        "php-app": {
            "type": "php",
            "targets": {
                "front": {
                    "script": "front.php",
                    "root": "/www/apps/php-app/front/"
                },

                "back": {
                    "script": "back.php",
                    "root": "/www/apps/php-app/back/"
                }
            }
        }
    }
}
```

Each target is an object that specifies **root** and can define **index** or **script**
just like a regular app does. Targets can be used by the **pass** options
in listeners and routes to serve requests:

```json
{
    "listeners": {
        "127.0.0.1:8080": {
            "pass": "applications/php-app/front"
        },

        "127.0.0.1:80": {
            "pass": "routes"
        }
    },

    "routes": [
        {
            "match": {
                "uri": "/back"
            },

            "action": {
                "pass": "applications/php-app/back"
            }
        }
    ]
}
```

App-wide settings (**isolation**, **limits**, **options**, **processes**)
are shared by all targets within the app.

{{< warning >}}
If you specify **targets**, there should be no **root**, **index**, or **script**
defined at the app level.
{{< /warning >}}

{{< note >}}
For PHP-based examples, see our
[CakePHP]({{< relref "/unit/howto/frameworks/cakephp/">}}),
[CodeIgniter]({{< relref "/unit/howto/frameworks/codeigniter/">}}),
[DokuWiki]({{< relref "/unit/howto/apps/dokuwiki/">}}),
[Drupal]({{< relref "/unit/howto/apps/drupal/">}}),
[Laravel]({{< relref "/unit/howto/frameworks/laravel/">}}),
[Lumen]({{< relref "/unit/howto/frameworks/lumen/">}}),
[Matomo]({{< relref "/unit/howto/apps/matomo/">}}),
[MediaWiki]({{< relref "/unit/howto/apps/mediawiki/">}}),
[MODX]({{< relref "/unit/howto/apps/modx/">}}),
[Nextcloud]({{< relref "/unit/howto/apps/nextcloud/">}}),
[phpBB]({{< relref "/unit/howto/apps/phpbb/">}}),
[phpMyAdmin]({{< relref "/unit/howto/apps/phpmyadmin/">}}),
[Roundcube]({{< relref "/unit/howto/apps/roundcube/">}}),
[Symfony]({{< relref "/unit/howto/frameworks/symfony/">}}),
[WordPress]({{< relref "/unit/howto/apps/wordpress/">}}),
and
[Yii]({{< relref "/unit/howto/frameworks/yii/">}})
howtos or a basic
[sample]({{< relref "/unit/configuration.md#sample-php" >}}).
{{< /note >}}

### Python {#configuration-python}

First, make sure to install Unit along with the
[Python language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option                | Description                                                                                                            |
|-----------------------|------------------------------------------------------------------------------------------------------------------------|
| **module** (required) | String; app's module name. This module is [imported](https://docs.python.org/3/reference/import.html) by Unit the usual Python way. |
| **callable**           | String; name of the **module**-based callable that Unit runs as the app. The default is **application**. |
| **factory**            | Boolean: when enabled, Unit treats **callable** as a factory. The default is **false**.<br><br>**Note:** Unit does *not* support passing arguments to factories. *(since 1.33.0)* |
| **home**               | String; path to the app's [virtual environment](https://packaging.python.org/en/latest/tutorials/installing-packages/#creating-virtual-environments). Absolute or relative to **working_directory**.<br><br>**Note:** The Python version used to run the app is determined by **type**; for performance, Unit doesn't use the command-line interpreter from the virtual environment. |
| **path**               | String or an array of strings; additional Python module lookup paths. These values are prepended to **sys.path**. |
| **prefix**             | String; **SCRIPT_NAME** context value for WSGI or the **root_path** context value for ASGI. Should start with a slash (**/**). |
| **protocol**           | String; hints Unit that the app uses a certain interface. Can be **asgi** or **wsgi**. |
| **targets**            | Object; app sections with [custom]({{< relref "/unit/configuration.md#configuration-python-targets" >}}) **module** and **callable** values. |
| **thread_stack_size**  | Integer; stack size of a worker thread (in bytes, multiple of memory page size; the minimum value is usually architecture specific). The default is usually system dependent and can be set with `ulimit -s <SIZE_KB>`. |
| **threads**            | Integer; number of worker threads per [app process]({{< relref "/unit/howto/security.md#sec-processes" >}}). When started, each app process creates this number of threads to handle requests. The default is **1**. |

{{</bootstrap-table>}}


#### Example:

```json
{
    "type": "python",
    "processes": 10,
    "working_directory": "/www/store/cart/",
    "path": "/www/store/",
    "comment_path": "Added to sys.path for lookup; store the application module within this directory",
    "home": ".virtualenv/",
    "comment_home": "Path where the virtual environment is located; here, it's relative to the working directory",
    "module": "cart.run",
    "comment_module": "Looks for a 'run.py' module in /www/store/cart/",
    "callable": "app",
    "prefix": "/cart",
    "comment_prefix": "Sets the SCRIPT_NAME or root_path context value",
    "user": "www",
    "group": "www"
}
```

This snippet runs the **app** callable from the **/www/store/cart/run.py** module
with **/www/store/cart/** as the working directory and **/www/store/.virtualenv/**
as the virtual environment; the **path** value accommodates for situations
when some modules of the app are imported from outside the **cart/** subdirectory.

<a name="configuration-python-asgi"></a>

You can provide the callable in two forms. The first one uses WSGI
([PEP 333](https://peps.python.org/pep-0333/)
or [PEP 3333](https://peps.python.org/pep-3333/)):

```python
def application(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/plain')])
    yield b'Hello, WSGI\n'
```

The second one, supported with Python 3.5+, uses
[ASGI](https://asgi.readthedocs.io/en/latest/):

```python
async def application(scope, receive, send):

    await send({
        'type': 'http.response.start',
        'status': 200
    })

    await send({
        'type': 'http.response.body',
        'body': b'Hello, ASGI\n'
    })
```

{{< note >}}
Legacy [two-callable](https://asgi.readthedocs.io/en/latest/specs/main.html#legacy-applications)
ASGI 2.0 applications were not supported prior to Unit 1.21.0.
{{< /note >}}

Choose either one according to your needs; Unit tries to infer your choice automatically.
If this inference fails, use the **protocol** option to set the interface explicitly.

{{< note >}}
The **prefix** option controls the **SCRIPT_NAME**
([WSGI](https://wsgi.readthedocs.io/en/latest/definitions.html))
or **root_path**
([ASGI](https://asgi.readthedocs.io/en/latest/specs/www.html#http-connection-scope))
setting in Python's context, allowing to route requests regardless of the app's factual path.
{{< /note >}}


#### Targets {#configuration-python-targets}

You can configure up to 254 individual entry points for a single Python app:

```json
{
    "applications": {
        "python-app": {
            "type": "python",
            "path": "/www/apps/python-app/",
            "targets": {
                "front": {
                    "module": "front.wsgi",
                    "callable": "app"
                },

                "back": {
                    "module": "back.wsgi",
                    "callable": "app"
                }
            }
        }
    }
}
```

Each target is an object that specifies **module** and can also define **callable** and **prefix**
just like a regular app does. Targets can be used by the **pass** options
in listeners and routes to serve requests:

```json
{
    "listeners": {
        "127.0.0.1:8080": {
            "pass": "applications/python-app/front"
        },

        "127.0.0.1:80": {
            "pass": "routes"
        }
    },

    "routes": [
        {
            "match": {
                "uri": "/back"
            },

            "action": {
                "pass": "applications/python-app/back"
            }
        }
    ]
}
```

The **home**, **path**, **protocol**, **threads**, and **thread_stack_size** settings
are shared by all targets in the app.

{{< warning >}}
If you specify **targets**, there should be no **module** or **callable**
defined at the app level. Moreover, you can't combine WSGI and ASGI targets
within a single app.
{{< /warning >}}

{{< note >}}
For Python-based examples, see our
[Bottle]({{< relref "/unit/howto/frameworks/bottle/">}}),
[Datasette]({{< relref "/unit/howto/apps/datasette/">}}),
[Django]({{< relref "/unit/howto/frameworks/django/">}}),
[DjangoChannels]({{< relref "/unit/howto/frameworks/djangochannels/">}}),
[Falcon]({{< relref "/unit/howto/frameworks/falcon/">}}),
[FastAPI]({{< relref "/unit/howto/frameworks/fastapi/">}}),
[Flask]({{< relref "/unit/howto/frameworks/flask/">}}),
[Guillotina]({{< relref "/unit/howto/frameworks/guillotina/">}}),
[Mailman]({{< relref "/unit/howto/apps/mailman/">}}),
[Mercurial]({{< relref "/unit/howto/apps/mercurial/">}}),
[Moin]({{< relref "/unit/howto/apps/moin/">}}),
[Plone]({{< relref "/unit/howto/apps/plone/">}}),
[Pyramid]({{< relref "/unit/howto/frameworks/pyramid/">}}),
[Quart]({{< relref "/unit/howto/frameworks/quart/">}}),
[Responder]({{< relref "/unit/howto/frameworks/responder/">}}),
[ReviewBoard]({{< relref "/unit/howto/apps/reviewboard/">}}),
[Sanic]({{< relref "/unit/howto/frameworks/sanic/">}}),
[Starlette]({{< relref "/unit/howto/frameworks/starlette/">}}),
[Trac]({{< relref "/unit/howto/apps/trac/">}}),
and
[Zope]({{< relref "/unit/howto/frameworks/zope/">}})
howtos or a basic
[sample]({{< relref "/unit/configuration.md#sample-python" >}}).
{{< /note >}}


### Ruby {#configuration-ruby}

First, make sure to install Unit along with the
[Ruby language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

{{< note >}}
Unit uses the [Rack](https://rack.github.io) interface to run Ruby scripts;
you need to have it installed as well:

```console
$ gem install rack
```
{{< /note >}}

Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option         | Description                                                                                                          |
|----------------|----------------------------------------------------------------------------------------------------------------------|
| **script** (required)  | String; rack script pathname, including the **.ru** extension, for instance: **/www/rubyapp/script.ru**. |
| **hooks**      | String; pathname of the **.rb** file setting the event hooks invoked during the app's lifecycle. |
| **threads**    | Integer; number of worker threads per [app process]({{< relref "/unit/howto/security.md#sec-processes" >}}). When started, each app process creates this number of threads to handle requests. The default is **1**. |

{{</bootstrap-table>}}


#### Example:

```json
{
   "type": "ruby",
   "processes": 5,
   "user": "www",
   "group": "www",
   "script": "/www/cms/config.ru",
   "hooks": "hooks.rb"
}
```

The **hooks** script is evaluated when the app starts. If set, it can define
blocks of Ruby code named **on_worker_boot**, **on_worker_shutdown**,
**on_thread_boot**, or **on_thread_shutdown**. If provided, these blocks are
called at the respective points of the app's lifecycle, for example:


```ruby
@mutex = Mutex.new

File.write("./hooks.#{Process.pid}", "hooks evaluated")
# Runs once at app load.

on_worker_boot do
   File.write("./worker_boot.#{Process.pid}", "worker boot")
end
# Runs at worker process boot.

on_thread_boot do
   @mutex.synchronize do
      # Avoids a race condition that may crash the app.
      File.write("./thread_boot.#{Process.pid}.#{Thread.current.object_id}",
                  "thread boot")
   end
end
# Runs at worker thread boot.

on_thread_shutdown do
    @mutex.synchronize do
        # Avoids a race condition that may crash the app.
        File.write("./thread_shutdown.#{Process.pid}.#{Thread.current.object_id}",
                   "thread shutdown")
    end
end
# Runs at worker thread shutdown.

on_worker_shutdown do
    File.write("./worker_shutdown.#{Process.pid}", "worker shutdown")
end
# Runs at worker process shutdown.
```

Use these hooks to add custom runtime logic to your app.

{{< note >}}
For Ruby-based examples, see our
[Rails]({{< relref "/unit/howto/frameworks/rails/">}})
and
[Redmine]({{< relref "/unit/howto/apps/redmine/">}})
howtos or a basic
[sample]({{< relref "/unit/configuration.md#sample-ruby" >}}).
{{< /note >}}


### WebAssembly {#configuration-wasm}



{{<tabs name="unit-wasm">}}
{{%tab name="wasm-wasi-component"%}}

First, make sure to install Unit along with the
[WebAssembly language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option       | Description                                                                                                     |
|--------------|-----------------------------------------------------------------------------------------------------------------|
| **component** (required) | String; WebAssembly component pathname, including the **.wasm** extension, for instance: "/var/www/wasm/component.wasm" |
| **access**   | Object; its only array member, **filesystem**, lists directories to which the application has access.           |
{{</bootstrap-table>}}

The `access` object has the following structure:

```json
"access": {
   "filesystem": [
      "/tmp/",
      "/var/tmp/"
   ]
}
```

#### Example:

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
         "component": "/var/www/app/component.wasm",
         "access": {
         "filesystem": [
            "/tmp/",
            "/var/tmp/"
         ]
         }
      }
   }
   }
```

{{< note >}}
A good, first Rust-based project is available at
[sunfishcode/hello-wasi-http](https://github.com/sunfishcode/hello-wasi-http).
It also includes all the important steps to get started with WebAssembly, WASI, and Rust.
{{< /note >}}
{{%/tab%}}

{{%tab name="unit-wasm"%}}
{{< warning >}}
The `unit-wasm` module is deprecated. We recommend using `wasm-wasi-component`
instead, which supports WebAssembly Components using standard WASI 0.2 interfaces.
The `wasm-wasi-component` module is available in Unit 1.32 and later.
{{< /warning >}}

First, make sure to install Unit along with the
[WebAssembly language module]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}).

Besides the
[common options]({{< relref "/unit/configuration.md#configuration-apps-common" >}}),
you have:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option                     | Description                                                                                                     |
|----------------------------|-----------------------------------------------------------------------------------------------------------------|
| **module** (required)       | String; WebAssembly module pathname, including the **.wasm** extension, for instance: **applications/wasmapp/module.wasm**. |
| **request_handler** (required) | String; name of the request handler function. If you use Unit with the official `unit-wasm` [package]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), the value is language specific; see the [SDK](https://github.com/nginx/unit-wasm/) documentation for details. Otherwise, use the name of your custom implementation. The runtime calls this handler, providing the address of the shared memory block used to pass data in and out the app. |
| **malloc_handler** (required) | String; name of the memory allocator function. See note above regarding language-specific handlers in the official `unit-wasm` package. The runtime calls this handler at language module startup to allocate the shared memory block used to pass data in and out the app. |
| **free_handler** (required) | String; name of the memory deallocator function. See note above regarding language-specific handlers in the official `unit-wasm` package. The runtime calls this handler at language module shutdown to free the shared memory block used to pass data in and out the app. |
| **access**                  | Object; its only array member, **filesystem**, lists directories the application can access:                       |
|              | `"access": {`<br><br>&nbsp;&nbsp;&nbsp;&nbsp;`"filesystem": [`<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`"/tmp/",`<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`"/var/tmp/"`<br><br>&nbsp;&nbsp;&nbsp;&nbsp;`]`<br><br>&nbsp;&nbsp;`}` |
| **module_init_handler**     | String; name of the module initialization function. If you use Unit with the official `unit-wasm` [package]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), the value is language specific; see the [SDK](https://github.com/nginx/unit-wasm/) documentation for details. Otherwise, use the name of your custom implementation. It is invoked by the WebAssembly language module at language module startup, after the WebAssembly module was initialized. |
| **module_end_handler**      | String; name of the module finalization function. If you use Unit with the official `unit-wasm` [package]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), the value is language specific; see the [SDK](https://github.com/nginx/unit-wasm/) documentation for details. Otherwise, use the name of your custom implementation. It is invoked by the WebAssembly language module at language module shutdown. |
| **request_init_handler**    | String; name of the request initialization function. If you use Unit with the official `unit-wasm` [package]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), the value is language specific; see the [SDK](https://github.com/nginx/unit-wasm/) documentation for details. Otherwise, use the name of your custom implementation. It is invoked by the WebAssembly language module at the start of each request. |
| **request_end_handler**     | String; name of the request finalization function. If you use Unit with the official `unit-wasm` [package]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), the value is language specific; see the [SDK](https://github.com/nginx/unit-wasm/) documentation for details. Otherwise, use the name of your custom implementation. It is invoked by the WebAssembly language module at the end of each request, when the headers and the request body were received. |
| **response_end_handler**    | String; name of the response finalization function. If you use Unit with the official `unit-wasm` [package]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), the value is language specific; see the [SDK](https://github.com/nginx/unit-wasm/) documentation for details. Otherwise, use the name of your custom implementation. It is invoked by the WebAssembly language module at the end of each response, when the headers and the response body were sent. |
{{</bootstrap-table>}}


#### Example:

```json
   {
      "type": "wasm",
      "module": "/www/webassembly/unitapp.wasm",
      "request_handler": "my_custom_request_handler",
      "malloc_handler": "my_custom_malloc_handler",
      "free_handler": "my_custom_free_handler",
      "access": {
            "filesystem": [
               "/tmp/",
               "/var/tmp/"
            ]
      },
      "module_init_handler": "my_custom_module_init_handler",
      "module_end_handler": "my_custom_module_end_handler",
      "request_init_handler": "my_custom_request_init_handler",
      "request_end_handler": "my_custom_request_end_handler",
      "response_end_handler": "my_custom_response_end_handler"
   }
```

Use these handlers to add custom runtime logic to your app; for a detailed
discussion of their usage and requirements, see the
[SDK](https://github.com/nginx/unit-wasm/) source code and documentation.

{{< note >}}
For WASM-based examples, see our [Rust and C samples]({{< relref "/unit/configuration.md#sample-wasm" >}}).
{{< /note >}}
{{%/tab%}}
{{</tabs>}}

## Settings {#configuration-stngs}

Unit has a global **settings** configuration object that stores instance-wide preferences.

{{<bootstrap-table "table table-striped table-bordered">}}
| Option              | Description                                                                                                              |
|---------------------|--------------------------------------------------------------------------------------------------------------------------|
| **listen_threads**   | Integer; controls the number of router threads created to handle client connections. Each thread includes all the configured listeners. By default, we create as many threads as the number of CPUs that are available to run on. *(since 1.33.0)* |
| **http**             | Object; fine-tunes handling of HTTP requests from the clients.                                                           |
| **js_module**        | String or an array of strings; lists enabled `njs` [modules]({{< relref "/unit/scripting.md" >}}), uploaded via the [control API]({{< relref "/unit/controlapi.md" >}}). |
| **telemetry**        | Object: OpenTelemetry configuration *(since 1.34.0)*                                                                    |

{{</bootstrap-table>}}


In turn, the **http** option exposes the following settings:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option                 | Description                                                                                                                |
|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| **body_read_timeout**   | Maximum number of seconds to read data from the body of a client's request. This is the interval between consecutive read operations, not the time to read the entire body. If Unit doesn't receive any data from the client within this interval, it returns a 408 "Request Timeout" response. The default is 30. |
| **discard_unsafe_fields** | Boolean; controls header field name parsing. If it's set to **true**, Unit only processes header names made of alphanumeric characters and hyphens (see [RFC 9110](https://datatracker.ietf.org/doc/html/rfc9110#section-16.3.1-6); otherwise, these characters are also permitted: **.!#$%&'*+^_`|~**. The default is **true**. |
| **header_read_timeout** | Maximum number of seconds to read the header of a client's request. If Unit doesn't receive the entire header from the client within this interval, it returns a 408 "Request Timeout" response. The default is 30. |
| **idle_timeout**        | Maximum number of seconds between requests in a keep-alive connection. If no new requests arrive within this interval, Unit returns a 408 "Request Timeout" response and closes the connection. The default is 180. |
| **log_route**           | Boolean; enables or disables [router logging]({{< relref "/unit/troubleshooting.md#troubleshooting-router-log" >}}). The default is **false** (disabled). |
| **max_body_size**       | Maximum number of bytes in the body of a client's request. If the body size exceeds this value, Unit returns a 413 "Payload Too Large" response and closes the connection. The default is 8388608 (8 MB). |
| **send_timeout**        | Maximum number of seconds to transmit data as a response to the client. This is the interval between consecutive transmissions, not the time for the entire response. If no data is sent to the client within this interval, Unit closes the connection. The default is 30. |
| **server_version**      | Boolean; if set to **false**, Unit omits version information in its **Server** response [header fields](https://datatracker.ietf.org/doc/html/rfc9110.html#section-10.2.4). The default is **true**. *(since 1.30.0)* |
| **static**              | Object; configures static asset handling. Has a single object option named **mime_types** that defines specific [MIME types](https://www.iana.org/assignments/media-types/media-types.xhtml) as options. Their values can be strings or arrays of strings; each string must specify a filename extension or a specific filename that's included in the MIME type. You can override default MIME types or add new types. |

{{</bootstrap-table>}}


The **telemetry** option exposes the following settings:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option            | Description                                                                                                                             |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| **endpoint**      | The endpoint for the OpenTelemetry (OTEL) Collector. <br><br>It takes a URL to either a gRPC or HTTP(S) endpoint.                               |
| **protocol**      | Determines the protocol used to communicate with the endpoint.<br><br> Can be either *http(s)* or *grpc*.                                      |
| **batch_size**    | Number of spans to cache before triggering a transaction with the configured endpoint. This is optional.<br><br> This allows the user to cache up to N spans before the OpenTelemetry (OTEL) background thread sends spans over the network to the collector.<br><br> If specified, it must be a positive integer. |
| **sampling_ratio** | Percentage of requests to trace.<br><br> This allows the user to only trace anywhere from 0% to 100% of requests that hit Unit. In high throughput environments this percentage should be lower. This allows the user to save space in storing span data, and to collect request metrics like time to decode headers and whatnot without storing massive amounts of duplicate superfluous data.<br><br> If specified, it must be a positive floating point number. |

{{</bootstrap-table>}}


#### Example:

```json
"settings": {
    "telemetry": {
        "batch_size": 20,
        "endpoint": "http://example.com/v1/traces",
        "protocol": "http",
        "sampling_ratio": 1.0
    }
},
```


## Access log {#configuration-access-log}

To enable basic access logging, specify the log file path in the **access_log** option
of the **config** object.

In the example below, all requests will be logged to **/var/log/access.log**:

```console
curl -X PUT -d '"/var/log/access.log"' \
      --unix-socket /path/to/control.unit.sock \
      http://localhost/config/access_log

   {
      "success": "Reconfiguration done."
   }
```

By default, the log is written in the
[Combined Log Format](https://httpd.apache.org/docs/2.2/logs.html#combined).
Example of a CLF line:

```none
127.0.0.1 - - [21/Oct/2015:16:29:00 -0700] "GET / HTTP/1.1" 200 6022 "http://example.com/links.html" "Godzilla/5.0 (X11; Minix i286) Firefox/42"
```

### Custom log formatting {#custom-log-format}

The **access_log** option can be also set to an object to customize both the log path
and its format:

{{<bootstrap-table "table table-striped table-bordered">}}

| Option   | Description                                                                                                                   |
|----------|-------------------------------------------------------------------------------------------------------------------------------|
| **format** | String; sets the log format. Besides arbitrary text, can contain any [variables]({{< relref "/unit/configuration.md#configuration-variables-native" >}}) Unit supports. |
| **path**   | String; pathname of the access log file.                                                                                        |

{{</bootstrap-table>}}


#### Example:

```json
{
    "access_log": {
        "path": "/var/log/unit/access.log",
        "format": "$remote_addr - - [$time_local] \"$request_line\" $status $body_bytes_sent \"$header_referer\" \"$header_user_agent\""
    }
}
```

By a neat coincidence, the above **format** is the default setting.
Also, mind that the log entry is formed *after* the request has been handled.

Besides
[built-in variables]({{< relref "/unit/configuration.md#configuration-variables-native" >}}),
you can use `njs` [templates]({{< relref "/unit/scripting.md" >}})
to define the log format:

```json
{
    "access_log": {
        "path": "/var/log/unit/basic_access.log",
        "format": "`${host + ': ' + uri}`"
    }
}
```

### JSON log format

Starting with NGINX Unit 1.34.0, **format** can instead be an object
describing JSON field name/value pairs, for example,

```json
{
    "access_log": {
        "path": "/tmp/access.log",
        "format": {
            "remote_addr": "$remote_addr",
            "time_local": "$time_local",
            "request_line": "$request_line",
            "status": "$status",
            "body_bytes_sent": "$body_bytes_sent",
            "header_referer": "$header_referer",
            "header_user_agent": "$header_user_agent"
        }
    }
}
```

The JSON *values* can be strings, variables and JavaScript.


### Conditional access log {#conditional-access-log-1}

The **access_log** can be dynamically turned on and off by using the **if** option:

{{<bootstrap-table "table table-striped table-bordered">}}
| Option | Description |
|--------|-------------|
| **if** | if the value is empty, 0, false, null, or undefined, the logs will not be recorded. |
{{</bootstrap-table>}}


This feature lets users set conditions to determine whether access logs are
recorded. The **if** option supports a string and JavaScript code.
If its value is empty, 0, false, null, or undefined, the logs will not be
recorded. And the '!' as a prefix inverses the condition.

Example without njs:

```json
{
   "access_log": {
      "if": "$cookie_session",
      "path": "..."
   }
}
```

All requests using a session cookie named **session** will be logged.

We can add `!` to inverse the condition.

```json
{
   "access_log": {
      "if": "!$cookie_session",
      "path": "..."
   }
}
```

Now, all requests without a session cookie will be logged.

Example with njs and the use of a template literal:

```json
{
   "access_log": {
      "if": "`${uri == '/health' ? false : true}`",
      "path": "..."
   }
}
```
