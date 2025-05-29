Run the following command (as root) so Unit can access the application
directory (If the application uses several directories, run the command for
each one):

```console
# chown -R unit:unit /path/to/app/  # User and group that Unit's router runs as by default
```


{{< note >}}
The **unit:unit** user-group pair is available only with
[official packages]({{< relref "/unit/installation.md#installation-precomp-pkgs" >}})
, Docker [images]({{< relref "/unit/installation.md#installation-docker" >}}),
and some [third-party repos]({{< relref "/unit/installation.md#installation-community-repos" >}}). Otherwise, account names may differ; run the `ps aux | grep unitd` command to be sure.
{{< /note >}}

For further details, including permissions, see the
[security checklist]({{< relref "/unit/howto/security.md#secutiry-apps" >}}).
