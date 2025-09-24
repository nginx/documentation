---
# We use sentence case and present imperative tone
title: "Geolocation"
# Weights are assigned in increments of 100: determines sorting order
weight: 1150
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

Geolocation refers to the process of assessing or determining the geographic location of an object. This feature helps in identifying the geographic location of a client or web application user.

In F5 WAF for NGINX, the Enforcer will look up the client IP address in the Geolocation file included in the app protect package, and extract the corresponding [ISO 3166](https://www.iso.org/obp/ui/#search) two-letter code, representing the country. For instance, "IL" denotes Israel. This information is denoted as "geolocation" in the condition and is also included in the request reporting.

For applications protected by app protect, you can use Geolocation enforcement to restrict or allow application use in specific countries. You can adjust the lists of which countries or locations are allowed or disallowed in a app protect security policy. If the user tries to access the web application from a location that is not allowed, the `VIOL_GEOLOCATION` violation will be triggered. By default, all locations are allowed, and the alarm and block flags are enabled.

Requests from certain locations, such as RFC-1918 addresses or unassigned global addresses, do not include a valid country code. The geolocation is shown as **N/A** in both the request and the list of geolocations. You have the option to disallow N/A requests whose country of origination is unknown.

For example, in the policy provided below, within the "disallowed-geolocations" section, "countryCode": IL and "countryName": Israel have been included.  This signifies that requests originating from these locations will raise an alarm, trigger the `VIOL_GEOLOCATION` violation and will be blocked.


```shell
"general": {
         "customXffHeaders": [],
         "trustXff": true
      },
"disallowed-geolocations" : [
         {
            "countryCode" : "IL",
            "countryName" : "Israel"
         }
      ],
"blocking-settings": {
      "violations": [
       {
          "name": "VIOL_GEOLOCATION",
          "alarm": true,
          "block": true
        }
    ]
}

```

The below example represents a security policy for a web application. The policy named as "override_rule_example" is based on a template called "POLICY_TEMPLATE_NGINX_BASE." The policy is set to operate in "blocking" mode, which means it will prevent certain activities.

There's a specific configuration under "general" that deals with custom headers for cross-origin requests, specifically the "xff" header. The policy is configured to trust this header.

In the "override-rules" section there is one override rule named "myFirstRule." This rule is set up to trigger when the geolocation of a request is identified as 'IL' (Israel). When this condition is met, the action taken is to extend the policy, but with a change in enforcement mode to "transparent."

In simpler terms, when someone tries to access the web application from Israel ('IL'), the security policy will be adjusted to allow the access but in a more transparent manner, meaning it won't block the access but may monitor it differently.

```json
{
    "policy": {T
        "name": "override_rule_example",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "enforcementMode": "blocking",
        "general": {
             "customXffHeaders": ["xff"],
             "trustXff": true
         },
         "override-rules": [
            {
                "name": "myFirstRule",
                "condition": "geolocation == 'IL'",
                "actionType": "extend-policy",
                "override": {
                    "policy": {
                        "enforcementMode": "transparent"
                    }
                }
            }
        ]
    }
}
```