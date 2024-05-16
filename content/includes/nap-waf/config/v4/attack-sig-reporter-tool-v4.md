---
docs: "DOCS-1524"
---

The Attack Signature Report tool `/opt/app_protect/bin/get-signatures` scans the system for attack signatures and generates a JSON report file that includes information about these signatures.

This tool can be deployed and used independently of the NGINX App Protect WAF deployment, by [installing the compiler package as a standalone]({{< relref "/nap-waf/v4/admin-guide/install#converter-tool-docker-image" >}}), in order to generate a report about either the default signatures included in the package, or signatures included in a signature update package. The latter can be obtained by running the tool on a standalone compiler deployment, after installing a new signature update package on top of the compiler package. These reports can then be compared for greater clarity regarding signature updates.

In addition, this report can be used for reporting or troubleshooting purposes or for auditing/tracking changes for signature updates on the NGINX App Protect WAF deployment itself.

Using the script:
```shell
/opt/app_protect/bin/get-signatures
```

Output:
```shell
USAGE:
    /opt/app_protect/bin/get-signatures <arguments>

  Required arguments:
    --outfile|o='/path/to/report-file.json'
      File name to write signature report.

  Optional arguments:
    --fields|f='list,of,fields'
      Comma separated list of desired fields.
      Available fields:
      name,signatureId,signatureType,attackType,accuracy,tag,risk,systems,hasCve,references,isUserDefined,description,lastUpdateMicros

Optionally, using --help will issue this help message.
```

Example of generating a signature report (with all signature details):
```shell
/opt/app_protect/bin/get-signatures -o /path/to/signature-report.json | jq
```

Output:
```json
{
    "file_size": 1868596,
    "filename": "/path/to/signature-report.json",
    "completed_successfully": true
}
```

Example of the contents of the output file (displayed and piped into `jq`):
```json
{
    "signatures": [
        {
            "isUserDefined": false,
            "attackType": {
                "name": "Detection Evasion"
            },
            "name": "Unicode Fullwidth ASCII variant",
            "hasCve": false,
            "systems": [
                {
                    "name": "IIS"
                }
            ],
            "references": [
                {
                    "value": "infosecauditor.wordpress.com/2013/05/27/bypassing-asp-net-validaterequest-for-script-injection-attacks/",
                    "type": "url"
                }
            ],
            "signatureId": 299999999,
            "signatureType": "request",
            "risk": "low",
            "accuracy": "low"
        },
        {
            "isUserDefined": false,
            "attackType": {
                "name": "Predictable Resource Location"
            },
            "name": "IIS Web Server log dir access (/W3SVC..)",
            "hasCve": false,
            "systems": [
                {
                    "name": "IIS"
                }
            ],
            "references": [
                {
                    "value": "www.webappsec.org/projects/threat/classes/predictable_resource_location.shtml",
                    "type": "url"
                }
            ],
            "signatureId": 200000001,
            "signatureType": "request",
            "risk": "low",
            "accuracy": "high"
        },
        {
            "isUserDefined": false,
            "name": "WEB-INF dir access (/WEB-INF/)",
            "attackType": {
                "name": "Predictable Resource Location"
            },
            "hasCve": true,
            "systems": [
                {
                    "name": "Java Servlets/JSP"
                },
                {
                    "name": "Macromedia JRun"
                },
                {
                    "name": "Jetty"
                }
            ],
            "references": [
                {
                    "value": "www.webappsec.org/projects/threat/classes/predictable_resource_location.shtml",
                    "type": "url"
                },
                {
                    "value": "CVE-2016-4800",
                    "type": "cve"
                },
                {
                    "value": "CVE-2007-6672",
                    "type": "cve"
                }
            ],
            "signatureType": "request",
            "risk": "low",
            "signatureId": 200000018
        }
    ],
    "revisionDatetime": "2019-07-16T12:21:31Z"
}
```

Example of generating signature report (with a preset set of fields):
```shell
/opt/app_protect/bin/get-signatures -o /path/to/signature-report.json --fields=name,signatureId
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.