---
docs: "DOCS-1541"
---

The User Defined Signatures Converter tool `/opt/app_protect/bin/convert-signatures` takes a User Defined Signatures XML file as input and exports the content as a JSON file suitable for use in an NGINX App Protect WAF environment.

The tool can optionally accept a tag argument as an input. Otherwise, the default tag value `user-defined-signatures` is assigned to the exported JSON file.

Note that the User Defined signatures XML file can be obtained by exporting the signatures from a BIG-IP device.

Using the tool:
```shell
/opt/app_protect/bin/convert-signatures
```

Output:
```shell
USAGE:
    /opt/app_protect/bin/convert-signatures

Required arguments:
    --outfile|o='/path/to/signatures.json'
        File name to write JSON format export
        Can also be set via an environment variable: EXPORT_FILE
    --infile|i='/path/to/signatures.xml'
        Advanced WAF/ASM User Defined Signatures file to Convert
        Can also be set via an environment variable: IMPORT_FILE

Optional arguments:
    --tag|t='mytag'
        Signature Tag to associate with User Defined Signatures.
        If no tag is specified in the XML file, a default tag of 'user-defined-signatures' will be assigned.
        Can also be set via an environment variable: TAG
    --format|f='json'
        Desired output format for signature file. Default 'json'
        Supported formats: 'json'

Optionally, using --help will issue this help message.
```

Example of generating a user defined signature JSON file (with default tag):
```shell
/opt/app_protect/bin/convert-signatures -i /path/to/signatures.xml -o /path/to/signatures.json | jq
```

Output:
```json
{
    "file_size": 1003,
    "filename": "/path/to/signatures.json",
    "completed_successfully": true
}
```

Example of the contents of the output file (displayed and piped into `jq`):
```json
{
    "signatures": [
        {
            "attackType": {
                "name": "Buffer Overflow"
            },
            "name": "my_first_sig",
            "lastUpdateMicros": 1606014750000000,
            "rule": "content:\"first_sig\"; nocase;",
            "description": "This is the first user defined signature",
            "revision": "1",
            "systems": [
                {
                    "name": "Microsoft Windows"
                }
            ],
            "accuracy": "low",
            "signatureId": "300000002",
            "signatureType": "request",
            "risk": "low"
        },
        {
            "attackType": {
                "name": "Command Execution"
            },
            "name": "my_second_sig",
            "lastUpdateMicros": 1606014818000000,
            "rule": "uricontent:\"second_sig\"; nocase; objonly;",
            "description": "Short description of the signature",
            "revision": "1",
            "systems": [
                {
                    "name": "Unix/Linux"
                }
            ],
            "accuracy": "medium",
            "signatureId": "300000003",
            "signatureType": "request",
            "risk": "medium"
        }
    ],
    "tag": "user-defined-signatures"
}
```

Example of generating a user defined signature JSON file (with custom tag):
```shell
/opt/app_protect/bin/convert-signatures -i /path/to/signatures.xml -o /path/to/signatures.json --tag "MyTag"
```

Note that if the script is run without the required switches and their corresponding arguments, it will display the help message.