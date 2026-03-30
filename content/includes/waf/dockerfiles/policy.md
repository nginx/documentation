<!--- GENERATED FILE - DO NOT MODIFY --->

# Declarative Policy

```eval_rst
.. _policy:
```


### policy



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `access-profiles <policy/access-profiles_>`_

     - array of objects
     - 
     - 
   * - ``applicationLanguage``

     - string
     - The character encoding for the application. The character encoding determines how the policy processes the character sets. The default is utf-8.
     - * big5
       * euc-jp
       * euc-kr
       * gb18030
       * gb2312
       * gbk
       * iso-8859-1
       * iso-8859-10
       * iso-8859-13
       * iso-8859-15
       * iso-8859-16
       * iso-8859-2
       * iso-8859-3
       * iso-8859-4
       * iso-8859-5
       * iso-8859-6
       * iso-8859-7
       * iso-8859-8
       * iso-8859-9
       * koi8-r
       * shift_jis
       * utf-8
       * windows-1250
       * windows-1251
       * windows-1252
       * windows-1253
       * windows-1255
       * windows-1256
       * windows-1257
       * windows-874
   * - `blocking-settings <policy/blocking-settings_>`_

     - object
     - This section defines policy block/alarm behaviors.
     - 
   * - `bot-defense <policy/bot-defense_>`_

     - object
     - This section defines the properties of the bot defense feature.
     - 
   * - `browser-definitions <policy/browser-definitions_>`_

     - array of objects
     - 
     - 
   * - `brute-force-attack-preventions <policy/brute-force-attack-preventions_>`_

     - array of objects
     - Defines configuration for Brute Force Protection feature.
       There is default configuration (one with bruteForceProtectionForAllLoginPages flag and without url) that applies to all configured login URLs unless there exists another brute force configuration for a specific login page.
     - 
   * - ``caseInsensitive``

     - boolean
     - Specifies whether the security policy treats microservice URLs, file types, URLs, and parameters as case sensitive or not. When this setting is enabled, the system stores these security policy elements in lowercase in the security policy configuration.
     - 
   * - `character-sets <policy/character-sets_>`_

     - array of objects
     - 
     - 
   * - `cookie-settings <policy/cookie-settings_>`_

     - object
     - The maximum length of a cookie header name and value that the system processes. The system calculates and enforces a cookie header length based on the sum of the length of the cookie header name and value.
     - 
   * - `cookies <policy/cookies_>`_

     - array of objects
     - This section defines Cookie entities for your policy.
       You can specify the cookies that you want to allow, and the ones you want to enforce in a security policy:
       
         - **Allowed cookies**: The system allows these cookies and clients can change them.
         - **Enforced cookies**: The system enforces the cookies in the list (not allowing clients to change them) and allows clients to change all others.
     - 
   * - `csrf-protection <policy/csrf-protection_>`_

     - object
     - 
     - 
   * - `csrf-urls <policy/csrf-urls_>`_

     - array of objects
     - 
     - 
   * - `data-guard <policy/data-guard_>`_

     - object
     - Data Guard feature can prevent responses from exposing sensitive information by masking the data.
     - 
   * - ``description``

     - string
     - Specifies the description of the policy.
     - 
   * - `disallowed-geolocations <policy/disallowed-geolocations_>`_

     - array of objects
     - Specifies a list of countries that may not access the web application.
     - 
   * - ``enforcementMode``

     - string
     - How the system processes a request that triggers a security policy violation.
         - **Blocking:** When the enforcement mode is set to blocking, traffic is blocked if it causes a violation (configured for blocking).
         - **Transparent:** When the enforcement mode is set to transparent, traffic is not blocked even if a violation is triggered.
     - * blocking
       * transparent
   * - `enforcer-settings <policy/enforcer-settings_>`_

     - object
     - This section contains all enforcer settings.
     - 
   * - `filetypes <policy/filetypes_>`_

     - array of objects
     - File types are categorization of the URLs in the request by the extension appearing past the last dot at the end of the URL. For example, the file type of /index.php
       is "php". Other well known file types are html, aspx, png, jpeg and many more. A special case is the "empty" file type called "no-ext" meaning, no extension in which the URL has no dot at its last segment as in /foo_no_dot
       
       File types usually imply the expected content type in the response. For example, html and php return HTML content, while jpeg, png and gif return images, each in its respective format. File types also imply the server technology deployed for rendering the page. For example, php (PHP), aspx (ASP) and many others.
       
       The security policy uses file types for several purposes:
       1. Ability to define which file types are allowed and which are disallowed. By including the pure wildcard "\*" file type and a list of disallowed file types you have a file type denylist.
       By having a list of explicit file type *without* the pure wildcard "\*" you have a file type allowlist.
       2. Each file type implies maximum *length restrictions* for the requests of that file type. The checked lengths are per the URL, Query String, total request length, and payload (POST data).
       3. Each file type determines whether to detect *response signatures* for requests of that file type. Typically, one would never check signatures for image file types.
     - 
   * - ``fullPath``

     - string
     - The full name of the policy including partition.
     - 
   * - `general <policy/general_>`_

     - object
     - This section includes several advanced policy configuration settings.
     - 
   * - `graphql-profiles <policy/graphql-profiles_>`_

     - array of objects
     - 
     - 
   * - `grpc-profiles <policy/grpc-profiles_>`_

     - array of objects
     - 
     - 
   * - `header-settings <policy/header-settings_>`_

     - object
     - The maximum length of an HTTP header name and value that the system processes. The system calculates and enforces the HTTP header length based on the sum of the length of the HTTP header name and value.
     - 
   * - `headers <policy/headers_>`_

     - array of objects
     - This section defines Header entities for your policy.
     - 
   * - `host-names <policy/host-names_>`_

     - array of objects
     - 
     - 
   * - `idl-files <policy/idl-files_>`_

     - array of objects
     - 
     - 
   * - `ip-address-lists <policy/ip-address-lists_>`_

     - array of objects
     - An IP address list is a list of IP addresses that you want the system to treat in a specific way for a security policy.
     - 
   * - `ip-intelligence <policy/ip-intelligence_>`_

     - object
     - 
     - 
   * - `json-profiles <policy/json-profiles_>`_

     - array of objects
     - 
     - 
   * - `json-validation-files <policy/json-validation-files_>`_

     - array of objects
     - 
     - 
   * - `login-enforcement <policy/login-enforcement_>`_

     - object
     - 
     - 
   * - `login-pages <policy/login-pages_>`_

     - array of objects
     - A login page is a URL in a web application that requests must pass through to get to the authenticated URLs. Use login pages, for example, to prevent forceful browsing of restricted parts of the web application, by defining access permissions for users. Login pages also allow session tracking of user sessions.
     - 
   * - `methods <policy/methods_>`_

     - array of objects
     - 
     - 
   * - ``name``

     - string
     - The unique user-given name of the policy. Policy names cannot contain spaces or special characters. Allowed characters are a-z, A-Z, 0-9, dot, dash (-), colon (:) and underscore (_).
     - 
   * - `open-api-files <policy/open-api-files_>`_

     - array of objects
     - 
     - 
   * - `override-rules <policy/override-rules_>`_

     - array of objects
     - This section defines policy override rules.
     - 
   * - `parameters <policy/parameters_>`_

     - array of objects
     - This section defines parameters that the security policy permits in requests.
     - 
   * - ``performStaging``

     - boolean
     - Determines staging handling for all applicable entities in the policy, such as signatures, URLs, parameters, and cookies. If disabled, all entities will be enforced and any violations triggered will be considered illegal.
     - 
   * - `response-pages <policy/response-pages_>`_

     - array of objects
     - The Security Policy has a default blocking response page that it returns to the client when the client request, or the web server response, is blocked by the security policy. You can change the way the system responds to blocked requests. All default response pages contain a variable, <%TS.request.ID()%>, that the system replaces with a support ID number when it issues the page.
     - 
   * - `sensitive-parameters <policy/sensitive-parameters_>`_

     - array of objects
     - This section defines sensitive parameters.
       The contents of these parameters are not visible in logs nor in the user interfaces.
       Instead of actual values a string of asterisks is shown for these parameters.
       Use these parameters to protect sensitive user input, such as a password or a credit card number, in a validated request.
       A parameter name of "password" is always defined as sensitive by default.
     - 
   * - `server-technologies <policy/server-technologies_>`_

     - array of objects
     - The server technology is a server-side application, framework, web server or operating system type that is configured in the policy in order to adapt the policy to the checks needed for the respective technology.
     - 
   * - `signature-requirements <policy/signature-requirements_>`_

     - array of objects
     - 
     - 
   * - `signature-sets <policy/signature-sets_>`_

     - array of objects
     - Defines behavior when signatures found within a signature-set are detected in a request. Settings are cumulative, so if a signature is found in any set with block enabled, that signature will have block enabled.
     - 
   * - `signature-settings <policy/signature-settings_>`_

     - object
     - 
     - 
   * - `signatures <policy/signatures_>`_

     - array of objects
     - This section defines the properties of a signature on the policy.
     - 
   * - `template <policy/template_>`_

     - object
     - Specifies the template to populate the default attributes of a new policy.
     - 
   * - `threat-campaigns <policy/threat-campaigns_>`_

     - array of objects
     - This section defines the enforcement state for the threat campaigns in the security policy.
     - 
   * - `urls <policy/urls_>`_

     - array of objects
     - In a security policy, you can manually specify the HTTP URLs that are allowed (or disallowed) in traffic to the web application being protected. When you create a security policy, wildcard URLs of * (representing all HTTP URLs) are added to the Allowed HTTP URLs lists.
     - 
   * - ``wafEngineVersion``

     - string
     - 
     - 
   * - `xml-profiles <policy/xml-profiles_>`_

     - array of objects
     - 
     - 
```

```eval_rst
.. _policy/open-api-files:
```


##### open-api-files



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``link``

     - string
     - 
     - 
```

```eval_rst
.. _policy/template:
```


##### template



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``derivedFrom``

     - string
     - 
     - 
   * - ``name``

     - string
     - Specifies the name of the template used for the policy creation.
     - * POLICY_TEMPLATE_NGINX_BASE
```

---


```eval_rst
.. _policy/access-profiles:
```


### access-profiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``description``

     - string
     - 
     - 
   * - ``enforceMaximumLength``

     - boolean
     - 
     - 
   * - ``enforceValidityPeriod``

     - boolean
     - 
     - 
   * - `keyFiles <policy/access-profiles/keyFiles_>`_

     - array of objects
     - 
     - 
   * - `location <policy/access-profiles/location_>`_

     - object
     - 
     - 
   * - ``maximumLength``

     - integer
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - ``type``

     - string
     - 
     - * jwt
   * - `usernameExtraction <policy/access-profiles/usernameExtraction_>`_

     - object
     - 
     - 
   * - ``verifyDigitalSignature``

     - boolean
     - 
     - 
```

```eval_rst
.. _policy/access-profiles/keyFiles:
```


##### keyFiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``contents``

     - string
     - 
     - 
   * - ``fileName``

     - string
     - 
     - 
```

```eval_rst
.. _policy/access-profiles/location:
```


##### location



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``in``

     - string
     - 
     - * header
       * query
   * - ``name``

     - string
     - 
     - 
```

```eval_rst
.. _policy/access-profiles/usernameExtraction:
```


##### usernameExtraction



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``claimPropertyName``

     - string
     - 
     - 
   * - ``enabled``

     - boolean
     - 
     - 
   * - ``isMandatory``

     - boolean
     - 
     - 
```

---


```eval_rst
.. _policy/blocking-settings:
```


### blocking-settings



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `evasions <policy/blocking-settings_evasions_>`_

     - array of objects
     - This section defines behavior of 'Evasion technique detected' (VIOL_EVASION) violation sub-violations.
       User can control which sub-violations are enabled (alarmed/blocked).
       Behavior of sub-violations depends on the block/alarm settings of 'Evasion technique detected' violation,
       defined in /policy/blocking-settings/violations section:
        - If both alarm and block are disabled - enable flag becomes irrelevant, since there will be no block/alarm for all sub-violations
     - 
   * - `http-protocols <policy/blocking-settings_http-protocols_>`_

     - array of objects
     - This section defines behavior of 'HTTP protocol compliance failed' (VIOL_HTTP_PROTOCOL) violation sub-violations.
       User can control which sub-violations are enabled (alarmed/blocked).
       Behavior of sub-violations depends on the block/alarm settings of 'HTTP protocol compliance failed' violation,
        - If both alarm and block are disabled - enable flag becomes irrelevant, since there will be no block/alarm for all sub-violations
     - 
   * - `violations <policy/blocking-settings_violations_>`_

     - array of objects
     - 
     - 
```

---


```eval_rst
.. _policy/bot-defense:
```


### bot-defense



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `mitigations <policy/bot-defense_mitigations_>`_

     - object
     - This section defines the mitigation to each class or signature.
     - 
   * - `settings <policy/bot-defense_settings_>`_

     - object
     - This section contains all bot defense settings.
     - 
```

---


```eval_rst
.. _policy/browser-definitions:
```


### browser-definitions



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isUserDefined``

     - boolean
     - 
     - 
   * - ``matchRegex``

     - string
     - 
     - 
   * - ``matchString``

     - string
     - 
     - 
   * - ``name``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/brute-force-attack-preventions:
```


