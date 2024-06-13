---
docs: "DOCS-1527"
---

NGINX App Protect WAF introduces a new policy entity known as "**access profile**" to authenticate JSON Web Token. Access Profile is added to the app protect policy to enforce JWT settings. JSON Web Token needs to be applied to the URLs for enforcement and includes the actions to be taken with respect to access tokens. It is specifically associated with HTTP URLs and does not have any predefined default profiles.

{{< note >}}At present, only one access profile is supported within the App Protect policy. However, the JSON schema for the policy will be designed to accommodate multiple profiles in the future.{{< /note >}}

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

{{< note >}} For access profile default values and their related field names, see NGINX App Protect WAF [Declarative Policy guide]({{< relref "/nap-waf/v4/declarative-policy/policy.md" >}}). {{< /note >}}

### Access Profile in URL Settings

The next step to configure JWT is to define the URL settings. Add the access profile name that you defined previously under the access profiles in the "name" field. From the previous example, we associate the access profile "**access_profile_jwt**" with the "name": **/jwt** in the URLs section to become effective, which means URLs with /jwt name are permitted for this feature and will be used for all JWT API requests.

Please note that the access profile cannot be deleted if it is in use in any URL.