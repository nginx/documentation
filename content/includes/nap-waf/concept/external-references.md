---
nd-docs: DOCS-000
---

External references in policy are defined as any code blocks that can be used as part of the policy without being explicitly pasted within the policy file. This means that you can have a set of pre-defined configurations for parts of the policy, and you can incorporate them as part of the policy by simply referencing them. This would save a lot of overhead having to concentrate everything into a single policy file.

A perfect use case for external references is when you wish to build a dynamic policy that depends on moving parts. You can have code create and populate specific files with the configuration relevant to your policy, and then compile the policy to include the latest version of these files, ensuring that your policy is always up to date when it comes to a constantly changing environment.

**Note**: Any update of a single file referenced in the policy will not trigger a policy compilation. This action needs to be done actively by reloading the NGINX configuration.

To use the external references capability, in the policy file the direct property is replaced by "xxxReference" property, where xxx defines the replacement text for the property changed to singular (if originally plural) and notation converted from snake case to camelCase. For example, `modifications` section is replaced by `modificationsReference` and `data-guard` is replaced by `dataGuardReference`.