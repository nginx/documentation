Assuming the JSON above was added to
`config.json`. Run the following command as root:

```console
# curl -X PUT --data-binary @config.json --unix-socket \
   /path/to/control.unit.sock \  # Path to Unit's control socket in your installation
   http://localhost/config/      # Path to the config section in Unit's control API
```

{{< note >}}
The [control socket]({{< relref "/unit/installation.md#configuration-socket" >}}) path may vary; run
`unitd -h` or see
[Startup and shutdown]({{< relref "/unit/howto/source.md#source-startup" >}}) for details.
{{< /note >}}
