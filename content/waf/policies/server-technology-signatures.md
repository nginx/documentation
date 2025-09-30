---
title: Server technology signatures
weight: 1900
toc: true
nd-content-type: reference
nd-product: NAP-WAF
nd-docs: DOCS-000
---

Another way to configure attack signature sets is by applying **server technologies**. A server technology represents a specific OS, application, or server type, and applying it enables the sets of attack signatures relevant to that technology.

Server technologies are also represented in attack signatures as **systems** with the same name (for example, *SharePoint*). However, the overlap between server technologies and signature systems is not exact. Some server technologies do not map to any signature system, and there are a few generic signature systems that are not represented as server technologies. Details on these differences are provided in the following sections.

It is important to note that server technologies without a corresponding signature system will not add new signatures when included in the policy. Even so, associating them with the policy still has value, since they may be linked to new signatures in future updates.

In the following example, we enable the attack signature violation and apply the *Apache/NCSA HTTP Server* server technology. This enables signatures specific to that server type. We also configure the system to include signatures with a minimum accuracy of **low**, which means signatures of low, medium, and high accuracy are all applied.

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

### Available server technologies

The table below lists all available server technologies. Some technologies are built on top of others in the stack, and including them in a policy automatically implies the inclusion of the underlying ones.

For example, selecting **ASP.NET** also implies **IIS** and **Microsoft Windows**. This relationship is shown in the *Implied technologies* column when applicable.

The table also indicates which server technologies currently have a corresponding signature system.

{{< table variant="narrow" theme="bordered">}}
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
{{< /table >}}

### Generic signature systems

These signature systems are generic and not tied to any specific technology, so they do not have a server technology counterpart. However, signatures are still associated with them.

Most of these signatures are included in the **Generic Detection Signatures** factory signature set. You can also create custom signature sets that use one or more of these generic systems.

{{< table variant="narrow" theme="bordered">}}
| System name        | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| Other Web Server    | Web servers that are not covered by any of the specific server technologies |
| System Independent  | Used to denote signatures that apply to any server technology               |
| Various Systems     | Server-side systems not covered by any existing server technologies or the other systems listed here |
| Generic Database    | Database systems that are not covered by any of the specific server technologies |
{{< /table >}}
