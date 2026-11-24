<!-- Generated policy reference. Do not edit. -->

<span id="policy"></span>

## Policy settings

`access-profiles`

* **Type:** `array of objects`
* **External reference:** Yes (`accessProfileReference`)
* **Subfields:** [See fields](<#policy/access-profiles>)

---

<span id="policy/applicationLanguage"></span>

`applicationLanguage`

* **Type:** `string`
* **Default:** `utf-8`
* **Allowed Values:** `big5` | `euc-jp` | `euc-kr` | `gb18030` | `gb2312` | `gbk` | `iso-8859-1` | `iso-8859-10` | `iso-8859-13` | `iso-8859-15` | `iso-8859-16` | `iso-8859-2` | `iso-8859-3` | `iso-8859-4` | `iso-8859-5` | `iso-8859-6` | `iso-8859-7` | `iso-8859-8` | `iso-8859-9` | `koi8-r` | `shift_jis` | `utf-8` | `windows-1250` | `windows-1251` | `windows-1252` | `windows-1253` | `windows-1255` | `windows-1256` | `windows-1257` | `windows-874`
* **Description:** The character encoding for the application. The character encoding determines how the policy processes the character sets. The default is utf-8.
* **External reference:** No

---

`blocking-settings`

* **Type:** `object`
* **Description:** This section defines policy block/alarm behaviors.
* **External reference:** Yes (`blockingSettingsReference`)
* **Subfields:** [See fields](<#policy/blocking-settings>)

---

`bot-defense`

* **Type:** `object`
* **Description:** This section defines the properties of the bot defense feature.
* **External reference:** Yes (`botDefenseReference`)
* **Subfields:** [See fields](<#policy/bot-defense>)

---

`browser-definitions`

* **Type:** `array of objects`
* **External reference:** Yes (`browserDefinitionReference`)
* **Subfields:** [See fields](<#policy/browser-definitions>)

---

`brute-force-attack-preventions`

* **Type:** `array of objects`
* **Description:** Defines configuration for Brute Force Protection feature.
  There is default configuration (one with bruteForceProtectionForAllLoginPages flag and without url) that applies to all configured login URLs unless there exists another brute force configuration for a specific login page.
* **External reference:** Yes (`bruteForceAttackPreventionReference`)
* **Subfields:** [See fields](<#policy/brute-force-attack-preventions>)

---

<span id="policy/caseInsensitive"></span>

`caseInsensitive`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies whether the security policy treats microservice URLs, file types, URLs, and parameters as case sensitive or not. When this setting is enabled, the system stores these security policy elements in lowercase in the security policy configuration.
* **External reference:** No

---

`character-sets`

* **Type:** `array of objects`
* **External reference:** Yes (`characterSetReference`)
* **Subfields:** [See fields](<#policy/character-sets>)

---

`cookie-settings`

* **Type:** `object`
* **Description:** The maximum length of a cookie header name and value that the system processes. The system calculates and enforces a cookie header length based on the sum of the length of the cookie header name and value.
* **External reference:** Yes (`cookieSettingsReference`)
* **Subfields:** [See fields](<#policy/cookie-settings>)

---

`cookies`

* **Type:** `array of objects`
* **Description:** This section defines Cookie entities for your policy.
  You can specify the cookies that you want to allow, and the ones you want to enforce in a security policy:

  - **Allowed cookies**: The system allows these cookies and clients can change them.
  - **Enforced cookies**: The system enforces the cookies in the list (not allowing clients to change them) and allows clients to change all others.
* **External reference:** Yes (`cookieReference`)
* **Subfields:** [See fields](<#policy/cookies>)

---

`csrf-protection`

* **Type:** `object`
* **External reference:** Yes (`csrfProtectionReference`)
* **Subfields:** [See fields](<#policy/csrf-protection>)

---

`csrf-urls`

* **Type:** `array of objects`
* **External reference:** Yes (`csrfUrlReference`)
* **Subfields:** [See fields](<#policy/csrf-urls>)

---

`data-guard`

* **Type:** `object`
* **Description:** Data Guard feature can prevent responses from exposing sensitive information by masking the data.
* **External reference:** Yes (`dataGuardReference`)
* **Subfields:** [See fields](<#policy/data-guard>)

---

<span id="policy/description"></span>

`description`

* **Type:** `string`
* **Description:** Specifies the description of the policy.
* **External reference:** No

---

`disallowed-geolocations`

* **Type:** `array of objects`
* **Description:** Specifies a list of countries that may not access the web application.
* **External reference:** Yes (`disallowedGeolocationReference`)
* **Subfields:** [See fields](<#policy/disallowed-geolocations>)

---

<span id="policy/enforcementMode"></span>

`enforcementMode`

* **Type:** `string`
* **Default:** `blocking`
* **Schema default:** `transparent`
* **Allowed Values:** `blocking` | `transparent`
* **Description:** How the system processes a request that triggers a security policy violation.
  - **Blocking:** When the enforcement mode is set to blocking, traffic is blocked if it causes a violation (configured for blocking).
  - **Transparent:** When the enforcement mode is set to transparent, traffic is not blocked even if a violation is triggered.
* **External reference:** No

---

`enforcer-settings`

* **Type:** `object`
* **Description:** This section contains all enforcer settings.
* **External reference:** Yes (`enforcerSettingsReference`)
* **Subfields:** [See fields](<#policy/enforcer-settings>)

---

`filetypes`

* **Type:** `array of objects`
* **Description:** File types are categorization of the URLs in the request by the extension appearing past the last dot at the end of the URL. For example, the file type of /index.php
  is &quot;php&quot;. Other well known file types are html, aspx, png, jpeg and many more. A special case is the &quot;empty&quot; file type called &quot;no-ext&quot; meaning, no extension in which the URL has no dot at its last segment as in /foo\_no\_dot

  File types usually imply the expected content type in the response. For example, html and php return HTML content, while jpeg, png and gif return images, each in its respective format. File types also imply the server technology deployed for rendering the page. For example, php (PHP), aspx (ASP) and many others.

  The security policy uses file types for several purposes:
  1. Ability to define which file types are allowed and which are disallowed. By including the pure wildcard &quot;\*&quot; file type and a list of disallowed file types you have a file type denylist.
  By having a list of explicit file type *without* the pure wildcard &quot;\*&quot; you have a file type allowlist.
  2. Each file type implies maximum *length restrictions* for the requests of that file type. The checked lengths are per the URL, Query String, total request length, and payload (POST data).
  3. Each file type determines whether to detect *response signatures* for requests of that file type. Typically, one would never check signatures for image file types.
* **External reference:** Yes (`filetypeReference`)
* **Subfields:** [See fields](<#policy/filetypes>)

---

<span id="policy/fullPath"></span>

`fullPath`

* **Type:** `string`
* **Description:** The full name of the policy including partition.
* **External reference:** No

---

`general`

* **Type:** `object`
* **Description:** This section includes several advanced policy configuration settings.
* **External reference:** Yes (`generalReference`)
* **Subfields:** [See fields](<#policy/general>)

---

`graphql-profiles`

* **Type:** `array of objects`
* **External reference:** Yes (`graphqlProfileReference`)
* **Subfields:** [See fields](<#policy/graphql-profiles>)

---

`grpc-profiles`

* **Type:** `array of objects`
* **External reference:** Yes (`grpcProfileReference`)
* **Subfields:** [See fields](<#policy/grpc-profiles>)

---

`header-settings`

* **Type:** `object`
* **Description:** The maximum length of an HTTP header name and value that the system processes. The system calculates and enforces the HTTP header length based on the sum of the length of the HTTP header name and value.
* **External reference:** Yes (`headerSettingsReference`)
* **Subfields:** [See fields](<#policy/header-settings>)

---

`headers`

* **Type:** `array of objects`
* **Description:** This section defines Header entities for your policy.
* **External reference:** Yes (`headerReference`)
* **Subfields:** [See fields](<#policy/headers>)

---

`host-names`

* **Type:** `array of objects`
* **External reference:** Yes (`hostNameReference`)
* **Subfields:** [See fields](<#policy/host-names>)

---

`idl-files`

* **Type:** `array of objects`
* **External reference:** Yes (`idlFileReference`)
* **Subfields:** [See fields](<#policy/idl-files>)

---

`ip-address-lists`

* **Type:** `array of objects`
* **Description:** An IP address list is a list of IP addresses that you want the system to treat in a specific way for a security policy.
* **External reference:** Yes (`ipAddressListReference`)
* **Subfields:** [See fields](<#policy/ip-address-lists>)

---

`ip-intelligence`

* **Type:** `object`
* **External reference:** Yes (`ipIntelligenceReference`)
* **Subfields:** [See fields](<#policy/ip-intelligence>)

---

`json-profiles`

* **Type:** `array of objects`
* **External reference:** Yes (`jsonProfileReference`)
* **Subfields:** [See fields](<#policy/json-profiles>)

---

`json-validation-files`

* **Type:** `array of objects`
* **External reference:** Yes (`jsonValidationFileReference`)
* **Subfields:** [See fields](<#policy/json-validation-files>)

---

`login-enforcement`

* **Type:** `object`
* **External reference:** Yes (`loginEnforcementReference`)
* **Subfields:** [See fields](<#policy/login-enforcement>)

---

`login-pages`

* **Type:** `array of objects`
* **Description:** A login page is a URL in a web application that requests must pass through to get to the authenticated URLs. Use login pages, for example, to prevent forceful browsing of restricted parts of the web application, by defining access permissions for users. Login pages also allow session tracking of user sessions.
* **External reference:** Yes (`loginPageReference`)
* **Subfields:** [See fields](<#policy/login-pages>)

---

`methods`

* **Type:** `array of objects`
* **External reference:** Yes (`methodReference`)
* **Subfields:** [See fields](<#policy/methods>)

---

<span id="policy/name"></span>

`name`

* **Type:** `string`
* **Description:** The unique user-given name of the policy. Policy names cannot contain spaces or special characters. Allowed characters are a-z, A-Z, 0-9, dot, dash (-), colon (:) and underscore (\_).
* **External reference:** No

---

`open-api-files`

* **Type:** `array of objects`
* **External reference:** Yes (`openApiFileReference`)
* **Subfields:** [See fields](<#policy/open-api-files>)

---

`override-rules`

* **Type:** `array of objects`
* **Description:** This section defines policy override rules.
* **External reference:** Yes (`overrideRuleReference`)
* **Subfields:** [See fields](<#policy/override-rules>)

---

`parameters`

* **Type:** `array of objects`
* **Description:** This section defines parameters that the security policy permits in requests.
* **External reference:** Yes (`parameterReference`)
* **Subfields:** [See fields](<#policy/parameters>)

---

<span id="policy/performStaging"></span>

`performStaging`

* **Type:** `boolean`
* **Default:** `false`
* **Schema default:** `true`
* **Description:** Determines staging handling for all applicable entities in the policy, such as signatures, URLs, parameters, and cookies. If disabled, all entities will be enforced and any violations triggered will be considered illegal.
* **External reference:** No

---

`response-pages`

* **Type:** `array of objects`
* **Description:** The Security Policy has a default blocking response page that it returns to the client when the client request, or the web server response, is blocked by the security policy. You can change the way the system responds to blocked requests. All default response pages contain a variable, &lt;%TS.request.ID()%&gt;, that the system replaces with a support ID number when it issues the page.
* **External reference:** Yes (`responsePageReference`)
* **Subfields:** [See fields](<#policy/response-pages>)

---

`sensitive-parameters`

* **Type:** `array of objects`
* **Description:** This section defines sensitive parameters.
  The contents of these parameters are not visible in logs nor in the user interfaces.
  Instead of actual values a string of asterisks is shown for these parameters.
  Use these parameters to protect sensitive user input, such as a password or a credit card number, in a validated request.
  A parameter name of &quot;password&quot; is always defined as sensitive by default.
* **External reference:** Yes (`sensitiveParameterReference`)
* **Subfields:** [See fields](<#policy/sensitive-parameters>)

---

`server-technologies`

* **Type:** `array of objects`
* **Description:** The server technology is a server-side application, framework, web server or operating system type that is configured in the policy in order to adapt the policy to the checks needed for the respective technology.
* **External reference:** Yes (`serverTechnologyReference`)
* **Subfields:** [See fields](<#policy/server-technologies>)

---

`signature-requirements`

* **Type:** `array of objects`
* **External reference:** Yes (`signatureRequirementReference`)
* **Subfields:** [See fields](<#policy/signature-requirements>)

---

`signature-sets`

* **Type:** `array of objects`
* **Description:** Defines behavior when signatures found within a signature-set are detected in a request. Settings are cumulative, so if a signature is found in any set with block enabled, that signature will have block enabled.
* **External reference:** Yes (`signatureSetReference`)
* **Subfields:** [See fields](<#policy/signature-sets>)

---

`signature-settings`

* **Type:** `object`
* **External reference:** Yes (`signatureSettingReference`)
* **Subfields:** [See fields](<#policy/signature-settings>)

---

`signatures`

* **Type:** `array of objects`
* **Description:** This section defines the properties of a signature on the policy.
* **External reference:** Yes (`signatureReference`)
* **Subfields:** [See fields](<#policy/signatures>)

---

`template`

* **Type:** `object`
* **Description:** Specifies the template to populate the default attributes of a new policy.
* **External reference:** No
* **Subfields:** [See fields](<#policy/template>)

---

`threat-campaigns`

* **Type:** `array of objects`
* **Description:** This section defines the enforcement state for the threat campaigns in the security policy.
* **External reference:** Yes (`threatCampaignReference`)
* **Subfields:** [See fields](<#policy/threat-campaigns>)

---

`urls`

* **Type:** `array of objects`
* **Description:** In a security policy, you can manually specify the HTTP URLs that are allowed (or disallowed) in traffic to the web application being protected. When you create a security policy, wildcard URLs of * (representing all HTTP URLs) are added to the Allowed HTTP URLs lists.
* **External reference:** Yes (`urlReference`)
* **Subfields:** [See fields](<#policy/urls>)

---

<span id="policy/wafEngineVersion"></span>

`wafEngineVersion`

* **Type:** `string`
* **External reference:** No

---

`xml-profiles`

* **Type:** `array of objects`
* **External reference:** Yes (`xmlProfileReference`)
* **Subfields:** [See fields](<#policy/xml-profiles>)

---

<span id="policy/open-api-files"></span>

## open-api-files

<span id="policy/open-api-files/link"></span>

`link`

* **Type:** `string`

---

<span id="policy/template"></span>

## template

<span id="policy/template/derivedFrom"></span>

`derivedFrom`

* **Type:** `string`

---

<span id="policy/template/name"></span>

`name`

* **Type:** `string`
* **Allowed Values:** `POLICY_TEMPLATE_NGINX_BASE`
* **Description:** Specifies the name of the template used for the policy creation.

---

<span id="policy/access-profiles"></span>

## access-profiles

<span id="policy/access-profiles/description"></span>

`description`

* **Type:** `string`

---

<span id="policy/access-profiles/enforceMaximumLength"></span>

`enforceMaximumLength`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/access-profiles/enforceValidityPeriod"></span>

`enforceValidityPeriod`

* **Type:** `boolean`
* **Default:** `true`

---

`keyFiles`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/access-profiles/keyFiles>)

---

`location`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/access-profiles/location>)

---

<span id="policy/access-profiles/maximumLength"></span>

`maximumLength`

* **Type:** `integer`
* **Default:** `2000`

---

<span id="policy/access-profiles/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/access-profiles/type"></span>

`type`

* **Type:** `string`
* **Default:** `jwt`
* **Allowed Values:** `jwt`

---

`usernameExtraction`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/access-profiles/usernameExtraction>)

---

<span id="policy/access-profiles/verifyDigitalSignature"></span>

`verifyDigitalSignature`

* **Type:** `boolean`
* **Default:** `true`

---

<h3 id="policy/access-profiles/keyFiles"><code>keyFiles</code></h3>

<span id="policy/access-profiles/keyFiles/contents"></span>

`contents`

* **Type:** `string`

---

<span id="policy/access-profiles/keyFiles/fileName"></span>

`fileName`

* **Type:** `string`

---

<h3 id="policy/access-profiles/location"><code>location</code></h3>

<span id="policy/access-profiles/location/in"></span>

`in`

* **Type:** `string`
* **Default:** `header`
* **Allowed Values:** `header` | `query`

---

<span id="policy/access-profiles/location/name"></span>

`name`

* **Type:** `string`
* **Default:** `authorization`

---

<h3 id="policy/access-profiles/usernameExtraction"><code>usernameExtraction</code></h3>

<span id="policy/access-profiles/usernameExtraction/claimPropertyName"></span>

`claimPropertyName`

* **Type:** `string`
* **Default:** `sub`

---

<span id="policy/access-profiles/usernameExtraction/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/access-profiles/usernameExtraction/isMandatory"></span>

`isMandatory`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/blocking-settings"></span>

## blocking-settings

<span id="policy/blocking-settings/evasions"></span>

`evasions`

* **Type:** `array of objects`
* **Description:** This section defines behavior of 'Evasion technique detected' (VIOL\_EVASION) violation sub-violations.
  User can control which sub-violations are enabled (alarmed/blocked).
  Behavior of sub-violations depends on the block/alarm settings of 'Evasion technique detected' violation,
  defined in /policy/blocking-settings/violations section:
   - If both alarm and block are disabled - enable flag becomes irrelevant, since there will be no block/alarm for all sub-violations
* **External reference:** Yes (`evasionReference`)
* **Subfields:** [See fields](<#policy/blocking-settings_evasions>)

---

<span id="policy/blocking-settings/http-protocols"></span>

`http-protocols`

* **Type:** `array of objects`
* **Description:** This section defines behavior of 'HTTP protocol compliance failed' (VIOL\_HTTP\_PROTOCOL) violation sub-violations.
  User can control which sub-violations are enabled (alarmed/blocked).
  Behavior of sub-violations depends on the block/alarm settings of 'HTTP protocol compliance failed' violation,
   - If both alarm and block are disabled - enable flag becomes irrelevant, since there will be no block/alarm for all sub-violations
* **External reference:** Yes (`httpProtocolReference`)
* **Subfields:** [See fields](<#policy/blocking-settings_http-protocols>)

---

<span id="policy/blocking-settings/violations"></span>

`violations`

* **Type:** `array of objects`
* **External reference:** Yes (`violationReference`)
* **Subfields:** [See fields](<#policy/blocking-settings_violations>)

---

<span id="policy/bot-defense"></span>

## bot-defense

<span id="policy/bot-defense/mitigations"></span>

`mitigations`

* **Type:** `object`
* **Description:** This section defines the mitigation to each class or signature.
* **External reference:** Yes (`mitigationsReference`)
* **Subfields:** [See fields](<#policy/bot-defense_mitigations>)

---

<span id="policy/bot-defense/settings"></span>

`settings`

* **Type:** `object`
* **Description:** This section contains all bot defense settings.
* **External reference:** Yes (`settingsReference`)
* **Subfields:** [See fields](<#policy/bot-defense_settings>)

---

<span id="policy/browser-definitions"></span>

## browser-definitions

<span id="policy/browser-definitions/isUserDefined"></span>

`isUserDefined`

* **Type:** `boolean`

---

<span id="policy/browser-definitions/matchRegex"></span>

`matchRegex`

* **Type:** `string`

---

<span id="policy/browser-definitions/matchString"></span>

`matchString`

* **Type:** `string`

---

<span id="policy/browser-definitions/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/brute-force-attack-preventions"></span>

## brute-force-attack-preventions

<span id="policy/brute-force-attack-preventions/bruteForceProtectionForAllLoginPages"></span>

`bruteForceProtectionForAllLoginPages`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** When enabled, enables Brute Force Protection for all configured login URLs.
  When disabled, only brute force configurations for specific login pages are applied in case they exist.

---

`clientSideIntegrityBypassCriteria`

* **Type:** `object`
* **Description:** Specifies configuration for Client Side Integrity Bypass Mitigation.
* **Subfields:** [See fields](<#policy/brute-force-attack-preventions/clientSideIntegrityBypassCriteria>)

---

`detectionCriteria`

* **Type:** `object`
* **Description:** Specifies configuration for detecting distributed brute force attacks.
* **Subfields:** [See fields](<#policy/brute-force-attack-preventions/detectionCriteria>)

---

`loginAttemptsFromTheSameIp`

* **Type:** `object`
* **Description:** Specifies configuration for detecting brute force attacks from IP Address.
* **Subfields:** [See fields](<#policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp>)

---

`loginAttemptsFromTheSameUser`

* **Type:** `object`
* **Description:** Specifies configuration for detecting brute force attacks for Username.
* **Subfields:** [See fields](<#policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser>)

---

<span id="policy/brute-force-attack-preventions/measurementPeriod"></span>

`measurementPeriod`

* **Type:** `integer`
* **Default:** `900`
* **Minimum:** `60`
* **Maximum:** `90000`
* **Description:** Defines detection period (measured in seconds) for distributed brute force attacks.

---

<span id="policy/brute-force-attack-preventions/preventionDuration"></span>

`preventionDuration`

* **Type:** `integer` | `string`
* **Default:** `3600`
* **Allowed Values:** Integer values | `unlimited`
* **Minimum:** `60`
* **Maximum:** `90000`
* **Description:** Defines prevention period (measured in seconds) for distributed brute force attacks.

---

<span id="policy/brute-force-attack-preventions/reEnableLoginAfter"></span>

`reEnableLoginAfter`

* **Type:** `integer`
* **Default:** `3600`
* **Minimum:** `60`
* **Maximum:** `90000`
* **Description:** Defines prevention period (measured in seconds) for source-based brute force attacks.

---

<span id="policy/brute-force-attack-preventions/sourceBasedProtectionDetectionPeriod"></span>

`sourceBasedProtectionDetectionPeriod`

* **Type:** `integer`
* **Default:** `3600`
* **Minimum:** `60`
* **Maximum:** `90000`
* **Description:** Defines detection period (measured in seconds) for source-based brute force attacks.

---

<span id="policy/brute-force-attack-preventions/url"></span>

`url`

* **Type:** `object`
* **Description:** Reference to the URL used in login URL configuration (policy/login-pages). This login URL is protected by Brute Force Protection feature.
* **Subfields:** [See fields](<#policy/urls>)

---

<h3 id="policy/brute-force-attack-preventions/clientSideIntegrityBypassCriteria"><code>clientSideIntegrityBypassCriteria</code></h3>

<span id="policy/brute-force-attack-preventions/clientSideIntegrityBypassCriteria/action"></span>

`action`

* **Type:** `string`
* **Default:** `alarm-and-captcha`
* **Allowed Values:** `alarm-and-captcha`
* **Description:** Specifies action that is applied when defined threshold is reached.

  - **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge.

---

<span id="policy/brute-force-attack-preventions/clientSideIntegrityBypassCriteria/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** When enabled, the system counts successful challenges with failed logins from IP Address / Device ID / Username.
  Legitimate users who have disabled JavaScripting on their browsers for security reasons will fail a client side integrity challenge.

---

<span id="policy/brute-force-attack-preventions/clientSideIntegrityBypassCriteria/threshold"></span>

`threshold`

* **Type:** `integer`
* **Default:** `3`
* **Minimum:** `1`
* **Maximum:** `100`
* **Description:** After configured threshold (number of successful challenges with failed logins from IP Address / Device ID / Username) defined action will be applied for the next login attempt

---

<h3 id="policy/brute-force-attack-preventions/detectionCriteria"><code>detectionCriteria</code></h3>

<span id="policy/brute-force-attack-preventions/detectionCriteria/action"></span>

`action`

* **Type:** `string`
* **Default:** `alarm-and-captcha`
* **Allowed Values:** `alarm` | `alarm-and-captcha` | `alarm-and-client-side-integrity` | `alarm-and-client-side-integrity-captcha`
* **Description:** Specifies action that is applied when one of the defined thresholds (credentialsStuffingMatchesReached, failedLoginAttemptsRateReached) is reached.

  - **alarm**: The system will log the login attempt.
  - **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge.
  - **alarm-and-client-side-integrity**: The system determines whether the client is a legal browser or a bot by sending a page containing JavaScript code and waiting for a response. Legal browsers are able to execute JavaScript and produce a valid response, whereas bots cannot. A login attempt is logged if the client successfully passes the Client Side Integrity challenge.
  - **alarm-and-client-side-integrity-captcha**: The system sends a Client Side Integrity challenge upon the first failed login attempt from a source and a CAPTCHA challenge upon second and all subsequent failed login attempts. A login attempt is logged if client successfully passes the challenge. This enforcement action should be chosen if CAPTCHA is considered intrusive. Benign users who mistype their password will likely get only the Client Side Integrity challenge, while an attacker will eventually get the CAPTCHA challenge.

---

<span id="policy/brute-force-attack-preventions/detectionCriteria/credentialsStuffingMatchesReached"></span>

`credentialsStuffingMatchesReached`

* **Type:** `integer`
* **Default:** `100`
* **Minimum:** `1`
* **Maximum:** `10000`
* **Description:** After configured threshold (number of detected login attempts that match known leaked credentials library) defined action will be applied for the next login attempt.

---

<span id="policy/brute-force-attack-preventions/detectionCriteria/detectDistributedBruteForceAttack"></span>

`detectDistributedBruteForceAttack`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** When enabled, the system detects distributed brute force attacks.

---

<span id="policy/brute-force-attack-preventions/detectionCriteria/failedLoginAttemptsRateReached"></span>

`failedLoginAttemptsRateReached`

* **Type:** `integer`
* **Default:** `100`
* **Minimum:** `1`
* **Maximum:** `10000`
* **Description:** After configured threshold (number of failed login attempts within measurementPeriod) defined action will be applied for the next login attempt.           

---

<h3 id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp"><code>loginAttemptsFromTheSameIp</code></h3>

<span id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp/action"></span>

`action`

* **Type:** `string`
* **Default:** `alarm-and-captcha`
* **Allowed Values:** `alarm` | `alarm-and-blocking-page` | `alarm-and-captcha` | `alarm-and-client-side-integrity`
* **Description:** Specifies action that is applied when defined threshold is reached.

  - **alarm**: The system will log the login attempt.
  - **alarm-and-blocking-page**: The system will log the login attempt, block the request and send the Blocking page.
  - **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge.
  - **alarm-and-client-side-integrity**: The system determines whether the client is a legal browser or a bot by sending a page containing JavaScript code and waiting for a response. Legal browsers are able to execute JavaScript and produce a valid response, whereas bots cannot. A login attempt is logged if the client successfully passes the Client Side Integrity challenge.
  - **alarm-and-drop**: The system will log the login attempt and reset the TCP connection.
  - **alarm-and-honeypot-page**: The system will log the login attempt, block the request and send the Honeypot page. The Honeypot page is used for attacker deception. The page should look like an application failed login page. Unlike with the Blocking page, when the Honeypot page is sent an attacker is not able to distinguish a failed login response from a mitigation. As a result, the attacker will not change identity (Source IP or Device ID) and the brute force attack will be rendered ineffective. The Honeypot page is recommended when mitigation is request blocking.

---

<span id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** When enabled, the system counts failed login attempts from IP Address.

---

<span id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp/threshold"></span>

`threshold`

* **Type:** `integer`
* **Default:** `20`
* **Minimum:** `1`
* **Maximum:** `1000`
* **Description:** After configured threshold (number of failed login attempts from IP Address) defined action will be applied for the next login attempt.

---

<h3 id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser"><code>loginAttemptsFromTheSameUser</code></h3>

<span id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser/action"></span>

`action`

* **Type:** `string`
* **Default:** `alarm-and-captcha`
* **Allowed Values:** `alarm` | `alarm-and-captcha` | `alarm-and-client-side-integrity`
* **Description:** Specifies action that is applied when defined threshold is reached.

  - **alarm**: The system will log the login attempt.
  - **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge.
  - **alarm-and-client-side-integrity**: The system determines whether the client is a legal browser or a bot by sending a page containing JavaScript code and waiting for a response. Legal browsers are able to execute JavaScript and produce a valid response, whereas bots cannot. A login attempt is logged if the client successfully passes the Client Side Integrity challenge.

---

<span id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** When enabled, the system counts failed login attempts for each Username.

---

<span id="policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser/threshold"></span>

`threshold`

* **Type:** `integer`
* **Default:** `5`
* **Minimum:** `1`
* **Maximum:** `100`
* **Description:** After configured threshold (number of failed login attempts for each Username) defined action will be applied for the next login attempt.

---

<span id="policy/character-sets"></span>

## character-sets

`characterSet`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/character-sets/characterSet>)

---

<span id="policy/character-sets/characterSetType"></span>

`characterSetType`

* **Type:** `string`
* **Allowed Values:** `header` | `url` | `parameter-name` | `parameter-value` | `xml-content` | `json-content`

---

<h3 id="policy/character-sets/characterSet"><code>characterSet</code></h3>

<span id="policy/character-sets/characterSet/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`

---

<span id="policy/character-sets/characterSet/metachar"></span>

`metachar`

* **Type:** `string`

---

<span id="policy/cookie-settings"></span>

## cookie-settings

<span id="policy/cookie-settings/maximumCookieHeaderLength"></span>

`maximumCookieHeaderLength`

* **Type:** `integer` | `string`
* **Default:** `4096`
* **Schema default:** `any`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `1`
* **Maximum:** `65536`
* **Description:** Maximum Cookie Header Length must be greater than 0 and less than 65536 bytes (64K). Note: if 0 or *any* are set, then no restriction on the cookie header length is applied.

---

<span id="policy/cookies"></span>

## cookies

<span id="policy/cookies/accessibleOnlyThroughTheHttpProtocol"></span>

`accessibleOnlyThroughTheHttpProtocol`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies, when true, that the system adds the HttpOnly attribute to the domain cookie's response header.
  This is done to expose the cookie to only HTTP and HTTPS entities.
  This prevents the cookie from being modified, or intercepted even if it is not modified,
  by unwanted third parties that run scripts on the web page.

  **Notes**:
  - The system does not validate that the cookie has not been modified or intercepted.
  - The feature covers all security policy cookies, both enforced and allowed, explicit and wildcard.

---

<span id="policy/cookies/attackSignaturesCheck"></span>

`attackSignaturesCheck`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Specifies, when true, that you want attack signatures and threat campaigns to be detected on this cookie
  and possibly override the security policy settings of an attack signature or threat campaign specifically for this cookie.
  After you enable this setting, the system displays a list of attack signatures and threat campaigns.

---

<span id="policy/cookies/decodeValueAsBase64"></span>

`decodeValueAsBase64`

* **Type:** `string`
* **Default:** `disabled`
* **Allowed Values:** `disabled` | `enabled` | `required`
* **Description:** Specifies whether the the system should detect or require values to be Base64 encoded:

   - **disabled**: the value will not be decoded as Base64 content.
   - **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value.
   - **required**: the value must be decoded as Base64, and security checks will be performed on the decoded value.

   **Note**: This setting is only relevant if the Cookie Enforcement Type is set to Allowed.

---

<span id="policy/cookies/enforcementType"></span>

`enforcementType`

* **Type:** `string`
* **Default:** `allow`
* **Allowed Values:** `allow` | `enforce`
* **Description:** Specifies how the system treats this cookie.

  - **enforced**: Specifies that according to the security policy, this cookie may not be changed by the client.
  - **allowed**: Specifies that according to the security policy, this cookie may be changed by the client. The system ignores this cookie.

---

<span id="policy/cookies/insertSameSiteAttribute"></span>

`insertSameSiteAttribute`

* **Type:** `string`
* **Default:** `none`
* **Allowed Values:** `lax` | `none` | `none-value` | `strict`
* **Description:** The introduction of the SameSite http attribute (defined in [RFC6265bis](<https://tools.ietf.org/html/draft-ietf-httpbis-cookie-same-site-00>))
  allows you to declare if your cookie should be restricted to a first-party or same-site context.
  Introducing the SameSite attribute on a cookie provides three different ways of controlling same-site vs. cross-site cookie sending:

  - **strict**: Cookie will only be sent in a first-party context. In user terms, the cookie will only be sent if the site for the cookie matches the site currently shown in the browser's URL bar.
  - **lax**: Cookies will be sent with top level navigation
  - **none-value**: Cookies will be sent in a third-party context.

---

<span id="policy/cookies/maskValueInLogs"></span>

`maskValueInLogs`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies, when true, that the cookie's value will be masked in the request log.

---

<span id="policy/cookies/name"></span>

`name`

* **Type:** `string`
* **Description:** Specifies the cookie name as appearing in the http cookie header.
  The cookie name length is limited to 500 characters.

  Names can be one of the following according to the *type* attribute:

  - **explicit**: Specifies that the cookie has a specific name and is not a wildcard entity. Type the name of a cookie exactly as you expect it to appear in the request.
  - **wildcard**: Specifies that any cookie that matches the listed wildcard expression should be treated according to the wildcard attributes. Type a wildcard expression that matches the expected cookie. For example, the wildcard expression cookie\_12* of type Enforced specifies that the security policy should not allow modified domain cookies for all cookies which match cookie\_12*.

  The syntax for wildcard entities is based on shell-style wildcard characters.
  The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.

  - **\***: Matches all characters
  - **?**: Matches any single character
  - **\[abcde\]**: Matches exactly one of the characters listed
  - **\[\!abcde\]**: Matches any character not listed
  - **\[a-e\]**: Matches exactly one character in the range
  - **\[\!a-e\]**: Matches any character not in the range

  **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.

---

<span id="policy/cookies/securedOverHttpsConnection"></span>

`securedOverHttpsConnection`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies, when true, that the system adds the Secure attribute to the domain cookie's response header.
  This is done to ensure that the cookies are returned to the server only over SSL (by using the HTTPS protocol).
  This prevents the cookie from being intercepted, but does not guarantee its integrity.

  **Notes**:
  - The system does not validate that the cookie was received over SSL.
  - The feature covers all security policy cookies, both enforced and allowed, explicit and wildcard.

---

`signatureOverrides`

* **Type:** `array of objects`
* **Description:** Array of signature overrides.
  Specifies attack signatures whose security policy settings are overridden for this cookie,
  and which action the security policy takes when it discovers a request for this cookie that matches these attack signatures.
* **Subfields:** [See fields](<#policy/cookies/signatureOverrides>)

---

<span id="policy/cookies/type"></span>

`type`

* **Type:** `string`
* **Default:** `explicit`
* **Allowed Values:** `explicit` | `wildcard`
* **Description:** Determines the type of the **name** attribute.
  Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.

---

<span id="policy/cookies/wildcardOrder"></span>

`wildcardOrder`

* **Type:** `integer`
* **Description:** Specifies the order index for wildcard cookies matching.
  Wildcard cookies with lower wildcard order will get checked for a match prior to cookies with higher wildcard order.

---

<h3 id="policy/cookies/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/cookies/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Description:** Specifies, when true, that the overridden signature is enforced

---

<span id="policy/cookies/signatureOverrides/name"></span>

`name`

* **Type:** `string`
* **Description:** The signature name which, along with the signature tag, identifies the signature.

---

<span id="policy/cookies/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`
* **Description:** The signature ID which identifies the signature.

---

<span id="policy/cookies/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`
* **Description:** The signature tag which, along with the signature name, identifies the signature.

---

<span id="policy/csrf-protection"></span>

## csrf-protection

<span id="policy/csrf-protection/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/csrf-protection/expirationTimeInSeconds"></span>

`expirationTimeInSeconds`

* **Type:** `integer` | `string`
* **Default:** `disabled`
* **Allowed Values:** Integer values | `disabled`

---

<span id="policy/csrf-protection/sslOnly"></span>

`sslOnly`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/csrf-urls"></span>

## csrf-urls

<span id="policy/csrf-urls/enforcementAction"></span>

`enforcementAction`

* **Type:** `string`
* **Allowed Values:** `none` | `verify-origin`

---

<span id="policy/csrf-urls/method"></span>

`method`

* **Type:** `string`
* **Default:** `POST`
* **Allowed Values:** `GET` | `POST` | `any`

---

<span id="policy/csrf-urls/url"></span>

`url`

* **Type:** `string`

---

<span id="policy/csrf-urls/wildcardOrder"></span>

`wildcardOrder`

* **Type:** `integer`
* **Default:** `0`

---

<span id="policy/data-guard"></span>

## data-guard

<span id="policy/data-guard/creditCardNumbers"></span>

`creditCardNumbers`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** If *true* the system considers credit card numbers as sensitive data.

---

<span id="policy/data-guard/customPatterns"></span>

`customPatterns`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** If *true* the system recognizes customized patterns as sensitive data.

---

<span id="policy/data-guard/customPatternsList"></span>

`customPatternsList`

* **Type:** `array of strings`
* **Default:** `[]`
* **Description:** List of PCRE regular expressions that specify the sensitive data patterns.

---

<span id="policy/data-guard/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** If *true* the system protects sensitive data.

---

<span id="policy/data-guard/enforcementMode"></span>

`enforcementMode`

* **Type:** `string`
* **Default:** `ignore-urls-in-list`
* **Allowed Values:** `enforce-urls-in-list` | `ignore-urls-in-list`
* **Description:** Specifies the URLs for which the system enforces data guard protection.

  - **ignore-urls-in-list**: Specifies that the system enforces data guard protection for all URLs except for those URLs in the Enforcement Mode list.
  - **enforce-urls-in-list**: Specifies that the system enforces data guard protection only for those URLs in the Enforcement Mode list

---

<span id="policy/data-guard/enforcementUrls"></span>

`enforcementUrls`

* **Type:** `array of strings`
* **Default:** `[]`
* **Description:** List of URLS to be enforced based on enforcement mode of data guard protection.

---

<span id="policy/data-guard/firstCustomCharactersToExpose"></span>

`firstCustomCharactersToExpose`

* **Type:** `integer`
* **Default:** `0`
* **Minimum:** `0`
* **Maximum:** `255`
* **Description:** Specifies the number of first alphanumeric characters in Custom patterns that are exposed.

---

<span id="policy/data-guard/lastCustomCharactersToExpose"></span>

`lastCustomCharactersToExpose`

* **Type:** `integer`
* **Default:** `0`
* **Minimum:** `0`
* **Maximum:** `255`
* **Description:** Specifies the number of last alphanumeric characters in Custom patterns that are exposed.

---

<span id="policy/data-guard/maskData"></span>

`maskData`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** If *true* the system intercepts the returned responses to mask sensitive data.

---

<span id="policy/data-guard/usSocialSecurityNumbers"></span>

`usSocialSecurityNumbers`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** If *true* the system considers U.S Social Security numbers as sensitive data.

---

<span id="policy/disallowed-geolocations"></span>

## disallowed-geolocations

<span id="policy/disallowed-geolocations/countryCode"></span>

`countryCode`

* **Type:** `string`
* **Description:** Specifies the ISO country code of the selected country.

---

<span id="policy/disallowed-geolocations/countryName"></span>

`countryName`

* **Type:** `string`
* **Allowed Values:** `Afghanistan` | `Aland Islands` | `Albania` | `Algeria` | `American Samoa` | `Andorra` | `Angola` | `Anguilla` | `Anonymous Proxy` | `Antarctica` | `Antigua and Barbuda` | `Argentina` | `Armenia` | `Aruba` | `Australia` | `Austria` | `Azerbaijan` | `Bahamas` | `Bahrain` | `Bangladesh` | `Barbados` | `Belarus` | `Belgium` | `Belize` | `Benin` | `Bermuda` | `Bhutan` | `Bolivia` | `Bosnia and Herzegovina` | `Botswana` | `Bouvet Island` | `Brazil` | `British Indian Ocean Territory` | `Brunei Darussalam` | `Bulgaria` | `Burkina Faso` | `Burundi` | `Cambodia` | `Cameroon` | `Canada` | `Cape Verde` | `Cayman Islands` | `Central African Republic` | `Chad` | `Chile` | `China` | `Christmas Island` | `Cocos (Keeling) Islands` | `Colombia` | `Comoros` | `Congo` | `Congo, The Democratic Republic of the` | `Cook Islands` | `Costa Rica` | `Cote D'Ivoire` | `Croatia` | `Cuba` | `Cyprus` | `Czech Republic` | `Denmark` | `Djibouti` | `Dominica` | `Dominican Republic` | `Ecuador` | `Egypt` | `El Salvador` | `Equatorial Guinea` | `Eritrea` | `Estonia` | `Ethiopia` | `Falkland Islands (Malvinas)` | `Faroe Islands` | `Fiji` | `Finland` | `France` | `France, Metropolitan` | `French Guiana` | `French Polynesia` | `French Southern Territories` | `Gabon` | `Gambia` | `Georgia` | `Germany` | `Ghana` | `Gibraltar` | `Greece` | `Greenland` | `Grenada` | `Guadeloupe` | `Guam` | `Guatemala` | `Guernsey` | `Guinea` | `Guinea-Bissau` | `Guyana` | `Haiti` | `Heard Island and McDonald Islands` | `Holy See (Vatican City State)` | `Honduras` | `Hong Kong` | `Hungary` | `Iceland` | `India` | `Indonesia` | `Iran, Islamic Republic of` | `Iraq` | `Ireland` | `Isle of Man` | `Israel` | `Italy` | `Jamaica` | `Japan` | `Jersey` | `Jordan` | `Kazakhstan` | `Kenya` | `Kiribati` | `Korea, Democratic People's Republic of` | `Korea, Republic of` | `Kuwait` | `Kyrgyzstan` | `Lao People's Democratic Republic` | `Latvia` | `Lebanon` | `Lesotho` | `Liberia` | `Libyan Arab Jamahiriya` | `Liechtenstein` | `Lithuania` | `Luxembourg` | `Macau` | `Macedonia` | `Madagascar` | `Malawi` | `Malaysia` | `Maldives` | `Mali` | `Malta` | `Marshall Islands` | `Martinique` | `Mauritania` | `Mauritius` | `Mayotte` | `Mexico` | `Micronesia, Federated States of` | `Moldova, Republic of` | `Monaco` | `Mongolia` | `Montenegro` | `Montserrat` | `Morocco` | `Mozambique` | `Myanmar` | `N/A` | `Namibia` | `Nauru` | `Nepal` | `Netherlands` | `Netherlands Antilles` | `New Caledonia` | `New Zealand` | `Nicaragua` | `Niger` | `Nigeria` | `Niue` | `Norfolk Island` | `Northern Mariana Islands` | `Norway` | `Oman` | `Other` | `Pakistan` | `Palau` | `Palestinian Territory` | `Panama` | `Papua New Guinea` | `Paraguay` | `Peru` | `Philippines` | `Pitcairn Islands` | `Poland` | `Portugal` | `Puerto Rico` | `Qatar` | `Reunion` | `Romania` | `Russian Federation` | `Rwanda` | `Saint Barthelemy` | `Saint Helena` | `Saint Kitts and Nevis` | `Saint Lucia` | `Saint Martin` | `Saint Pierre and Miquelon` | `Saint Vincent and the Grenadines` | `Samoa` | `San Marino` | `Sao Tome and Principe` | `Satellite Provider` | `Saudi Arabia` | `Senegal` | `Serbia` | `Seychelles` | `Sierra Leone` | `Singapore` | `Slovakia` | `Slovenia` | `Solomon Islands` | `Somalia` | `South Africa` | `South Georgia and the South Sandwich Islands` | `Spain` | `Sri Lanka` | `Sudan` | `Suriname` | `Svalbard and Jan Mayen` | `Swaziland` | `Sweden` | `Switzerland` | `Syrian Arab Republic` | `Taiwan` | `Tajikistan` | `Tanzania, United Republic of` | `Thailand` | `Timor-Leste` | `Togo` | `Tokelau` | `Tonga` | `Trinidad and Tobago` | `Tunisia` | `Turkey` | `Turkmenistan` | `Turks and Caicos Islands` | `Tuvalu` | `Uganda` | `Ukraine` | `United Arab Emirates` | `United Kingdom` | `United States` | `United States Minor Outlying Islands` | `Uruguay` | `Uzbekistan` | `Vanuatu` | `Venezuela` | `Vietnam` | `Virgin Islands, British` | `Virgin Islands, U.S.` | `Wallis and Futuna` | `Western Sahara` | `Yemen` | `Zambia` | `Zimbabwe`
* **Description:** Specifies the name of the country.

---

<span id="policy/enforcer-settings"></span>

## enforcer-settings

`enforcerStateCookies`

* **Type:** `object`
* **Description:** This section defines the properties of the enforcer state cookies.
* **Subfields:** [See fields](<#policy/enforcer-settings/enforcerStateCookies>)

---

<h3 id="policy/enforcer-settings/enforcerStateCookies"><code>enforcerStateCookies</code></h3>

<span id="policy/enforcer-settings/enforcerStateCookies/httpOnlyAttribute"></span>

`httpOnlyAttribute`

* **Type:** `boolean`
* **Default:** `true`
* **Schema default:** `false`
* **Description:** Specifies, when true, that the system adds the state cookie HttpOnly attribute.

---

<span id="policy/enforcer-settings/enforcerStateCookies/sameSiteAttribute"></span>

`sameSiteAttribute`

* **Type:** `string`
* **Default:** `strict`
* **Schema default:** `none`
* **Allowed Values:** `lax` | `none` | `none-value` | `strict`
* **Description:** The value for the state cookie SameSite attribute:

  - **none**: The SameSite attribute is never added to the state cookie.
  - **strict**: Cookie will only be sent in a first-party context. In user terms, the cookie will only be sent if the site for the cookie matches the site currently shown in the browser's URL bar.
  - **lax**: Cookies will be sent with top level navigation
  - **none-value**: Cookies will be sent in a third-party context.

---

<span id="policy/enforcer-settings/enforcerStateCookies/secureAttribute"></span>

`secureAttribute`

* **Type:** `string`
* **Default:** `always`
* **Schema default:** `never`
* **Allowed Values:** `always` | `never`
* **Description:** The value for the state cookie Secure attribute:

  - **always**: Always add the Secure attribute to the state cookie.
  - **never**: The Secure attribute is never added to the state cookie.

---

<span id="policy/filetypes"></span>

## filetypes

<span id="policy/filetypes/allowed"></span>

`allowed`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether the file type is allowed or disallowed. In either of these cases the VIOL\_FILETYPE violation is issued (if enabled) for an incoming request-
  1. No allowed file type matched the file type of the request.
  2. The file type of the request matched a disallowed file type.

---

<span id="policy/filetypes/checkPostDataLength"></span>

`checkPostDataLength`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether to enforce maximum length restriction for the body, a.k.a. &quot;POST data&quot; part of the requests that match the respective file type. The maximum length is determined by *postDataLength* attribute.
  Although named &quot;POST data&quot;, this applies to any content type and not restricted to POST requests, e.g. PUT requests are also checked.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/checkQueryStringLength"></span>

`checkQueryStringLength`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether to enforce maximum length restriction for the query string of the requests that match the respective file type. The maximum length is determined by *queryStringLength* attribute.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/checkRequestLength"></span>

`checkRequestLength`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether to enforce maximum length restriction for the total length of requests that match the respective file type. The maximum length is determined by *requestLength* attribute.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/checkUrlLength"></span>

`checkUrlLength`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether to enforce maximum length restriction for the URL of the requests that match the respective file type. The URL does *not* include the query string, past the &amp;. The maximum length is determined by *urlLength* attribute.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/name"></span>

`name`

* **Type:** `string`
* **Description:** Specifies the file type name as appearing in the URL extension. Names can be one of the following according to the *type* attribute:

  - **Explicit** - Specifies that the name is the literal file extension to which the file type refers. The *type* attribute has to be &quot;explicit&quot;.
  - **No Extension** - Specifies the empty file type, lacking file extension. For this the reserved string **no\_ext** should be used. The *type* attribute has to be &quot;explicit&quot;.
  - **Wildcard** - Specifies that any file extension that matches the wildcard expression is matched to this file type in the policy. The *type* attribute has to be &quot;wildcard&quot;.

  The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.

  - **\***: Matches all characters
  - **?**: Matches any single character
  - **\[abcde\]**: Matches exactly one of the characters listed
  - **\[\!abcde\]**: Matches any character not listed
  - **\[a-e\]**: Matches exactly one character in the range
  - **\[\!a-e\]**: Matches any character not in the range

  **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.

---

<span id="policy/filetypes/postDataLength"></span>

`postDataLength`

* **Type:** `integer`
* **Default:** `1000`
* **Minimum:** `0`
* **Description:** The maximum length in bytes of the body (POST data) of the request matching the file type. Enforced only if checkPostDataLength is set to *true*.
  If the value is exceeded then VIOL\_POST\_DATA\_LENGTH violation is issued.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/queryStringLength"></span>

`queryStringLength`

* **Type:** `integer`
* **Default:** `1000`
* **Minimum:** `0`
* **Description:** The maximum length in bytes of the query string of the request matching the file type. Enforced only if checkQueryStringLength is set to *true*.
  If the value is exceeded then VIOL\_QUERY\_STRING\_LENGTH violation is issued.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/requestLength"></span>

`requestLength`

* **Type:** `integer`
* **Default:** `5000`
* **Minimum:** `0`
* **Description:** The maximum total length in bytes of the request matching the file type. Enforced only if checkRequestLength is set to *true*.
  If the value is exceeded then VIOL\_REQUEST\_LENGTH violation is issued.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/responseCheck"></span>

`responseCheck`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether the responses to requests that match the respective file types are inspected for attack signature detection.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/responseCheckLength"></span>

`responseCheckLength`

* **Type:** `integer`
* **Default:** `20000`
* **Minimum:** `0`
* **Maximum:** `10000000000`
* **Description:** Determines how much of the response body will be checked for signatures.
  When value is set to 0, only the header will be checked.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/type"></span>

`type`

* **Type:** `string`
* **Default:** `explicit`
* **Allowed Values:** `explicit` | `wildcard`
* **Description:** Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.

---

<span id="policy/filetypes/urlLength"></span>

`urlLength`

* **Type:** `integer`
* **Default:** `100`
* **Minimum:** `0`
* **Description:** The maximum length in bytes of the URL of the request matching the file type, excluding the query string. Enforced only if checkUrlLength is set to *true*.
  If the value is exceeded then VIOL\_URL\_LENGTH violation is issued.
  This attribute is relevant only to *allowed* file types.

---

<span id="policy/filetypes/wildcardOrder"></span>

`wildcardOrder`

* **Type:** `integer`

---

<span id="policy/general"></span>

## general

<span id="policy/general/allowedResponseCodes"></span>

`allowedResponseCodes`

* **Type:** `array of integers`
* **Default:** `[400,401,404,407,417,503]`
* **Description:** You can specify which responses a security policy permits.
  By default, the system accepts all response codes from 100 to 399 as valid responses.
  Response codes from 400 to 599 are considered invalid unless added to the Allowed Response Status Codes list.
  By default, 400, 401, 404, 407, 417, and 503 are on the list as allowed HTTP response status codes.

---

<span id="policy/general/customXffHeaders"></span>

`customXffHeaders`

* **Type:** `array of strings`
* **Default:** `[]`
* **Description:** If you require the system to trust a server further than one hop toward the client (the last proxy traversed), you can use the Custom XFF Headers setting to define a specific header that is inserted closer to, or at the client, that the system will trust.
  Additionally, if you require the system to trust a proxy server that uses a different header name than the X-Forwarded-For header name, you can add the desired header name to the Custom XFF Headers setting.
  When adding a custom header, the X-Forwarded-For header is not trusted anymore. In case the X-Forwarded-For header is to be trusted along with other headers, you must add it to the custom headers list.

---

<span id="policy/general/maskCreditCardNumbersInRequest"></span>

`maskCreditCardNumbersInRequest`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** When enabled, the security policy masks credit card numbers that appear in any part of requests. The system does not mask the information in the actual requests, but rather in various logs:
  * Credit card numbers appearing in entity names are masked in the requests of the Requests log.
  * Credit card numbers appearing in entity values are masked wherever requests can be viewed: the Requests log, and violation details within that log.
  This setting is enabled by default, and exists in addition to masking parameters defined as containing sensitive information.

---

<span id="policy/general/trustXff"></span>

`trustXff`

* **Type:** `boolean`
* **Description:** When enabled, the system has confidence in an XFF (X-Forwarded-For) header in the request. When disabled, that the system does not have confidence in an XFF header in the request. The default setting is disabled.

  Select this option if the system is deployed behind an internal or other trusted proxy. Then, the system uses the IP address that initiated the connection to the proxy instead of the internal proxy's IP address.

  Leave this option disabled if you think the HTTP header may be spoofed, or crafted, by a malicious client. With this setting disabled, if the system is deployed behind an internal proxy, the system uses the internal proxy's IP address instead of the client's IP address.

---

<span id="policy/graphql-profiles"></span>

## graphql-profiles

<span id="policy/graphql-profiles/attackSignaturesCheck"></span>

`attackSignaturesCheck`

* **Type:** `boolean`
* **Default:** `true`

---

`defenseAttributes`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/graphql-profiles/defenseAttributes>)

---

<span id="policy/graphql-profiles/description"></span>

`description`

* **Type:** `string`

---

<span id="policy/graphql-profiles/hasIdlFiles"></span>

`hasIdlFiles`

* **Type:** `boolean`

---

`idlFiles`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/graphql-profiles/idlFiles>)

---

<span id="policy/graphql-profiles/metacharElementCheck"></span>

`metacharElementCheck`

* **Type:** `boolean`
* **Default:** `true`

---

`metacharOverrides`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/graphql-profiles/metacharOverrides>)

---

<span id="policy/graphql-profiles/name"></span>

`name`

* **Type:** `string`

---

`responseEnforcement`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/graphql-profiles/responseEnforcement>)

---

`sensitiveData`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/graphql-profiles/sensitiveData>)

---

`signatureOverrides`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/graphql-profiles/signatureOverrides>)

---

<h3 id="policy/graphql-profiles/defenseAttributes"><code>defenseAttributes</code></h3>

<span id="policy/graphql-profiles/defenseAttributes/allowIntrospectionQueries"></span>

`allowIntrospectionQueries`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/graphql-profiles/defenseAttributes/maximumBatchedQueries"></span>

`maximumBatchedQueries`

* **Type:** `integer` | `string`
* **Default:** `10`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/graphql-profiles/defenseAttributes/maximumQueryCost"></span>

`maximumQueryCost`

* **Type:** `integer` | `string`
* **Default:** `any`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/graphql-profiles/defenseAttributes/maximumStructureDepth"></span>

`maximumStructureDepth`

* **Type:** `integer` | `string`
* **Default:** `10`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/graphql-profiles/defenseAttributes/maximumTotalLength"></span>

`maximumTotalLength`

* **Type:** `integer` | `string`
* **Default:** `100000`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/graphql-profiles/defenseAttributes/maximumValueLength"></span>

`maximumValueLength`

* **Type:** `integer` | `string`
* **Default:** `10000`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/graphql-profiles/defenseAttributes/tolerateParsingWarnings"></span>

`tolerateParsingWarnings`

* **Type:** `boolean`
* **Default:** `true`

---

<h3 id="policy/graphql-profiles/idlFiles"><code>idlFiles</code></h3>

`idlFile`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/graphql-profiles/idlFiles/idlFile>)

---

<span id="policy/graphql-profiles/idlFiles/isPrimary"></span>

`isPrimary`

* **Type:** `boolean`

---

<h4 id="policy/graphql-profiles/idlFiles/idlFile"><code>idlFile</code></h4>

<h3 id="policy/graphql-profiles/metacharOverrides"><code>metacharOverrides</code></h3>

<span id="policy/graphql-profiles/metacharOverrides/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`

---

<span id="policy/graphql-profiles/metacharOverrides/metachar"></span>

`metachar`

* **Type:** `string`

---

<h3 id="policy/graphql-profiles/responseEnforcement"><code>responseEnforcement</code></h3>

<span id="policy/graphql-profiles/responseEnforcement/blockDisallowedPatterns"></span>

`blockDisallowedPatterns`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/graphql-profiles/responseEnforcement/disallowedPatterns"></span>

`disallowedPatterns`

* **Type:** `array of strings`
* **Default:** `["{\\s*\"errors\":\\s*\\[\\s*{\\s*\"message\":"]`

---

<h3 id="policy/graphql-profiles/sensitiveData"><code>sensitiveData</code></h3>

<span id="policy/graphql-profiles/sensitiveData/parameterName"></span>

`parameterName`

* **Type:** `string`

---

<h3 id="policy/graphql-profiles/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/graphql-profiles/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`

---

<span id="policy/graphql-profiles/signatureOverrides/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/graphql-profiles/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`

---

<span id="policy/graphql-profiles/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`

---

<span id="policy/grpc-profiles"></span>

## grpc-profiles

<span id="policy/grpc-profiles/associateUrls"></span>

`associateUrls`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/grpc-profiles/attackSignaturesCheck"></span>

`attackSignaturesCheck`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/grpc-profiles/decodeStringValuesAsBase64"></span>

`decodeStringValuesAsBase64`

* **Type:** `string`
* **Default:** `disabled`
* **Allowed Values:** `disabled` | `enabled`

---

`defenseAttributes`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/grpc-profiles/defenseAttributes>)

---

<span id="policy/grpc-profiles/description"></span>

`description`

* **Type:** `string`

---

<span id="policy/grpc-profiles/hasIdlFiles"></span>

`hasIdlFiles`

* **Type:** `boolean`

---

`idlFiles`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/grpc-profiles/idlFiles>)

---

<span id="policy/grpc-profiles/metacharElementCheck"></span>

`metacharElementCheck`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/grpc-profiles/name"></span>

`name`

* **Type:** `string`

---

`signatureOverrides`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/grpc-profiles/signatureOverrides>)

---

<h3 id="policy/grpc-profiles/defenseAttributes"><code>defenseAttributes</code></h3>

<span id="policy/grpc-profiles/defenseAttributes/allowUnknownFields"></span>

`allowUnknownFields`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/grpc-profiles/defenseAttributes/maximumDataLength"></span>

`maximumDataLength`

* **Type:** `integer` | `string`
* **Default:** `4194304`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<h3 id="policy/grpc-profiles/idlFiles"><code>idlFiles</code></h3>

`idlFile`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/grpc-profiles/idlFiles/idlFile>)

---

<span id="policy/grpc-profiles/idlFiles/importUrl"></span>

`importUrl`

* **Type:** `string`

---

<span id="policy/grpc-profiles/idlFiles/isPrimary"></span>

`isPrimary`

* **Type:** `boolean`

---

<span id="policy/grpc-profiles/idlFiles/primaryIdlFileName"></span>

`primaryIdlFileName`

* **Type:** `string`

---

<h4 id="policy/grpc-profiles/idlFiles/idlFile"><code>idlFile</code></h4>

<h3 id="policy/grpc-profiles/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/grpc-profiles/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`

---

<span id="policy/grpc-profiles/signatureOverrides/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/grpc-profiles/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`

---

<span id="policy/grpc-profiles/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`

---

<span id="policy/header-settings"></span>

## header-settings

<span id="policy/header-settings/maximumHttpHeaderLength"></span>

`maximumHttpHeaderLength`

* **Type:** `integer` | `string`
* **Default:** `4096`
* **Schema default:** `any`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `1`
* **Maximum:** `65536`
* **Description:** Maximum HTTP Header Length must be greater than 0 and less than 65536 bytes (64K). Note: if 0 or *any* are set, then no restriction on the HTTP header length is applied.

---

<span id="policy/headers"></span>

## headers

<span id="policy/headers/allowEmptyValue"></span>

`allowEmptyValue`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/headers/allowRepeatedOccurrences"></span>

`allowRepeatedOccurrences`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/headers/autoDetectBinaryValue"></span>

`autoDetectBinaryValue`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/headers/checkSignatures"></span>

`checkSignatures`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/headers/decodeValueAsBase64"></span>

`decodeValueAsBase64`

* **Type:** `string`
* **Default:** `disabled`
* **Allowed Values:** `disabled` | `enabled` | `required`
* **Description:** Specifies whether the the system should detect or require values to be Base64 encoded:

   - **disabled**: the value will not be decoded as Base64 content.
   - **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value.
   - **required**: the value must be decoded as Base64, and security checks will be performed on the decoded value.

---

<span id="policy/headers/htmlNormalization"></span>

`htmlNormalization`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/headers/mandatory"></span>

`mandatory`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/headers/maskValueInLogs"></span>

`maskValueInLogs`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies, when true, that the headers's value will be masked in the request log.

---

<span id="policy/headers/name"></span>

`name`

* **Type:** `string`
* **Description:** Specifies the HTTP header name.
  The header name length is limited to 254 characters.

  Names can be one of the following according to the *type* attribute:

  - **explicit**: Specifies that the header has a specific name and is not a wildcard entity. The name of the header exactly as you expect it to appear in the request.
  - **wildcard**: Specifies that any header that matches the listed wildcard expression should be treated according to the wildcard attributes.

  The syntax for wildcard entities is based on shell-style wildcard characters.
  The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.

  - **\***: Matches all characters
  - **?**: Matches any single character
  - **\[abcde\]**: Matches exactly one of the characters listed
  - **\[\!abcde\]**: Matches any character not listed
  - **\[a-e\]**: Matches exactly one character in the range
  - **\[\!a-e\]**: Matches any character not in the range

  **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.

---

<span id="policy/headers/normalizationViolations"></span>

`normalizationViolations`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/headers/percentDecoding"></span>

`percentDecoding`

* **Type:** `boolean`
* **Default:** `false`

---

`signatureOverrides`

* **Type:** `array of objects`
* **Description:** Array of signature overrides.
  Specifies attack signatures whose security policy settings are overridden for this header,
  and which action the security policy takes when it discovers a request for this header that matches these attack signatures.
* **Subfields:** [See fields](<#policy/headers/signatureOverrides>)

---

<span id="policy/headers/type"></span>

`type`

* **Type:** `string`
* **Default:** `explicit`
* **Allowed Values:** `explicit` | `wildcard`
* **Description:** Determines the type of the **name** attribute.
  Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.

---

<span id="policy/headers/urlNormalization"></span>

`urlNormalization`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/headers/wildcardOrder"></span>

`wildcardOrder`

* **Type:** `integer`
* **Default:** `0`
* **Description:** Specifies the order index for wildcard header matching.
  Wildcard headers with lower wildcard order will get checked for a match prior to headers with higher wildcard order.

---

<h3 id="policy/headers/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/headers/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Description:** Specifies, when true, that the overridden signature is enforced

---

<span id="policy/headers/signatureOverrides/name"></span>

`name`

* **Type:** `string`
* **Description:** The signature name which, along with the signature tag, identifies the signature.

---

<span id="policy/headers/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`
* **Description:** The signature ID which identifies the signature.

---

<span id="policy/headers/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`
* **Description:** The signature tag which, along with the signature name, identifies the signature.

---

<span id="policy/host-names"></span>

## host-names

<span id="policy/host-names/includeSubdomains"></span>

`includeSubdomains`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/host-names/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/idl-files"></span>

## idl-files

<span id="policy/idl-files/contents"></span>

`contents`

* **Type:** `string`

---

<span id="policy/idl-files/fileName"></span>

`fileName`

* **Type:** `string`

---

<span id="policy/idl-files/isBase64"></span>

`isBase64`

* **Type:** `boolean`

---

<span id="policy/ip-address-lists"></span>

## ip-address-lists

<span id="policy/ip-address-lists/blockRequests"></span>

`blockRequests`

* **Type:** `string`
* **Default:** `policy-default`
* **Allowed Values:** `always` | `never` | `policy-default`
* **Description:** Specifies how the system responds to blocking requests sent from this IP address list.
  - **Policy Default:** Specifies that the policy enforcementMode will be used for requests from this IP address list.
  - **Never Block:** Specifies that the system does not block requests sent from this IP address list, even if your security policy is configured to block all traffic.
  - **Always Block:** Specifies that the system blocks requests sent from this IP address list.
  Optional, if absent Policy Default is used.

---

<span id="policy/ip-address-lists/description"></span>

`description`

* **Type:** `string`
* **Description:** Specifies a brief description of the IP address list. Optional

---

`ipAddresses`

* **Type:** `array of objects`
* **Description:** Specifies the IP addresses. Use CIDR notation for subnet definition.
* **Subfields:** [See fields](<#policy/ip-address-lists/ipAddresses>)

---

<span id="policy/ip-address-lists/matchOrder"></span>

`matchOrder`

* **Type:** `integer`
* **Description:** Specifies the order matching index between different IP Address Lists. If unspecified, the order is implicitly as the lists appear in the policy.
  IP Address Lists with a lower matchOrder will be checked for a match prior to items with higher matchOrder.

---

<span id="policy/ip-address-lists/name"></span>

`name`

* **Type:** `string`
* **Description:** Specifies the name of ip address list.

---

<span id="policy/ip-address-lists/neverLogRequests"></span>

`neverLogRequests`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies when enabled that the system does not log requests or responses sent from this IP address list, even if the traffic is illegal, and even if your security policy is configured to log all traffic.
  Optional, if absent default value is false.

---

<span id="policy/ip-address-lists/setGeolocation"></span>

`setGeolocation`

* **Type:** `string`
* **Description:** Specifies a geolocation to be associated for this IP address list.
  This will force the IP addresses in the list to be considered as though they are in that geolocation. This applies to blocking via &quot;disallowed-geolocations&quot; and to logging. 
  Optional

---

<h3 id="policy/ip-address-lists/ipAddresses"><code>ipAddresses</code></h3>

<span id="policy/ip-address-lists/ipAddresses/ipAddress"></span>

`ipAddress`

* **Type:** `string`
* **Description:** Specifies the IP address. Use CIDR notation for subnet definition.

---

<span id="policy/ip-intelligence"></span>

## ip-intelligence

<span id="policy/ip-intelligence/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `false`

---

`ipIntelligenceCategories`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/ip-intelligence/ipIntelligenceCategories>)

---

<h3 id="policy/ip-intelligence/ipIntelligenceCategories"><code>ipIntelligenceCategories</code></h3>

<span id="policy/ip-intelligence/ipIntelligenceCategories/alarm"></span>

`alarm`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/ip-intelligence/ipIntelligenceCategories/block"></span>

`block`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/ip-intelligence/ipIntelligenceCategories/category"></span>

`category`

* **Type:** `string`
* **Allowed Values:** `Anonymous Proxy` | `BotNets` | `Cloud-based Services` | `Denial of Service` | `Infected Sources` | `Mobile Threats` | `Phishing Proxies` | `Scanners` | `Spam Sources` | `Tor Proxies` | `Web Attacks` | `Windows Exploits`

---

<span id="policy/json-profiles"></span>

## json-profiles

<span id="policy/json-profiles/attackSignaturesCheck"></span>

`attackSignaturesCheck`

* **Type:** `boolean`
* **Default:** `true`

---

`defenseAttributes`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/json-profiles/defenseAttributes>)

---

<span id="policy/json-profiles/description"></span>

`description`

* **Type:** `string`

---

<span id="policy/json-profiles/handleJsonValuesAsParameters"></span>

`handleJsonValuesAsParameters`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/json-profiles/hasValidationFiles"></span>

`hasValidationFiles`

* **Type:** `boolean`

---

<span id="policy/json-profiles/metacharElementCheck"></span>

`metacharElementCheck`

* **Type:** `boolean`
* **Default:** `true`

---

`metacharOverrides`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/json-profiles/metacharOverrides>)

---

<span id="policy/json-profiles/name"></span>

`name`

* **Type:** `string`

---

`signatureOverrides`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/json-profiles/signatureOverrides>)

---

`validationFiles`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/json-profiles/validationFiles>)

---

<h3 id="policy/json-profiles/defenseAttributes"><code>defenseAttributes</code></h3>

<span id="policy/json-profiles/defenseAttributes/maximumArrayLength"></span>

`maximumArrayLength`

* **Type:** `integer` | `string`
* **Default:** `1000`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/json-profiles/defenseAttributes/maximumStructureDepth"></span>

`maximumStructureDepth`

* **Type:** `integer` | `string`
* **Default:** `10`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/json-profiles/defenseAttributes/maximumTotalLengthOfJSONData"></span>

`maximumTotalLengthOfJSONData`

* **Type:** `integer` | `string`
* **Default:** `10000`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/json-profiles/defenseAttributes/maximumValueLength"></span>

`maximumValueLength`

* **Type:** `integer` | `string`
* **Default:** `100`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/json-profiles/defenseAttributes/tolerateJSONParsingWarnings"></span>

`tolerateJSONParsingWarnings`

* **Type:** `boolean`
* **Default:** `false`

---

<h3 id="policy/json-profiles/metacharOverrides"><code>metacharOverrides</code></h3>

<span id="policy/json-profiles/metacharOverrides/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`

---

<span id="policy/json-profiles/metacharOverrides/metachar"></span>

`metachar`

* **Type:** `string`

---

<h3 id="policy/json-profiles/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/json-profiles/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`

---

<span id="policy/json-profiles/signatureOverrides/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/json-profiles/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`

---

<span id="policy/json-profiles/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`

---

<h3 id="policy/json-profiles/validationFiles"><code>validationFiles</code></h3>

<span id="policy/json-profiles/validationFiles/importUrl"></span>

`importUrl`

* **Type:** `string`

---

<span id="policy/json-profiles/validationFiles/isPrimary"></span>

`isPrimary`

* **Type:** `boolean`

---

`jsonValidationFile`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/json-profiles/validationFiles/jsonValidationFile>)

---

<h4 id="policy/json-profiles/validationFiles/jsonValidationFile"><code>jsonValidationFile</code></h4>

<span id="policy/json-validation-files"></span>

## json-validation-files

<span id="policy/json-validation-files/contents"></span>

`contents`

* **Type:** `string`

---

<span id="policy/json-validation-files/fileName"></span>

`fileName`

* **Type:** `string`

---

<span id="policy/json-validation-files/isBase64"></span>

`isBase64`

* **Type:** `boolean`

---

<span id="policy/login-enforcement"></span>

## login-enforcement

<span id="policy/login-enforcement/authenticatedUrls"></span>

`authenticatedUrls`

* **Type:** `array of strings`
* **Default:** `[]`

---

<span id="policy/login-enforcement/expirationTimePeriod"></span>

`expirationTimePeriod`

* **Type:** `integer` | `string`
* **Default:** `disabled`
* **Allowed Values:** Integer values | `disabled`
* **Minimum:** `0`
* **Maximum:** `99999`

---

`logoutUrls`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/login-enforcement/logoutUrls>)

---

<h3 id="policy/login-enforcement/logoutUrls"><code>logoutUrls</code></h3>

<span id="policy/login-enforcement/logoutUrls/requestContains"></span>

`requestContains`

* **Type:** `string`

---

<span id="policy/login-enforcement/logoutUrls/requestOmits"></span>

`requestOmits`

* **Type:** `string`

---

<span id="policy/login-enforcement/logoutUrls/url"></span>

`url`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/urls>)

---

<span id="policy/login-pages"></span>

## login-pages

`accessValidation`

* **Type:** `object`
* **Description:** Access Validation define validation criteria for the login page response. If you define more than one validation criteria, the response must meet all the criteria before the system allows the user to access the application login URL.
* **Subfields:** [See fields](<#policy/login-pages/accessValidation>)

---

<span id="policy/login-pages/authenticationType"></span>

`authenticationType`

* **Type:** `string`
* **Default:** `none`
* **Allowed Values:** `ajax-or-json-request` | `form` | `http-basic` | `http-digest` | `none` | `ntlm` | `request-body`
* **Description:** Authentication Type is method the web server uses to authenticate the login URL's credentials with a web user.

  - **none**: The web server does not authenticate users trying to access the web application through the login URL. This is the default setting.
  - **form**: The web application uses a form to collect and authenticate user credentials. If using this option, you also need to type the user name and password parameters written in the code of the HTML form.
  - **http-basic**: The user name and password are transmitted in Base64 and stored on the server in plain text.
  - **http-digest**: The web server performs the authentication; user names and passwords are not transmitted over the network, nor are they stored in plain text.
  - **ntlm**: Microsoft LAN Manager authentication (also called Integrated Windows Authentication) does not transmit credentials in plain text, but requires a continuous TCP connection between the server and client.
  - **ajax-or-json-request**: The web server uses JSON and AJAX requests to authenticate users trying to access the web application through the login URL. For this option, you also need to type the name of the JSON element containing the user name and password.
  - **request-body**: The web server uses the request body to authenticate users trying to access the web application through the login URL. This allows brute force login detection using, for example, SAML authentication used on Microsoft Federation Services for SSO which uses SOAP API to login.

---

<span id="policy/login-pages/passwordParameterName"></span>

`passwordParameterName`

* **Type:** `string`
* **Description:** A name of parameter which will contain password string.

---

<span id="policy/login-pages/passwordRegex"></span>

`passwordRegex`

* **Type:** `string`
* **Description:** PCRE regular expression for capturing the password. The regular expression must include exactly one capturing group (in rounded parentheses) for the value of the password. For example: &quot;pwd=(\\w+)&quot;. The entered expression is validated and any invalid code is noted and must be corrected. Note: This setting is only relevant if authenticationType is request-body.

---

<span id="policy/login-pages/url"></span>

`url`

* **Type:** `object`
* **Description:** URL string used for login page.
* **Subfields:** [See fields](<#policy/urls>)

---

<span id="policy/login-pages/usernameParameterName"></span>

`usernameParameterName`

* **Type:** `string`
* **Description:** A name of parameter which will contain username string.

---

<span id="policy/login-pages/usernameRegex"></span>

`usernameRegex`

* **Type:** `string`
* **Description:** PCRE regular expression for capturing the username. The regular expression must include exactly one capturing group (in rounded parentheses) for the value of the username. For example: &quot;user\_id=(\\w+)&quot;. The entered expression is validated and any invalid code is noted and must be corrected. Note: This setting is only relevant if authenticationType is request-body.

---

<h3 id="policy/login-pages/accessValidation"><code>accessValidation</code></h3>

<span id="policy/login-pages/accessValidation/cookieContains"></span>

`cookieContains`

* **Type:** `string`
* **Description:** A defined domain cookie name that the response to the login URL must match to permit user access to the authenticated URL.

---

<span id="policy/login-pages/accessValidation/headerContains"></span>

`headerContains`

* **Type:** `string`
* **Description:** A header name and value that the response to the login URL must match to permit user access to the authenticated URL.

---

<span id="policy/login-pages/accessValidation/headerContainsMatchCondition"></span>

`headerContainsMatchCondition`

* **Type:** `string`
* **Default:** `exact`
* **Allowed Values:** `exact` | `regex`

---

<span id="policy/login-pages/accessValidation/headerOmits"></span>

`headerOmits`

* **Type:** `string`
* **Description:** A header name and value that indicates a failed login attempt and prohibits user access to the authenticated URL.

---

<span id="policy/login-pages/accessValidation/headerOmitsMatchCondition"></span>

`headerOmitsMatchCondition`

* **Type:** `string`
* **Default:** `exact`
* **Allowed Values:** `exact` | `regex`

---

<span id="policy/login-pages/accessValidation/parameterContains"></span>

`parameterContains`

* **Type:** `string`
* **Description:** A parameter that must exist in the login URL's HTML body to allow access to the authenticated URL.

---

<span id="policy/login-pages/accessValidation/responseContains"></span>

`responseContains`

* **Type:** `string`
* **Description:** A string that must appear in the response for the system to allow the user to access the authenticated URL; for example, &quot;Successful Login&quot;.

---

<span id="policy/login-pages/accessValidation/responseHttpStatus"></span>

`responseHttpStatus`

* **Type:** `string`
* **Description:** An HTTP response code that the server must return to the user to allow access to the authenticated URL; for example, &quot;200&quot;.

---

<span id="policy/login-pages/accessValidation/responseHttpStatusOmits"></span>

`responseHttpStatusOmits`

* **Type:** `array of strings`
* **Description:** An HTTP response code that indicates a failed login attempt and prohibits user access to the authenticated URL.

---

<span id="policy/login-pages/accessValidation/responseOmits"></span>

`responseOmits`

* **Type:** `string`
* **Description:** A string that indicates a failed login attempt and prohibits user access to the authenticated URL; for example, &quot;Authentication failed&quot;.

---

<span id="policy/methods"></span>

## methods

<span id="policy/methods/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/override-rules"></span>

## override-rules

<span id="policy/override-rules/actionType"></span>

`actionType`

* **Type:** `string`
* **Default:** `extend-policy`
* **Allowed Values:** `client-side-integrity` | `client-side-integrity-captcha` | `extend-policy` | `replace-policy` | `violation`
* **Description:** The action to take when the override rule is matched. Possible values are:

  - **extend-policy**: The override policy inherits the containing policy settings, allowing only the required settings to be overridden.
  - **replace-policy**: The override policy must be a valid declarative policy that includes a name, template and all necessary settings.
  - **violation**: The request is blocked and a the VIOL\_RULE is logged based on the provided violation settings.
  - **client-side-integrity**: The request is challenged using the existing Client-Side Integrity flow. The matching URL must be eligible for Client-Side Integrity qualification; responses that are not HTML cannot be qualified automatically.
  - **client-side-integrity-captcha**: The request is challenged using Client-Side Integrity first, then a CAPTCHA after a valid Client-Side Integrity replay. The matching URL must be eligible for Client-Side Integrity qualification; responses that are not HTML cannot be qualified automatically.

---

<span id="policy/override-rules/condition"></span>

`condition`

* **Type:** `string`
* **Description:** Specifies the condition under which the override rule should be applied.

  Example: &quot;clientIp \!= '10.0.0.5' and userAgent.lower().contains('WebRobot')&quot;

  Condition Syntax:

  - The condition consists of one or more clauses separated by **and** or **or**.

    Example: &quot;clientIp == '10.0.0.5' and (host.startsWith('internal') or uri.contains('api'))&quot;

  - Each clause can optionally start with **not** - to negate the expression.

    Example: &quot;not clientIp == '127.0.0.1'&quot;

  - **not** can also be used to negate a parenthesized expression.

    Example: &quot;not (method == 'GET' or method == 'PUT')&quot;

  - A clause can be a simple comparison between two value expressions, or a boolean function applied to a literal value.

  Supported comparison operators:

    - **==** - Checks for equality between two value expressions.
    - **\!=** - Checks for inequality between two value expressions.

    Example: &quot;clientIp \!= '10.0.0.5'&quot; (equivalent to &quot;not clientIp == '10.0.0.5'&quot;)

  Supported boolean functions:

    - **matches**: Performs an exact match of a value expression, equivalent to **==**.
    - **startsWith**: Checks if a value expression starts with a specific substring.
    - **contains**: Checks if a value expression contains a specific substring.

    Example: &quot;uri.startsWith('/api')&quot;

  **Note**: Functions &quot;startsWith&quot; and &quot;contains&quot; are not applicable to the &quot;clientIp&quot; attribute. Regular expressions are not supported.

  - Value expressions can be a request attribute, literal value, or a value function.
  - A literal can be a string value enclosed in single quotes, or can be the keyword &quot;null&quot; without quotes.

    Example: &quot;userAgent == null&quot;

  Supported value functions:

    - **lower**: Any boolean function applied on the resulting string will be **case insensitive**. Applicable to ANSI characters only.

    Example: &quot;uri.lower().contains('BaR')&quot; will match the URI &quot;/Foo/bAr&quot;

  Request Attributes:

  - **clientIp**: Client IP address in canonical IPv4 or IPv6 format or ip-address-list. Use CIDR notation for subnet definition. Example: *192.168.1.2* or *fd00:1::/48*. If *trustXff* (X-Forwarded-For) is enabled in the containing policy, then the value is taken from the configured header (XFF or other). The only supported boolean function for the clientIP attribute is *matches*.
  - **host**: The value of the Host header
  - **method**: The HTTP method in the request
  - **uri**: The URI (path part) of the request
  - **userAgent**: The value of the User-Agent header, or *null* (without quotes) if not present
  - **geolocation**: The geolocation of the client IP address. The value is the ISO 3166 two-letter code of the respective country.
  - **parameters\['&lt;name&gt;'\]**: (map-type) The value of the specified parameter name (limited to query string parameters). Example: &quot;parameters\['id'\] == '11'&quot;
  - **cookies\['&lt;name&gt;'\]**: (map-type) The value of the specified cookie name. Example: &quot;cookies\['Path'\].contains('product')&quot;
  - **headers\['&lt;name&gt;'\]**: (map-type) The value of the specified header name. Example: &quot;headers\['Accept'\].startsWith('application')&quot;

  **Note**: 
  - The &quot;headers\['&lt;name&gt;'\]&quot; attribute does not support 'Cookie' as a header name.
  - Attribute &quot;clientIp&quot; supports using &quot;ipAddressLists&quot; in condition: &quot;clientIp.matches(ipAddressLists\['&lt;name&gt;'\])&quot; 

---

<span id="policy/override-rules/name"></span>

`name`

* **Type:** `string`
* **Description:** The unique name of the override rule. Cannot contain spaces or special characters.

---

`override`

* **Type:** `object`
* **Description:** The overriding security policy definition.
* **Subfields:** [See fields](<#policy/override-rules/override>)

---

`violation`

* **Type:** `object`
* **Description:** Contains the details of the raised VIOL\_RULE violation.
  Mandatory if action-type is violation.
* **Subfields:** [See fields](<#policy/override-rules/violation>)

---

<h3 id="policy/override-rules/override"><code>override</code></h3>

<h3 id="policy/override-rules/violation"><code>violation</code></h3>

<span id="policy/override-rules/violation/alarm"></span>

`alarm`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Whether the violation should be marked in the security log and cause the request to be classified as &quot;illegal&quot;.

---

`attackType`

* **Type:** `object`
* **Description:** The attack type associated with the violation in the present rule. This is reflected in the security log.
  Mandatory.
* **Subfields:** [See fields](<#policy/override-rules/violation/attackType>)

---

<span id="policy/override-rules/violation/block"></span>

`block`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Whether the violation should cause the request to be blocked. On other words: the block flag of the VIOL\_RULE for the present rule.

---

<span id="policy/override-rules/violation/description"></span>

`description`

* **Type:** `string`
* **Description:** Textual description of the violation in the present rule.
  Limited to 200 characters.
  Not Mandatory.

---

<span id="policy/override-rules/violation/rating"></span>

`rating`

* **Type:** `integer`
* **Default:** `3`
* **Minimum:** `3`
* **Maximum:** `5`
* **Description:** The violation rating that the present rule violation  will induce. In other words, the violation rating of the request will be the maximum between this value and the calculated value based on the other violations in the request.
  If not specified and there is no other violation, then the VR is 3.

---

<h4 id="policy/override-rules/violation/attackType"><code>attackType</code></h4>

<span id="policy/override-rules/violation/attackType/name"></span>

`name`

* **Type:** `string`
* **Description:** The name of the attack type.
  Mandatory.

---

<span id="policy/parameters"></span>

## parameters

<span id="policy/parameters/allowEmptyValue"></span>

`allowEmptyValue`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether an empty value is allowed for a parameter.

---

<span id="policy/parameters/allowRepeatedParameterName"></span>

`allowRepeatedParameterName`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether multiple parameter instances with the same name are allowed in one request.

---

<span id="policy/parameters/arraySerializationFormat"></span>

`arraySerializationFormat`

* **Type:** `string`
* **Default:** `csv`
* **Allowed Values:** `csv` | `form` | `label` | `matrix` | `multi` | `multipart` | `pipe` | `ssv` | `tsv`
* **Description:** Specifies type of serialization for array of primitives parameter.
  Serialization defines how multiple values are delimited - format that can be transmitted and reconstructed later:

   - **pipe**: pipe-separated values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; color=blue\|black.
   - **form**: ampersand-separated values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; color=blue,black.
   - **matrix**: semicolon-prefixed values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; ;color=blue,black.
   - **tsv**: tab-separated values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; color=blue\\tblack.
   - **csv**: comma-separated values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; color=blue,black.
   - **label**: dot-prefixed values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; .blue.black.
   - **multi**: multiple parameter instances rather than multiple values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; color=blue&amp;color=black.
   - **ssv**: space-separated values. Array color=\[&quot;blue&quot;,&quot;black&quot;\] -&gt; color=blue black.
   - **multipart**: defines array of files.

  **Notes**:

   - This attribute is relevant only for parameters with **array** *valueType*.
   - **multi** and **form** serializations can be defined for parameter with *query*, *form-data* or *cookie* locations only.
   - **multipart** serialization can be defined for parameter with *form-data* location only.
   - **matrix** and **label** serializations can be defined for parameter with *path* location only.

---

<span id="policy/parameters/arrayUniqueItemsCheck"></span>

`arrayUniqueItemsCheck`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether items in an array parameter must be unique.
  This attribute is relevant only for parameters with **array** *valueType*.

---

<span id="policy/parameters/attackSignaturesCheck"></span>

`attackSignaturesCheck`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether attack signatures and threat campaigns must be detected in a parameter's value.
  This attribute is relevant only for parameters with **alpha-numeric** or **binary** *dataType*.

---

<span id="policy/parameters/checkMaxItemsInArray"></span>

`checkMaxItemsInArray`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether an array parameter has a restricted maximum number of items.
  This attribute is relevant only for parameters with **array** *valueType*.

---

<span id="policy/parameters/checkMaxValue"></span>

`checkMaxValue`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether the parameter has a restricted maximum value.
  This attribute is relevant only for parameters with **integer** or **decimal** *dataType*.

---

<span id="policy/parameters/checkMaxValueLength"></span>

`checkMaxValueLength`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter has a restricted maximum length for value.

---

<span id="policy/parameters/checkMetachars"></span>

`checkMetachars`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether disallowed metacharacters must be detected in a parameter's name.
  This attribute is relevant only for **wildcard** parameters with **alpha-numeric** *dataType*.

---

<span id="policy/parameters/checkMinItemsInArray"></span>

`checkMinItemsInArray`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether an array parameter has a restricted minimum number of items.
  This attribute is relevant only for parameters with **array** *valueType*.

---

<span id="policy/parameters/checkMinValue"></span>

`checkMinValue`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter has a restricted minimum value.
  This attribute is relevant only for parameters with **integer** or **decimal** *dataType*.

---

<span id="policy/parameters/checkMinValueLength"></span>

`checkMinValueLength`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter has a restricted minimum length for value.

---

<span id="policy/parameters/checkMultipleOfValue"></span>

`checkMultipleOfValue`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter's value is a multiple of a number defined in *multipleOf*.
  This attribute is relevant only for parameters with **integer** or **decimal** *dataType*.

---

`contentProfile`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/parameters/contentProfile>)

---

<span id="policy/parameters/dataType"></span>

`dataType`

* **Type:** `string`
* **Default:** `alpha-numeric`
* **Allowed Values:** `alpha-numeric` | `binary` | `phone` | `email` | `boolean` | `integer` | `decimal`
* **Description:** Specifies data type of parameter's value:

   - **alpha-numeric**: specifies that the value of parameter can be any text consisting of letters, digits, and the underscore character.
   - **binary**: specifies there is no text limit for the value of a parameter (length checks only).
   - **phone**: specifies that the value of a parameter can be text in telephone number format only.
   - **email**: specifies that the value of a parameter must be text in email format only.
   - **boolean**: specifies that the value of a parameter must be boolean (only *true* and  *false* values are allowed).
   - **integer**: specifies that the value of a parameter must be whole numbers only (no decimals).
   - **decimal**: specifies that the value of a parameter is numbers only and can include decimals.

  **Notes**:
  -  This attribute is relevant for parameters with **array** or **user-input** *valueType* only.

---

<span id="policy/parameters/decodeValueAsBase64"></span>

`decodeValueAsBase64`

* **Type:** `string`
* **Default:** `enabled`
* **Allowed Values:** `disabled` | `enabled` | `required`
* **Description:** Specifies whether the the system should detect or require values to be Base64 encoded:

   - **disabled**: the value will not be decoded as Base64 content.
   - **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value.
   - **required**: the value must be decoded as Base64. Security checks will be performed on the decoded value.

  **Notes**:
  -  This attribute is relevant for parameters with **binary**, **auto-detect**, or **user-input** *valueType* only.

---

<span id="policy/parameters/disallowFileUploadOfExecutables"></span>

`disallowFileUploadOfExecutables`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether a parameter's value cannot have binary executable content.
  This attribute is relevant only for parameters with **binary** *dataType*.

---

<span id="policy/parameters/enableRegularExpression"></span>

`enableRegularExpression`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether the parameter value includes the pattern defined in *regularExpression*.
  This attribute is relevant only for parameters with **alpha-numeric** *dataType*.

---

<span id="policy/parameters/exclusiveMax"></span>

`exclusiveMax`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether the maximum value defined in *maximumValue* attribute is exclusive.
  This attribute is relevant only if *checkMaxValue* is set to **true**.

---

<span id="policy/parameters/exclusiveMin"></span>

`exclusiveMin`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a minimum value defined in *minimumValue* attribute is exclusive.
  This attribute is relevant only if *checkMinValue* is set to **true**.

---

<span id="policy/parameters/explodeObjectSerialization"></span>

`explodeObjectSerialization`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies whether an array or object parameters should have separate values for each array item or object property.
  This attribute is relevant only if *objectSerializationStyle* is defined.

  **Notes**:
  -  This attribute is not relevant for parameters with **deep-object**, **space-delimited** or **pipe-delimited** *objectSerializationStyle*.

---

<span id="policy/parameters/hostNameRepresentation"></span>

`hostNameRepresentation`

* **Type:** `string`
* **Default:** `domain-name`
* **Allowed Values:** `any` | `domain-name` | `ip-address`

---

<span id="policy/parameters/isCookie"></span>

`isCookie`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter is located in the value of Cookie header.
  *parameterLocation* attribute is ignored if **isCookie** is set to *true*.

---

<span id="policy/parameters/isHeader"></span>

`isHeader`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter is located in headers as one of the headers.
  *parameterLocation* attribute is ignored if **isHeader** is set to *true*.

---

<span id="policy/parameters/level"></span>

`level`

* **Type:** `string`
* **Default:** `global`
* **Allowed Values:** `global` | `url`
* **Description:** Specifies whether the parameter is associated with a URL, a flow, or neither.

---

<span id="policy/parameters/mandatory"></span>

`mandatory`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter must exist in the request.

---

<span id="policy/parameters/maxItemsInArray"></span>

`maxItemsInArray`

* **Type:** `integer`
* **Default:** `100`
* **Minimum:** `0`
* **Description:** Determines the restriction for the maximum number of items in an array parameter.
  This attribute is relevant only if *checkMaxItemsInArray* is set to **true**.

---

<span id="policy/parameters/maximumLength"></span>

`maximumLength`

* **Type:** `integer`
* **Default:** `10`
* **Minimum:** `0`
* **Description:** Determines the restriction for the maximum length of parameter's value.
  This attribute is relevant only if *checkMaxValueLength* is set to **true**.

---

<span id="policy/parameters/maximumValue"></span>

`maximumValue`

* **Type:** `number`
* **Default:** `10`
* **Description:** Determines the restriction for the maximum value of parameter.
  This attribute is relevant only if *checkMaxValue* is set to **true**.

---

<span id="policy/parameters/metacharsOnParameterValueCheck"></span>

`metacharsOnParameterValueCheck`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Determines whether disallowed metacharacters must be detected in a parameter's value.
  This attribute is relevant only for parameters with **alpha-numeric** *dataType*.

---

<span id="policy/parameters/minItemsInArray"></span>

`minItemsInArray`

* **Type:** `integer`
* **Default:** `1`
* **Minimum:** `0`
* **Description:** Determines the restriction for the minimum number of items in an array parameter.
  This attribute is relevant only if *checkMinItemsInArray* is set to **true**.

---

<span id="policy/parameters/minimumLength"></span>

`minimumLength`

* **Type:** `integer`
* **Default:** `0`
* **Minimum:** `0`
* **Description:** Determines the restriction for the minimum length of parameter's value.
  This attribute is relevant only if *checkMinValueLength* is set to **true**.

---

<span id="policy/parameters/minimumValue"></span>

`minimumValue`

* **Type:** `number`
* **Default:** `0`
* **Description:** Determines the restriction for the minimum value of a parameter.
  This attribute is relevant only if *checkMinValue* is set to **true**.

---

<span id="policy/parameters/multipleOf"></span>

`multipleOf`

* **Type:** `number`
* **Default:** `5`
* **Description:** Determines the number by which a parameter's value is divisible without remainder.
  This number must be positive and it may be a floating-point number.
  This attribute is relevant only if *checkMultipleOfValue* is set to **true**.

---

<span id="policy/parameters/name"></span>

`name`

* **Type:** `string`
* **Description:** Specifies the name of a parameter which must be permitted in requests.
  Format of parameter name attribute differs depending on *type* attribute:
   - **explicit** *type*: name of permitted parameter in request should literally match.
   - **wildcard** *type*: name of permitted parameter in request should match wildcard expression.

  The syntax for wildcard entities is based on shell-style wildcard characters.
  The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.

   - **\***: Matches all characters
   - **?**: Matches any single character
   - **\[abcde\]**: Matches exactly one of the characters listed
   - **\[\!abcde\]**: Matches any character not listed
   - **\[a-e\]**: Matches exactly one character in the range
   - **\[\!a-e\]**: Matches any character not in the range

  **Notes**:
   - Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.
   - Empty parameter name is allowed for **explicit** *type*

---

`nameMetacharOverrides`

* **Type:** `array of objects`
* **Description:** Determines metacharacters whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request for this parameter that has these metacharacters in the name.
  This attribute is relevant only if *checkMetachars* is set to **true**.
* **Subfields:** [See fields](<#policy/parameters/nameMetacharOverrides>)

---

<span id="policy/parameters/objectSerializationStyle"></span>

`objectSerializationStyle`

* **Type:** `string`
* **Default:** `simple`
* **Allowed Values:** `deep-object` | `form` | `label` | `matrix` | `pipe-delimited` | `simple` | `space-delimited`
* **Description:** Specifies the type of serialization for an object or complex array parameter.
  Serialization defines how multiple values are delimited - format that can be transmitted and reconstructed later:

   - **pipe-delimited**: pipe-separated values. Object color=\{&quot;R&quot;:100,&quot;G&quot;:200\} -&gt; color=R\|100\|G\|200.
   - **form**: ampersand-separated values. Object color=\{&quot;R&quot;:100,&quot;G&quot;:200\} -&gt; color=R,100,G,200 if *explodeObjectSerialization* set to **false** or -&gt; R=100&amp;G=200 if *explodeObjectSerialization* set to **true**.
   - **space-delimited**: space-separated values. Object color=\{&quot;R&quot;:100,&quot;G&quot;:200\} -&gt; color=R 100 G 200.
   - **deep-object**: rendering nested objects. Object color=\{&quot;R&quot;:100,&quot;G&quot;:200\} -&gt; color\[R\]=100&amp;color\[G\]=200.
   - **matrix**: semicolon-prefixed values. Object color=\{&quot;R&quot;:100,&quot;G&quot;:200\} -&gt; ;color=R,100,G,200 if *explodeObjectSerialization* set to **false** or -&gt; ;R=100;G=200 if *explodeObjectSerialization* set to **true**.
   - **simple**: comma-separated values. Object color=\{&quot;R&quot;:100,&quot;G&quot;:200\} -&gt; R,100,G,200 if *explodeObjectSerialization* set to **false** or -&gt; R=100,G=200 if *explodeObjectSerialization* set to **true**.
   - **label**: dot-prefixed values. Object color=\{&quot;R&quot;:100,&quot;G&quot;:200\} -&gt; .R.100.G.200 if *explodeObjectSerialization* set to **false** or -&gt; .R=100.G=200 if *explodeObjectSerialization* set to **true**.

  **Notes**:

   - This attribute is relevant only for parameters with **object** or **openapi-array** *valueType*.
   - **form** serialization can be defined for a parameter with *query*, *form-data* or *cookie* locations only.
   - **matrix** and **label** serializations can be defined for an array parameter with *path* location only.
   - **simple** serializations can be defined for a parameter with *path* and *header* locations only.
   - **deep-object** serialization can be defined for a parameter with *query* or *form-data* locations only.

---

<span id="policy/parameters/parameterEnumValues"></span>

`parameterEnumValues`

* **Type:** `array of strings`
* **Description:** Determines the set of possible parameter's values.
  This attribute is not relevant for parameters with **phone**, **email** or **binary** *dataType*.

---

<span id="policy/parameters/parameterLocation"></span>

`parameterLocation`

* **Type:** `string`
* **Default:** `any`
* **Allowed Values:** `any` | `cookie` | `form-data` | `header` | `path` | `query`
* **Description:** Specifies location of parameter in request:

   - **any**: in query string, in POST data (body) or in URL path.
   - **query**: in query string.
   - **form-data**: in POST data (body).
   - **cookie**: in value of Cookie header.
   - **path**: in URL path.
   - **header**: in request headers.

  **Notes**:
   - **path** location can be defined for parameter with **global** *level* only.
   - **path**, **header** and **cookie** location can be defined for parameter with **explicit** *type* only.
   - **header** and **cookie** location cannot be defined for parameter with empty *name*.

---

<span id="policy/parameters/regularExpression"></span>

`regularExpression`

* **Type:** `string`
* **Description:** Determines a positive regular expression (PCRE) for a parameter's value.
  This attribute is relevant only if *enableRegularExpression* is set to **true**.

  **Notes**:
   - The length of a regular expression is limited to 254 characters.

---

<span id="policy/parameters/sensitiveParameter"></span>

`sensitiveParameter`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Determines whether a parameter is sensitive and must be not visible in logs nor in the user interface.
  Instead of the actual value, a string of asterisks is shown for this parameter.
  Use it to protect sensitive user input, such as a password or a credit card number, in a validated request.

---

`signatureOverrides`

* **Type:** `array of objects`
* **Description:** Determines attack signatures whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request for this parameter that matches these attack signatures.
  This attribute is relevant only if *signatureOverrides* is set to **true**.
* **Subfields:** [See fields](<#policy/parameters/signatureOverrides>)

---

<span id="policy/parameters/staticValues"></span>

`staticValues`

* **Type:** `array of strings`
* **Description:** Determines the set of possible parameter's values.
  This attribute is relevant for parameters with **static-content** *valueType* only.

---

<span id="policy/parameters/type"></span>

`type`

* **Type:** `string`
* **Default:** `explicit`
* **Allowed Values:** `explicit` | `wildcard`
* **Description:** Specifies the type of the *name* attribute.

---

<span id="policy/parameters/url"></span>

`url`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/urls>)

---

`valueMetacharOverrides`

* **Type:** `array of objects`
* **Description:** Determines metacharacters whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request parameter that has these metacharacters in its value.
  This attribute is relevant only if *metacharsOnParameterValueCheck* is set to **true**.
* **Subfields:** [See fields](<#policy/parameters/valueMetacharOverrides>)

---

<span id="policy/parameters/valueType"></span>

`valueType`

* **Type:** `string`
* **Default:** `user-input`
* **Allowed Values:** `array` | `auto-detect` | `ignore` | `json` | `object` | `openapi-array` | `static-content` | `user-input` | `xml`
* **Description:** Specifies type of parameter's value:

   - **object**: the parameter's value is complex object defined by JSON schema.
   - **dynamic-content**: the parameter's content changes dynamically.
   - **openapi-array**: the parameter's value is complex array defined by JSON schema.
   - **ignore**: the system does not perform validity checks on the value of the parameter.
   - **static-content**: the parameter has a static, or pre-defined, value(s).
   - **json**: the parameter's value is JSON data.
   - **array**: the parameter's value is array of primitives.
   - **user-input**: the parameter's value is provided by user-input.
   - **xml**: the parameter's value is XML data.
   - **auto-detect**: the parameter's value can be user-input, XML data or JSON data. The system automatically classifies the type of value.
   - **dynamic-parameter-name**: the parameter's name changes dynamically.

  **Notes**:
   - **dynamic-parameter-name** value type can be defined for a parameter with **flow** *level* and **explicit** *type* only.
   - **dynamic-content** value type can be defined for a parameter with **explicit** *type* only.

---

<span id="policy/parameters/wildcardOrder"></span>

`wildcardOrder`

* **Type:** `integer`
* **Description:** Specifies the order in which wildcard entities are organized.
  Matching of an enforced parameter with a defined wildcard parameter happens based on order from smaller to larger.

---

<h3 id="policy/parameters/contentProfile"><code>contentProfile</code></h3>

`contentProfile`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/parameters/contentProfile/contentProfile>)

---

<h4 id="policy/parameters/contentProfile/contentProfile"><code>contentProfile</code></h4>

<span id="policy/parameters/contentProfile/contentProfile/name"></span>

`name`

* **Type:** `string`

---

<h3 id="policy/parameters/nameMetacharOverrides"><code>nameMetacharOverrides</code></h3>

<span id="policy/parameters/nameMetacharOverrides/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`
* **Description:** Specifies permission of *metachar* - when *false*, then character is prohibited.

---

<span id="policy/parameters/nameMetacharOverrides/metachar"></span>

`metachar`

* **Type:** `string`
* **Description:** Specifies character in hexadecimal format with special allowance.

---

<h3 id="policy/parameters/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/parameters/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Description:** Specifies, when true, that the overridden signature is enforced

---

<span id="policy/parameters/signatureOverrides/name"></span>

`name`

* **Type:** `string`
* **Description:** The signature name which, along with the signature tag, identifies the signature.

---

<span id="policy/parameters/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`
* **Description:** The signature ID which identifies the signature.

---

<span id="policy/parameters/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`
* **Description:** The signature tag which, along with the signature name, identifies the signature.

---

<h3 id="policy/parameters/valueMetacharOverrides"><code>valueMetacharOverrides</code></h3>

<span id="policy/parameters/valueMetacharOverrides/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`
* **Description:** Specifies permission of *metachar* - when *false*, then character is prohibited.

---

<span id="policy/parameters/valueMetacharOverrides/metachar"></span>

`metachar`

* **Type:** `string`
* **Description:** Specifies character in hexadecimal format with special allowance.

---

<span id="policy/response-pages"></span>

## response-pages

<span id="policy/response-pages/ajaxActionType"></span>

`ajaxActionType`

* **Type:** `string`
* **Default:** `redirect`
* **Allowed Values:** `alert-popup` | `custom` | `redirect`
* **Description:** Which content, or URL, the system sends to the client as a response to an AJAX request that does not comply with the security policy.
  - **alert-popup**: The system opens a message as a popup screen. Type the message the system displays in the popup screen, or leave the default text.
  - **custom**: A response text that will replace the frame or page which generated the AJAX request. The system provides additional options where you can type the response body you prefer.
  - **redirect**: The system redirects the user to a specific web page instead of viewing a response page. Type the web page's full URL path, for example, [http://www.redirectpage.com](<http://www.redirectpage.com>). 

---

<span id="policy/response-pages/ajaxCustomContent"></span>

`ajaxCustomContent`

* **Type:** `string`
* **Description:** Custom message typed by user as a response for blocked AJAX request.

---

<span id="policy/response-pages/ajaxEnabled"></span>

`ajaxEnabled`

* **Type:** `boolean`
* **Description:** When enabled, the system injects JavaScript code into responses. You must enable this toggle in order to configure an Application Security Manager AJAX response page which is returned when the system detects an AJAX request that does not comply with the security policy.

---

<span id="policy/response-pages/ajaxPopupMessage"></span>

`ajaxPopupMessage`

* **Type:** `string`
* **Description:** Default message provided by the system as a response for blocked AJAX request. Can be manipulated by user, but &lt;%TS.request.ID()%&gt; must be included in this message.

---

<span id="policy/response-pages/ajaxRedirectUrl"></span>

`ajaxRedirectUrl`

* **Type:** `string`
* **Description:** The system redirects the user to a specific web page instead of viewing a response page. Type the web page's full URL path, for example, [http://www.redirectpage.com](<http://www.redirectpage.com>). To redirect the blocking page to a URL with a support ID in the query string, type the URL and the support ID in the following format: [http://www.example.com/blocking\_page.php?support\_id=](<http://www.example.com/blocking_page.php?support_id=>)&lt;%TS.request.ID()%&gt;. The system replaces &lt;%TS.request.ID%&gt; with the relevant support ID so that the blocked request is redirected to the URL with the relevant support ID.

---

<span id="policy/response-pages/grpcStatusCode"></span>

`grpcStatusCode`

* **Type:** `integer` | `string`
* **Default:** `UNKNOWN`
* **Allowed Values:** Integer values | `ABORTED` | `ALREADY_EXISTS` | `CANCELLED` | `DATA_LOSS` | `DEADLINE_EXCEEDED` | `FAILED_PRECONDITION` | `INTERNAL` | `INVALID_ARGUMENT` | `NOT_FOUND` | `OK` | `OUT_OF_RANGE` | `PERMISSION_DENIED` | `RESOURCE_EXHAUSTED` | `UNAUTHENTICATED` | `UNAVAILABLE` | `UNIMPLEMENTED` | `UNKNOWN`

---

<span id="policy/response-pages/grpcStatusMessage"></span>

`grpcStatusMessage`

* **Type:** `string`

---

<span id="policy/response-pages/responseActionType"></span>

`responseActionType`

* **Type:** `string`
* **Default:** `default`
* **Allowed Values:** `custom` | `default` | `erase-cookies` | `redirect` | `soap-fault`
* **Description:** Which action the system takes, and which content the system sends to the client, as a response when the security policy blocks the client request.
  - **custom**: The system returns a response page with HTML code that the user defines.
  - **default**: The system returns the system-supplied response page in HTML. No further configuration is needed.
  - **erase-cookies**:  The system deletes all client side domain cookies. This is done in order to block web application users once, and not from the entire web application. The system displays this text in the response page. You cannot edit this text.
  - **redirect**: The system redirects the user to a specific web page instead of viewing a response page. The system provides an additional setting where you can indicate the redirect web page.
  - **soap-fault**:  Displays the system-supplied response written in SOAP fault message structure. Use this type when a SOAP request is blocked due to an XML related violation. You cannot edit this text.

---

<span id="policy/response-pages/responseContent"></span>

`responseContent`

* **Type:** `string`
* **Description:** The content the system sends to the client in response to an illegal blocked request.

---

<span id="policy/response-pages/responseHeader"></span>

`responseHeader`

* **Type:** `string`
* **Description:** The response headers that the system sends to the client as a response to an illegal blocked request.

---

<span id="policy/response-pages/responsePageType"></span>

`responsePageType`

* **Type:** `string`
* **Default:** `default`
* **Allowed Values:** `ajax` | `default` | `graphql` | `grpc` | `xml`
* **Description:** The different types of blocking response pages which are available from the system:
  - **ajax**: The system sends the AJAX Blocking Response Page when the security policy blocks an AJAX request that does not comply with the security policy.
  - **default**: The system sends the default response when the security policy blocks a client request.
  - **graphql**: The system sends the GraphQL response when the security policy blocks a client request that contains GraphQL message that does not comply with the settings of a GraphQL profile configured in the security policy.
  - **grpc**: The system sends the gRPC response when the security policy blocks a client request that contains gRPC message that does not comply with the settings of a gRPC profile configured in the security policy.
  - **xml**: The system sends the XML response page when the security policy blocks a client request that contains XML content that does not comply with the settings of an XML profile configured in the security policy.

---

<span id="policy/response-pages/responseRedirectUrl"></span>

`responseRedirectUrl`

* **Type:** `string`
* **Description:** The particular URL to which the system redirects the user. To redirect the blocking page to a URL with a support ID in the query string, type the URL and the support ID in the following format: [http://www.example.com/blocking\_page.php?support\_id=](<http://www.example.com/blocking_page.php?support_id=>)&lt;%TS.request.ID()%&gt;. The system replaces &lt;%TS.request.ID%&gt; with the relevant support ID so that the blocked request is redirected to the URL with the relevant support ID.

---

<span id="policy/sensitive-parameters"></span>

## sensitive-parameters

<span id="policy/sensitive-parameters/name"></span>

`name`

* **Type:** `string`
* **Description:** Name of a parameter whose values the system should consider sensitive.

---

<span id="policy/server-technologies"></span>

## server-technologies

<span id="policy/server-technologies/serverTechnologyName"></span>

`serverTechnologyName`

* **Type:** `string`
* **Allowed Values:** `ASP` | `ASP.NET` | `AngularJS` | `Apache Struts` | `Apache Tomcat` | `Apache/NCSA HTTP Server` | `BEA Systems WebLogic Server` | `Backbone.js` | `CGI` | `Cisco` | `Citrix` | `CodeIgniter` | `CouchDB` | `Django` | `Elasticsearch` | `Ember.js` | `Express.js` | `Front Page Server Extensions (FPSE)` | `Google Web Toolkit` | `GraphQL` | `Handlebars` | `IBM DB2` | `IIS` | `JBoss` | `Java Servlets/JSP` | `JavaScript` | `JavaServer Faces (JSF)` | `Jenkins` | `Jetty` | `Joomla` | `Laravel` | `Lotus Domino` | `Macromedia ColdFusion` | `Macromedia JRun` | `Microsoft SQL Server` | `Microsoft Windows` | `MongoDB` | `MooTools` | `Mustache` | `MySQL` | `Neo4J` | `Nginx` | `Node.js` | `Novell` | `Oracle` | `Oracle Application Server` | `Oracle Identity Manager` | `Outlook Web Access` | `PHP` | `PostgreSQL` | `Prototype` | `Proxy Servers` | `Python` | `React` | `Redis` | `RequireJS` | `Ruby` | `SQLite` | `SSI (Server Side Includes)` | `SharePoint` | `Spring Boot` | `Svelte` | `Sybase/ASE` | `TYPO3 CMS` | `UIKit` | `Underscore.js` | `Unix/Linux` | `Vue.js` | `WebDAV` | `WordPress` | `XML` | `ZURB Foundation` | `Zend` | `ef.js` | `jQuery`
* **Description:** Specifies the name of the selected policy. For example, PHP will add attack signatures that cover known PHP vulnerabilities.

---

<span id="policy/signature-requirements"></span>

## signature-requirements

<span id="policy/signature-requirements/maxRevisionDatetime"></span>

`maxRevisionDatetime`

* **Type:** `string`

---

<span id="policy/signature-requirements/minRevisionDatetime"></span>

`minRevisionDatetime`

* **Type:** `string`

---

<span id="policy/signature-requirements/tag"></span>

`tag`

* **Type:** `string`

---

<span id="policy/signature-sets"></span>

## signature-sets

<span id="policy/signature-sets/alarm"></span>

`alarm`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If enabled - when a signature from this signature set is detected in a request - the request is logged.

---

<span id="policy/signature-sets/block"></span>

`block`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If enabled - when a signature from this signature set is detected in a request - the request is blocked.

---

<span id="policy/signature-sets/learn"></span>

`learn`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If enabled - when a signature from this signature set is detected in a request -the policy builder creates a learning suggestion to disable it.

---

<span id="policy/signature-sets/name"></span>

`name`

* **Type:** `string`
* **Allowed Values:** `All Response Signatures` | `All Signatures` | `Authentication/Authorization Attack Signatures` | `Buffer Overflow Signatures` | `CVE Signatures` | `Command Execution Signatures` | `Cross Site Scripting Signatures` | `Denial of Service Signatures` | `Directory Indexing Signatures` | `Generic Detection Signatures` | `Generic Detection Signatures (High Accuracy)` | `Generic Detection Signatures (High/Medium Accuracy)` | `HTTP Response Splitting Signatures` | `High Accuracy Detection Evasion Signatures` | `High Accuracy Signatures` | `Information Leakage Signatures` | `Low Accuracy Signatures` | `Medium Accuracy Signatures` | `OS Command Injection Signatures` | `OWA Signatures` | `Other Application Attacks Signatures` | `Path Traversal Signatures` | `Predictable Resource Location Signatures` | `Remote File Include Signatures` | `SQL Injection Signatures` | `Server Side Code Injection Signatures` | `Vulnerability Scan Signatures` | `WebSphere signatures` | `XML External Entities (XXE) Signatures` | `XPath Injection Signatures`
* **Description:** Signature set name.

---

`signatureSet`

* **Type:** `object`
* **Description:** Defines signature set.
* **Subfields:** [See fields](<#policy/signature-sets/signatureSet>)

---

<span id="policy/signature-sets/stagingCertificationDatetime"></span>

`stagingCertificationDatetime`

* **Type:** `string`

---

<h3 id="policy/signature-sets/signatureSet"><code>signatureSet</code></h3>

`filter`

* **Type:** `object`
* **Description:** Specifies filter that defines signature set.
* **Subfields:** [See fields](<#policy/signature-sets/signatureSet/filter>)

---

`signatures`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/signature-sets/signatureSet/signatures>)

---

`systems`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/signature-sets/signatureSet/systems>)

---

<span id="policy/signature-sets/signatureSet/type"></span>

`type`

* **Type:** `string`
* **Default:** `filter-based`
* **Allowed Values:** `filter-based` | `manual`

---

<h4 id="policy/signature-sets/signatureSet/filter"><code>filter</code></h4>

<span id="policy/signature-sets/signatureSet/filter/accuracyFilter"></span>

`accuracyFilter`

* **Type:** `string`
* **Allowed Values:** `all` | `eq` | `ge` | `le`

---

<span id="policy/signature-sets/signatureSet/filter/accuracyValue"></span>

`accuracyValue`

* **Type:** `string`
* **Allowed Values:** `all` | `high` | `low` | `medium`

---

`attackType`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/signature-sets/signatureSet/filter/attackType>)

---

<span id="policy/signature-sets/signatureSet/filter/hasCve"></span>

`hasCve`

* **Type:** `string`
* **Default:** `all`
* **Allowed Values:** `all` | `no` | `yes`

---

<span id="policy/signature-sets/signatureSet/filter/lastUpdatedFilter"></span>

`lastUpdatedFilter`

* **Type:** `string`
* **Allowed Values:** `after` | `all` | `before`

---

<span id="policy/signature-sets/signatureSet/filter/lastUpdatedValue"></span>

`lastUpdatedValue`

* **Type:** `string`
* **Default:** `1970-01-01`

---

<span id="policy/signature-sets/signatureSet/filter/riskFilter"></span>

`riskFilter`

* **Type:** `string`
* **Allowed Values:** `all` | `eq` | `ge` | `le`

---

<span id="policy/signature-sets/signatureSet/filter/riskValue"></span>

`riskValue`

* **Type:** `string`
* **Allowed Values:** `all` | `high` | `low` | `medium`

---

<span id="policy/signature-sets/signatureSet/filter/signatureType"></span>

`signatureType`

* **Type:** `string`
* **Default:** `request`
* **Allowed Values:** `all` | `request` | `response`

---

<span id="policy/signature-sets/signatureSet/filter/tagFilter"></span>

`tagFilter`

* **Type:** `string`
* **Default:** `all`
* **Allowed Values:** `all` | `eq` | `untagged`
* **Description:** Filter by signature tagValue.

  - **all**: no filter applied.
  - **eq**: only signatures with a tag that equals tagValue are added to the signature set.
  - **untagged**: only signatures without a tag are added to the signature set.

---

<span id="policy/signature-sets/signatureSet/filter/tagValue"></span>

`tagValue`

* **Type:** `string`
* **Description:** Value for the tagFilter.
  Relevant only for the **eq** value of tagFilter.

---

<span id="policy/signature-sets/signatureSet/filter/userDefinedFilter"></span>

`userDefinedFilter`

* **Type:** `string`
* **Default:** `all`
* **Allowed Values:** `all` | `no` | `yes`

---

<h5 id="policy/signature-sets/signatureSet/filter/attackType"><code>attackType</code></h5>

<span id="policy/signature-sets/signatureSet/filter/attackType/name"></span>

`name`

* **Type:** `string`

---

<h4 id="policy/signature-sets/signatureSet/signatures"><code>signatures</code></h4>

<span id="policy/signature-sets/signatureSet/signatures/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/signature-sets/signatureSet/signatures/signatureId"></span>

`signatureId`

* **Type:** `integer`

---

<span id="policy/signature-sets/signatureSet/signatures/tag"></span>

`tag`

* **Type:** `string`

---

<h4 id="policy/signature-sets/signatureSet/systems"><code>systems</code></h4>

<span id="policy/signature-sets/signatureSet/systems/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/signature-settings"></span>

## signature-settings

<span id="policy/signature-settings/minimumAccuracyForAutoAddedSignatures"></span>

`minimumAccuracyForAutoAddedSignatures`

* **Type:** `string`
* **Default:** `medium`
* **Allowed Values:** `high` | `low` | `medium`

---

<span id="policy/signature-settings/signatureStaging"></span>

`signatureStaging`

* **Type:** `boolean`
* **Default:** `false`
* **Schema default:** `true`

---

<span id="policy/signature-settings/stagingCertificationDatetime"></span>

`stagingCertificationDatetime`

* **Type:** `string`

---

<span id="policy/signatures"></span>

## signatures

<span id="policy/signatures/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Specifies, if true, that the signature is enabled on the security policy. When false, the signature is disable on the security policy.

---

<span id="policy/signatures/learn"></span>

`learn`

* **Type:** `boolean`

---

<span id="policy/signatures/name"></span>

`name`

* **Type:** `string`
* **Description:** The signature name which, along with the signature tag, identifies the signature.

---

<span id="policy/signatures/performStaging"></span>

`performStaging`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Specifies, if true, that the signature is in staging.
  The system does not enforce signatures in staging. Instead, the system records the request information and keeps it for a period of time
  (the Enforcement Readiness Period whose default time period is 7 days).
  Specifies, when false, that the staging feature is not in use, and that the system enforces the signatures' Learn/Alarm/Block settings immediately.
  (Blocking is performed only if the security policy's enforcement mode is Blocking.)

---

<span id="policy/signatures/signatureId"></span>

`signatureId`

* **Type:** `integer`
* **Description:** The signature ID which identifies the signature.

---

<span id="policy/signatures/tag"></span>

`tag`

* **Type:** `string`
* **Description:** The signature tag which, along with the signature name, identifies the signature.       

---

<span id="policy/threat-campaigns"></span>

## threat-campaigns

<span id="policy/threat-campaigns/displayName"></span>

`displayName`

* **Type:** `string`

---

<span id="policy/threat-campaigns/isEnabled"></span>

`isEnabled`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If enabled - threat campaign is enforced in the security policy.

---

<span id="policy/threat-campaigns/name"></span>

`name`

* **Type:** `string`
* **Description:** Name of the threat campaign.

---

<span id="policy/urls"></span>

## urls

<span id="policy/urls/accessProfile"></span>

`accessProfile`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/access-profiles>)

---

<span id="policy/urls/allowRenderingInFrames"></span>

`allowRenderingInFrames`

* **Type:** `string`
* **Default:** `never`
* **Allowed Values:** `never` | `only-same`
* **Description:** Specifies the conditions for when the browser should allow this URL to be rendered in a frame or iframe.
  never: Specifies that this URL must never be rendered in a frame or iframe. The web application instructs browsers to hide, or disable, frame and iframe parts of this URL.
  only-same: Specifies that the browser may load the frame or iframe if the referring page is from the same protocol, port, and domain as this URL. This limits the user to navigate only within the same web application.

---

<span id="policy/urls/allowRenderingInFramesOnlyFrom"></span>

`allowRenderingInFramesOnlyFrom`

* **Type:** `string`
* **Description:** Specifies that the browser may load the frame or iframe from a specified domain. Type the protocol and domain in URL format for example, [http://www.mywebsite.com](<http://www.mywebsite.com>). Do not enter a sub-URL, such as [http://www.mywebsite.com/index](<http://www.mywebsite.com/index>).

---

<span id="policy/urls/attackSignaturesCheck"></span>

`attackSignaturesCheck`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Specifies, when true, that you want attack signatures and threat campaigns to be detected on this URL and possibly override the security policy settings of an attack signature or threat campaign specifically for this URL. After you enable this setting, the system displays a list of attack signatures and threat campaigns.

---

`authorizationRules`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/urls/authorizationRules>)

---

<span id="policy/urls/canChangeDomainCookie"></span>

`canChangeDomainCookie`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/urls/clickjackingProtection"></span>

`clickjackingProtection`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies that the system adds the X-Frame-Options header to the domain URL's response header. This is done to protect the web application against clickjacking. Clickjacking occurs when an attacker lures a user to click illegitimate frames and iframes because the attacker hid them on legitimate visible website buttons. Therefore, enabling this option protects the web application from other web sites hiding malicious code behind them. The default is disabled. After you enable this option, you can select whether, and under what conditions, the browser should allow this URL to be rendered in a frame or iframe.

---

<span id="policy/urls/disallowFileUploadOfExecutables"></span>

`disallowFileUploadOfExecutables`

* **Type:** `boolean`
* **Default:** `false`

---

`html5CrossOriginRequestsEnforcement`

* **Type:** `object`
* **Description:** The system extracts the Origin (domain) of the request from the Origin header.
* **Subfields:** [See fields](<#policy/urls/html5CrossOriginRequestsEnforcement>)

---

<span id="policy/urls/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If *true*, the URLs allowed by the security policy.

---

<span id="policy/urls/mandatoryBody"></span>

`mandatoryBody`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** A request body is mandatory. This is relevant for any method acting as POST.

---

`metacharOverrides`

* **Type:** `array of objects`
* **Description:** To allow or disallow specific meta characters in the name of this specific URL (and thus override the global meta character settings).
* **Subfields:** [See fields](<#policy/urls/metacharOverrides>)

---

<span id="policy/urls/metacharsOnUrlCheck"></span>

`metacharsOnUrlCheck`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Specifies, when true, that you want meta characters to be detected on this URL and possibly override the security policy settings of a meta character specifically for this URL. After you enable this setting, the system displays a list of meta characters.

---

<span id="policy/urls/method"></span>

`method`

* **Type:** `string`
* **Default:** `*`
* **Allowed Values:** `ACL` | `BCOPY` | `BDELETE` | `BMOVE` | `BPROPFIND` | `BPROPPATCH` | `CHECKIN` | `CHECKOUT` | `CONNECT` | `COPY` | `DELETE` | `GET` | `HEAD` | `LINK` | `LOCK` | `MERGE` | `MKCOL` | `MKWORKSPACE` | `MOVE` | `NOTIFY` | `OPTIONS` | `PATCH` | `POLL` | `POST` | `PROPFIND` | `PROPPATCH` | `PUT` | `REPORT` | `RPC_IN_DATA` | `RPC_OUT_DATA` | `SEARCH` | `SUBSCRIBE` | `TRACE` | `TRACK` | `UNLINK` | `UNLOCK` | `UNSUBSCRIBE` | `VERSION_CONTROL` | `X-MS-ENUMATTS` | `*`
* **Description:** Unique ID of a URL with a protocol type and name. Select a Method for the URL to create an API endpoint: URL + Method.

---

`methodOverrides`

* **Type:** `array of objects`
* **Description:** Specifies a list of methods that are allowed or disallowed for a specific URL. The list overrides the list of methods allowed or disallowed globally at the policy level.
* **Subfields:** [See fields](<#policy/urls/methodOverrides>)

---

<span id="policy/urls/methodsOverrideOnUrlCheck"></span>

`methodsOverrideOnUrlCheck`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Specifies, when true, that you want methods to be detected on this URL and possibly override the security policy settings of a method specifically for this URL. After you enable this setting, the system displays a list of methods.

---

<span id="policy/urls/name"></span>

`name`

* **Type:** `string`
* **Description:** Specifies an HTTP URL that the security policy allows. The available types are:

  - **Explicit**: Specifies that the URL has a specific name and is not a wildcard entity. Type the name of a URL exactly as you expect it to appear in the request.
  - **Wildcard**: Specifies that any URL that matches the listed wildcard expression should be treated according to the wildcard attributes. Type a wildcard expression that matches the expected URL. For example, entering the wildcard expression * specifies that any URL is allowed by the security policy.
  The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.

  - **\***: Matches all characters
  - **?**: Matches any single character
  - **\[abcde\]**: Matches exactly one of the characters listed
  - **\[\!abcde\]**: Matches any character not listed
  - **\[a-e\]**: Matches exactly one character in the range
  - **\[\!a-e\]**: Matches any character not in the range

  **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.

---

<span id="policy/urls/operationId"></span>

`operationId`

* **Type:** `string`
* **Description:** The attribute operationId is used as an OpenAPI endpoint identifier.

---

`positionalParameters`

* **Type:** `array of objects`
* **Description:** When checked (enabled), positional parameters are enabled in the URL.
* **Subfields:** [See fields](<#policy/urls/positionalParameters>)

---

<span id="policy/urls/protocol"></span>

`protocol`

* **Type:** `string`
* **Default:** `http`
* **Allowed Values:** `http` | `https`
* **Description:** Specifies whether the protocol for the URL is HTTP or HTTPS.

---

`signatureOverrides`

* **Type:** `array of objects`
* **Description:** Array of signature overrides.
  Specifies attack signatures whose security policy settings are overridden for this URL, and which action the security policy takes when it discovers a request for this URL that matches these attack signatures.
* **Subfields:** [See fields](<#policy/urls/signatureOverrides>)

---

<span id="policy/urls/type"></span>

`type`

* **Type:** `string`
* **Default:** `explicit`
* **Allowed Values:** `explicit` | `wildcard`
* **Description:** Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.

---

`urlContentProfiles`

* **Type:** `array of objects`
* **Description:** Specifies how the system recognizes and enforces requests for this URL according to the requests' header content. The system automatically creates a default header-based content profile for HTTP, and you cannot delete it. However, requests for a URL may contain other types of content, such as JSON, XML, or other proprietary formats.
* **Subfields:** [See fields](<#policy/urls/urlContentProfiles>)

---

<span id="policy/urls/wildcardOrder"></span>

`wildcardOrder`

* **Type:** `integer`
* **Description:** Specifies the order index for wildcard URLs matching. Wildcard URLs with lower wildcard order will get checked for a match prior to URLs with higher wildcard order.

---

<span id="policy/urls/parameters"></span>

`parameters`

* **Type:** `array of objects`
* **External reference:** Yes (`parameterReference`)

---

<h3 id="policy/urls/authorizationRules"><code>authorizationRules</code></h3>

<span id="policy/urls/authorizationRules/condition"></span>

`condition`

* **Type:** `string`

---

<span id="policy/urls/authorizationRules/name"></span>

`name`

* **Type:** `string`

---

<h3 id="policy/urls/html5CrossOriginRequestsEnforcement"><code>html5CrossOriginRequestsEnforcement</code></h3>

<span id="policy/urls/html5CrossOriginRequestsEnforcement/allowOriginsEnforcementMode"></span>

`allowOriginsEnforcementMode`

* **Type:** `string`
* **Default:** `unmodified`
* **Allowed Values:** `replace-with` | `unmodified`
* **Description:** Allows you to specify a list of origins allowed to share data returned by this URL.

---

<span id="policy/urls/html5CrossOriginRequestsEnforcement/checkAllowedMethods"></span>

`checkAllowedMethods`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Allows you to specify a list of methods that other web applications hosted in different domains can use when requesting this URL.

---

`crossDomainAllowedOrigin`

* **Type:** `array of objects`
* **Description:** Allows you to specify a list of origins allowed to share data returned by this URL.
* **Subfields:** [See fields](<#policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin>)

---

<span id="policy/urls/html5CrossOriginRequestsEnforcement/enforcementMode"></span>

`enforcementMode`

* **Type:** `string`
* **Default:** `disabled`
* **Allowed Values:** `disabled` | `enforce`
* **Description:** Specify the option to determine how to handle CORS requests.
  disabled: Do nothing related to cross-domain requests. Pass CORS requests exactly as set by the server.
  enforce: Allow cross-origin resource sharing as configured in the crossDomainAllowedOrigin setting. CORS requests are allowed from the domains specified as allowed origins. 

---

<h4 id="policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin"><code>crossDomainAllowedOrigin</code></h4>

<span id="policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin/includeSubDomains"></span>

`includeSubDomains`

* **Type:** `boolean`
* **Description:** If *true*, sub-domains of the allowed origin are also allowed to receive data from your web application.

---

<span id="policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin/originName"></span>

`originName`

* **Type:** `string`
* **Description:** Type the domain name or IP address with which the URL can share data.
  Wildcards are allowed in the names. For example: *.f5.com will match b.f5.com; however it will not match a.b.f5.com.

---

<span id="policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin/originPort"></span>

`originPort`

* **Type:** `integer` | `string`
* **Default:** `all`
* **Allowed Values:** Integer values | `all`
* **Minimum:** `0`
* **Maximum:** `65535`
* **Description:** Select the port that other web applications can use to request data from your web application, or use the * wildcard for all ports.

---

<span id="policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin/originProtocol"></span>

`originProtocol`

* **Type:** `string`
* **Default:** `http/https`
* **Allowed Values:** `http` | `http/https` | `https`
* **Description:** Select the appropriate protocol for the allowed origin.

---

<h3 id="policy/urls/metacharOverrides"><code>metacharOverrides</code></h3>

<span id="policy/urls/metacharOverrides/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If *true*, metacharacters and other characters are allowed in a URL.

---

<span id="policy/urls/metacharOverrides/metachar"></span>

`metachar`

* **Type:** `string`
* **Description:** ASCII representation of the character in Hex format

---

<h3 id="policy/urls/methodOverrides"><code>methodOverrides</code></h3>

<span id="policy/urls/methodOverrides/allowed"></span>

`allowed`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Specifies that the system allows you to override allowed methods for this URL. When selected, the global policy settings for methods are listed, and you can change what is allowed or disallowed for this URL.

---

<span id="policy/urls/methodOverrides/method"></span>

`method`

* **Type:** `string`
* **Allowed Values:** `ACL` | `BCOPY` | `BDELETE` | `BMOVE` | `BPROPFIND` | `BPROPPATCH` | `CHECKIN` | `CHECKOUT` | `CONNECT` | `COPY` | `DELETE` | `GET` | `HEAD` | `LINK` | `LOCK` | `MERGE` | `MKCOL` | `MKWORKSPACE` | `MOVE` | `NOTIFY` | `OPTIONS` | `PATCH` | `POLL` | `POST` | `PROPFIND` | `PROPPATCH` | `PUT` | `REPORT` | `RPC_IN_DATA` | `RPC_OUT_DATA` | `SEARCH` | `SUBSCRIBE` | `TRACE` | `TRACK` | `UNLINK` | `UNLOCK` | `UNSUBSCRIBE` | `VERSION_CONTROL` | `X-MS-ENUMATTS`
* **Description:** Specifies a list of existing HTTP methods. All security policies accept standard HTTP methods by default.

---

<h3 id="policy/urls/positionalParameters"><code>positionalParameters</code></h3>

<span id="policy/urls/positionalParameters/parameter"></span>

`parameter`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/parameters>)

---

<span id="policy/urls/positionalParameters/urlSegmentIndex"></span>

`urlSegmentIndex`

* **Type:** `integer`
* **Default:** `1`
* **Minimum:** `1`
* **Description:** Select which to add: Text or Parameter and enter your desired segments. You can add multiple text and parameter segments.

---

<h3 id="policy/urls/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/urls/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Description:** Specifies, when true, that the overridden signature is enforced

---

<span id="policy/urls/signatureOverrides/name"></span>

`name`

* **Type:** `string`
* **Description:** The signature name which, along with the signature tag, identifies the signature.

---

<span id="policy/urls/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`
* **Description:** The signature ID which identifies the signature.

---

<span id="policy/urls/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`
* **Description:** The signature tag which, along with the signature name, identifies the signature.

---

<h3 id="policy/urls/urlContentProfiles"><code>urlContentProfiles</code></h3>

`contentProfile`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/urls/urlContentProfiles/contentProfile>)

---

<span id="policy/urls/urlContentProfiles/decodeValueAsBase64"></span>

`decodeValueAsBase64`

* **Type:** `string`
* **Default:** `disabled`
* **Allowed Values:** `disabled` | `required`

---

<span id="policy/urls/urlContentProfiles/headerName"></span>

`headerName`

* **Type:** `string`
* **Default:** `*`
* **Description:** Specifies an explicit header name that must appear in requests for this URL. This field is not case-sensitive.

---

<span id="policy/urls/urlContentProfiles/headerOrder"></span>

`headerOrder`

* **Type:** `integer` | `string`
* **Default:** `default`
* **Allowed Values:** Integer values | `default`
* **Description:** Displays the order in which the system checks header content of requests for this URL.

---

<span id="policy/urls/urlContentProfiles/headerValue"></span>

`headerValue`

* **Type:** `string`
* **Default:** `*`
* **Description:** Specifies a simple pattern string (glob pattern matching) for the header value that must appear in legal requests for this URL; for example, *json*, xml\_method?, or method\[0-9\]. If the header includes this pattern, the system assumes the request contains the type of data you select in the Request Body Handling setting. This field is case-sensitive.

---

<span id="policy/urls/urlContentProfiles/type"></span>

`type`

* **Type:** `string`
* **Default:** `form-data`
* **Allowed Values:** `apply-content-signatures` | `apply-value-and-content-signatures` | `disallow` | `do-nothing` | `form-data` | `graphql` | `grpc` | `json` | `xml`
* **Description:**
  - **Apply Content Signatures**: Do not parse the content; scan the entire payload with full-content attack signatures.
  - **Apply Value and Content Signatures**: Do not parse the content or extract parameters; process the entire payload with value and full-content attack signatures.
  - **Disallow**: Block requests for an URL containing this header content. Log the Illegal Request Content Type violation.
  - **Do Nothing**: Do not inspect or parse the content. Handle the header of the request as specified by the security policy.
  - **Form Data**: Parse content as posted form data in either URL-encoded or multi-part formats. Enforce the form parameters according to the policy.
  - **GWT**: Perform checks for data in requests, based on the configuration of the GWT (Google Web Toolkit) profile associated with this URL.
  - **JSON**: Review JSON data using an associated JSON profile, and use value attack signatures to scan the element values.
  - **XML**: Review XML data using an associated XML profile.

---

<h4 id="policy/urls/urlContentProfiles/contentProfile"><code>contentProfile</code></h4>

<span id="policy/urls/urlContentProfiles/contentProfile/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/xml-profiles"></span>

## xml-profiles

<span id="policy/xml-profiles/attackSignaturesCheck"></span>

`attackSignaturesCheck`

* **Type:** `boolean`
* **Default:** `true`

---

`defenseAttributes`

* **Type:** `object`
* **Subfields:** [See fields](<#policy/xml-profiles/defenseAttributes>)

---

<span id="policy/xml-profiles/description"></span>

`description`

* **Type:** `string`

---

<span id="policy/xml-profiles/metacharAttributeCheck"></span>

`metacharAttributeCheck`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/xml-profiles/metacharElementCheck"></span>

`metacharElementCheck`

* **Type:** `boolean`
* **Default:** `true`

---

`metacharOverrides`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/xml-profiles/metacharOverrides>)

---

<span id="policy/xml-profiles/name"></span>

`name`

* **Type:** `string`

---

`signatureOverrides`

* **Type:** `array of objects`
* **Subfields:** [See fields](<#policy/xml-profiles/signatureOverrides>)

---

<span id="policy/xml-profiles/useXmlResponsePage"></span>

`useXmlResponsePage`

* **Type:** `boolean`
* **Default:** `false`

---

<h3 id="policy/xml-profiles/defenseAttributes"><code>defenseAttributes</code></h3>

<span id="policy/xml-profiles/defenseAttributes/allowCDATA"></span>

`allowCDATA`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/xml-profiles/defenseAttributes/allowDTDs"></span>

`allowDTDs`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/xml-profiles/defenseAttributes/allowExternalReferences"></span>

`allowExternalReferences`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/xml-profiles/defenseAttributes/allowProcessingInstructions"></span>

`allowProcessingInstructions`

* **Type:** `boolean`
* **Default:** `true`

---

<span id="policy/xml-profiles/defenseAttributes/maximumAttributeValueLength"></span>

`maximumAttributeValueLength`

* **Type:** `integer` | `string`
* **Default:** `1024`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumAttributesPerElement"></span>

`maximumAttributesPerElement`

* **Type:** `integer` | `string`
* **Default:** `16`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumChildrenPerElement"></span>

`maximumChildrenPerElement`

* **Type:** `integer` | `string`
* **Default:** `1024`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumDocumentDepth"></span>

`maximumDocumentDepth`

* **Type:** `integer` | `string`
* **Default:** `32`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumDocumentSize"></span>

`maximumDocumentSize`

* **Type:** `integer` | `string`
* **Default:** `1024000`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumElements"></span>

`maximumElements`

* **Type:** `integer` | `string`
* **Default:** `65536`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumNSDeclarations"></span>

`maximumNSDeclarations`

* **Type:** `integer` | `string`
* **Default:** `64`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumNameLength"></span>

`maximumNameLength`

* **Type:** `integer` | `string`
* **Default:** `256`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/maximumNamespaceLength"></span>

`maximumNamespaceLength`

* **Type:** `integer` | `string`
* **Default:** `256`
* **Allowed Values:** Integer values | `any`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/xml-profiles/defenseAttributes/tolerateCloseTagShorthand"></span>

`tolerateCloseTagShorthand`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/xml-profiles/defenseAttributes/tolerateLeadingWhiteSpace"></span>

`tolerateLeadingWhiteSpace`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/xml-profiles/defenseAttributes/tolerateNumericNames"></span>

`tolerateNumericNames`

* **Type:** `boolean`
* **Default:** `false`

---

<h3 id="policy/xml-profiles/metacharOverrides"><code>metacharOverrides</code></h3>

<span id="policy/xml-profiles/metacharOverrides/isAllowed"></span>

`isAllowed`

* **Type:** `boolean`

---

<span id="policy/xml-profiles/metacharOverrides/metachar"></span>

`metachar`

* **Type:** `string`

---

<h3 id="policy/xml-profiles/signatureOverrides"><code>signatureOverrides</code></h3>

<span id="policy/xml-profiles/signatureOverrides/enabled"></span>

`enabled`

* **Type:** `boolean`

---

<span id="policy/xml-profiles/signatureOverrides/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/xml-profiles/signatureOverrides/signatureId"></span>

`signatureId`

* **Type:** `integer`

---

<span id="policy/xml-profiles/signatureOverrides/tag"></span>

`tag`

* **Type:** `string`

---

<h3 id="policy/blocking-settings_evasions"><code>evasions</code></h3>

<span id="policy/blocking-settings_evasions/description"></span>

`description`

* **Type:** `string`
* **Allowed Values:** `%u decoding` | `Apache whitespace` | `Bad unescape` | `Bare byte decoding` | `Directory traversals` | `IIS Unicode codepoints` | `IIS backslashes` | `Multiple decoding` | `Multiple slashes` | `Semicolon path parameters`
* **Description:** Human-readable name of sub-violation.

---

<span id="policy/blocking-settings_evasions/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Defines if sub-violation is enforced - alarmed or blocked, according to the 'Evasion technique detected' (VIOL\_EVASION) violation blocking settings.

---

<span id="policy/blocking-settings_evasions/learn"></span>

`learn`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Defines if sub-violation is learned. Sub-violations are learned only when learn is enabled for the 'Evasion technique detected' (VIOL\_EVASION) violation.

---

<span id="policy/blocking-settings_evasions/maxDecodingPasses"></span>

`maxDecodingPasses`

* **Type:** `integer`
* **Default:** `2`
* **Minimum:** `2`
* **Maximum:** `5`
* **Description:** Defines how many times the system decodes URI and parameter values before the request is considered an evasion.
  Relevant only for the 'Multiple decoding' sub-violation.

---

<h3 id="policy/blocking-settings_http-protocols"><code>http-protocols</code></h3>

<span id="policy/blocking-settings_http-protocols/description"></span>

`description`

* **Type:** `string`
* **Allowed Values:** `POST request with Content-Length: 0` | `Multiple host headers` | `Host header contains IP address` | `Null in request` | `Header name with no header value` | `Chunked request with Content-Length header` | `Check maximum number of cookies` | `Check maximum number of parameters` | `Check maximum number of headers` | `Body in GET or HEAD requests` | `Bad multipart/form-data request parsing` | `Bad multipart parameters parsing` | `Unescaped space in URL` | `High ASCII characters in headers`
* **Description:** Human-readable name of sub-violation

---

<span id="policy/blocking-settings_http-protocols/enabled"></span>

`enabled`

* **Type:** `boolean`
* **Default:** `false`
* **Description:** Defines if sub-violation is enforced - alarmed or blocked, according to the 'HTTP protocol compliance failed' (VIOL\_HTTP\_PROTOCOL) violation blocking settings

---

<span id="policy/blocking-settings_http-protocols/learn"></span>

`learn`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** Defines if sub-violation is learned. Sub-violations is learned only when learn is enabled for the 'HTTP protocol compliance failed' (VIOL\_HTTP\_PROTOCOL) violation

---

<span id="policy/blocking-settings_http-protocols/maxCookies"></span>

`maxCookies`

* **Type:** `integer`
* **Default:** `50`
* **Minimum:** `1`
* **Maximum:** `100`

---

<span id="policy/blocking-settings_http-protocols/maxHeaders"></span>

`maxHeaders`

* **Type:** `integer`
* **Default:** `30`
* **Minimum:** `1`
* **Maximum:** `150`
* **Description:** Defines maximum allowed number of headers in request.
  Relevant only for the 'Check maximum number of headers' sub-violation

---

<span id="policy/blocking-settings_http-protocols/maxParams"></span>

`maxParams`

* **Type:** `integer`
* **Default:** `500`
* **Minimum:** `1`
* **Maximum:** `5000`
* **Description:** Defines maximum allowed number of parameters in request.
  Relevant only for the 'Check maximum number of parameters' sub-violation

---

<h3 id="policy/blocking-settings_violations"><code>violations</code></h3>

<span id="policy/blocking-settings_violations/alarm"></span>

`alarm`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/blocking-settings_violations/block"></span>

`block`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/blocking-settings_violations/description"></span>

`description`

* **Type:** `string`

---

<span id="policy/blocking-settings_violations/learn"></span>

`learn`

* **Type:** `boolean`
* **Default:** `false`

---

<span id="policy/blocking-settings_violations/name"></span>

`name`

* **Type:** `string`
* **Allowed Values:** `VIOL_ACCESS_UNAUTHORIZED` | `VIOL_ACCESS_INVALID` | `VIOL_ACCESS_MALFORMED` | `VIOL_ACCESS_MISSING` | `VIOL_ASM_COOKIE_MODIFIED` | `VIOL_BLACKLISTED_IP` | `VIOL_BOT_CLIENT` | `VIOL_BRUTE_FORCE` | `VIOL_COOKIE_EXPIRED` | `VIOL_COOKIE_LENGTH` | `VIOL_COOKIE_MALFORMED` | `VIOL_COOKIE_MODIFIED` | `VIOL_CSRF` | `VIOL_DATA_GUARD` | `VIOL_ENCODING` | `VIOL_EVASION` | `VIOL_FILETYPE` | `VIOL_FILE_UPLOAD` | `VIOL_FILE_UPLOAD_IN_BODY` | `VIOL_GRAPHQL_MALFORMED` | `VIOL_GRAPHQL_FORMAT` | `VIOL_GRAPHQL_INTROSPECTION_QUERY` | `VIOL_GRAPHQL_ERROR_RESPONSE` | `VIOL_GRPC_FORMAT` | `VIOL_GRPC_MALFORMED` | `VIOL_GRPC_METHOD` | `VIOL_HEADER_LENGTH` | `VIOL_HEADER_METACHAR` | `VIOL_HEADER_REPEATED` | `VIOL_HTTP_PROTOCOL` | `VIOL_HTTP_RESPONSE_STATUS` | `VIOL_JSON_FORMAT` | `VIOL_JSON_MALFORMED` | `VIOL_JSON_SCHEMA` | `VIOL_LOGIN` | `VIOL_LOGIN_URL_BYPASSED` | `VIOL_LOGIN_URL_EXPIRED` | `VIOL_MANDATORY_HEADER` | `VIOL_MANDATORY_PARAMETER` | `VIOL_MANDATORY_REQUEST_BODY` | `VIOL_METHOD` | `VIOL_PARAMETER` | `VIOL_PARAMETER_ARRAY_VALUE` | `VIOL_PARAMETER_DATA_TYPE` | `VIOL_PARAMETER_EMPTY_VALUE` | `VIOL_PARAMETER_LOCATION` | `VIOL_PARAMETER_MULTIPART_NULL_VALUE` | `VIOL_PARAMETER_NAME_METACHAR` | `VIOL_PARAMETER_NUMERIC_VALUE` | `VIOL_PARAMETER_REPEATED` | `VIOL_PARAMETER_STATIC_VALUE` | `VIOL_PARAMETER_VALUE_BASE64` | `VIOL_PARAMETER_VALUE_LENGTH` | `VIOL_PARAMETER_VALUE_METACHAR` | `VIOL_PARAMETER_VALUE_REGEXP` | `VIOL_POST_DATA_LENGTH` | `VIOL_QUERY_STRING_LENGTH` | `VIOL_RATING_THREAT` | `VIOL_RATING_NEED_EXAMINATION` | `VIOL_REQUEST_MAX_LENGTH` | `VIOL_REQUEST_LENGTH` | `VIOL_THREAT_CAMPAIGN` | `VIOL_URL` | `VIOL_URL_CONTENT_TYPE` | `VIOL_URL_LENGTH` | `VIOL_URL_METACHAR` | `VIOL_XML_FORMAT` | `VIOL_XML_MALFORMED` | `VIOL_GEOLOCATION` | `VIOL_WEBSOCKET_BAD_REQUEST` | `VIOL_MALICIOUS_IP`

---

<h2 id="policy/bot-defense_mitigations"><code>mitigations</code></h2>

<span id="policy/bot-defense_mitigations/anomalies"></span>

`anomalies`

* **Type:** `array of objects`
* **External reference:** Yes (`anomalyReference`)
* **Subfields:** [See fields](<#policy/bot-defense/mitigations_anomalies>)

---

<span id="policy/bot-defense_mitigations/browsers"></span>

`browsers`

* **Type:** `array of objects`
* **External reference:** Yes (`browserReference`)
* **Subfields:** [See fields](<#policy/bot-defense/mitigations_browsers>)

---

<span id="policy/bot-defense_mitigations/classes"></span>

`classes`

* **Type:** `array of objects`
* **Description:** List of classes and their actions.
* **External reference:** Yes (`classReference`)
* **Subfields:** [See fields](<#policy/bot-defense/mitigations_classes>)

---

<span id="policy/bot-defense_mitigations/signatures"></span>

`signatures`

* **Type:** `array of objects`
* **Description:** List of signatures and their actions.
  If a signature is not in the list - its action will be taken according to the class it belongs to.
* **External reference:** Yes (`signatureReference`)
* **Subfields:** [See fields](<#policy/bot-defense/mitigations_signatures>)

---

<h3 id="policy/bot-defense_settings"><code>settings</code></h3>

<span id="policy/bot-defense_settings/caseSensitiveHttpHeaders"></span>

`caseSensitiveHttpHeaders`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If *false* the system will not check header name with case sensitivity for both relevant anomalies: Invalid HTTP Headers, Suspicious HTTP Headers.

---

<span id="policy/bot-defense_settings/isEnabled"></span>

`isEnabled`

* **Type:** `boolean`
* **Default:** `true`
* **Description:** If *true* the system detects bots.

---

<h3 id="policy/bot-defense/mitigations_anomalies"><code>anomalies</code></h3>

<span id="policy/bot-defense/mitigations_anomalies/action"></span>

`action`

* **Type:** `string`
* **Default:** `default`
* **Allowed Values:** `alarm` | `block` | `default` | `detect` | `ignore`

---

<span id="policy/bot-defense/mitigations_anomalies/name"></span>

`name`

* **Type:** `string`

---

<span id="policy/bot-defense/mitigations_anomalies/scoreThreshold"></span>

`scoreThreshold`

* **Type:** `integer` | `string`
* **Default:** `default`
* **Allowed Values:** Integer values | `default`
* **Minimum:** `0`
* **Maximum:** `150`

---

<h3 id="policy/bot-defense/mitigations_browsers"><code>browsers</code></h3>

<span id="policy/bot-defense/mitigations_browsers/action"></span>

`action`

* **Type:** `string`
* **Default:** `detect`
* **Allowed Values:** `alarm` | `block` | `detect`

---

<span id="policy/bot-defense/mitigations_browsers/maxVersion"></span>

`maxVersion`

* **Type:** `integer`
* **Default:** `0`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/bot-defense/mitigations_browsers/minVersion"></span>

`minVersion`

* **Type:** `integer`
* **Default:** `0`
* **Minimum:** `0`
* **Maximum:** `2147483647`

---

<span id="policy/bot-defense/mitigations_browsers/name"></span>

`name`

* **Type:** `string`

---

<h3 id="policy/bot-defense/mitigations_classes"><code>classes</code></h3>

<span id="policy/bot-defense/mitigations_classes/action"></span>

`action`

* **Type:** `string`
* **Default:** `detect`
* **Allowed Values:** `alarm` | `block` | `detect` | `ignore`
* **Description:** The action we set for this class.

  - **ignore**: The system will not detect or report bots from this class.
  - **detect**: The system will detect and report the bot, but violation won't be reported.
  - **alarm**: The system will detect and report requests made by bots from this class as illegal, but will not block them.
  - **block**: The system will detect and report requests made by bots from this class as illegal, and block them.

---

<span id="policy/bot-defense/mitigations_classes/name"></span>

`name`

* **Type:** `string`
* **Default:** `trusted-bot`
* **Allowed Values:** `browser` | `malicious-bot` | `suspicious-browser` | `trusted-bot` | `unknown` | `untrusted-bot`
* **Description:** The class we set the action to.

---

<h3 id="policy/bot-defense/mitigations_signatures"><code>signatures</code></h3>

<span id="policy/bot-defense/mitigations_signatures/action"></span>

`action`

* **Type:** `string`
* **Allowed Values:** `alarm` | `block` | `detect` | `ignore`
* **Description:** The action we set for this signature.

  - **ignore**: The system will not detect or report this signature.
  - **detect**: The system will detect and report the signature, but violation won't be reported.
  - **alarm**: The system will detect and report requests made by those specific bots as illegal, but will not block them.
  - **block**: The system will detect and report requests made by those specific bots as illegal, and will block them.

---

<span id="policy/bot-defense/mitigations_signatures/name"></span>

`name`

* **Type:** `string`
* **Description:** The name of the signature we want to change action for.

---
