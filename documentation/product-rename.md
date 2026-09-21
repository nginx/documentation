# Product rename playbook

This playbook describes how to rename a product's documentation tree while
keeping the old pages live as stub pages. Use it when a product is
consolidated under a new name and a new content path, and you need the old
URLs to keep working, keep their search ranking, and point readers and search
engines at the new content.

This playbook covers the **copy-and-stub** pattern: the old content tree
stays in place, gets a small set of metadata changes and a callout, and
points to a newly created canonical tree. It does not cover deleting the old
tree outright. If a rename should delete the old tree instead of stubbing it,
this playbook doesn't apply as written and the steps need to be adapted.

This playbook was written after renaming NGINXaaS for Google Cloud to F5
Application Delivery Service for Google Cloud. Use that rename as a worked
example if you need one.

## Before you start: decisions required

Nail these down before touching any files. Getting them wrong partway through
means redoing work.

- **New product name (full form)**: used at first mention on a page and in
  `f5-product` front matter.
- **New product name (short form)**: used at subsequent mentions on the same
  page, and in compound terms like "the F5 ADS Console."
- **Former product name**: the exact value to record in `f5-product-former`.
  Decide whether this should be the literal prior `f5-product` value, or a
  more general product-level name. Different renames in this repo have used
  both, inconsistently. Pick one and use it consistently within a single
  rename.
- **Old content path → new content path**: for example,
  `content/nginxaas/google` → `content/f5ads/google`.
- **File-level mapping**: confirm the old and new trees have the same files
  in the same relative structure. Flag any exceptions, such as a file that
  was renamed as part of the move (for example, `glossary.md` becoming
  `f5ads-glossary.md`). You'll need an explicit mapping for these, not a
  path-for-path copy.
