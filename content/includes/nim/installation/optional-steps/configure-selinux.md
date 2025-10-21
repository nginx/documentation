---
files:
- content/nim/deploy/vm-bare-metal/install-nim-manual.md
- content/nim/deploy/vm-bare-metal/install.md
- content/nim/disconnected/offline-install-guide-manual.md
- content/nim/disconnected/offline-install-guide.md
---

SELinux helps secure your deployment by enforcing mandatory access control policies.

If you use SELinux, follow the steps in the [Configure SELinux]({{< ref "/nim/system-configuration/configure-selinux.md" >}}) guide to restore SELinux contexts (`restorecon`) for the files and directories related to NGINX Instance Manager.
