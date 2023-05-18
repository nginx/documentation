The NGINX Controller API uses session cookies to authenticate requests. The session cookie is returned in response to a `GET /api/v1/platform/login` request. See the Login endpoint in the [NGINX Controller API Reference]({{< relref "api/_index.md" >}}) documentation for information about session cookie timeouts and invalidation.

{{< tip >}}
You can send a GET request to the login endpoint to find the status of the session token.
{{< /tip >}}

For example:

- Login and capture the session cookie:
  
  ```curl
  curl -c cookie.txt -X POST --url 'https://198.51.100.10/api/v1/platform/login' --header 'Content-Type: application/json' --data '{"credentials": {"type": "BASIC","username": "arthur@arthurdent.net","password": "Towel$123"}}'
  ```

- Use the session cookie to authenticate and get the session status:

  ```curl
  curl -b cookie.txt -c cookie.txt -X GET --url 'https://198.51.100.10/api/v1/platform/login'
  ```

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-345 -->