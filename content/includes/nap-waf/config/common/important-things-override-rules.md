---
nd-docs: "DOCS-1549"
---

Here are some key points to remember regarding the Override Rules feature:

- To ensure efficient compilation time and optimal resource allocation for policies, there are limitations in place. Currently, policies have a maximum limit of 10 rules and a maximum of 5 clauses in a condition. These limitations help maintain better performance and manageability. A compilation error will not occur if a policy file contains more than 5 clauses or 10 overrides.
- The replacement policy should not include any override rules. Override rules should be used to extend or switch to a different policy, rather than being part of the replacement policy itself.
- Each override rule will be compiled as a separate policy, whether extending the main policy or switching to a new one. The enforcer will switch to the policy that corresponds to the matched rule, but the main policy name will be reported along with the override rule property.
- The URI, host, and user-agent strings in the request will be treated as plain ASCII characters and won't undergo language decoding. If any of these strings contain non-ASCII characters, they may be misinterpreted and may not comply with rules that expect specific values in the conditions.