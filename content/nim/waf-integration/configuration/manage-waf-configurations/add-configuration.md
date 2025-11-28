---
title: Add WAF configuration
description: Add default or custom WAF policies to your NGINX instances.
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIMNGR
nd-docs:
---

Start by adding an F5 WAF for NGINX configuration to your instances. You can apply one of the built-in security policies or reference your own custom policy bundle.

The [F5 WAF for NGINX configuration guide]({{< ref "/waf/policies/configuration.md" >}}) explains how and where to add security directives in your NGINX configuration. **F5 NGINX Instance Manager** provides the same default security policies:

- **NGINX Default Policy** — Includes [OWASP Top 10](https://owasp.org/www-project-top-ten/) protections and basic bot mitigation.
- **NGINX Strict Policy** — Applies tighter blocking criteria than the default policy and may increase the risk of false positives.

You can use these defaults as-is or customize them for your application. Security Monitoring dashboards in **NGINX Instance Manager** can help you fine-tune policy behavior over time.

## Before you begin

Keep the following points in mind when configuring F5 WAF for NGINX through **NGINX Instance Manager**:

- **Policy bundles:** Instance Manager compiles JSON security policies into `.tgz` bundles.
- **Custom policies:** Use the `app_protect_policy_file` directive to reference custom policies. If you’re using precompiled publication with NGINX Agent, change the file extension from `.json` to `.tgz`. The filename itself stays the same. **NGINX Instance Manager** doesn’t support mixing `.json` and `.tgz` references in the same configuration.
- **Access permissions:** Ensure the NGINX Agent can access directories where your policy files are stored. Update the `config_dirs` setting in the Agent configuration if needed.
- **Logging:** **NGINX Instance Manager** uses the default log profiles included with F5 WAF for NGINX. You can reference them with the `app_protect_security_log` directive. Custom log profiles aren’t supported.

If your data plane uses different directory paths, update them accordingly in your configuration files.

## Next steps

Once you’ve added your WAF configuration:

- [Edit the WAF configuration]({{< ref "edit-waf-configuration.md" >}}) to apply directives in your NGINX configuration files.
- [Verify the configuration]({{< ref "verify-configuration.md" >}}) to confirm that WAF is active on your instances.