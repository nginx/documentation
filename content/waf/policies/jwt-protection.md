---
title: JWT protection
weight: 1650
toc: true
nd-content-type: reference
nd-product: NAP-WAF
---

JSON Web Tokens (JWTs) are a compact and self-contained way to represent information between two parties in JSON format, commonly used for authentication and authorization.
F5 WAF for NGINX validates the authenticity and well-formedness of JWTs, denying access when validation fails. JWTs are mainly used for API access.

When a user logs in to an application, they might receive a JWT, which is then included in subsequent requests.
The server validates the JWT to ensure the user is authorized to access the requested resources.

F5 WAF for NGINX handles tokens on behalf of the application by:

1. Validating the token's existence and structure for specific URLs.
1. Verifying the token's signature using provisioned certificates.
1. Checking the token validity period (`nbf`, `exp`).
1. Extracting user identity for logging and session awareness.

The JSON Web Token consists of three parts: the **Header**, **Claims** and **Signature**. The first two parts are in JSON and Base64 encoded when carried in a request. The three parts are separated by a dot "." delimiter and put in the authorization header of type "Bearer", but can also be carried in a query string parameter.

A JWT consists of three parts: **Header**, **Claims**, and **Signature**.
The header and claims are JSON objects, Base64 encoded, separated by `.` delimiters, and typically carried in the `Authorization` header of type `Bearer`.

- **Header**: Metadata about the token, for example type and algorithm.
- **Claims**: Assertions about the entity, for example user. Example claim:

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

   {{< table >}}
   | Claim | Description                                                                                      |
   |-------|--------------------------------------------------------------------------------------------------|
   | `sub` (Subject) | Represents the subject of the JWT, typically the user or entity for which the token was created. |
   | `name` (Issuer) | Indicates the entity that issued the JWT. It is a string that identifies the issuer of the token. |
   | `iat` (Issued At) | Indicates the time at which the token was issued. Like `exp`, it is represented as a timestamp. |
   | `nbf` (Not Before) | Specifies the time before which the token should not be considered valid. |
   | `exp` (Expiration Time) | Specifies the expiration time of the token. It is represented as a numeric timestamp (for example, `1654608348`), and the token is considered invalid after this time. |
   {{< /table >}}

   These claims provide information about the JWT and can be used by the recipient to verify the token's authenticity and determine its validity. Additionally, you can include custom claims in the payload to carry additional information specific to your application.

- **Signature** - To create the signature part, the header and payload are encoded using a specified algorithm and a secret key. This signature can be used to verify the authenticity of the token and to ensure that it has not been tampered with during transmission. The signature is computed based on the algorithm and the keys used and also Base64-encoded.

### Supported algorithms

Currently supported: `RS256` (RSA/SHA-256).

- Example JWT header:

   ```json
   {
   "alg": "RS256",
   "typ": "JWT"
   }
   ```

### Configure for JWT protection

#### Access profile

F5 WAF for NGINX introduces a new policy entity known as `accessProfile` to authenticate JSON Web Token. Access profile is added to the F5 WAF for NGINX policy to enforce JWT settings. JSON Web Token needs to be applied to the URLs for enforcement and includes the actions to be taken with respect to access tokens. It is specifically associated with HTTP URLs and does not have any predefined default profiles.

{{< call-out "note" >}}Currently, only one `accessProfile` is supported per policy{{< /call-out >}}

The access profile includes:

- **Enforcement settings**: `enforceMaximumLength`, `enforceValidityPeriod`, `keyFiles`.
- **Location**: where to expect the enforcement settings (`header` or `query`) and the name of the header parameter.
- **General settings**: `maximumLength`, `type` (`jwt`), and profile `name`.

#### Access profile example

Refer to the following example where all access profile properties are configured to enforce specific settings within the F5 WAF for NGINX policy. In this instance, we have established an access profile named `access_profile_jwt` located in the `authorization header`. The `maximumLength` for the token is defined as "2000", and `verifyDigitalSignature` is set to "true".