- **Prose rules**: confirm the first-mention and subsequent-mention pattern,
  and how to handle standalone mentions of the old product name that aren't
  paired with a qualifier (for example, "NGINXaaS" alone versus "NGINXaaS for
  Google Cloud").
- **Compound terms**: list the UI element names and compound phrases that
  need consistent treatment, such as "<old name> Console" or "<old name>
  deployment." Decide the replacement for each before starting the prose
  pass, not during it.
- **Protected strings**: identify strings that must NOT change even though
  they contain the old product name. Typical examples: shell variable names,
  UI field names that haven't been renamed in the product itself, JSON keys,
  and file or URL slugs. Get sign-off on these before running any find-and-
  replace.
- **Reference document**: if a similar product's documentation has already
  been renamed, use it as the style reference for the copy edit pass. Read it
  in full before editing the new tree.

## Infrastructure already in place

The following was built during the NGINXaaS for Google Cloud rename and
should not need to be rebuilt for a subsequent rename. Confirm it's still
present and unmodified before assuming you can skip these steps.

- `layouts/shortcodes/renamed-notice.html`: renders the "this page has moved"
  callout. Reads `canonical`, `f5-product`, and `f5-product-former` from page
  front matter, and errors the build if any are missing, or if `canonical`
  doesn't resolve to a real page.
- `layouts/partials/meta.html`: local override of the theme partial. Emits
  `<link rel="canonical">` from a page's `canonical` front matter key, if
  present, falling back to Hugo's default `.Permalink` behavior otherwise.
- `layouts/_default/list.html`: local override of the theme's section list
  template. Renders `.Content` on section (`_index.md`) pages that carry
  `f5-product-former`, so the renamed-notice callout appears above the
  section's card grid. Without this override, Hugo's section template skips
  page body content entirely unless `f5-landing-page: true` is set, which
  means the notice silently doesn't render on section pages.

If a future rename needs different behavior from any of these three files,
treat that as a deliberate decision, not an oversight, and document why.

## Step 1: Branch and product name registration

1. Create a branch named `<product-code>/<verb>-<description>`, following
   `documentation/git-conventions.md`. Use an imperative verb
   (`migrate`, `rename`, `consolidate`), not a noun phrase.
2. Add the new product name to the Product names list in `AGENTS.md`.
   Use the list's existing values as a naming precedent; don't invent a new
   format.

## Step 2: Build the new canonical content tree

1. Copy the old content directory to the new path.
2. In every copied file, update:
   - Internal `{{< ref >}}` shortcode paths that point within the old tree,
     so they point at the new tree instead.
   - `url:` front matter, so it reflects the new path. This step isn't
     optional: if the copy keeps the old `url:` value, Hugo will see two
     pages claiming the same URL and fail to build, or silently pick one.
   - `titleUrl` attributes in card shortcodes.
   - `f5-product` front matter, to the new product name.
3. Add a self-referencing `canonical` front matter key to every file in the
   new tree. The value is the page's own `url:` value. This is what makes
   the new tree emit its own canonical tag instead of falling back to Hugo's
   default.
4. Update body prose throughout the new tree:
   - First mention of the product name on a page uses the full form.
   - Every subsequent mention on the same page uses the short form.
   - Standalone mentions of the old product name become the new product
     name, expanded per the compound-terms list you built in the decisions
     step.
   - Leave protected strings untouched.
   - Update link text that contains the old product name, to match.
   - Update any code block content that references the product name in a way
     visible to users, such as a dashboard display name or a UI label in a
     comment. Leave code that references actual identifiers, environment
     variables, or UI field names that have not themselves been renamed.
5. Fill in any front matter fields present on the reference document but
   missing on the page being edited, such as `description`, `f5-keywords`,
   `f5-summary`, and `f5-audience`.
6. If a reference document exists for a similar, already-renamed product,
   copy edit the new tree's overview page (and other key pages, as needed)
   to align structurally and stylistically with it. Follow the F5 Tech
   Writer Agent instructions and the style guide for this pass.

## Step 3: Update the legacy tree

Do this after the new tree exists and its URLs are final, since the legacy
tree's `canonical` values point at them.

1. Update `f5-product` on every file to the new product name.
2. Add `f5-product-former`, set to the former product name you decided on
   before starting.
3. Add `canonical`, pointing to the corresponding page in the new tree. Map
   old pages to new pages using the file mapping you built in the decisions
   step, not by assuming identical filenames throughout.
4. Insert `{{< renamed-notice >}}` as the first item in the page body,
   immediately after the closing front matter delimiter, with a blank line
   before and after it. This applies to every page in the legacy tree,
   including section `_index.md` pages, not just leaf content pages.

## Step 4: Update site-wide references

Search the repository for anything that links to or names the old product
outside its own content tree, and update it to point at the new tree. Common
locations:

- The homepage product card grid (`content/_index.md`).
- The product selector navigation data (`data/product-selector.yaml`).
- Any other page that cross-links to this product from outside its own
  content tree.

## Step 5: Verify

Run these checks before committing. Most can be scripted; none require a
running Hugo instance.

- Every `canonical` value in the legacy tree resolves to a real page that
  exists in the new tree.
- No page in the legacy tree has a `canonical` value pointing at itself.
- Every page in the new tree has `canonical` equal to its own `url:`.
- Every page in the legacy tree has all three front matter keys the
  `renamed-notice` shortcode requires: `canonical`, `f5-product`,
  `f5-product-former`.
- No leftover references to whatever front matter key the shortcode used to
  read, if this rename retires one (as happened when `f5-moved-to` was
  replaced with `canonical`).
- Front matter blocks in the new tree are unmodified by the prose edit pass;
  only the body should have changed.
- No doubled or malformed names in prose (for example, "F5 F5," or the old
  and new name concatenated).
- No unintended side effects from automated text substitution, such as an
  added or removed trailing newline on files that otherwise had no content
  change. Diff the working tree against the base commit and confirm every
  changed file has a change you intended.

Then, with a running Hugo instance (`make watch` or equivalent):

- Confirm the canonical tag renders correctly in `<head>` on both a new-tree
  page and a legacy-tree page.
- Confirm the renamed-notice callout renders on a legacy leaf page and on a
  legacy section (`_index.md`) page, and that the section's card grid still
  renders underneath it.
- Spot-check an unrelated, untouched section page elsewhere in the site to
  confirm the `list.html` override hasn't changed its rendering.

## Step 6: Commit

Group commits by logical unit of work rather than as one large commit, so
each can be reviewed and reverted independently. A typical sequence:

1. New canonical tree creation, including ref/URL updates and canonical
   front matter.
2. Body prose update in the new tree.
3. Legacy tree metadata and renamed-notice insertion.
4. Site-wide reference updates.
5. Any copy-edit pass done separately from the initial content creation.

Follow the commit message format in `documentation/git-conventions.md`.

## Deferred work and out-of-scope items

This playbook produces a working rename, but the following are commonly left
for follow-up and shouldn't be assumed done just because the steps above are
complete:

- **Includes and static assets.** Copying a content tree with `cp` does not
  copy `content/includes/<old-path>/` or `static/<old-path>/`. If the new
  tree's pages reference includes or images at the old path, either migrate
  those assets to a new path and repoint the references, or knowingly leave
  the new tree depending on the old tree's assets and document that
  dependency.
- **Legacy tree body prose.** This playbook updates the legacy tree's front
  matter and adds the renamed-notice callout, but does not require rewriting
  the legacy tree's body prose to reflect the new product name. Whether to
  do that is a separate decision: the legacy pages are stubs pointing
  elsewhere, and some teams consider prose changes there unnecessary work on
  content that's being phased out.
- **Changelog pages.** A shared changelog page covering multiple products or
  platforms may not need the renamed-notice treatment even if other pages in
  the same tree do. Confirm with a subject matter expert rather than
  applying the same treatment automatically.
- **Product-specific technical claims.** A copy edit pass may surface
  content differences between the old and new product (for example,
  different default behavior for an access control list, or a capability
  that doesn't carry over between platforms). Flag these for subject matter
  expert review. Don't resolve them by editorial judgment.
- **Cross-references from sibling products.** If another product's
  documentation links to or mentions the product being renamed (for example,
  a note like "this other product will move to the new naming over time"),
  search for and update those references once the rename lands. They're easy
  to miss because they live outside both the old and new content trees.
