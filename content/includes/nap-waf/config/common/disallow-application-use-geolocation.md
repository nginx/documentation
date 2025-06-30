---
nd-docs: "DOCS-1547"
---

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