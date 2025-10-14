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

This topic describes the geolocation feature for F5 WAF for NGINX.

Geolocation refers to the process of assessing or determining the geographic location of an object. This feature helps in identifying the geographic location of a client or web application user.

The Enforcer will look up the client IP address in the Geolocation file included in the F5 WAF for NGINX, and extract the corresponding [ISO 3166](https://www.iso.org/obp/ui/#search) two-letter code, representing the country. 

For instance, "IL" denotes Israel. This information is denoted as "geolocation" in the condition and reported in the request..

Applications protected by F5 WAF for NGINX can use geolocation enforcement to restrict or allow application use in specific countries.  You can adjust the lists of which countries or locations are allowed or disallowed with a security policy. 

If the user tries to access the web application from a location that is not allowed, the `VIOL_GEOLOCATION` violation will be triggered.

By default, all locations are allowed, and the alarm and block flags are enabled.

Requests from certain locations, such as RFC-1918 addresses or unassigned global addresses, do not include a valid country code. 

The geolocation is shown as _N/A_ in both the request and the list of geolocations. You can disallow N/A requests whose country of origination is unknown.

In the follow policy example, _"countryCode": IL_ and _"countryName": Israel_ have been included within the _"disallowed-geolocations"_ section.

This indicates that requests originating from these locations should raise an alarm, trigger the `VIOL_GEOLOCATION` violation and be blocked.


```json
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

The next example represents a security policy override for a web application. The policy is named "_override_rule_example_" and is based on a template called "_POLICY_TEMPLATE_NGINX_BASE_". 

The policy is set to operate in _blocking mode_, which means it will prevent certain activities. The policy is configured to trust headers configured under _general_ that deal with custom headers for cross-origin requests, specifically the _xff_ header. 

In the "_override-rules_" section there is one override rule named "_myFirstRule_". This rule is configured to trigger when the geolocation of a request is identified as 'IL' (Israel). When this condition is met, the action taken is to extend the policy, but with a change in enforcement mode to "transparent."

```json
{
    "policy": {
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