---
docs: "DOCS-1550"
---

JSON Web Token (JWT) is a compact and self-contained way to represent information between two parties in a JSON (JavaScript Object Notation) format and is commonly used for authentication and authorization. With NGINX App Protect now it is possible to control access to its application using JWT validation. NGINX App Protect WAF validates the authenticity and well-formedness of JWTs coming from a client, denying access to the service exclusively when the validation process fails. JWT is mainly used for API access.

When a user logs in to a web application, they might receive a JWT, which can then be included in subsequent requests to the server. The server can validate the JWT to ensure that the user is authenticated to access the requested resources.

Now NGINX App Protect WAF provides JSON Web Token (JWT) protection. NGINX App Protect WAF will be placed in the path leading to the application server and will handle the token for the application. This includes:

1. Validating the token's existence and ensuring its correct structure for specific URLs.
2. Verifying the token's signature based on provisioned certificates.
3. Check the validity period of the token.
4. Extract the user identity from the token and use it for logging and session awareness.

The JSON Web Token consists of three parts: the **Header**, **Claims** and **Signature**. The first two parts are in JSON and Base64 encoded when carried in a request. The three parts are separated by a dot "." delimiter and put in the authorization header of type "Bearer", but can also be carried in a query string parameter.

- **Header**: It contains information about the type of token (usually "JWT") and the cryptographic algorithm being used to secure the JSON Web Signature (JWS).

- **Claims**: This part contains claims, which refers to the statements or assertions about an entity (typically, the user) that the token is issued for. Claims are **key/value** pairs contained within the token's payload. The claims is the second part of a JWT and typically looks like this:

    ```json
    {
      "sub": "1234567890",
      "name": "John Doe",
      "iat": 1654591231,
      "nbf": 1654607591,
      "exp": 1654608348
    }
    ```

In example above, the payload contains several claims:

- sub (Subject) - Represents the subject of the JWT, typically the user or entity for which the token was created.

- name (Issuer) - Indicates the entity that issued the JWT. It is a string that identifies the issuer of the token.

- iat (Issued At) - Indicates the time at which the token was issued. Like exp, it is represented as a timestamp.

- nbf (Not Before) - Specifies the time before which the token should not be considered valid.

- exp (Expiration Time) - Specifies the expiration time of the token. It is represented as a numeric timestamp (for example, 1654608348), and the token is considered invalid after this time.

These claims provide information about the JWT and can be used by the recipient to verify the token's authenticity and determine its validity. Additionally, you can include custom claims in the payload to carry additional information specific to your application.

- **Signature** - To create the signature part, the header and payload are encoded using a specified algorithm and a secret key. This signature can be used to verify the authenticity of the token and to ensure that it has not been tampered with during transmission. The signature is computed based on the algorithm and the keys used and also Base64-encoded.

#### NGINX App Protect WAF supports the following types of JWT:

JSON Web Signature (JWS) - JWT content is digitally signed. The following algorithm can be used for signing:

- RSA/SHA-256 (RS256 for short)

Here is an example of a Header: describes a JWT signed with HMAC 256 encryption algorithm:

```json
{
  "alg": "RS256",
  "typ": "JWT"
}
```