---
# We use sentence case and present imperative tone
title: "JWT protection"
# Weights are assigned in increments of 100: determines sorting order
weight: 1650
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

JSON Web Token (JWT) is a compact and self-contained way to represent information between two parties in a JSON (JavaScript Object Notation) format and is commonly used for authentication and authorization. With NGINX App Protect now it is possible to control access to its application using JWT validation. F5 WAF for NGINX validates the authenticity and well-formedness of JWTs coming from a client, denying access to the service exclusively when the validation process fails. JWT is mainly used for API access.

When a user logs in to a web application, they might receive a JWT, which can then be included in subsequent requests to the server. The server can validate the JWT to ensure that the user is authenticated to access the requested resources.

Now F5 WAF for NGINX provides JSON Web Token (JWT) protection. F5 WAF for NGINX will be placed in the path leading to the application server and will handle the token for the application. This includes:

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

#### F5 WAF for NGINX supports the following types of JWT:

JSON Web Signature (JWS) - JWT content is digitally signed. The following algorithm can be used for signing:

- RSA/SHA-256 (RS256 for short)

Here is an example of a Header: describes a JWT signed with HMAC 256 encryption algorithm:

```json
{
  "alg": "RS256",
  "typ": "JWT"
}
```

### Configuring NGINX App Protect WAF to Authenticate JSON Web Token

#### Access Profile

NGINX App Protect WAF introduces a new policy entity known as "**access profile**" to authenticate JSON Web Token. Access Profile is added to the app protect policy to enforce JWT settings. JSON Web Token needs to be applied to the URLs for enforcement and includes the actions to be taken with respect to access tokens. It is specifically associated with HTTP URLs and does not have any predefined default profiles.

{{< call-out "note" >}}At present, only one access profile is supported within the App Protect policy. However, the JSON schema for the policy will be designed to accommodate multiple profiles in the future.{{< /call-out >}}

The access profile includes:

- **Enforcement Settings**: here you can configure the "enforceMaximumLength," "enforceValidityPeriod," and "keyFiles" settings within the scope of this profile, allowing you to enable or disable them as needed.
- **Location**: here you can modify the location settings, choosing between "header" or "query," as well as specifying the "name" for the header or parameter.
- **Access Profile Settings**: here you can set the "maximumLength" as well as specify the "name" and "type" for the access profile, with "jwt" representing JSON Web Token.

Access Profile example:

Refer to the following example where all access profile properties are configured to enforce specific settings within the App Protect policy. In this instance, we have established an access profile named "**access_profile_jwt**" located in the **authorization header**. The "maximumLength" for the token is defined as **2000**, and "verifyDigitalSignature" is set to **true**.

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

{{< call-out "note" >}} For access profile default values and their related field names, see NGINX App Protect WAF [Declarative Policy guide]({{< ref "/nap-waf/v4/declarative-policy/policy.md" >}}). {{< /call-out >}}

#### Access Profile in URL Settings

The next step to configure JWT is to define the URL settings. Add the access profile name that you defined previously under the access profiles in the "name" field. From the previous example, we associate the access profile "**access_profile_jwt**" with the "name": **/jwt** in the URLs section to become effective, which means URLs with /jwt name are permitted for this feature and will be used for all JWT API requests.

Please note that the access profile cannot be deleted if it is in use in any URL.

### Authorization Rules in URLs

A new entity named as `authorizationRules` is introduced under the URL. This entity encompasses an authorization condition essential for "Claims" validation, enabling access to a specific URL based on claims of a JWT.
The `authorizationRules` entity consists of the following two mandatory fields:

- `name`: a unique descriptive name for the condition predicate
- `condition`: a boolean expression that defines the conditions for granting access to the URL

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

#### AuthorizationRules Condition Syntax Usage

The `authorizationRules` use a Boolean expression to articulate the conditions for granting access to the URL. The conditions use the same syntax as in [Policy Override Rules](#override-rules) with one additional attribute **"claims"**.
#### Claims Attribute
The newly introduced attribute "claims" is a mapping of JSON paths for claims from the JWT to their respective values. Only structure nesting is supported using the "." notation.
A few points to remember regarding JWT claims:
- Please note that at the moment, accessing individual cells within JSON arrays isn't possible. Instead, the entire array gets serialized as a string, and its elements can be evaluated using string operators like "contains".
- While it's technically feasible to consolidate all conditions into one with "and" between them, it's not recommended. Dividing them into multiple conditions enhances the readability and clarity of the policy, particularly when explaining the reasons for authorization failure.
For the full reference of authorizationRules condition syntax and usage see the NGINX App Protect WAF [Declarative Policy guide]({{< ref "nap-waf/v4/declarative-policy/policy.md" >}}/#policy/override-rules).
See below example for JWT claims:

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
then the claims can be:
```
claims['scope'] = "top-level:read"
claims['roles'] = "["inventory-manager", "price-editor]" # the whole array is presented as a string
claims['address.country'] = "US"
claims['company'] = null # does not exist
claims['address'] = "{ \"address\": { .... } }" # JSON structs can be accessed using the dot "." notation
```

### Attack Signatures

Attack signatures are detected within the JSON values of the token, i.e. the header and claims parts, but not on the digital signature part of the token. The detection of signatures, and specifically which signatures are recognized, depends on the configuration entity within the Policy. Typically, this configuration entity is the Authorization HTTP header or else, the header or parameter entity configured as the location of the token in the access profile.

If the request doesn't align with a URL associated with an Access Profile, an attempt is made to parse the "bearer" type Authorization header, but no violations are raised, except for Base64. More information can be found below:

1. Token parsed successfully - No violations are detected when enforced on URL with or without access profile.

2. There are more or less than two dots in the token - `VIOL_ACCESS_MALFORMED` is detected when enforced on URL with access profile.

3. Base64 decoding failure - `VIOL_ACCESS_MALFORMED` is detected when enforced on URL with access profile. `VIOL_PARAMETER_BASE64` is detected when enforced with access profile.

4. JSON parsing failure - `VIOL_ACCESS_MALFORMED` is detected when enforced on URL with access profile.

### JSON Web Token Violations

F5 WAF for NGINX introduces three new violations specific to JWT: `VIOL_ACCESS_INVALID`, `VIOL_ACCESS_MISSING` and `VIOL_ACCESS_MALFORMED`.

Under the "blocking-settings," user can either enable or disable these violations. Note that these violations will be enabled by default. The details regarding logs will be recorded in the security log.

See the below example for these violations.

```shell
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

### Violation Rating Calculation

The default violation rating is set to the level of **5** regardless of any violation. Any changes to these violation settings here will override the default settings. The details regarding logs will be recorded in the security log. All violations will be disabled on upgrade.

See also the [Violations](#violations) section for more details.

### Other References

For more information about JSON Web Token (JWT) see below reference links:

- [The definition of the JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [Specification of how tokens are digitally signed](https://datatracker.ietf.org/doc/html/rfc7515)
- [The format of the JSON Web Key (JWK) that needs to be included in the profile for extracting the public keys used to verify the signatures](https://datatracker.ietf.org/doc/html/rfc7515)
- [Examples of Protecting Content Using JSON Object Signing and Encryption (JOSE)](https://datatracker.ietf.org/doc/html/rfc7520)