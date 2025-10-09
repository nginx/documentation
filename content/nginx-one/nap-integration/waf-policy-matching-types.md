---
title: "Matching types: Explicit vs Wildcard"
weight: 700
toc: true
nd-content-type: how-to
nd-product: NGINX One Console
---

In F5 WAF for NGINX (formerly known as NGINX App Protect WAF), matching can be defined in two ways:

## Explicit Matching

Explicit matching refers to direct matches to specific names or paths in your application. For example:
- URLs: `/index.html`, `/api/data`
- Cookies: `sessionId`, `userPrefs`
- Parameters: `username`, `email`

Use explicit matching when you need to protect specific, known entities.

## Wildcard Matching

Wildcard matching uses patterns to match multiple similar names or paths. For example:
- URLs: `/test*` matches `/test`, `/test123`, `/testing`
- Cookies: `test*` matches `test`, `test123`, `testing`
- Parameters: `user*` matches `username`, `user_id`, `userEmail`

Wildcard matching is useful when:
- You need to protect multiple similar entities
- You want to apply the same security controls to a group
- The exact names or paths may vary or are dynamically generated

Both explicit and wildcard matching allow you to configure additional properties, such as enforcement type, attack signatures, and more, depending on the entity being protected.
