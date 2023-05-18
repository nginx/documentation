To use the [NGINX Controller REST API]({{< relref "api/_index.md" >}}) to download your NGINX Plus certificate and key bundle as a gzip or JSON file, send a GET request to the `/platform/licenses/nginx-plus-licenses/controller-provided` endpoint.

For example:

- Download JSON file:

  ```bash
  curl -b cookie.txt -c cookie.txt --header 'Content-Type: application/json' -X GET --url 'https://192.0.2.0/api/v1/platform/licenses/nginx-plus-licenses/controller-provided'  --output nginx-plus-certs.json
  ```

- Download GZIP file:

  ```bash
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://192.0.2.0/api/v1/platform/licenses/nginx-plus-licenses/controller-provided' --output nginx-plus-certs.gz
  ```

{{< note >}}
If you are using a self-signed certificate you will need to add `-k` (allow insecure connections) to your curl command to be able to download your NGINX Plus certificate and key bundle. 
{{< /note >}}


Once you have downloaded your certificate and key bundle you will need to expand the `.gz` file to get your certificate and key pair.

For example:

```bash
gunzip nginx-plus-certs.gz
```
<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-329 -->