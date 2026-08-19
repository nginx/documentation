---
f5-product: Miscellaneous
f5-files:
- content/nginx-one-console/connect-instances/connect-nginx-plus-container-images-to-nginx-one.md
- content/nginx/admin-guide/installing-nginx/installing-nginx-docker.md
- content/nim/fundamentals/api-overview.md
---

{{<call-out class="important" title="Protect sensitive data" icon="shield" >}}
To protect your system and data, follow these security practices:

1. **JWTs:** Treat JSON Web Tokens (JWTs) as sensitive data. Store them securely and delete them after use to prevent unauthorized access.

2. **Shell history:** Commands with JWTs or passwords are saved in plain text in your shell history. After running such commands, clear the history to protect credentials. For example:
   - Edit your shell history file (such as ~/.bash_history or ~/.zsh_history) to remove specific commands.
   - Use `history -c` to clear all shell history in bash or zsh.
{{</call-out>}}
