IP groups is a feature to organize lists of allowed and forbidden IP addresses across several lists with common attributes.

This allows you to control unique policy settings for incoming requests based on specific IP addresses.

Each IP Group contains a unique name, enforcement type (_always_, _never_ and _policy-default_), and list of IP addresses.


An example of a declarative policy using IP Groups configuration: 

```json
{ 
  "policy": { 
    "name": "IpGroups_policy", 
    "template": { 
       "name": "POLICY_TEMPLATE_NGINX_BASE" 
    }, 
    "applicationLanguage": "utf-8", 
    "caseInsensitive": false, 
    "enforcementMode": "blocking", 
    "ip-address-lists": [ 
       { 
         "name": "Standalone",
         "description": "Optional Description",
         "blockRequests": "policy-default",
         "setGeolocation": "IN",
         "ipAddresses": [
          {
             "ipAddress": "1.2.3.4/32"
          },
          {
             "ipAddress": "1111:fc00:0:112::2"
          }
        ]
      }
    ]
  }
}

```
The example with IP-Group definition in external file external_ip_groups.json:

```json
{
  "policy": { 
    "name": "IpGroups_policy2", 
    "template": { 
       "name": "POLICY_TEMPLATE_NGINX_BASE" 
    }, 
    "applicationLanguage": "utf-8", 
    "caseInsensitive": false, 
    "enforcementMode": "blocking", 
    "ip-address-lists": [
      { 
        "name": "external_ip_groups",
        "description": "Optional Description",
        "blockRequests": "always",
        "setGeolocation": "IL",
        "ipAddresses": [ 
           {
             "ipAddress": "31.8.194.27"
           }
        ],
        "$ref": "file:///tmp/policy/external_ip_groups.json"
      }
    ]
  }
}
```
Example of the file external_ip_groups.json

```json
{ 
    "name": "External Ip Groups List",
    "description": "Optional Description",
    "blockRequests": "always",
    "setGeolocation": "IR",
    "ipAddresses": [
      {
        "ipAddress": "66.51.41.21"
      },
      {
        "ipAddress": "66.52.42.22"
      }
    ]
}
```
