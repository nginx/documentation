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
| NGINX App Protect WAF[^1]              | `archive-nap`        | 2025-11-05      |
| NGINX Controller                       | `archive-controller` | 2025-10-08      |
| NGINX Management Suite[^2]             | `archive-nms`        | 2025-10-08      |
| NGINX Service Mesh                     | `archive-mesh`       | 2025-11-05      |

## Review and add tags

You can review the repository tags using the `git tag` command:

```text
➜ git tag -l
archive-controller
archive-mesh
archive-nap
archive-nms
```

To add a new tag, use the following command:

```shell
git tag -a <tag-name> <commit-sha>
```

The tag name should follow the format of _archive-\<product-name\>_, and the commit sha should be the last commit **before** the content was removed.

To add the new tag to the remote repository, you must add it as an explicit argument to `git push`:

```shell
git push origin <tag-name>
```

[^1]: NGINX App Protect WAF is now known as F5 WAF for NGINX  
[^2]: NGINX Management Suite was refactored into NGINX Instance Manager