```shell
{
    "policy": {
        "name": "jwt_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "access-profiles": [
         {
            "description": "",
            "enforceMaximumLength": true,
            "enforceValidityPeriod": false,
            "keyFiles": [
               {
                  "contents": "{\r\n  \"keys\": [\r\n    {\r\n      \"alg\": \"RS256\",\r\n      \"e\": \"AQAB\",\r\n      \"kid\": \"1234\",\r\n      \"kty\": \"RSA\",\r\n      \"n\": \"tSbi8WYTScbuM4fe5qe4l60A2SG5oo3u5JDBtH_dPJTeQICRkrgLD6oyyHJc9BCe9abX4FEq_Qd1SYHBdl838g48FWblISBpn9--B4D9O5TPh90zAYP65VnViKun__XHGrfGT65S9HFykvo2KxhtxOFAFw0rE6s5nnKPwhYbV7omVS71KeT3B_u7wHsfyBXujr_cxzFYmyg165Yx9Z5vI1D-pg4EJLXIo5qZDxr82jlIB6EdLCL2s5vtmDhHzwQSdSOMWEp706UgjPl_NFMideiPXsEzdcx2y1cS97gyElhmWcODl4q3RgcGTlWIPFhrnobhoRtiCZzvlphu8Nqn6Q\",\r\n      \"use\": \"sig\",\r\n      \"x5c\": [\r\n        \"MIID1zCCAr+gAwIBAgIJAJ/bOlwBpErqMA0GCSqGSIb3DQEBCwUAMIGAMQswCQYDVQQGEwJpbDEPMA0GA1UECAwGaXNyYWVsMRAwDgYDVQQHDAd0ZWxhdml2MRMwEQYDVQQKDApmNW5ldHdvcmtzMQwwCgYDVQQLDANkZXYxDDAKBgNVBAMMA21heDEdMBsGCSqGSIb3DQEJARYOaG93ZHlAbWF0ZS5jb20wIBcNMjIxMTA3MTM0ODQzWhgPMjA1MDAzMjUxMzQ4NDNaMIGAMQswCQYDVQQGEwJpbDEPMA0GA1UECAwGaXNyYWVsMRAwDgYDVQQHDAd0ZWxhdml2MRMwEQYDVQQKDApmNW5ldHdvcmtzMQwwCgYDVQQLDANkZXYxDDAKBgNVBAMMA21heDEdMBsGCSqGSIb3DQEJARYOaG93ZHlAbWF0ZS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC1JuLxZhNJxu4zh97mp7iXrQDZIbmije7kkMG0f908lN5AgJGSuAsPqjLIclz0EJ71ptfgUSr9B3VJgcF2XzfyDjwVZuUhIGmf374HgP07lM+H3TMBg/rlWdWIq6f/9ccat8ZPrlL0cXKS+jYrGG3E4UAXDSsTqzmeco/CFhtXuiZVLvUp5PcH+7vAex/IFe6Ov9zHMVibKDXrljH1nm8jUP6mDgQktcijmpkPGvzaOUgHoR0sIvazm+2YOEfPBBJ1I4xYSnvTpSCM+X80UyJ16I9ewTN1zHbLVxL3uDISWGZZw4OXirdGBwZOVYg8WGuehuGhG2IJnO+WmG7w2qfpAgMBAAGjUDBOMB0GA1UdDgQWBBSHykVOY3Q1bWmwFmJbzBkQdyGtkTAfBgNVHSMEGDAWgBSHykVOY3Q1bWmwFmJbzBkQdyGtkTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCgcgp72Xw6qzbGLHyNMaCm9A6smtquKTdFCXLWVSOBix6WAJGPv1iKOvvMNF8ZV2RU44vS4Qa+o1ViBN8DXuddmRbShtvxcJzRKy1I73szZBMlZL6euRB1KN4m8tBtDj+rfKtPpheMtwIPbiukRjJrzRzSz3LXAAlxEIEgYSifKpL/okYZYRY6JF5PwSR0cvrfe/qa/G2iYF6Ps7knxy424RK6gpMbnhxb2gdhLPqDE50uxkr6dVHXbc85AuwAi983tOMhTyzDh3XTBEt2hr26F7jSeniC7TTIxmMgDdtYzRMwdb1XbubdtzUPnB/SW7jemK9I45kpKlUBDZD/QwER\"\r\n      ]\r\n    }\r\n  ]\r\n}",  # there can be more only one JWKs file (contents) in the policy JSON schema, however, the total amount of JWK in the JWKs is limited to 10.
                  "fileName": "JWKSFile.json"
               }
            ],
            "location": {
               "in": "header",  # the other option is: "query"
               "name": "authorization"  # the name of the header or parameter (according to "part")
            },
            "maximumLength": 2000,
            "name": "access_profile_jwt",
            "type": "jwt",
            "usernameExtraction": {
               "claimPropertyName": "sub",
               "enabled": true,
               "isMandatory": false
            },
            "verifyDigitalSignature": true
        }
      ],
      "urls": [
         {
            "name": "/jwt",
            "accessProfile": {
               "name": "access_profile_jwt"
            },
            "attackSignaturesCheck": true,
            "isAllowed": true,
            "mandatoryBody": false,
            "method": "*",
            "methodsOverrideOnUrlCheck": false,
            "name": "/jwt",
            "performStaging": false,
            "protocol": "http",
            "type": "explicit"
         }
      ]
    }
}
```

{{< call-out "note" >}} For access profile default values and their related field names, see F5 WAF for NGINX [Policy paramenter reference]({{< ref "/waf/policies/parameter-reference.md" >}}). {{< /call-out >}}

#### Access profile in URL settings

The next step to configure JWT is to define the URL settings. Add the access profile name that you defined previously under the access profiles in the "name" field. From the previous example, we associate the access profile "**access_profile_jwt**" with the "name": **/jwt** in the URLs section to become effective, which means URLs with /jwt name are permitted for this feature and will be used for all JWT API requests.

Please note that the access profile cannot be deleted if it is in use in any URL.

### Authorization rules in URLs

