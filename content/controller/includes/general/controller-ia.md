---
---

- **Analytics**: Enables data visualization for NGINX Controller.
- **Infrastructure**: Lets you manage your NGINX Plus instances and certain aspects of the host machines on which NGINX Controller and NGINX Plus instances run.
- **Platform**: Lets you manage NGINX Controller options and configurations, including Users, Roles, Licenses, and Global Settings.
- **Services**: Lets you manage your applications and APIs.

The diagrams below demonstrate how the different objects at the Service level relate to each other:

1. All Service objects are part of an Environment.
1. Gateways and Certs can be defined at the Environment level --or-- at the Component Level. The diagram below shows an example of how traffic flows through a Gateway to an App.
1. Components are child objects that represent the back-end server(s) that host your App or API.
    {{<note>}}A Component can represent an application **or** an API. The same Component cannot be used for both App Delivery and API Management.{{</note>}}
1. Certs can be added to a Gateway or to an individual Component.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-351 -->