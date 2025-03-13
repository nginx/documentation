---
description: Learn about the NGINX App Protect WAF Debug Log.
docs: DOCS-913
title: NGINX App Protect WAF Debug Log
toc: true
weight: 540
type:
- concept
---

## Debug Logs

Debug log settings determine the minimum log level and the internal App Protect components included in the log.

`nginx.conf` does not refer to the NGINX App Protect WAF debug log configuration neither directly nor indirectly.

### Logger Configuration File

The logging configuration file is located in: `/etc/app_protect/bd/logger.cfg` and contains the App Protect modules for logging and debugging.

```none
################################################################################################
#
#                                        Logger configuration file
#
#       Existing modules:
#
#       IO_PLUGIN (Requests & Responses) FTP_PLUGIN (ftp) SMTP_PLUGIN (smtp)
#       BEM (Accumulation Responses), ECARD (Tables),
#       ECARD_POLICY (Enforcer), BD_SSL (Communications), UMU (Memory),
#       IMF (Sockets), BD_MISC (Config and miscs),COOKIE_MGR (Cookies), REG_EXP (Regular expressions),
#       RESP_PARAMS (Extractions), ATTACK_SIG (Attack Signatures), BD_XML(XML Enforcer),
#       ATTACK_ENGINE (BF & BOT detect monitor), XML_PARSER (all xml engine), ACY (pattern match engine),
#       BD_PB (policy builder), BD_PB_SAMPLING (sampling decisions for pb), LEGAL_HASH (internal cache tables),
#       CLIENT_SIDE (Client Side infrastructure), STATS (policy builder statistics), ICAP (content inspection),
#       CLUSTER_ANOMALY (the anomaly distributed channel), PIPE (shmem channel bd-pbng, bd-lrn),
#       MPP_PARSER (Multipart parser), SA_PLUGIN (Session awareness), DATA_PROTECT (Data Protection Library),
#       GDM (Guardium DB security), ASM_IRULE (ASM iRule commands), LIBDATASYNC (Data Sync Library),
#       BD_CONF (BD MCP configuration), MPI_CHANNEL (BD initiated MPI events),
#       BD_FLUSH_TBLS(flush BD conf tables), CSRF (CSRF feature), BRUTE_FORCE_ENFORCER (Brute Force feature),
#       LONG_REQUEST (Long request), HTML_PARSER (HTML parser)
#
#       Log levels:
#
#       TS_DEBUG | TS_INFO | TS_NOTICE | TS_WARNING | TS_ERR | TS_CRIT
#
#       File numbers:
#
#       errors.log = 2 , debug.log = 3 (see /ts/agent/log.cfg)
#
```

### Enabling Debug Logging

To add a module for logging:

```none
#       MODULE = <module_name>;
#       LOG_LEVEL = <log level 1> | <log level 2> | ... | <log level n>;
#       FILE = <file number> (recommended 2 always);
#
#       Use # to comment out lines.
```

For example:

```none
MODULE=IO_PLUGIN;
LOG_LEVEL=TS_INFO | TS_DEBUG;
FILE = 2;
```

```none
MODULE = ALL;
LOG_LEVEL = TS_ERR | TS_CRIT | TS_WARNING | TS_NOTICE;
FILE=2;
```
