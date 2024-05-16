---
description: NGINX Analyzer Documentation
docs: DOCS-629
doctypes:
- tutorial
tags:
- docs
title: Analyzer
toc: true
weight: 300
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document explains how to use the analyzer in NGINX Instance Manager.

## Prerequisites {#prerequisites}

1. Install NGINX Instance Manager Server.
2. Install NGINX or NGINX Plus and the NGINX Agent.
3. Start and Enable Instance Manager.

{{%heading "analyzer"%}}

## Analyzer from the UI {#analyzer-ui}

Open the user interface on `https://nginx-manager.example.com:11000` (or similar) and select the **Inventory** tab. Select the instance you want to analyze by clicking the instance ID link in the table.

Then select the **Config** tab at the top of the main panel to open the editor.

You can make the changes you need, and the analyzer will check your configuration when you move off the line you are editing.

## Analyzer from the API {#analyzer-api}

Call the API on https://nginx-manager.example.com:11000/api/v0/configs/analyze and run something similar to the following call.

```bash
curl -X POST "https://nginx-manager.example.com/api/v0/configs/analyze" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"partial\": false,  \"plus\": true,  \"contents\": \"ICMgRm9yIG1vcmUgaW5mb3JtYXRpb24gb24gY29uZmlndXJhdGlvbiwgc2VlOgojICAgKiBPZmZpY2lhbCBFbmdsaXNoIERvY3VtZW50YXRpb246IGh0dHA6Ly9uZ2lueC5vcmcvZW4vZG9jcy8KIyAgICogT2ZmaWNpYWwgUnVzc2lhbiBEb2N1bWVudGF0aW9uOiBodHRwOi8vbmdpbngub3JnL3J1L2RvY3MvCgp1c2VyIG5naW54Owp3b3JrZXJfcHJvY2Vzc2VzIGF1dG87CmVycm9yX2xvZyAvdmFyL2xvZy9uZ2lueC9lcnJvci5sb2c7CnBpZCAvcnVuL25naW54LnBpZDsKCiMgTG9hZCBkeW5hbWljIG1vZHVsZXMuIFNlZSAvdXNyL3NoYXJlL2RvYy9uZ2lueC9SRUFETUUuZHluYW1pYy4KI2luY2x1ZGUgL3Vzci9zaGFyZS9uZ2lueC9tb2R1bGVzLyouY29uZjsKCmV2ZW50cyB7CiAgICB3b3JrZXJfY29ubmVjdGlvbnMgMTAyNDsKfQoKaHR0cCB7CiAgICBsb2dfZm9ybWF0IG1haW4gJyRyZW1vdGVfYWRkciAtICRyZW1vdGVfdXNlciBbJHRpbWVfbG9jYWxdICIkcmVxdWVzdCIgJyAnJHN0YXR1cyAkYm9keV9ieXRlc19zZW50ICIkaHR0cF9yZWZlcmVyIiAnICciJGh0dHBfdXNlcl9hZ2VudCIgIiRodHRwX3hfZm9yd2FyZGVkX2ZvciInOwoKICAgIGluY2x1ZGUgL2V0Yy9uZ2lueC90ZXN0LmNvbmY7CgogICAgZXJyb3JfbG9nIC92YXIvbG9nL25naW54L2Vycm9yLmxvZyB3YXJuOwoKICAgIGFjY2Vzc19sb2cgL3Zhci9sb2cvbmdpbngvYWNjZXNzLmxvZyBtYWluOwoKICAgIHNlbmRmaWxlIG9mZjsKICAgIHRjcF9ub3B1c2ggb247CiAgICB0Y3Bfbm9kZWxheSBvbjsKICAgIGtlZXBhbGl2ZV90aW1lb3V0IDY1OwogICAgdHlwZXNfaGFzaF9tYXhfc2l6ZSAyMDQ4OwoKICAgIGluY2x1ZGUgL2V0Yy9uZ2lueC9taW1lLnR5cGVzOwogICAgZGVmYXVsdF90eXBlIGFwcGxpY2F0aW9uL29jdGV0LXN0cmVhbTsKCiAgICAjIExvYWQgbW9kdWxhciBjb25maWd1cmF0aW9uIGZpbGVzIGZyb20gdGhlIC9ldGMvbmdpbngvY29uZi5kIGRpcmVjdG9yeS4KICAgICMgU2VlIGh0dHA6Ly9uZ2lueC5vcmcvZW4vZG9jcy9uZ3hfY29yZV9tb2R1bGUuaHRtbCNpbmNsdWRlCiAgICAjIGZvciBtb3JlIGluZm9ybWF0aW9uLgogICAgaW5jbHVkZSAvZXRjL25naW54L2NvbmYuZC8qLmNvbmY7Cn0K\"}"
```

This should present you with a response similar to the one below.

{{<fa "download">}} {{<link "/nim/previous-versions/static/previous-versions/v1/guides/analyzer/errors.json" "errors.json">}}
{{<fa "download">}} {{<link "/nim/previous-versions/static/previous-versions/v1/guides/analyzer/warnings.json" "warnings.json">}}
