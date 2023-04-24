User account passwords for NGINX Controller must meet the following requirements:

- Must be between 8–64 characters. Special characters are allowed.
- Must contain at least 1 letter.
- Must contain at least 1 number.
- New passwords must be different from the last password.

Dictionary words, mangled dictionary words like `p4ssword`, or systematic passwords like `1234567a` are not allowed.

If your organization requires a different password policy, we recommend that you [configure external authentication using Active Directory]({{< relref "/platform/access-management/manage-active-directory-auth-provider.md" >}}) for all users except the primary NGINX Controller admin user.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-767 -->
