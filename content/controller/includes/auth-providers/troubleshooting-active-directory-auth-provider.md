### Active Directory User or Group Isn't Found

If NGINX Controller doesn't find Active Directory users or groups as expected, you can use `ldapsearch` or a similar tool to search your LDAP directory to verify the users and groups exist.

**Examples**:

- To query for an Active Directory user named "Jane Doe" using `ldapsearch`, run the following command:

  ```bash
  ldapsearch -ZZ -W -H ldap://ldap.example.com \
             -b "DC=ldap,DC=example,DC=com" \
             -D "uid=search-user,ou=People,dc=example,dc=com" \
             "(&(objectClass=person)(CN=Jane Doe))"
  ```

- To query for an Active Directory group -- called "devops" in the example below -- using `ldapsearch`, you would run the following command:

  ```bash
  ldapsearch -ZZ -W -H ldap://ldap.example.com \
             -b "DC=ldap,DC=example,DC=com" \
             -D "uid=search-user,ou=People,dc=example,dc=com" \
             "(&(objectClass=group)(CN=devops))"
  ```

{{< see-also >}}
For an overview of the `ldapsearch` command and command options, see the [ldapsearch man page](https://linux.die.net/man/1/ldapsearch).
{{< /see-also >}}

### How to Immediately Refresh the Active Directory Information

When setting up your Active Directory provider, you specified a poll interval. This is the time, in seconds, to wait between refreshes of the Active Directory information, including the AD Groups list. The minimum is 300 seconds (5 minutes); the default is 3600 seconds (1 hour).

Suppose there's an emergency or pressing circumstance for which you need to update the Active Directory information sooner than the polling interval. Maybe there was a company reorganization, and all the mappings were changed. Or maybe there was an error in the Active Directory configuration, and a group was given the wrong permissions. In either case, you can [delete the Active Directory provider](#view-edit-or-delete-an-active-directory-authentication-provider) in NGINX Controller and then add it back. The changes made on the Active Directory server will be reflected on NGINX Controller once the Active Directory provider is re-added.

{{< warning >}}
Deleting an authentication provider is disruptive. Once the authentication provider is removed, authenticated users will lose access to NGINX Controller until the authentication provider is added again.
{{< /warning >}}

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-730 -->