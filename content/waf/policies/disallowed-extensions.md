---
# We use sentence case and present imperative tone
title: "Disallowed file type extensions"
# Weights are assigned in increments of 100: determines sorting order
weight: 1000
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes the disallowed file type extensions feature for F5 WAF by NGINX.

The following file types are disallowed by default:

- bak, bat, bck, bkp, cfg, conf, config, ini, log, old, sav, save, temp, tmp
- bin, cgi, cmd, com, dll, exe, msi, sys, shtm, shtml, stm
- cer, crt, der, key, p12, p7b, p7c, pem, pfx
- dat, eml, hta, htr, htw, ida, idc, idq, nws, pol, printer, reg, wmz
