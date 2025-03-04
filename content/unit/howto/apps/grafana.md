---
title: Grafana
toc: true
weight: 600
---

Here, we install Grafana from [sources](https://github.com/grafana/grafana/blob/main/contribute/developer-guide.md)
so we can
[configure it]({{< relref "/unit/configuration.md#configuration-go" >}})
to run on Unit.

1. Install [Unit]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}) with a Go language module.

   Also, make sure Unit's Go module is available at **\$GOPATH**.

2. Download Grafana's source files:

   ```console
   $ go get github.com/grafana/grafana
   ```

3. Update the code, adding Unit to Grafana's protocol list. You can either
   apply a patch ([<i class="fa-solid fa-download" style="margin-right: 0.2;"></i> grafana.patch](/unit/downloads/grafana.patch)):

   ```console
   $ cd $GOPATH/src/github.com/grafana/grafana  # The path where the previous step saves the application's files
   ```

   ```console
   $ curl -O https://unit.nginx.org/_downloads/grafana.patch
   ```

   ```console
   $ patch -p1 < grafana.patch
   ```

   Or update the sources manually. In **conf/defaults.ini**:

   ```ini
   #################################### Server ##############################
   [server]
   # Protocol (http, https, socket, unit)
   protocol = unit
   ```

   In **pkg/api/http_server.go**:

   ```go
   import (
       // ...
       "net/http"
       "unit.nginx.org/go"
       "os"
       // ...
   )

   // ...

   switch setting.Protocol {

   // ...

   case setting.HTTP, setting.HTTPS, setting.HTTP2:
       var err error
       listener, err = net.Listen("tcp", hs.httpSrv.Addr)
       if err != nil {
           return errutil.Wrapf(err, "failed to open listener on address %s", hs.httpSrv.Addr)
       }
   case setting.SOCKET:
       var err error
       listener, err = net.ListenUnix("unix", &net.UnixAddr{Name: setting.SocketPath, Net: "unix"})
       if err != nil {
           return errutil.Wrapf(err, "failed to open listener for socket %s", setting.SocketPath)
       }
   case setting.UNIT:
       var err error
       err = unit.ListenAndServe(hs.httpSrv.Addr, hs.macaron)
       if err == http.ErrServerClosed {
           hs.log.Debug("server was shutdown gracefully")
           return nil
       }
   ```

   In **pkg/setting/setting.go**:

   ```go
    const (
        HTTP              Scheme = "http"
        HTTPS             Scheme = "https"
        SOCKET            Scheme = "socket"
        UNIT              Scheme = "unit"
        DEFAULT_HTTP_ADDR string = "0.0.0.0"
    )

    // ...

    Protocol = HTTP
    protocolStr, err := valueAsString(server, "protocol", "http")
    // ...
    if protocolStr == "https" {
        Protocol = HTTPS
        CertFile = server.Key("cert_file").String()
        KeyFile = server.Key("cert_key").String()
    }
    if protocolStr == "h2" {
        Protocol = HTTP2
        CertFile = server.Key("cert_file").String()
        KeyFile = server.Key("cert_key").String()
    }
    if protocolStr == "socket" {
        Protocol = SOCKET
        SocketPath = server.Key("socket").String()
    }
    if protocolStr == "unit" {
        Protocol = UNIT
    }
   ```

4. Build Grafana:

   ```console
   $ cd $GOPATH/src/github.com/grafana/grafana  # The path where the previous step saves the application's files
   $ go get ./...  # Installs dependencies
   $ go run build.go setup
   $ go run build.go build
   $ yarn install --pure-lockfile
   $ yarn start
   ```

   Note the directory where the newly built **grafana-server** is placed,
   usually **\$GOPATH/bin/**; it's used for the **executable** option in
   the Unit configuration.

5. Run the following commands (as root) so Unit can access Grafana's files:

   ```console
   # chown -R unit:unit $GOPATH/src/github.com/grafana/grafana  # User and group that Unit's router runs as by default | Path to the application's files
   ```

   ```console
   # chown unit:unit $GOPATH/bin/grafana-server  # User and group that Unit's router runs as by default | Path to the application's executable
   ```

   {{< note >}}
   The **unit:unit** user-group pair is available only with
   [official packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}}), Docker
   [images]({{< relref "/unit/installation.md#installation-docker" >}})
   , and some
   [third-party repos]({{< relref "/unit/installation.md#installation-community-repos" >}}).
   Otherwise, account names may differ; run the `ps aux | grep unitd` command to be sure.
   {{< /note >}}

   For further details, including permissions, see the
   [security checklist]({{< relref "/unit/howto/security.md#security-apps" >}}).

6. Next, [prepare]({{< relref "/unit/configuration.md#configuration-php" >}}) the configuration (replace
   **\$GOPATH** with its value in **executable** and
   **working_directory**):

   ```json
   {
      "listeners": {
         "*:3000": {
               "pass": "applications/grafana"
         }
      },

      "applications": {
         "grafana": {
               "executable": "$GOPATH/bin/grafana-server",
               "_comment_executable": "Replace with the environment variable's value | Path to the application's executable",
               "type": "external",
               "working_directory": "$GOPATH/src/github.com/grafana/grafana/",
               "_comment_working_directory": "Replace with the environment variable's value | Path to the application's files"
         }
      }
   }
   ```

   See
   [Go application options]({{< relref "/unit/configuration.md#configuration-go" >}})
   and the Grafana [docs](https://grafana.com/docs/grafana/latest/administration/configuration/#static_root_path)
   for details.

7. Upload the updated configuration.

   {{< include "unit/howto_upload_config.md" >}}

   After a successful update, Grafana should be available on the listener's IP
   and port:

   ![Grafana on Unit - Setup Screen](/unit/images/grafana.png)
