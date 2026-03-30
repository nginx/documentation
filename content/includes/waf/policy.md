<!--- GENERATED FILE - DO NOT MODIFY --->

# Declarative Policy

<a id="policy"></a>


### policy



| Field Name | Type | Description |
|---|---|---|
| [access-profiles](#policy-access-profiles) | array of objects |  |
| `applicationLanguage` | string | The character encoding for the application. The character encoding determines how the policy processes the character sets. The default is utf-8. |
| [blocking-settings](#policy-blocking-settings) | object | This section defines policy block/alarm behaviors. |
| [bot-defense](#policy-bot-defense) | object | This section defines the properties of the bot defense feature. |
| [browser-definitions](#policy-browser-definitions) | array of objects |  |
| [brute-force-attack-preventions](#policy-brute-force-attack-preventions) | array of objects | Defines configuration for Brute Force Protection feature. There is default configuration (one with bruteForceProtectionForAllLoginPages flag and without url) that applies to all configured login URLs unless there exists another brute force configuration for a specific login page. |
| `caseInsensitive` | boolean | Specifies whether the security policy treats microservice URLs, file types, URLs, and parameters as case sensitive or not. When this setting is enabled, the system stores these security policy elements in lowercase in the security policy configuration. |
| [character-sets](#policy-character-sets) | array of objects |  |
| [cookie-settings](#policy-cookie-settings) | object | The maximum length of a cookie header name and value that the system processes. The system calculates and enforces a cookie header length based on the sum of the length of the cookie header name and value. |
| [cookies](#policy-cookies) | array of objects | This section defines Cookie entities for your policy. You can specify the cookies that you want to allow, and the ones you want to enforce in a security policy: | **Allowed cookies**: The system allows these cookies and clients can change them. | **Enforced cookies**: The system enforces the cookies in the list (not allowing clients to change them) and allows clients to change all others. |
| [csrf-protection](#policy-csrf-protection) | object |  |
| [csrf-urls](#policy-csrf-urls) | array of objects |  |
| [data-guard](#policy-data-guard) | object | Data Guard feature can prevent responses from exposing sensitive information by masking the data. |
| `description` | string | Specifies the description of the policy. |
| [disallowed-geolocations](#policy-disallowed-geolocations) | array of objects | Specifies a list of countries that may not access the web application. |
| `enforcementMode` | string | How the system processes a request that triggers a security policy violation. | **Blocking:** When the enforcement mode is set to blocking, traffic is blocked if it causes a violation (configured for blocking). | **Transparent:** When the enforcement mode is set to transparent, traffic is not blocked even if a violation is triggered. |
| [enforcer-settings](#policy-enforcer-settings) | object | This section contains all enforcer settings. |
| [filetypes](#policy-filetypes) | array of objects | File types are categorization of the URLs in the request by the extension appearing past the last dot at the end of the URL. For example, the file type of /index.php is "php". Other well known file types are html, aspx, png, jpeg and many more. A special case is the "empty" file type called "no-ext" meaning, no extension in which the URL has no dot at its last segment as in /foo_no_dot File types usually imply the expected content type in the response. For example, html and php return HTML content, while jpeg, png and gif return images, each in its respective format. File types also imply the server technology deployed for rendering the page. For example, php (PHP), aspx (ASP) and many others. The security policy uses file types for several purposes: 1. Ability to define which file types are allowed and which are disallowed. By including the pure wildcard "\*" file type and a list of disallowed file types you have a file type denylist. By having a list of explicit file type *without* the pure wildcard "\*" you have a file type allowlist. 2. Each file type implies maximum *length restrictions* for the requests of that file type. The checked lengths are per the URL, Query String, total request length, and payload (POST data). 3. Each file type determines whether to detect *response signatures* for requests of that file type. Typically, one would never check signatures for image file types. |
| `fullPath` | string | The full name of the policy including partition. |
| [general](#policy-general) | object | This section includes several advanced policy configuration settings. |
| [graphql-profiles](#policy-graphql-profiles) | array of objects |  |
| [grpc-profiles](#policy-grpc-profiles) | array of objects |  |
| [header-settings](#policy-header-settings) | object | The maximum length of an HTTP header name and value that the system processes. The system calculates and enforces the HTTP header length based on the sum of the length of the HTTP header name and value. |
| [headers](#policy-headers) | array of objects | This section defines Header entities for your policy. |
| [host-names](#policy-host-names) | array of objects |  |
| [idl-files](#policy-idl-files) | array of objects |  |
| [ip-address-lists](#policy-ip-address-lists) | array of objects | An IP address list is a list of IP addresses that you want the system to treat in a specific way for a security policy. |
| [ip-intelligence](#policy-ip-intelligence) | object |  |
| [json-profiles](#policy-json-profiles) | array of objects |  |
| [json-validation-files](#policy-json-validation-files) | array of objects |  |
| [login-enforcement](#policy-login-enforcement) | object |  |
| [login-pages](#policy-login-pages) | array of objects | A login page is a URL in a web application that requests must pass through to get to the authenticated URLs. Use login pages, for example, to prevent forceful browsing of restricted parts of the web application, by defining access permissions for users. Login pages also allow session tracking of user sessions. |
| [methods](#policy-methods) | array of objects |  |
| `name` | string | The unique user-given name of the policy. Policy names cannot contain spaces or special characters. Allowed characters are a-z, A-Z, 0-9, dot, dash (-), colon (:) and underscore (_). |
| [open-api-files](#policy-open-api-files) | array of objects |  |
| [override-rules](#policy-override-rules) | array of objects | This section defines policy override rules. |
| [parameters](#policy-parameters) | array of objects | This section defines parameters that the security policy permits in requests. |
| `performStaging` | boolean | Determines staging handling for all applicable entities in the policy, such as signatures, URLs, parameters, and cookies. If disabled, all entities will be enforced and any violations triggered will be considered illegal. |
| [response-pages](#policy-response-pages) | array of objects | The Security Policy has a default blocking response page that it returns to the client when the client request, or the web server response, is blocked by the security policy. You can change the way the system responds to blocked requests. All default response pages contain a variable, <%TS.request.ID()%>, that the system replaces with a support ID number when it issues the page. |
| [sensitive-parameters](#policy-sensitive-parameters) | array of objects | This section defines sensitive parameters. The contents of these parameters are not visible in logs nor in the user interfaces. Instead of actual values a string of asterisks is shown for these parameters. Use these parameters to protect sensitive user input, such as a password or a credit card number, in a validated request. A parameter name of "password" is always defined as sensitive by default. |
| [server-technologies](#policy-server-technologies) | array of objects | The server technology is a server-side application, framework, web server or operating system type that is configured in the policy in order to adapt the policy to the checks needed for the respective technology. |
| [signature-requirements](#policy-signature-requirements) | array of objects |  |
| [signature-sets](#policy-signature-sets) | array of objects | Defines behavior when signatures found within a signature-set are detected in a request. Settings are cumulative, so if a signature is found in any set with block enabled, that signature will have block enabled. |
| [signature-settings](#policy-signature-settings) | object |  |
| [signatures](#policy-signatures) | array of objects | This section defines the properties of a signature on the policy. |
| [template](#policy-template) | object | Specifies the template to populate the default attributes of a new policy. |
| [threat-campaigns](#policy-threat-campaigns) | array of objects | This section defines the enforcement state for the threat campaigns in the security policy. |
| [urls](#policy-urls) | array of objects | In a security policy, you can manually specify the HTTP URLs that are allowed (or disallowed) in traffic to the web application being protected. When you create a security policy, wildcard URLs of * (representing all HTTP URLs) are added to the Allowed HTTP URLs lists. |
| `wafEngineVersion` | string |  |
| [xml-profiles](#policy-xml-profiles) | array of objects |  |  |


<a id="policy/open-api-files"></a>


##### open-api-files



| Field Name | Type | Description |
|---|---|---|
| `link` | string |  |  |


<a id="policy/template"></a>


##### template



| Field Name | Type | Description |
|---|---|---|
| `derivedFrom` | string |  |
| `name` | string | Specifies the name of the template used for the policy creation. | * POLICY_TEMPLATE_NGINX_BASE |


---


<a id="policy/access-profiles"></a>


### access-profiles



| Field Name | Type | Description |
|---|---|---|
| `description` | string |  |
| `enforceMaximumLength` | boolean |  |
| `enforceValidityPeriod` | boolean |  |
| [keyFiles](#policy-access-profiles-keyFiles) | array of objects |  |
| [location](#policy-access-profiles-location) | object |  |
| `maximumLength` | integer |  |
| `name` | string |  |
| `type` | string |  |
| [usernameExtraction](#policy-access-profiles-usernameExtraction) | object |  |
| `verifyDigitalSignature` | boolean |  |  |


<a id="policy/access-profiles/keyFiles"></a>


##### keyFiles



| Field Name | Type | Description |
|---|---|---|
| `contents` | string |  |
| `fileName` | string |  |  |


<a id="policy/access-profiles/location"></a>


##### location



| Field Name | Type | Description |
|---|---|---|
| `in` | string |  |
| `name` | string |  |  |


<a id="policy/access-profiles/usernameExtraction"></a>


##### usernameExtraction



| Field Name | Type | Description |
|---|---|---|
| `claimPropertyName` | string |  |
| `enabled` | boolean |  |
| `isMandatory` | boolean |  |  |


---


<a id="policy/blocking-settings"></a>


### blocking-settings



| Field Name | Type | Description |
|---|---|---|
| [evasions](#policy-blocking-settings-evasions) | array of objects | This section defines behavior of 'Evasion technique detected' (VIOL_EVASION) violation sub-violations. User can control which sub-violations are enabled (alarmed/blocked). Behavior of sub-violations depends on the block/alarm settings of 'Evasion technique detected' violation, defined in /policy/blocking-settings/violations section: | If both alarm and block are disabled - enable flag becomes irrelevant, since there will be no block/alarm for all sub-violations |
| [http-protocols](#policy-blocking-settings-http-protocols) | array of objects | This section defines behavior of 'HTTP protocol compliance failed' (VIOL_HTTP_PROTOCOL) violation sub-violations. User can control which sub-violations are enabled (alarmed/blocked). Behavior of sub-violations depends on the block/alarm settings of 'HTTP protocol compliance failed' violation, | If both alarm and block are disabled - enable flag becomes irrelevant, since there will be no block/alarm for all sub-violations |
| [violations](#policy-blocking-settings-violations) | array of objects |  |  |


---


<a id="policy/bot-defense"></a>


### bot-defense



| Field Name | Type | Description |
|---|---|---|
| [mitigations](#policy-bot-defense-mitigations) | object | This section defines the mitigation to each class or signature. |
| [settings](#policy-bot-defense-settings) | object | This section contains all bot defense settings. |  |


---


<a id="policy/browser-definitions"></a>


### browser-definitions



| Field Name | Type | Description |
|---|---|---|
| `isUserDefined` | boolean |  |
| `matchRegex` | string |  |
| `matchString` | string |  |
| `name` | string |  |  |


---


<a id="policy/brute-force-attack-preventions"></a>


### brute-force-attack-preventions



| Field Name | Type | Description |
|---|---|---|
| `bruteForceProtectionForAllLoginPages` | boolean | When enabled, enables Brute Force Protection for all configured login URLs. When disabled, only brute force configurations for specific login pages are applied in case they exist. |
| [loginAttemptsFromTheSameIp](#policy-brute-force-attack-preventions-loginAttemptsFromTheSameIp) | object | Specifies configuration for detecting brute force attacks from IP Address. |
| [loginAttemptsFromTheSameUser](#policy-brute-force-attack-preventions-loginAttemptsFromTheSameUser) | object | Specifies configuration for detecting brute force attacks for Username. |
| `reEnableLoginAfter` | integer minimum: 60 maximum: 90000 | Defines prevention period (measured in seconds) for source-based brute force attacks. |
| `sourceBasedProtectionDetectionPeriod` | integer minimum: 60 maximum: 90000 | Defines detection period (measured in seconds) for source-based brute force attacks. |
| [url](#policy-urls) | object | Reference to the URL used in login URL configuration (policy/login-pages). This login URL is protected by Brute Force Protection feature. |  |


<a id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp"></a>


##### loginAttemptsFromTheSameIp



| Field Name | Type | Description |
|---|---|---|
| `action` | string | Specifies action that is applied when defined threshold is reached. | **alarm**: The system will log the login attempt. | **alarm-and-blocking-page**: The system will log the login attempt, block the request and send the Blocking page. | **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge. | **alarm-and-client-side-integrity**: The system determines whether the client is a legal browser or a bot by sending a page containing JavaScript code and waiting for a response. Legal browsers are able to execute JavaScript and produce a valid response, whereas bots cannot. A login attempt is logged if the client successfully passes the Client Side Integrity challenge. | **alarm-and-drop**: The system will log the login attempt and reset the TCP connection. | **alarm-and-honeypot-page**: The system will log the login attempt, block the request and send the Honeypot page. The Honeypot page is used for attacker deception. The page should look like an application failed login page. Unlike with the Blocking page, when the Honeypot page is sent an attacker is not able to distinguish a failed login response from a mitigation. As a result, the attacker will not change identity (Source IP or Device ID) and the brute force attack will be rendered ineffective. The Honeypot page is recommended when mitigation is request blocking. |
| `enabled` | boolean | When enabled, the system counts failed login attempts from IP Address. |
| `threshold` | integer minimum: 1 maximum: 1000 | After configured threshold (number of failed login attempts from IP Address) defined action will be applied for the next login attempt. |  |


<a id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser"></a>


##### loginAttemptsFromTheSameUser



| Field Name | Type | Description |
|---|---|---|
| `action` | string | Specifies action that is applied when defined threshold is reached. | **alarm**: The system will log the login attempt. | **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge. | **alarm-and-client-side-integrity**: The system determines whether the client is a legal browser or a bot by sending a page containing JavaScript code and waiting for a response. Legal browsers are able to execute JavaScript and produce a valid response, whereas bots cannot. A login attempt is logged if the client successfully passes the Client Side Integrity challenge. |
| `enabled` | boolean | When enabled, the system counts failed login attempts for each Username. |
| `threshold` | integer minimum: 1 maximum: 100 | After configured threshold (number of failed login attempts for each Username) defined action will be applied for the next login attempt. |  |


---


<a id="policy/character-sets"></a>


### character-sets



| Field Name | Type | Description |
|---|---|---|
| [characterSet](#policy-character-sets-characterSet) | array of objects |  |
| `characterSetType` | string |  | * header<br>• url<br>• parameter-name<br>• parameter-value<br>• xml-content<br>• json-content |


<a id="policy/character-sets/characterSet"></a>


##### characterSet



| Field Name | Type | Description |
|---|---|---|
| `isAllowed` | boolean |  |
| `metachar` | string |  |  |


---


<a id="policy/cookie-settings"></a>


### cookie-settings



| Field Name | Type | Description |
|---|---|---|
| `maximumCookieHeaderLength` | <br>• integer minimum: 1 maximum: 65536<br>• string | Maximum Cookie Header Length must be greater than 0 and less than 65536 bytes (64K). Note: if 0 or *any* are set, then no restriction on the cookie header length is applied. | * Integer values<br>• "any" |


---


<a id="policy/cookies"></a>


### cookies



| Field Name | Type | Description |
|---|---|---|
| `accessibleOnlyThroughTheHttpProtocol` | boolean | Specifies, when true, that the system adds the HttpOnly attribute to the domain cookie's response header. This is done to expose the cookie to only HTTP and HTTPS entities. This prevents the cookie from being modified, or intercepted even if it is not modified, by unwanted third parties that run scripts on the web page. **Notes**: | The system does not validate that the cookie has not been modified or intercepted. | The feature covers all security policy cookies, both enforced and allowed, explicit and wildcard. |
| `attackSignaturesCheck` | boolean | Specifies, when true, that you want attack signatures and threat campaigns to be detected on this cookie and possibly override the security policy settings of an attack signature or threat campaign specifically for this cookie. After you enable this setting, the system displays a list of attack signatures and threat campaigns. |
| `decodeValueAsBase64` | string | Specifies whether the the system should detect or require values to be Base64 encoded: | **disabled**: the value will not be decoded as Base64 content. | **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value. | **required**: the value must be decoded as Base64, and security checks will be performed on the decoded value. **Note**: This setting is only relevant if the Cookie Enforcement Type is set to Allowed. |
| `enforcementType` | string | Specifies how the system treats this cookie. | **enforced**: Specifies that according to the security policy, this cookie may not be changed by the client. | **allowed**: Specifies that according to the security policy, this cookie may be changed by the client. The system ignores this cookie. |
| `insertSameSiteAttribute` | string | The introduction of the SameSite http attribute (defined in [RFC6265bis](https://tools.ietf.org/html/draft-ietf-httpbis-cookie-same-site-00)) allows you to declare if your cookie should be restricted to a first-party or same-site context. Introducing the SameSite attribute on a cookie provides three different ways of controlling same-site vs. cross-site cookie sending: | **strict**: Cookie will only be sent in a first-party context. In user terms, the cookie will only be sent if the site for the cookie matches the site currently shown in the browser's URL bar. | **lax**: Cookies will be sent with top level navigation | **none-value**: Cookies will be sent in a third-party context. |
| `maskValueInLogs` | boolean | Specifies, when true, that the cookie's value will be masked in the request log. |
| `name` | string | Specifies the cookie name as appearing in the http cookie header. The cookie name length is limited to 500 characters. Names can be one of the following according to the *type* attribute: | **explicit**: Specifies that the cookie has a specific name and is not a wildcard entity. Type the name of a cookie exactly as you expect it to appear in the request. | **wildcard**: Specifies that any cookie that matches the listed wildcard expression should be treated according to the wildcard attributes. Type a wildcard expression that matches the expected cookie. For example, the wildcard expression cookie_12* of type Enforced specifies that the security policy should not allow modified domain cookies for all cookies which match cookie_12*. The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects. | **\***: Matches all characters | **?**: Matches any single character | **[abcde]**: Matches exactly one of the characters listed | **[!abcde]**: Matches any character not listed | **[a-e]**: Matches exactly one character in the range | **[!a-e]**: Matches any character not in the range **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard. |
| `securedOverHttpsConnection` | boolean | Specifies, when true, that the system adds the Secure attribute to the domain cookie's response header. This is done to ensure that the cookies are returned to the server only over SSL (by using the HTTPS protocol). This prevents the cookie from being intercepted, but does not guarantee its integrity. **Notes**: | The system does not validate that the cookie was received over SSL. | The feature covers all security policy cookies, both enforced and allowed, explicit and wildcard. |
| [signatureOverrides](#policy-cookies-signatureOverrides) | array of objects | Array of signature overrides. Specifies attack signatures whose security policy settings are overridden for this cookie, and which action the security policy takes when it discovers a request for this cookie that matches these attack signatures. |
| `type` | string | Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such. |
| `wildcardOrder` | integer | Specifies the order index for wildcard cookies matching. Wildcard cookies with lower wildcard order will get checked for a match prior to cookies with higher wildcard order. |  |


<a id="policy/cookies/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean | Specifies, when true, that the overridden signature is enforced |
| `name` | string | The signature name which, along with the signature tag, identifies the signature. |
| `signatureId` | integer | The signature ID which identifies the signature. |
| `tag` | string | The signature tag which, along with the signature name, identifies the signature. |  |


---


<a id="policy/csrf-protection"></a>


### csrf-protection



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean |  |
| `expirationTimeInSeconds` | <br>• integer<br>• string |  |
| `sslOnly` | boolean |  |  |


---


<a id="policy/csrf-urls"></a>


### csrf-urls



| Field Name | Type | Description |
|---|---|---|
| `enforcementAction` | string |  |
| `method` | string |  |
| `url` | string |  |
| `wildcardOrder` | integer |  |  |


---


<a id="policy/data-guard"></a>


### data-guard



| Field Name | Type | Description |
|---|---|---|
| `creditCardNumbers` | boolean | If *true* the system considers credit card numbers as sensitive data. |
| `customPatterns` | boolean | If *true* the system recognizes customized patterns as sensitive data. |
| `customPatternsList` | array of strings | List of PCRE regular expressions that specify the sensitive data patterns. |
| `enabled` | boolean | If *true* the system protects sensitive data. |
| `enforcementMode` | string | Specifies the URLs for which the system enforces data guard protection. | **ignore-urls-in-list**: Specifies that the system enforces data guard protection for all URLs except for those URLs in the Enforcement Mode list. | **enforce-urls-in-list**: Specifies that the system enforces data guard protection only for those URLs in the Enforcement Mode list |
| `enforcementUrls` | array of strings | List of URLS to be enforced based on enforcement mode of data guard protection. |
| `firstCustomCharactersToExpose` | integer minimum: 0 maximum: 255 | Specifies the number of first alphanumeric characters in Custom patterns that are exposed. |
| `lastCustomCharactersToExpose` | integer minimum: 0 maximum: 255 | Specifies the number of last alphanumeric characters in Custom patterns that are exposed. |
| `maskData` | boolean | If *true* the system intercepts the returned responses to mask sensitive data. |
| `usSocialSecurityNumbers` | boolean | If *true* the system considers U.S Social Security numbers as sensitive data. |  |


---


<a id="policy/disallowed-geolocations"></a>


### disallowed-geolocations



| Field Name | Type | Description |
|---|---|---|
| `countryCode` | string | Specifies the ISO country code of the selected country. |
| `countryName` | string | Specifies the name of the country. | * Afghanistan<br>• Aland Islands<br>• Albania<br>• Algeria<br>• American Samoa<br>• Andorra<br>• Angola<br>• Anguilla<br>• Anonymous Proxy<br>• Antarctica<br>• Antigua and Barbuda<br>• Argentina<br>• Armenia<br>• Aruba<br>• Australia<br>• Austria<br>• Azerbaijan<br>• Bahamas<br>• Bahrain<br>• Bangladesh<br>• Barbados<br>• Belarus<br>• Belgium<br>• Belize<br>• Benin<br>• Bermuda<br>• Bhutan<br>• Bolivia<br>• Bosnia and Herzegovina<br>• Botswana<br>• Bouvet Island<br>• Brazil<br>• British Indian Ocean Territory<br>• Brunei Darussalam<br>• Bulgaria<br>• Burkina Faso<br>• Burundi<br>• Cambodia<br>• Cameroon<br>• Canada<br>• Cape Verde<br>• Cayman Islands<br>• Central African Republic<br>• Chad<br>• Chile<br>• China<br>• Christmas Island<br>• Cocos (Keeling) Islands<br>• Colombia<br>• Comoros<br>• Congo<br>• Congo, The Democratic Republic of the<br>• Cook Islands<br>• Costa Rica<br>• Cote D'Ivoire<br>• Croatia<br>• Cuba<br>• Cyprus<br>• Czech Republic<br>• Denmark<br>• Djibouti<br>• Dominica<br>• Dominican Republic<br>• Ecuador<br>• Egypt<br>• El Salvador<br>• Equatorial Guinea<br>• Eritrea<br>• Estonia<br>• Ethiopia<br>• Falkland Islands (Malvinas)<br>• Faroe Islands<br>• Fiji<br>• Finland<br>• France<br>• France, Metropolitan<br>• French Guiana<br>• French Polynesia<br>• French Southern Territories<br>• Gabon<br>• Gambia<br>• Georgia<br>• Germany<br>• Ghana<br>• Gibraltar<br>• Greece<br>• Greenland<br>• Grenada<br>• Guadeloupe<br>• Guam<br>• Guatemala<br>• Guernsey<br>• Guinea<br>• Guinea-Bissau<br>• Guyana<br>• Haiti<br>• Heard Island and McDonald Islands<br>• Holy See (Vatican City State)<br>• Honduras<br>• Hong Kong<br>• Hungary<br>• Iceland<br>• India<br>• Indonesia<br>• Iran, Islamic Republic of<br>• Iraq<br>• Ireland<br>• Isle of Man<br>• Israel<br>• Italy<br>• Jamaica<br>• Japan<br>• Jersey<br>• Jordan<br>• Kazakhstan<br>• Kenya<br>• Kiribati<br>• Korea, Democratic People's Republic of<br>• Korea, Republic of<br>• Kuwait<br>• Kyrgyzstan<br>• Lao People's Democratic Republic<br>• Latvia<br>• Lebanon<br>• Lesotho<br>• Liberia<br>• Libyan Arab Jamahiriya<br>• Liechtenstein<br>• Lithuania<br>• Luxembourg<br>• Macau<br>• Macedonia<br>• Madagascar<br>• Malawi<br>• Malaysia<br>• Maldives<br>• Mali<br>• Malta<br>• Marshall Islands<br>• Martinique<br>• Mauritania<br>• Mauritius<br>• Mayotte<br>• Mexico<br>• Micronesia, Federated States of<br>• Moldova, Republic of<br>• Monaco<br>• Mongolia<br>• Montenegro<br>• Montserrat<br>• Morocco<br>• Mozambique<br>• Myanmar<br>• N/A<br>• Namibia<br>• Nauru<br>• Nepal<br>• Netherlands<br>• Netherlands Antilles<br>• New Caledonia<br>• New Zealand<br>• Nicaragua<br>• Niger<br>• Nigeria<br>• Niue<br>• Norfolk Island<br>• Northern Mariana Islands<br>• Norway<br>• Oman<br>• Other<br>• Pakistan<br>• Palau<br>• Palestinian Territory<br>• Panama<br>• Papua New Guinea<br>• Paraguay<br>• Peru<br>• Philippines<br>• Pitcairn Islands<br>• Poland<br>• Portugal<br>• Puerto Rico<br>• Qatar<br>• Reunion<br>• Romania<br>• Russian Federation<br>• Rwanda<br>• Saint Barthelemy<br>• Saint Helena<br>• Saint Kitts and Nevis<br>• Saint Lucia<br>• Saint Martin<br>• Saint Pierre and Miquelon<br>• Saint Vincent and the Grenadines<br>• Samoa<br>• San Marino<br>• Sao Tome and Principe<br>• Satellite Provider<br>• Saudi Arabia<br>• Senegal<br>• Serbia<br>• Seychelles<br>• Sierra Leone<br>• Singapore<br>• Slovakia<br>• Slovenia<br>• Solomon Islands<br>• Somalia<br>• South Africa<br>• South Georgia and the South Sandwich Islands<br>• Spain<br>• Sri Lanka<br>• Sudan<br>• Suriname<br>• Svalbard and Jan Mayen<br>• Swaziland<br>• Sweden<br>• Switzerland<br>• Syrian Arab Republic<br>• Taiwan<br>• Tajikistan<br>• Tanzania, United Republic of<br>• Thailand<br>• Timor-Leste<br>• Togo<br>• Tokelau<br>• Tonga<br>• Trinidad and Tobago<br>• Tunisia<br>• Turkey<br>• Turkmenistan<br>• Turks and Caicos Islands<br>• Tuvalu<br>• Uganda<br>• Ukraine<br>• United Arab Emirates<br>• United Kingdom<br>• United States<br>• United States Minor Outlying Islands<br>• Uruguay<br>• Uzbekistan<br>• Vanuatu<br>• Venezuela<br>• Vietnam<br>• Virgin Islands, British<br>• Virgin Islands, U.S.<br>• Wallis and Futuna<br>• Western Sahara<br>• Yemen<br>• Zambia<br>• Zimbabwe |


---


<a id="policy/enforcer-settings"></a>


### enforcer-settings



| Field Name | Type | Description |
|---|---|---|
| [enforcerStateCookies](#policy-enforcer-settings-enforcerStateCookies) | object | This section defines the properties of the enforcer state cookies. |  |


<a id="policy/enforcer-settings/enforcerStateCookies"></a>


##### enforcerStateCookies



| Field Name | Type | Description |
|---|---|---|
| `httpOnlyAttribute` | boolean | Specifies, when true, that the system adds the state cookie HttpOnly attribute. |
| `sameSiteAttribute` | string | The value for the state cookie SameSite attribute: | **none**: The SameSite attribute is never added to the state cookie. | **strict**: Cookie will only be sent in a first-party context. In user terms, the cookie will only be sent if the site for the cookie matches the site currently shown in the browser's URL bar. | **lax**: Cookies will be sent with top level navigation | **none-value**: Cookies will be sent in a third-party context. |
| `secureAttribute` | string | The value for the state cookie Secure attribute: | **always**: Always add the Secure attribute to the state cookie. | **never**: The Secure attribute is never added to the state cookie. | * always<br>• never |


---


<a id="policy/filetypes"></a>


### filetypes



| Field Name | Type | Description |
|---|---|---|
| `allowed` | boolean | Determines whether the file type is allowed or disallowed. In either of these cases the VIOL_FILETYPE violation is issued (if enabled) for an incoming request- 1. No allowed file type matched the file type of the request. 2. The file type of the request matched a disallowed file type. |
| `checkPostDataLength` | boolean | Determines whether to enforce maximum length restriction for the body, a.k.a. "POST data" part of the requests that match the respective file type. The maximum length is determined by *postDataLength* attribute. Although named "POST data", this applies to any content type and not restricted to POST requests, e.g. PUT requests are also checked. This attribute is relevant only to *allowed* file types. |
| `checkQueryStringLength` | boolean | Determines whether to enforce maximum length restriction for the query string of the requests that match the respective file type. The maximum length is determined by *queryStringLength* attribute. This attribute is relevant only to *allowed* file types. |
| `checkRequestLength` | boolean | Determines whether to enforce maximum length restriction for the total length of requests that match the respective file type. The maximum length is determined by *requestLength* attribute. This attribute is relevant only to *allowed* file types. |
| `checkUrlLength` | boolean | Determines whether to enforce maximum length restriction for the URL of the requests that match the respective file type. The URL does *not* include the query string, past the &. The maximum length is determined by *urlLength* attribute. This attribute is relevant only to *allowed* file types. |
| `name` | string | Specifies the file type name as appearing in the URL extension. Names can be one of the following according to the *type* attribute: | **Explicit** - Specifies that the name is the literal file extension to which the file type refers. The *type* attribute has to be "explicit". | **No Extension** - Specifies the empty file type, lacking file extension. For this the reserved string **no_ext** should be used. The *type* attribute has to be "explicit". | **Wildcard** - Specifies that any file extension that matches the wildcard expression is matched to this file type in the policy. The *type* attribute has to be "wildcard". The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects. | **\***: Matches all characters | **?**: Matches any single character | **[abcde]**: Matches exactly one of the characters listed | **[!abcde]**: Matches any character not listed | **[a-e]**: Matches exactly one character in the range | **[!a-e]**: Matches any character not in the range **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard. |
| `postDataLength` | integer minimum: 0 | The maximum length in bytes of the body (POST data) of the request matching the file type. Enforced only if checkPostDataLength is set to *true*. If the value is exceeded then VIOL_POST_DATA_LENGTH violation is issued. This attribute is relevant only to *allowed* file types. |
| `queryStringLength` | integer minimum: 0 | The maximum length in bytes of the query string of the request matching the file type. Enforced only if checkQueryStringLength is set to *true*. If the value is exceeded then VIOL_QUERY_STRING_LENGTH violation is issued. This attribute is relevant only to *allowed* file types. |
| `requestLength` | integer minimum: 0 | The maximum total length in bytes of the request matching the file type. Enforced only if checkRequestLength is set to *true*. If the value is exceeded then VIOL_REQUEST_LENGTH violation is issued. This attribute is relevant only to *allowed* file types. |
| `responseCheck` | boolean | Determines whether the responses to requests that match the respective file types are inspected for attack signature detection. This attribute is relevant only to *allowed* file types. |
| `responseCheckLength` | integer minimum: 0 maximum: 10000000000 | Determines how much of the response body will be checked for signatures. When value is set to 0, only the header will be checked. This attribute is relevant only to *allowed* file types. |
| `type` | string | Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such. |
| `urlLength` | integer minimum: 0 | The maximum length in bytes of the URL of the request matching the file type, excluding the query string. Enforced only if checkUrlLength is set to *true*. If the value is exceeded then VIOL_URL_LENGTH violation is issued. This attribute is relevant only to *allowed* file types. |
| `wildcardOrder` | integer |  |  |


---


<a id="policy/general"></a>


### general



| Field Name | Type | Description |
|---|---|---|
| `allowedResponseCodes` | array of integers | You can specify which responses a security policy permits. By default, the system accepts all response codes from 100 to 399 as valid responses. Response codes from 400 to 599 are considered invalid unless added to the Allowed Response Status Codes list. By default, 400, 401, 404, 407, 417, and 503 are on the list as allowed HTTP response status codes. |
| `customXffHeaders` | array of strings | If you require the system to trust a server further than one hop toward the client (the last proxy traversed), you can use the Custom XFF Headers setting to define a specific header that is inserted closer to, or at the client, that the system will trust. Additionally, if you require the system to trust a proxy server that uses a different header name than the X-Forwarded-For header name, you can add the desired header name to the Custom XFF Headers setting. When adding a custom header, the X-Forwarded-For header is not trusted anymore. In case the X-Forwarded-For header is to be trusted along with other headers, you must add it to the custom headers list. |
| `maskCreditCardNumbersInRequest` | boolean | When enabled, the security policy masks credit card numbers that appear in any part of requests. The system does not mask the information in the actual requests, but rather in various logs:<br>• Credit card numbers appearing in entity names are masked in the requests of the Requests log.<br>• Credit card numbers appearing in entity values are masked wherever requests can be viewed: the Requests log, and violation details within that log. This setting is enabled by default, and exists in addition to masking parameters defined as containing sensitive information. |
| `trustXff` | boolean | When enabled, the system has confidence in an XFF (X-Forwarded-For) header in the request. When disabled, that the system does not have confidence in an XFF header in the request. The default setting is disabled. Select this option if the system is deployed behind an internal or other trusted proxy. Then, the system uses the IP address that initiated the connection to the proxy instead of the internal proxy's IP address. Leave this option disabled if you think the HTTP header may be spoofed, or crafted, by a malicious client. With this setting disabled, if the system is deployed behind an internal proxy, the system uses the internal proxy's IP address instead of the client's IP address. |  |


---


<a id="policy/graphql-profiles"></a>


### graphql-profiles



| Field Name | Type | Description |
|---|---|---|
| `attackSignaturesCheck` | boolean |  |
| [defenseAttributes](#policy-graphql-profiles-defenseAttributes) | object |  |
| `description` | string |  |
| `hasIdlFiles` | boolean |  |
| [idlFiles](#policy-graphql-profiles-idlFiles) | array of objects |  |
| `metacharElementCheck` | boolean |  |
| [metacharOverrides](#policy-graphql-profiles-metacharOverrides) | array of objects |  |
| `name` | string |  |
| [responseEnforcement](#policy-graphql-profiles-responseEnforcement) | object |  |
| [sensitiveData](#policy-graphql-profiles-sensitiveData) | array of objects |  |
| [signatureOverrides](#policy-graphql-profiles-signatureOverrides) | array of objects |  |  |


<a id="policy/graphql-profiles/defenseAttributes"></a>


##### defenseAttributes



| Field Name | Type | Description |
|---|---|---|
| `allowIntrospectionQueries` | boolean |  |
| `maximumBatchedQueries` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumQueryCost` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumStructureDepth` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumTotalLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumValueLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `tolerateParsingWarnings` | boolean |  |  |


<a id="policy/graphql-profiles/idlFiles"></a>


##### idlFiles



| Field Name | Type | Description |
|---|---|---|
| [idlFile](#policy-graphql-profiles-idlFiles-idlFile) | object |  |
| `isPrimary` | boolean |  |  |


<a id="policy/graphql-profiles/idlFiles/idlFile"></a>


##### idlFile



| Field Name | Type | Description | Allowed Values |
|---|---|---|---|


<a id="policy/graphql-profiles/metacharOverrides"></a>


##### metacharOverrides



| Field Name | Type | Description |
|---|---|---|
| `isAllowed` | boolean |  |
| `metachar` | string |  |  |


<a id="policy/graphql-profiles/responseEnforcement"></a>


##### responseEnforcement



| Field Name | Type | Description |
|---|---|---|
| `blockDisallowedPatterns` | boolean |  |
| `disallowedPatterns` | array of strings |  |  |


<a id="policy/graphql-profiles/sensitiveData"></a>


##### sensitiveData



| Field Name | Type | Description |
|---|---|---|
| `parameterName` | string |  |  |


<a id="policy/graphql-profiles/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean |  |
| `name` | string |  |
| `signatureId` | integer |  |
| `tag` | string |  |  |


---


<a id="policy/grpc-profiles"></a>


### grpc-profiles



| Field Name | Type | Description |
|---|---|---|
| `associateUrls` | boolean |  |
| `attackSignaturesCheck` | boolean |  |
| `decodeStringValuesAsBase64` | string |  |
| [defenseAttributes](#policy-grpc-profiles-defenseAttributes) | object |  |
| `description` | string |  |
| `hasIdlFiles` | boolean |  |
| [idlFiles](#policy-grpc-profiles-idlFiles) | array of objects |  |
| `metacharElementCheck` | boolean |  |
| `name` | string |  |
| [signatureOverrides](#policy-grpc-profiles-signatureOverrides) | array of objects |  |  |


<a id="policy/grpc-profiles/defenseAttributes"></a>


##### defenseAttributes



| Field Name | Type | Description |
|---|---|---|
| `allowUnknownFields` | boolean |  |
| `maximumDataLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  | * Integer values<br>• "any" |


<a id="policy/grpc-profiles/idlFiles"></a>


##### idlFiles



| Field Name | Type | Description |
|---|---|---|
| [idlFile](#policy-grpc-profiles-idlFiles-idlFile) | object |  |
| `importUrl` | string |  |
| `isPrimary` | boolean |  |
| `primaryIdlFileName` | string |  |  |


<a id="policy/grpc-profiles/idlFiles/idlFile"></a>


##### idlFile



| Field Name | Type | Description | Allowed Values |
|---|---|---|---|


<a id="policy/grpc-profiles/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean |  |
| `name` | string |  |
| `signatureId` | integer |  |
| `tag` | string |  |  |


---


<a id="policy/header-settings"></a>


### header-settings



| Field Name | Type | Description |
|---|---|---|
| `maximumHttpHeaderLength` | <br>• integer minimum: 1 maximum: 65536<br>• string | Maximum HTTP Header Length must be greater than 0 and less than 65536 bytes (64K). Note: if 0 or *any* are set, then no restriction on the HTTP header length is applied. | * Integer values<br>• "any" |


---


<a id="policy/headers"></a>


### headers



| Field Name | Type | Description |
|---|---|---|
| `allowEmptyValue` | boolean |  |
| `allowRepeatedOccurrences` | boolean |  |
| `autoDetectBinaryValue` | boolean |  |
| `checkSignatures` | boolean |  |
| `decodeValueAsBase64` | string | Specifies whether the the system should detect or require values to be Base64 encoded: | **disabled**: the value will not be decoded as Base64 content. | **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value. | **required**: the value must be decoded as Base64, and security checks will be performed on the decoded value. |
| `htmlNormalization` | boolean |  |
| `mandatory` | boolean |  |
| `maskValueInLogs` | boolean | Specifies, when true, that the headers's value will be masked in the request log. |
| `name` | string | Specifies the HTTP header name. The header name length is limited to 254 characters. Names can be one of the following according to the *type* attribute: | **explicit**: Specifies that the header has a specific name and is not a wildcard entity. The name of the header exactly as you expect it to appear in the request. | **wildcard**: Specifies that any header that matches the listed wildcard expression should be treated according to the wildcard attributes. The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects. | **\***: Matches all characters | **?**: Matches any single character | **[abcde]**: Matches exactly one of the characters listed | **[!abcde]**: Matches any character not listed | **[a-e]**: Matches exactly one character in the range | **[!a-e]**: Matches any character not in the range **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard. |
| `normalizationViolations` | boolean |  |
| `percentDecoding` | boolean |  |
| [signatureOverrides](#policy-headers-signatureOverrides) | array of objects | Array of signature overrides. Specifies attack signatures whose security policy settings are overridden for this header, and which action the security policy takes when it discovers a request for this header that matches these attack signatures. |
| `type` | string | Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such. |
| `urlNormalization` | boolean |  |
| `wildcardOrder` | integer | Specifies the order index for wildcard header matching. Wildcard headers with lower wildcard order will get checked for a match prior to headers with higher wildcard order. |  |


<a id="policy/headers/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean | Specifies, when true, that the overridden signature is enforced |
| `name` | string | The signature name which, along with the signature tag, identifies the signature. |
| `signatureId` | integer | The signature ID which identifies the signature. |
| `tag` | string | The signature tag which, along with the signature name, identifies the signature. |  |


---


<a id="policy/host-names"></a>


### host-names



| Field Name | Type | Description |
|---|---|---|
| `includeSubdomains` | boolean |  |
| `name` | string |  |  |


---


<a id="policy/idl-files"></a>


### idl-files



| Field Name | Type | Description |
|---|---|---|
| `contents` | string |  |
| `fileName` | string |  |
| `isBase64` | boolean |  |  |


---


<a id="policy/ip-address-lists"></a>


### ip-address-lists



| Field Name | Type | Description |
|---|---|---|
| `blockRequests` | string | Specifies how the system responds to blocking requests sent from this IP address list. | **Policy Default:** Specifies that the policy enforcementMode will be used for requests from this IP address list. | **Never Block:** Specifies that the system does not block requests sent from this IP address list, even if your security policy is configured to block all traffic. | **Always Block:** Specifies that the system blocks requests sent from this IP address list. Optional, if absent Policy Default is used. |
| `description` | string | Specifies a brief description of the IP address list. Optional |
| [ipAddresses](#policy-ip-address-lists-ipAddresses) | array of objects | Specifies the IP addresses. Use CIDR notation for subnet definition. |
| `matchOrder` | integer | Specifies the order matching index between different IP Address Lists. If unspecified, the order is implicitly as the lists appear in the policy. IP Address Lists with a lower matchOrder will be checked for a match prior to items with higher matchOrder. |
| `name` | string | Specifies the name of ip address list. |
| `neverLogRequests` | boolean | Specifies when enabled that the system does not log requests or responses sent from this IP address list, even if the traffic is illegal, and even if your security policy is configured to log all traffic. Optional, if absent default value is false. |
| `setGeolocation` | string | Specifies a geolocation to be associated for this IP address list. This will force the IP addresses in the list to be considered as though they are in that geolocation. This applies to blocking via "disallowed-geolocations" and to logging. Optional |  |


<a id="policy/ip-address-lists/ipAddresses"></a>


##### ipAddresses



| Field Name | Type | Description |
|---|---|---|
| `ipAddress` | string | Specifies the IP address. Use CIDR notation for subnet definition. |  |


---


<a id="policy/ip-intelligence"></a>


### ip-intelligence



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean |  |
| [ipIntelligenceCategories](#policy-ip-intelligence-ipIntelligenceCategories) | array of objects |  |  |


<a id="policy/ip-intelligence/ipIntelligenceCategories"></a>


##### ipIntelligenceCategories



| Field Name | Type | Description |
|---|---|---|
| `alarm` | boolean |  |
| `block` | boolean |  |
| `category` | string |  | * Anonymous Proxy<br>• BotNets<br>• Cloud-based Services<br>• Denial of Service<br>• Infected Sources<br>• Mobile Threats<br>• Phishing Proxies<br>• Scanners<br>• Spam Sources<br>• Tor Proxies<br>• Web Attacks<br>• Windows Exploits |


---


<a id="policy/json-profiles"></a>


### json-profiles



| Field Name | Type | Description |
|---|---|---|
| `attackSignaturesCheck` | boolean |  |
| [defenseAttributes](#policy-json-profiles-defenseAttributes) | object |  |
| `description` | string |  |
| `handleJsonValuesAsParameters` | boolean |  |
| `hasValidationFiles` | boolean |  |
| `metacharElementCheck` | boolean |  |
| [metacharOverrides](#policy-json-profiles-metacharOverrides) | array of objects |  |
| `name` | string |  |
| [signatureOverrides](#policy-json-profiles-signatureOverrides) | array of objects |  |
| [validationFiles](#policy-json-profiles-validationFiles) | array of objects |  |  |


<a id="policy/json-profiles/defenseAttributes"></a>


##### defenseAttributes



| Field Name | Type | Description |
|---|---|---|
| `maximumArrayLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumStructureDepth` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumTotalLengthOfJSONData` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumValueLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `tolerateJSONParsingWarnings` | boolean |  |  |


<a id="policy/json-profiles/metacharOverrides"></a>


##### metacharOverrides



| Field Name | Type | Description |
|---|---|---|
| `isAllowed` | boolean |  |
| `metachar` | string |  |  |


<a id="policy/json-profiles/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean |  |
| `name` | string |  |
| `signatureId` | integer |  |
| `tag` | string |  |  |


<a id="policy/json-profiles/validationFiles"></a>


##### validationFiles



| Field Name | Type | Description |
|---|---|---|
| `importUrl` | string |  |
| `isPrimary` | boolean |  |
| [jsonValidationFile](#policy-json-profiles-validationFiles-jsonValidationFile) | object |  |  |


<a id="policy/json-profiles/validationFiles/jsonValidationFile"></a>


##### jsonValidationFile



| Field Name | Type | Description | Allowed Values |
|---|---|---|---|


---


<a id="policy/json-validation-files"></a>


### json-validation-files



| Field Name | Type | Description |
|---|---|---|
| `contents` | string |  |
| `fileName` | string |  |
| `isBase64` | boolean |  |  |


---


<a id="policy/login-enforcement"></a>


### login-enforcement



| Field Name | Type | Description |
|---|---|---|
| `authenticatedUrls` | array of strings |  |
| `expirationTimePeriod` | <br>• integer minimum: 0 maximum: 99999<br>• string |  |
| [logoutUrls](#policy-login-enforcement-logoutUrls) | array of objects |  |  |


<a id="policy/login-enforcement/logoutUrls"></a>


##### logoutUrls



| Field Name | Type | Description |
|---|---|---|
| `requestContains` | string |  |
| `requestOmits` | string |  |
| [url](#policy-urls) | object |  |  |


---


<a id="policy/login-pages"></a>


### login-pages



| Field Name | Type | Description |
|---|---|---|
| [accessValidation](#policy-login-pages-accessValidation) | object | Access Validation define validation criteria for the login page response. If you define more than one validation criteria, the response must meet all the criteria before the system allows the user to access the application login URL. |
| `authenticationType` | string | Authentication Type is method the web server uses to authenticate the login URL's credentials with a web user. | **none**: The web server does not authenticate users trying to access the web application through the login URL. This is the default setting. | **form**: The web application uses a form to collect and authenticate user credentials. If using this option, you also need to type the user name and password parameters written in the code of the HTML form. | **http-basic**: The user name and password are transmitted in Base64 and stored on the server in plain text. | **http-digest**: The web server performs the authentication; user names and passwords are not transmitted over the network, nor are they stored in plain text. | **ntlm**: Microsoft LAN Manager authentication (also called Integrated Windows Authentication) does not transmit credentials in plain text, but requires a continuous TCP connection between the server and client. | **ajax-or-json-request**: The web server uses JSON and AJAX requests to authenticate users trying to access the web application through the login URL. For this option, you also need to type the name of the JSON element containing the user name and password. | **request-body**: The web server uses the request body to authenticate users trying to access the web application through the login URL. This allows brute force login detection using, for example, SAML authentication used on Microsoft Federation Services for SSO which uses SOAP API to login. |
| `passwordParameterName` | string | A name of parameter which will contain password string. |
| `passwordRegex` | string | PCRE regular expression for capturing the password. The regular expression must include exactly one capturing group (in rounded parentheses) for the value of the password. For example: "pwd=(\w+)". The entered expression is validated and any invalid code is noted and must be corrected. Note: This setting is only relevant if authenticationType is request-body. |
| [url](#policy-urls) | object | URL string used for login page. |
| `usernameParameterName` | string | A name of parameter which will contain username string. |
| `usernameRegex` | string | PCRE regular expression for capturing the username. The regular expression must include exactly one capturing group (in rounded parentheses) for the value of the username. For example: "user_id=(\w+)". The entered expression is validated and any invalid code is noted and must be corrected. Note: This setting is only relevant if authenticationType is request-body. |  |


<a id="policy/login-pages/accessValidation"></a>


##### accessValidation



| Field Name | Type | Description |
|---|---|---|
| `cookieContains` | string | A defined domain cookie name that the response to the login URL must match to permit user access to the authenticated URL. |
| `headerContains` | string | A header name and value that the response to the login URL must match to permit user access to the authenticated URL. |
| `headerContainsMatchCondition` | string |  |
| `headerOmits` | string | A header name and value that indicates a failed login attempt and prohibits user access to the authenticated URL. |
| `headerOmitsMatchCondition` | string |  |
| `parameterContains` | string | A parameter that must exist in the login URL's HTML body to allow access to the authenticated URL. |
| `responseContains` | string | A string that must appear in the response for the system to allow the user to access the authenticated URL; for example, "Successful Login". |
| `responseHttpStatus` | string | An HTTP response code that the server must return to the user to allow access to the authenticated URL; for example, "200". |
| `responseHttpStatusOmits` | array of strings | An HTTP response code that indicates a failed login attempt and prohibits user access to the authenticated URL. |
| `responseOmits` | string | A string that indicates a failed login attempt and prohibits user access to the authenticated URL; for example, "Authentication failed". |  |


---


<a id="policy/methods"></a>


### methods



| Field Name | Type | Description |
|---|---|---|
| `name` | string |  |  |


---


<a id="policy/override-rules"></a>


### override-rules



| Field Name | Type | Description |
|---|---|---|
| `actionType` | string | The action to take when the override rule is matched. Possible values are: | **extend-policy**: The override policy inherits the containing policy settings, allowing only the required settings to be overridden. | **replace-policy**: The override policy must be a valid declarative policy that includes a name, template and all necessary settings. | **violation**: The request is blocked and a the VIOL_RULE is logged based on the provided violation settings. |
| `condition` | string | Specifies the condition under which the override rule should be applied. Example: "clientIp != '10.0.0.5' and userAgent.lower().contains('WebRobot')" Condition Syntax: | The condition consists of one or more clauses separated by **and** or **or**. Example: "clientIp == '10.0.0.5' and (host.startsWith('internal') or uri.contains('api'))" | Each clause can optionally start with **not** - to negate the expression. Example: "not clientIp == '127.0.0.1'" | **not** can also be used to negate a parenthesized expression. Example: "not (method == 'GET' or method == 'PUT')" | A clause can be a simple comparison between two value expressions, or a boolean function applied to a literal value. Supported comparison operators: | **==** - Checks for equality between two value expressions. | **!=** - Checks for inequality between two value expressions. Example: "clientIp != '10.0.0.5'" (equivalent to "not clientIp == '10.0.0.5'") Supported boolean functions: | **matches**: Performs an exact match of a value expression, equivalent to **==**. | **startsWith**: Checks if a value expression starts with a specific substring. | **contains**: Checks if a value expression contains a specific substring. Example: "uri.startsWith('/api')" **Note**: Functions "startsWith" and "contains" are not applicable to the "clientIp" attribute. Regular expressions are not supported. | Value expressions can be a request attribute, literal value, or a value function. | A literal can be a string value enclosed in single quotes, or can be the keyword "null" without quotes. Example: "userAgent == null" Supported value functions: | **lower**: Any boolean function applied on the resulting string will be **case insensitive**. Applicable to ANSI characters only. Example: "uri.lower().contains('BaR')" will match the URI "/Foo/bAr" Request Attributes: | **clientIp**: Client IP address in canonical IPv4 or IPv6 format or ip-address-list. Use CIDR notation for subnet definition. Example: *192.168.1.2* or *fd00:1::/48*. If *trustXff* (X-Forwarded-For) is enabled in the containing policy, then the value is taken from the configured header (XFF or other). The only supported boolean function for the clientIP attribute is *matches*. | **host**: The value of the Host header | **method**: The HTTP method in the request | **uri**: The URI (path part) of the request | **userAgent**: The value of the User-Agent header, or *null* (without quotes) if not present | **geolocation**: The geolocation of the client IP address. The value is the ISO 3166 two-letter code of the respective country. | **parameters['<name>']**: (map-type) The value of the specified parameter name (limited to query string parameters). Example: "parameters['id'] == '11'" | **cookies['<name>']**: (map-type) The value of the specified cookie name. Example: "cookies['Path'].contains('product')" | **headers['<name>']**: (map-type) The value of the specified header name. Example: "headers['Accept'].startsWith('application')" **Note**: | The "headers['<name>']" attribute does not support 'Cookie' as a header name. | Attribute "clientIp" supports using "ipAddressLists" in condition: "clientIp.matches(ipAddressLists['<name>'])" |
| `name` | string | The unique name of the override rule. Cannot contain spaces or special characters. |
| [override](#policy-override-rules-override) | object | The overriding security policy definition. |
| [violation](#policy-override-rules-violation) | object | Contains the details of the raised VIOL_RULE violation. Mandatory if action-type is violation. |  |


<a id="policy/override-rules/override"></a>


##### override



| Field Name | Type | Description | Allowed Values |
|---|---|---|---|


<a id="policy/override-rules/violation"></a>


##### violation



| Field Name | Type | Description |
|---|---|---|
| `alarm` | boolean | Whether the violation should be marked in the security log and cause the request to be classified as "illegal". |
| [attackType](#policy-override-rules-violation-attackType) | object | The attack type associated with the violation in the present rule. This is reflected in the security log. Mandatory. |
| `block` | boolean | Whether the violation should cause the request to be blocked. On other words: the block flag of the VIOL_RULE for the present rule. |
| `description` | string | Textual description of the violation in the present rule. Limited to 200 characters. Not Mandatory. |
| `rating` | integer minimum: 3 maximum: 5 | The violation rating that the present rule violation  will induce. In other words, the violation rating of the request will be the maximum between this value and the calculated value based on the other violations in the request. If not specified and there is no other violation, then the VR is 3. |  |


<a id="policy/override-rules/violation/attackType"></a>


##### attackType



| Field Name | Type | Description |
|---|---|---|
| `name` | string | The name of the attack type. Mandatory. |  |


---


<a id="policy/parameters"></a>


### parameters



| Field Name | Type | Description |
|---|---|---|
| `allowEmptyValue` | boolean | Determines whether an empty value is allowed for a parameter. |
| `allowRepeatedParameterName` | boolean | Determines whether multiple parameter instances with the same name are allowed in one request. |
| `arraySerializationFormat` | string | Specifies type of serialization for array of primitives parameter. Serialization defines how multiple values are delimited - format that can be transmitted and reconstructed later: | **pipe**: pipe-separated values. Array color=["blue","black"] -> color=blue|black. | **form**: ampersand-separated values. Array color=["blue","black"] -> color=blue,black. | **matrix**: semicolon-prefixed values. Array color=["blue","black"] -> ;color=blue,black. | **tsv**: tab-separated values. Array color=["blue","black"] -> color=blue\tblack. | **csv**: comma-separated values. Array color=["blue","black"] -> color=blue,black. | **label**: dot-prefixed values. Array color=["blue","black"] -> .blue.black. | **multi**: multiple parameter instances rather than multiple values. Array color=["blue","black"] -> color=blue&color=black. | **ssv**: space-separated values. Array color=["blue","black"] -> color=blue black. | **multipart**: defines array of files. **Notes**: | This attribute is relevant only for parameters with **array** *valueType*. | **multi** and **form** serializations can be defined for parameter with *query*, *form-data* or *cookie* locations only. | **multipart** serialization can be defined for parameter with *form-data* location only. | **matrix** and **label** serializations can be defined for parameter with *path* location only. |
| `arrayUniqueItemsCheck` | boolean | Determines whether items in an array parameter must be unique. This attribute is relevant only for parameters with **array** *valueType*. |
| `attackSignaturesCheck` | boolean | Determines whether attack signatures and threat campaigns must be detected in a parameter's value. This attribute is relevant only for parameters with **alpha-numeric** or **binary** *dataType*. |
| `checkMaxItemsInArray` | boolean | Determines whether an array parameter has a restricted maximum number of items. This attribute is relevant only for parameters with **array** *valueType*. |
| `checkMaxValue` | boolean | Determines whether the parameter has a restricted maximum value. This attribute is relevant only for parameters with **integer** or **decimal** *dataType*. |
| `checkMaxValueLength` | boolean | Determines whether a parameter has a restricted maximum length for value. |
| `checkMetachars` | boolean | Determines whether disallowed metacharacters must be detected in a parameter's name. This attribute is relevant only for **wildcard** parameters with **alpha-numeric** *dataType*. |
| `checkMinItemsInArray` | boolean | Determines whether an array parameter has a restricted minimum number of items. This attribute is relevant only for parameters with **array** *valueType*. |
| `checkMinValue` | boolean | Determines whether a parameter has a restricted minimum value. This attribute is relevant only for parameters with **integer** or **decimal** *dataType*. |
| `checkMinValueLength` | boolean | Determines whether a parameter has a restricted minimum length for value. |
| `checkMultipleOfValue` | boolean | Determines whether a parameter's value is a multiple of a number defined in *multipleOf*. This attribute is relevant only for parameters with **integer** or **decimal** *dataType*. |
| [contentProfile](#policy-parameters-contentProfile) | object |  |
| `dataType` | string | Specifies data type of parameter's value: | **alpha-numeric**: specifies that the value of parameter can be any text consisting of letters, digits, and the underscore character. | **binary**: specifies there is no text limit for the value of a parameter (length checks only). | **phone**: specifies that the value of a parameter can be text in telephone number format only. | **email**: specifies that the value of a parameter must be text in email format only. | **boolean**: specifies that the value of a parameter must be boolean (only *true* and  *false* values are allowed). | **integer**: specifies that the value of a parameter must be whole numbers only (no decimals). | **decimal**: specifies that the value of a parameter is numbers only and can include decimals. **Notes**: | This attribute is relevant for parameters with **array** or **user-input** *valueType* only. |
| `decodeValueAsBase64` | string | Specifies whether the the system should detect or require values to be Base64 encoded: | **disabled**: the value will not be decoded as Base64 content. | **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value. | **required**: the value must be decoded as Base64. Security checks will be performed on the decoded value. **Notes**: | This attribute is relevant for parameters with **binary**, **auto-detect**, or **user-input** *valueType* only. |
| `disallowFileUploadOfExecutables` | boolean | Determines whether a parameter's value cannot have binary executable content. This attribute is relevant only for parameters with **binary** *dataType*. |
| `enableRegularExpression` | boolean | Determines whether the parameter value includes the pattern defined in *regularExpression*. This attribute is relevant only for parameters with **alpha-numeric** *dataType*. |
| `exclusiveMax` | boolean | Determines whether the maximum value defined in *maximumValue* attribute is exclusive. This attribute is relevant only if *checkMaxValue* is set to **true**. |
| `exclusiveMin` | boolean | Determines whether a minimum value defined in *minimumValue* attribute is exclusive. This attribute is relevant only if *checkMinValue* is set to **true**. |
| `explodeObjectSerialization` | boolean | Specifies whether an array or object parameters should have separate values for each array item or object property. This attribute is relevant only if *objectSerializationStyle* is defined. **Notes**: | This attribute is not relevant for parameters with **deep-object**, **space-delimited** or **pipe-delimited** *objectSerializationStyle*. |
| `hostNameRepresentation` | string |  |
| `isCookie` | boolean | Determines whether a parameter is located in the value of Cookie header. *parameterLocation* attribute is ignored if **isCookie** is set to *true*. |
| `isHeader` | boolean | Determines whether a parameter is located in headers as one of the headers. *parameterLocation* attribute is ignored if **isHeader** is set to *true*. |
| `level` | string | Specifies whether the parameter is associated with a URL, a flow, or neither. |
| `mandatory` | boolean | Determines whether a parameter must exist in the request. |
| `maxItemsInArray` | integer minimum: 0 | Determines the restriction for the maximum number of items in an array parameter. This attribute is relevant only if *checkMaxItemsInArray* is set to **true**. |
| `maximumLength` | integer minimum: 0 | Determines the restriction for the maximum length of parameter's value. This attribute is relevant only if *checkMaxValueLength* is set to **true**. |
| `maximumValue` | number | Determines the restriction for the maximum value of parameter. This attribute is relevant only if *checkMaxValue* is set to **true**. |
| `metacharsOnParameterValueCheck` | boolean | Determines whether disallowed metacharacters must be detected in a parameter's value. This attribute is relevant only for parameters with **alpha-numeric** *dataType*. |
| `minItemsInArray` | integer minimum: 0 | Determines the restriction for the minimum number of items in an array parameter. This attribute is relevant only if *checkMinItemsInArray* is set to **true**. |
| `minimumLength` | integer minimum: 0 | Determines the restriction for the minimum length of parameter's value. This attribute is relevant only if *checkMinValueLength* is set to **true**. |
| `minimumValue` | number | Determines the restriction for the minimum value of a parameter. This attribute is relevant only if *checkMinValue* is set to **true**. |
| `multipleOf` | number | Determines the number by which a parameter's value is divisible without remainder. This number must be positive and it may be a floating-point number. This attribute is relevant only if *checkMultipleOfValue* is set to **true**. |
| `name` | string | Specifies the name of a parameter which must be permitted in requests. Format of parameter name attribute differs depending on *type* attribute: | **explicit** *type*: name of permitted parameter in request should literally match. | **wildcard** *type*: name of permitted parameter in request should match wildcard expression. The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects. | **\***: Matches all characters | **?**: Matches any single character | **[abcde]**: Matches exactly one of the characters listed | **[!abcde]**: Matches any character not listed | **[a-e]**: Matches exactly one character in the range | **[!a-e]**: Matches any character not in the range **Notes**: | Wildcards do not match regular expressions. Do not use a regular expression as a wildcard. | Empty parameter name is allowed for **explicit** *type* |
| [nameMetacharOverrides](#policy-parameters-nameMetacharOverrides) | array of objects | Determines metacharacters whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request for this parameter that has these metacharacters in the name. This attribute is relevant only if *checkMetachars* is set to **true**. |
| `objectSerializationStyle` | string | Specifies the type of serialization for an object or complex array parameter. Serialization defines how multiple values are delimited - format that can be transmitted and reconstructed later: | **pipe-delimited**: pipe-separated values. Object color={"R":100,"G":200} -> color=R|100|G|200. | **form**: ampersand-separated values. Object color={"R":100,"G":200} -> color=R,100,G,200 if *explodeObjectSerialization* set to **false** or -> R=100&G=200 if *explodeObjectSerialization* set to **true**. | **space-delimited**: space-separated values. Object color={"R":100,"G":200} -> color=R 100 G 200. | **deep-object**: rendering nested objects. Object color={"R":100,"G":200} -> color[R]=100&color[G]=200. | **matrix**: semicolon-prefixed values. Object color={"R":100,"G":200} -> ;color=R,100,G,200 if *explodeObjectSerialization* set to **false** or -> ;R=100;G=200 if *explodeObjectSerialization* set to **true**. | **simple**: comma-separated values. Object color={"R":100,"G":200} -> R,100,G,200 if *explodeObjectSerialization* set to **false** or -> R=100,G=200 if *explodeObjectSerialization* set to **true**. | **label**: dot-prefixed values. Object color={"R":100,"G":200} -> .R.100.G.200 if *explodeObjectSerialization* set to **false** or -> .R=100.G=200 if *explodeObjectSerialization* set to **true**. **Notes**: | This attribute is relevant only for parameters with **object** or **openapi-array** *valueType*. | **form** serialization can be defined for a parameter with *query*, *form-data* or *cookie* locations only. | **matrix** and **label** serializations can be defined for an array parameter with *path* location only. | **simple** serializations can be defined for a parameter with *path* and *header* locations only. | **deep-object** serialization can be defined for a parameter with *query* or *form-data* locations only. |
| `parameterEnumValues` | array of strings | Determines the set of possible parameter's values. This attribute is not relevant for parameters with **phone**, **email** or **binary** *dataType*. |
| `parameterLocation` | string | Specifies location of parameter in request: | **any**: in query string, in POST data (body) or in URL path. | **query**: in query string. | **form-data**: in POST data (body). | **cookie**: in value of Cookie header. | **path**: in URL path. | **header**: in request headers. **Notes**: | **path** location can be defined for parameter with **global** *level* only. | **path**, **header** and **cookie** location can be defined for parameter with **explicit** *type* only. | **header** and **cookie** location cannot be defined for parameter with empty *name*. |
| `regularExpression` | string | Determines a positive regular expression (PCRE) for a parameter's value. This attribute is relevant only if *enableRegularExpression* is set to **true**. **Notes**: | The length of a regular expression is limited to 254 characters. |
| `sensitiveParameter` | boolean | Determines whether a parameter is sensitive and must be not visible in logs nor in the user interface. Instead of the actual value, a string of asterisks is shown for this parameter. Use it to protect sensitive user input, such as a password or a credit card number, in a validated request. |
| [signatureOverrides](#policy-parameters-signatureOverrides) | array of objects | Determines attack signatures whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request for this parameter that matches these attack signatures. This attribute is relevant only if *signatureOverrides* is set to **true**. |
| `staticValues` | array of strings | Determines the set of possible parameter's values. This attribute is relevant for parameters with **static-content** *valueType* only. |
| `type` | string | Specifies the type of the *name* attribute. |
| [url](#policy-urls) | object |  |
| [valueMetacharOverrides](#policy-parameters-valueMetacharOverrides) | array of objects | Determines metacharacters whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request parameter that has these metacharacters in its value. This attribute is relevant only if *metacharsOnParameterValueCheck* is set to **true**. |
| `valueType` | string | Specifies type of parameter's value: | **object**: the parameter's value is complex object defined by JSON schema. | **dynamic-content**: the parameter's content changes dynamically. | **openapi-array**: the parameter's value is complex array defined by JSON schema. | **ignore**: the system does not perform validity checks on the value of the parameter. | **static-content**: the parameter has a static, or pre-defined, value(s). | **json**: the parameter's value is JSON data. | **array**: the parameter's value is array of primitives. | **user-input**: the parameter's value is provided by user-input. | **xml**: the parameter's value is XML data. | **auto-detect**: the parameter's value can be user-input, XML data or JSON data. The system automatically classifies the type of value. | **dynamic-parameter-name**: the parameter's name changes dynamically. **Notes**: | **dynamic-parameter-name** value type can be defined for a parameter with **flow** *level* and **explicit** *type* only. | **dynamic-content** value type can be defined for a parameter with **explicit** *type* only. |
| `wildcardOrder` | integer | Specifies the order in which wildcard entities are organized. Matching of an enforced parameter with a defined wildcard parameter happens based on order from smaller to larger. |  |


<a id="policy/parameters/contentProfile"></a>


##### contentProfile



| Field Name | Type | Description |
|---|---|---|
| [contentProfile](#policy-parameters-contentProfile-contentProfile) | object |  |  |


<a id="policy/parameters/contentProfile/contentProfile"></a>


##### contentProfile



| Field Name | Type | Description |
|---|---|---|
| `name` | string |  |  |


<a id="policy/parameters/nameMetacharOverrides"></a>


##### nameMetacharOverrides



| Field Name | Type | Description |
|---|---|---|
| `isAllowed` | boolean | Specifies permission of *metachar* - when *false*, then character is prohibited. |
| `metachar` | string | Specifies character in hexadecimal format with special allowance. |  |


<a id="policy/parameters/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean | Specifies, when true, that the overridden signature is enforced |
| `name` | string | The signature name which, along with the signature tag, identifies the signature. |
| `signatureId` | integer | The signature ID which identifies the signature. |
| `tag` | string | The signature tag which, along with the signature name, identifies the signature. |  |


<a id="policy/parameters/valueMetacharOverrides"></a>


##### valueMetacharOverrides



| Field Name | Type | Description |
|---|---|---|
| `isAllowed` | boolean | Specifies permission of *metachar* - when *false*, then character is prohibited. |
| `metachar` | string | Specifies character in hexadecimal format with special allowance. |  |


---


<a id="policy/response-pages"></a>


### response-pages



| Field Name | Type | Description |
|---|---|---|
| `ajaxActionType` | string | Which content, or URL, the system sends to the client as a response to an AJAX request that does not comply with the security policy. | **alert-popup**: The system opens a message as a popup screen. Type the message the system displays in the popup screen, or leave the default text. | **custom**: A response text that will replace the frame or page which generated the AJAX request. The system provides additional options where you can type the response body you prefer. | **redirect**: The system redirects the user to a specific web page instead of viewing a response page. Type the web page's full URL path, for example, http://www.redirectpage.com. |
| `ajaxCustomContent` | string | Custom message typed by user as a response for blocked AJAX request. |
| `ajaxEnabled` | boolean | When enabled, the system injects JavaScript code into responses. You must enable this toggle in order to configure an Application Security Manager AJAX response page which is returned when the system detects an AJAX request that does not comply with the security policy. |
| `ajaxPopupMessage` | string | Default message provided by the system as a response for blocked AJAX request. Can be manipulated by user, but <%TS.request.ID()%> must be included in this message. |
| `ajaxRedirectUrl` | string | The system redirects the user to a specific web page instead of viewing a response page. Type the web page's full URL path, for example, http://www.redirectpage.com. To redirect the blocking page to a URL with a support ID in the query string, type the URL and the support ID in the following format: http://www.example.com/blocking_page.php?support_id=<%TS.request.ID()%>. The system replaces <%TS.request.ID%> with the relevant support ID so that the blocked request is redirected to the URL with the relevant support ID. |
| `grpcStatusCode` | <br>• integer<br>• string |  |
| `grpcStatusMessage` | string |  |
| `responseActionType` | string | Which action the system takes, and which content the system sends to the client, as a response when the security policy blocks the client request. | **custom**: The system returns a response page with HTML code that the user defines. | **default**: The system returns the system-supplied response page in HTML. No further configuration is needed. | **erase-cookies**:  The system deletes all client side domain cookies. This is done in order to block web application users once, and not from the entire web application. The system displays this text in the response page. You cannot edit this text. | **redirect**: The system redirects the user to a specific web page instead of viewing a response page. The system provides an additional setting where you can indicate the redirect web page. | **soap-fault**:  Displays the system-supplied response written in SOAP fault message structure. Use this type when a SOAP request is blocked due to an XML related violation. You cannot edit this text. |
| `responseContent` | string | The content the system sends to the client in response to an illegal blocked request. |
| `responseHeader` | string | The response headers that the system sends to the client as a response to an illegal blocked request. |
| `responsePageType` | string | The different types of blocking response pages which are available from the system: | **ajax**: The system sends the AJAX Blocking Response Page when the security policy blocks an AJAX request that does not comply with the security policy. | **default**: The system sends the default response when the security policy blocks a client request. | **graphql**: The system sends the GraphQL response when the security policy blocks a client request that contains GraphQL message that does not comply with the settings of a GraphQL profile configured in the security policy. | **grpc**: The system sends the gRPC response when the security policy blocks a client request that contains gRPC message that does not comply with the settings of a gRPC profile configured in the security policy. | **xml**: The system sends the XML response page when the security policy blocks a client request that contains XML content that does not comply with the settings of an XML profile configured in the security policy. |
| `responseRedirectUrl` | string | The particular URL to which the system redirects the user. To redirect the blocking page to a URL with a support ID in the query string, type the URL and the support ID in the following format: http://www.example.com/blocking_page.php?support_id=<%TS.request.ID()%>. The system replaces <%TS.request.ID%> with the relevant support ID so that the blocked request is redirected to the URL with the relevant support ID. |  |


---


<a id="policy/sensitive-parameters"></a>


### sensitive-parameters



| Field Name | Type | Description |
|---|---|---|
| `name` | string | Name of a parameter whose values the system should consider sensitive. |  |


---


<a id="policy/server-technologies"></a>


### server-technologies



| Field Name | Type | Description |
|---|---|---|
| `serverTechnologyName` | string | Specifies the name of the selected policy. For example, PHP will add attack signatures that cover known PHP vulnerabilities. |  |


---


<a id="policy/signature-requirements"></a>


### signature-requirements



| Field Name | Type | Description |
|---|---|---|
| `maxRevisionDatetime` | string |  |
| `minRevisionDatetime` | string |  |
| `tag` | string |  |  |


---


<a id="policy/signature-sets"></a>


### signature-sets



| Field Name | Type | Description |
|---|---|---|
| `alarm` | boolean | If enabled - when a signature from this signature set is detected in a request - the request is logged. |
| `block` | boolean | If enabled - when a signature from this signature set is detected in a request - the request is blocked. |
| `learn` | boolean | If enabled - when a signature from this signature set is detected in a request -the policy builder creates a learning suggestion to disable it. |
| `name` | string | Signature set name. |
| [signatureSet](#policy-signature-sets-signatureSet) | object | Defines signature set. |
| `stagingCertificationDatetime` | string |  | * |


<a id="policy/signature-sets/signatureSet"></a>


##### signatureSet



| Field Name | Type | Description |
|---|---|---|
| [filter](#policy-signature-sets-signatureSet-filter) | object | Specifies filter that defines signature set. |
| [signatures](#policy-signature-sets-signatureSet-signatures) | array of objects |  |
| [systems](#policy-signature-sets-signatureSet-systems) | array of objects |  |
| `type` | string |  | * filter-based<br>• manual |


<a id="policy/signature-sets/signatureSet/filter"></a>


##### filter



| Field Name | Type | Description |
|---|---|---|
| `accuracyFilter` | string |  |
| `accuracyValue` | string |  |
| [attackType](#policy-signature-sets-signatureSet-filter-attackType) | object |  |
| `hasCve` | string |  |
| `lastUpdatedFilter` | string |  |
| `lastUpdatedValue` | string |  |
| `riskFilter` | string |  |
| `riskValue` | string |  |
| `signatureType` | string |  |
| `tagFilter` | string | Filter by signature tagValue. | **all**: no filter applied. | **eq**: only signatures with a tag that equals tagValue are added to the signature set. | **untagged**: only signatures without a tag are added to the signature set. |
| `tagValue` | string | Value for the tagFilter. Relevant only for the **eq** value of tagFilter. |
| `userDefinedFilter` | string |  | * all<br>• no<br>• yes |


<a id="policy/signature-sets/signatureSet/filter/attackType"></a>


##### attackType



| Field Name | Type | Description |
|---|---|---|
| `name` | string |  |  |


<a id="policy/signature-sets/signatureSet/signatures"></a>


##### signatures



| Field Name | Type | Description |
|---|---|---|
| `name` | string |  |
| `signatureId` | integer |  |
| `tag` | string |  |  |


<a id="policy/signature-sets/signatureSet/systems"></a>


##### systems



| Field Name | Type | Description |
|---|---|---|
| `name` | string |  |  |


---


<a id="policy/signature-settings"></a>


### signature-settings



| Field Name | Type | Description |
|---|---|---|
| `minimumAccuracyForAutoAddedSignatures` | string |  |
| `signatureStaging` | boolean |  |
| `stagingCertificationDatetime` | string |  | * |


---


<a id="policy/signatures"></a>


### signatures



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean | Specifies, if true, that the signature is enabled on the security policy. When false, the signature is disable on the security policy. |
| `learn` | boolean |  |
| `name` | string | The signature name which, along with the signature tag, identifies the signature. |
| `performStaging` | boolean | Specifies, if true, that the signature is in staging. The system does not enforce signatures in staging. Instead, the system records the request information and keeps it for a period of time (the Enforcement Readiness Period whose default time period is 7 days). Specifies, when false, that the staging feature is not in use, and that the system enforces the signatures' Learn/Alarm/Block settings immediately. (Blocking is performed only if the security policy's enforcement mode is Blocking.) |
| `signatureId` | integer | The signature ID which identifies the signature. |
| `tag` | string | The signature tag which, along with the signature name, identifies the signature. |  |


---


<a id="policy/threat-campaigns"></a>


### threat-campaigns



| Field Name | Type | Description |
|---|---|---|
| `displayName` | string |  |
| `isEnabled` | boolean | If enabled - threat campaign is enforced in the security policy. |
| `name` | string | Name of the threat campaign. |  |


---


<a id="policy/urls"></a>


### urls



| Field Name | Type | Description |
|---|---|---|
| [accessProfile](#policy-access-profiles) | object |  |
| `allowRenderingInFrames` | string | Specifies the conditions for when the browser should allow this URL to be rendered in a frame or iframe. never: Specifies that this URL must never be rendered in a frame or iframe. The web application instructs browsers to hide, or disable, frame and iframe parts of this URL. only-same: Specifies that the browser may load the frame or iframe if the referring page is from the same protocol, port, and domain as this URL. This limits the user to navigate only within the same web application. |
| `allowRenderingInFramesOnlyFrom` | string | Specifies that the browser may load the frame or iframe from a specified domain. Type the protocol and domain in URL format for example, http://www.mywebsite.com. Do not enter a sub-URL, such as http://www.mywebsite.com/index. |
| `attackSignaturesCheck` | boolean | Specifies, when true, that you want attack signatures and threat campaigns to be detected on this URL and possibly override the security policy settings of an attack signature or threat campaign specifically for this URL. After you enable this setting, the system displays a list of attack signatures and threat campaigns. |
| [authorizationRules](#policy-urls-authorizationRules) | array of objects |  |
| `canChangeDomainCookie` | boolean |  |
| `clickjackingProtection` | boolean | Specifies that the system adds the X-Frame-Options header to the domain URL's response header. This is done to protect the web application against clickjacking. Clickjacking occurs when an attacker lures a user to click illegitimate frames and iframes because the attacker hid them on legitimate visible website buttons. Therefore, enabling this option protects the web application from other web sites hiding malicious code behind them. The default is disabled. After you enable this option, you can select whether, and under what conditions, the browser should allow this URL to be rendered in a frame or iframe. |
| `disallowFileUploadOfExecutables` | boolean |  |
| [html5CrossOriginRequestsEnforcement](#policy-urls-html5CrossOriginRequestsEnforcement) | object | The system extracts the Origin (domain) of the request from the Origin header. |
| `isAllowed` | boolean | If *true*, the URLs allowed by the security policy. |
| `mandatoryBody` | boolean | A request body is mandatory. This is relevant for any method acting as POST. |
| [metacharOverrides](#policy-urls-metacharOverrides) | array of objects | To allow or disallow specific meta characters in the name of this specific URL (and thus override the global meta character settings). |
| `metacharsOnUrlCheck` | boolean | Specifies, when true, that you want meta characters to be detected on this URL and possibly override the security policy settings of a meta character specifically for this URL. After you enable this setting, the system displays a list of meta characters. |
| `method` | string | Unique ID of a URL with a protocol type and name. Select a Method for the URL to create an API endpoint: URL + Method. |
| [methodOverrides](#policy-urls-methodOverrides) | array of objects | Specifies a list of methods that are allowed or disallowed for a specific URL. The list overrides the list of methods allowed or disallowed globally at the policy level. |
| `methodsOverrideOnUrlCheck` | boolean | Specifies, when true, that you want methods to be detected on this URL and possibly override the security policy settings of a method specifically for this URL. After you enable this setting, the system displays a list of methods. |
| `name` | string | Specifies an HTTP URL that the security policy allows. The available types are: | **Explicit**: Specifies that the URL has a specific name and is not a wildcard entity. Type the name of a URL exactly as you expect it to appear in the request. | **Wildcard**: Specifies that any URL that matches the listed wildcard expression should be treated according to the wildcard attributes. Type a wildcard expression that matches the expected URL. For example, entering the wildcard expression * specifies that any URL is allowed by the security policy. The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects. | **\***: Matches all characters | **?**: Matches any single character | **[abcde]**: Matches exactly one of the characters listed | **[!abcde]**: Matches any character not listed | **[a-e]**: Matches exactly one character in the range | **[!a-e]**: Matches any character not in the range **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard. |
| `operationId` | string | The attribute operationId is used as an OpenAPI endpoint identifier. |
| [positionalParameters](#policy-urls-positionalParameters) | array of objects | When checked (enabled), positional parameters are enabled in the URL. |
| `protocol` | string | Specifies whether the protocol for the URL is HTTP or HTTPS. |
| [signatureOverrides](#policy-urls-signatureOverrides) | array of objects | Array of signature overrides. Specifies attack signatures whose security policy settings are overridden for this URL, and which action the security policy takes when it discovers a request for this URL that matches these attack signatures. |
| `type` | string | Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such. |
| [urlContentProfiles](#policy-urls-urlContentProfiles) | array of objects | Specifies how the system recognizes and enforces requests for this URL according to the requests' header content. The system automatically creates a default header-based content profile for HTTP, and you cannot delete it. However, requests for a URL may contain other types of content, such as JSON, XML, or other proprietary formats. |
| `wildcardOrder` | integer | Specifies the order index for wildcard URLs matching. Wildcard URLs with lower wildcard order will get checked for a match prior to URLs with higher wildcard order. |  |


<a id="policy/urls/authorizationRules"></a>


##### authorizationRules



| Field Name | Type | Description |
|---|---|---|
| `condition` | string |  |
| `name` | string |  |  |


<a id="policy/urls/html5CrossOriginRequestsEnforcement"></a>


##### html5CrossOriginRequestsEnforcement



| Field Name | Type | Description |
|---|---|---|
| `allowOriginsEnforcementMode` | string | Allows you to specify a list of origins allowed to share data returned by this URL. |
| `checkAllowedMethods` | boolean | Allows you to specify a list of methods that other web applications hosted in different domains can use when requesting this URL. |
| [crossDomainAllowedOrigin](#policy-urls-html5CrossOriginRequestsEnforcement-crossDomainAllowedOrigin) | array of objects | Allows you to specify a list of origins allowed to share data returned by this URL. |
| `enforcementMode` | string | Specify the option to determine how to handle CORS requests. disabled: Do nothing related to cross-domain requests. Pass CORS requests exactly as set by the server. enforce: Allow cross-origin resource sharing as configured in the crossDomainAllowedOrigin setting. CORS requests are allowed from the domains specified as allowed origins. | * disabled<br>• enforce |


<a id="policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin"></a>


##### crossDomainAllowedOrigin



| Field Name | Type | Description |
|---|---|---|
| `includeSubDomains` | boolean | If *true*, sub-domains of the allowed origin are also allowed to receive data from your web application. |
| `originName` | string | Type the domain name or IP address with which the URL can share data. Wildcards are allowed in the names. For example: *.f5.com will match b.f5.com; however it will not match a.b.f5.com. |
| `originPort` | <br>• integer minimum: 0 maximum: 65535<br>• string | Select the port that other web applications can use to request data from your web application, or use the * wildcard for all ports. |
| `originProtocol` | string | Select the appropriate protocol for the allowed origin. | * http<br>• http/https<br>• https |


<a id="policy/urls/metacharOverrides"></a>


##### metacharOverrides



| Field Name | Type | Description |
|---|---|---|
| `isAllowed` | boolean | If *true*, metacharacters and other characters are allowed in a URL. |
| `metachar` | string | ASCII representation of the character in Hex format |  |


<a id="policy/urls/methodOverrides"></a>


##### methodOverrides



| Field Name | Type | Description |
|---|---|---|
| `allowed` | boolean | Specifies that the system allows you to override allowed methods for this URL. When selected, the global policy settings for methods are listed, and you can change what is allowed or disallowed for this URL. |
| `method` | string | Specifies a list of existing HTTP methods. All security policies accept standard HTTP methods by default. | * ACL<br>• BCOPY<br>• BDELETE<br>• BMOVE<br>• BPROPFIND<br>• BPROPPATCH<br>• CHECKIN<br>• CHECKOUT<br>• CONNECT<br>• COPY<br>• DELETE<br>• GET<br>• HEAD<br>• LINK<br>• LOCK<br>• MERGE<br>• MKCOL<br>• MKWORKSPACE<br>• MOVE<br>• NOTIFY<br>• OPTIONS<br>• PATCH<br>• POLL<br>• POST<br>• PROPFIND<br>• PROPPATCH<br>• PUT<br>• REPORT<br>• RPC_IN_DATA<br>• RPC_OUT_DATA<br>• SEARCH<br>• SUBSCRIBE<br>• TRACE<br>• TRACK<br>• UNLINK<br>• UNLOCK<br>• UNSUBSCRIBE<br>• VERSION_CONTROL<br>• X-MS-ENUMATTS |


<a id="policy/urls/positionalParameters"></a>


##### positionalParameters



| Field Name | Type | Description |
|---|---|---|
| [parameter](#policy-parameters) | object |  |
| `urlSegmentIndex` | integer minimum: 1 | Select which to add: Text or Parameter and enter your desired segments. You can add multiple text and parameter segments. |  |


<a id="policy/urls/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean | Specifies, when true, that the overridden signature is enforced |
| `name` | string | The signature name which, along with the signature tag, identifies the signature. |
| `signatureId` | integer | The signature ID which identifies the signature. |
| `tag` | string | The signature tag which, along with the signature name, identifies the signature. |  |


<a id="policy/urls/urlContentProfiles"></a>


##### urlContentProfiles



| Field Name | Type | Description |
|---|---|---|
| [contentProfile](#policy-urls-urlContentProfiles-contentProfile) | object |  |
| `decodeValueAsBase64` | string |  |
| `headerName` | string | Specifies an explicit header name that must appear in requests for this URL. This field is not case-sensitive. |
| `headerOrder` | <br>• integer<br>• string | Displays the order in which the system checks header content of requests for this URL. |
| `headerValue` | string | Specifies a simple pattern string (glob pattern matching) for the header value that must appear in legal requests for this URL; for example, *json*, xml_method?, or method[0-9]. If the header includes this pattern, the system assumes the request contains the type of data you select in the Request Body Handling setting. This field is case-sensitive. |
| `type` | string | - **Apply Content Signatures**: Do not parse the content; scan the entire payload with full-content attack signatures. | **Apply Value and Content Signatures**: Do not parse the content or extract parameters; process the entire payload with value and full-content attack signatures. | **Disallow**: Block requests for an URL containing this header content. Log the Illegal Request Content Type violation. | **Do Nothing**: Do not inspect or parse the content. Handle the header of the request as specified by the security policy. | **Form Data**: Parse content as posted form data in either URL-encoded or multi-part formats. Enforce the form parameters according to the policy. | **GWT**: Perform checks for data in requests, based on the configuration of the GWT (Google Web Toolkit) profile associated with this URL. | **JSON**: Review JSON data using an associated JSON profile, and use value attack signatures to scan the element values. | **XML**: Review XML data using an associated XML profile. | * apply-content-signatures<br>• apply-value-and-content-signatures<br>• disallow<br>• do-nothing<br>• form-data<br>• graphql<br>• grpc<br>• json<br>• xml |


<a id="policy/urls/urlContentProfiles/contentProfile"></a>


##### contentProfile



| Field Name | Type | Description |
|---|---|---|
| `name` | string |  |  |


---


<a id="policy/urls"></a>


### urls



| Field Name | Type | Description |
|---|---|---|
| [parameters](#policy-urls-parameters) | array of objects |  |  |


---


<a id="policy/xml-profiles"></a>


### xml-profiles



| Field Name | Type | Description |
|---|---|---|
| `attackSignaturesCheck` | boolean |  |
| [defenseAttributes](#policy-xml-profiles-defenseAttributes) | object |  |
| `description` | string |  |
| `metacharAttributeCheck` | boolean |  |
| `metacharElementCheck` | boolean |  |
| [metacharOverrides](#policy-xml-profiles-metacharOverrides) | array of objects |  |
| `name` | string |  |
| [signatureOverrides](#policy-xml-profiles-signatureOverrides) | array of objects |  |
| `useXmlResponsePage` | boolean |  |  |


<a id="policy/xml-profiles/defenseAttributes"></a>


##### defenseAttributes



| Field Name | Type | Description |
|---|---|---|
| `allowCDATA` | boolean |  |
| `allowDTDs` | boolean |  |
| `allowExternalReferences` | boolean |  |
| `allowProcessingInstructions` | boolean |  |
| `maximumAttributeValueLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumAttributesPerElement` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumChildrenPerElement` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumDocumentDepth` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumDocumentSize` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumElements` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumNSDeclarations` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumNameLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `maximumNamespaceLength` | <br>• integer minimum: 0 maximum: 2147483647<br>• string |  |
| `tolerateCloseTagShorthand` | boolean |  |
| `tolerateLeadingWhiteSpace` | boolean |  |
| `tolerateNumericNames` | boolean |  |  |


<a id="policy/xml-profiles/metacharOverrides"></a>


##### metacharOverrides



| Field Name | Type | Description |
|---|---|---|
| `isAllowed` | boolean |  |
| `metachar` | string |  |  |


<a id="policy/xml-profiles/signatureOverrides"></a>


##### signatureOverrides



| Field Name | Type | Description |
|---|---|---|
| `enabled` | boolean |  |
| `name` | string |  |
| `signatureId` | integer |  |
| `tag` | string |  |  |


---


<a id="policy/blocking-settings_evasions"></a>


### evasions



| Field Name | Type | Description |
|---|---|---|
| `description` | string | Human-readable name of sub-violation. |
| `enabled` | boolean | Defines if sub-violation is enforced - alarmed or blocked, according to the 'Evasion technique detected' (VIOL_EVASION) violation blocking settings. |
| `learn` | boolean | Defines if sub-violation is learned. Sub-violations are learned only when learn is enabled for the 'Evasion technique detected' (VIOL_EVASION) violation. |
| `maxDecodingPasses` | integer minimum: 2 maximum: 5 | Defines how many times the system decodes URI and parameter values before the request is considered an evasion. Relevant only for the 'Multiple decoding' sub-violation. |  |


---


<a id="policy/blocking-settings_http-protocols"></a>


### http-protocols



| Field Name | Type | Description |
|---|---|---|
| `description` | string | Human-readable name of sub-violation |
| `enabled` | boolean | Defines if sub-violation is enforced - alarmed or blocked, according to the 'HTTP protocol compliance failed' (VIOL_HTTP_PROTOCOL) violation blocking settings |
| `learn` | boolean | Defines if sub-violation is learned. Sub-violations is learned only when learn is enabled for the 'HTTP protocol compliance failed' (VIOL_HTTP_PROTOCOL) violation |
| `maxCookies` | integer minimum: 1 maximum: 100 |  |
| `maxHeaders` | integer minimum: 1 maximum: 150 | Defines maximum allowed number of headers in request. Relevant only for the 'Check maximum number of headers' sub-violation |
| `maxParams` | integer minimum: 1 maximum: 5000 | Defines maximum allowed number of parameters in request. Relevant only for the 'Check maximum number of parameters' sub-violation |  |


---


<a id="policy/blocking-settings_violations"></a>


### violations



| Field Name | Type | Description |
|---|---|---|
| `alarm` | boolean |  |
| `block` | boolean |  |
| `description` | string |  |
| `learn` | boolean |  |
| `name` | string |  | * VIOL_ACCESS_UNAUTHORIZED<br>• VIOL_ACCESS_INVALID<br>• VIOL_ACCESS_MALFORMED<br>• VIOL_ACCESS_MISSING<br>• VIOL_ASM_COOKIE_MODIFIED<br>• VIOL_BLACKLISTED_IP<br>• VIOL_BOT_CLIENT<br>• VIOL_BRUTE_FORCE<br>• VIOL_COOKIE_EXPIRED<br>• VIOL_COOKIE_LENGTH<br>• VIOL_COOKIE_MALFORMED<br>• VIOL_COOKIE_MODIFIED<br>• VIOL_CSRF<br>• VIOL_DATA_GUARD<br>• VIOL_ENCODING<br>• VIOL_EVASION<br>• VIOL_FILETYPE<br>• VIOL_FILE_UPLOAD<br>• VIOL_FILE_UPLOAD_IN_BODY<br>• VIOL_GRAPHQL_MALFORMED<br>• VIOL_GRAPHQL_FORMAT<br>• VIOL_GRAPHQL_INTROSPECTION_QUERY<br>• VIOL_GRAPHQL_ERROR_RESPONSE<br>• VIOL_GRPC_FORMAT<br>• VIOL_GRPC_MALFORMED<br>• VIOL_GRPC_METHOD<br>• VIOL_HEADER_LENGTH<br>• VIOL_HEADER_METACHAR<br>• VIOL_HEADER_REPEATED<br>• VIOL_HTTP_PROTOCOL<br>• VIOL_HTTP_RESPONSE_STATUS<br>• VIOL_JSON_FORMAT<br>• VIOL_JSON_MALFORMED<br>• VIOL_JSON_SCHEMA<br>• VIOL_LOGIN<br>• VIOL_LOGIN_URL_BYPASSED<br>• VIOL_LOGIN_URL_EXPIRED<br>• VIOL_MANDATORY_HEADER<br>• VIOL_MANDATORY_PARAMETER<br>• VIOL_MANDATORY_REQUEST_BODY<br>• VIOL_METHOD<br>• VIOL_PARAMETER<br>• VIOL_PARAMETER_ARRAY_VALUE<br>• VIOL_PARAMETER_DATA_TYPE<br>• VIOL_PARAMETER_EMPTY_VALUE<br>• VIOL_PARAMETER_LOCATION<br>• VIOL_PARAMETER_MULTIPART_NULL_VALUE<br>• VIOL_PARAMETER_NAME_METACHAR<br>• VIOL_PARAMETER_NUMERIC_VALUE<br>• VIOL_PARAMETER_REPEATED<br>• VIOL_PARAMETER_STATIC_VALUE<br>• VIOL_PARAMETER_VALUE_BASE64<br>• VIOL_PARAMETER_VALUE_LENGTH<br>• VIOL_PARAMETER_VALUE_METACHAR<br>• VIOL_PARAMETER_VALUE_REGEXP<br>• VIOL_POST_DATA_LENGTH<br>• VIOL_QUERY_STRING_LENGTH<br>• VIOL_RATING_THREAT<br>• VIOL_RATING_NEED_EXAMINATION<br>• VIOL_REQUEST_MAX_LENGTH<br>• VIOL_REQUEST_LENGTH<br>• VIOL_THREAT_CAMPAIGN<br>• VIOL_URL<br>• VIOL_URL_CONTENT_TYPE<br>• VIOL_URL_LENGTH<br>• VIOL_URL_METACHAR<br>• VIOL_XML_FORMAT<br>• VIOL_XML_MALFORMED<br>• VIOL_GEOLOCATION<br>• VIOL_WEBSOCKET_BAD_REQUEST<br>• VIOL_MALICIOUS_IP |


---


<a id="policy/bot-defense_mitigations"></a>


### mitigations



| Field Name | Type | Description |
|---|---|---|
| [anomalies](#policy-bot-defense-mitigations-anomalies) | array of objects |  |
| [browsers](#policy-bot-defense-mitigations-browsers) | array of objects |  |
| [classes](#policy-bot-defense-mitigations-classes) | array of objects | List of classes and their actions. |
| [signatures](#policy-bot-defense-mitigations-signatures) | array of objects | List of signatures and their actions. If a signature is not in the list - its action will be taken according to the class it belongs to. |  |


---


<a id="policy/bot-defense_settings"></a>


### settings



| Field Name | Type | Description |
|---|---|---|
| `caseSensitiveHttpHeaders` | boolean | If *false* the system will not check header name with case sensitivity for both relevant anomalies: Invalid HTTP Headers, Suspicious HTTP Headers. |
| `isEnabled` | boolean | If *true* the system detects bots. |  |


---


<a id="policy/bot-defense/mitigations_anomalies"></a>


### anomalies



| Field Name | Type | Description |
|---|---|---|
| `action` | string |  |
| `name` | string |  |
| `scoreThreshold` | <br>• integer minimum: 0 maximum: 150<br>• string |  | * Integer values<br>• "default" |


---


<a id="policy/bot-defense/mitigations_browsers"></a>


### browsers



| Field Name | Type | Description |
|---|---|---|
| `action` | string |  |
| `maxVersion` | integer minimum: 0 maximum: 2147483647 |  |
| `minVersion` | integer minimum: 0 maximum: 2147483647 |  |
| `name` | string |  |  |


---


<a id="policy/bot-defense/mitigations_classes"></a>


### classes



| Field Name | Type | Description |
|---|---|---|
| `action` | string | The action we set for this class. | **ignore**: The system will not detect or report bots from this class. | **detect**: The system will detect and report the bot, but violation won't be reported. | **alarm**: The system will detect and report requests made by bots from this class as illegal, but will not block them. | **block**: The system will detect and report requests made by bots from this class as illegal, and block them. |
| `name` | string | The class we set the action to. | * browser<br>• malicious-bot<br>• suspicious-browser<br>• trusted-bot<br>• unknown<br>• untrusted-bot |


---


<a id="policy/bot-defense/mitigations_signatures"></a>


### signatures



| Field Name | Type | Description |
|---|---|---|
| `action` | string | The action we set for this signature. | **ignore**: The system will not detect or report this signature. | **detect**: The system will detect and report the signature, but violation won't be reported. | **alarm**: The system will detect and report requests made by those specific bots as illegal, but will not block them. | **block**: The system will detect and report requests made by those specific bots as illegal, and will block them. |
| `name` | string | The name of the signature we want to change action for. |  |
