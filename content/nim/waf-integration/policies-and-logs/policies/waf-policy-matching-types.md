---
title: "Matching types: Explicit vs. Wildcard"
description: Learn how explicit and wildcard matching determine how F5 WAF for NGINX identifies and protects URLs, cookies, and parameters.
toc: true
weight: 700
nd-content-type: how-to
nd-product: NIM
nd-docs:
---

In F5 WAF for NGINX, you can define how the WAF identifies and protects URLs, cookies, and parameters using **explicit** or **wildcard** matching. The matching type determines how closely the WAF compares incoming requests to the entities defined in your security policy.

## Explicit matching

Explicit matching applies protection to exact names or paths in your application. Use this option when you want to secure specific, known entities.

**Examples:**

- URLs: `/index.html`, `/api/data`
- Cookies: `sessionId`, `userPrefs`
- Parameters: `username`, `email`

Explicit matching is best for applications with well-defined structures or limited dynamic content.

## Wildcard matching

Wildcard matching uses patterns to cover multiple related names or paths. Use this option when names follow a predictable pattern or are generated dynamically.

**Examples:**

- URLs: `/test*` matches `/test`, `/test123`, `/testing`
- Cookies: `test*` matches `test`, `test123`, `testing`
- Parameters: `user*` matches `username`, `user_id`, `userEmail`

Wildcard matching is useful when:

- You need to apply the same protection to a group of similar entities  
- The names or paths may vary dynamically  
- You want to simplify maintenance by reducing the number of explicit entries

Both explicit and wildcard matching let you define additional security properties such as enforcement mode, attack signatures, and other policy options, depending on the entity type.