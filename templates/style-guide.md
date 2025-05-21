
# F5 NGINX Documentation style guide

See the [revision history](#revision-history) for the current version.

## Introduction

Welcome to our project! This style guide is intended for use by project contributors, not necessarily end-users. It provides general guidance to anyone who contributes to the project's documentation.

## Intended audience and scope

This style guide is intended for use by any contributors that are writing documentation for F5 NGINX products, including software engineers. This guide can help project contributors to communicate clearly and consistently in the project's end-user documentation, API documentation, configuration files, and in-product user messages.

## Our preferred style guide

This document provides guidelines specific to documenting F5 NGINX products and open-source projects.

- Follow American English spelling and conventions. For spelling reference, use the [American Heritage Dictionary](https://ahdictionary.com/).
- When the NGINX style guide does not cover a style, refer next to the [Microsoft Style Guide](https://learn.microsoft.com/en-us/style-guide/welcome/) for user-facing content, and then to the [Chicago Manual of Style](https://www.chicagomanualofstyle.org/home.html).

When writing documentation for our project, align with the default guide's voice and tone.


## F5 brand trademarks and product names

- On the first mention of an enterprise NGINX product in a document, use the full product name. For example:

  - F5 NGINX Plus
  - F5 NGINX App Protect WAF
  - F5 NGINX Instance Manager

- Don't add "F5" to open source products. For example:

  - NGINX Unit
  - NGINX Agent

- For subsequent mentions of any enterprise product, you can drop the "F5". You must include the "NGINX" brand name in all uses. For example:

  - NGINX Plus
  - NGINX App Protect WAF
  - NGINX Instance Manager

- When naming multiple products in one document, you only need to include F5 once, on the first mentioned product.
- Never use acronyms instead of the full product names.
- We don't need to use trademark and rights reserved icons (™,®) in product documentation.
- Use the full product name, including "F5" on product landing pages.
- Don't include the "F5" in document titles. For example:

  - Using NGINX Plus Docker images with NGINX Instance Manager

- Don't use articles ("the", "a") in front of product names. For example, use
  - NGINX Agent (not "the NGINX Agent").
- Always use the full brand name in the meta description. The meta description does not count as first mention of the product in the document.


## Glossary of preferred terms

The table provides guidelines about the terms you should and should not use for consistency, listed in alphabetical order:

| Term | Notes | Explanation |
|------|-------|-------------|
| a.m./p.m. | 10 am. | |
| abbreviations: acronyms and initialisms, capitalization | Acronyms and initialisms are abbreviations that are written out in capitalized letters, but unless the word or phrase they represent is a proper noun, the words do not need to be capitalized. For example single sign-on (SSO). Note: acronyms are pronounced as words (such as LAN) but initialisms are pronounced as letters (such as SSO). | |
| abort | Never use this term in your docs. Use the preferred terms when writing about a process:<br>stop<br>interrupt<br>shut down | Abort is acceptable to use in programmer or similar technical documentation only if it is a function name, parameter name, or otherwise part of a name in the API. |
| above and below | Avoid. Refer to the specific section, table, figure, an so on, as opposed to indicating its relative position in the document. | |
| access | Used as a verb, it's jargon, so don't use it.| |
| allows | Not recommended. \<br>Avoid phrases such as "NGINX Plus allows you to…". \<br><br>Use direct, active verbs from the perspective of the user instead. | |
| and/or | Not recommended. Usually, this means either "and" or "or". Try to be specific in your writing; people are counting on you for clear instructions. | |
| anthropomorphism | Avoid referring to the product or feature as though it were alive. \<br>When referring to products, stay away from words like: decides, knows, sees, listens, and hears.<br>A wizard guides you, it doesn't walk you through the steps. | |
| application | When referring to applications in general, write out the entire word. For clarity, avoid abbreviating to "app" unless specifically referencing the user interface or product. | |
| as/because | Use "because" instead of "as" when showing a cause-and-effect relationship. | |
| attack signature, attack signature set | Refers to elements of the NGINX App Protect WAF package. Do not abbreviate or otherwise shorten. | |
| backwards | Use backward and forward, not backwards and forwards | |
| black list<br> blacklist<br> blacklisted | Do not use these terms.<br>Use these terms instead:<br>-black list (noun) = deny list (noun)<br>-blacklist (verb) = denylist (verb)<br>-blacklisted (adjective) = denylisted (adjective) | |
| boot, boot up, reboot | Use "start" and "restart" if possible.<br>For "boot", use in the context of "boot to a new volume". If the meaning is actually "start", then use "start". Do not use "boot up".<br>Instead of "reboot", use "restart". \<br>When referring to applying configuration changes, use "reload". | |
| case insensitive | Use "not case-sensitive" instead of "case insensitive". | |
| caution/warning | Caution is less severe than Warning. Use Caution when alerting that damage may occur, such as down time or service interruption. Use Warning as the severest form of advisory, such as the risk of data loss or sustained outage.| |
| certificate authority (CA) | | |
| certificate request | | |
| certificate signing request (CSR) | | |
| certificate/key pair | | |
| check (verb) | Do not use when referring to a checkbox action. Use select. Options for check as a verb: verify, confirm, test, ensure, and so on. | |
| checkbox (noun, GUI) | Use "select" when referring to a checkbox action.<br>In this example, you could document as either: "For the Protocol Security (DNS) setting, select the Enabled checkbox." – OR – "For the Application Security setting, select Enabled." | |
| checksum | | |
| click vs select | Use "select". | Refer to the [Microsoft Style Guide instructions for Describing Interactions with UI](https://learn.microsoft.com/en-us/style-guide/procedures-instructions/describing-interactions-with-ui) for more information. |
| client certificate authentication | | |
| Client SSL | | |
| client-side or client side | Hyphenate when used as adjective. | |
| colloquial language | Try to avoid using colloquial language, which does not translate well. For example, use "press Esc", not "hit Esc"; "Go to the next section", not "jump to the next section". | |
| colon | Never use a colon to introduce a graphic, a figure, or a table. | |
| comma (serial or Oxford) | **Always use the serial (Oxford) comma.**<br><br>Example: "apples, oranges, and bananas"; not "apples, oranges and bananas".| |
| comma-separated | Always hyphenate. For example: a comma-separated values (CSV) file | |
| command line and command prompt (usage) | Use "command line".<br><br>NOUN: …at the command line.<br>ADJ: …using command-line tools.<br>At the command prompt, type...<br>Do not use command-line prompt.| |
| configure | Do not use, except when describing the configuration of an NGINX product, such as when installing NGINX or NGINX Agent.<br>In most cases, use "set up" instead.| |
| contractions | Contractions are okay to use as long as they're not ambiguous. | |
| control plane | Write as two words. Definition: The part of a network architecture that manages routing, signaling, and policy enforcement. | |
| Cookie persistence (option type) | | |
| cookie/cookies (noun) | | |
| covers | As in, "this section/topic/chapter covers the following...". Instead, use a phrase such as, "This topic deals with..." or "This topic provides the following information...". More options: communicates, presents, offers, introduces, explains, describes. | |
| curly brackets `{}` | The name for the curved `{}` parenthetical markings is "braces". They are not called curly brackets. | |
| CVSS v3.0 | Do not spell out. (Articles with CVSS metrics should include the CVSS link.) | |
| daemon | Avoid using this term in generic documentation because it is UNIX-oriented. Instead, we use "agent", "utility", or "application". However, we do refer to specific UNIX daemons, like `named` and `sod`, when daemon is part of the name. | |
| data center | Write this as two words. | |
| domain name | example.com, example.net, example.org, or localhost per [RFC 2606](https://www.rfc-editor.org/rfc/rfc2606.html). | |
| em dash | Allowed in the proper context. May be written using two dashes to ensure it converts correctly when displayed in the web version. | |
| data plane | Write as two words. Definition: The part of a network architecture responsible for forwarding packets based on established rules. | |
| data source | | |
| database | Do not abbreviate as "db". Always a single word. | |
|date format | Use _month day, year_ format, as in December 4, 2024. Don't use _day month year_, as in 31 July 2016. <br>  In the UI, it's OK to use numbers and slashes for dates if the code supports that format and automatically displays the appropriate date format for different locales. For example, 12/4/2024. | This format aligns with standard American usage for consistency and clarity. |
| disconnected | Use this term to describe environments without internet or external network access, such as air-gapped, offline, or network-restricted setups. Preferred term due to alignment with product UI and configuration settings (for example, `mode_of_operation: disconnected`). If needed, clarify as "in a disconnected (network-restricted) environment" for context. | |
| DoS/DDoS/3DoS | Spell out on first reference:<br>- denial-of-service (DoS)<br>- distributed denial-of-service (DDoS)<br>- diverse distributed denial-of-service (3DoS) | |
| e.g., i.e., etc. | Avoid using Latin abbreviations.<br>- e.g. = for example<br>- i.e. = in other words<br>- etc. = and so on | |
| earlier and later | Use to describe versioning. For example, "This applies to versions earlier than NGINX Plus R31".<br>Do not use before, after, greater, lower, higher, below, above, and so on. | |
| either/or | Not recommended.<br>Usually, we mean either, or we mean or. Try to be specific in your writing; people are counting on you for specific instructions. It's okay to use these terms when separated by text, as in, "You can use either the semi-colon or the comma here".| |
| ellipses […] | Don't use ellipses (dots) in your tech writing.<br>When referring to a menu command that has an ellipse, DO NOT include the ellipse.<br>It's okay to use the word "ellipses" in text. | |
| enable | Always use direct, active verbs.<br>It's okay to instruct the user to enable a setting. Do not use in the context of a system or product enabling the user to do something.| |
| end a connection vs. tear down a connection (telephony) | In legacy telephony content, tear down was a clear way to describe how multiple connections were taken down (such as, for a trunk). Although that action is now completed in a streamlined and advanced manner (behind the scenes), end the connection may not be an accurate substitute phrase for this action, and suggest ending only one connection. | |
| Enter (key) | Do not use ALL CAPS when referring to the Enter key; use Initial capitalization. For example, Press Enter. | |
| enter (verb) | Follow MSG and use enter for data inserted into a box (field) or for a string that is likely to be blocked and copied. Use type for typing a command-line command. | |
| etc., i.e., e.g., etc., et cetera | Avoid Latin abbreviations. Be specific where possible. If the etc. represents additional information that the user needs to know, then include it. Otherwise, use and so on instead. You can recast to elaborate, or use that is if appropriate instead of i.e.; also use for example or for instance or such as instead of e.g., where applicable. | |
| EULA | End User License Agreement (EULA). A hard copy of the EULA ships with F5 products. | |
| example element (tagging) | Use the \<example> element when presenting a technical example of something (such as hardware/software and configuration details). If the information is not a specific technical example, or is further clarification of the subject, then a regular content paragraph is sufficient. | |
| executables | Refers to system files. Use system files instead. | |
| execute | Put to death. Don't use it. Use another word instead; for UNIX, we prefer run. Or start Alternatives: § Use the \<command> command to… § Enter the \<command> command at the prompt… § Start the \<command> utility… § Run the \<command> script… EXCEPTION: Security Advisory Articles and vulnerabilities in release notes. | |
| expand vs. flyout | Do not use flyout. Write text to describe action for the user. Expand is OK. | |
| expire | In GLOBAL-SITE and EDGE-FX documents, the term expire was used to take an object. It means to have the cache remove old content. We shouldn't have any need to use it this way anymore, thank goodness, as these products are gone. | |
| extraneous | Don't use it. Use extra or unneeded instead. | |
| F5 Networks (trademark practice) | Replace with "F5, Inc.". Visit the [trademarks page](https://www.f5.com/company/policies/trademarks) on f5.com for the latest guidance. | |
| F5 web resource URLs (reference) | Include the full URL when possible instead of masking the destination URL. Be sure to include the trademark in the URL name (unregistered trademark ™, or registered trademark ®, or service mark SM) at first mention where appropriate. <br>For example: "In a browser, open the F5 Downloads page (https://downloads.f5.com)" or "the F5 DevCentral web site (https://devcentral.f5.com/)". | |
| F5 persona names | Do not refer to internal personae in public-facing documentation. | |
| F5 recommends vs. We recommend | Do not use We recommend or it is recommended when referring to an F5 recommended guideline. If needed, use F5 recommends or, at present, writers are encouraged to state the specific action that the user should take when possible. | |
| F5 Support | Use instead of F5 Technical Support or other variations thereof. | |
| F5 Technical Support | Do not use. Use F5 Support. | |
| F5 XC Tech Docs | Use when linking to documents on the https://docs.cloud.f5.com/docs/ site. | |
| fetch | This can be a technical term; depending on context, it may relate to getting, reading, or moving data objects. | |
| fictitious names (domains/companies) | When documenting example scenarios, unless it is a case study, and/or we have approval from the company to use their company name, we should use a generic fictitious approved name (such as ABC corporation or Company A or Company B). For domains, see [RFC 2606](https://www.rfc-editor.org/rfc/rfc2606.html) for reserved top-level DNS names to use in documentation. RE the GUI: Consult the legal team if your product team uses trademarked names (owned by others) in the GUI. | |
| figure captions (graphics) | Ensure that text describing the graphic is precise, short, and describes the action or process shown in graphic; do not include illustration in the caption. AVOID: “Figure 2 Illustration of NGINX Instance Manager using XXX. Avoid using trademarks in diagrams; instead, ensure that the product name is called out in the topic body text and add the trademark as needed at first mention. | |
| figures/images (TBA) | For a figure (screenshot or graphic): Use the \<fig> content unit when you want to display a screenshot or a graphic on your topic. Within the \<fig> content unit, use the \<image> element to contain the actual graphic, and use the \<title> element to provide a caption. For an image, such as an icon or button: Use the \<image> element to include artwork or images in a topic. In most cases, the \<fig> and \<title> elements are used. | |
| file name | File name is presented as two words, unless for commands/syntax or when matching the GUI, (representing variables) such as \<filename>. | |
| FIPS | Correct: FIPS hardware security module (HSM), FIPS HSM. | |
| flyout | Do not use. When describing the user interface, state that the "panel expands". | |
| foo bar, foo, fu, fubar | Do not use; always replace with specific text. Watch for these in code samples. | |
| forward slash | We don't call it a forward slash, just a slash. § In text, use as needed to match the UI, with no space on either side. Type the host name/IP address… § In syntax, the slash is used for web addresses: https://webmail.f5.com/exchange/ | |
| Forwarding (IP) | See virtual server types. | |
| Forwarding (Layer 2) | See virtual server types. | |
| forwards | Use backward and forward, not backwards and forwards. | |
| FTP | Do not spell out. | |
| fu, fubar | Do not use; always replace with specific text. Watch for these in code samples. | |
| future releases and TBD | Do not use TBD in any content, including release notes. Do not reference future releases, such as This OID will be disabled in future releases. | |
| G | Abbreviation for "giga", but in computer terminology represents 230, or 1,073,741,824. Correct: 4G | |
| Gateway ICMP | Also see ICMP | |
| GbE and GigE | For a number plus GbE, such as 10GbE, the standard is no space. For a number plus GigE, such as 10 GigE, the standard includes a space. | |
| gear icon | In a product's user interface, a gear icon may open an object's properties or the system settings. Refer to the object by its purpose, not the icon, unless in a task step. For example "Select the gear icon to open the system settings menu." or "Open the System Settings menu." | |
| geolocation vendor name (database) | Refer to geolocation vendor name as Digital Element versus parent company Digital Envoy. | |
| gerunds | Do not use gerund forms in article titles or headings. Correct: Provision your system. Incorrect: Provisioning your system. | |
| grayed out | Don't use it. Use unavailable. | |
| group box | Do not refer to UI element names if possible. Instead, use the label name. If necessary for clarity, use box. | |
| GSLB | This is the abbreviation for global server load balancing (GSLB). It is a subset of DNS. | |
| GUI | Do not use. Acronym for Graphical User Interface. Use "user interface" instead. | |
| hang | As in the system hangs or This hangs the system. OK in internal department stuff; but it's slang, and we should do better in our docs. For a write-around, try fail to respond, as in: If the program fails to respond, restart the system. Other possible terms to use, depending on the circumstances, could be: § causes the system to jam/get stuck/stop processing. § If horrid: halt, stop or crash; or cause an error. | |
| hardware upgrade | Hardware upgrade is to install a system in place with a newer platform. For example: Check the version compatibility list before upgrading your software to make sure you do not need to perform a hardware upgrade as well. | |
| has | One of those weak, vague verbs we're supposed to avoid as much as possible: Allow, do, enable, let, perform, be, has, make, and do. Use direct, active verbs instead. | |
| Headings | Use imperative verbs (formerly, MyF5 used gerunds)<br><br>Heading text must **not** link to other pages. | |
| hears | When referring to products, avoid it, it's anthropomorphism. When referring to products, stay away from words like decides, knows, sees, listens, and hears. | |
| help (capitalization style) | When referring to online help in our documentation, use lowercase format for instances of help as per legacy guidelines (unless specifically referring to the Help button). However, identify it as F5 online help in order to distinguish it from general instances of help as a verb and noun. | |
| host name | Two words, except when a parameter. | |
| hover (user interface) | Use "hover over" not "hover on" nor "hover in" when describing this action. | |
| HTTP status codes | First mention: HTTP 200 status code (OK). Subsequent mention: HTTP 200 status code. HTTP status codes are grouped into five classes: 1xx (Informational): The request was received, continuing process 2xx (Success): The was successfully received, understood, and accepted 3xx (Redirection): Further action needs to be taken to complete the request 4xx (Client Error): The request contains bad syntax or cannot be fulfilled 5xx (Server Error): The server failed to fulfill an apparently valid request The following list is not exhaustive, but includes some common HTTP status codes: 100 Continue 101 Switching Protocols 200 OK 300 Multiple Choices 301 Moved Permanently 302 Found 304 Not Modified 307 Temporary Redirect 400 Bad Request 401 Not Authorized 403 Forbidden 404 Not Found 500 Internal Server Error 502 Bad Gateway 503 Service Unavailable 504 Gateway Timeout | |
| HTTPS | All caps unless appearing in URL, where it should be lowercase. A a daemon: https | |
| hyphens | You can use hyphens for compound words, to join prefixes to other words, or to show word breaks. Practice best judgment when employing them. In some instances, a hyphen may seem unnecessary as the compound word may be clear enough to the user and frequently presented without a hyphen, such as antivirus. In other cases, a term may look odd without it, so you may choose to include it for readability, such as pre-entrancy vs. preentrancy. Do not use hyphens to introduce list items in TBA content. | |
| i.e. | Latin abbreviation for "that is" or "in other words". Don't use it. | |
| id | When you mean ID, in text, never use user id nor user Id. If you're matching a UI that says one of these, talk to the Dev team about changing it to ID. | |
| ID | When you mean identify, in text, never use ID, spell out the word. | |
| if vs. whether | In informal writing and speech, often used interchangeably but can have different meanings, so try to use the correct word. Use if when expressing a condition of uncertainty: You don't know If NGINX Management Suite includes Instance Manager. Use whether when you are showing that two (or more) alternatives are possible: Whether your NGINX Management Suite deployment includes Instance Manager and API Connectivity Manager. | |
| in order to | Most often just use to instead, especially in procedures. | |
| information about vs. information on | Reserve the on preposition for location, such as The label on the back of the device... Use For information about NGINX Mangement Suite, refer to…. | |
| initiate | Use start instead. Press Enter to start the domino-fall routine. | |
| input | Not as a verb. Use type instead. | |
| insecure | Avoid using when describing a lack of security for something technical or technology-related, such as system versions, fraud issues, and so on. Across F5, we are trying to consistently use unsecure or not secure(though non-secure may appear as well) instead, for accuracy. | |
| interface and port (usage) | If referring to a physical port on F5 hardware, use interface (examples of interface names are 1.1, 1.2, and 2.1). In this case, port is just industry slang to mean a physical hardware interface. An actual port is a number that corresponds to a software service (daemon) running on a server, such as port 80, which corresponds to the HTTP service (and underneath it all, the httpd daemon). | |
| Internet, intranet, and extranet | Use internet to refer to the worldwide collection of networks that use open protocols such as TCP/IP to communicate with one another. Don't capitalize. Use intranet to refer to a communications network based on web technology, but that's available only to certain people, such as the employees of a company. Don't capitalize. Use extranet to refer to an extension of an intranet that uses internet protocols to give authorized outside users limited access to the intranet. Don't capitalize. | |
| interoperate | Do not use. Recast to operate or clarify connecting relationships as needed. | |
| IP address and MAC address | Specify whether referring to IP address or MAC address in content, rather than just address for clarity. IP and MAC are always capitalized. | |
| IP addresses (general usage) | Internal IP addresses that include beginning ranges, such as 172.25, 172.26, 172.27, 172.28, 172.29, 172.30, 172.31, and 172.32 should not appear in external documentation. | |
| IP addresses in examples | Be careful not to use example IP addresses that belong to another company. Refer to [RFC5737 for IPv4](https://www.ietf.org/rfc/rfc5737.txt) and [RFC3849 for IPv6](https://www.ietf.org/rfc/rfc3849.txt) for a list of IP addresses that are approved for use in documentation and examples. | |
| IPsec | Internet Protocol Security (IPsec), two caps. Note internal capitalization style of acronym. Do not use IPSec (three caps). | |
| IPv4-in-IPv6 vs. IPv4 in IPv6 | You can hyphenate IPv4-in-IPv6 when used as an adjective, such as IPv4-in-IPv6 tunnels. Note that the internal v in IPv4 and IPv6 should remain in lowercase format. | |
| ISO 9001:2015 certification | For example: ISO 9001:2015 certified" or ISO 9001:2015 certification Don't use: ISO certified or ISO certification (Per: ISO - Certification, for questions about the use of ISO Certificate terms and logo, please contact the GS quality team at *qmt) | |
| it | Avoid ambiguous pronouns. Be explicit: "Check the status of the server. Restart ~~it~~ the server" | |
| jargon | Jargon is the technical terminology or characteristic idiom of a special activity or group. Try hard to avoid it. Think about explaining something to a member of your family or a friend who doesn't know what you know. F5 products are highly technical, but strive to be as plainspoken as possible when describing or instructing. Spell out abbreviations on first use, use the clearest and easiest word to understand that will still accomplish the job, and so on. | |
| JWT license file | Include the word "license" when referring to the JSON Web Token that users download as part of their F5 NGINX subscription. | |
| kill | Avoid this term except in command line syntax, where it is a UNIX command for stopping processes. (It's actually an IEEE POSIX standard command.) Alternatives for describing the action are: § End the process § Interrupt the process § Quit the process § Shut down the process § Stop the process | |
| known issue | Abbreviate as "KI" when using in public-facing documentation. | |
| knows | When referring to products, avoid it; it's anthropomorphism. When referring to products, stay away from words like decides, knows, sees, listens, and hears. Do not use possessive case for inanimate objects. | |
| Latin | Don't use it [via, vice versa, id est, i.e., e.g., etc. ] EXCEPTION: Security Advisory Articles and vulnerabilities in release notes. | |
| launch | As in launch a program. This is jargon. Use start instead. | |
| layer 4 (L4) | Lowercase spelled out, capitalized in abbreviation. Use same reference for all layer numbers: layer 2, 3, 7, etc. layer 4-7 (L4-7) (no spaces) | |
| left-hand | See Page directions. | |
| let | One of those weak, vague verbs we're supposed to avoid as much as possible: Allow, do, enable, let, perform; enter [usually implies type and press Enter], be, has, make, and do. Use direct, active verbs instead. | |
| lets, allows | Avoid. These verbs are system-focused and not user-focused. They may be appropriate to employ in a description about the feature, but not when describing what a user can accomplish by using the feature. | |
| list box | When possible, don't use the UI item name. Use the label name instead. If necessary for clarity, use list. | |
| listens | When referring to products, avoid it, it's anthropomorphism. However, it is acceptable only in conjunction with UNIX daemons, which listenon the port specified by a user. When referring to products, stay away from words like decides, knows, sees, listens, and hears. | |
| load balance, load balancing, load balancer | Write as two words. No hyphen, even as an adjective. Definition : A system that distributes network or application traffic across multiple servers to optimize resource use and reliability. | |
| local domain name system server vs. | Do not use; use local domain name system server or variations as applicable, such as local DNS server or LDNS server and so on. | |
| Log error message types (format) | The message type should be formatted in lowercase, such as: log_error. | |
| Log in syntax for products | *Login* is an adjective or noun. Log in is a verb. *Log in* to (F5 product) or verify your login credentials.  | |
| login vs. logon | Use log in and log in to. There are still legacy instances of log on and logon and GUI references to logon. Do not use log into (or onto) when referring to the login process; use two words: Log in to the system… Login is an adjective or noun. Log in is a verb. | |
| lower left hand | See Page directions. | |
| lower right hand | See Page directions. | |
| make | One of those weak, vague verbs we're supposed to avoid as much as possible: Allow, do, enable, let, perform, enter [usually implies type and press Enter], be, has, make and do. Use direct, active verbs instead. | |
| man pages, MAN number | Man pages (short for manual pages) are OK to mention in content if appropriate. MAN numbers refer to the manual publication numbers that appear in the front matter of our documentation (such as MAN-0123-04). | |
| management interface | Synonymous for management port. | |
| management plane | Use *control plane*. | |
| management port | Synonymous for management interface. | |
| manually vs. “from scratch” | Use manually or specify when describing how to create a process from the beginning or at the start. Avoid from scratch to ensure clarity and prevent future localization issues. | |
| master | Do not use this term in documentation unless you are referring to/quoting specific command line syntax or process. For example: "The nginx master process...". Some possible alternatives, depending on your use case: primary, prime, principal, control, or, possibly, server. For more information, refer to K34150231: Exclusionary language in F5 products and documentation. | |
| master/slave | Do not use these terms if possible. Revise to primary/secondary. | |
| may/may not | Implies permission or uncertainty. Generally, use can indicate ability. | |
| menu | In general, try to avoid discussing the UI. Use the label of the UI item instead unless there is a possibility for confusion. Do not use menu as a generic term. Most often the UI item is a list, not a menu. Never use "drop-down menu". | |
| mouse | Don't use the word mouse when you mean cursor. | |
| mouse over | We don't use mouseover, or mouse over, or mouse-over in our writing. If you need this concept, try a write-around: "when you move the cursor over..." or "hover over the system performance graph...". | |
| Move button and \<< >> symbols (GUI) | When referring to GUI settings, you can document the button as the Move button and follow with the icon symbols \<< or >> as appropriate, or opt to not include the button by name if appropriate. | |
| multifactor authentication (MFA) | multifactor is one word | |
| mutually exclusive | Be careful how you use this. PREFERRED: This option mutually excludes the from-group and to-group options. TECHCOMM STYLE: The from-group and to-group options are mutually exclusive. | |
| My Support | two words, title caps | |
| MyF5 | Do not use MyF5 Knowledge Base (MyF5) or MyF5 portal. | |
| name server vs. nameserver | nameserver | |
| Navigate to | Replaces with "Go to". | |
| net | Don't use the word net to mean network. | |
| network | Don't use network as a verb. | |
| network mask | In our documentation, a network mask is also known as: a netmask,subnet mask, and mask. Use network mask when possible. | |
| Note style type | Use only these Note style types: Note, Important, Tip, and Warning. Caution and Attention note style types are not used unless in hardware documentation. We do not use Notice. | |
| numbers and numerals | Spell out the number 0-9, for example, three computers one file; numbers are OK to use in numeric elements (<0); ordinal numbers use words, such as first, second, third. Our hardware documentation may present some exceptions to this guideline. | |
| numeric ranges | Use a hyphen (or En dash if available) as opposed to writing to when possible to indicate a range between numbers. Use a hyphen as opposed to writing to when possible to indicate a range between numbers. Also use “between” when possible, and not from when referring the numeric range. MyF5 uses through instead of a hyphen in paragraph text (non-procedural writing or writing outside of titles, tables, headers, etc.) when indicating version ranges. NGINX Instance Manager 2.1 through 2.5. | |
| on-screen | Do not use screen or variations thereof when referring to the user interface. Use "page" instead. | |
| once | For localization purposes, use only in the noun form (to mean one single time). Use when or after as appropriate. Not our style: Once you have completed this task, the configuration is complete. | |
| operating system vs. operation system | Watch out! We run an operating system (OS) and perform an operation; do not use operation system for OS. | |
| output | Is a great word as a noun or adjective, but a failure as a verb. Use write to, display on, print on, or print to instead. | |
| page | Use instead of screen. | |
| page directions | Use only when necessary (when a UI item is hard to find). Consider that, due to Responsive Web Design, the directions may not be applicable on all viewing devices. <br>Use: at the top of the page, at the bottom of the page, on the right side of the page, on the left side of the page.<br>Avoid: right-hand, left-hand, above, below, and other variations | |
| patch | Use when applying an engineering hotfix. For example: You can patch your system using hotfix files. | |
| path | Try to avoid using it when referring to a directory structure. You may use path when you are referring to a DNS path. In DNS, path and directory structure are different things. Use path. | |
| path name | Don't use it. Use path instead (see path). Don't use path name, but you can use file name. | |
| percent (%) | Do not spell out percent. | |
| perform | One of those weak, vague verbs we're supposed to avoid as much as possible: Allow, do, enable, let, perform; enter [usually implies type and press Enter], be, has, make and do. Use direct, active verbs instead: complete, follow the steps, finish… | |
| persist | When used as a transitive verb, as in use this command to persist connections to the server. Use the adjective form, persistent, whenever possible. So instead of saying to ensure the connections persist, say "To ensure persistent connections...." | |
| please, thank you | Don't use please except where the user is asked to do something inconvenient or where the software is to blame for a situation. Use thank you only when user has provided info that is difficult or inconvenient to collect. | |
| plug-in, plugin | Both variations (with and without hyphen) are acceptable as long as maintaining internal consistency throughout topic(s) and/or sections, and clear to audience. | |
| pointer | On the off chance that we'll ever talk about a cursor, don't use the word pointer when you mean cursor. | |
| policing | Recast in terms of policies or policy enforcement for clarity, if appropriate. | |
| policy | Always qualify this with an appropriate modifier when referring to a policy, such as enforcement policy or access policy, and so on. | |
| Policy Builder | Do not use the Policy Builder or Policy Builder feature or any other permutations thereof. | |
| policy item | Policy items are the objects used to build policies in the Visual Policy Editor. Policy item names are title case, non-bold. For example, the SSO Resource Assign policy item. | |
| policy name (user instruction, tagging) | In a content example, such as: When creating enforcement policies that you plan to apply globally or to unknown subscribers, include the word global or unknown in the policy name to distinguish these from other subscriber policies. Do not use quotes for emphasis. | |
| popup screen, pop-up window | MyF5 uses pop-up window instead of dialog box. TechComm uses popup screen instead of dialog box. | |
| possessives | Don't do it with our trademarks. Do not use possessive case for inanimate objects. Do not use possessive constructions for product and company names, such as *NGINX's config file*. No possessive in trademarked words. For instance, you can't have the *NGINX's anything* but you can say the *NGINX instance's* something. | |
| power off | Do not use.* Use *shut down* for *turn off*. | |
| pre-logon | As a setting: Pre-Logon Sequence. | |
| prepositions | Areas--Settings are in an area of the page.<br>Box -- Users type in a box. <br>Charts -- Charts show on a page; info is found in charts. <br>Check box -- (use rarely) We place a check in a checkbox (more common, select the checkbox) <br>Diagram -- Info or objects are in a diagram or in a figure <br>Headers -- Users hover over a header. <br>Legend -- Users find info in the legend for a figure. <br>List -- Select (without preposition) an item in a list. Select an option from a list; data appears in a list. <br>Menu bar -- Select something on a menu bar. <br>Menus -- Commands are on menus. Menus -- Choose commands from menus. (Note: most UI elements are not menus but lists. See menu.) <br>Navigation pane -- Select an item in/on the navigation pane. <br>Network -- Printers may be on a network. <br>Pages -- Information and controls are on a page. <br>Panels -- Refer to objects in a panel. <br>Popup window –-(use infrequently) Information and controls are on a popup window. <br>Tabs -- The Visual Policy Editor may open in a new tab; information is found or selected on a tab. <br>Tables -- Controls are in, and info listed in, tables; but you select an item from a table. <br>Toolbar -- Select something from a toolbar, or tell the user to select something on the toolbar. | |
| private cloud | A cloud computing environment wholly dedicated to, and accessible only by a single group, or organization. Use instead of: bare metal on-prem. Also see public cloud. | |
| procedure vs. step | Avoid referring to a procedure as a step(s). We can refer to a procedure as a task if appropriate. | |
| pronouns | Second person (you, your) is preferred over third person (the user, the administrator) unless necessary to avoid confusion. Avoid we If possible, use F5 instead of we. Following MSG's Bias-free communications, use gender-neutral pronouns rather than he/she, his/hers, and him/her. If you can't write around using the pronoun, use their, theirs, they, or them for the gender-neutral singular and plural pronoun. | |
| public cloud | Cloud computing services delivered over infrastructure shared by multiple groups or organizations. | |
| QoS vs. QOS | Do not write as QOS regardless of the context; always document the abbreviation for Quality of Service as (QoS). | |
| queuing vs. queueing | Use queuing, not queueing. | |
| quotation marks | In our docs, we don't typically use quotation marks except when quoting a source, or when they are required for syntax. | |
| quotation marks (titles/headings) | Do not use quotation marks in topic titles or section headings; recast or omit if needed. Also, apply appropriate tags to identify what the text represents (such as a log or error message, and so on) rather than using quotes to add emphasis or convey something about the text origin. You can use smart (straight) quotes in release notes, for table cell content (such as CLI syntax and related text in Known issues, and so on). Do not use curly quotes in content. | |
| radio button | Don't use radio button. Refer to item by label. If necessary for clarity, use button or option. | |
| Reboot, reset | Do not use. Use restart. See boot, boot up, reboot. | |
| Referrer | (industry standard when referencing the referrer header.) | |
| regular expression | Not RegExp. | |
| Reject | See virtual server types. | |
| reject-all | Also refer to catch-all. | |
| replace | To install a system in place of one with the same platform, due to failure or similar condition. For example: If your hardware fails, you can replace it if you have a support contract by calling F5 Support. | |
| resource record | Not RR. | |
| Result (TBA and GUI) | For GUI content, you can omit a Result step if you feel the result of the GUI steps would be obvious and expected for the user. | |
| right-hand | See Page directions. | |
| Role-based Access Control (RBAC) | Note the hyphen and acronym style. | |
| root account | Use this version for general references; if referring to the UI, reflect how the UI refers to it. | |
| scale (up, down, in out) | See Autoscaling. | |
| screen | Do not use screen or variations thereof when referring to the product user interface. Use page instead. | |
| secure network address translation (SNAT) | SNAT is a noun. Do not use as a verb. You use SNAT to. You don't SNAT to. | |
| secure web gateway | Do not abbreviate generic references to the F5 offering. | |
| sees | When referring to products, avoid as anthropomorphism. When referring to products, stay away from words like decides, knows, sees, listens, and hears. | |
| select | Use instead of "click on" when referring to interaction with elements of a product user interface. | |
| server-side/server side | Hyphenate when used as an adjective. | |
| Session Initiation Protocol (SIP) | Correct: a SIP client (pronounced sip). | |
| shortcut menu | Don't use it. | |
| should | Should can be ambiguous. Avoid using it. Do not use should when you mean if. Don't say, Should you decide to … just say If you decide to… . | |
| single quotes | In our docs, we don't use single quotes to mean apostrophes [ 'like this' ]. We use them only when they are required for syntax. | |
| slash (“/” symbol) | When referencing the slash character (forward or backward) in content, specify the symbol by name (forward slash or back slash). You can also add the symbol if you feel that is helpful, though this is not required (/). Do not use oblique to mean slash. | |
| slave/master | Do not use these terms if possible. Revise to secondary/primary, respectively. For more information, refer to K34150231: Exclusionary language in F5 products and documentation. | |
| space | Do not use when referring to an input field or checkbox where the user needs to enter info. Recast to identify as a box. | |
| SPDY | Correct: a SPDY profile (pronounced speedy). | |
| spin up/spin down, spinning up/spinning down | Jargon, but becoming more widely used because of AWS. Do not use in our documentation without adding context on first reference. For example You can spin up (create additional virtual instances) or spin down (remove virtual instances) . . . . | |
| SSH | Do not spell out. | |
| SSL | Do not spell out. | |
| SSLi/SSL Intercept | For the SSL Intercept iRule. Spell out. Do not abbreviate except to match UI label. | |
| Sync-Failover (and Sync-Only) | Title capitalize and hyphenate to Sync-Failover unless referencing the option in tmsh; then lowercase and hyphenate as sync-failover. These guidelines apply to Sync-Only as well. | |
| tap | Describes action of touching the hardware touchscreens in hardware documentation. Do not use in software documentation; use "select" instead. | |
| tarball | tarball is defined as "files distributed as a tar archive"; a computer file format that can combine multiple files into a single, typically compressed, file. For the standard `gzip` compression algorithm, use the `tar.gz` extension for such files | |
| TCP flag names | All caps. SYN, ACK, PSH, URG, FIN, etc. (Industry standard) | |
| tense | Strive to use the simple present tense rather than the past or future, unless necessary for clarity. Do not: The system will receive. Do: The system receives. Do not: The feature was introduced in NGINX Instance Manger 2.16. Do: The feature is introduced in NGINX Instance Manager 2.16. (Remember that for some users older versions are used in the present.) | |
| text box | Use box. | |
| that vs. which vs. who | Be careful. Don't use *that* when you mean *who*. Use *that* for objects and *who* for people. Also, make sure you don't mean *which*. *That* sets off essential clauses (containing information essential to the meaning of the sentence). *Which* sets off non-essential clauses (not containing information essential to the meaning of the sentence). Examples: The virtual servers that you configured are ready. (*that you configured* is essential to distinguish them from virtual servers that you did not yet configure.) The virtual servers, which you configured, are ready. (*which you formatted* is not essential because you do not have any configured ones to distinguish the configured ones from. This is just extra, non-essential, information. Note: *which* and the clause it modifies are set off by commas because you could eliminate the clause without changing the meaning of the sentence. You can't do that with restrictive *that* clauses. | |
| There is / There are | Avoid starting sentences with "There is" or "There are." Instead, rephrase the sentence to start with the subject. | |
| third-party trademarks | Writers do not need to trademark third-party product names/companies in content such as topics, help, or release notes. In our copyright page, we include this statement: All other product and company names herein may be trademarks of their respective owners. Rationale: It is not required, and some third parties have guidelines explicitly requesting that their marks are not marked. If a specific vendor requests it, then we can. But generally, we should not. | |
| threshold event | We're not using this term in the documentation. The occurrence of system performance crossing a threshold and now behaving in a manner of interest to whoever established the threshold. A threshold event is generally associated with a notification. | |
| touchscreen | One word, used to describe new active screens in hardware displaying settings. | |
| trademarks | Watch out for possessive—don't do it in trademarks. For instance, you can't have the *NGINX's anything* but you can say the *NGINX instance's something*. Don't hyphenate trademarks. | |
| Traffic Management Microkernel (TMM) | First mention: the Traffic Management Microkernel (TMM)Subsequent references: the TMM | |
| Traffic Management Operating System (TMOS) | Do not use. See TMOS. | |
| typically vs. normally | When describing a predictable and expected action in technical content, write in terms of what is typical rather than normal for clarity. Normal implies judgment. Avoid particularly when applying to user actions, practices, or behaviors. Use typical instead. | |
| UDP | User Datagram Protocol. Do not spell out. | |
| UI/GUI/WebGUI | Don't use these terms in documentation. For UI, call it the browser interface or user interface if necessary. Don't use GUI, or WebGUI. | |
| unsecure and non-secure | Use unsecure and not insecure when describing a lack of security regarding something technical or technology-related in our documentation. If preferred and internally consistent with what you are documenting, non-secure may be OK, but defer to your editor. | |
| update | Use when moving from one minor version of a product to another. For example, from NGINX Instance Manager 2.1 to 2.2. For example: Before updating your system, you should read the release notes to understand any new issues. For example: OIDC-authenticated users can't view the Users list after updating to NGINX Instance Manager 2.9.1. | |
| upgrade | Use when moving from one major version of a product to another. For example, from NGINX Instance Manager 1.0 to 2.0. For example: When upgrading NGINX Instance Manager system, make sure your license key supports the new version. | |
| upper left hand | Don't use. See Page directions. | |
| upper right hand | Don't use. See Page directions. | |
| username | one word | |
| versions and version ranges | When referring to a software version, indicate the software name and then the version (for example, NGINX Instance Manager 2.16). Do not use the word version between the software name and the version (for example, NGINX Instance Manager version 2.x) When indicating a range of versions in procedure titles or subsection titles, indicate the software name and then the version range with a space, hyphen, and space between the version numbers (for example NGINX Instance Manager 1.x - 2.x). | |
| via | Do not use. Use by means of or through or recast in terms of using to ensure clarity of meaning and avoid confusion with Via Headers. (and because it is Latin.) | |
| vice versa | Another Latin word that we use like English. Avoid it; it's hard to translate. Instead, use conversely. | |
| virtual address | Use instead of virtual IP address or VIP. | |
| virtual address vs. virtual IP address | Although this refers to the IP address part of a virtual server destination address, only use virtual address (which also reflects the GUI). | |
| virtual edition/Virtual Edition | Use virtual edition as a generic term. For Virtual Edition, see VE. | |
| Virtual Local Area Network (VLAN) | Do not spell out unless necessary to context. | |
| Virtual Private Network (VPN) | Do not spell out unless necessary to context. | |
| walk | Don't use. Anthropomorphism. Instead, try guides, leads, conducts, directs, shows… Example: The Setup utility guides you through a series of pages. | |
| warning/caution | Caution is less severe than Warning. Use Caution when alerting that damage may occur, such as data loss. Use Warning as the severest form of advisory, reserved for when there's a hazard to personnel (such as you're being directed to install a server rack and there's a chance it may fall on you). | |
| wget | command.| |
| Wget | program. | |
| whether or not | Don't use whether or not something happens. Use whether. Also see if vs. whether. | |
| while | Avoid using while to mean although. Use although or though instead.<br> Avoid using while to mean whereas. Use whereas instead. | |
| whitelist and blacklist, whitelisting and blacklisting | Do not use these terms. Use the following substitutions: white list (noun) = allow list (noun); whitelist (verb) = allowlist (verb); whitelisted (adjective) = allowlisted (adjective); black list (noun) = deny list (noun); blacklist (verb) = denylist (verb); blacklisted (adjective) = denylisted (adjective). <br> For more information, refer to K34150231: Exclusionary language in F5 products and documentation. | |
| Wi-Fi vs. wifi vs. WiFi | Use Wi-Fi | |
| wide IP | Use an article when describing: the wide IP or a wide IP, as appropriate). | |
| window | Do not use window or screen. Use page. | |
| Window's | NEVER say Window's (as a possessive). Just Windows. | |
| wish, desire | Do not use. Belongs in fairy tales. Use want, need, require, or prefer. | |
| Wizard and wizard | When documenting the GUI, you can capitalize Wizard if appropriate, such as for the Network Access Setup Wizard. When writing about wizards in general, or when a page title of a dialog box or GUI does not show Wizard in uppercase format, you can leave wizard in lowercase format. | |
| WWW or www | Do not include www. in web addresses In text, do not use WWW, but use Internet instead. Of course, you can use www as part of a URL. Although we're moving away from that, too. | |

---

## Topic types and templates

When writing new documentation, use the following [templates](/templates):

- Concept Article
- Getting Started Guide
- How To Guide
- Installation Guide
- Reference Article
- Troubleshooting
- Tutorial

## Language guidelines

- Prefer active voice and goal-oriented phrases:

   | Do | Don't |
   |----|-------|
   | _To restart the system, run the following command.__ |_ For the system to be restarted, run the following command._ <br> Restarting the system can be achieved, if necessary, by running the following command._ |

- Prefer that for essential clauses, which for non-defining details.

- For optional, required, and forbidden actions, use proper modal verbs instead of ambiguous conditionals:

   | Do | Don't |
   |----|-------|
   | _You may/should/must add additional security by following this guide._ | _If more security is necessary, follow this guide._ |

   For more information about modal verb semantics, see [RFC-2119](https://tools.ietf.org/html/rfc2119).

- In code snippets, follow established style conventions of respective languages, including indentation, line breaks, and naming.

- Omit unnecessary words and phrases, courtesy sugaring in particular.

   | Do | Don't |
   |----|-------|
   | _To enable this feature, do that._ | _Oops! To enable this feature, please do that._ |

- Use hyphens to join compound adjectives before nouns, not after.

   | Do | Don't |
   |----|-------|
   | _A well-known feature._ | _A feature well-known._ |
   | _The feature is well known._ | _The feature is well-known._ |

## Titles: use sentence case

Use [sentence case](https://docs.microsoft.com/en-us/style-guide/text-formatting/using-type/use-sentence-style-capitalization) predominately. Use Title Case only when referring to specific API objects by name or when matching the UI.

Examples:

- "To create an App, select ..." 
- GET Get the details for a single Certificate
- Description: "Returns the metadata and status for the specified Certificate." 
- On the Overview page for your app, select **Create Component** (where Create Component is from the UI).. 
- GET Get the details for a single certificate. 
- Description: "Returns the metadata and status for the specified certificate." 
- Send a PUT request to the Roles endpoint to create a new role.

## Guidelines for screenshots

Only use screenshots when absolutely necessary, as they can be hard to keep up-to-date. Minimize their use to avoid frequent updates. Screenshots can quickly become outdated with changes in user interfaces or software versions, leading to user confusion. Consider if clear, concise written instructions can convey the information instead of a screenshot.

If you decide to include a screenshot, follow these guidelines:

- Use PNG format.
- Use filenames with lowercase words separated by dashes. For example, `nginx-management-suite-dashboard.png`. For consistency, don't use spaces or underscores.
- Use a resolution of 72 dpi.
- Set the width to 800 pixels for full-width screenshots.
- Use a transparent background to support both light and dark modes.
- Don't add a border; CSS automatically includes it when the screenshot is placed in the documentation.
- Don't capture the cursor in the screenshot.
- Ensure the screenshot includes the relevant item (button, menu item, icon) with enough context to locate it in the user interface and understand the action.
- Avoid unnecessary whitespace. Crop the image to include only relevant content. If needed, use image editing software to move content closer together, or ask the writers team for help.
- Use simple arrows and rectangles to highlight important items. Use a high-contrast color to make the annotations stand out.
- Include a description (`<img alt>` text) for the screenshot that provides a brief summary of the content and context. This description helps screen readers describe the image to visually impaired users. For example, "Area chart titled 'NGINX Active Connections' showing the number of active connections over time for the current date. The x-axis represents the time of day, and the y-axis represents the number of connections, ranging from 0 to 10,000. The chart is color-coded with different shades to indicate varying levels of connections." For examples and guidelines for effective alt text, see the BBC's useful guide [How to write text descriptions (alt text)](https://www.bbc.co.uk/gel/how-to-write-text-descriptions-alt-text).

## Sensitive and personally identifying information

Ensure content and screenshots are anonymized and don't contain sensitive information:

- Replace personal information (names, email addresses, phone numbers) with generic placeholders.
- Replace sensitive data (IP addresses, passwords, domain names, SSH keys, OAuth 2 tokens, and other confidential information) with generic placeholders.
  - Look for (and replace) sensitive words like `secret`
  - Look for (and replace) content such as UUIDs and OAuth 2 keys (which start with `eY`)
- Limit the use of links to external (non-F5) sources. When necessary, only link to reputable sources and foundational sites, such as GitHub.com, Google.com, and Microsoft.com.
  - This helps minimize the risk of prompt injection.

## Guidelines for `includes`

In an ideal world, we'd "write once, publish everywhere." To support this goal, we follow the principle of [Don't repeat yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) in our documentation. This principle shapes how we create and use `includes`, which pull reusable content from files in the [content/includes](https://github.com/nginxinc/docs/tree/main/content/includes) directory.

For example:

```text
{{< include "controller/helper-script-prereqs.md" >}}
```

This entry automatically incorporates content from the `helper-script-prereqs.md` file in the `content/includes/controller` subdirectory.

To make sure includes are effective and easy to maintain, follow these practices:

- **Use includes only for reusable content**: Create an include only if the content appears in at least **two locations**. Using an include for single-use content adds unnecessary complexity and makes maintenance harder.
- **Keep includes small and modular**: Write narrowly scoped snippets to maximize flexibility and reuse.
- **Avoid branded product names in includes**: Use the full product name (e.g., "NGINX Instance Manager"), but avoid including the branded version (e.g., "F5 NGINX Instance Manager"). The branded name is required only on the first mention in a document; this is a context-specific rule. Includes, however, are designed to be context-agnostic—they should not rely on or assume any prior content—so including the branded name could repeat information unnecessarily in locations where it has already been introduced.
- **Don't include headers**: Avoid adding H2 or other headers inside includes. These headers won't appear in the document's table of contents (TOC) and may not fit well with the surrounding content hierarchy. Add headers directly in the document instead.
- **Avoid nesting includes**: If there’s another way to achieve the same outcome, avoid nesting includes. While technically possible, it complicates reviews and maintenance. Use a flat structure for simplicity.
- **Don't start documents with includes**: The opening of a document is usually the introduction, which explains its purpose. Includes are reused text, so starting multiple documents with identical content could look odd, especially in search results.

## Guidelines for command-line operations

### Restarting vs. reloading NGINX

When managing NGINX through the command line, it’s important to choose the right command based on its effect on users and connections.

Before reloading or restarting NGINX, always check the syntax of the NGINX configuration to avoid potential errors. Use the following command:

```bash
sudo nginx -t
```


- **sudo systemctl nginx reload**
  Use `reload` to apply configuration changes without stopping active connections. This keeps the NGINX service running while updating the configuration. It’s the preferred option for most changes because it avoids downtime and doesn’t interrupt users.

  *Note*: While `nginx -s reload` is also available, it works differently by reading the configuration file twice: once when sending the signal and again when the master process reloads. `nginx -s reload` is typically used in environments that don’t use `systemd`, such as Windows. On most modern Linux distributions that use `systemd`, it’s better to use `systemctl reload nginx` because it integrates directly with the system’s service manager.

  Example:

  ```bash
  sudo systemctl reload nginx
  ```

- **sudo systemct restart nginx**
  Use restart when you need to fully stop and start NGINX, such as for software upgrades or clearing memory. This action will:
  - Drop all active connections, causing a temporary service interruption.
  - Reinitialize worker processes, which clears any in-memory states, including cached data.
  - Reload all modules and configurations. If there’s an error in the configuration, the restart will fail, potentially bringing down the service until the issue is resolved.
  - Reset logging, depending on your log rotation setup.
  - Clear any temporary files or ongoing operations (such as uploads or downloads), which could disrupt users mid-process.

  Example:

  ```bash
  sudo systemctl restart nginx
  ```

Key points:

- **Reload** is usually the best option to avoid disrupting users and to apply changes without downtime.
- **Restart** should only be used when necessary, with a clear warning about connection loss and potential disruption to ongoing operations.

## Revision history

The following table describes the history of all decisions and revisions made to
this style guide over time. This guide uses the Major.Minor.Patch
[semantic versioning](https://semver.org/) convention.

| Edition | Date          | Lead Author(s) | Comments                                              |
|---------|---------------|----------------|-------------------------------------------------------|
| 1.11  | April 23, 2025 | Mike Jang | Specify use of .tar.gz for tarballs. |
| 1.10  | February 19, 2025 | Mike Jang | Clarify use of nested includes. |
| 1.9   | December 10, 2024 | Mike Jang | Specify the use of "license" when writing about the JWT token associated with licensed versions of NGINX. |
| 1.8   | December 4, 2024 | Jon Torre | Clarify that heading text must not contain a link to other pages. |
| 1.7   | November 20, 2024 | Mike Jang  | Specify "includes" must be in at leat two locations. |
| 1.6   | October 23, 2024 | Jon Torre  | Incorporated specific guidelines from Unit's style guide |
| 1.5   | October 3, 2024 | Mike Jang  | Include guidelines for "includes"                      |
| 1.4   | Septemter 20, 2024 | Mike Jang  | Organize and clarify info on sensitive content |
| 1.3   | August 12, 2024 | Jon Torre  | Include additional rules for product names |
| 1.2   | June 21, 2024 | Travis Martin  | Added link to BBC's examples for effective alt images |
| 1.1   | May 21, 2024  | Jon Torre      | Added guidelines for screenshots                      |
| 1.0   | May 05, 2024  | Travis Martin  | First draft of Style Guide                            |

