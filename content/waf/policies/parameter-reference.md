---
title: Policy parameter reference
toc: true
weight: 300
nd-content-type: reference
nd-product: F5WAFN
---

<!-- {{< include "waf/policy.html" >}} -->

---

## policy

| Field Name | Reference | Type | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| [access-profiles](#policy/access-profiles) | Yes | array of objects |  |  |
| `applicationLanguage` | No | string | The character encoding for the application. The character encoding determines how the policy processes the character sets. The default is utf-8. | big5, euc-jp, euc-kr, gb18030, gb2312, gbk, iso-8859-1, iso-8859-10, iso-8859-13, iso-8859-15, iso-8859-16, iso-8859-2, iso-8859-3, iso-8859-4, iso-8859-5, iso-8859-6, iso-8859-7, iso-8859-8, iso-8859-9, koi8-r, shift_jis, utf-8, windows-1250, windows-1251, windows-1252, windows-1253, windows-1255, windows-1256, windows-1257, windows-874 |
| [blocking-settings](#policy/blocking-settings) | Yes | object | This section defines policy block/alarm behaviors. |  |
| [bot-defense](#policy/bot-defense) | Yes | object | This section defines the properties of the bot defense feature. |  |
| [browser-definitions](#policy/browser-definitions) | Yes | array of objects |  |  |
| [brute-force-attack-preventions](#policy/brute-force-attack-preventions) | Yes | array of objects | Defines configuration for Brute Force Protection feature. There is default configuration (one with bruteForceProtectionForAllLoginPages flag and without url) that applies to all configured login URLs unless there exists another brute force configuration for a specific login page. |  |
| `caseInsensitive` | No | boolean | Specifies whether the security policy treats microservice URLs, file types, URLs, and parameters as case sensitive or not. When this setting is enabled, the system stores these security policy elements in lowercase in the security policy configuration. |  |
| [character-sets](#policy/character-sets) | Yes | array of objects |  |  |
| [cookie-settings](#policy/cookie-settings) | Yes | object | The maximum length of a cookie header name and value that the system processes. The system calculates and enforces a cookie header length based on the sum of the length of the cookie header name and value. |  |
| [cookies](#policy/cookies) | Yes | array of objects | This section defines Cookie entities for your policy. You can specify the cookies that you want to allow, and the ones you want to enforce in a security policy:  - **Allowed cookies**: The system allows these cookies and clients can change them.  - **Enforced cookies**: The system enforces the cookies in the list (not allowing clients to change them) and allows clients to change all others. |  |
| [csrf-protection](#policy/csrf-protection) | Yes | object |  |  |
| [csrf-urls](#policy/csrf-urls) | Yes | array of objects |  |  |
| [data-guard](#policy/data-guard) | Yes | object | Data Guard feature can prevent responses from exposing sensitive information by masking the data. |  |
| `description` | No | string | Specifies the description of the policy. |  |
| [disallowed-geolocations](#policy/disallowed-geolocations) | Yes | array of objects | Specifies a list of countries that may not access the web application. |  |
| `enforcementMode` | No | string | How the system processes a request that triggers a security policy violation.  - **Blocking:** Traffic is blocked if it causes a violation (configured for blocking).  - **Transparent:** Traffic is not blocked even if a violation is triggered. | blocking, transparent |
| [enforcer-settings](#policy/enforcer-settings) | Yes | object | This section contains all enforcer settings. |  |
| [filetypes](#policy/filetypes) | Yes | array of objects | File types are categorized by the extension appearing past the last dot at the end of the URL. For example, "php". Other well known types: html, aspx, png, jpeg, no-ext ("empty" type, no extension, e.g. /foo_no_dot). File types also imply expected content type or technology. 1. Define allowed/disallowed types. 2. Each type may have max length restrictions. 3. Each type enables/disables response signature checks. Wildcard * allows everything except specified disallowed, otherwise it's an allowlist. |  |
| `fullPath` | No | string | The full name of the policy including partition. |  |
| [general](#policy/general) | Yes | object | Several advanced policy configuration settings. |  |
| [graphql-profiles](#policy/graphql-profiles) | Yes | array of objects |  |  |
| [grpc-profiles](#policy/grpc-profiles) | Yes | array of objects |  |  |
| [header-settings](#policy/header-settings) | Yes | object | The maximum length of an HTTP header name and value that the system processes. The system calculates and enforces the HTTP header length based on the sum of the length of the HTTP header name and value. |  |
| [headers](#policy/headers) | Yes | array of objects | This section defines Header entities for your policy. |  |
| [host-names](#policy/host-names) | Yes | array of objects |  |  |
| [idl-files](#policy/idl-files) | Yes | array of objects |  |  |
| [ip-address-lists](#policy/ip-address-lists) | Yes | array of objects | An IP address list is a list of IP addresses that you want the system to treat in a specific way for a security policy. |  |
| [ip-intelligence](#policy/ip-intelligence) | Yes | object |  |  |
| [json-profiles](#policy/json-profiles) | Yes | array of objects |  |  |
| [json-validation-files](#policy/json-validation-files) | Yes | array of objects |  |  |
| [login-enforcement](#policy/login-enforcement) | Yes | object |  |  |
| [login-pages](#policy/login-pages) | Yes | array of objects | Login page is a URL in a web application that requests must pass through to get to the authenticated URLs. |  |
| [methods](#policy/methods) | Yes | array of objects |  |  |
| `name` | No | string | The unique user-given name of the policy. Policy names cannot contain spaces or special characters. Allowed: a-z, A-Z, 0-9, ., -, :, _ |  |
| [open-api-files](#policy/open-api-files) | Yes | array of objects |  |  |
| [override-rules](#policy/override-rules) | Yes | array of objects | This section defines policy override rules. |  |
| [parameters](#policy/parameters) | Yes | array of objects | This section defines parameters that the security policy permits in requests. |  |
| `performStaging` | No | boolean | Determines staging handling for all applicable entities in the policy, such as signatures, URLs, parameters, and cookies. If disabled, all entities will be enforced and any violations triggered will be considered illegal. |  |
| [response-pages](#policy/response-pages) | Yes | array of objects | The Security Policy has a default blocking response page that it returns to the client when the client request, or the web server response, is blocked by the security policy. You can change the way the system responds to blocked requests. |  |
| [sensitive-parameters](#policy/sensitive-parameters) | Yes | array of objects | Defines sensitive parameters. Contents not visible in logs nor UI; a string of asterisks is shown. Used for passwords, credit cards, etc. "password" is always defined as sensitive by default. |  |
| [server-technologies](#policy/server-technologies) | Yes | array of objects | The server technology is a server-side application, framework, web server or operating system type that is configured in the policy. |  |
| [signature-requirements](#policy/signature-requirements) | Yes | array of objects |  |  |
| [signature-sets](#policy/signature-sets) | Yes | array of objects | Defines behavior when signatures found within a signature-set are detected in a request. Settings are cumulative, so if a signature is found in any set with block enabled, that signature will have block enabled. |  |
| [signature-settings](#policy/signature-settings) | Yes | object |  |  |
| [signatures](#policy/signatures) | Yes | array of objects | This section defines the properties of a signature on the policy. |  |
| [template](#policy/template) | Yes | object | Specifies the template to populate the default attributes of a new policy. |  |
| [threat-campaigns](#policy/threat-campaigns) | Yes | array of objects | This section defines the enforcement state for the threat campaigns in the security policy. |  |
| [urls](#policy/urls) | Yes | array of objects | Allowed/disallowed HTTP URLs in traffic to the protected web application. |  |
| `wafEngineVersion` | No | string |  |  |
| [xml-profiles](#policy/xml-profiles) | Yes | array of objects |  |  |

---

## open-api-files {#policy/open-api-files}

| Field Name | Type | Description | Allowed Values |
| --- | --- | --- | --- |
| `link` | string |  |  |

---

## template {#policy/template}

| Field Name | Type | Description | Allowed Values |
| --- | --- | --- | --- |
| `derivedFrom` | string |  |  |
| `name` | string | Specifies the name of the template used for the policy creation. | POLICY_TEMPLATE_NGINX_BASE |

---

## access-profiles {#policy/access-profiles}

| Field Name | Type | Description | Allowed Values |
| --- | --- | --- | --- |
| `description` | string |  |  |
| `enforceMaximumLength` | boolean |  |  |
| `enforceValidityPeriod` | boolean |  |  |
| [keyFiles](#policy/access-profiles/keyFiles) | array of objects |  |  |
| [location](#policy/access-profiles/location) | object |  |  |
| `maximumLength` | integer |  |  |
| `name` | string |  |  |
| `type` | string |  | jwt |
| [usernameExtraction](#policy/access-profiles/usernameExtraction) | object |  |  |
| `verifyDigitalSignature` | boolean |  |  |

---

Absolutely! Here are **the rest of the tables converted to markdown**.  
If you want a zip/text file with all of these, just say so!

---

## keyFiles {#policy/access-profiles/keyFiles}

| Field Name  | Type   | Description | Allowed Values |
| ----------- | ------ | ----------- | -------------- |
| `contents`  | string |             |                |
| `fileName`  | string |             |                |

---

## location {#policy/access-profiles/location}

| Field Name | Type   | Description | Allowed Values   |
| ---------- | ------ | ----------- | ---------------- |
| `in`       | string |             | header, query    |
| `name`     | string |             |                  |

---

## usernameExtraction {#policy/access-profiles/usernameExtraction}

| Field Name          | Type    | Description | Allowed Values |
| ------------------- | ------- | ----------- | -------------- |
| `claimPropertyName` | string  |             |                |
| `enabled`           | boolean |             |                |
| `isMandatory`       | boolean |             |                |

---

## blocking-settings {#policy/blocking-settings}

| Field Name     | Reference | Type   | Description                                             | Allowed Values |
| -------------- | --------- | ------ | ------------------------------------------------------- | -------------- |
| [evasions](#policy/blocking-settings/evasions)           | Yes       | array of objects | Defines behavior for 'Evasion technique detected' violation sub-violations.                                                                        |                |
| [http-protocols](#policy/blocking-settings/http-protocols)      | Yes       | array of objects | Defines behavior for 'HTTP protocol compliance failed' violation sub-violations.                                                                  |                |
| [violations](#policy/blocking-settings/violations)          | Yes       | array of objects |                                                                                                              |                |

---

## bot-defense {#policy/bot-defense}

| Field Name     | Reference | Type   | Description                                             | Allowed Values |
| -------------- | --------- | ------ | ------------------------------------------------------- | -------------- |
| [settings](#policy/bot-defense/settings)       | Yes       | object | Contains all bot defense settings.                      |                |
| [mitigations](#policy/bot-defense/mitigations)    | Yes       | object | Defines the mitigation to each class or signature.      |                |

---

## browser-definitions {#policy/browser-definitions}

| Field Name        | Type    | Description | Allowed Values |
| ----------------- | ------- | ----------- | -------------- |
| isUserDefined     | boolean |             |                |
| matchRegex        | string  |             |                |
| matchString       | string  |             |                |
| name              | string  |             |                |

---

## brute-force-attack-preventions {#policy/brute-force-attack-preventions}

| Field Name     | Reference | Type   | Description                                             | Allowed Values |
| -------------- | --------- | ------ | ------------------------------------------------------- | -------------- |
| bruteForceProtectionForAllLoginPages| boolean                               | Enables BFP for all login URLs.                                                              |                |
| [loginAttemptsFromTheSameIp](#policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp)          | object                                | Config for detecting brute force attacks from IP Address.                                    |                |
| [loginAttemptsFromTheSameUser](#policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser)         | object                                | Config for detecting brute force attacks for Username.                                       |                |
| reEnableLoginAfter                  | integer min:60 max:90000              | Defines prevention period (seconds) for source-based attacks.                                |                |
| sourceBasedProtectionDetectionPeriod| integer min:60 max:90000              | Defines detection period (seconds) for source-based attacks.                                 |                |
| [url](#policy/urls)                                  | object                                | Reference to the login URL (policy/login-pages).                                             |                |

---

## loginAttemptsFromTheSameIp {#policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp}

| Field Name | Type                                | Description | Allowed Values            |
| ---------- | ----------------------------------- | ----------- | ------------------------ |
| action     | string                              | Specifies mitigation action | alarm, alarm-and-blocking-page |
| enabled    | boolean                             | Count failed login attempts |                          |
| threshold  | integer min:1 max:1000              | Action applied after threshold |                   |

---

## loginAttemptsFromTheSameUser {#policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser}

| Field Name | Type                          | Description                                    | Allowed Values |
| ---------- | ----------------------------- | ---------------------------------------------- | -------------- |
| action     | string                        | Mitigation action after threshold              | alarm          |
| enabled    | boolean                       | Count failed attempts per username             |                |
| threshold  | integer min:1 max:100         | Action applied after threshold                 |                |

---

## character-sets {#policy/character-sets}

| Field Name       | Type           | Description | Allowed Values                                                        |
| ---------------- | -------------- | ----------- | --------------------------------------------------------------------- |
| [characterSet](#policy/character-sets/characterSet)     | array of objects|            |                                                                       |
| characterSetType | string         |             | header, url, parameter-name, parameter-value, xml-content, json-content|

---

## characterSet {#policy/character-sets/characterSet}

| Field Name | Type    | Description | Allowed Values |
| ---------- | ------- | ----------- | -------------- |
| isAllowed  | boolean |             |                |
| metachar   | string  |             |                |

---

## cookie-settings {#policy/cookie-settings}

| Field Name             | Type                                 | Description                                                                                   | Allowed Values          |
| ---------------------- | ------------------------------------ | --------------------------------------------------------------------------------------------- | ----------------------- |
| maximumCookieHeaderLength | integer min:1 max:65536 / string   | Max Cookie Header Length (byte size). 0 or "any" disables restriction.                        | Integer values, "any"   |

---

## cookies {#policy/cookies}

| Field Name                       | Type          | Description                                                                   | Allowed Values                           |
| -------------------------------- | ------------- | ----------------------------------------------------------------------------- | ---------------------------------------- |
| accessibleOnlyThroughTheHttpProtocol | boolean     | HttpOnly attribute                                                            |                                          |
| attackSignaturesCheck            | boolean        | Override attack signature settings for this cookie                            |                                          |
| decodeValueAsBase64              | string         | Base64 enforcement (disabled, enabled, required)                              | disabled, enabled, required              |
| enforcementType                  | string         | Enforced/Allowed cookie                                                       | allow, enforce                           |
| insertSameSiteAttribute          | string         | SameSite cookie attribute                                                     | lax, none, none-value, strict            |
| maskValueInLogs                  | boolean        | Mask value in logs                                                            |                                          |
| name                             | string         | Cookie name (explicit or wildcard supported; see notes)                       |                                          |
| securedOverHttpsConnection       | boolean        | Secure attribute (only send over HTTPS)                                       |                                          |
| [signatureOverrides](#policy/cookies/signatureOverrides)               | array of objects| Override attack signatures for this cookie                                    |                                          |
| type                             | string         | explicit, wildcard (interpret as wildcard only if set)                        | explicit, wildcard                       |
| wildcardOrder                    | integer        | Wildcard matching priority                                                    |                                          |

---

## signatureOverrides {#policy/cookies/signatureOverrides}

| Field Name    | Type    | Description                                 | Allowed Values |
| ------------- | ------- | ------------------------------------------- | -------------- |
| enabled       | boolean | Mark this signature as enforced             |                |
| name          | string  | Signature name                              |                |
| signatureId   | integer | Signature ID                                |                |
| tag           | string  | Signature tag                               |                |

---

## csrf-protection {#policy/csrf-protection}

| Field Name               | Type               | Description                              | Allowed Values          |
| ------------------------ | ------------------ | ---------------------------------------- | ----------------------- |
| enabled                  | boolean            |                                          |                         |
| expirationTimeInSeconds  | integer or string  |                                          | Integer values, "disabled"|
| sslOnly                  | boolean            |                                          |                         |

---

## csrf-urls {#policy/csrf-urls}

| Field Name       | Type    | Description  | Allowed Values          |
| ---------------- | ------- | ------------ | ----------------------- |
| enforcementAction| string  |              | none, verify-origin     |
| method           | string  |              | GET, POST, any          |
| url              | string  |              |                         |
| wildcardOrder    | integer |              |                         |

---

## data-guard {#policy/data-guard}

| Field Name                   | Type                | Description                                                 | Allowed Values                         |
| ---------------------------- | ------------------- | ----------------------------------------------------------- | -------------------------------------- |
| creditCardNumbers            | boolean             | If true, system treats credit card numbers as sensitive     |                                        |
| customPatterns               | boolean             | If true, custom regex patterns are sensitive                |                                        |
| customPatternsList           | array of strings    | List of regex patterns                                      |                                        |
| enabled                      | boolean             | Enabled/disabled                                            |                                        |
| enforcementMode              | string              | enforce-urls-in-list, ignore-urls-in-list                   | enforce-urls-in-list, ignore-urls-in-list |
| enforcementUrls              | array of strings    | List of URLs                                                |                                        |
| firstCustomCharactersToExpose| integer min:0 max:255| Number of first alphanumerics to expose                     |                                        |
| lastCustomCharactersToExpose | integer min:0 max:255| Number of last alphanumerics to expose                      |                                        |
| maskData                     | boolean             | If true, mask sensitive data in response                    |                                        |
| usSocialSecurityNumbers      | boolean             | If true, treat US SSNs as sensitive                         |                                        |

---

## disallowed-geolocations {#policy/disallowed-geolocations}

| Field Name     | Type   | Description           | Allowed Values (sample) |
| -------------- | ------ | --------------------- | ----------------------- |
| countryCode    | string | ISO country code      |                         |
| countryName    | string | Country name          | Afghanistan, Albania, ...|

---

## enforcer-settings {#policy/enforcer-settings}

| Field Name            | Type   | Description                              | Allowed Values |
| --------------------- | ------ | ---------------------------------------- | -------------- |
| [enforcerStateCookies](#policy/enforcer-settings/enforcerStateCookies)  | object | Properties of the enforcer state cookies |                |

---

## enforcerStateCookies {#policy/enforcer-settings/enforcerStateCookies}

| Field Name         | Type    | Description                                         | Allowed Values        |
| ------------------ | ------- | --------------------------------------------------- | ---------------------|
| httpOnlyAttribute  | boolean | Add HttpOnly attribute to state cookie              |                      |
| sameSiteAttribute  | string  | SameSite attribute: none, strict, lax, none-value   | lax, none, none-value, strict      |
| secureAttribute    | string  | Secure attribute (always, never)                    | always, never         |

---

## filetypes {#policy/filetypes}

| Field Name           | Type                | Description                                                      | Allowed Values           |
| -------------------- | ------------------- | ---------------------------------------------------------------- | ------------------------|
| allowed              | boolean             | Is allowed/disallowed filetype                                   |                          |
| checkPostDataLength  | boolean             | Enforce max POST data length                                     |                          |
| checkQueryStringLength| boolean            | Enforce max query string length                                  |                          |
| checkRequestLength   | boolean             | Enforce max request length                                       |                          |
| checkUrlLength       | boolean             | Enforce max URL length                                           |                          |
| name                 | string              | File type name/extension (explicit or wildcard; see notes)       |                          |
| postDataLength       | integer min:0       | Max POST data length                                             |                          |
| queryStringLength    | integer min:0       | Max query string length                                          |                          |
| requestLength        | integer min:0       | Max request length                                               |                          |
| responseCheck        | boolean             | Check for signature detection in response                        |                          |
| responseCheckLength  | integer min:0 max:10000000000 | Max response body checked for signatures                |                          |
| type                 | string              | explicit, wildcard                                               | explicit, wildcard       |
| urlLength            | integer min:0       | Max URL length excluding query string                            |                          |
| wildcardOrder        | integer             | Wildcard match order                                             |                          |

---

## general {#policy/general}

| Field Name                     | Type              | Description                                                                     | Allowed Values  |
| ------------------------------ | ----------------- | ------------------------------------------------------------------------------- | --------------- |
| allowedResponseCodes           | array of integers | Allowed HTTP status response codes (default: 100-399, plus 400,401,404,407,417,503) |           |
| customXffHeaders               | array of strings  | Custom headers for XFF header trust                                              |  |
| maskCreditCardNumbersInRequest | boolean           | Mask CCNs in logs for requests                                                   |  |
| trustXff                       | boolean           | Trust XFF header (enabled if internal trusted proxy)                             |  |

---

## graphql-profiles {#policy/graphql-profiles}

| Field Name                  | Type            | Description           | Allowed Values |
| --------------------------- | ----------------| --------------------- | -------------- |
| attackSignaturesCheck       | boolean         |                       |                |
| [defenseAttributes](#policy/graphql-profiles/defenseAttributes)          | object          |                       |                |
| description                 | string          |                       |                |
| hasIdlFiles                 | boolean         |                       |                |
| [idlFiles](#policy/graphql-profiles/idlFiles)                  | array of objects|                       |                |
| metacharElementCheck        | boolean         |                       |                |
| [metacharOverrides](#policy/graphql-profiles/metacharOverrides)           | array of objects|                       |                |
| name                        | string          |                       |                |
| [responseEnforcement](#policy/graphql-profiles/responseEnforcement)         | object          |                       |                |
| [sensitiveData](#policy/graphql-profiles/sensitiveData)               | array of objects|                       |                |
| [signatureOverrides](#policy/graphql-profiles/signatureOverrides)          | array of objects|                       |                |

---

## defenseAttributes {#policy/graphql-profiles/defenseAttributes}

| Field Name            | Type                                | Description | Allowed Values         |
| --------------------- | ----------------------------------- | ----------- | --------------------- |
| allowIntrospectionQueries | boolean                         |             |                      |
| maximumBatchedQueries | integer min:0 max:2147483647 / string |             | Integer, "any"        |
| maximumQueryCost      | integer min:0 max:2147483647 / string |             | Integer, "any"        |
| maximumStructureDepth | integer min:0 max:2147483647 / string |             | Integer, "any"        |
| maximumTotalLength    | integer min:0 max:2147483647 / string |             | Integer, "any"        |
| maximumValueLength    | integer min:0 max:2147483647 / string |             | Integer, "any"        |
| tolerateParsingWarnings| boolean                            |             |                      |

---

##  idlFiles {#policy/graphql-profiles/idlFiles}

| Field Name    | Type           | Description      | Allowed Values |
| ------------- | -------------- | --------------- | -------------- |
| [idlFile](#policy/graphql-profiles/idlFiles/idlFile)       | object         |                 |                |
| isPrimary     | boolean        |                 |                |

---

##  idlFile {#policy/graphql-profiles/idlFiles/idlFile}

| Field Name    | Type           | Description      | Allowed Values |
| ------------- | -------------- | --------------- | -------------- |
|        |          |                 |                |

---

## metacharOverrides {#policy/graphql-profiles/metacharOverrides}

| Field Name     | Type     | Description | Allowed Values |
| -------------- | -------- | ----------- | -------------- |
| isAllowed      | boolean  |             |                |
| metachar       | string   |             |                |

---

## responseEnforcement {#policy/graphql-profiles/responseEnforcement}

| Field Name         | Type             | Description | Allowed Values |
| ------------------ | ----------------| ----------- | -------------- |
| blockDisallowedPatterns | boolean     |             |                |
| disallowedPatterns      | array of strings |         |                |

---

## sensitiveData {#policy/graphql-profiles/sensitiveData}

| Field Name     | Type   | Description | Allowed Values |
| -------------- | ------ | ----------- | -------------- |
| parameterName  | string |             |                |

---

## signatureOverrides {#policy/graphql-profiles/signatureOverrides}

| Field Name  | Type    | Description | Allowed Values |
| ----------- | ------- | ----------- | -------------- |
| enabled     | boolean |             |                |
| name        | string  |             |                |
| signatureId | integer |             |                |
| tag         | string  |             |                |

---

## grpc-profiles {#policy/grpc-profiles}

| Field Name                | Type             | Description | Allowed Values  |
|------------------------ |------------------|-------------|-----------------|
| associateUrls           | boolean          |             |                 |
| attackSignaturesCheck   | boolean          |             |                 |
| decodeStringValuesAsBase64| string          |             | disabled, enabled|
| [defenseAttributes](#policy/grpc-profiles/defenseAttributes)       | object           |             |                 |
| description             | string           |             |                 |
| hasIdlFiles             | boolean          |             |                 |
| [idlFiles](#policy/grpc-profiles/idlFiles)                | array of objects |             |                 |
| metacharElementCheck    | boolean          |             |                 |
| name                    | string           |             |                 |
| [signatureOverrides](#policy/grpc-profiles/signatureOverrides)      | array of objects |             |                 |

---

## defenseAttributes {#policy/grpc-profiles/defenseAttributes}

| Field Name         | Type                                | Description | Allowed Values    |
| ------------------ | ----------------------------------- | ----------- | -----------------|
| allowUnknownFields | boolean                             |             |                  |
| maximumDataLength  | integer min:0 max:2147483647 / string |             | Integer, "any"   |

---

## idlFiles {#policy/grpc-profiles/idlFiles}

| Field Name    | Type     | Description | Allowed Values |
| ------------- | -------- | ----------- | -------------- |
| [idlFile](#policy/grpc-profiles/idlFiles/idlFile)       | object   |             |                |
| importUrl     | string   |             |                |
| isPrimary     | boolean  |             |                |
| primaryIdlFileName | string |         |                |

---

## idlFile {#policy/grpc-profiles/idlFiles/idlFile}

| Field Name    | Type     | Description | Allowed Values |
| ------------- | -------- | ----------- | -------------- |
|               |          |             |                |

---

## signatureOverrides {#policy/grpc-profiles/signatureOverrides}

| Field Name   | Type    | Description | Allowed Values |
| -------------| ------- | ----------- | -------------- |
| enabled      | boolean |             |                |
| name         | string  |             |                |
| signatureId  | integer |             |                |
| tag          | string  |             |                |

---

## header-settings

| Field Name            | Type                                  | Description                                   | Allowed Values |
| --------------------- | ------------------------------------ | --------------------------------------------- | -------------- |
| maximumHttpHeaderLength| integer min:1 max:65536 / string    | Max HTTP Header Length (bytes, 64K max)       | Integer, "any" |

---

## headers {#policy/headers}

| Field Name             | Type             | Description | Allowed Values      |
| ---------------------- | ---------------- | ----------- | -------------------|
| allowEmptyValue        | boolean          |             |                    |
| allowRepeatedOccurrences| boolean         |             |                    |
| autoDetectBinaryValue  | boolean          |             |                    |
| checkSignatures        | boolean          |             |                    |
| decodeValueAsBase64    | string           | base64 enforcement |disabled, enabled, required|
| htmlNormalization      | boolean          |             |                    |
| mandatory              | boolean          |             |                    |
| maskValueInLogs        | boolean          |             |                    |
| name                   | string           | (explicit, wildcard) |                    |
| normalizationViolations| boolean          |             |                    |
| percentDecoding        | boolean          |             |                    |
| [signatureOverrides](#policy/headers/signatureOverrides)     | array of objects | Signature settings overrides |                    |
| type                   | string           | explicit, wildcard |explicit, wildcard    |
| urlNormalization       | boolean          |             |                    |
| wildcardOrder          | integer          | Wildcard match order |                    |

---

## signatureOverrides {#policy/headers/signatureOverrides}

| Field Name  | Type    | Description | Allowed Values |
| ----------- | ------- | ----------- | -------------- |
| enabled     | boolean |             |                |
| name        | string  |             |                |
| signatureId | integer |             |                |
| tag         | string  |             |                |

---

## host-names {#policy/host-names}

| Field Name        | Type    | Description | Allowed Values |
| ----------------- | ------- | ----------- | -------------- |
| includeSubdomains | boolean |             |                |
| name              | string  |             |                |

---

## idl-files {#policy/idl-files}

| Field Name | Type    | Description | Allowed Values |
| ---------- | ------- | ----------- | -------------- |
| contents   | string  |             |                |
| fileName   | string  |             |                |
| isBase64   | boolean |             |                |

---

## ip-address-lists {#policy/ip-address-lists}

| Field Name          | Type           | Description               | Allowed Values                 |
|---------------------|---------------|---------------------------|-------------------------------|
| blockRequests       | string        | Block handling            | always, never, policy-default |
| description         | string        | Description               |                               |
| [ipAddresses](#policy/ip-address-lists/ipAddresses)        | array of objects | List of IPs (use CIDR for subnet) |                     |
| matchOrder          | integer       | Match priority/order      |                               |
| name                | string        | Name                      |                               |
| neverLogRequests    | boolean       | If enabled, requests not logged |                        |
| setGeolocation      | string        | Fake geolocation          |                               |

---

## ipAddresses {#policy/ip-address-lists/ipAddresses}

| Field Name | Type   | Description                      | Allowed Values |
| ---------- | ------ | -------------------------------- | -------------- |
| ipAddress  | string | IP address/CIDR                  |                |

---

## ip-intelligence {#policy/ip-intelligence}

| Field Name                | Type             | Description | Allowed Values |
| ------------------------- | ----------------| ----------- | -------------- |
| enabled                   | boolean         |             |                |
| [ipIntelligenceCategories](#policy/ip-intelligence/ipIntelligenceCategories)  | array of objects|             |                |

---

## ipIntelligenceCategories {#policy/ip-intelligence/ipIntelligenceCategories}

| Field Name | Type    | Description | Allowed Values |
| ---------- | ------- | ----------- | -------------- |
| alarm      | boolean |             |                |
| block      | boolean |             |                |
| category   | string  |             | Anonymous Proxy, BotNets, Cloud-based Services, ...|

---

## json-profiles {#policy/json-profiles}

| Field Name                | Type             | Description | Allowed Values |
| ------------------------- | ----------------| ----------- | -------------- |
| attackSignaturesCheck     | boolean         |             |                |
| [defenseAttributes](#policy/json-profiles/defenseAttributes)         | object          |             |                |
| description               | string          |             |                |
| handleJsonValuesAsParameters| boolean       |             |                |
| hasValidationFiles        | boolean         |             |                |
| metacharElementCheck      | boolean         |             |                |
| [metacharOverrides](#policy/json-profiles/metacharOverrides)         | array of objects|             |                |
| name                      | string          |             |                |
| [signatureOverrides](#policy/json-profiles/signatureOverrides)       | array of objects|             |                |
| [validationFiles](#policy/json-profiles/validationFiles)           | array of objects|             |                |

---

##  defenseAttributes {#policy/json-profiles/defenseAttributes}

| Field Name                      | Type                                | Description | Allowed Values |
| ------------------------------- | -----------------------------------| ----------- | -------------- |
| maximumArrayLength              | integer min:0 max:2147483647 / string |         | Integer, "any" |
| maximumStructureDepth           | integer min:0 max:2147483647 / string |         | Integer, "any" |
| maximumTotalLengthOfJSONData    | integer min:0 max:2147483647 / string |         | Integer, "any" |
| maximumValueLength              | integer min:0 max:2147483647 / string |         | Integer, "any" |
| tolerateJSONParsingWarnings     | boolean                              |         |                |

---

## metacharOverrides {#policy/json-profiles/metacharOverrides}

| Field Name  | Type    | Description | Allowed Values |
| ----------- | ------- | ----------- | -------------- |
| isAllowed   | boolean |             |                |
| metachar    | string  |             |                |

---

## signatureOverrides {#policy/json-profiles/signatureOverrides}

| Field Name  | Type    | Description | Allowed Values |
| ----------- | ------- | ----------- | -------------- |
| enabled     | boolean |             |                |
| name        | string  |             |                |
| signatureId | integer |             |                |
| tag         | string  |             |                |

---

## validationFiles {#policy/json-profiles/validationFiles}

| Field Name      | Type           | Description | Allowed Values |
|-----------------|---------------|-------------|---------------|
| importUrl       | string        |             |               |
| isPrimary       | boolean       |             |               |
| [jsonValidationFile](#policy/json-profiles/validationFiles/jsonValidationFile) | object     |             |               |

---

## jsonValidationFile {#policy/json-profiles/validationFiles/jsonValidationFile}

| Field Name      | Type           | Description | Allowed Values |
|-----------------|---------------|-------------|---------------|
|        |         |             |               |

---

## json-validation-files {#policy/json-validation-files}

| Field Name | Type    | Description | Allowed Values |
| ---------- | ------- | ----------- | -------------- |
| contents   | string  |             |                |
| fileName   | string  |             |                |
| isBase64   | boolean |             |                |

---

## login-enforcement {#policy/login-enforcement}

| Field Name         | Type                          | Description | Allowed Values         |
| ------------------ | ----------------------------- | ----------- | ----------------------|
| authenticatedUrls  | array of strings              |             |                       |
| expirationTimePeriod| integer min:0 max:99999 / string|           | Integer, "disabled"   |
| [logoutUrls](#policy/login-enforcement/logoutUrls)         | array of objects              |             |                       |

---

## logoutUrls {#policy/login-enforcement/logoutUrls}

| Field Name      | Type    | Description | Allowed Values |
|-----------------|---------|-------------|---------------|
| requestContains | string  |             |               |
| requestOmits    | string  |             |               |
| url             | object  |             |               |

---

## login-pages {#policy/login-pages}

| Field Name       | Type    | Description | Allowed Values         |
|------------------|---------|-------------|-----------------------|
| [accessValidation](#policy/login-pages/accessValidation) | object  | Login page validation |               |
| authenticationType | string| Method the web server uses to authenticate |none, form, http-basic, http-digest, ntlm, ajax-or-json-request, request-body|
| passwordParameterName | string |         |                       |
| passwordRegex        | string |         |                       |
| [url](#policy/login-pages/url)                  | object |         |                       |
| usernameParameterName| string |         |                       |
| usernameRegex        | string |         |                       |

---

## accessValidation {#policy/login-pages/accessValidation}

| Field Name              | Type             | Description                                         | Allowed Values |
| ----------------------- | ---------------- | --------------------------------------------------- | -------------- |
| cookieContains          | string           | Cookie name required on response                     |                |
| headerContains          | string           | Header name/value required on response               |                |
| headerContainsMatchCondition| string       | Header match: exact or regex                        | exact, regex   |
| headerOmits             | string           | Header name/value that prohibits login               |                |
| headerOmitsMatchCondition| string          | Header omit match: exact or regex                   | exact, regex   |
| parameterContains       | string           | Required parameter in HTML body                      |                |
| responseContains        | string           | Required response string for successful login        |                |
| responseHttpStatus      | string           | HTTP response code required                          |                |
| responseHttpStatusOmits | array of strings | HTTP response code for failed login                  |                |
| responseOmits           | string           | Failed login indication string                       |                |

---

## methods {#policy/methods}

| Field Name | Type   | Description | Allowed Values |
| ---------- | ------ | ----------- | -------------- |
| name       | string |             |                |

---

## override-rules {#policy/override-rules}

| Field Name     | Type    | Description | Allowed Values |
| -------------- | ------- | ----------- | -------------- |
| actionType     | string  | extend-policy, replace-policy, violation | extend-policy, replace-policy, violation |
| condition      | string  | Condition syntax (see detailed HTML) | |
| name           | string  | Unique name                           | |
| override       | string  | Overriding policy definition           | |
| [violation](#policy/override-rules/violation)      | object  | Details of raised violation            | |

---

## violation {#policy/override-rules/violation}

| Field Name    | Type    | Description                                        | Allowed Values |
| ------------- | ------- | -------------------------------------------------- | -------------- |
| alarm         | boolean | Should the violation be logged                      |                |
| [attackType](#policy/override-rules/violation/attackType)    | object  | Associated attack type                              |                |
| block         | boolean | Should request be blocked                           |                |
| description   | string  | Text description                                    |                |
| rating        | integer min:3 max:5 | Violation rating                       |                |

---

## attackType {#policy/override-rules/violation/attackType}

| Field Name | Type   | Description                       | Allowed Values |
|------------|--------|-----------------------------------|---------------|
| name       | string | Name of attack type (mandatory)   |               |

---

## parameters {#policy/parameters}

| Field Name                      | Type              | Description | Allowed Values |
|---------------------------------|-------------------|-------------|---------------|
| allowEmptyValue                 | boolean           | Determines whether an empty value is allowed for a parameter. | |
| allowRepeatedParameterName      | boolean           | Multiple parameter instances with the same name allowed. | |
| arraySerializationFormat        | string            | Format for array of primitives. | csv, form, label, matrix, multi, multipart, pipe, ssv, tsv |
| arrayUniqueItemsCheck           | boolean           | Items in an array parameter must be unique. | |
| attackSignaturesCheck           | boolean           | Detect attacks in value. Only for alpha-numeric or binary. | |
| checkMaxItemsInArray            | boolean           | Restricts maximum number of items in array. | |
| checkMaxValue                   | boolean           | Restricts maximum value (integer or decimal). | |
| checkMaxValueLength             | boolean           | Restricts maximum value length. | |
| checkMetachars                  | boolean           | Detect disallowed metacharacters for wildcard/alpha-numeric. | |
| checkMinItemsInArray            | boolean           | Restricts minimum number of items in array. | |
| checkMinValue                   | boolean           | Restricts minimum value (integer/decimal). | |
| checkMinValueLength             | boolean           | Restricts minimum value length. | |
| checkMultipleOfValue            | boolean           | Value must be a multiple of number. | |
| [contentProfile](#policy/parameters/contentProfile)                 | object            | Content profile object. | |
| dataType                        | string            | alpha-numeric, binary, phone, email, boolean, integer, decimal | [see list] |
| decodeValueAsBase64             | string            | Value should/can/must be decoded as Base64. | disabled, enabled, required |
| disallowFileUploadOfExecutables | boolean           | Parameter cannot have binary executable content (binary only). | |
| enableRegularExpression         | boolean           | Parameter value must match regularExpression. | |
| exclusiveMax                    | boolean           | Maximum value is exclusive (if checkMaxValue=true). | |
| exclusiveMin                    | boolean           | Minimum value is exclusive (if checkMinValue=true). | |
| explodeObjectSerialization      | boolean           | Arrays/Objects have separate values for each item/property. | |
| hostNameRepresentation          | string            | Hostname format. | any, domain-name, ip-address |
| isCookie                        | boolean           | Parameter is in Cookie header. | |
| isHeader                        | boolean           | Parameter is in headers.       | |
| level                           | string            | Parameter matches: url, global | url, global |
| mandatory                       | boolean           | Parameter required.            | |
| maxItemsInArray                 | integer (min 0)   | Maximum items in array (if checkMaxItemsInArray). | |
| maximumLength                   | integer (min 0)   | Maximum value length (if checkMaxValueLength). | |
| maximumValue                    | number            | Maximum value (if checkMaxValue). | |
| metacharsOnParameterValueCheck  | boolean           | Disallowed metacharacters in value. | |
| minItemsInArray                 | integer (min 0)   | Minimum items in array (if checkMinItemsInArray). | |
| minimumLength                   | integer (min 0)   | Minimum value length (if checkMinValueLength). | |
| minimumValue                    | number            | Minimum value (if checkMinValue). | |
| multipleOf                      | number            | Value must be multiple of (if checkMultipleOfValue). | |
| name                            | string            | Parameter name (explicit or wildcard). | |
| [nameMetacharOverrides](#policy/parameters/nameMetacharOverrides)           | array of objects  | Override metachar settings for this parameter name. | |
| objectSerializationStyle        | string            | Serialization for object or complex array. | deep-object, form, label, matrix, pipe-delimited, simple, space-delimited |
| parameterEnumValues             | array of strings  | Set of allowed values (not for phone/email/binary). | |
| parameterLocation               | string            | Parameter location. | any, query, form-data, cookie, path, header |
| regularExpression               | string            | Positive regex for parameter value. | |
| sensitiveParameter              | boolean           | Parameter is sensitive (masked in logs/GUI). | |
| [signatureOverrides](#policy/parameters/signatureOverrides)              | array of objects  | Attack signature overrides for this parameter. | |
| staticValues                    | array of strings  | Value set for static-content parameters only. | |
| type                            | string            | explicit, wildcard                     | explicit, wildcard |
| [url](#policy/parameters/url)                             | object            | Reference to URL.                      | |
| [valueMetacharOverrides](#policy/parameters/valueMetacharOverrides)          | array of objects  | Override metachar settings for parameter value. | |
| valueType                       | string            | object, dynamic-content, openapi-array, ignore, static-content, json, array, user-input, xml, auto-detect, dynamic-parameter-name | [see list] |
| wildcardOrder                   | integer           | Wildcard matching order.                | |

---

### contentProfile {#policy/parameters/contentProfile}

| Field Name    | Type   | Description | Allowed Values |
|---------------|--------|-------------|---------------|
| [contentProfile](#policy/parameters/contentProfile/contentProfile) | object | Content profile object | |

---

### contentProfile {#policy/parameters/contentProfile/contentProfile}

| Field Name | Type   | Description | Allowed Values |
|------------|--------|-------------|---------------|
| name       | string |             |               |

---

### nameMetacharOverrides {#policy/parameters/nameMetacharOverrides}

| Field Name | Type    | Description                                         | Allowed Values |
|------------|---------|-----------------------------------------------------|---------------|
| isAllowed  | boolean | Permission for metachar (false = prohibited)        |               |
| metachar   | string  | Hex character                                      |               |

---

### signatureOverrides {#policy/parameters/signatureOverrides}

| Field Name  | Type    | Description                               | Allowed Values |
|-------------|---------|-------------------------------------------|---------------|
| enabled     | boolean | Signature is enforced                     |               |
| name        | string  | Attack signature name                     |               |
| signatureId | integer | Attack signature ID                       |               |
| tag         | string  | Attack signature tag                      |               |

---

### valueMetacharOverrides {#policy/parameters/valueMetacharOverrides}

| Field Name | Type    | Description                                    | Allowed Values |
|------------|---------|------------------------------------------------|---------------|
| isAllowed  | boolean | Permission for metachar (false = prohibited)   |               |
| metachar   | string  | Hex character                                  |               |

---

## response-pages {#policy/response-pages}

| Field Name           | Type    | Description | Allowed Values |
|----------------------|---------|-------------|---------------|
| ajaxActionType       | string  | AJAX response action | alert-popup, custom, redirect |
| ajaxCustomContent    | string  | Custom AJAX block message | |
| ajaxEnabled          | boolean | JavaScript injection for AJAX blocking | |
| ajaxPopupMessage     | string  | Message for popup | |
| ajaxRedirectUrl      | string  | URL for block redirect | |
| grpcStatusCode       | integer/string | gRPC status code | Integer, "ABORTED" |
| grpcStatusMessage    | string  | gRPC status message | |
| responseActionType   | string  | How a response is issued | custom, default, erase-cookies, redirect, soap-fault |
| responseContent      | string  | Content to return when blocked | |
| responseHeader       | string  | Headers for blocked response | |
| responsePageType     | string  | Which block page is returned | ajax, default, graphql, grpc, xml |
| responseRedirectUrl  | string  | Redirect URL with support ID | |

---

## sensitive-parameters {#policy/sensitive-parameters}

| Field Name | Type   | Description | Allowed Values |
|------------|--------|-------------|---------------|
| name       | string | Parameter name considered sensitive | |

---

## server-technologies {#policy/server-technologies}

| Field Name          | Type   | Description | Allowed Values (Examples) |
|---------------------|--------|-------------|----------------------|
| serverTechnologyName| string | Name of technology  | ASP, Node.js, PHP, React, WordPress, ... [see full list above] |

---

## signature-requirements {#policy/signature-requirements}

| Field Name          | Type   | Description | Allowed Values |
|---------------------|--------|-------------|---------------|
| maxRevisionDatetime | string |             |               |
| minRevisionDatetime | string |             |               |
| tag                 | string |             |               |

---

## signature-sets {#policy/signature-sets}

| Field Name          | Type            | Description | Allowed Values (see below) |
|---------------------|-----------------|-------------|---------------------------|
| alarm               | boolean         | Log requests for signatures from this set | |
| block               | boolean         | Block requests for signatures from this set | |
| learn               | boolean         | Suggest learning action | |
| name                | string          | Signature set name      | All Signatures, SQL Injection Signatures, etc |
| [signatureSet](#policy/signature-sets/signatureSet)        | object          | Defines signature set   | |
| stagingCertificationDatetime | string |             |               |

---

### signatureSet {#policy/signature-sets/signatureSet}

| Field Name     | Type             | Description | Allowed Values     |
|----------------|------------------|-------------|-------------------|
| [filter](#policy/signature-sets/signatureSet/filter)         | object           | Signature filter|                 |
| [signatures](#policy/signature-sets/signatureSet/signatures)      | array of objects | Included signatures|                |
| [systems](#policy/signature-sets/signatureSet/systems)         | array of objects | Matching systems|                  |
| type           | string           | filter-based, manual| filter-based, manual |

---

#### filter {#policy/signature-sets/signatureSet/filter}

| Field Name         | Type   | Description | Allowed Values |
|--------------------|--------|-------------|---------------|
| accuracyFilter     | string |             | all, eq, ge, le |
| accuracyValue      | string |             | all, high, low, medium |
| [attackType](#policy/signature-sets/signatureSet/filter/attackType)         | object |             | |
| hasCve             | string |             | all, no, yes |
| lastUpdatedFilter  | string |             | after, all, before |
| lastUpdatedValue   | string |             | |
| riskFilter         | string |             | all, eq, ge, le |
| riskValue          | string |             | all, high, low, medium |
| signatureType      | string |             | all, request, response |
| tagFilter          | string | See doc     | all, eq, untagged |
| tagValue           | string |             | |
| userDefinedFilter  | string |             | all, no, yes |

---

##### attackType {#policy/signature-sets/signatureSet/filter/attackType}

| Field Name | Type   | Description | Allowed Values |
|------------|--------|-------------|---------------|
| name       | string |             |               |

---

#### signatures {#policy/signature-sets/signatureSet/signatures}

| Field Name  | Type    | Description | Allowed Values |
|-------------|---------|-------------|---------------|
| name        | string  |             |               |
| signatureId | integer |             |               |
| tag         | string  |             |               |

---

#### systems {#policy/signature-sets/signatureSet/systems}

| Field Name | Type   | Description | Allowed Values |
|------------|--------|-------------|---------------|
| name       | string |             |               |

---

## signature-settings {#policy/signature-settings}

| Field Name                        | Type    | Description | Allowed Values |
|-----------------------------------|---------|-------------|---------------|
| minimumAccuracyForAutoAddedSignatures | string |              | high, low, medium |
| signatureStaging                  | boolean |             |               |
| stagingCertificationDatetime      | string  |             |               |

---

## signatures {#policy/signatures}

| Field Name    | Type    | Description | Allowed Values |
|---------------|---------|-------------|---------------|
| enabled       | boolean | If true, the signature is enabled | |
| learn         | boolean |             | |
| name          | string  | Signature name | |
| performStaging| boolean | Signature is in staging           | |
| signatureId   | integer | Signature ID | |
| tag           | string  | Signature tag | |

---

## threat-campaigns {#policy/threat-campaigns}

| Field Name   | Type    | Description | Allowed Values |
|--------------|---------|-------------|---------------|
| displayName  | string  |             |               |
| isEnabled    | boolean | Threat campaign enforced |         |
| name         | string  | Campaign name |             |

---

## urls {#policy/urls}

| Field Name           | Type             | Description | Allowed Values |
|----------------------|------------------|-------------|---------------|
| [accessProfile]({policy/urls/accessProfile)        | object           |             |               |
| allowRenderingInFrames| string          | Conditions for browser rendering in frames | never, only-same |
| allowRenderingInFramesOnlyFrom | string | Browser may load frame from domain |               |
| attackSignaturesCheck| boolean          | Override attack signatures for this URL |     |
| [authorizationRules]({policy/urls/authorizationRules)   | array of objects | Authorization rules |               |
| canChangeDomainCookie| boolean          |             |               |
| clickjackingProtection| boolean         | Add X-Frame-Options |               |
| disallowFileUploadOfExecutables | boolean |           |               |
| [html5CrossOriginRequestsEnforcement]({policy/urls/html5CrossOriginRequestsEnforcement) | object | Cross-domain config |           |
| isAllowed            | boolean          | URL allowed by security policy |     |
| mandatoryBody        | boolean          | Body is mandatory |               |
| [metacharOverrides]({policy/urls/)    | array of objects | Override metacharacters for this URL |     |
| metacharsOnUrlCheck  | boolean          | Check meta characters |           |
| method               | string           | Method for this URL | ACL, GET, POST, PUT, *, ... |
| [methodOverrides]({policy/urls/methodOverrides)      | array of objects | Allowed/disallowed method overrides |     |
| methodsOverrideOnUrlCheck | boolean     | Custom methods for this URL   |     |
| name                 | string           | URL path (explicit/wildcard) |         |
| operationId          | string           | OpenAPI endpoint identifier   |         |
| [positionalParameters]({policy/urls/positionalParameters) | array of objects | Positional URL parameters     |         |
| protocol             | string           | HTTP/HTTPS                    | http, https |
| [signatureOverrides]({policy/urls/signatureOverrides)   | array of objects | Signature overrides           |         |
| type                 | string           | explicit, wildcard            | explicit, wildcard |
| [urlContentProfiles]({policy/urls/urlContentProfiles)   | array of objects | Header/body content profile   |         |
| wildcardOrder        | integer          | Wildcard match order          |         |

---

### authorizationRules {#policy/urls/authorizationRules}

| Field Name | Type   | Description | Allowed Values |
|------------|--------|-------------|---------------|
| condition  | string |             |               |
| name       | string |             |               |

---

### html5CrossOriginRequestsEnforcement {#policy/urls/html5CrossOriginRequestsEnforcement}

| Field Name                  | Type             | Description | Allowed Values          |
|-----------------------------|------------------|-------------|------------------------|
| allowOriginsEnforcementMode | string           | Specify list of allowed origins | replace-with, unmodified |
| checkAllowedMethods         | boolean          | Allowed methods for cross domain|                   |
| [crossDomainAllowedOrigin](#policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin)    | array of objects | List of allowed origins        |                   |
| enforcementMode             | string           | Disabled or enforce CORS       | disabled, enforce |

---

#### crossDomainAllowedOrigin {#policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin}

| Field Name         | Type    | Description | Allowed Values     |
|--------------------|---------|-------------|--------------------|
| includeSubDomains  | boolean | Subdomains allowed? |           |
| originName         | string  | Allowed domain name |           |
| originPort         | integer min:0 max:65535 or string | Allowed port | Integer values, "all" |
| originProtocol     | string  | Protocol           | http, https, http/https |

---

### metacharOverrides {policy/urls/metacharOverrides}

| Field Name | Type    | Description                     | Allowed Values |
|------------|---------|---------------------------------|---------------|
| isAllowed  | boolean | Allowed in URL                  |               |
| metachar   | string  | Hex code                        |               |

---

### methodOverrides {#policy/urls/methodOverrides}

| Field Name | Type    | Description | Allowed Values (method) |
|------------|---------|-------------|------------------------|
| allowed    | boolean | Allow override? |                     |
| method     | string  | HTTP method    | ACL, GET, POST, ...  |

---

### positionalParameters {#policy/urls/positionalParameters}

| Field Name   | Type        | Description                        | Allowed Values |
|--------------|-------------|------------------------------------|---------------|
| [parameter](#policy/parameters)    | object      | Parameter object                   |               |
| urlSegmentIndex | integer (min 1) | Segment index                |               |

---

### signatureOverrides {#policy/urls/signatureOverrides}

| Field Name  | Type    | Description                | Allowed Values |
|-------------|---------|----------------------------|---------------|
| enabled     | boolean | Signature enforced         |               |
| name        | string  | Signature name             |               |
| signatureId | integer | Signature ID               |               |
| tag         | string  | Signature tag              |               |

---

### urlContentProfiles {#policy/urls/urlContentProfiles}

| Field Name      | Type        | Description                     | Allowed Values |
|-----------------|-------------|---------------------------------|---------------|
| [contentProfile](#policy/urls/urlContentProfiles/contentProfile)  | object      | Content profile                 |               |
| decodeValueAsBase64 | string  | Base64 decode for profile       | disabled, required |
| headerName      | string      | Explicit header                 |               |
| headerOrder     | integer/string | Check order                  | Integer, "default" |
| headerValue     | string      | Pattern for header value        |               |
| type            | string      | Content handling                | apply-content-signatures, apply-value-and-content-signatures, disallow, do-nothing, form-data, graphql, grpc, json, xml |

---

#### contentProfile {#policy/urls/urlContentProfiles/contentProfile}

| Field Name | Type   | Description | Allowed Values |
|------------|--------|-------------|---------------|
| name       | string |             |               |

---

## urls {#unknown-urls}

| Field Name | Reference | Type            | Description | Allowed Values |
|------------|-----------|-----------------|-------------|---------------|
| parameters | Yes       | array of objects |             |               |

---

## xml-profiles {#policy/xml-profiles}

| Field Name              | Type             | Description                   | Allowed Values |
|-------------------------|------------------|-------------------------------|---------------|
| attackSignaturesCheck   | boolean          |                               |               |
| [defenseAttributes](#policy/xml-profiles/defenseAttributes)       | object           |                               |               |
| description             | string           |                               |               |
| metacharAttributeCheck  | boolean          |                               |               |
| metacharElementCheck    | boolean          |                               |               |
| [metacharOverrides](#policy/xml-profiles/metacharOverrides)       | array of objects |                               |               |
| name                    | string           |                               |               |
| [signatureOverrides](#policy/xml-profiles/)      | array of objects |                               |               |
| useXmlResponsePage      | boolean          |                               |               |

---

### defenseAttributes {#policy/xml-profiles/defenseAttributes}

| Field Name                      | Type                                 | Description         | Allowed Values |
|---------------------------------|--------------------------------------|---------------------|---------------|
| allowCDATA                      | boolean                              |                     |               |
| allowDTDs                       | boolean                              |                     |               |
| allowExternalReferences         | boolean                              |                     |               |
| allowProcessingInstructions     | boolean                              |                     |               |
| maximumAttributeValueLength     | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumAttributesPerElement     | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumChildrenPerElement       | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumDocumentDepth            | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumDocumentSize             | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumElements                 | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumNSDeclarations           | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumNameLength               | integer min:0 max:2147483647 or string |               | Integer, any |
| maximumNamespaceLength          | integer min:0 max:2147483647 or string |               | Integer, any |
| tolerateCloseTagShorthand       | boolean                              |                     |               |
| tolerateLeadingWhiteSpace       | boolean                              |                     |               |
| tolerateNumericNames            | boolean                              |                     |               |

---

### metacharOverrides {#policy/xml-profiles/metacharOverrides}

| Field Name  | Type    | Description | Allowed Values |
|-------------|---------|-------------|---------------|
| isAllowed   | boolean |             |               |
| metachar    | string  |             |               |

---

### signatureOverrides {#policy/xml-profiles/signatureOverrides}

| Field Name  | Type    | Description | Allowed Values |
|-------------|---------|-------------|---------------|
| enabled     | boolean |             |               |
| name        | string  |             |               |
| signatureId | integer |             |               |
| tag         | string  |             |               |

---

## evasions {#policy/blocking-settings/evasions}

| Field Name         | Type                          | Description | Allowed Values          |
|--------------------|-------------------------------|-------------|------------------------|
| description        | string                        | Sub-violation name | %u decoding, Apache whitespace, Bad unescape, Bare byte decoding, Directory traversals, IIS Unicode codepoints, IIS backslashes, Multiple decoding, Multiple slashes, Semicolon path parameters |
| enabled            | boolean                       | Is enforced (alarm/block per parent evasion setting) | |
| learn              | boolean                       | Learned if parent is set to learn | |
| maxDecodingPasses  | integer (min 2, max 5)        | Decoding attempts before triggering evasion (Multiple decoding only) | |

---

## http-protocols {#policy/blocking-settings/http-protocols}

| Field Name     | Type                          | Description | Allowed Values              |
|----------------|-------------------------------|-------------|----------------------------|
| description    | string                        | Sub-violation name | POST request with Content-Length: 0, Multiple host headers, Host header contains IP address, Null in request, Header name with no header value, Chunked request with Content-Length header, Check maximum number of cookies, Check maximum number of parameters, Check maximum number of headers, Body in GET or HEAD requests, Bad multipart/form-data request parsing, Bad multipart parameters parsing, Unescaped space in URL, High ASCII characters in headers |
| enabled        | boolean                       | Is enforced (alarm/block per parent HTTP protocol setting) | |
| learn          | boolean                       | Learning enabled | |
| maxCookies     | integer (min 1, max 100)      | Max cookies (Check max cookies sub-violation) | |
| maxHeaders     | integer (min 1, max 150)      | Max headers (Check max headers sub-violation) | |
| maxParams      | integer (min 1, max 5000)     | Max parameters (Check max params sub-violation) | |

---

## violations {#policy/blocking-settings/violations}

| Field Name   | Type    | Description | Allowed Values (name) |
|--------------|---------|-------------|-----------------------|
| alarm        | boolean | Alarm enabled | |
| block        | boolean | Block enabled | |
| description  | string  | Violation description | |
| learn        | boolean | Learn enabled | |
| name         | string  | Violation name | VIOL_ACCESS_UNAUTHORIZED, VIOL_ACCESS_INVALID, VIOL_ACCESS_MALFORMED, VIOL_ACCESS_MISSING, VIOL_ASM_COOKIE_MODIFIED, VIOL_BLACKLISTED_IP, VIOL_BOT_CLIENT, VIOL_BRUTE_FORCE, VIOL_COOKIE_EXPIRED, VIOL_COOKIE_LENGTH, VIOL_COOKIE_MALFORMED, VIOL_COOKIE_MODIFIED, VIOL_CSRF, VIOL_DATA_GUARD, VIOL_ENCODING, VIOL_EVASION, VIOL_FILETYPE, VIOL_FILE_UPLOAD, VIOL_FILE_UPLOAD_IN_BODY, VIOL_GRAPHQL_MALFORMED, VIOL_GRAPHQL_FORMAT, VIOL_GRAPHQL_INTROSPECTION_QUERY, VIOL_GRAPHQL_ERROR_RESPONSE, VIOL_GRPC_FORMAT, VIOL_GRPC_MALFORMED, VIOL_GRPC_METHOD, VIOL_HEADER_LENGTH, VIOL_HEADER_METACHAR, VIOL_HEADER_REPEATED, VIOL_HTTP_PROTOCOL, VIOL_HTTP_RESPONSE_STATUS, VIOL_JSON_FORMAT, VIOL_JSON_MALFORMED, VIOL_JSON_SCHEMA, VIOL_LOGIN, VIOL_LOGIN_URL_BYPASSED, VIOL_LOGIN_URL_EXPIRED, VIOL_MANDATORY_HEADER, VIOL_MANDATORY_PARAMETER, VIOL_MANDATORY_REQUEST_BODY, VIOL_METHOD, VIOL_PARAMETER, VIOL_PARAMETER_ARRAY_VALUE, VIOL_PARAMETER_DATA_TYPE, VIOL_PARAMETER_EMPTY_VALUE, VIOL_PARAMETER_LOCATION, VIOL_PARAMETER_MULTIPART_NULL_VALUE, VIOL_PARAMETER_NAME_METACHAR, VIOL_PARAMETER_NUMERIC_VALUE, VIOL_PARAMETER_REPEATED, VIOL_PARAMETER_STATIC_VALUE, VIOL_PARAMETER_VALUE_BASE64, VIOL_PARAMETER_VALUE_LENGTH, VIOL_PARAMETER_VALUE_METACHAR, VIOL_PARAMETER_VALUE_REGEXP, VIOL_POST_DATA_LENGTH, VIOL_QUERY_STRING_LENGTH, VIOL_RATING_THREAT, VIOL_RATING_NEED_EXAMINATION, VIOL_REQUEST_MAX_LENGTH, VIOL_REQUEST_LENGTH, VIOL_THREAT_CAMPAIGN, VIOL_URL, VIOL_URL_CONTENT_TYPE, VIOL_URL_LENGTH, VIOL_URL_METACHAR, VIOL_XML_FORMAT, VIOL_XML_MALFORMED, VIOL_GEOLOCATION, VIOL_WEBSOCKET_BAD_REQUEST, VIOL_MALICIOUS_IP |

---

## settings {#policy/bot-defense/settings}

| Field Name               | Type    | Description                                                      | Allowed Values |
|--------------------------|---------|------------------------------------------------------------------|---------------|
| caseSensitiveHttpHeaders | boolean | If false, not case-sensitive for header name in anomaly check    |               |
| isEnabled                | boolean | If true, bot defense active                                      |               |

---

## mitigations {#policy/bot-defense/mitigations}

| Field Name   | Reference | Type             | Description | Allowed Values |
|--------------|-----------|------------------|-------------|---------------|
| [anomalies](#policy/bot-defense/mitigations/anomalies)   | Yes       | array of objects |             |               |
| [browsers](#policy/bot-defense/mitigations/browsers)   | Yes       | array of objects |             |               |
| [classes](#policy/bot-defense/mitigations/classes)   | Yes       | array of objects | List of classes and their actions. | |
| [signatures](#policy/bot-defense/mitigations/signatures)   | Yes       | array of objects | List of signatures and their actions; class default applies if not listed | |

---

### anomalies {#policy/bot-defense/mitigations/anomalies}

| Field Name     | Type                     | Description | Allowed Values             |
|----------------|--------------------------|-------------|---------------------------|
| action         | string                   |             | alarm, block, default, detect, ignore |
| name           | string                   |             |                               |
| scoreThreshold | integer (min 0, max 150) or string | Score trigger for anomaly | Integer, "default" |

---

### browsers {#policy/bot-defense/mitigations/browsers}

| Field Name   | Type           | Description | Allowed Values |
|--------------|----------------|-------------|---------------|
| action       | string         |             | alarm, block, detect |
| maxVersion   | integer (min 0, max 2147483647) | | |
| minVersion   | integer (min 0, max 2147483647) | | |
| name         | string         |             |               |

---

### classes {#policy/bot-defense/mitigations/classes}

| Field Name | Type   | Description      | Allowed Values                             |
|------------|--------|------------------|--------------------------------------------|
| action     | string | Class mitigation | alarm, block, detect, ignore               |
| name       | string | Class name       | browser, malicious-bot, suspicious-browser, trusted-bot, unknown, untrusted-bot |

---

### signatures {#policy/bot-defense/mitigations/signatures}

| Field Name | Type   | Description           | Allowed Values               |
|------------|--------|-----------------------|------------------------------|
| action     | string | Signature mitigation  | alarm, block, detect, ignore |
| name       | string | Signature name        |                              |

---