A new entity named as `authorizationRules` is introduced under the URL. This entity encompasses an authorization condition essential for "Claims" validation, enabling access to a specific URL based on claims of a JWT.
The `authorizationRules` entity consists of the following two mandatory fields:

- `name`: a unique descriptive name for the condition predicate
- `condition`: a boolean expression that defines the conditions for granting access to the URL

#### Authorization rules example

Here is an example of declarative policy using an `authorizationRules` entity under the access profile:

```json
{
    "urls": [
        {
            "name": "/api/v3/shops/items/*",
            "accessProfile": {
                "name": "my_jwt"
            },
            "authorizationRules": [
                {
                    "condition": "claims['scope'].contains('pet:read') and claims['scope'].contains('pet:write')",
                    "name": "auth_scope"
                },
                {
                    "condition": "claims['roles'].contains('admin') or claims['roles'].contains('inventory-manager')",
                    "name": "auth_roles"
                },
                {
                    "condition": "claims['email'].endsWith('petshop.com')",
                    "name": "auth_email"
                }
            ]
        }
    ]
}
```

#### AuthorizationRules condition syntax usage

The `authorizationRules` use a Boolean expression to articulate the conditions for granting access to the URL.

#### Claims attribute

The `claims` attribute is a mapping of JSON paths for claims from the JWT to their respective values.
Only structure nesting is supported using the `.` notation.

- Accessing individual cells within JSON arrays is not supported. The entire array is serialized as a string, and its elements can be evaluated using string operators like `contains`.
- Although it is possible to consolidate all conditions into one with `and`, it is not recommended. Splitting conditions improves readability and helps explain authorization failures.

{{< call-out "note" >}}
For the full reference of `authorizationRules` condition syntax and usage, see the F5 WAF for NGINX [Policy paramenter reference]({{< ref "/waf/policies/parameter-reference.md" >}}).
{{< /call-out >}}

See the example below for JWT claims:

```json
{
    "scope": "top-level:read",
    "roles": [
        "inventory-manager",
        "price-editor"
    ],
    "sub": "joe@doe.com"
    "address": {
        "country": "US",
        "state": "NY",
        "city": "New York",
        "street": "888 38th W"
    }
}
```

For the above example, the claims can be:

```text
claims['scope'] = "top-level:read"
claims['roles'] = "["inventory-manager", "price-editor]" # the whole array is presented as a string
claims['address.country'] = "US"
claims['company'] = null # does not exist
claims['address'] = "{ \"address\": { .... } }" # JSON structs can be accessed using the dot "." notation
```

### Attack signatures

Attack signatures are detected within the JSON values of the token (header and claims), but not in the digital signature.
The detection of signatures depends on the configuration entity in the policy, typically the `Authorization` header or the header/parameter defined in the `accessProfile`.

If the request does not match a URL associated with an `accessProfile`, the system attempts to parse the `Authorization` header of type `Bearer`. No violations are raised, except for Base64.

Details:

| Condition                  | Violation(s)                                                                 |
|----------------------------|-------------------------------------------------------------------------------|
| **Token parsed successfully** | No violations when enforced on a URL with or without `accessProfile`.           |
| **Incorrect token structure** | `VIOL_ACCESS_MALFORMED` if enforced on a URL with `accessProfile`.               |
| **Base64 decoding failure**   | `VIOL_ACCESS_MALFORMED` if enforced on a URL with `accessProfile`; `VIOL_PARAMETER_BASE64` if enforced with `accessProfile`. |
| **JSON parsing failure**      | `VIOL_ACCESS_MALFORMED` if enforced on a URL with `accessProfile`.               |

### JSON web token violations

F5 WAF for NGINX introduces three new violations specific to JWT:
- `VIOL_ACCESS_INVALID`
- `VIOL_ACCESS_MISSING`
- `VIOL_ACCESS_MALFORMED`

Under `blocking-settings`, you can enable or disable these violations.
By default, they are enabled. Details are recorded in the security log.

Example:

```json
{
    "policy": {
        "name": "jwt_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "blocking-settings": {
           "violations": [
            {
               "alarm": true,
               "block": false,
               "name": "VIOL_ACCESS_INVALID"
            },
            {
               "alarm": true,
               "block": false,
               "name": "VIOL_ACCESS_MISSING"
            },
            {
               "alarm": true,
               "block": false,
               "name": "VIOL_ACCESS_MALFORMED"
            }
            ]
        }
    }
}
```

### Violation rating calculation

The default violation rating is set to **5** regardless of the violation.
Any changes to these violation settings override the default.

Details are recorded in the security log.
All violations are disabled after an upgrade.

### Other references

For more information about JSON Web Token (JWT) see below reference links:

- [The definition of the JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [Specification of how tokens are digitally signed](https://datatracker.ietf.org/doc/html/rfc7515)
- [The format of the JSON Web Key (JWK) that needs to be included in the profile for extracting the public keys used to verify the signatures](https://datatracker.ietf.org/doc/html/rfc7515)
- [Examples of Protecting Content Using JSON Object Signing and Encryption (JOSE)](https://datatracker.ietf.org/doc/html/rfc7520)