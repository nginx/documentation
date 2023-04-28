# nms-docs repo

This repo houses the product documentation for the NGINX Management Suite:

- NMS Platform 
- Instance Manager module
- API Connectivity Manager module
- App Delivery Manager module (coming soon!)
- Security Monitoring module

Content directory tree:

```shell
└── content
    ├── acm             \\ content for API Connectivity Manager
    ├── adm             \\ content for App Delivery Manager  
    ├── admin-guides    \\ administrator content related to platform installation and setup
    ├── includes        \\ content that can be reused in other files, organized by product
    ├── nginx-agent     \\ content for NGINX Agent*
    ├── nim             \\ content for Instance Manager
    └── security        \\ content for Security Monitoring

```

\* Some of the Agent content will migrate to the open source [agent repo](https://github.com/nginx/agent). Content specific to the NMS use case will remain here.

> If you're unsure where to add new documentation, refer to this [information architecture diagram](https://lucid.app/lucidchart/9e08c70b-474b-4fca-be9e-4322a970b0b5/edit?viewport_loc=-1511%2C-9511%2C2325%2C1389%2C0zeGYG.TUQLB&invitationId=inv_8aa60510-fd69-418c-8679-746ae3770e88).

## Where to Find Docs Online

When you merge to the "main" branch in this repo, the docs deploy immediately to the production website: [docs.nginx.com/nginx-management-suite](https://docs.nginx.com/nginx-management-suite)

The internal preview site below is used for merge request reviews.

> Internal Docs: https://nms-docs-private.netlify.app/
>
> pw: `NGINX_docs001`

Deploy previews for merge requests will prepend the branch name to the domain. For example `https://<branch-name>--nms-docs-private.netlify.app`.
This lets us share stable URLs with stakeholders for review. 

## Contributing

Docs are written in Markdown. We build the docs using [Hugo](https://gohugo.io) and host them on [Netlify](https://www.netlify.com/).

We use a set of pre-defined [content types and templates](https://nginxsoftware.atlassian.net/wiki/spaces/ENGUSEMEA/pages/439320577/Content+Types+and+Templates), which can help you get started when working on new docs.

> Refer to [Add new docs](#add-new-docs) to learn how to create new docs using Hugo.

## Branch Management

**In this repo, the `main` branch should always be releaseable. Commits to `main` will publish to the live documentation website automatically.**

The default branch in the repo is `staging`. **Commits merged to staging can be cherry-picked to `main` for release.** 

### Preparing content for an upcoming release

**When working on content for a release with a delayed publication timeline:**

1. Create a feature branch specific to that version. **Follow the naming convention `<acronym>-release-0.0.0`**, e.g., `nim-release-2.4.0` (all lowercase).
2. Treat the version feature branch as if it were the main branch for the version.

    - Cut new feature branches from the release branch and merge your work into the release branch as it's completed.
    - Share the branch URL for the release branch with stakeholders so they can preview the documentation for the release. 
      Netlify's branch name URLs follow the format `https://<branch-name>--nms-docs-private.netlify.app`.

    > TIP: Keep your git history tidy and write clear, concise commit messages that refer to the Jira ID and epic for the docs work. This helps make it easier to back out content for features that miss the release train.

3. Merge release branches into `staging` to prepare for publication. 
4. To release content publicly to docs.nginx.com, cherry-pick the release branch merge commit from `staging` to `main`.

### Preparing content that's not time-sensitive

**When working on content that can be published at any time:**

1. Create a feature branch from `staging`.
2. Merge the update into `staging`.
3. Cherry-pick the merge commit from `staging` to `main` to publish.

### Keeping feature and release branches current

Use the following workflow to keep your feature branch up-to-date:

``` shell
git checkout <your-feature-branch>
git pull --ff-only origin/<source branch>
```

The DocOps team will keep release branches up-to-date with the staging branch, using a [rebase](https://git-scm.com/docs/git-rebase) workflow.

## Tools

In this directory, you will find files that support the tools we use to lint, build, and deploy the docs:

- a GitLab CI config that contains the docs lint, build, and publish jobs;
- configuration files for [markdownlint](https://github.com/DavidAnson/markdownlint/) and [markdown-link-check](https://github.com/tcort/markdown-link-check);
- a [`config`](./config/) directory that contains the [Hugo](https://gohugo.io) configuration. Each sub-directory represents a different Hugo build environment (e.g., staging, production);
  > [Learn more about Hugo configuration](https://gohugo.io/getting-started/configuration/#configuration-directory) 
- a [Netlify](https://netlify.com) configuration file.

### Setup

1. To install Hugo locally, refer to the [Hugo installation instructions](https://gohugo.io/getting-started/installing/).

    > **NOTE**: We don't support versions newer than v0.91 yet, so we recommend using the [Binary](https://gohugo.io/getting-started/installing/#binary-cross-platform) installation option.

2. We use the `netlify-cli` tool to build deploy previews and deploy them to Netlify. Use `npm` to install `netlify-cli` if you want to deploy to Netlify from your development environment.

    ```shell
    npm i -g netlify-cli
    ```

3. We use markdownlint to check that Markdown files are correct. Use `npm` to install `markdownlint-cli` if you want to lint the files locally.

    ```shell
    npm i -g markdownlint-cli   
    ```

### Hugo Theme

The docs rely on the [f5-hugo theme](https://gitlab.com/f5/nginx/controller/poc/f5-hugo) for the page layouts.
The theme is imported as Hugo module (essentially the same thing as go mods), via the [default docs config](./_default/config.toml). 

### Local Docs Development

To build the docs locally, run the desired `make` command from the docs directory:

```text
make clean          -   removes the local `public` directory, which is the default output path used by Hugo
make docs           -   runs a local hugo server so you can view docs in your browser while you work
make docs-drafts    -   runs the local hugo server and includes all docs marked with `draft: true`
make hugo-mod       -   cleans the Hugo module cache and fetches the latest version of the theme module
make docs-local     -   runs the `hugo` command to generate static HTML files into the `public` directory
make netlify        -   runs the netlify build and deploy commands; use this command to deploy docs to netlify from your local environment
```

> **Note:** Before you can deploy to Netlify from your local environment, you must log in. 
> Contact the [doc-ops team](https://nginx.slack.com/archives/CRA509PUM) if you have any trouble logging in.
> 
> 1. Run `netlify login` in your terminal. This will open a web browser with the Netlify login screen. 
> 2. Use the GitLab option to log in using F5 SSO.
> 
> Refer to the [Netlify CLI Getting Started Guide](https://docs.netlify.com/cli/get-started/) for more information.

### Linting

- To run the style and grammar check, run the following command from the docs directory:

    ```bash
    docker run --rm -it -v $PWD/content:/root/content --workdir /root/content nginxdevopssvcs.azurecr.io/cylon-indigo-docker-dev/f5/nginx/controller/tools/docs/vale-lint:0.5.0 vale ./content
    ```

    **Note**: If you're not able to pull the image, run `az login` and `az acr login --name nginxdevopssvcs` to log in to Azure.

- To run the markdownlint check, run the following command from the docs directory:

    ```bash
    markdownlint -c .gitlab/ci/markdown_lint_config.json content    
    ```

    **Note**: You can run this tool on an entire directory or on an individual file.

## Add new docs

### Create an entry for your new document in the Documentation Catalog

**Required**: Add your new document to the [Documentation Catalog](https://nginxsoftware.atlassian.net/jira/software/c/projects/DOCS/issues).
Complete field descriptions and extended instructions are available at the [Watchdocs Catalog and Audit](https://nginxsoftware.atlassian.net/wiki/x/UQD-aw) website.

1. Create a new entry in the DOCS project (**Jira > Create > Project: Docs Catalog**).

2. Fill out the new ticket creation form with the information currently available. You can use temporary values for the **Summary** and **Description** while working on the draft. 

3. Once you have created a new doc following the steps in the next section, add the ticket ID (DOCS-<number>) from the Documentation Catalog entry you just created to the front matter `docs:` key before you merge your changes.

4. Once your changes have been merged and the new document is published, complete and confirm the required fields -- Title, Description, SME Squad, Docs Team, Product, Code Location, and Visibility -- and transition your DOCS Jira ticket to `Operational` status.

### Generate a new doc file using Hugo

To create a new doc file that contains all of the pre-configured Hugo front-matter and the docs task template, **run the following command in the docs directory**:

`hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>`

e.g.,

`hugo new getting-started/install.md`

The default template -- task -- should be used for most docs. To docs from the other content templates, you can use the `--kind` flag:

`hugo new tutorials/deploy.md --kind tutorial`

The available content types (`kind`) are:

- concept: Helps a customer learn about a specific feature or feature set.
- tutorial: Walks a customer through an example use case scenario; results in a functional PoC environment.
- reference: Describes an API, command line tool, config options, etc.; should be generated automatically from source code. 
- troubleshooting: Helps a customer solve a specific problem.
- openapi: Contains front-matter and shortcode for rendering an openapi.yaml spec

## How to format docs

### Internal links

Format links as [Hugo refs](https://gohugo.io/content-management/cross-references/). 

- File extensions are optional.
- You can use relative paths or just the filename. (**Paths without a leading / are first resolved relative to the current page, then to the remainder of the site.**)
- Anchors are supported.

For example:

```md
To install <product>, refer to the [installation instructions]({{< ref "install" >}}).
```

### Hugo shortcodes

You can use [Hugo shortcodes](/docs/themes/f5-hugo/layouts/shortcodes/) to do things like format callouts, add images, and reuse content across different docs. 

For example, to use the note callout:

```md
{{< note >}}Provide the text of the note here. {{< /note >}}
```

The callout shortcodes also support multi-line blocks:

```md
{{< caution >}}
You should probably never do this specific thing in a production environment. 

If you do, and things break, don't say we didn't warn you.
{{< /caution >}}
```

Supported callouts:

- `caution`
- `important`
- `note`
- `see-also`
- `tip`
- `warning`

A few more fun shortcodes:

- `fa`: inserts a Font Awesome icon
- `img`: include an image and define things like alt text and dimensions
- `include`: include the content of a file in another file (requires the included file to be in the content/includes directory; will be deprecated in favor of readfile)
- `link`: makes it possible to link to a file and prepend the path with the Hugo baseUrl
- `openapi`: loads an OpenAPI spec and renders as HTML using ReDoc
- `raw-html`: makes it possible to include a block of raw HTML
- `readfile`: includes the content of another file in the current file (intended to replace `include`)
- `bootstrap-table`: formats a table using Bootstrap classes; accepts any bootstrap table classes as additional arguments, e.g. `{{< bootstrap-table "table-bordered table-hover" }}`
