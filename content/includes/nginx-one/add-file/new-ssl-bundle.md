---
---

First you can select the toggle to allow NGINX One Console to manage the new certificate or bundle.

In the screen that appears, you can add a certificate name. If you don't add a name, NGINX One Console will add a name for you, based on the expiration date for the certificate.   
You can add certificates in the following formats:

- **SSL Certificate and Key**
- **CA Certificate Bundle**

In each case, you can upload files directly, or enter the content of the certificates in a text box. Once you upload these certificates, you may need to scroll down. You'll see:

- **Certificate Details**, with the Subject Name, start and end dates. 
- **Key Details**, with the encryption key size and algorithm, such as RSA

Select **Save and Continue**. You're taken to another screen where you can specify the locations for your files, which may be:

- **Certificate File Path**
  - Enter the full path to your certificate, such as
    - /etc/nginx/server.crt
    - /etc/nginx/server.pem

- **Key File Path**
  - Enter the full path to your certificate key, such as
    - /etc/nginx/server.key

With the **Add Item** button, you can add the file to additional directories.

When complete, select **Add** to include the certificate files that you've configured to desired directories.
