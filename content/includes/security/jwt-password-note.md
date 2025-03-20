---
docs: 
---

{{<call-out "important" "Protect sensitive data" "fas fa-shield-alt" >}}
To protect your system and data, follow these security practices:
 
1. **JWTs:** Treat JSON Web Tokens (JWTs) as sensitive data. Store them securely and delete them after use to prevent unauthorized access.
 
2. **Shell history:** Commands with JWTs or passwords are saved in plain text in your shell history. After running such commands, clear the history to protect credentials. For example:
   - Edit your shell history file (such as ~/.bash_history or ~/.zsh_history) to remove specific commands.
   - Use `history -c` to clear all shell history in bash or zsh.
{{</call-out>}}
