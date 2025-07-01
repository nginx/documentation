---
nd-docs: DOCS-000
---

The only configuration related to streaming is the IDL file or more specifically the `rpc` declaration. The keyword `stream` indicates that the message on the respective side is streaming. <br> <br>For example:

#### Client Stream

Where the client writes a sequence of messages and sends them to the server, again using a provided stream. Once the client has finished writing the messages, it waits for the server to read them and return its response. Again gRPC guarantees message ordering within an individual RPC call.

```shell
rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
```
#### Server Stream

Where the client sends a request to the server and gets a stream to read a sequence of messages back. The client reads from the returned stream until there are no more messages. gRPC guarantees message ordering within an individual RPC call.

```shell
rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
```
#### Bidirectional Streams

Where both sides send a sequence of messages using a read-write stream. The two streams operate independently, so clients and servers can read and write in whatever order they like: for example, the server could wait to receive all the client messages before writing its responses, or it could alternately read a message and then write a message, or some other combination of reads and writes. The order of messages in each stream is preserved.

```shell
rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
```

#### Bidirectional IDL File Example:

```proto
syntax = "proto3";
package streaming;
service Greeter {
  rpc BothUnary (HelloRequest) returns (HelloReply) {}
  rpc ClientStreaming (stream HelloRequest) returns (HelloReply) {}
  rpc ServerStreaming (HelloRequest) returns (stream HelloReply) {}
  rpc BidirectionalStreaming (stream HelloRequest) returns (stream HelloReply) {}
}
message HelloRequest {
  string message = 1;
}
message HelloReply {
  string message = 1;
}
```

#### Enabling the gRPC Protection for Bidirectional Streaming

For enabling the gRPC capability, an HTTP/2 server definition needs to be applied with the `grpc_pass` location in the `nginx.conf` file. In addition, the `app_protect_policy_file` directive points to a policy specific to gRPC. All the gRPC messages will be logged in Security Log under the `log_grpc_all.json` file. For more details on how these requests are handled in gRPC, refer to the [gRPC Logging](#grpc-logging) section.

```nginx
user nginx;
worker_processes auto;

load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;
working_directory /tmp/cores;
worker_rlimit_core 1000M;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    keepalive_timeout  30m;
    client_body_timeout 30m;
    client_max_body_size 0;
    send_timeout 30m;

    proxy_connect_timeout  30m;
    proxy_send_timeout  30m;
    proxy_read_timeout  30m;
    proxy_socket_keepalive on;

    server {
        listen       80 default_server http2;
        server_name  localhost;
        app_protect_enable on;
        app_protect_policy_file "/etc/app_protect/conf/grpc_policy.json";
        app_protect_security_log_enable on;
        app_protect_security_log "/opt/app_protect/share/defaults/log_grpc_all.json" /tmp/grpc.log;

        grpc_socket_keepalive on;
        grpc_read_timeout 30m;
        grpc_send_timeout 30m;

        location / {
            default_type text/html;
            grpc_pass grpc://<GRPC_BACKEND_SERVER_IP>:<PORT>;
        }
    }
}
```

#### Policy with the profile example:

Refer to the above section for more details on [policy with the profile example](#policy-with-the-profile-example).