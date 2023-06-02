To make API requests using basic authentication, you can include the base64-encoded credentials as a "Basic" token in the "Authorization" request header. Here's an example using cURL:

``` bash
curl -X GET "https://<NMS_FQDN>/api/platform/<API_VERSION>/systems" -H "Authorization: Basic YWRtaW..."
```

In the above example, replace `<NMS_FQDN>` with the fully qualified domain name of your NGINX Management Suite instance and `<API_VERSION>` with the desired API version.

The `-H "Authorization: Basic YWRtaW..."` flag specifies the "Authorization" header with the base64-encoded credentials. You should replace `YWRtaW...` with the actual base64-encoded username and password combination.

<br>

{{<warning>}}While basic authentication can be used for API requests, it’s important to consider the security implications. Basic authentication transmits credentials in plain text, which can pose a security risk if intercepted. For this reason, token-based authentication and OAuth are recommended in production environments, especially when security is a concern.{{</warning>}}

