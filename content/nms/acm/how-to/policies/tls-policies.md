---
Title: "TLS Policies"
description: "Learn how to use NGINX Management Suite API Connectivity Manager to secure communications by applying TLS policies."
weight: 1400
toc: true
tags: [ "docs" ]
categories: ["API Connectivity Manager", "Developer Portal", "TLS"]
doctypes: ["task"]
docs: "DOCS-926"
---

{{<custom-styles>}}

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Overview

{{< include "acm/how-to/policies-intro.md" >}}

The types of communication you can apply TLS policies to includes:

- ingress traffic to an API or Dev Portal proxy; 
- communications between an API proxy and a backend API service; and
- communications between the API Connectivity Manager management plane and the Dev Portal data plane.

---

### Before You Begin

Complete the following prerequisites before proceeding with this guide: 

- API Connectivity Manager is installed, licensed, and running.
- You have one or more Environments with [API Gateway]({{< relref "/nms/acm/getting-started/add-api-gateway" >}}) or [Dev Portal]({{< relref "/nms/acm/getting-started/add-devportal" >}}) clusters.

### How to Access the User Interface

{{< include "acm/how-to/access-acm-ui" >}}

### How to Access the REST API

{{< include "acm/how-to/access-acm-api" >}}

---

## Secure Ingress Traffic

Take the steps in this section to secure the traffic coming into your API Proxies.

### Add TLS Listener

