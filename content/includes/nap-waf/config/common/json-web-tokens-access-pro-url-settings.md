---
docs: DOCS-1497
---

The next step to configure JWT is to define the URL settings. Add the access profile name that you defined previously under the access profiles in the "name" field. From the previous example, we associate the access profile "**access_profile_jwt**" with the "name": **/jwt** in the URLs section to become effective, which means URLs with /jwt name are permitted for this feature and will be used for all JWT API requests.
Please note that the access profile cannot be deleted if it is in use in any URL.