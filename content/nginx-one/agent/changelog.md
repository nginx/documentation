---
title: "Changelog"
weight: 1200
toc: true
docs: "DOCS-1093"
---

{{< note >}}You can find the full changelog, contributor list and assets for NGINX Agent in the [GitHub repository](https://github.com/nginx/agent/releases).{{< /note >}}

See the list of supported Operating Systems and architectures in the [Technical Specifications]({{< ref "/nginx-one/agent/overview/tech-specs.md" >}}).

---
## Release [v3.0.0](https://github.com/nginx/agent/releases/tag/v3.0.0)

### 🌟 Highlights

- **NGINX Agent v3 and Management Plane Interface (MPI)**: NGINX Agent v3 is here! This release is a major milestone aimed at simplifying the management, monitoring, and scaling of your NGINX instances. With enhanced integrations, improved observability features, and support for modern orchestrated environments like Kubernetes.

### 🚀 Features

This release introduces the following new features:

- **Enhanced Kubernetes Integration with Management Plane Interface (MPI)**: NGINX Agent now offers full integration with Kubernetes-native products, such as the [NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/) and [NGINX Gateway Fabric](https://docs.nginx.com/nginx-gateway-fabric), enabling seamless fleet management, real-time observability, and smooth interoperability across Kubernetes deployments. This is powered by the Management Plane Interface (MPI), a standardized interface designed to provide a unified and consistent experience across NGINX solutions, with built-in support for Kubernetes-based applications. For detailed technical specifications, refer to the official Protocol Documentation .

### 📝 Documentation

We have made the following updates to the documentation:

- [Official NGINX Agent documentation](https://docs.nginx.com/nginx-agent/)
- [F5 Support](https://my.f5.com/manage/s/)

---
## Release [v2.41.1](https://github.com/nginx/agent/releases/tag/v2.41.1)

### 🚀 Features

This release introduces the following new features:

- Fix remotely enabling/disabling features by [@dhurley](https://github.com/dhurley) in [#1088](https://github.com/nginx/agent/pull/1088)

---
## Release [v2.41.0](https://github.com/nginx/agent/releases/tag/v2.41.0)

### 📝 Documentation

We have made the following updates to the documentation:

- Update agent landing page and readme by [@nginx-seanmoloney](https://github.com/nginx-seanmoloney) in [#1017](https://github.com/nginx/agent/pull/1017)
- Update dependencies  by [@dhurley](https://github.com/dhurley) in [#1026](https://github.com/nginx/agent/pull/1026)
- Update net and nats dependencies by [@dhurley](https://github.com/dhurley) in [#1070](https://github.com/nginx/agent/pull/1070)

### 🔨 Maintenance

We have made the following maintenance-related minor changes:

- Merge v2.40.1 back to main by [@dhurley](https://github.com/dhurley) in [#1049](https://github.com/nginx/agent/pull/1049)

---
## Release [v2.40.1](https://github.com/nginx/agent/releases/tag/v2.40.1)

### 🐛 Bug Fixes

In this release we have resolved the following issues:

- Add nil pointer check to GenerateMetricsReportBundle by [@dhurley](https://github.com/dhurley) in [#1047](https://github.com/nginx/agent/pull/1047)

---
## Release [v2.40.0](https://github.com/nginx/agent/releases/tag/v2.40.0)

### 🌟 Highlights

- The source code for the [NGINX Agent documentation](https://docs.nginx.com/nginx-agent/) has moved to the [NGINX Documentation](https://github.com/nginx/documentation/) repository. We invite you to [contribute](https://github.com/nginx/documentation/blob/main/CONTRIBUTING.md), improve the Agent docs and report any issues you find in the documentation repository.

### 🐛 Bug Fixes

In this release we have resolved the following issues:

- Lua config apply by [@oliveromahony](https://github.com/oliveromahony) in [#963](https://github.com/nginx/agent/pull/963)
- Fix release workflow by [@dhurley](https://github.com/dhurley) in [#991](https://github.com/nginx/agent/pull/991)

### 📝 Documentation

We have made the following updates to the documentation:

- Docs: updating links from /nginx-management-suite/nim to /nginx-instance-manager by [@nginx-aoife](https://github.com/nginx-aoife) in [#927](https://github.com/nginx/agent/pull/927)
- Autodeploy main docs to production by [@nginx-jack](https://github.com/nginx-jack) in [#924](https://github.com/nginx/agent/pull/924)
- docs: remove docs by [@JTorreG](https://github.com/JTorreG) in [#976](https://github.com/nginx/agent/pull/976)
- Add a docs page to explain NGINX Agent features by [@nginx-seanmoloney](https://github.com/nginx-seanmoloney) in [#941](https://github.com/nginx/agent/pull/941)
- docs: Fix NGINX install link and dockerfile section by [@JTorreG](https://github.com/JTorreG) in [#928](https://github.com/nginx/agent/pull/928)

### 🔨 Maintenance

We have made the following maintenance-related minor changes:

- Fail release job if packages fail to publish by [@dhurley](https://github.com/dhurley) in [#923](https://github.com/nginx/agent/pull/923)
- Update performance test Dockerfile to use NGINX R32 by [@dhurley](https://github.com/dhurley) in [#937](https://github.com/nginx/agent/pull/937)
- Updated golang.org/x/net version by [@oliveromahony](https://github.com/oliveromahony) in [#954](https://github.com/nginx/agent/pull/954)
- Update performance test dependencies by [@dhurley](https://github.com/dhurley) in [#984](https://github.com/nginx/agent/pull/984)
- Refactor integration tests by [@dhurley](https://github.com/dhurley) in [#985](https://github.com/nginx/agent/pull/985)
- Update dependencies by [@dhurley](https://github.com/dhurley) in [#98](https://github.com/nginx/agent/pull/98)
- Updated the crypto library version by [@oliveromahony](https://github.com/oliveromahony) in [#947](https://github.com/nginx/agent/pull/947)

---
## Release [v2.39.0](https://github.com/nginx/agent/releases/tag/v2.39.0)

### 🌟 Highlights

- Remove official docker images & move testing images to test folder by [@aphralG](https://github.com/aphralG) in [#838](https://github.com/nginx/agent/pull/838)

### 🐛 Bug Fixes

In this release we have resolved the following issues:

- Race conditions fixes by [@oliveromahony](https://github.com/oliveromahony) in [#810](https://github.com/nginx/agent/pull/810)
- fix r30 pipeline failures by [@oliveromahony](https://github.com/oliveromahony) in [#844](https://github.com/nginx/agent/pull/844)
- Fixed make target pointing at wrong Dockerfile and renamed others to be consistent by [@oliveromahony](https://github.com/oliveromahony) in [#857](https://github.com/nginx/agent/pull/857)
- Fix broken links causing deployment failures by [@ADubhlaoich](https://github.com/ADubhlaoich) in [#863](https://github.com/nginx/agent/pull/863)
- Fix NGINX OSS integration tests by [@dhurley](https://github.com/dhurley) in [#888](https://github.com/nginx/agent/pull/888)
- Fix docs docker failing without git context by [@nginx-jack](https://github.com/nginx-jack) in [#892](https://github.com/nginx/agent/pull/892)

### 📝 Documentation

We have made the following updates to the documentation:

- Add automatic changelog generation in release workflow by [@spencerugbo](https://github.com/spencerugbo) in [#784](https://github.com/nginx/agent/pull/784)
- Add CLA bot workflow by [@lucacome](https://github.com/lucacome) in [#828](https://github.com/nginx/agent/pull/828)
- Refactor docker images by [@nginx-seanmoloney](https://github.com/nginx-seanmoloney) in [#841](https://github.com/nginx/agent/pull/841)
- Docs: Add hugo version check and theme update to Makefile by [@nginx-jack](https://github.com/nginx-jack) in [#869](https://github.com/nginx/agent/pull/869)
- Change casing of docs makefile to Makefile by [@nginx-jack](https://github.com/nginx-jack) in [#884](https://github.com/nginx/agent/pull/884)
- docs: enableGitInfo config and docs-action bump by [@nginx-jack](https://github.com/nginx-jack) in [#886](https://github.com/nginx/agent/pull/886)
- Change go version to latest go 1.23.2 by [@oliveromahony](https://github.com/oliveromahony) in [#889](https://github.com/nginx/agent/pull/889)
- Remove link to github dockerfiles by [@nginx-seanmoloney](https://github.com/nginx-seanmoloney) in [#897](https://github.com/nginx/agent/pull/897)
- Docs: Update link to 3rd party site by [@nginx-aoife](https://github.com/nginx-aoife) in [#898](https://github.com/nginx/agent/pull/898)
- Update the changelog for v2.38 by [@ADubhlaoich](https://github.com/ADubhlaoich) in [#901](https://github.com/nginx/agent/pull/901)

### 🔨 Maintenance

We have made the following maintenance-related minor changes:

- Set log level to debug for inetegration tests by [@aphralG](https://github.com/aphralG) in [#826](https://github.com/nginx/agent/pull/826)
- updated runc dependency highlighted in security scan scan by [@oliveromahony](https://github.com/oliveromahony) in [#842](https://github.com/nginx/agent/pull/842)
- Update CODEOWNERS by [@oCHRISo](https://github.com/oCHRISo) in [#851](https://github.com/nginx/agent/pull/851)
- Check version command output by [@aphralG](https://github.com/aphralG) in [#853](https://github.com/nginx/agent/pull/853)
- Bump NGINX plus go client version from v1 to v2 by [@dhurley](https://github.com/dhurley) in [#879](https://github.com/nginx/agent/pull/879)
- Allowlist Error Messages by [@aphralG](https://github.com/aphralG) in [#907](https://github.com/nginx/agent/pull/907)

---
## Release [v2.38.0](https://github.com/nginx/agent/releases/tag/v2.38.0)

### 🐛 Bug Fixes

In this release we have resolved the following issues:

- Fix broken URLS in docs by [@nginx-aoife](https://github.com/nginx-aoife) in [#796](https://github.com/nginx/agent/pull/796)
- fix name of deprecated flag by [@aphralG](https://github.com/aphralG) in [#811](https://github.com/nginx/agent/pull/811)
- Fix make image targets by [@dhurley](https://github.com/dhurley) in [#812](https://github.com/nginx/agent/pull/812)
- Fix debian oss image by [@dhurley](https://github.com/dhurley) in [#819](https://github.com/nginx/agent/pull/819)

### 📝 Documentation

We have made the following updates to the documentation:

- docs: update GPG keys by [@Jcahilltorre](https://github.com/Jcahilltorre) in [#776](https://github.com/nginx/agent/pull/776)
- Add new docker images to v2 pipeline for integration testing by [@oliveromahony](https://github.com/oliveromahony) in [#756](https://github.com/nginx/agent/pull/756)
- Update website changelog for v2.37.0 by [@ADubhlaoich](https://github.com/ADubhlaoich) in [#790](https://github.com/nginx/agent/pull/790)
- Pass on custom error log path at the time of validating config by [@achawla2012](https://github.com/achawla2012) in [#774](https://github.com/nginx/agent/pull/774)
- Remove blocking calls in metrics framework by [@oliveromahony](https://github.com/oliveromahony) in [#788](https://github.com/nginx/agent/pull/788)
- Update broken URL in installation-plus.md by [@nginx-aoife](https://github.com/nginx-aoife) in [#808](https://github.com/nginx/agent/pull/808)

### 🔨 Maintenance

We have made the following maintenance-related minor changes:

- add new plus docker images to v2 pipeline by [@aphralG](https://github.com/aphralG) in [#779](https://github.com/nginx/agent/pull/779)
- Add MaxRecvMsgSize and MaxSendMsgSize to client and server options by [@oliveromahony](https://github.com/oliveromahony) in [#795](https://github.com/nginx/agent/pull/795)
- added leak tests for agent v2 by [@oliveromahony](https://github.com/oliveromahony) in [#807](https://github.com/nginx/agent/pull/807)

---
## Release [v2.37.0](https://github.com/nginx/agent/releases/tag/v2.37.0)

### 🚀 Features

This release introduces the following new features:

- feat: Update the changelog by [@ADubhlaoich](https://github.com/ADubhlaoich) in [#753](https://github.com/nginx/agent/pull/753)

### 🐛 Bug Fixes

In this release we have resolved the following issues:

- Prevent writing outside allowed directories list from a config payload with actions by [@oliveromahony](https://github.com/oliveromahony) in [#766](https://github.com/nginx/agent/pull/766)
- The letter v is now always prepended to output of -v by [@olli-holmala](https://github.com/olli-holmala) in [#751](https://github.com/nginx/agent/pull/751)
- Fix backoff to drop Metrics Reports from buffer after max_elapsed_time has been reached by [@oliveromahony](https://github.com/oliveromahony) in [#752](https://github.com/nginx/agent/pull/752)
- Fix Post Install Script Issues by [@spencerugbo](https://github.com/spencerugbo) in [#739](https://github.com/nginx/agent/pull/739)
- docs: fix github links in changelog by [@Jcahilltorre](https://github.com/Jcahilltorre) in [#770](https://github.com/nginx/agent/pull/770)
- Fix post install script for when no nginx instance is installed by [@dhurley](https://github.com/dhurley) in [#773](https://github.com/nginx/agent/pull/773)

### 📝 Documentation

We have made the following updates to the documentation:

- Upgrade prometheus exporter version to latest by [@oliveromahony](https://github.com/oliveromahony) in [#749](https://github.com/nginx/agent/pull/749)
- Add badges for Go version, release, license, contributions, and Slack… by [@oCHRISo](https://github.com/oCHRISo) in [#763](https://github.com/nginx/agent/pull/763)
- Add instructions for Amazon Linux 2023 by [@nginx-seanmoloney](https://github.com/nginx-seanmoloney) in [#759](https://github.com/nginx/agent/pull/759)
- Add docs-build-push github workflow by [@nginx-jack](https://github.com/nginx-jack) in [#765](https://github.com/nginx/agent/pull/765)

### 🔨 Maintenance

We have made the following maintenance-related minor changes:

- Increase timeout period for collecting metrics by [@oliveromahony](https://github.com/oliveromahony) in [#755](https://github.com/nginx/agent/pull/755)

---
## Release [v2.36.1](https://github.com/nginx/agent/releases/tag/v2.36.1)

### 🌟 Highlights

- Upgrade crossplane version to prevent Agent from rolling back in the case of valid NGINX configurations by [@oliveromahony](https://github.com/oliveromahony) in [#746](https://github.com/nginx/agent/pull/746)

### 🔨 Maintenance

We have made the following maintenance-related minor changes:

- Added version regex to parse the logs to see if matches vsemvar format by [@oliveromahony](https://github.com/oliveromahony) in [#747](https://github.com/nginx/agent/pull/747)

---
## Release [v2.36.0](https://github.com/nginx/agent/releases/tag/v2.36.0)

### 🐛 Bug Fixes

In this release we have resolved the following issues:

- Fix incorrect bold tag in heading by [@nginx-seanmoloney](https://github.com/nginx-seanmoloney) in [#715](https://github.com/nginx/agent/pull/715)
- URL fix for building docker image in README.md by [@y82](https://github.com/y82) in [#720](https://github.com/nginx/agent/pull/720)
- Fix for version by [@oliveromahony](https://github.com/oliveromahony) in [#732](https://github.com/nginx/agent/pull/732)

### 📝 Documentation

We have made the following updates to the documentation:

- More flexible container images for the official images by [@oliveromahony](https://github.com/oliveromahony) in [#729](https://github.com/nginx/agent/pull/729)
- Update configuration examples by [@nginx-seanmoloney](https://github.com/nginx-seanmoloney) in [#731](https://github.com/nginx/agent/pull/731)
- updated github.com/rs/cors version by [@oliveromahony](https://github.com/oliveromahony) in [#735](https://github.com/nginx/agent/pull/735)
- docs: update changelog by [@Jcahilltorre](https://github.com/Jcahilltorre) in [#736](https://github.com/nginx/agent/pull/736)
- Upgrade crossplane by [@oliveromahony](https://github.com/oliveromahony) in [#737](https://github.com/nginx/agent/pull/737)