{{<tabs name="add_tls_listener">}}
    {{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Workspaces > Environments > \<your environment\>**, where "your environment" is the Environment that contains the Developer Portal.
1. Select **Edit Advanced Config** from the **Actions** menu for the desired Developer Portal.
1. On the **Listeners** tab, select **Add Listener**. 
1. Provide the desired **Protocol** and **Port** (for example, `443`) and select the **TLS** checkbox. 

    {{%/tab%}}
    {{%tab name="API"%}}

```json
"listeners": [
    {
        "transportProtocol": "HTTP",
        "port": 443,
        "tlsEnabled": true,
        "ipv6": false
    }
```
    {{%/tab%}}
{{</tabs>}}

### Add TLS Inbound Policy {#add-tls-inbound}

{{<tabs name="tls-inbound">}}
{{%tab name="UI"%}}

1. Select the **Global Policies** tab.
1. Select **Add Policy** from the **Actions** menu for the **TLS Inbound** policy.
1. On the **TLS Inbound** policy page, provide the requested information.

    - **Protocols:** The TLS and SSL protocols that will be used for securing communication.
    - **Cipher:** The set of algorithms or a set of instructions/steps that helps to establish the secure connection.
    - **Session Timeout:** Specifies the time during which a client may reuse the session parameters.
    - **Session Cache:** Sets whether a session can be re-used.  When off, a full negotiation is performed for every connection.
    - **Session Type:** Determines the cache type for re-using sessions.
    - **Session Size:** Sets the shared cache size.

1. Upload a Server Certificate, Certificate Key, and CA Certificate. 

    - Select the upload icon in the **Server Certificate** field and browse for the desired certificate on your file system.
    - Select the upload icon in the **Certificate Key** field and browse for the desired key file on your file system.
    - Select the upload icon in the **CA Certificates** field and browse for the desired Root CA certificate on your file system.

1. (Optional) Select the **Verify Client Certificate** toggle and complete the configurations as appropriate.
1. Select **Add** to save and add the policy.
1. Select **Save and Submit**.   

{{%/tab%}}
{{%tab name="API"%}}

```json
"policies": {
    "tls-inbound": [
        {
            "data": {
                "serverCerts": [
                    {
                        "key": {{tlsKey}},
                        "cert": {{tlsCert}}
                    }
                ],
                "trustedRootCACerts":{{caCert}}
            }
        }
    ]
}
```
{{%/tab%}}
{{</tabs>}}

### Verify HTTPS Connection

Once the Environment configuration has been submitted and applied, the **Job Status** for the Environment will change to **Success**.
You can then navigate to the Dev Portal user interface to verify that your connection is secured using HTTPS. 

---

## Secure Communications between API Proxy and Backend Service

Take the steps in this section to secure the communications between your Proxies and the associated API backend services. When mTLS is enabled, the API Gateway identifies itself to the backend service using an SSL client certificate.

### Add TLS Backend Policy {#add-tls-backend}

{{<tabs name="tls-backend">}}
{{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Workspaces > Environments > \<your environment\>**, where "your environment" is the Environment that contains the API Gateway to be updated.
1. Select **Edit Advanced Config** from the **Actions** menu for the desired API Gateway.
1. Select the **Global Policies** tab, then select **Add Policy** from the **Actions** menu for the **TLS Backend** policy.
1. On the **TLS Backend** policy page, provide the requested information. 

    - **Protocols:** The TLS and SSL protocols that will be used for securing communication to the proxied server.
    - **Cipher:** The set of algorithms or a set of instructions/steps that helps to establish the secure connection to the proxied server.
    - **Verify Certificate Chain Depth:** Sets the verification depth in the client certificates chain.

1. Upload a Client Certificate, Certificate Key, and CA Certificate. 

    - Select the upload icon in the **Client Certificate** field and browse for the desired certificate on your file system.
    - Select the upload icon in the **Certificate Key** field and browse for the desired key file on your file system.
    - (Optional) Provide the Client ID and select the upload icon to upload a Trusted Root CA, then browse for the desired Root CA certificate on your file system.

1. Select **Add** to save and add the policy.
1. Select **Save and Submit**.   

{{%/tab%}}
{{%tab name="API"%}}

```json
"policies": {
    "tls-backend": [
        { "action": {
            "cipher": "HIGH:!aNULL:!MD5",
            "protocols": [
                "TLSv1.2"
            ]
        },
            "data": {
                "trustedRootCACerts":"{{caCert}}",
                "clientCerts": [
                    {
                        "cert": "{{clientCert}}",
                        "key": "{{clientKey}}"
                        
                    }
                ]
            }
        }
    ]
}
```
{{%/tab%}}
{{</tabs>}}

Once the Environment configuration has been submitted and applied, the **Job Status** for the Environment will change to **Success**.

--- 

## Secure Communications Between API Connectivity Manager and Dev Portal Hosts

Take the steps in this section to secure communications between the API Connectivity Manager management plane and Dev Portal hosts. 

### Add TLS Policies to External Developer Portal {#tls-external-cluster}

{{<tabs name="tls-external">}}
{{%tab name="UI"%}}

1. In the API Connectivity Manager user interface, go to **Workspaces > Environments > \<your environment\>**, where "your environment" is the Environment that contains the Developer Portal.
1. Add the [TLS Inbound](#add-tls-inbound) and [TLS Backend](#add-tls-backend) policies to your Developer Portal.
1. Save and submit your changes.

{{%/tab%}}
{{%tab name="API"%}}

```json
{
    "name": "{{environmentName}}",
    "functions": [
        "DEVPORTAL"
    ],
    "proxies": [
        {
            "proxyClusterName": "{{portalInstanceGName}}",
            "hostnames": [
                "{{portalEnvironmentHostname}}"
            ],
            "runtime": "PORTAL-PROXY",
            "policies": {
                "tls-inbound": [
                    {
                        "action": {
                            "cipher": "ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5",
                            "protocols": [
                                "TLSv1.2"
                            ],
                            "sessionCache": {
                                "enable": "on",
                                "size": "10M",
                                "type": "shared"
                            },
                            "sessionTimeout": "5m"
                        },
                        "data": {
                            "trustedRootCACerts": {
                                    "clientId": "clientId1",
                                    "cert": "{{}}"
                            },
                            "serverCerts": [
                                {
                                    "key": {{tlsServerKey}},
                                    "cert": {{tlsServerCert}}
                                }
                            ]
                        }
                    }
                ],
                "tls-backend": [
                    {
                        "action": {
                            "cipher": "HIGH:!aNULL:!MD5",
                            "sessionReuse": false,
                            "proxyServerName": false,
                            "protocols": [
                                "TLSv1.2"
                            ]
                        },
                        "data": {
                            "trustedRootCACerts":"{{caCert}}",
                            "clientCerts": [
                                {
                                    "key": {{tlsClientKey}},
                                    "cert": {{tlsClientCert}}
                                }
                            ]
                        }
                    }
                ]
            }
        }
    ]
}
```

{{%/tab%}}
{{</tabs>}}

### Secure Communication between Portal and API Connectivity Manager using TLS Policies {#tls-internal-cluster}

{{<tabs name="tls-internal">}}
{{%tab name="UI"%}}

1. Select **Edit Portal <-> API Connectivity Manager Connectivity** from the **Actions** menu for your desired developer portal.
1. [Add TLS Listener(s)](#add-a-tls-listener).
1. Add the [TLS Inbound](#add-tls-inbound) policy.
    
    - Complete the fields as desired.
    - Upload the Server Certificate and Certificate Key.
    - On the same **TLS Inbound** policy page, select the **Verify Client Certificate** option.
    - Provide the Certificate Authority (CA) certificates and a Client ID.
    - Select **Add**.

1. Add the [TLS Backend](#add-tls-backend) policy.  
    
    - Complete the fields as desired.
    - Upload the Client Certificate and Certificate Key. 
    - Select **Add**.

1. Save and submit your changes.

{{%/tab%}}
{{%tab name="API"%}}

```json
{
    "name": "{{environmentName}}",
    "functions": [
        "DEVPORTAL"
    ],
    "proxies": [
        {
            "proxyClusterName": "{{portalInstanceGName}}",
            "hostnames": [
                "acm.{{portalEnvironmentHostname}}"
            ],
            "runtime": "PORTAL-PROXY",
            "listeners": [
                {
                    "transportProtocol": "HTTP",
                    "port": 443,
                    "tlsEnabled": true,
                    "ipv6": false
                }
            ],
            "policies": {
                "tls-inbound": [
                    {
                        "action": {
                            "cipher": "ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5",
                            "protocols": [
                                "TLSv1.2"
                            ],
                            "sessionCache": {
                                "enable": "on",
                                "size": "10M",
                                "type": "shared"
                            },
                            "sessionTimeout": "5m",
                            "enableMTLS": {
                               "certVerify": true,
                               "certChainVerifyDepth": 2
                            }
                        },
                        "data": {
                            "serverCerts": [
                                {
                                    "key": {{tlsServerKey}},
                                    "cert": {{tlsServerCert}}
                                }
                            ],
                            "clientCerts": [
                               {
                                  "clientId": "client-1",
                                  "cert": {{caCert}},
                               }
                            ]
                        }
                    }
                ],
                "tls-backend": [
                    {
                        "action": {
                            "cipher": "HIGH:!aNULL:!MD5",
                            "sessionReuse": false,
                            "proxyServerName": false,
                            "protocols": [
                                "TLSv1.2"
                            ]
                        },
                        "data": {
                            "clientCerts": [
                                {
                                    "key": {{tlsClientKey}},
                                    "cert": {{tlsClientCert}}
                                }
                            ]
                        }
                    }
                ]
            }
        }
    ]
}
```

{{%/tab%}}
{{</tabs>}}

Once the Environment configuration has been submitted and applied, the **Job Status** for the Environment will change to **Success**.

### Update Developer Portal Backend Configuration

Take the steps below to update the settings for the Developer Portal backend server.

1. Edit the Dev Portal configuration file located at `/etc/nginx-devportal/devportal.conf`
2. Add the location of the server and client certificates and certificate keys, as shown in the example below.

    ``` yaml
    DP_CERT_FILE="/path/to/devportal-server.crt"
    DP_KEY_FILE="/path/to/devportal-server.key"
    DP_CLIENT_CERT_FILE="/path/to/devportal-client.crt"
    DP_CLIENT_KEY_FILE="/path/to/devportal-client.key"
    DP_CA_FILE="/path/to/ca.pem"
    DP_INSECURE_MODE=false
    ```

3. Adjust the permissions of each of the certificate and key files provided to ensure they are readable by the Dev Portal backend service.
4. Restart the developer portal backend service:

    ``` shell
    sudo systemctl restart nginx-devportal
    ```

### Update the `nms-http` Config File

Take the steps below to ensure API Connectivity Manager can verify the client certificates provided by the Dev Portal's backend service.

1. Edit the NGINX Management Suite configuration file located at `/etc/nginx/conf.d/nms-http.conf`.
2. Add the location of the CA PEM file to the `ssl_client_certificate` directive, as shown in the example below:

    {{<note>}}This should be the same CA PEM file that was used to generate the client certificates for the tls-backend policy used to secure Portal <-> API Connectivity Manager communication.{{</note>}}

    ``` yaml
    ssl_certificate         /etc/nms/certs/manager-server.pem;
    ssl_certificate_key     /etc/nms/certs/manager-server.key;
    ssl_client_certificate  /etc/nms/certs/ca.pem;
    ```

3. Reload the NGINX configuration:

    ``` shell
    sudo nginx -s reload
    ```
