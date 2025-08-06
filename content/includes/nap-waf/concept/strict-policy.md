The Strict Policy is recommended as a starting point for applications requiring a higher level of security. Just like all other policies it is based on the base template, so it detects and blocks everything the default policy does.
To obtain the Strict Policy, execute the following command:

```shell
sudo docker run --rm -v $(pwd):$(pwd) --entrypoint='' private-registry.nginx.com/nap/waf-compiler:1.0.0 cat /etc/app_protect/conf/NginxStrictPolicy.json
```

Replace the `1.0.0` with the actual release version.

In addition the Strict Policy also **blocks** the following:
- Requests that have a Violation Rating of 3, "Needs examination". This occurs because the `VIOL_RATING_NEED_EXAMINATION` violation's block flag is enabled in the strict policy.
- Requests with the `VIOL_EVASION` violation (evasion techniques).
- Requests with violations that restrict options in the request and response: HTTP method, response status code and disallowed file types.

{{< call-out "note" >}} Other violations, specifically attack signatures and metacharacters, which are more prone to false positives, still have only Alarm turned on, without blocking, contributing to the Violation Rating as in the Default policy.{{< /call-out >}}

In addition, the Strict policy also enables the following features in **alarm only** mode:
- **Data Guard**: masking Credit Card Number (CCN), US Social Security Number (SSN) and custom patterns found in HTTP responses.

- **HTTP response data leakage signatures**: preventing exfiltration of sensitive information from the servers.
- **More restrictive limitations**: mainly sizing and parsing of JSON and XML payloads.
- **Cookie attribute insertion**: the Strict policy adds the **Secure** and **SameSite=lax** attributes to every cookie set by the application server. These attributes are enforced by the browsers and protect against session hijacking and CSRF attacks respectively.