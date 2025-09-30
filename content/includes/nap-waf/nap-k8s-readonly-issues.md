**Permission denied errors**

If you encounter file permission issues, verify that the paths requiring write access are correctly configured as writable volumes in the pod manifest.
 
**F5 WAF for NGINX initialization errors**:  

Check the NGINX and NGINX App Protect Logs to ensure that App Protect can write to necessary files like logs and temporary directories.

For general issues, read the [Troubleshooting]({{< ref "/nap-waf/v5/troubleshooting-guide/troubleshooting.md" >}}) topic.