### brute-force-attack-preventions



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``bruteForceProtectionForAllLoginPages``

     - boolean
     - When enabled, enables Brute Force Protection for all configured login URLs.
       When disabled, only brute force configurations for specific login pages are applied in case they exist.
     - 
   * - `loginAttemptsFromTheSameIp <policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp_>`_

     - object
     - Specifies configuration for detecting brute force attacks from IP Address.
     - 
   * - `loginAttemptsFromTheSameUser <policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser_>`_

     - object
     - Specifies configuration for detecting brute force attacks for Username.
     - 
   * - ``reEnableLoginAfter``

     - integer
       minimum: 60
       maximum: 90000
     - Defines prevention period (measured in seconds) for source-based brute force attacks.
     - 
   * - ``sourceBasedProtectionDetectionPeriod``

     - integer
       minimum: 60
       maximum: 90000
     - Defines detection period (measured in seconds) for source-based brute force attacks.
     - 
   * - `url <policy/urls_>`_

     - object
     - Reference to the URL used in login URL configuration (policy/login-pages). This login URL is protected by Brute Force Protection feature.
     - 
```

```eval_rst
.. _policy/brute-force-attack-preventions/loginAttemptsFromTheSameIp:
```


##### loginAttemptsFromTheSameIp



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``action``

     - string
     - Specifies action that is applied when defined threshold is reached.
       
         - **alarm**: The system will log the login attempt.
         - **alarm-and-blocking-page**: The system will log the login attempt, block the request and send the Blocking page.
         - **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge.
         - **alarm-and-client-side-integrity**: The system determines whether the client is a legal browser or a bot by sending a page containing JavaScript code and waiting for a response. Legal browsers are able to execute JavaScript and produce a valid response, whereas bots cannot. A login attempt is logged if the client successfully passes the Client Side Integrity challenge.
         - **alarm-and-drop**: The system will log the login attempt and reset the TCP connection.
         - **alarm-and-honeypot-page**: The system will log the login attempt, block the request and send the Honeypot page. The Honeypot page is used for attacker deception. The page should look like an application failed login page. Unlike with the Blocking page, when the Honeypot page is sent an attacker is not able to distinguish a failed login response from a mitigation. As a result, the attacker will not change identity (Source IP or Device ID) and the brute force attack will be rendered ineffective. The Honeypot page is recommended when mitigation is request blocking.
     - * alarm
       * alarm-and-blocking-page
   * - ``enabled``

     - boolean
     - When enabled, the system counts failed login attempts from IP Address.
     - 
   * - ``threshold``

     - integer
       minimum: 1
       maximum: 1000
     - After configured threshold (number of failed login attempts from IP Address) defined action will be applied for the next login attempt.
     - 
```

```eval_rst
.. _policy/brute-force-attack-preventions/loginAttemptsFromTheSameUser:
```


##### loginAttemptsFromTheSameUser



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``action``

     - string
     - Specifies action that is applied when defined threshold is reached.
       
         - **alarm**: The system will log the login attempt.
         - **alarm-and-captcha**: The system determines whether the client is a legal browser operated by a human user by sending a CAPTCHA challenge. A login attempt is logged if the client successfully passes the CAPTCHA challenge.
         - **alarm-and-client-side-integrity**: The system determines whether the client is a legal browser or a bot by sending a page containing JavaScript code and waiting for a response. Legal browsers are able to execute JavaScript and produce a valid response, whereas bots cannot. A login attempt is logged if the client successfully passes the Client Side Integrity challenge.
     - * alarm
   * - ``enabled``

     - boolean
     - When enabled, the system counts failed login attempts for each Username.
     - 
   * - ``threshold``

     - integer
       minimum: 1
       maximum: 100
     - After configured threshold (number of failed login attempts for each Username) defined action will be applied for the next login attempt.
     - 
```

---


```eval_rst
.. _policy/character-sets:
```


### character-sets



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `characterSet <policy/character-sets/characterSet_>`_

     - array of objects
     - 
     - 
   * - ``characterSetType``

     - string
     - 
     - * header
       * url
       * parameter-name
       * parameter-value
       * xml-content
       * json-content
```

```eval_rst
.. _policy/character-sets/characterSet:
```


##### characterSet



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isAllowed``

     - boolean
     - 
     - 
   * - ``metachar``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/cookie-settings:
```


### cookie-settings



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``maximumCookieHeaderLength``

     - 
       * integer
         minimum: 1
         maximum: 65536
       * string
     - Maximum Cookie Header Length must be greater than 0 and less than 65536 bytes (64K). Note: if 0 or *any* are set, then no restriction on the cookie header length is applied.
     - * Integer values
       * "any"
```

---


```eval_rst
.. _policy/cookies:
```


