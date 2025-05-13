#### IP-Groups feature as part of Override Rules feature.
The Override Rules feature allows overriding of the original or parent policy settings.
This can be done by defining override rules in the designated section, based on specific override conditions.
Override rule condition with IP group based on JSON schema defined by the declarative policy and applied to "clientIp" attribute using “matches” function.
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

The above policy contains ip group with the name "standalone" which is used in override rule condition "clientIp.matches(ipAddressLists['standalone'])".
The condition means that the rule enforcement is applied when clientIp is matched to one of ipAddresses in ipAddressList with name "standalone". 
The value used in override rule condition must exist and be exactly equal the name in "ip-address-lists".  

#### Several error cases are verified: 
- Using another keyword instead of ipAddressLists;   
  example: clientIp.matches(invalidList['standalone']);  
  error_message: " Invalid field invalidList" 

- Using empty name; 
  example: clientIp.matches(ipAddressLists['']);  
  error_message: " Invalid value empty string" 

- Using ipAddressLists with attribute otherwise then clientIp;  
  example: uri.matches(ipAddressLists['standalone']);  
  error_message: "Failed to compile policy - 'ipGroupOverridePolicy'" 


 
