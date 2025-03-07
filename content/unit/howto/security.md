---
title: Security checklist
weight: 800
toc: true
---

At its core, Unit has security as one of its top priorities; our development
follows the appropriate best practices focused on making the code robust and
solid. However, even the most hardened system requires proper setup,
configuration, and maintenance.

This guide lists the steps to protect your Unit from installation to individual
app configuration.

{{< note >}}
The commands in this document starting with a hash (#) must be run as root or
with superuser privileges.
{{< /note >}}

## Update Unit regularly {#security-update}

**Rationale**: Each release introduces [bug fixes and new
features]({{< relref "/unit/changes.md" >}}) that improve your installation's security.

**Actions**: Follow our latest [news](https://mailman.nginx.org/mailman3/lists/unit.nginx.org/)
and upgrade to new versions shortly after they are released.

<details>
<summary>Details</summary>
<a name="sec-updates"></a>

Specific upgrade steps depend on your installation method:

- The recommended option is to use our official
   [packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
   or Docker
   [images]({{< relref "/unit/installation.md#installation-docker" >}});
   with them, it's just a matter of updating
   **unit-*** packages with your package manager of choice or
   switching to a newer image.

- If you use a third-party installation
   [method]({{< relref "/unit/installation.md#installation-community-repos" >}}),
   consult the maintainer's documentation for details.

- If you install Unit from
   [source files]({{< relref "/unit/howto/source.md" >}}),
   rebuild and reinstall Unit and its modules from scratch.

</details>

## Secure socket and state {#security-socket-state}

**Rationale**: Your
[control socket and state directory]({{< relref "/unit/howto/source.md#source-dir" >}})
provide unlimited access to Unit's configuration, which
calls for stringent protection.

**Actions**: Default configuration in our
[official packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
is usually sufficient; if you use another installation method, ensure the control
socket and the state directory are safe.

<details>
<summary>Control socket</summary>

<a name="sec-socket"></a>

If you use a UNIX control socket, ensure it is available to **root**
only:

```console
$ unitd -h

      ...
      --control ADDRESS    set address of control API socket
                           default: "unix:/default/path/to/control.unit.sock" # Build-time setting, can be overridden

$ ps ax | grep unitd

      ... unit: main {{< param "unitversionv" >}} [... --control /path/to/control.sock ...] # Make sure to check for runtime overrides

# ls -l /path/to/control.unit.sock # If it's overridden, use the runtime setting

      srw------- 1 root root 0 ... /path/to/control.unit.sock

```

UNIX domain sockets aren't network accessible; for remote access, use
[NGINX]({{< relref "/unit/howto/integration.md#nginx-secure-api" >}}) oor a solution such as SSH:

```console
$ ssh -N -L ./here.sock:/path/to/control.unit.sock root@unit.example.com & # Local socket | Socket on the Unit server; use a real path in your command | Unit server hostname
```

```console
$ curl --unix-socket ./here.sock # Use the local socket to configure Unit

      {
            "certificates": {},
            "config": {
               "listeners": {},
               "applications": {}
            }
      }
```

If you prefer an IP-based control socket, avoid public IPs; they expose the
[control API]({{< relref "/unit/controlapi.md#configuration-api" >}})
and all its capabilities.  This means your Unit instance can be manipulated by
whomever is physically able to connect:

```console
# unitd --control 203.0.113.14:8080
```

```console
$ curl 203.0.113.14:8080

      {
            "certificates": {},
            "config": {
               "listeners": {},
               "applications": {}
            }
      }
```

Instead, opt for the loopback address to ensure all access is local to your
server:

```console
# unitd --control 127.0.0.1:8080
```

```console
$ curl 203.0.113.14:8080

      curl: (7) Failed to connect to 203.0.113.14 port 8080: Connection refused
```

However, any processes local to the same system can access the local socket,
which calls for additional measures.  A go-to solution would be using NGINX
to [proxy]({{< relref "/unit/howto/integration.md#nginx-secure-api" >}})
Unit's control API.

</details>

<details>
<summary>State directory</summary>

<a name="sec-state"></a>

The state directory stores Unit's internal configuration between launches.
Avoid manipulating it or relying on its contents even if tempted to do so.
Instead, use only the control API to manage Unit's configuration.

Also, the state directory should be available only to **root** (or the
user that the **main**
[process]({{< relref "/unit/howto/security.md#security-apps" >}})
runs as):

```console
$ unitd -h

      ...
      --state DIRECTORY    set state directory name
                           default: /default/path/to/unit/state/  # Build-time setting, can be overridden
```

```console
$ ps ax | grep unitd

      ... unit: main {{< param "unitversionv" >}} [... --state /path/to/unit/state/ ...]  # Make sure to check for runtime overrides
```

```console
# ls -l /path/to/unit/state/  # If it's overridden, use the runtime setting

      drwx------ 2 root root 4096 ...
```

</details>

## Configure SSL/TLS {#security-ssl}

**Rationale**: To protect your client connections in production scenarios,
configure SSL certificate bundles for your Unit installation.

**Actions**: For details, see [SSL/TLS configuration]({{< relref "/unit/certificates.md#configuration-ssl" >}}) and [TLS with certbot]({{< relref "/unit/howto/certbot.md" >}}).

## Error-proof your routes {#security-routes}

**Rationale**: Arguably, [routes]({{< relref "/unit/configuration.md#configuration-routes" >}})
are the most flexible and versatile part of the Unit configuration. Thus, they must be as
clear and robust as possible to avoid loose ends and gaping holes.

**Actions**: Familiarize yourself with the
[matching]({{< relref "/unit/configuration.md#configuration-routes-matching" >}})
logic and double-check all
[patterns]({{< relref "/unit/configuration.md#configuration-routes-matching-patterns" >}})
that you use.

<details>
<summary name="Details">Details</summary>

<a name="sec-routes"></a>


Some considerations:

- Mind that
   [variables]({{< relref "/unit/configuration.md#configuration-variables-native" >}})
   contain arbitrary user-supplied request values; variable-based **pass** values in
   [listeners]({{< relref "/unit/configuration.md#configuration-listeners" >}})
   and
   [routes]({{< relref "/unit/configuration.md#configuration-routes-action" >}})
    must account for malicious requests, or the requests must be properly filtered.

- Create
   [matching rules]({{< relref "/unit/configuration.md#configuration-routes-matching" >}})
   to formalize the restrictions of your Unit instance and the apps it runs.

- Configure
   [shares]({{< relref "/unit/configuration.md#configuration-static" >}})
   only for directories and files you intend to make public.

</details>

## Protect app data {#security-apps}

**Rationale**: Unit's architecture involves many processes that operate
together during app delivery; improper process permissions can make sensitive
files available across apps or even publicly.

**Actions**: Properly configure your app directories and shares: apps and the
router process need access to them. Still, avoid loose rights such as the
notorious **777**, instead assigning them on a need-to-know basis.

<details>
<summary>File permissions</summary>

<a name="sec-files"></a>

To configure file permissions for your apps, check Unit's build-time and
run-time options first:

```console
$ unitd -h

      ...
      --user USER  # set non-privileged processes to run as specified user | default: unit_user (Build-time setting, can be overridden)

      --group GROUP        set non-privileged processes to run as specified group
                           default: user's primary group
```

```console
$ ps ax | grep unitd

      ... unit: main {{< param "unitversionv" >}} [... --user unit_user --group unit_group ...]  # Make sure to check for runtime overrides
```

In particular, this is the account the router process runs as.  Use this
information to set up permissions for the app code or binaries and shared
static files.  The main idea is to limit each app to its own files and
directories while simultaneously allowing Unit's router process to access
static files for all apps.

Specifically, the requirements are as follows:

- All apps should run as different users so that the permissions can be
   configured properly.  Even if you run a single app, it's reasonable to
   create a dedicated user for added flexibility.

- An app's code or binaries should be reachable for the user the app runs
   as; the static files should be reachable for the router process.  Thus,
   each part of an app's directory path must have execute permissions
   assigned for the respective users.

- An app's directories should not be available to other apps or
   non-privileged system users. The router process should be able to access
   the app's static file directories.  Accordingly, the app's directories
   must have read and execute permissions assigned for the respective users.

- The files and directories that the app is designed to update should
   be writable only for the user the app runs as.

- The app code should be readable (and executable in case of
   [external]({{< relref "/unit/howto/modules.md#modules-ext" >}}) apps)
   for the user the app runs as; the static content should be readable for the
   router process.

A detailed walkthrough to guide you through each requirement:

1. If you have several independent apps, running them with a single user
account poses a security risk.  Consider adding a separate system user
and group per each app:

   ```console
   # useradd -M app_user  # Add user account without home directory
   ```

   ```console
   # groupadd app_group
   ```

   ```console
   # usermod -L app_user  # Deny interactive login
   ```

   ```console
   # usermod -a -G app_group app_user  # Add user to the group
   ```

   Even if you run a single app, this helps if you add more apps or need to
   decouple permissions later.

1. It's important to add Unit's non-privileged user account to *each* app
group:

   ```console
   # usermod -a -G app_group unit_user
   ```

   Thus, Unit's router process can access each app's directory and serve
   files from each app's shares.

1. A frequent source of issues is the lack of permissions for directories
inside a directory path needed to run the app, so check for that if in
doubt.  Assuming your app code is stored at **/path/to/app/**:

   ```console
   # ls -l /

            # drwxr-xr-x some_user some_group path  # Permissions are OK
   ```

   ```console
   # ls -l /path/

         # drwxr-x--- some_user some_group to  # Permissions are too restrictive
   ```

   This may be a problem because the **to/** directory isn't owned by
   **app_user:app_group** and denies all permissions to non-owners (as
   the **---** sequence tells us), so a fix can be warranted:

   ```console
   # chmod o+rx /path/to/  # Add read/execute permissions for non-owners
   ```

   Another solution is to add **app_user** to **some_group**
   (assuming this was not done before):

   ```console
   # usermod -a -G some_group app_user
   ```

1. Having checked the directory tree, assign ownership and permissions for
your app's directories, making them reachable for Unit and the app:

   ```console
   # chown -R app_user:app_group /path/to/app/  # Assign ownership for the app code | Path to the application directory; use a real path in your command
   ```

   ```console
   # chown -R app_user:app_group /path/to/static/app/files/  # Assign ownership for the static files | Can be outside the app directory tree; use a real path in your command
   ```

   ```console
   # find /path/to/app/ -type d -exec chmod u=rx,g=rx,o= {} \;  # Path to the application directory; use a real path in your command | Add read/execute permissions to app code directories for user and group
   ```

   ```console
   # find /path/to/static/app/files/ -type d -exec chmod u=rx,g=rx,o= {} \;  # Can be outside the app directory tree; use a real path in your command | Add read/execute permissions to static file directories for user and group
   ```

1. If the app needs to update specific directories or files, make sure
they're writable for the app alone:

   ```console
   # chmod u+w /path/to/writable/file/or/directory/  # Add write permissions for the user only; the group shouldn't have them | Repeat for each file or directory that must be writable
   ```

   In case of a writable directory, you may also want to prevent non-owners
   from messing with its files:

   ```console
   # chmod +t /path/to/writable/directory/  # Sticky bit prevents non-owners from deleting or renaming files | Repeat for each directory that must be writable

   ```

   {{< note >}}
   Usually, apps store and update their data outside the app code
   directories, but some apps may mix code and data.  In such a case,
   assign permissions on an individual basis, making sure you understand
   how the app uses each file or directory: is it code, read-only
   content, or writable data.
   {{< /note >}}

1. For [embedded]({{< relref "/unit/howto/modules.md#modules-emb" >}})
   apps, it's usually enough to make the
   app code and the static files readable:

   ```console
   # find /path/to/app/code/ -type f -exec chmod u=r,g=r,o= {} \;  # Path to the application's code directory; use a real path in your command | Add read rights to app code for user and group
   ```

   ```console
   # find /path/to/static/app/files/ -type f -exec chmod u=r,g=r,o= {} \;  # Can be outside the app directory tree; use a real path in your command | Add read rights to static files for user and group
   ```

1. For
   [external]({{< relref "/unit/howto/modules.md#modules-ext" >}})
   apps, additionally make the app code or binaries executable:

   ```console
   # find /path/to/app/ -type f -exec chmod u=rx,g=rx,o= {} \;  # Path to the application directory; use a real path in your command | Add read and execute rights to app code for user and group
   ```

   ```console
   # find /path/to/static/app/files/ -type f -exec chmod u=r,g=r,o= {} \;  # Can be outside the app directory tree; use a real path in your command | Add read rights to static files for user and group
   ```

1. To run a single app, [configure]({{< relref "/unit/configuration.md" >}})
   Unit as follows:

   ```json
         {
            "listeners": {
               "*:80": {  /* Or another suitable socket address */
                  "pass": "routes"
               }
            },

            "routes": [
               {
                  "action": {
                        "share": "/path/to/static/app/files/$uri",
                        /* Router process needs read and execute permissions to serve static content from this directory */
                        "fallback": {
                           "pass": "applications/app"
                        }
                  }
               }
            ],

            "applications": {
               "app": {
                  "type": "...",
                  "user": "app_user",
                  "group": "app_group"
               }
            }
      }
   ```

1. To run several apps side by side,
   [configure]({{< relref "/unit/configuration.md" >}})
   them with appropriate user and group names.  The following
   configuration distinguishes apps based on the request URI, but you can
   implement another scheme such as different listeners:

   ```json
         {
            "listeners": {
               "*:80": {  /* Or another suitable socket address */
                  "pass": "routes"
               }
            },

            "routes": [
               {
                  "match": {
                        "uri": "/app1/*"  /* Arbitrary matching condition */
                  },

                  "action": {
                        "share": "/path/to/static/app1/files/$uri",
                        /* Router process needs read and execute permissions to serve static content from this directory */
                        "fallback": {
                           "pass": "applications/app1"
                        }
                  }
               },

               {
                  "match": {
                        "uri": "/app2/*"  /* Arbitrary matching condition */
                  },

                  "action": {
                        "share": "/path/to/static/app2/files/$uri",
                        /* Router process needs read and execute permissions to serve static content from this directory */
                        "fallback": {
                           "pass": "applications/app2"
                        }
                  }
               }
            ],

            "applications": {
               "app1": {
                  "type": "...",
                  "user": "app_user1",
                  "group": "app_group1"
               },

               "app2": {
                  "type": "...",
                  "user": "app_user2",
                  "group": "app_group2"
               }
            }
      }
   ```

{{< note >}}
As usual with permissions, different steps may be required if you use
ACLs.
{{< /note >}}
</details>

<details>
<summary>App internals</summary>

<a name="sec-app-internals"></a>

Unfortunately, quite a few web apps are built in a manner that mixes their
source code, data, and configuration files with static content, which calls
for complex access restrictions.  The situation is further aggravated by the
inevitable need for maintenance activities that may leave a footprint of
extra files and directories unrelated to the app's operation.  The issue has
several aspects:

- Storage of code and data at the same locations, which usually happens by
(insufficient) design.  You neither want your internal data and code files
to be freely downloadable nor your user-uploaded data to be executable as
code, so configure your routes and apps to prevent both.

- Exposure of configuration data.  Your app-specific settings, **.ini**
or **.htaccess** files, and credentials are best kept hidden from
prying eyes, and your routing configuration should reflect that.

- Presence of hidden files from versioning, backups by text editors, and
other temporary files.  Instead of carving your configuration around
these, it's best to keep your app free of them altogether.

If these can't be avoided, investigate the inner workings of the app to
prevent exposure, for example:

```json
   {
         "routes": {
            "app": [
               {
                     "match": {
                        "uri": [
                           "*.php",
                           "*.php/*"
                        ]
                        /* Handles requests that target PHP scripts to avoid having them served as static files */
                     },

                     "action": {
                        "pass": "applications/app/direct"
                     }
               },
               {
                     "match": {
                        "uri": [
                           "!/sensitive/*",  /* Restricts access to a directory with sensitive data */
                           "!/data/*",  /* Restricts access to a directory with sensitive data */
                           "!/app_config_values.ini",  /* Restricts access to a specific file */
                           "!*/.*",  /* Restricts access to hidden files and directories */
                           "!*~"  /* Restricts access to temporary files */
                        ]
                        /* Protects files and directories best kept hidden */
                     },

                     "action": {
                        "share": "/path/to/app/static$uri",
                        /* Serves valid requests with static content | Path to the application's static file directory; use a real path in your configuration */

                        "types": [
                           "image/*",
                           "text/*",
                           "application/javascript"
                        ]
                        /* Limits file types served from the share */

                        "fallback": {
                           "pass": "applications/app/index"
                        }
                        /* Relays all requests not yet served to a catch-all app target */
                     }
               }
            ]
         }
   }

```

However, this does not replace the need to set up file permissions; use both
[matching rules]({{< relref "/unit/configuration.md#configuration-routes-matching" >}})
and per-app user
permissions to manage access.  For more info and real-life examples, refer
to our app [how-tos]({{< relref "/unit/howto/" >}}).
and the 'File Permissions' callout above.
</details>

<details>
<summary>Unit's process summary</summary>

<a name="sec-processes"></a>

Unit's processes are detailed [elsewhere](https://www.nginx.com/blog/introducing-nginx-unit/),
but here's a synopsis of the different roles they have:

{{<bootstrap-table "table table-striped table-bordered">}}
| Process       | Privileged? | User and Group                                          | Description |
|--------------|------------|---------------------------------------------------------|-------------|
| **Main**     | Yes        | Whoever starts the **unitd** executable<br><br>; by default, **root**. | Runs as a daemon, spawning Unit's non-privileged and app processes; requires numerous system capabilities and privileges for operation. |
| **Controller** | No       | Set by `--user` and `--group` options at [build]({{< relref "/unit/howto/source.md#source-config-src" >}})  or [execution]({{< relref "/unit/howto/source.md#source-startup" >}}) <br><br>; by default, **unit**. | Serves the control API, accepting reconfiguration requests, sanitizing them, and passing them to other processes for implementation. |
| **Discovery** | No       | Set by `--user` and `--group` options at [build]({{< relref "/unit/howto/source.md#source-config-src" >}})  or [execution]({{< relref "/unit/howto/source.md#source-startup" >}}) <br><br>; by default, **unit**. | Discovers the language modules in the module directory at startup, then quits. |
| **Router**    | No       | Set by `--user` and `--group` options at [build]({{< relref "/unit/howto/source.md#source-config-src" >}})  or [execution]({{< relref "/unit/howto/source.md#source-startup" >}}) <br><br>; by default, **unit**. | Serves client requests, accepting them, processing them on the spot, passing them to app processes, or proxying them further; requires access to static content paths you configure. |
| **App processes** | No  | Set by per-app **user** and **group** [options]({{< relref "/unit/configuration.md#configuration-applications" >}}) <br><br>; by default, `--user` and `--group` values. | Serve client requests that are routed to apps; require access to paths and namespaces you configure for the app. |
{{</bootstrap-table>}}


You can check all of the above on your system when Unit is running:

```console
   $ ps aux | grep unit

         ...
         root   ... unit: main {{< param "unitversionv" >}}
         unit   ... unit: controller
         unit   ... unit: router
         unit   ... unit: "front" application
```

The important outtake here is to understand that Unit's non-privileged
processes don't require running as **root**.  Instead, they should have
the minimal privileges required to operate, which so far means the ability
to open connections and access the application code and the static files
shared during routing.

</details>

## Prune debug and access logs {#security-logs}

**Rationale**: Unit stores potentially sensitive data in its general and access
logs; their size can also become a concern if debug mode is enabled.

**Actions**: Secure access to the logs and ensure they don't exceed the allowed
disk space.

<details>
<summary>Details</summary>

<a name="sec-logs"></a>

Unit can maintain two different logs:

- A general-purpose log that is enabled by default and can be switched to
debug mode for verbosity.

- An access log that is off by default but can be enabled via the control
API.

If you enable debug-mode or access logging, rotate these logs with tools
such as `logrotate` to avoid overgrowth.  A sample
`logrotate` [configuration](https://man7.org/linux/man-pages/man8/logrotate.8.html#CONFIGURATION_FILE_DIRECTIVES):

```none
/path/to/unit.log { # Use a real path in your configuration
      daily
      missingok
      rotate 7
      compress
      delaycompress
      nocreate
      notifempty
      su root root
      postrotate
         if [ -f `/path/to/unit.pid` ]; then
            /bin/kill -SIGUSR1 `cat /path/to/unit.pid` # Use a real path in your configuration
         fi
      endscript
}
```

To figure out the log and PID file paths:

```console
$ unitd -h

      ...
      --pid FILE           set pid filename
                           default: "/default/path/to/unit.pid" # Build-time setting, can be overridden

      --log FILE           set log filename
                           default: "/default/path/to/unit.log " # Build-time setting, can be overridden

$ ps ax | grep unitd

      ... unit: main {{< param "unitversionv" >}} [... --pid /path/to/unit.pid --log /path/to/unit.log...] # Make sure to check for runtime overrides
```

Another issue is the logs' accessibility.  Logs are opened and updated by
the
[main process]({{< relref "/unit/howto/security.md#security-apps" >}})
that usually runs as **root**.
However, to make them available for a certain consumer, you may need to
enable access for a dedicated user that the consumer runs as.

Perhaps, the most straightforward way to achieve this is to assign log
ownership to the consumer's account.  Suppose you have a log utility running
as **log_user:log_group**:

```console
# chown log_user:log_group :/path/to/unit.log # If it's overridden, use the runtime setting
```

```console
curl -X PUT -d '"/path/to/access.log"'  \
       --unix-socket /path/to/control.unit.sock \
       http://localhost/config/access_log
```


```console
# chown log_user:log_group /path/to/access.log # Use a real path in your command>
```

If you change the log file ownership, adjust your `logrotate`
settings accordingly:

```none
/path/to/unit.log {
      ...
      su log_user log_group
      ...
}
```

{{< note >}}
As usual with permissions, different steps may be required if you use
ACLs.
{{< /note >}}

</details>

## Add restrictions, isolation {#security-isolation}

**Rationale**: If the underlying OS allows, Unit provides features that create an
additional level of separation and containment for your apps, such as:

- Share [path restrictions]({{< relref "/unit/configuration.md#configuration-share-path" >}})
- Namespace and file system root
   [isolation]({{< relref "/unit/configuration.md#configuration-proc-mgmt-isolation" >}})

**Actions**: For more details, see our blog posts on [path restrictions](https://www.nginx.com/blog/nginx-unit-updates-for-summer-2021-now-available/#Static-Content:-Chrooting-and-Path-Restrictions),
[namespace](https://www.nginx.com/blog/application-isolation-nginx-unit/) and
[file system](https://www.nginx.com/blog/filesystem-isolation-nginx-unit/)
isolation.
