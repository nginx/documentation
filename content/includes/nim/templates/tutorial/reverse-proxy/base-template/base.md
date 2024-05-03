---
docs:
---

``` go
{{/*
    A simple base template that provides augment injection points for
    the main context, the http context, upstreams, servers, and locations.
*/}}
{{ $input := .}}
{{ $baseData := .Data.V1}}

{{/* Augments targeting the main context are injected here */}}
{{ $input.ExecTemplateAugments "main" }}
events {
    worker_connections  1024;
}

http {
    {{/* Augments targeting the http context are injected here */}}
    {{ $input.ExecTemplateAugments "http" }}
    {{ range $upstreamIndex, $upstream := $baseData.http.upstreams }}
          upstream {{$upstream.templateInput.nameInConfig}} {
              {{$upstreamTemplateInput := $upstream.templateInput}}
              {{range $serverIndex, $upstreamServer := $upstreamTemplateInput.servers}}
                  {{$port := ""}}
                  {{if $upstreamServer.port}}
                      {{$port = (printf ":%0.f" $upstreamServer.port)}}
                  {{end}}
                  server {{$upstreamServer.address}}{{$port}};
              {{end}}

              {{/* Augments targeting the this $upstream are injected here */}}
              {{ $input.ExecTemplateAugments "http-upstream" $upstream }}
          }
    {{end}}

    {{ range $serverIndex, $server := $baseData.http.servers}}
        server {
            server_name {{$server.templateInput.serverNameInConfig}};
            {{ range $locationIndex, $location := $server.locations}}
                location {{$location.templateInput.locationMatchExpression}} {
                  {{/* Augments targeting the this $location are injected here */}}
                  {{ $input.ExecTemplateAugments "location" $location $server }}
                }
            {{end}}

            {{/* Augments targeting the this $server are injected here */}}
            {{ $input.ExecTemplateAugments "http-server" $server }}
        }
    {{end}}
}
```
