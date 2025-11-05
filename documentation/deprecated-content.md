# Review deprecated content

As part of the documentation lifecycle, the documentation team periodically removes deprecated content.

Although a product may no longer be available for sale, we maintain the documentation until end of support for the benefit of its users.

By removing the content, their files do not create unnecessary noise when working on documentation, nor impact the user search experience.

Since we use git to track file changes, the documentation is still available by checking out an older revision of the repository.

To quickly traverse git history, we have created tags corresponding to the last commit prior to the removal of the products' files.

## Check out deprecated product documentation

To check out deprecated product documentation, use the `git` command:

```shell
git checkout <product-tag>
```

You should replace `<product-tag>` with a tag from the following table:

| Product name                           | Tag                  | Date of removal |
| -------------------------------------- | -------------------- | --------------- |
| NGINX App Protect WAF[^1]              | `archive-nap`        |                 |
| NGINX Application Connectivity Manager | `archive-acm`        |                 |
| NGINX Application Delivery Manager     | `archive-adm`        |                 |
| NGINX Controller                       | `archive-controller` |                 |
| NGINX Management Suite[^2]             | `archive-nms`        |                 |
| NGINX Service Mesh                     | `archive-mesh`       |                 |

[^1]: NGINX App Protect WAF is now known as F5 WAF for NGINX 
[^2]: NGINX Management Suite was refactored into NGINX Instance Manager