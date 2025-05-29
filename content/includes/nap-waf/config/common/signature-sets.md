---
docs: "DOCS-1580"
---

The default and strict policies include and enable common signature sets, which are categorized groups of [signatures](#attack-signatures-overview) applied to the policy. However, you may wish to modify the list of signature sets and their logging and enforcement settings via the `signature-sets` array property. There are several ways to configure the enforced signature sets.

One way is by use of the `All Signatures` signature set, which is simply a predefined signature set that includes all signatures known to NGINX App Protect WAF.

In this example, the `All Signatures` set (and therefore the signatures included within) are configured to be enforced and logged respectively, by setting their `block` and `alarm` properties:

```json
{
    "policy": {
        "name": "attack_sigs",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ]
    }
}
```

In this example, only high accuracy signatures are configured to be enforced, but SQL Injection signatures are detected and reported:

```json
{
    "policy": {
        "name": "attack_sigs",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "High Accuracy Signatures",
                "block": true,
                "alarm": true
            },
            {
                "name": "SQL Injection Signatures",
                "block": false,
                "alarm": true
            }
        ]
    }
}
```

Since the "All Signatures" set is not included in the default policy, turning OFF both alarm and block has no effect because all the other sets with alarm turned ON (and high accuracy signatures with block enabled) are still in place and a signature that is a member of multiple sets behaves in accordance with the strict settings of all sets it belongs to. The only way to remove signature sets is to remove or disable sets that are part of the [default policy](#signature-sets-in-default-policy).

For example, in the below default policy, even though All Signature's Alarm/Block settings are set to false, we cannot ignore all attack signatures enforcement as some of the signature sets will be enabled in their strict policy. If the end users want to remove a specific signature set then they must explicitly mention it under the [strict policy](#the-strict-policy).

```json
{
    "policy": {
        "name": "signatures_block",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "caseInsensitive": false,
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                "name": "Generic Detection Signatures (High/Medium Accuracy)",
                "block": false,
                "alarm": false
            },
            {
                "name": "All Signatures",
                "block": false,
                "alarm": false
            }
        ]
    }
}
```

A signature may belong to more than one set in the policy. Its behavior is determined by the most severe action across all the sets that contain it. In the above example, a high accuracy SQL injection signature will both alarm and block, because the `High Accuracy Signatures` set is blocking and both sets trigger alarm.

The default policy already includes many signature sets, most of which are determined by the attack type these signatures protect from, for example `Cross-Site Scripting Signatures` or `SQL Injection Signatures`. See [the full list](#signature-sets-in-default-policy) above. In some cases you may want to exclude individual signatures.

In this example, signature ID 200001834 is excluded from enforcement:

```json
{
    "policy": {
        "name": "signature_exclude",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ],
        "signatures": [
            {
                 "signatureId": 200001834,
                 "enabled": false
            }
        ]
    }
}
```

Another way to exclude signature ID 200001834 is by using the `modifications` section instead of the `signatures` section used in the example above:

```json
{
    "policy": {
        "name": "signature_modification_entitytype",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-sets": [
            {
                 "name": "All Signatures",
                 "block": true,
                 "alarm": true
            }
        ]
    },
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

To exclude multiple attack signatures, each signature ID needs to be added as a separate entity under the `modifications` list:

```json
{
    "modifications": [
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200001834
            },
            "entityType": "signature",
            "action": "add-or-update"
        },
        {
            "entityChanges": {
                "enabled": false
            },
            "entity": {
                "signatureId": 200004461
            },
            "entityType": "signature",
            "action": "add-or-update"
        }
    ]
}
```

In the above examples, the signatures were disabled for all the requests that are inspected by the respective policy. You can also exclude signatures for specific URLs or parameters, while still enable them for the other URLs and parameters. See the sections on [User-Defined URLs](#user-defined-urls) and [User-Defined Parameters](#user-defined-parameters) for details.

In some cases, you may want to remove a whole signature set that was included in the default policy. For example, suppose your protected application does not use XML and hence is not exposed to XPath injection. You would like to remove the set `XPath Injection Signatures`. There are two ways to do that. The first is to set the `alarm` and `block` flags to `false` for this signature set overriding the settings in the base template:

```json
{
    "policy": {
        "name": "no_xpath_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "signature-sets": [
            {
                 "name": "XPath Injection Signatures",
                 "block": false,
                 "alarm": false
            }
        ]
    }
}
```

The second way is to remove this set totally from the policy using the `$action` meta-property.

```json
{
    "policy": {
        "name": "no_xpath_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "signature-sets": [
            {
                 "name": "XPath Injection Signatures",
                 "$action": "delete"
            }
        ]
    }
}
```

Although the two methods are functionally equivalent, the second one is preferable for performance reasons.


#### Server Technologies

Another way to configure attack signature sets is by applying server technologies. Server technologies applies sets of signatures that would be relevant to attacks targeted to a specific OS, application, or server type. The Server technologies are represented in attack signatures as `systems` using the same name, for example `SharePoint`. Note, however, that the overlap between Server technologies and signature systems is not complete: there are server technologies that cannot be represented as signature systems, and also a few generic signature systems that are not represented as server technologies. The exact details will follow in the sections just below. Server technologies that are not signature systems will not bring in new signatures when added to the policy. However, associating them with the policy still has declarational value, and in one of the future signature updates they may be associated with new signatures.

In this example, we enable the attack signature violation, and enabled the **Apache/NCSA HTTP Server** server technology, which in turn enables attack signatures specific to this type of technology. We also enabled signatures with minimum accuracy of low. This would include low, medium, and high accuracy attack signatures.

```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "signature-settings": {
            "minimumAccuracyForAutoAddedSignatures": "low"
        },
        "server-technologies": [
            { "serverTechnologyName": "Apache/NCSA HTTP Server" }
        ]
    }
}
```


##### Available Server Technologies

The table below lists all the available Server Technologies. Some of them are built on top others on the stack and including them implies the inclusion of the latter. For example: ASP.NET implies both IIS and Microsoft Windows. This is indicated in the "implied technologies" column when applicable. We also denote the server technologies that currently have a signature system counterpart.


{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|Server Technology Name | Description | Implied Technologies | Signature System? |
| ---| ---| ---| --- |
|Jenkins | Jenkins is an open source automation server written in Java. Jenkins helps to automate the non-human part of the software development process, with continuous integration and facilitating technical aspects of continuous delivery. It is a server-based system that runs in servlet containers such as Apache Tomcat. |  | Yes |
|SharePoint | SharePoint is a web-based collaborative platform that integrates with Microsoft Office. Launched in 2001, SharePoint is primarily sold as a document management and storage system, but the product is highly configurable and usage varies substantially among organizations. |  | Yes |
|Oracle Application Server | Oracle Internet Application Server provides a single integrated packaged solution of for middleware infrastructure including Oracle Containers for J2EE, Oracle Web Cache, Oracle HTTP Server, Oracle Forms, Oracle Reports, Oracle Portal and Oracle Discoverer. |  | Yes |
|Python | Python is an interpreted, high-level, general-purpose programming language. Created by Guido van Rossum and first released in 1991, Python has a design philosophy that emphasizes code readability, notably using significant whitespace. It provides constructs that enable clear programming on both small and large scales. |  | Yes |
|Oracle Identity Manager | Oracle Identity Manager (OIM) enables enterprises to manage the entire user lifecycle across all enterprise resources both within and beyond a firewall. Within Oracle Identity Management it provides a mechanism for implementing the user-management aspects of a corporate policy. |  | Yes |
|Spring Boot | Spring Boot makes it easy to create Spring-powered, production-grade applications and services with absolute minimum fuss. It takes an opinionated view of the Spring platform so that new and existing users can quickly get to the bits they need. |  | Yes |
|CouchDB | Apache CouchDB is open source database software that focuses on ease of use and having a scalable architecture. |  | Yes |
|SQLite | SQLite is a relational database management system contained in a C programming library. In contrast to many other database management systems, SQLite is not a client-server database engine. Rather, it is embedded into the end program. |  | Yes |
|Handlebars | Handlebars provides the power necessary to let you build semantic templates effectively with no frustration. |  | No |
|Mustache | Mustache is a simple web template system. |  | No |
|Prototype | Prototype takes the complexity out of client-side web programming. Built to solve real-world problems, it adds useful extensions to the browser scripting environment and provides elegant APIs around the clumsy interfaces of Ajax and the Document Object Model. |  | No |
|Zend | Zend Server is a complete and certified PHP distribution stack fully maintained and supported by Zend Technologies. It ships with an updated set of advanced value-add features designed to optimize productivity, performance, scalability and reliability. |  | No |
|Redis | Redis is an open source in-memory data structure project implementing a distributed, in-memory key-value database with optional durability. Redis supports different kinds of abstract data structures, such as strings, lists, maps, sets, sorted sets, hyperloglogs, bitmaps, streams and spatial indexes. |  | Yes |
|Underscore.js | Underscore.js is a JavaScript library which provides utility functions for common programming tasks. It is comparable to features provided by Prototype.js and the Ruby language, but opts for a functional programming design instead of extending object prototypes |  | No |
|Ember.js | Ember.js is an open source JavaScript web framework, based on the Model-view-viewmodel pattern. It allows developers to create scalable single-page web applications by incorporating common idioms and best practices into the framework. |  | No |
|ZURB Foundation | Foundation is a responsive front-end framework. Foundation provides a responsive grid and HTML and CSS UI components, templates, and code snippets, including typography, forms, buttons, navigation and other interface elements, as well as optional functionality provided by JavaScript extensions. Foundation is maintained by ZURB and is an open source project. |  | No |
|ef.js | ef.js is an elegant HTML template engine & basic framework. |  | No |
|Vue.js | Vue.js is an open source JavaScript framework for building user interfaces and single-page applications. |  | No |
|UIKit | UIkit is a lightweight and modular front-end framework for developing fast and powerful web interfaces. |  | No |
|TYPO3 CMS | TYPO3 is a free and open source web content management system written in PHP. It is released under the GNU General Public License. It can run on several web servers, such as Apache or IIS, on top of many operating systems, among them Linux, Microsoft Windows, FreeBSD, macOS and OS/2. |  | No |
|RequireJS | RequireJS is a JavaScript library and file loader which manages the dependencies between JavaScript files and in modular programming. It also helps to improve the speed and quality of the code. |  | No |
|React | React is a JavaScript library for building user interfaces. It is maintained by Facebook and a community of individual developers and companies. React can be used as a base in the development of single-page or mobile applications. |  | Yes |
|MooTools | MooTools is a lightweight, object-oriented JavaScript framework. It is released under the free, open source MIT License. |  | No |
|Laravel | Laravel is a free, open source PHP web framework, created by Taylor Otwell and intended for the development of web applications following the model-view-controller architectural pattern and based on Symfony. |  | No |
|Google Web Toolkit | Google Web Toolkit, or GWT Web Toolkit, is an open source set of tools that allows web developers to create and maintain complex JavaScript front-end applications in Java. Other than a few native libraries, everything is Java source that can be built on any supported platform with the included GWT Ant build files. |  | No |
|Express.js | Express.js, or simply Express, is a web application framework for Node.js, released as free and open source software under the MIT License. It is designed for building web applications and APIs. It has been called the de facto standard server framework for Node.js. |  | No |
|CodeIgniter | CodeIgniter is an open source software rapid development web framework, for use in building dynamic web sites with PHP. |  | No |
|Backbone.js | Backbone.js is a JavaScript library with a RESTful JSON interface and is based on the Model-view-presenter application design paradigm. Backbone is known for being lightweight, as its only hard dependency is on one JavaScript library, Underscore.js, plus jQuery for use of the full library. |  | No |
|AngularJS | AngularJS is a JavaScript-based open source front-end web application framework mainly maintained by Google and by a community of individuals and corporations to address many of the challenges encountered in developing single-page applications. |  | Yes |
|JavaScript | JavaScript, often abbreviated as JS, is a high-level, interpreted programming language that conforms to the ECMAScript specification. It is a language which is also characterized as dynamic, weakly typed, prototype-based and multi-paradigm. |  | Yes |
|NGINX | NGINX is a web server which can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache. |  | Yes |
|Jetty | Jetty is a Java HTTP (Web) server and Java Servlet container | Java Servlets/JSP | Yes |
|Joomla | Joomla is a free and open source content management system (CMS) for publishing web content. | PHP | Yes |
|JavaServer Faces (JSF) | JavaServer Faces (JSF) is a Java specification for building component-based user interfaces for web applications. | Java Servlets/JSP | Yes |
|Ruby | Ruby is a dynamic, reflective, object-oriented, general-purpose programming language. |  | Yes |
|MongoDB | MongoDB is a free and open source cross-platform document-oriented database program. |  | Yes |
|Django | Django is a free and open source web framework, written in Python, which follows the model-view-template (MVT) architectural pattern. |  | Yes |
|Node.js | Node.js is an open source, cross-platform JavaScript runtime environment for developing a diverse variety of tools and applications. |  | Yes |
|Citrix | Citrix Systems, Inc. is an American multinational software company that provides server, application and desktop virtualization, networking, software as a service (SaaS), and cloud computing technologies. |  | Yes |
|JBoss | The JBoss Enterprise Application Platform (or JBoss EAP) is a subscription-based/open source Java EE-based application server runtime platform used for building, deploying, and hosting highly-transactional Java applications and services. | Java Servlets/JSP | Yes |
|Elasticsearch | Elasticsearch is a search engine based on Lucene. |  | Yes |
|Apache Struts | Apache Struts is an open source web application framework for developing Java EE web applications. | Java Servlets/JSP | Yes |
|XML | Extensible Markup Language (XML) is a markup language that defines a set of rules for encoding documents in a format that is both human-readable and machine-readable. |  | Yes |
|PostgreSQL | PostgreSQL, often simply Postgres, is an object-relational database (ORDBMS) - that is, an RDBMS, with additional (optional use) \"object\" features - with an emphasis on extensibility and standards-compliance. |  | Yes |
|IBM DB2 | IBM DB2 contains database server products developed by IBM. |  | Yes |
|Sybase/ASE | SAP ASE (Adaptive Server Enterprise), originally known as Sybase SQL Server, and also commonly known as Sybase DB or ASE, is a relational model database server product for businesses developed by Sybase Corporation which became part of SAP AG. |  | Yes |
|CGI | Common Gateway Interface (CGI) offers a standard protocol for web servers to interface with executable programs running on a server that generate web pages dynamically. |  | Yes |
|Proxy Servers | A proxy server is a server (a computer system or an application) that acts as an intermediary for requests from clients seeking resources from other servers. |  | Yes |
|SSI (Server Side Includes) | Server Side Includes (SSI) is a simple interpreted server-side scripting language used almost exclusively for the Web. |  | Yes |
|Cisco | Cisco Systems, Inc. is an American multinational corporation technology company headquartered in San Jose, California, that designs, manufactures and sells networking equipment worldwide. |  | Yes |
|Novell | Novell Directory Services (NDS) is a popular software product for managing access to computer resources and keeping track of the users of a network, such as a company's intranet, from a single point of administration. |  | Yes |
|Macromedia JRun | JRun is a J2EE application server, originally developed in 1997 as a Java Servlet engine by Live Software and subsequently purchased by Allaire, who brought out the first J2EE compliant version. |  | Yes |
|BEA Systems WebLogic Server | Oracle WebLogic Server is a Java EE application server currently developed by Oracle Corporation. | Java Servlets/JSP | Yes |
|Lotus Domino | IBM Notes and IBM Domino are the client and server, respectively, of a collaborative client-server software platform sold by IBM. |  | Yes |
|MySQL | MySQL is an open source relational database management system (RDBMS). |  | Yes |
|Oracle | Oracle Database (commonly referred to as Oracle RDBMS or simply as Oracle) is an object-relational database management system produced and marketed by Oracle Corporation. |  | Yes |
|Microsoft SQL Server | Microsoft SQL Server is a relational database management system developed by Microsoft. |  | Yes |
|PHP | PHP is a server-side scripting language designed primarily for web development but is also used as a general-purpose programming language. |  | Yes |
|Outlook Web Access | Outlook on the web (previously called Exchange Web Connect, Outlook Web Access, and Outlook Web App in Office 365 and Exchange Server 2013) is a personal information manager web app from Microsoft. | ASP.NET, IIS, Microsoft Windows | Yes |
|Apache/NCSA HTTP Server | The Apache HTTP Server, colloquially called Apache, is the world's most used web server software. |  | Yes |
|Apache Tomcat | Apache Tomcat, often referred to as Tomcat, is an open source Java Servlet Container developed by the Apache Software Foundation (ASF). | Java Servlets/JSP | Yes |
|WordPress | WordPress is a free and open source content management system (CMS) based on PHP and MySQL. | XML, PHP | Yes |
|Macromedia ColdFusion | Adobe ColdFusion is a commercial rapid web application development platform created by JJ Allaire in 1995. |  | Yes |
|Unix/Linux | Unix is a family of multitasking, multiuser computer operating systems that derive from the original AT&T Unix, developed in the 1970s at the Bell Labs research center by Ken Thompson, Dennis Ritchie, and others. |  | Yes |
|Microsoft Windows | Microsoft Windows (or simply Windows) is a meta-family of graphical operating systems developed, marketed, and sold by Microsoft. |  | Yes |
|ASP.NET | ASP.NET is an open source server-side web application framework designed for web development to produce dynamic web pages. | IIS, Microsoft Windows | Yes |
|Front Page Server Extensions (FPSE) | FrontPage Server Extensions are a software technology that allows Microsoft FrontPage clients to communicate with web servers, and provide additional functionality intended for websites. |  | Yes |
|IIS | Internet Information Services (IIS, formerly Internet Information Server) is an extensible web server created by Microsoft for use with Windows NT family. | Microsoft Windows | Yes |
|WebDAV | Web Distributed Authoring and Versioning (WebDAV) is an extension of the Hypertext Transfer Protocol (HTTP) that allows clients to perform remote Web content authoring operations. |  | Yes |
|ASP | Active Server Pages (ASP), later known as Classic ASP or ASP Classic, is Microsoft's first server-side script engine for dynamically generated web pages. | IIS, Microsoft Windows | Yes |
|Java Servlets/JSP | A Java servlet is a Java program that extends the capabilities of a server. |  | Yes |
|jQuery | jQuery is a cross-platform JavaScript library designed to simplify the client-side scripting of HTML. |  | Yes |
{{</bootstrap-table>}}

##### Generic Signature Systems

These signature systems are generic and do not represent a particular technology, therefore do not have a server technology counterpart. Yet, there are signatures associated with them. The `Generic Detection Signatures` factory signature set includes most of these signatures. You can define your own signature sets using one or more of those systems.

{{<bootstrap-table "table table-striped table-bordered table-sm table-responsive">}}
|System Name | Description |
| ---| --- |
|Other Web Server | Web Servers that are not covered by any of the specific server technologies |
|System Independent | Used to denote signatures that apply to any server technology |
|Various Systems | Server-side systems not covered by any of the existing server technologies or the other systems here |
|Generic Database | Database systems that are not covered by any of the specific server technologies |
{{</bootstrap-table>}}


#### Threat Campaigns

Threat Campaigns is a threat intelligence feature included in an NGINX App Protect WAF subscription. The feature includes frequent update feeds containing contextual information about active attack campaigns currently being observed by F5 Threat Labs that NGINX App Protect WAF can provide protection against. As an example, without threat campaign updates NGINX App Protect WAF (and any WAF in general) may detect an attack pattern in a web application form parameter, but it cannot correlate the singular attack incident as part of a more extensive and sophisticated threat campaign. Threat Campaigns' contextual information is very specific to current attack campaigns, allowing false positives to be virtually non-existent.

Just like attack signatures, the Threat Campaign patterns, i.e. `app-protect-attack-signatures` and `app-protect-threat-campaigns` are installed as a dependency chain of our main package `app-protect`. Then, these two package dependencies should be updated periodically to get the latest security updates. Due to the highly dynamic nature of threat campaigns the updates are issued far more frequently than the attack signatures. You need to install those updates close to the time they are issued in order to get the most effective protection.

The default policy enables the mechanism with all available Threat Campaigns and blocks when detecting one. Since the risk of false positive is very low, you do not need to enable or disable specific Threat Campaigns. Rather, you can disable the whole mechanism or decide to only alarm rather than block. You can do that by modifying the properties of the Threat Campaign Violation - `VIOL_THREAT_CAMPAIGN`.

In this example we disable both alarm and blocking.

 ```json
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_THREAT_CAMPAIGN",
                    "alarm": false,
                    "block": false
                }
            ]
        }
    }
}