### cookies



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``accessibleOnlyThroughTheHttpProtocol``

     - boolean
     - Specifies, when true, that the system adds the HttpOnly attribute to the domain cookie's response header.
       This is done to expose the cookie to only HTTP and HTTPS entities.
       This prevents the cookie from being modified, or intercepted even if it is not modified,
       by unwanted third parties that run scripts on the web page.
       
       **Notes**:
         - The system does not validate that the cookie has not been modified or intercepted.
         - The feature covers all security policy cookies, both enforced and allowed, explicit and wildcard.
     - 
   * - ``attackSignaturesCheck``

     - boolean
     - Specifies, when true, that you want attack signatures and threat campaigns to be detected on this cookie
       and possibly override the security policy settings of an attack signature or threat campaign specifically for this cookie.
       After you enable this setting, the system displays a list of attack signatures and threat campaigns.
     - 
   * - ``decodeValueAsBase64``

     - string
     - Specifies whether the the system should detect or require values to be Base64 encoded:
       
        - **disabled**: the value will not be decoded as Base64 content.
        - **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value.
        - **required**: the value must be decoded as Base64, and security checks will be performed on the decoded value.
       
        **Note**: This setting is only relevant if the Cookie Enforcement Type is set to Allowed.
     - * disabled
       * enabled
       * required
   * - ``enforcementType``

     - string
     - Specifies how the system treats this cookie.
       
         - **enforced**: Specifies that according to the security policy, this cookie may not be changed by the client.
         - **allowed**: Specifies that according to the security policy, this cookie may be changed by the client. The system ignores this cookie.
     - * allow
       * enforce
   * - ``insertSameSiteAttribute``

     - string
     - The introduction of the SameSite http attribute (defined in [RFC6265bis](https://tools.ietf.org/html/draft-ietf-httpbis-cookie-same-site-00))
       allows you to declare if your cookie should be restricted to a first-party or same-site context.
       Introducing the SameSite attribute on a cookie provides three different ways of controlling same-site vs. cross-site cookie sending:
       
         - **strict**: Cookie will only be sent in a first-party context. In user terms, the cookie will only be sent if the site for the cookie matches the site currently shown in the browser's URL bar.
         - **lax**: Cookies will be sent with top level navigation
         - **none-value**: Cookies will be sent in a third-party context.
     - * lax
       * none
       * none-value
       * strict
   * - ``maskValueInLogs``

     - boolean
     - Specifies, when true, that the cookie's value will be masked in the request log.
     - 
   * - ``name``

     - string
     - Specifies the cookie name as appearing in the http cookie header.
       The cookie name length is limited to 500 characters.
       
       Names can be one of the following according to the *type* attribute:
       
         - **explicit**: Specifies that the cookie has a specific name and is not a wildcard entity. Type the name of a cookie exactly as you expect it to appear in the request.
         - **wildcard**: Specifies that any cookie that matches the listed wildcard expression should be treated according to the wildcard attributes. Type a wildcard expression that matches the expected cookie. For example, the wildcard expression cookie_12* of type Enforced specifies that the security policy should not allow modified domain cookies for all cookies which match cookie_12*.
       
       The syntax for wildcard entities is based on shell-style wildcard characters.
       The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.
       
         - **\***: Matches all characters
         - **?**: Matches any single character
         - **[abcde]**: Matches exactly one of the characters listed
         - **[!abcde]**: Matches any character not listed
         - **[a-e]**: Matches exactly one character in the range
         - **[!a-e]**: Matches any character not in the range
       
       **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.
     - 
   * - ``securedOverHttpsConnection``

     - boolean
     - Specifies, when true, that the system adds the Secure attribute to the domain cookie's response header.
       This is done to ensure that the cookies are returned to the server only over SSL (by using the HTTPS protocol).
       This prevents the cookie from being intercepted, but does not guarantee its integrity.
       
       **Notes**:
         - The system does not validate that the cookie was received over SSL.
         - The feature covers all security policy cookies, both enforced and allowed, explicit and wildcard.
     - 
   * - `signatureOverrides <policy/cookies/signatureOverrides_>`_

     - array of objects
     - Array of signature overrides.
       Specifies attack signatures whose security policy settings are overridden for this cookie,
       and which action the security policy takes when it discovers a request for this cookie that matches these attack signatures.
     - 
   * - ``type``

     - string
     - Determines the type of the **name** attribute.
       Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.
     - * explicit
       * wildcard
   * - ``wildcardOrder``

     - integer
     - Specifies the order index for wildcard cookies matching.
       Wildcard cookies with lower wildcard order will get checked for a match prior to cookies with higher wildcard order.
     - 
```

```eval_rst
.. _policy/cookies/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - Specifies, when true, that the overridden signature is enforced
     - 
   * - ``name``

     - string
     - The signature name which, along with the signature tag, identifies the signature.
     - 
   * - ``signatureId``

     - integer
     - The signature ID which identifies the signature.
     - 
   * - ``tag``

     - string
     - The signature tag which, along with the signature name, identifies the signature.
     - 
```

---


```eval_rst
.. _policy/csrf-protection:
```


### csrf-protection



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - 
     - 
   * - ``expirationTimeInSeconds``

     - 
       * integer
       * string
     - 
     - * Integer values
       * "disabled"
   * - ``sslOnly``

     - boolean
     - 
     - 
```

---


```eval_rst
.. _policy/csrf-urls:
```


### csrf-urls



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enforcementAction``

     - string
     - 
     - * none
       * verify-origin
   * - ``method``

     - string
     - 
     - * GET
       * POST
       * any
   * - ``url``

     - string
     - 
     - 
   * - ``wildcardOrder``

     - integer
     - 
     - 
```

---


```eval_rst
.. _policy/data-guard:
```


### data-guard



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``creditCardNumbers``

     - boolean
     - If *true* the system considers credit card numbers as sensitive data.
     - 
   * - ``customPatterns``

     - boolean
     - If *true* the system recognizes customized patterns as sensitive data.
     - 
   * - ``customPatternsList``

     - array of strings
     - List of PCRE regular expressions that specify the sensitive data patterns.
     - 
   * - ``enabled``

     - boolean
     - If *true* the system protects sensitive data.
     - 
   * - ``enforcementMode``

     - string
     - Specifies the URLs for which the system enforces data guard protection.
       
         - **ignore-urls-in-list**: Specifies that the system enforces data guard protection for all URLs except for those URLs in the Enforcement Mode list.
         - **enforce-urls-in-list**: Specifies that the system enforces data guard protection only for those URLs in the Enforcement Mode list
     - * enforce-urls-in-list
       * ignore-urls-in-list
   * - ``enforcementUrls``

     - array of strings
     - List of URLS to be enforced based on enforcement mode of data guard protection.
     - 
   * - ``firstCustomCharactersToExpose``

     - integer
       minimum: 0
       maximum: 255
     - Specifies the number of first alphanumeric characters in Custom patterns that are exposed.
     - 
   * - ``lastCustomCharactersToExpose``

     - integer
       minimum: 0
       maximum: 255
     - Specifies the number of last alphanumeric characters in Custom patterns that are exposed.
     - 
   * - ``maskData``

     - boolean
     - If *true* the system intercepts the returned responses to mask sensitive data.
     - 
   * - ``usSocialSecurityNumbers``

     - boolean
     - If *true* the system considers U.S Social Security numbers as sensitive data.
     - 
```

---


```eval_rst
.. _policy/disallowed-geolocations:
```


### disallowed-geolocations



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``countryCode``

     - string
     - Specifies the ISO country code of the selected country.
     - 
   * - ``countryName``

     - string
     - Specifies the name of the country.
     - * Afghanistan
       * Aland Islands
       * Albania
       * Algeria
       * American Samoa
       * Andorra
       * Angola
       * Anguilla
       * Anonymous Proxy
       * Antarctica
       * Antigua and Barbuda
       * Argentina
       * Armenia
       * Aruba
       * Australia
       * Austria
       * Azerbaijan
       * Bahamas
       * Bahrain
       * Bangladesh
       * Barbados
       * Belarus
       * Belgium
       * Belize
       * Benin
       * Bermuda
       * Bhutan
       * Bolivia
       * Bosnia and Herzegovina
       * Botswana
       * Bouvet Island
       * Brazil
       * British Indian Ocean Territory
       * Brunei Darussalam
       * Bulgaria
       * Burkina Faso
       * Burundi
       * Cambodia
       * Cameroon
       * Canada
       * Cape Verde
       * Cayman Islands
       * Central African Republic
       * Chad
       * Chile
       * China
       * Christmas Island
       * Cocos (Keeling) Islands
       * Colombia
       * Comoros
       * Congo
       * Congo, The Democratic Republic of the
       * Cook Islands
       * Costa Rica
       * Cote D'Ivoire
       * Croatia
       * Cuba
       * Cyprus
       * Czech Republic
       * Denmark
       * Djibouti
       * Dominica
       * Dominican Republic
       * Ecuador
       * Egypt
       * El Salvador
       * Equatorial Guinea
       * Eritrea
       * Estonia
       * Ethiopia
       * Falkland Islands (Malvinas)
       * Faroe Islands
       * Fiji
       * Finland
       * France
       * France, Metropolitan
       * French Guiana
       * French Polynesia
       * French Southern Territories
       * Gabon
       * Gambia
       * Georgia
       * Germany
       * Ghana
       * Gibraltar
       * Greece
       * Greenland
       * Grenada
       * Guadeloupe
       * Guam
       * Guatemala
       * Guernsey
       * Guinea
       * Guinea-Bissau
       * Guyana
       * Haiti
       * Heard Island and McDonald Islands
       * Holy See (Vatican City State)
       * Honduras
       * Hong Kong
       * Hungary
       * Iceland
       * India
       * Indonesia
       * Iran, Islamic Republic of
       * Iraq
       * Ireland
       * Isle of Man
       * Israel
       * Italy
       * Jamaica
       * Japan
       * Jersey
       * Jordan
       * Kazakhstan
       * Kenya
       * Kiribati
       * Korea, Democratic People's Republic of
       * Korea, Republic of
       * Kuwait
       * Kyrgyzstan
       * Lao People's Democratic Republic
       * Latvia
       * Lebanon
       * Lesotho
       * Liberia
       * Libyan Arab Jamahiriya
       * Liechtenstein
       * Lithuania
       * Luxembourg
       * Macau
       * Macedonia
       * Madagascar
       * Malawi
       * Malaysia
       * Maldives
       * Mali
       * Malta
       * Marshall Islands
       * Martinique
       * Mauritania
       * Mauritius
       * Mayotte
       * Mexico
       * Micronesia, Federated States of
       * Moldova, Republic of
       * Monaco
       * Mongolia
       * Montenegro
       * Montserrat
       * Morocco
       * Mozambique
       * Myanmar
       * N/A
       * Namibia
       * Nauru
       * Nepal
       * Netherlands
       * Netherlands Antilles
       * New Caledonia
       * New Zealand
       * Nicaragua
       * Niger
       * Nigeria
       * Niue
       * Norfolk Island
       * Northern Mariana Islands
       * Norway
       * Oman
       * Other
       * Pakistan
       * Palau
       * Palestinian Territory
       * Panama
       * Papua New Guinea
       * Paraguay
       * Peru
       * Philippines
       * Pitcairn Islands
       * Poland
       * Portugal
       * Puerto Rico
       * Qatar
       * Reunion
       * Romania
       * Russian Federation
       * Rwanda
       * Saint Barthelemy
       * Saint Helena
       * Saint Kitts and Nevis
       * Saint Lucia
       * Saint Martin
       * Saint Pierre and Miquelon
       * Saint Vincent and the Grenadines
       * Samoa
       * San Marino
       * Sao Tome and Principe
       * Satellite Provider
       * Saudi Arabia
       * Senegal
       * Serbia
       * Seychelles
       * Sierra Leone
       * Singapore
       * Slovakia
       * Slovenia
       * Solomon Islands
       * Somalia
       * South Africa
       * South Georgia and the South Sandwich Islands
       * Spain
       * Sri Lanka
       * Sudan
       * Suriname
       * Svalbard and Jan Mayen
       * Swaziland
       * Sweden
       * Switzerland
       * Syrian Arab Republic
       * Taiwan
       * Tajikistan
       * Tanzania, United Republic of
       * Thailand
       * Timor-Leste
       * Togo
       * Tokelau
       * Tonga
       * Trinidad and Tobago
       * Tunisia
       * Turkey
       * Turkmenistan
       * Turks and Caicos Islands
       * Tuvalu
       * Uganda
       * Ukraine
       * United Arab Emirates
       * United Kingdom
       * United States
       * United States Minor Outlying Islands
       * Uruguay
       * Uzbekistan
       * Vanuatu
       * Venezuela
       * Vietnam
       * Virgin Islands, British
       * Virgin Islands, U.S.
       * Wallis and Futuna
       * Western Sahara
       * Yemen
       * Zambia
       * Zimbabwe
```

---


```eval_rst
.. _policy/enforcer-settings:
```


### enforcer-settings



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `enforcerStateCookies <policy/enforcer-settings/enforcerStateCookies_>`_

     - object
     - This section defines the properties of the enforcer state cookies.
     - 
```

```eval_rst
.. _policy/enforcer-settings/enforcerStateCookies:
```


##### enforcerStateCookies



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``httpOnlyAttribute``

     - boolean
     - Specifies, when true, that the system adds the state cookie HttpOnly attribute.
     - 
   * - ``sameSiteAttribute``

     - string
     - The value for the state cookie SameSite attribute:
       
         - **none**: The SameSite attribute is never added to the state cookie.
         - **strict**: Cookie will only be sent in a first-party context. In user terms, the cookie will only be sent if the site for the cookie matches the site currently shown in the browser's URL bar.
         - **lax**: Cookies will be sent with top level navigation
         - **none-value**: Cookies will be sent in a third-party context.
     - * lax
       * none
       * none-value
       * strict
   * - ``secureAttribute``

     - string
     - The value for the state cookie Secure attribute:
       
         - **always**: Always add the Secure attribute to the state cookie.
         - **never**: The Secure attribute is never added to the state cookie.
     - * always
       * never
```

---


```eval_rst
.. _policy/filetypes:
```


### filetypes



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowed``

     - boolean
     - Determines whether the file type is allowed or disallowed. In either of these cases the VIOL_FILETYPE violation is issued (if enabled) for an incoming request-
       1. No allowed file type matched the file type of the request.
       2. The file type of the request matched a disallowed file type.
     - 
   * - ``checkPostDataLength``

     - boolean
     - Determines whether to enforce maximum length restriction for the body, a.k.a. "POST data" part of the requests that match the respective file type. The maximum length is determined by *postDataLength* attribute.
       Although named "POST data", this applies to any content type and not restricted to POST requests, e.g. PUT requests are also checked.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``checkQueryStringLength``

     - boolean
     - Determines whether to enforce maximum length restriction for the query string of the requests that match the respective file type. The maximum length is determined by *queryStringLength* attribute.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``checkRequestLength``

     - boolean
     - Determines whether to enforce maximum length restriction for the total length of requests that match the respective file type. The maximum length is determined by *requestLength* attribute.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``checkUrlLength``

     - boolean
     - Determines whether to enforce maximum length restriction for the URL of the requests that match the respective file type. The URL does *not* include the query string, past the &. The maximum length is determined by *urlLength* attribute.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``name``

     - string
     - Specifies the file type name as appearing in the URL extension. Names can be one of the following according to the *type* attribute:
       
         - **Explicit** - Specifies that the name is the literal file extension to which the file type refers. The *type* attribute has to be "explicit".
         - **No Extension** - Specifies the empty file type, lacking file extension. For this the reserved string **no_ext** should be used. The *type* attribute has to be "explicit".
         - **Wildcard** - Specifies that any file extension that matches the wildcard expression is matched to this file type in the policy. The *type* attribute has to be "wildcard".
       
       The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.
       
         - **\***: Matches all characters
         - **?**: Matches any single character
         - **[abcde]**: Matches exactly one of the characters listed
         - **[!abcde]**: Matches any character not listed
         - **[a-e]**: Matches exactly one character in the range
         - **[!a-e]**: Matches any character not in the range
       
       **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.
     - 
   * - ``postDataLength``

     - integer
       minimum: 0
     - The maximum length in bytes of the body (POST data) of the request matching the file type. Enforced only if checkPostDataLength is set to *true*.
       If the value is exceeded then VIOL_POST_DATA_LENGTH violation is issued.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``queryStringLength``

     - integer
       minimum: 0
     - The maximum length in bytes of the query string of the request matching the file type. Enforced only if checkQueryStringLength is set to *true*.
       If the value is exceeded then VIOL_QUERY_STRING_LENGTH violation is issued.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``requestLength``

     - integer
       minimum: 0
     - The maximum total length in bytes of the request matching the file type. Enforced only if checkRequestLength is set to *true*.
       If the value is exceeded then VIOL_REQUEST_LENGTH violation is issued.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``responseCheck``

     - boolean
     - Determines whether the responses to requests that match the respective file types are inspected for attack signature detection.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``responseCheckLength``

     - integer
       minimum: 0
       maximum: 10000000000
     - Determines how much of the response body will be checked for signatures.
       When value is set to 0, only the header will be checked.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``type``

     - string
     - Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.
     - * explicit
       * wildcard
   * - ``urlLength``

     - integer
       minimum: 0
     - The maximum length in bytes of the URL of the request matching the file type, excluding the query string. Enforced only if checkUrlLength is set to *true*.
       If the value is exceeded then VIOL_URL_LENGTH violation is issued.
       This attribute is relevant only to *allowed* file types.
     - 
   * - ``wildcardOrder``

     - integer
     - 
     - 
```

---


```eval_rst
.. _policy/general:
```


### general



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowedResponseCodes``

     - array of integers
     - You can specify which responses a security policy permits.
       By default, the system accepts all response codes from 100 to 399 as valid responses.
       Response codes from 400 to 599 are considered invalid unless added to the Allowed Response Status Codes list.
       By default, 400, 401, 404, 407, 417, and 503 are on the list as allowed HTTP response status codes.
     - 
   * - ``customXffHeaders``

     - array of strings
     - If you require the system to trust a server further than one hop toward the client (the last proxy traversed), you can use the Custom XFF Headers setting to define a specific header that is inserted closer to, or at the client, that the system will trust.
       Additionally, if you require the system to trust a proxy server that uses a different header name than the X-Forwarded-For header name, you can add the desired header name to the Custom XFF Headers setting.
       When adding a custom header, the X-Forwarded-For header is not trusted anymore. In case the X-Forwarded-For header is to be trusted along with other headers, you must add it to the custom headers list.
     - 
   * - ``maskCreditCardNumbersInRequest``

     - boolean
     - When enabled, the security policy masks credit card numbers that appear in any part of requests. The system does not mask the information in the actual requests, but rather in various logs:
       * Credit card numbers appearing in entity names are masked in the requests of the Requests log.
       * Credit card numbers appearing in entity values are masked wherever requests can be viewed: the Requests log, and violation details within that log.
       This setting is enabled by default, and exists in addition to masking parameters defined as containing sensitive information.
     - 
   * - ``trustXff``

     - boolean
     - When enabled, the system has confidence in an XFF (X-Forwarded-For) header in the request. When disabled, that the system does not have confidence in an XFF header in the request. The default setting is disabled.
       
       Select this option if the system is deployed behind an internal or other trusted proxy. Then, the system uses the IP address that initiated the connection to the proxy instead of the internal proxy's IP address.
       
       Leave this option disabled if you think the HTTP header may be spoofed, or crafted, by a malicious client. With this setting disabled, if the system is deployed behind an internal proxy, the system uses the internal proxy's IP address instead of the client's IP address.
     - 
```

---


```eval_rst
.. _policy/graphql-profiles:
```


### graphql-profiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``attackSignaturesCheck``

     - boolean
     - 
     - 
   * - `defenseAttributes <policy/graphql-profiles/defenseAttributes_>`_

     - object
     - 
     - 
   * - ``description``

     - string
     - 
     - 
   * - ``hasIdlFiles``

     - boolean
     - 
     - 
   * - `idlFiles <policy/graphql-profiles/idlFiles_>`_

     - array of objects
     - 
     - 
   * - ``metacharElementCheck``

     - boolean
     - 
     - 
   * - `metacharOverrides <policy/graphql-profiles/metacharOverrides_>`_

     - array of objects
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - `responseEnforcement <policy/graphql-profiles/responseEnforcement_>`_

     - object
     - 
     - 
   * - `sensitiveData <policy/graphql-profiles/sensitiveData_>`_

     - array of objects
     - 
     - 
   * - `signatureOverrides <policy/graphql-profiles/signatureOverrides_>`_

     - array of objects
     - 
     - 
```

```eval_rst
.. _policy/graphql-profiles/defenseAttributes:
```


##### defenseAttributes



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowIntrospectionQueries``

     - boolean
     - 
     - 
   * - ``maximumBatchedQueries``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumQueryCost``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumStructureDepth``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumTotalLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumValueLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``tolerateParsingWarnings``

     - boolean
     - 
     - 
```

```eval_rst
.. _policy/graphql-profiles/idlFiles:
```


##### idlFiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `idlFile <policy/graphql-profiles/idlFiles/idlFile_>`_

     - object
     - 
     - 
   * - ``isPrimary``

     - boolean
     - 
     - 
```

```eval_rst
.. _policy/graphql-profiles/idlFiles/idlFile:
```


##### idlFile



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
```

```eval_rst
.. _policy/graphql-profiles/metacharOverrides:
```


##### metacharOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isAllowed``

     - boolean
     - 
     - 
   * - ``metachar``

     - string
     - 
     - 
```

```eval_rst
.. _policy/graphql-profiles/responseEnforcement:
```


##### responseEnforcement



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``blockDisallowedPatterns``

     - boolean
     - 
     - 
   * - ``disallowedPatterns``

     - array of strings
     - 
     - 
```

```eval_rst
.. _policy/graphql-profiles/sensitiveData:
```


##### sensitiveData



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``parameterName``

     - string
     - 
     - 
```

```eval_rst
.. _policy/graphql-profiles/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - ``signatureId``

     - integer
     - 
     - 
   * - ``tag``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/grpc-profiles:
```


### grpc-profiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``associateUrls``

     - boolean
     - 
     - 
   * - ``attackSignaturesCheck``

     - boolean
     - 
     - 
   * - ``decodeStringValuesAsBase64``

     - string
     - 
     - * disabled
       * enabled
   * - `defenseAttributes <policy/grpc-profiles/defenseAttributes_>`_

     - object
     - 
     - 
   * - ``description``

     - string
     - 
     - 
   * - ``hasIdlFiles``

     - boolean
     - 
     - 
   * - `idlFiles <policy/grpc-profiles/idlFiles_>`_

     - array of objects
     - 
     - 
   * - ``metacharElementCheck``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - `signatureOverrides <policy/grpc-profiles/signatureOverrides_>`_

     - array of objects
     - 
     - 
```

```eval_rst
.. _policy/grpc-profiles/defenseAttributes:
```


##### defenseAttributes



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowUnknownFields``

     - boolean
     - 
     - 
   * - ``maximumDataLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
```

```eval_rst
.. _policy/grpc-profiles/idlFiles:
```


##### idlFiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `idlFile <policy/grpc-profiles/idlFiles/idlFile_>`_

     - object
     - 
     - 
   * - ``importUrl``

     - string
     - 
     - 
   * - ``isPrimary``

     - boolean
     - 
     - 
   * - ``primaryIdlFileName``

     - string
     - 
     - 
```

```eval_rst
.. _policy/grpc-profiles/idlFiles/idlFile:
```


##### idlFile



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
```

```eval_rst
.. _policy/grpc-profiles/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - ``signatureId``

     - integer
     - 
     - 
   * - ``tag``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/header-settings:
```


### header-settings



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``maximumHttpHeaderLength``

     - 
       * integer
         minimum: 1
         maximum: 65536
       * string
     - Maximum HTTP Header Length must be greater than 0 and less than 65536 bytes (64K). Note: if 0 or *any* are set, then no restriction on the HTTP header length is applied.
     - * Integer values
       * "any"
```

---


```eval_rst
.. _policy/headers:
```


### headers



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowEmptyValue``

     - boolean
     - 
     - 
   * - ``allowRepeatedOccurrences``

     - boolean
     - 
     - 
   * - ``autoDetectBinaryValue``

     - boolean
     - 
     - 
   * - ``checkSignatures``

     - boolean
     - 
     - 
   * - ``decodeValueAsBase64``

     - string
     - Specifies whether the the system should detect or require values to be Base64 encoded:
       
        - **disabled**: the value will not be decoded as Base64 content.
        - **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value.
        - **required**: the value must be decoded as Base64, and security checks will be performed on the decoded value.
     - * disabled
       * enabled
       * required
   * - ``htmlNormalization``

     - boolean
     - 
     - 
   * - ``mandatory``

     - boolean
     - 
     - 
   * - ``maskValueInLogs``

     - boolean
     - Specifies, when true, that the headers's value will be masked in the request log.
     - 
   * - ``name``

     - string
     - Specifies the HTTP header name.
       The header name length is limited to 254 characters.
       
       Names can be one of the following according to the *type* attribute:
       
         - **explicit**: Specifies that the header has a specific name and is not a wildcard entity. The name of the header exactly as you expect it to appear in the request.
         - **wildcard**: Specifies that any header that matches the listed wildcard expression should be treated according to the wildcard attributes.
       
       The syntax for wildcard entities is based on shell-style wildcard characters.
       The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.
       
         - **\***: Matches all characters
         - **?**: Matches any single character
         - **[abcde]**: Matches exactly one of the characters listed
         - **[!abcde]**: Matches any character not listed
         - **[a-e]**: Matches exactly one character in the range
         - **[!a-e]**: Matches any character not in the range
       
       **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.
     - 
   * - ``normalizationViolations``

     - boolean
     - 
     - 
   * - ``percentDecoding``

     - boolean
     - 
     - 
   * - `signatureOverrides <policy/headers/signatureOverrides_>`_

     - array of objects
     - Array of signature overrides.
       Specifies attack signatures whose security policy settings are overridden for this header,
       and which action the security policy takes when it discovers a request for this header that matches these attack signatures.
     - 
   * - ``type``

     - string
     - Determines the type of the **name** attribute.
       Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.
     - * explicit
       * wildcard
   * - ``urlNormalization``

     - boolean
     - 
     - 
   * - ``wildcardOrder``

     - integer
     - Specifies the order index for wildcard header matching.
       Wildcard headers with lower wildcard order will get checked for a match prior to headers with higher wildcard order.
     - 
```

```eval_rst
.. _policy/headers/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - Specifies, when true, that the overridden signature is enforced
     - 
   * - ``name``

     - string
     - The signature name which, along with the signature tag, identifies the signature.
     - 
   * - ``signatureId``

     - integer
     - The signature ID which identifies the signature.
     - 
   * - ``tag``

     - string
     - The signature tag which, along with the signature name, identifies the signature.
     - 
```

---


```eval_rst
.. _policy/host-names:
```


### host-names



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``includeSubdomains``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/idl-files:
```


### idl-files



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``contents``

     - string
     - 
     - 
   * - ``fileName``

     - string
     - 
     - 
   * - ``isBase64``

     - boolean
     - 
     - 
```

---


```eval_rst
.. _policy/ip-address-lists:
```


### ip-address-lists



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``blockRequests``

     - string
     - Specifies how the system responds to blocking requests sent from this IP address list.
         - **Policy Default:** Specifies that the policy enforcementMode will be used for requests from this IP address list.
         - **Never Block:** Specifies that the system does not block requests sent from this IP address list, even if your security policy is configured to block all traffic.
         - **Always Block:** Specifies that the system blocks requests sent from this IP address list.
       Optional, if absent Policy Default is used.
     - * always
       * never
       * policy-default
   * - ``description``

     - string
     - Specifies a brief description of the IP address list. Optional
     - 
   * - `ipAddresses <policy/ip-address-lists/ipAddresses_>`_

     - array of objects
     - Specifies the IP addresses. Use CIDR notation for subnet definition.
     - 
   * - ``matchOrder``

     - integer
     - Specifies the order matching index between different IP Address Lists. If unspecified, the order is implicitly as the lists appear in the policy.
       IP Address Lists with a lower matchOrder will be checked for a match prior to items with higher matchOrder.
     - 
   * - ``name``

     - string
     - Specifies the name of ip address list.
     - 
   * - ``neverLogRequests``

     - boolean
     - Specifies when enabled that the system does not log requests or responses sent from this IP address list, even if the traffic is illegal, and even if your security policy is configured to log all traffic.
       Optional, if absent default value is false.
     - 
   * - ``setGeolocation``

     - string
     - Specifies a geolocation to be associated for this IP address list.
       This will force the IP addresses in the list to be considered as though they are in that geolocation. This applies to blocking via "disallowed-geolocations" and to logging. 
       Optional
     - 
```

```eval_rst
.. _policy/ip-address-lists/ipAddresses:
```


##### ipAddresses



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``ipAddress``

     - string
     - Specifies the IP address. Use CIDR notation for subnet definition.
     - 
```

---


```eval_rst
.. _policy/ip-intelligence:
```


### ip-intelligence



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - 
     - 
   * - `ipIntelligenceCategories <policy/ip-intelligence/ipIntelligenceCategories_>`_

     - array of objects
     - 
     - 
```

```eval_rst
.. _policy/ip-intelligence/ipIntelligenceCategories:
```


##### ipIntelligenceCategories



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``alarm``

     - boolean
     - 
     - 
   * - ``block``

     - boolean
     - 
     - 
   * - ``category``

     - string
     - 
     - * Anonymous Proxy
       * BotNets
       * Cloud-based Services
       * Denial of Service
       * Infected Sources
       * Mobile Threats
       * Phishing Proxies
       * Scanners
       * Spam Sources
       * Tor Proxies
       * Web Attacks
       * Windows Exploits
```

---


```eval_rst
.. _policy/json-profiles:
```


### json-profiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``attackSignaturesCheck``

     - boolean
     - 
     - 
   * - `defenseAttributes <policy/json-profiles/defenseAttributes_>`_

     - object
     - 
     - 
   * - ``description``

     - string
     - 
     - 
   * - ``handleJsonValuesAsParameters``

     - boolean
     - 
     - 
   * - ``hasValidationFiles``

     - boolean
     - 
     - 
   * - ``metacharElementCheck``

     - boolean
     - 
     - 
   * - `metacharOverrides <policy/json-profiles/metacharOverrides_>`_

     - array of objects
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - `signatureOverrides <policy/json-profiles/signatureOverrides_>`_

     - array of objects
     - 
     - 
   * - `validationFiles <policy/json-profiles/validationFiles_>`_

     - array of objects
     - 
     - 
```

```eval_rst
.. _policy/json-profiles/defenseAttributes:
```


##### defenseAttributes



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``maximumArrayLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumStructureDepth``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumTotalLengthOfJSONData``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumValueLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``tolerateJSONParsingWarnings``

     - boolean
     - 
     - 
```

```eval_rst
.. _policy/json-profiles/metacharOverrides:
```


##### metacharOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isAllowed``

     - boolean
     - 
     - 
   * - ``metachar``

     - string
     - 
     - 
```

```eval_rst
.. _policy/json-profiles/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - ``signatureId``

     - integer
     - 
     - 
   * - ``tag``

     - string
     - 
     - 
```

```eval_rst
.. _policy/json-profiles/validationFiles:
```


##### validationFiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``importUrl``

     - string
     - 
     - 
   * - ``isPrimary``

     - boolean
     - 
     - 
   * - `jsonValidationFile <policy/json-profiles/validationFiles/jsonValidationFile_>`_

     - object
     - 
     - 
```

```eval_rst
.. _policy/json-profiles/validationFiles/jsonValidationFile:
```


##### jsonValidationFile



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
```

---


```eval_rst
.. _policy/json-validation-files:
```


### json-validation-files



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``contents``

     - string
     - 
     - 
   * - ``fileName``

     - string
     - 
     - 
   * - ``isBase64``

     - boolean
     - 
     - 
```

---


```eval_rst
.. _policy/login-enforcement:
```


### login-enforcement



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``authenticatedUrls``

     - array of strings
     - 
     - 
   * - ``expirationTimePeriod``

     - 
       * integer
         minimum: 0
         maximum: 99999
       * string
     - 
     - * Integer values
       * "disabled"
   * - `logoutUrls <policy/login-enforcement/logoutUrls_>`_

     - array of objects
     - 
     - 
```

```eval_rst
.. _policy/login-enforcement/logoutUrls:
```


##### logoutUrls



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``requestContains``

     - string
     - 
     - 
   * - ``requestOmits``

     - string
     - 
     - 
   * - `url <policy/urls_>`_

     - object
     - 
     - 
```

---


```eval_rst
.. _policy/login-pages:
```


### login-pages



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `accessValidation <policy/login-pages/accessValidation_>`_

     - object
     - Access Validation define validation criteria for the login page response. If you define more than one validation criteria, the response must meet all the criteria before the system allows the user to access the application login URL.
     - 
   * - ``authenticationType``

     - string
     - Authentication Type is method the web server uses to authenticate the login URL's credentials with a web user.
       
         - **none**: The web server does not authenticate users trying to access the web application through the login URL. This is the default setting.
         - **form**: The web application uses a form to collect and authenticate user credentials. If using this option, you also need to type the user name and password parameters written in the code of the HTML form.
         - **http-basic**: The user name and password are transmitted in Base64 and stored on the server in plain text.
         - **http-digest**: The web server performs the authentication; user names and passwords are not transmitted over the network, nor are they stored in plain text.
         - **ntlm**: Microsoft LAN Manager authentication (also called Integrated Windows Authentication) does not transmit credentials in plain text, but requires a continuous TCP connection between the server and client.
         - **ajax-or-json-request**: The web server uses JSON and AJAX requests to authenticate users trying to access the web application through the login URL. For this option, you also need to type the name of the JSON element containing the user name and password.
         - **request-body**: The web server uses the request body to authenticate users trying to access the web application through the login URL. This allows brute force login detection using, for example, SAML authentication used on Microsoft Federation Services for SSO which uses SOAP API to login.
     - * ajax-or-json-request
       * form
       * http-basic
       * http-digest
       * none
       * ntlm
       * request-body
   * - ``passwordParameterName``

     - string
     - A name of parameter which will contain password string.
     - 
   * - ``passwordRegex``

     - string
     - PCRE regular expression for capturing the password. The regular expression must include exactly one capturing group (in rounded parentheses) for the value of the password. For example: "pwd=(\w+)". The entered expression is validated and any invalid code is noted and must be corrected. Note: This setting is only relevant if authenticationType is request-body.
     - 
   * - `url <policy/urls_>`_

     - object
     - URL string used for login page.
     - 
   * - ``usernameParameterName``

     - string
     - A name of parameter which will contain username string.
     - 
   * - ``usernameRegex``

     - string
     - PCRE regular expression for capturing the username. The regular expression must include exactly one capturing group (in rounded parentheses) for the value of the username. For example: "user_id=(\w+)". The entered expression is validated and any invalid code is noted and must be corrected. Note: This setting is only relevant if authenticationType is request-body.
     - 
```

```eval_rst
.. _policy/login-pages/accessValidation:
```


##### accessValidation



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``cookieContains``

     - string
     - A defined domain cookie name that the response to the login URL must match to permit user access to the authenticated URL.
     - 
   * - ``headerContains``

     - string
     - A header name and value that the response to the login URL must match to permit user access to the authenticated URL.
     - 
   * - ``headerContainsMatchCondition``

     - string
     - 
     - * exact
       * regex
   * - ``headerOmits``

     - string
     - A header name and value that indicates a failed login attempt and prohibits user access to the authenticated URL.
     - 
   * - ``headerOmitsMatchCondition``

     - string
     - 
     - * exact
       * regex
   * - ``parameterContains``

     - string
     - A parameter that must exist in the login URL's HTML body to allow access to the authenticated URL.
     - 
   * - ``responseContains``

     - string
     - A string that must appear in the response for the system to allow the user to access the authenticated URL; for example, "Successful Login".
     - 
   * - ``responseHttpStatus``

     - string
     - An HTTP response code that the server must return to the user to allow access to the authenticated URL; for example, "200".
     - 
   * - ``responseHttpStatusOmits``

     - array of strings
     - An HTTP response code that indicates a failed login attempt and prohibits user access to the authenticated URL.
     - 
   * - ``responseOmits``

     - string
     - A string that indicates a failed login attempt and prohibits user access to the authenticated URL; for example, "Authentication failed".
     - 
```

---


```eval_rst
.. _policy/methods:
```


### methods



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/override-rules:
```


### override-rules



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``actionType``

     - string
     - The action to take when the override rule is matched. Possible values are:
       
         - **extend-policy**: The override policy inherits the containing policy settings, allowing only the required settings to be overridden.
         - **replace-policy**: The override policy must be a valid declarative policy that includes a name, template and all necessary settings.
         - **violation**: The request is blocked and a the VIOL_RULE is logged based on the provided violation settings.
     - * extend-policy
       * replace-policy
       * violation
   * - ``condition``

     - string
     - Specifies the condition under which the override rule should be applied.
       
       Example: "clientIp != '10.0.0.5' and userAgent.lower().contains('WebRobot')"
       
       Condition Syntax:
       
         - The condition consists of one or more clauses separated by **and** or **or**.
       
         Example: "clientIp == '10.0.0.5' and (host.startsWith('internal') or uri.contains('api'))"
       
         - Each clause can optionally start with **not** - to negate the expression.
       
         Example: "not clientIp == '127.0.0.1'"
       
         - **not** can also be used to negate a parenthesized expression.
       
         Example: "not (method == 'GET' or method == 'PUT')"
       
         - A clause can be a simple comparison between two value expressions, or a boolean function applied to a literal value.
       
       Supported comparison operators:
       
         - **==** - Checks for equality between two value expressions.
         - **!=** - Checks for inequality between two value expressions.
       
         Example: "clientIp != '10.0.0.5'" (equivalent to "not clientIp == '10.0.0.5'")
       
       Supported boolean functions:
       
         - **matches**: Performs an exact match of a value expression, equivalent to **==**.
         - **startsWith**: Checks if a value expression starts with a specific substring.
         - **contains**: Checks if a value expression contains a specific substring.
       
         Example: "uri.startsWith('/api')"
       
       **Note**: Functions "startsWith" and "contains" are not applicable to the "clientIp" attribute. Regular expressions are not supported.
       
         - Value expressions can be a request attribute, literal value, or a value function.
         - A literal can be a string value enclosed in single quotes, or can be the keyword "null" without quotes.
       
         Example: "userAgent == null"
       
       Supported value functions:
       
         - **lower**: Any boolean function applied on the resulting string will be **case insensitive**. Applicable to ANSI characters only.
       
         Example: "uri.lower().contains('BaR')" will match the URI "/Foo/bAr"
       
       Request Attributes:
       
         - **clientIp**: Client IP address in canonical IPv4 or IPv6 format or ip-address-list. Use CIDR notation for subnet definition. Example: *192.168.1.2* or *fd00:1::/48*. If *trustXff* (X-Forwarded-For) is enabled in the containing policy, then the value is taken from the configured header (XFF or other). The only supported boolean function for the clientIP attribute is *matches*.
         - **host**: The value of the Host header
         - **method**: The HTTP method in the request
         - **uri**: The URI (path part) of the request
         - **userAgent**: The value of the User-Agent header, or *null* (without quotes) if not present
         - **geolocation**: The geolocation of the client IP address. The value is the ISO 3166 two-letter code of the respective country.
         - **parameters['<name>']**: (map-type) The value of the specified parameter name (limited to query string parameters). Example: "parameters['id'] == '11'"
         - **cookies['<name>']**: (map-type) The value of the specified cookie name. Example: "cookies['Path'].contains('product')"
         - **headers['<name>']**: (map-type) The value of the specified header name. Example: "headers['Accept'].startsWith('application')"
       
       **Note**: 
         - The "headers['<name>']" attribute does not support 'Cookie' as a header name.
         - Attribute "clientIp" supports using "ipAddressLists" in condition: "clientIp.matches(ipAddressLists['<name>'])" 
     - 
   * - ``name``

     - string
     - The unique name of the override rule. Cannot contain spaces or special characters.
     - 
   * - `override <policy/override-rules/override_>`_

     - object
     - The overriding security policy definition.
     - 
   * - `violation <policy/override-rules/violation_>`_

     - object
     - Contains the details of the raised VIOL_RULE violation.
       Mandatory if action-type is violation.
     - 
```

```eval_rst
.. _policy/override-rules/override:
```


##### override



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
```

```eval_rst
.. _policy/override-rules/violation:
```


##### violation



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``alarm``

     - boolean
     - Whether the violation should be marked in the security log and cause the request to be classified as "illegal".
     - 
   * - `attackType <policy/override-rules/violation/attackType_>`_

     - object
     - The attack type associated with the violation in the present rule. This is reflected in the security log.
       Mandatory.
     - 
   * - ``block``

     - boolean
     - Whether the violation should cause the request to be blocked. On other words: the block flag of the VIOL_RULE for the present rule.
     - 
   * - ``description``

     - string
     - Textual description of the violation in the present rule.
       Limited to 200 characters.
       Not Mandatory.
     - 
   * - ``rating``

     - integer
       minimum: 3
       maximum: 5
     - The violation rating that the present rule violation  will induce. In other words, the violation rating of the request will be the maximum between this value and the calculated value based on the other violations in the request.
       If not specified and there is no other violation, then the VR is 3.
     - 
```

```eval_rst
.. _policy/override-rules/violation/attackType:
```


##### attackType



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - The name of the attack type.
       Mandatory.
     - 
```

---


```eval_rst
.. _policy/parameters:
```


### parameters



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowEmptyValue``

     - boolean
     - Determines whether an empty value is allowed for a parameter.
     - 
   * - ``allowRepeatedParameterName``

     - boolean
     - Determines whether multiple parameter instances with the same name are allowed in one request.
     - 
   * - ``arraySerializationFormat``

     - string
     - Specifies type of serialization for array of primitives parameter.
       Serialization defines how multiple values are delimited - format that can be transmitted and reconstructed later:
       
        - **pipe**: pipe-separated values. Array color=["blue","black"] -> color=blue|black.
        - **form**: ampersand-separated values. Array color=["blue","black"] -> color=blue,black.
        - **matrix**: semicolon-prefixed values. Array color=["blue","black"] -> ;color=blue,black.
        - **tsv**: tab-separated values. Array color=["blue","black"] -> color=blue\tblack.
        - **csv**: comma-separated values. Array color=["blue","black"] -> color=blue,black.
        - **label**: dot-prefixed values. Array color=["blue","black"] -> .blue.black.
        - **multi**: multiple parameter instances rather than multiple values. Array color=["blue","black"] -> color=blue&color=black.
        - **ssv**: space-separated values. Array color=["blue","black"] -> color=blue black.
        - **multipart**: defines array of files.
       
       **Notes**:
       
        - This attribute is relevant only for parameters with **array** *valueType*.
        - **multi** and **form** serializations can be defined for parameter with *query*, *form-data* or *cookie* locations only.
        - **multipart** serialization can be defined for parameter with *form-data* location only.
        - **matrix** and **label** serializations can be defined for parameter with *path* location only.
     - * csv
       * form
       * label
       * matrix
       * multi
       * multipart
       * pipe
       * ssv
       * tsv
   * - ``arrayUniqueItemsCheck``

     - boolean
     - Determines whether items in an array parameter must be unique.
       This attribute is relevant only for parameters with **array** *valueType*.
     - 
   * - ``attackSignaturesCheck``

     - boolean
     - Determines whether attack signatures and threat campaigns must be detected in a parameter's value.
       This attribute is relevant only for parameters with **alpha-numeric** or **binary** *dataType*.
     - 
   * - ``checkMaxItemsInArray``

     - boolean
     - Determines whether an array parameter has a restricted maximum number of items.
       This attribute is relevant only for parameters with **array** *valueType*.
     - 
   * - ``checkMaxValue``

     - boolean
     - Determines whether the parameter has a restricted maximum value.
       This attribute is relevant only for parameters with **integer** or **decimal** *dataType*.
     - 
   * - ``checkMaxValueLength``

     - boolean
     - Determines whether a parameter has a restricted maximum length for value.
     - 
   * - ``checkMetachars``

     - boolean
     - Determines whether disallowed metacharacters must be detected in a parameter's name.
       This attribute is relevant only for **wildcard** parameters with **alpha-numeric** *dataType*.
     - 
   * - ``checkMinItemsInArray``

     - boolean
     - Determines whether an array parameter has a restricted minimum number of items.
       This attribute is relevant only for parameters with **array** *valueType*.
     - 
   * - ``checkMinValue``

     - boolean
     - Determines whether a parameter has a restricted minimum value.
       This attribute is relevant only for parameters with **integer** or **decimal** *dataType*.
     - 
   * - ``checkMinValueLength``

     - boolean
     - Determines whether a parameter has a restricted minimum length for value.
     - 
   * - ``checkMultipleOfValue``

     - boolean
     - Determines whether a parameter's value is a multiple of a number defined in *multipleOf*.
       This attribute is relevant only for parameters with **integer** or **decimal** *dataType*.
     - 
   * - `contentProfile <policy/parameters/contentProfile_>`_

     - object
     - 
     - 
   * - ``dataType``

     - string
     - Specifies data type of parameter's value:
       
        - **alpha-numeric**: specifies that the value of parameter can be any text consisting of letters, digits, and the underscore character.
        - **binary**: specifies there is no text limit for the value of a parameter (length checks only).
        - **phone**: specifies that the value of a parameter can be text in telephone number format only.
        - **email**: specifies that the value of a parameter must be text in email format only.
        - **boolean**: specifies that the value of a parameter must be boolean (only *true* and  *false* values are allowed).
        - **integer**: specifies that the value of a parameter must be whole numbers only (no decimals).
        - **decimal**: specifies that the value of a parameter is numbers only and can include decimals.
       
       **Notes**:
         -  This attribute is relevant for parameters with **array** or **user-input** *valueType* only.
     - * alpha-numeric
       * binary
       * phone
       * email
       * boolean
       * integer
       * decimal
   * - ``decodeValueAsBase64``

     - string
     - Specifies whether the the system should detect or require values to be Base64 encoded:
       
        - **disabled**: the value will not be decoded as Base64 content.
        - **enabled**: the value will be checked whether it can be decoded as Base64 and, if so, security checks will be performed on the decoded value.
        - **required**: the value must be decoded as Base64. Security checks will be performed on the decoded value.
       
       **Notes**:
         -  This attribute is relevant for parameters with **binary**, **auto-detect**, or **user-input** *valueType* only.
     - * disabled
       * enabled
       * required
   * - ``disallowFileUploadOfExecutables``

     - boolean
     - Determines whether a parameter's value cannot have binary executable content.
       This attribute is relevant only for parameters with **binary** *dataType*.
     - 
   * - ``enableRegularExpression``

     - boolean
     - Determines whether the parameter value includes the pattern defined in *regularExpression*.
       This attribute is relevant only for parameters with **alpha-numeric** *dataType*.
     - 
   * - ``exclusiveMax``

     - boolean
     - Determines whether the maximum value defined in *maximumValue* attribute is exclusive.
       This attribute is relevant only if *checkMaxValue* is set to **true**.
     - 
   * - ``exclusiveMin``

     - boolean
     - Determines whether a minimum value defined in *minimumValue* attribute is exclusive.
       This attribute is relevant only if *checkMinValue* is set to **true**.
     - 
   * - ``explodeObjectSerialization``

     - boolean
     - Specifies whether an array or object parameters should have separate values for each array item or object property.
       This attribute is relevant only if *objectSerializationStyle* is defined.
       
       **Notes**:
         -  This attribute is not relevant for parameters with **deep-object**, **space-delimited** or **pipe-delimited** *objectSerializationStyle*.
     - 
   * - ``hostNameRepresentation``

     - string
     - 
     - * any
       * domain-name
       * ip-address
   * - ``isCookie``

     - boolean
     - Determines whether a parameter is located in the value of Cookie header.
       *parameterLocation* attribute is ignored if **isCookie** is set to *true*.
     - 
   * - ``isHeader``

     - boolean
     - Determines whether a parameter is located in headers as one of the headers.
       *parameterLocation* attribute is ignored if **isHeader** is set to *true*.
     - 
   * - ``level``

     - string
     - Specifies whether the parameter is associated with a URL, a flow, or neither.
     - * global
       * url
   * - ``mandatory``

     - boolean
     - Determines whether a parameter must exist in the request.
     - 
   * - ``maxItemsInArray``

     - integer
       minimum: 0
     - Determines the restriction for the maximum number of items in an array parameter.
       This attribute is relevant only if *checkMaxItemsInArray* is set to **true**.
     - 
   * - ``maximumLength``

     - integer
       minimum: 0
     - Determines the restriction for the maximum length of parameter's value.
       This attribute is relevant only if *checkMaxValueLength* is set to **true**.
     - 
   * - ``maximumValue``

     - number
     - Determines the restriction for the maximum value of parameter.
       This attribute is relevant only if *checkMaxValue* is set to **true**.
     - 
   * - ``metacharsOnParameterValueCheck``

     - boolean
     - Determines whether disallowed metacharacters must be detected in a parameter's value.
       This attribute is relevant only for parameters with **alpha-numeric** *dataType*.
     - 
   * - ``minItemsInArray``

     - integer
       minimum: 0
     - Determines the restriction for the minimum number of items in an array parameter.
       This attribute is relevant only if *checkMinItemsInArray* is set to **true**.
     - 
   * - ``minimumLength``

     - integer
       minimum: 0
     - Determines the restriction for the minimum length of parameter's value.
       This attribute is relevant only if *checkMinValueLength* is set to **true**.
     - 
   * - ``minimumValue``

     - number
     - Determines the restriction for the minimum value of a parameter.
       This attribute is relevant only if *checkMinValue* is set to **true**.
     - 
   * - ``multipleOf``

     - number
     - Determines the number by which a parameter's value is divisible without remainder.
       This number must be positive and it may be a floating-point number.
       This attribute is relevant only if *checkMultipleOfValue* is set to **true**.
     - 
   * - ``name``

     - string
     - Specifies the name of a parameter which must be permitted in requests.
       Format of parameter name attribute differs depending on *type* attribute:
        - **explicit** *type*: name of permitted parameter in request should literally match.
        - **wildcard** *type*: name of permitted parameter in request should match wildcard expression.
       
       The syntax for wildcard entities is based on shell-style wildcard characters.
       The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.
       
        - **\***: Matches all characters
        - **?**: Matches any single character
        - **[abcde]**: Matches exactly one of the characters listed
        - **[!abcde]**: Matches any character not listed
        - **[a-e]**: Matches exactly one character in the range
        - **[!a-e]**: Matches any character not in the range
       
       **Notes**:
        - Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.
        - Empty parameter name is allowed for **explicit** *type*
     - 
   * - `nameMetacharOverrides <policy/parameters/nameMetacharOverrides_>`_

     - array of objects
     - Determines metacharacters whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request for this parameter that has these metacharacters in the name.
       This attribute is relevant only if *checkMetachars* is set to **true**.
     - 
   * - ``objectSerializationStyle``

     - string
     - Specifies the type of serialization for an object or complex array parameter.
       Serialization defines how multiple values are delimited - format that can be transmitted and reconstructed later:
       
        - **pipe-delimited**: pipe-separated values. Object color={"R":100,"G":200} -> color=R|100|G|200.
        - **form**: ampersand-separated values. Object color={"R":100,"G":200} -> color=R,100,G,200 if *explodeObjectSerialization* set to **false** or -> R=100&G=200 if *explodeObjectSerialization* set to **true**.
        - **space-delimited**: space-separated values. Object color={"R":100,"G":200} -> color=R 100 G 200.
        - **deep-object**: rendering nested objects. Object color={"R":100,"G":200} -> color[R]=100&color[G]=200.
        - **matrix**: semicolon-prefixed values. Object color={"R":100,"G":200} -> ;color=R,100,G,200 if *explodeObjectSerialization* set to **false** or -> ;R=100;G=200 if *explodeObjectSerialization* set to **true**.
        - **simple**: comma-separated values. Object color={"R":100,"G":200} -> R,100,G,200 if *explodeObjectSerialization* set to **false** or -> R=100,G=200 if *explodeObjectSerialization* set to **true**.
        - **label**: dot-prefixed values. Object color={"R":100,"G":200} -> .R.100.G.200 if *explodeObjectSerialization* set to **false** or -> .R=100.G=200 if *explodeObjectSerialization* set to **true**.
       
       **Notes**:
       
        - This attribute is relevant only for parameters with **object** or **openapi-array** *valueType*.
        - **form** serialization can be defined for a parameter with *query*, *form-data* or *cookie* locations only.
        - **matrix** and **label** serializations can be defined for an array parameter with *path* location only.
        - **simple** serializations can be defined for a parameter with *path* and *header* locations only.
        - **deep-object** serialization can be defined for a parameter with *query* or *form-data* locations only.
     - * deep-object
       * form
       * label
       * matrix
       * pipe-delimited
       * simple
       * space-delimited
   * - ``parameterEnumValues``

     - array of strings
     - Determines the set of possible parameter's values.
       This attribute is not relevant for parameters with **phone**, **email** or **binary** *dataType*.
     - 
   * - ``parameterLocation``

     - string
     - Specifies location of parameter in request:
       
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
     - * any
       * cookie
       * form-data
       * header
       * path
       * query
   * - ``regularExpression``

     - string
     - Determines a positive regular expression (PCRE) for a parameter's value.
       This attribute is relevant only if *enableRegularExpression* is set to **true**.
       
       **Notes**:
        - The length of a regular expression is limited to 254 characters.
     - 
   * - ``sensitiveParameter``

     - boolean
     - Determines whether a parameter is sensitive and must be not visible in logs nor in the user interface.
       Instead of the actual value, a string of asterisks is shown for this parameter.
       Use it to protect sensitive user input, such as a password or a credit card number, in a validated request.
     - 
   * - `signatureOverrides <policy/parameters/signatureOverrides_>`_

     - array of objects
     - Determines attack signatures whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request for this parameter that matches these attack signatures.
       This attribute is relevant only if *signatureOverrides* is set to **true**.
     - 
   * - ``staticValues``

     - array of strings
     - Determines the set of possible parameter's values.
       This attribute is relevant for parameters with **static-content** *valueType* only.
     - 
   * - ``type``

     - string
     - Specifies the type of the *name* attribute.
     - * explicit
       * wildcard
   * - `url <policy/urls_>`_

     - object
     - 
     - 
   * - `valueMetacharOverrides <policy/parameters/valueMetacharOverrides_>`_

     - array of objects
     - Determines metacharacters whose security policy settings are overridden for this parameter, and which action the security policy takes when it discovers a request parameter that has these metacharacters in its value.
       This attribute is relevant only if *metacharsOnParameterValueCheck* is set to **true**.
     - 
   * - ``valueType``

     - string
     - Specifies type of parameter's value:
       
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
     - * array
       * auto-detect
       * ignore
       * json
       * object
       * openapi-array
       * static-content
       * user-input
       * xml
   * - ``wildcardOrder``

     - integer
     - Specifies the order in which wildcard entities are organized.
       Matching of an enforced parameter with a defined wildcard parameter happens based on order from smaller to larger.
     - 
```

```eval_rst
.. _policy/parameters/contentProfile:
```


##### contentProfile



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `contentProfile <policy/parameters/contentProfile/contentProfile_>`_

     - object
     - 
     - 
```

```eval_rst
.. _policy/parameters/contentProfile/contentProfile:
```


##### contentProfile



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - 
     - 
```

```eval_rst
.. _policy/parameters/nameMetacharOverrides:
```


##### nameMetacharOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isAllowed``

     - boolean
     - Specifies permission of *metachar* - when *false*, then character is prohibited.
     - 
   * - ``metachar``

     - string
     - Specifies character in hexadecimal format with special allowance.
     - 
```

```eval_rst
.. _policy/parameters/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - Specifies, when true, that the overridden signature is enforced
     - 
   * - ``name``

     - string
     - The signature name which, along with the signature tag, identifies the signature.
     - 
   * - ``signatureId``

     - integer
     - The signature ID which identifies the signature.
     - 
   * - ``tag``

     - string
     - The signature tag which, along with the signature name, identifies the signature.
     - 
```

```eval_rst
.. _policy/parameters/valueMetacharOverrides:
```


##### valueMetacharOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isAllowed``

     - boolean
     - Specifies permission of *metachar* - when *false*, then character is prohibited.
     - 
   * - ``metachar``

     - string
     - Specifies character in hexadecimal format with special allowance.
     - 
```

---


```eval_rst
.. _policy/response-pages:
```


### response-pages



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``ajaxActionType``

     - string
     - Which content, or URL, the system sends to the client as a response to an AJAX request that does not comply with the security policy.
         - **alert-popup**: The system opens a message as a popup screen. Type the message the system displays in the popup screen, or leave the default text.
         - **custom**: A response text that will replace the frame or page which generated the AJAX request. The system provides additional options where you can type the response body you prefer.
         - **redirect**: The system redirects the user to a specific web page instead of viewing a response page. Type the web page's full URL path, for example, http://www.redirectpage.com. 
     - * alert-popup
       * custom
       * redirect
   * - ``ajaxCustomContent``

     - string
     - Custom message typed by user as a response for blocked AJAX request.
     - 
   * - ``ajaxEnabled``

     - boolean
     - When enabled, the system injects JavaScript code into responses. You must enable this toggle in order to configure an Application Security Manager AJAX response page which is returned when the system detects an AJAX request that does not comply with the security policy.
     - 
   * - ``ajaxPopupMessage``

     - string
     - Default message provided by the system as a response for blocked AJAX request. Can be manipulated by user, but <%TS.request.ID()%> must be included in this message.
     - 
   * - ``ajaxRedirectUrl``

     - string
     - The system redirects the user to a specific web page instead of viewing a response page. Type the web page's full URL path, for example, http://www.redirectpage.com. To redirect the blocking page to a URL with a support ID in the query string, type the URL and the support ID in the following format: http://www.example.com/blocking_page.php?support_id=<%TS.request.ID()%>. The system replaces <%TS.request.ID%> with the relevant support ID so that the blocked request is redirected to the URL with the relevant support ID.
     - 
   * - ``grpcStatusCode``

     - 
       * integer
       * string
     - 
     - * Integer values
       * "ABORTED"
   * - ``grpcStatusMessage``

     - string
     - 
     - 
   * - ``responseActionType``

     - string
     - Which action the system takes, and which content the system sends to the client, as a response when the security policy blocks the client request.
         - **custom**: The system returns a response page with HTML code that the user defines.
         - **default**: The system returns the system-supplied response page in HTML. No further configuration is needed.
         - **erase-cookies**:  The system deletes all client side domain cookies. This is done in order to block web application users once, and not from the entire web application. The system displays this text in the response page. You cannot edit this text.
         - **redirect**: The system redirects the user to a specific web page instead of viewing a response page. The system provides an additional setting where you can indicate the redirect web page.
         - **soap-fault**:  Displays the system-supplied response written in SOAP fault message structure. Use this type when a SOAP request is blocked due to an XML related violation. You cannot edit this text.
     - * custom
       * default
       * erase-cookies
       * redirect
       * soap-fault
   * - ``responseContent``

     - string
     - The content the system sends to the client in response to an illegal blocked request.
     - 
   * - ``responseHeader``

     - string
     - The response headers that the system sends to the client as a response to an illegal blocked request.
     - 
   * - ``responsePageType``

     - string
     - The different types of blocking response pages which are available from the system:
         - **ajax**: The system sends the AJAX Blocking Response Page when the security policy blocks an AJAX request that does not comply with the security policy.
         - **default**: The system sends the default response when the security policy blocks a client request.
         - **graphql**: The system sends the GraphQL response when the security policy blocks a client request that contains GraphQL message that does not comply with the settings of a GraphQL profile configured in the security policy.
         - **grpc**: The system sends the gRPC response when the security policy blocks a client request that contains gRPC message that does not comply with the settings of a gRPC profile configured in the security policy.
         - **xml**: The system sends the XML response page when the security policy blocks a client request that contains XML content that does not comply with the settings of an XML profile configured in the security policy.
     - * ajax
       * default
       * graphql
       * grpc
       * xml
   * - ``responseRedirectUrl``

     - string
     - The particular URL to which the system redirects the user. To redirect the blocking page to a URL with a support ID in the query string, type the URL and the support ID in the following format: http://www.example.com/blocking_page.php?support_id=<%TS.request.ID()%>. The system replaces <%TS.request.ID%> with the relevant support ID so that the blocked request is redirected to the URL with the relevant support ID.
     - 
```

---


```eval_rst
.. _policy/sensitive-parameters:
```


### sensitive-parameters



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - Name of a parameter whose values the system should consider sensitive.
     - 
```

---


```eval_rst
.. _policy/server-technologies:
```


### server-technologies



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``serverTechnologyName``

     - string
     - Specifies the name of the selected policy. For example, PHP will add attack signatures that cover known PHP vulnerabilities.
     - 
```

---


```eval_rst
.. _policy/signature-requirements:
```


### signature-requirements



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``maxRevisionDatetime``

     - string
     - 
     - 
   * - ``minRevisionDatetime``

     - string
     - 
     - 
   * - ``tag``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/signature-sets:
```


### signature-sets



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``alarm``

     - boolean
     - If enabled - when a signature from this signature set is detected in a request - the request is logged.
     - 
   * - ``block``

     - boolean
     - If enabled - when a signature from this signature set is detected in a request - the request is blocked.
     - 
   * - ``learn``

     - boolean
     - If enabled - when a signature from this signature set is detected in a request -the policy builder creates a learning suggestion to disable it.
     - 
   * - ``name``

     - string
     - Signature set name.
     - 
   * - `signatureSet <policy/signature-sets/signatureSet_>`_

     - object
     - Defines signature set.
     - 
   * - ``stagingCertificationDatetime``

     - string
     - 
     - * 
```

```eval_rst
.. _policy/signature-sets/signatureSet:
```


##### signatureSet



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `filter <policy/signature-sets/signatureSet/filter_>`_

     - object
     - Specifies filter that defines signature set.
     - 
   * - `signatures <policy/signature-sets/signatureSet/signatures_>`_

     - array of objects
     - 
     - 
   * - `systems <policy/signature-sets/signatureSet/systems_>`_

     - array of objects
     - 
     - 
   * - ``type``

     - string
     - 
     - * filter-based
       * manual
```

```eval_rst
.. _policy/signature-sets/signatureSet/filter:
```


##### filter



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``accuracyFilter``

     - string
     - 
     - * all
       * eq
       * ge
       * le
   * - ``accuracyValue``

     - string
     - 
     - * all
       * high
       * low
       * medium
   * - `attackType <policy/signature-sets/signatureSet/filter/attackType_>`_

     - object
     - 
     - 
   * - ``hasCve``

     - string
     - 
     - * all
       * no
       * yes
   * - ``lastUpdatedFilter``

     - string
     - 
     - * after
       * all
       * before
   * - ``lastUpdatedValue``

     - string
     - 
     - 
   * - ``riskFilter``

     - string
     - 
     - * all
       * eq
       * ge
       * le
   * - ``riskValue``

     - string
     - 
     - * all
       * high
       * low
       * medium
   * - ``signatureType``

     - string
     - 
     - * all
       * request
       * response
   * - ``tagFilter``

     - string
     - Filter by signature tagValue.
       
         - **all**: no filter applied.
         - **eq**: only signatures with a tag that equals tagValue are added to the signature set.
         - **untagged**: only signatures without a tag are added to the signature set.
     - * all
       * eq
       * untagged
   * - ``tagValue``

     - string
     - Value for the tagFilter.
       Relevant only for the **eq** value of tagFilter.
     - 
   * - ``userDefinedFilter``

     - string
     - 
     - * all
       * no
       * yes
```

```eval_rst
.. _policy/signature-sets/signatureSet/filter/attackType:
```


##### attackType



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - 
     - 
```

```eval_rst
.. _policy/signature-sets/signatureSet/signatures:
```


##### signatures



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - 
     - 
   * - ``signatureId``

     - integer
     - 
     - 
   * - ``tag``

     - string
     - 
     - 
```

```eval_rst
.. _policy/signature-sets/signatureSet/systems:
```


##### systems



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/signature-settings:
```


### signature-settings



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``minimumAccuracyForAutoAddedSignatures``

     - string
     - 
     - * high
       * low
       * medium
   * - ``signatureStaging``

     - boolean
     - 
     - 
   * - ``stagingCertificationDatetime``

     - string
     - 
     - * 
```

---


```eval_rst
.. _policy/signatures:
```


### signatures



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - Specifies, if true, that the signature is enabled on the security policy. When false, the signature is disable on the security policy.
     - 
   * - ``learn``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - The signature name which, along with the signature tag, identifies the signature.
     - 
   * - ``performStaging``

     - boolean
     - Specifies, if true, that the signature is in staging.
       The system does not enforce signatures in staging. Instead, the system records the request information and keeps it for a period of time
       (the Enforcement Readiness Period whose default time period is 7 days).
       Specifies, when false, that the staging feature is not in use, and that the system enforces the signatures' Learn/Alarm/Block settings immediately.
       (Blocking is performed only if the security policy's enforcement mode is Blocking.)
     - 
   * - ``signatureId``

     - integer
     - The signature ID which identifies the signature.
     - 
   * - ``tag``

     - string
     - The signature tag which, along with the signature name, identifies the signature.       
     - 
```

---


```eval_rst
.. _policy/threat-campaigns:
```


### threat-campaigns



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``displayName``

     - string
     - 
     - 
   * - ``isEnabled``

     - boolean
     - If enabled - threat campaign is enforced in the security policy.
     - 
   * - ``name``

     - string
     - Name of the threat campaign.
     - 
```

---


```eval_rst
.. _policy/urls:
```


### urls



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `accessProfile <policy/access-profiles_>`_

     - object
     - 
     - 
   * - ``allowRenderingInFrames``

     - string
     - Specifies the conditions for when the browser should allow this URL to be rendered in a frame or iframe.
       never: Specifies that this URL must never be rendered in a frame or iframe. The web application instructs browsers to hide, or disable, frame and iframe parts of this URL.
       only-same: Specifies that the browser may load the frame or iframe if the referring page is from the same protocol, port, and domain as this URL. This limits the user to navigate only within the same web application.
     - * never
       * only-same
   * - ``allowRenderingInFramesOnlyFrom``

     - string
     - Specifies that the browser may load the frame or iframe from a specified domain. Type the protocol and domain in URL format for example, http://www.mywebsite.com. Do not enter a sub-URL, such as http://www.mywebsite.com/index.
     - 
   * - ``attackSignaturesCheck``

     - boolean
     - Specifies, when true, that you want attack signatures and threat campaigns to be detected on this URL and possibly override the security policy settings of an attack signature or threat campaign specifically for this URL. After you enable this setting, the system displays a list of attack signatures and threat campaigns.
     - 
   * - `authorizationRules <policy/urls/authorizationRules_>`_

     - array of objects
     - 
     - 
   * - ``canChangeDomainCookie``

     - boolean
     - 
     - 
   * - ``clickjackingProtection``

     - boolean
     - Specifies that the system adds the X-Frame-Options header to the domain URL's response header. This is done to protect the web application against clickjacking. Clickjacking occurs when an attacker lures a user to click illegitimate frames and iframes because the attacker hid them on legitimate visible website buttons. Therefore, enabling this option protects the web application from other web sites hiding malicious code behind them. The default is disabled. After you enable this option, you can select whether, and under what conditions, the browser should allow this URL to be rendered in a frame or iframe.
     - 
   * - ``disallowFileUploadOfExecutables``

     - boolean
     - 
     - 
   * - `html5CrossOriginRequestsEnforcement <policy/urls/html5CrossOriginRequestsEnforcement_>`_

     - object
     - The system extracts the Origin (domain) of the request from the Origin header.
     - 
   * - ``isAllowed``

     - boolean
     - If *true*, the URLs allowed by the security policy.
     - 
   * - ``mandatoryBody``

     - boolean
     - A request body is mandatory. This is relevant for any method acting as POST.
     - 
   * - `metacharOverrides <policy/urls/metacharOverrides_>`_

     - array of objects
     - To allow or disallow specific meta characters in the name of this specific URL (and thus override the global meta character settings).
     - 
   * - ``metacharsOnUrlCheck``

     - boolean
     - Specifies, when true, that you want meta characters to be detected on this URL and possibly override the security policy settings of a meta character specifically for this URL. After you enable this setting, the system displays a list of meta characters.
     - 
   * - ``method``

     - string
     - Unique ID of a URL with a protocol type and name. Select a Method for the URL to create an API endpoint: URL + Method.
     - * ACL
       * BCOPY
       * BDELETE
       * BMOVE
       * BPROPFIND
       * BPROPPATCH
       * CHECKIN
       * CHECKOUT
       * CONNECT
       * COPY
       * DELETE
       * GET
       * HEAD
       * LINK
       * LOCK
       * MERGE
       * MKCOL
       * MKWORKSPACE
       * MOVE
       * NOTIFY
       * OPTIONS
       * PATCH
       * POLL
       * POST
       * PROPFIND
       * PROPPATCH
       * PUT
       * REPORT
       * RPC_IN_DATA
       * RPC_OUT_DATA
       * SEARCH
       * SUBSCRIBE
       * TRACE
       * TRACK
       * UNLINK
       * UNLOCK
       * UNSUBSCRIBE
       * VERSION_CONTROL
       * X-MS-ENUMATTS
       * \*
   * - `methodOverrides <policy/urls/methodOverrides_>`_

     - array of objects
     - Specifies a list of methods that are allowed or disallowed for a specific URL. The list overrides the list of methods allowed or disallowed globally at the policy level.
     - 
   * - ``methodsOverrideOnUrlCheck``

     - boolean
     - Specifies, when true, that you want methods to be detected on this URL and possibly override the security policy settings of a method specifically for this URL. After you enable this setting, the system displays a list of methods.
     - 
   * - ``name``

     - string
     - Specifies an HTTP URL that the security policy allows. The available types are:
       
         - **Explicit**: Specifies that the URL has a specific name and is not a wildcard entity. Type the name of a URL exactly as you expect it to appear in the request.
         - **Wildcard**: Specifies that any URL that matches the listed wildcard expression should be treated according to the wildcard attributes. Type a wildcard expression that matches the expected URL. For example, entering the wildcard expression * specifies that any URL is allowed by the security policy.
       The syntax for wildcard entities is based on shell-style wildcard characters. The list below describes the wildcard characters that you can use so that the entity name can match multiple objects.
       
         - **\***: Matches all characters
         - **?**: Matches any single character
         - **[abcde]**: Matches exactly one of the characters listed
         - **[!abcde]**: Matches any character not listed
         - **[a-e]**: Matches exactly one character in the range
         - **[!a-e]**: Matches any character not in the range
       
       **Note**: Wildcards do not match regular expressions. Do not use a regular expression as a wildcard.
     - 
   * - ``operationId``

     - string
     - The attribute operationId is used as an OpenAPI endpoint identifier.
     - 
   * - `positionalParameters <policy/urls/positionalParameters_>`_

     - array of objects
     - When checked (enabled), positional parameters are enabled in the URL.
     - 
   * - ``protocol``

     - string
     - Specifies whether the protocol for the URL is HTTP or HTTPS.
     - * http
       * https
   * - `signatureOverrides <policy/urls/signatureOverrides_>`_

     - array of objects
     - Array of signature overrides.
       Specifies attack signatures whose security policy settings are overridden for this URL, and which action the security policy takes when it discovers a request for this URL that matches these attack signatures.
     - 
   * - ``type``

     - string
     - Determines the type of the **name** attribute. Only when setting the type to wildcard will the special wildcard characters in the name be interpreted as such.
     - * explicit
       * wildcard
   * - `urlContentProfiles <policy/urls/urlContentProfiles_>`_

     - array of objects
     - Specifies how the system recognizes and enforces requests for this URL according to the requests' header content. The system automatically creates a default header-based content profile for HTTP, and you cannot delete it. However, requests for a URL may contain other types of content, such as JSON, XML, or other proprietary formats.
     - 
   * - ``wildcardOrder``

     - integer
     - Specifies the order index for wildcard URLs matching. Wildcard URLs with lower wildcard order will get checked for a match prior to URLs with higher wildcard order.
     - 
```

```eval_rst
.. _policy/urls/authorizationRules:
```


##### authorizationRules



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``condition``

     - string
     - 
     - 
   * - ``name``

     - string
     - 
     - 
```

```eval_rst
.. _policy/urls/html5CrossOriginRequestsEnforcement:
```


##### html5CrossOriginRequestsEnforcement



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowOriginsEnforcementMode``

     - string
     - Allows you to specify a list of origins allowed to share data returned by this URL.
     - * replace-with
       * unmodified
   * - ``checkAllowedMethods``

     - boolean
     - Allows you to specify a list of methods that other web applications hosted in different domains can use when requesting this URL.
     - 
   * - `crossDomainAllowedOrigin <policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin_>`_

     - array of objects
     - Allows you to specify a list of origins allowed to share data returned by this URL.
     - 
   * - ``enforcementMode``

     - string
     - Specify the option to determine how to handle CORS requests.
       disabled: Do nothing related to cross-domain requests. Pass CORS requests exactly as set by the server.
       enforce: Allow cross-origin resource sharing as configured in the crossDomainAllowedOrigin setting. CORS requests are allowed from the domains specified as allowed origins. 
     - * disabled
       * enforce
```

```eval_rst
.. _policy/urls/html5CrossOriginRequestsEnforcement/crossDomainAllowedOrigin:
```


##### crossDomainAllowedOrigin



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``includeSubDomains``

     - boolean
     - If *true*, sub-domains of the allowed origin are also allowed to receive data from your web application.
     - 
   * - ``originName``

     - string
     - Type the domain name or IP address with which the URL can share data.
       Wildcards are allowed in the names. For example: *.f5.com will match b.f5.com; however it will not match a.b.f5.com.
     - 
   * - ``originPort``

     - 
       * integer
         minimum: 0
         maximum: 65535
       * string
     - Select the port that other web applications can use to request data from your web application, or use the * wildcard for all ports.
     - * Integer values
       * "all"
   * - ``originProtocol``

     - string
     - Select the appropriate protocol for the allowed origin.
     - * http
       * http/https
       * https
```

```eval_rst
.. _policy/urls/metacharOverrides:
```


##### metacharOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isAllowed``

     - boolean
     - If *true*, metacharacters and other characters are allowed in a URL.
     - 
   * - ``metachar``

     - string
     - ASCII representation of the character in Hex format
     - 
```

```eval_rst
.. _policy/urls/methodOverrides:
```


##### methodOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowed``

     - boolean
     - Specifies that the system allows you to override allowed methods for this URL. When selected, the global policy settings for methods are listed, and you can change what is allowed or disallowed for this URL.
     - 
   * - ``method``

     - string
     - Specifies a list of existing HTTP methods. All security policies accept standard HTTP methods by default.
     - * ACL
       * BCOPY
       * BDELETE
       * BMOVE
       * BPROPFIND
       * BPROPPATCH
       * CHECKIN
       * CHECKOUT
       * CONNECT
       * COPY
       * DELETE
       * GET
       * HEAD
       * LINK
       * LOCK
       * MERGE
       * MKCOL
       * MKWORKSPACE
       * MOVE
       * NOTIFY
       * OPTIONS
       * PATCH
       * POLL
       * POST
       * PROPFIND
       * PROPPATCH
       * PUT
       * REPORT
       * RPC_IN_DATA
       * RPC_OUT_DATA
       * SEARCH
       * SUBSCRIBE
       * TRACE
       * TRACK
       * UNLINK
       * UNLOCK
       * UNSUBSCRIBE
       * VERSION_CONTROL
       * X-MS-ENUMATTS
```

```eval_rst
.. _policy/urls/positionalParameters:
```


##### positionalParameters



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `parameter <policy/parameters_>`_

     - object
     - 
     - 
   * - ``urlSegmentIndex``

     - integer
       minimum: 1
     - Select which to add: Text or Parameter and enter your desired segments. You can add multiple text and parameter segments.
     - 
```

```eval_rst
.. _policy/urls/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - Specifies, when true, that the overridden signature is enforced
     - 
   * - ``name``

     - string
     - The signature name which, along with the signature tag, identifies the signature.
     - 
   * - ``signatureId``

     - integer
     - The signature ID which identifies the signature.
     - 
   * - ``tag``

     - string
     - The signature tag which, along with the signature name, identifies the signature.
     - 
```

```eval_rst
.. _policy/urls/urlContentProfiles:
```


##### urlContentProfiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `contentProfile <policy/urls/urlContentProfiles/contentProfile_>`_

     - object
     - 
     - 
   * - ``decodeValueAsBase64``

     - string
     - 
     - * disabled
       * required
   * - ``headerName``

     - string
     - Specifies an explicit header name that must appear in requests for this URL. This field is not case-sensitive.
     - 
   * - ``headerOrder``

     - 
       * integer
       * string
     - Displays the order in which the system checks header content of requests for this URL.
     - * Integer values
       * "default"
   * - ``headerValue``

     - string
     - Specifies a simple pattern string (glob pattern matching) for the header value that must appear in legal requests for this URL; for example, *json*, xml_method?, or method[0-9]. If the header includes this pattern, the system assumes the request contains the type of data you select in the Request Body Handling setting. This field is case-sensitive.
     - 
   * - ``type``

     - string
     - - **Apply Content Signatures**: Do not parse the content; scan the entire payload with full-content attack signatures.
         - **Apply Value and Content Signatures**: Do not parse the content or extract parameters; process the entire payload with value and full-content attack signatures.
         - **Disallow**: Block requests for an URL containing this header content. Log the Illegal Request Content Type violation.
         - **Do Nothing**: Do not inspect or parse the content. Handle the header of the request as specified by the security policy.
         - **Form Data**: Parse content as posted form data in either URL-encoded or multi-part formats. Enforce the form parameters according to the policy.
         - **GWT**: Perform checks for data in requests, based on the configuration of the GWT (Google Web Toolkit) profile associated with this URL.
         - **JSON**: Review JSON data using an associated JSON profile, and use value attack signatures to scan the element values.
         - **XML**: Review XML data using an associated XML profile.
     - * apply-content-signatures
       * apply-value-and-content-signatures
       * disallow
       * do-nothing
       * form-data
       * graphql
       * grpc
       * json
       * xml
```

```eval_rst
.. _policy/urls/urlContentProfiles/contentProfile:
```


##### contentProfile



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``name``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/urls:
```


### urls



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `parameters <policy/urls_parameters_>`_

     - array of objects
     - 
     - 
```

---


```eval_rst
.. _policy/xml-profiles:
```


### xml-profiles



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``attackSignaturesCheck``

     - boolean
     - 
     - 
   * - `defenseAttributes <policy/xml-profiles/defenseAttributes_>`_

     - object
     - 
     - 
   * - ``description``

     - string
     - 
     - 
   * - ``metacharAttributeCheck``

     - boolean
     - 
     - 
   * - ``metacharElementCheck``

     - boolean
     - 
     - 
   * - `metacharOverrides <policy/xml-profiles/metacharOverrides_>`_

     - array of objects
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - `signatureOverrides <policy/xml-profiles/signatureOverrides_>`_

     - array of objects
     - 
     - 
   * - ``useXmlResponsePage``

     - boolean
     - 
     - 
```

```eval_rst
.. _policy/xml-profiles/defenseAttributes:
```


##### defenseAttributes



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``allowCDATA``

     - boolean
     - 
     - 
   * - ``allowDTDs``

     - boolean
     - 
     - 
   * - ``allowExternalReferences``

     - boolean
     - 
     - 
   * - ``allowProcessingInstructions``

     - boolean
     - 
     - 
   * - ``maximumAttributeValueLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumAttributesPerElement``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumChildrenPerElement``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumDocumentDepth``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumDocumentSize``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumElements``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumNSDeclarations``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumNameLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``maximumNamespaceLength``

     - 
       * integer
         minimum: 0
         maximum: 2147483647
       * string
     - 
     - * Integer values
       * "any"
   * - ``tolerateCloseTagShorthand``

     - boolean
     - 
     - 
   * - ``tolerateLeadingWhiteSpace``

     - boolean
     - 
     - 
   * - ``tolerateNumericNames``

     - boolean
     - 
     - 
```

```eval_rst
.. _policy/xml-profiles/metacharOverrides:
```


##### metacharOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``isAllowed``

     - boolean
     - 
     - 
   * - ``metachar``

     - string
     - 
     - 
```

```eval_rst
.. _policy/xml-profiles/signatureOverrides:
```


##### signatureOverrides



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``enabled``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - 
     - 
   * - ``signatureId``

     - integer
     - 
     - 
   * - ``tag``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/blocking-settings_evasions:
```


### evasions



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``description``

     - string
     - Human-readable name of sub-violation.
     - * %u decoding
       * Apache whitespace
       * Bad unescape
       * Bare byte decoding
       * Directory traversals
       * IIS Unicode codepoints
       * IIS backslashes
       * Multiple decoding
       * Multiple slashes
       * Semicolon path parameters
   * - ``enabled``

     - boolean
     - Defines if sub-violation is enforced - alarmed or blocked, according to the 'Evasion technique detected' (VIOL_EVASION) violation blocking settings.
     - 
   * - ``learn``

     - boolean
     - Defines if sub-violation is learned. Sub-violations are learned only when learn is enabled for the 'Evasion technique detected' (VIOL_EVASION) violation.
     - 
   * - ``maxDecodingPasses``

     - integer
       minimum: 2
       maximum: 5
     - Defines how many times the system decodes URI and parameter values before the request is considered an evasion.
       Relevant only for the 'Multiple decoding' sub-violation.
     - 
```

---


```eval_rst
.. _policy/blocking-settings_http-protocols:
```


### http-protocols



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``description``

     - string
     - Human-readable name of sub-violation
     - * POST request with Content-Length: 0
       * Multiple host headers
       * Host header contains IP address
       * Null in request
       * Header name with no header value
       * Chunked request with Content-Length header
       * Check maximum number of cookies
       * Check maximum number of parameters
       * Check maximum number of headers
       * Body in GET or HEAD requests
       * Bad multipart/form-data request parsing
       * Bad multipart parameters parsing
       * Unescaped space in URL
       * High ASCII characters in headers
   * - ``enabled``

     - boolean
     - Defines if sub-violation is enforced - alarmed or blocked, according to the 'HTTP protocol compliance failed' (VIOL_HTTP_PROTOCOL) violation blocking settings
     - 
   * - ``learn``

     - boolean
     - Defines if sub-violation is learned. Sub-violations is learned only when learn is enabled for the 'HTTP protocol compliance failed' (VIOL_HTTP_PROTOCOL) violation
     - 
   * - ``maxCookies``

     - integer
       minimum: 1
       maximum: 100
     - 
     - 
   * - ``maxHeaders``

     - integer
       minimum: 1
       maximum: 150
     - Defines maximum allowed number of headers in request.
       Relevant only for the 'Check maximum number of headers' sub-violation
     - 
   * - ``maxParams``

     - integer
       minimum: 1
       maximum: 5000
     - Defines maximum allowed number of parameters in request.
       Relevant only for the 'Check maximum number of parameters' sub-violation
     - 
```

---


```eval_rst
.. _policy/blocking-settings_violations:
```


### violations



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``alarm``

     - boolean
     - 
     - 
   * - ``block``

     - boolean
     - 
     - 
   * - ``description``

     - string
     - 
     - 
   * - ``learn``

     - boolean
     - 
     - 
   * - ``name``

     - string
     - 
     - * VIOL_ACCESS_UNAUTHORIZED
       * VIOL_ACCESS_INVALID
       * VIOL_ACCESS_MALFORMED
       * VIOL_ACCESS_MISSING
       * VIOL_ASM_COOKIE_MODIFIED
       * VIOL_BLACKLISTED_IP
       * VIOL_BOT_CLIENT
       * VIOL_BRUTE_FORCE
       * VIOL_COOKIE_EXPIRED
       * VIOL_COOKIE_LENGTH
       * VIOL_COOKIE_MALFORMED
       * VIOL_COOKIE_MODIFIED
       * VIOL_CSRF
       * VIOL_DATA_GUARD
       * VIOL_ENCODING
       * VIOL_EVASION
       * VIOL_FILETYPE
       * VIOL_FILE_UPLOAD
       * VIOL_FILE_UPLOAD_IN_BODY
       * VIOL_GRAPHQL_MALFORMED
       * VIOL_GRAPHQL_FORMAT
       * VIOL_GRAPHQL_INTROSPECTION_QUERY
       * VIOL_GRAPHQL_ERROR_RESPONSE
       * VIOL_GRPC_FORMAT
       * VIOL_GRPC_MALFORMED
       * VIOL_GRPC_METHOD
       * VIOL_HEADER_LENGTH
       * VIOL_HEADER_METACHAR
       * VIOL_HEADER_REPEATED
       * VIOL_HTTP_PROTOCOL
       * VIOL_HTTP_RESPONSE_STATUS
       * VIOL_JSON_FORMAT
       * VIOL_JSON_MALFORMED
       * VIOL_JSON_SCHEMA
       * VIOL_LOGIN
       * VIOL_LOGIN_URL_BYPASSED
       * VIOL_LOGIN_URL_EXPIRED
       * VIOL_MANDATORY_HEADER
       * VIOL_MANDATORY_PARAMETER
       * VIOL_MANDATORY_REQUEST_BODY
       * VIOL_METHOD
       * VIOL_PARAMETER
       * VIOL_PARAMETER_ARRAY_VALUE
       * VIOL_PARAMETER_DATA_TYPE
       * VIOL_PARAMETER_EMPTY_VALUE
       * VIOL_PARAMETER_LOCATION
       * VIOL_PARAMETER_MULTIPART_NULL_VALUE
       * VIOL_PARAMETER_NAME_METACHAR
       * VIOL_PARAMETER_NUMERIC_VALUE
       * VIOL_PARAMETER_REPEATED
       * VIOL_PARAMETER_STATIC_VALUE
       * VIOL_PARAMETER_VALUE_BASE64
       * VIOL_PARAMETER_VALUE_LENGTH
       * VIOL_PARAMETER_VALUE_METACHAR
       * VIOL_PARAMETER_VALUE_REGEXP
       * VIOL_POST_DATA_LENGTH
       * VIOL_QUERY_STRING_LENGTH
       * VIOL_RATING_THREAT
       * VIOL_RATING_NEED_EXAMINATION
       * VIOL_REQUEST_MAX_LENGTH
       * VIOL_REQUEST_LENGTH
       * VIOL_THREAT_CAMPAIGN
       * VIOL_URL
       * VIOL_URL_CONTENT_TYPE
       * VIOL_URL_LENGTH
       * VIOL_URL_METACHAR
       * VIOL_XML_FORMAT
       * VIOL_XML_MALFORMED
       * VIOL_GEOLOCATION
       * VIOL_WEBSOCKET_BAD_REQUEST
       * VIOL_MALICIOUS_IP
```

---


```eval_rst
.. _policy/bot-defense_mitigations:
```


### mitigations



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - `anomalies <policy/bot-defense/mitigations_anomalies_>`_

     - array of objects
     - 
     - 
   * - `browsers <policy/bot-defense/mitigations_browsers_>`_

     - array of objects
     - 
     - 
   * - `classes <policy/bot-defense/mitigations_classes_>`_

     - array of objects
     - List of classes and their actions.
     - 
   * - `signatures <policy/bot-defense/mitigations_signatures_>`_

     - array of objects
     - List of signatures and their actions.
       If a signature is not in the list - its action will be taken according to the class it belongs to.
     - 
```

---


```eval_rst
.. _policy/bot-defense_settings:
```


### settings



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``caseSensitiveHttpHeaders``

     - boolean
     - If *false* the system will not check header name with case sensitivity for both relevant anomalies: Invalid HTTP Headers, Suspicious HTTP Headers.
     - 
   * - ``isEnabled``

     - boolean
     - If *true* the system detects bots.
     - 
```

---


```eval_rst
.. _policy/bot-defense/mitigations_anomalies:
```


### anomalies



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``action``

     - string
     - 
     - * alarm
       * block
       * default
       * detect
       * ignore
   * - ``name``

     - string
     - 
     - 
   * - ``scoreThreshold``

     - 
       * integer
         minimum: 0
         maximum: 150
       * string
     - 
     - * Integer values
       * "default"
```

---


```eval_rst
.. _policy/bot-defense/mitigations_browsers:
```


### browsers



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``action``

     - string
     - 
     - * alarm
       * block
       * detect
   * - ``maxVersion``

     - integer
       minimum: 0
       maximum: 2147483647
     - 
     - 
   * - ``minVersion``

     - integer
       minimum: 0
       maximum: 2147483647
     - 
     - 
   * - ``name``

     - string
     - 
     - 
```

---


```eval_rst
.. _policy/bot-defense/mitigations_classes:
```


### classes



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``action``

     - string
     - The action we set for this class.
       
         - **ignore**: The system will not detect or report bots from this class.
         - **detect**: The system will detect and report the bot, but violation won't be reported.
         - **alarm**: The system will detect and report requests made by bots from this class as illegal, but will not block them.
         - **block**: The system will detect and report requests made by bots from this class as illegal, and block them.
     - * alarm
       * block
       * detect
       * ignore
   * - ``name``

     - string
     - The class we set the action to.
     - * browser
       * malicious-bot
       * suspicious-browser
       * trusted-bot
       * unknown
       * untrusted-bot
```

---


```eval_rst
.. _policy/bot-defense/mitigations_signatures:
```


### signatures



```eval_rst
.. list-table::
   :header-rows: 1
   :widths: 5 1 8 3

   * - Field Name
     - Type
     - Description
     - Allowed Values
   * - ``action``

     - string
     - The action we set for this signature.
       
         - **ignore**: The system will not detect or report this signature.
         - **detect**: The system will detect and report the signature, but violation won't be reported.
         - **alarm**: The system will detect and report requests made by those specific bots as illegal, but will not block them.
         - **block**: The system will detect and report requests made by those specific bots as illegal, and will block them.
     - * alarm
       * block
       * detect
       * ignore
   * - ``name``

     - string
     - The name of the signature we want to change action for.
     - 
```