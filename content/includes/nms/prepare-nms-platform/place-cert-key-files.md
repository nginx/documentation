#
{{<tip>}}If you [installed NGINX Plus](#install-nginx) for the NGINX Management Suite host, you may have completed these steps already, in which case you can skip to the [Add the NGINX Management Suite Repo to Yum or Apt](#add-yum-apt) section.{{</tip>}}

To access the NGINX Management Suite repo, you'll need to add appropriate cert and key files to the `etc/ssl/nginx` folder.

1. Create the `/etc/ssl/nginx/` directory:

   ``` bash
   sudo mkdir -p /etc/ssl/nginx
   ```

2. Log in to [MyF5](https://account.f5.com/myf5), or follow the link in the trial activation email, and download the NMS repo `.crt` and `.key` files:

   - `nginx-mgmt-suite-trial.key`
   - `nginx-mgmt-suite-trial.crt`

   The filenames might be different, depending on your subscription type.

3. Rename and move the NMS `.crt` and `.key` files:

   ```bash
   sudo mv nginx-mgmt-suite-trial.key /etc/ssl/nginx/nginx-repo.key
   sudo mv nginx-mgmt-suite-trial.crt /etc/ssl/nginx/nginx-repo.crt
   ```
