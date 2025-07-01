---
nd-docs: "DOCS-1565"
---

A gRPC service can have a stream of messages on each side: client, server, or both. Bidirectional Streaming leverages HTTP/2 streaming capability, namely the ability to send multiple gRPC messages from either side ended by the message having the `END_STREAM` flag set to 1.

The Bidirectional Streaming will:

1. Accept streaming services on either or both sides (client or server) and send a sequence of messages using a read-write stream.
2. Inspect the client messages in the stream and log them one by one.
3. In case of blocking action:
    - Send the blocking response.
    - Close the stream on both directions.
4. Pass the server messages through without inspection.

<br> The below image demonstrates bidirectional streaming (client-side and server-side streaming):

{{< img src="/grpc/grpc_streaming.png" alt="gRPC Streaming" >}}
<br>