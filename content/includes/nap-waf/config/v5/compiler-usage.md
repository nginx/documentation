---
docs: "DOCS-1629"
---

{{< note >}}
This section assumes that you built a customized compiler image - `waf-compiler-1.0.0:custom`.
{{< /note >}}

#### Policy Compilation

To compile a security policy from a JSON file and create a policy bundle, execute the following command:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -p $(pwd)/policy.json -o $(pwd)/compiled_policy.tgz
```

#### Logging Profile Compilation

To compile a logging profile, execute the command below:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -l $(pwd)/log_01.json -o $(pwd)/log01.tgz
```

#### Bundle Information

To view information about a bundle file, use the following command:

```shell
docker run \
 -v $(pwd):$(pwd) \
 waf-compiler-1.0.0:custom \
 -dump -bundle $(pwd)/compiled_policy.tgz
```

#### WAF Compiler in CI/CD

When executing commands inside the compiler container, especially if it's part of a CI/CD process and you're overriding the default entrypoint, ensure that you use `/opt/app_protect/bin/apcompile` as the compiler binary. For example:

```shell
/opt/app_protect/bin/apcompile -p /path/to/policy.json -o /path/to/compiled_policy.tgz
```