```

#### Data Guard - Blocking

Data Guard is a security feature that can be used to prevent the leakage of sensitive information from an application. This could be credit card numbers (CCN) or Social Security numbers (SSN) or custom patterns. Once this feature is enabled, sensitive data is either blocked or masked, depending on the configuration.

In this example, we enable the data guard violation in blocking mode. In the detailed configuration, we enable enforcement of data guard and specify which items are being protected against information leakage. Note that if blocking is enabled, data masking will have no effect in this case.

```json
{
    "policy": {
        "name": "dataguard_blocking",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_DATA_GUARD",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "data-guard": {
            "enabled": true,
            "maskData": true,
            "creditCardNumbers": true,
            "usSocialSecurityNumbers": true,
            "enforcementMode": "ignore-urls-in-list",
            "enforcementUrls": []
        }
    }
}
```

#### Data Guard - Masking

Masking is used when we do not want to block the page entirely but want to mask all sensitive data in the response.

In this example, we enable data guard in alarm mode. In the detailed configuration, we enable enforcement of data guard and specify which items are being protected against information leakage.

```json
{
    "policy": {
        "name": "nginx_default_policy",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_DATA_GUARD",
                    "alarm": true,
                    "block": false
                }
            ]
        },
        "data-guard": {
            "enabled": true,
            "maskData": true,
            "creditCardNumbers": true,
            "usSocialSecurityNumbers": true,
            "enforcementMode": "ignore-urls-in-list",
            "enforcementUrls": []
        }
    }
}
```