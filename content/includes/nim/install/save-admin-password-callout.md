---
nd-files:
  - content/nim/install/vm-bare-metal/install-with-bash-script-online.md
  - content/nim/install/vm-bare-metal/install-with-bash-script-offline.md
---

{{< call-out "warning" "Save the admin password" >}}
After installation completes, the script generates an admin password. It may take a few minutes to appear:

```text
Regenerated Admin password: <encrypted password>
```

Save this password. You’ll need it to sign in to the NGINX Instance Manager web interface.

To change the password, follow the steps in the [Set user passwords]({{< ref "/nim/authentication/set-up-basic-authentication.md#set-basic-auth-passwords" >}}) section of the Basic Authentication guide.
{{< /call-out >}}