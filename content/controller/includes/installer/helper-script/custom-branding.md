The NGINX Controller logo in the user interface is replaceable with a custom logo. The requirements being:

- The logo file is in SVG format.
- The logo is square in shape.

{{< note >}} The above steps modify the logo in the top left corner and in the menu, not the favicon. {{< /note >}}

Follow the steps below to replace the logo:

1. Connect to the NGINX Controller host using 'ssh'.
1. Transfer the logo file to NGINX Controller using one of the following methods:
    1. Method 1: Download the file using curl after connecting to the host using the command `curl https://example.com/custom-logo.svg`.
    1. Method 2: Upload the logo to the host using SCP: `scp /local/path/custom-logo.svg user@controller-host:/remote/path`.
    1. Method 3: Copy/Paste the logo file.
        1. Copy the logo file to the clipboard before connecting to the host.
        1. After connecting to the host, paste the file.
1. Run `helper.sh setlogo <filename>` (<filename> is the name of the SVG file).
1. Wait for approximately five minutes for the cache to clear and the logo to appear in the user interface.
1. Re-run the `setlogo` command on each NGINX Controller node. This has to be done after an upgrade or reinstallation.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-341 -->