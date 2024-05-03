---
docs:
---

``` go
{{ $augmentData := .AugmentData.V1 }}
{{ $server := index .Args 1 }}
{{ $location := index .Args 0 }}
{{ $arguments := dict }}

{{/* Get the label for the location in the base template */}}
{{ $locationLabel := $location.templateInput.nameExpression | trim | lower }}

{{/* Check to see if we have nameExpression (label) for this location ID */}}
{{ range $args := $augmentData.location.templateInput.locations }}
  {{ $targetLabel := $args.targetLabel | trim | lower }}
  {{ if (eq $targetLabel $locationLabel) }}
    {{ $arguments = $args }}
    {{ break }}
  {{ end }}
{{ end }}

{{/* If augment arguments related to this location were found, perform templating */}}
{{ if not (empty $arguments) }}
  proxy_pass http://{{ $arguments.upstreamName }};
{{ end }}
```