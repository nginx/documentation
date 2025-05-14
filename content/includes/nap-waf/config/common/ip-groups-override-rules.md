#### IP-Groups feature as part of Override Rules feature.

The Override Rules feature allows you to modify original or parent policy settings.

Rules are defined using specific conditions, which can include an IP group based on the declarative policy JSON schema.

When triggered, the rule is applied to the _clientIp_ attribute using the _matches_ function.

'clientIp.matches(ipAddressLists["standalone"])'

Here is a policy example:

```json
{ 
  "policy": { 
    "name": "ip_group_override_rule", 
    "template": { 
      "name": "POLICY_TEMPLATE_NGINX_BASE" 
    }, 
    "applicationLanguage": "utf-8", 
    "caseInsensitive": false, 
    "enforcementMode": "blocking", 
    "ip-address-lists": [ 
      { 
        "name": "standalone", 
        "description": "This is my list of IP addresses", 
        "ipAddresses": [ 
          { 
            "ipAddress": "6.5.3.3/32" 
          }, 
          { 
            "ipAddress": "6.5.4.2" 
          } 
        ] 
      } 
     ], 
     "override-rules": [ 
      { 
        "name": "myFirstRule", 
        "condition": "clientIp.matches(ipAddressLists['standalone'])", 
        "actionType": "violation", 
        "violation": { 
          "block": true, 
          "alarm": true, 
          "attackType": { 
            "name": "Forceful Browsing" 
          }, 
          "description": "Attempt to access from clientIp", 
          "rating": 4
        }
      }
    ],
    "general": {
      "trustXff": true
    }
  }
}
```

The previous example policy contains an IP group with the name "standalone", used for the override rule condition "clientIp.matches(ipAddressLists['standalone'])".
The condition means that the rule enforcement is applied when clientIp is matched to one of ipAddresses in ipAddressList with name "standalone". 
The value used for the override condition must exist and exactly match the name in "ip-address-lists".  

#### Possible errors

| Error text | Input          | Explanation |
| -----------| ------------- | ------------ |
| _Invalid field invalidList_ | _clientIp.matches(invalidList['standalone']);_ | An incorrect keyword was used instead of _ipAddressLists_ |
| _Invalid value empty string_ | _clientIp.matches(ipAddressLists['']_ | An empty name was provided |
| _Failed to compile policy - 'ipGroupOverridePolicy'_ | _uri.matches(ipAddressLists['standalone']);_ |  Used _ipAddressLists_ without the _clientIP_ attribute |


 
