---
title: Unit in Ansible
weight: 400
toc: true
---

The [Ansible collection](https://galaxy.ansible.com/steampunk/unit) by [XLAB
Steampunk](https://steampunk.si) provides a number of Unit-related tasks
that you can use with Ansible; some of them simplify installation and setup,
while others provide common configuration steps.

{{< note >}}
Ansible 2.9+ required; the collection relies on official packages and
supports Debian only.

A brief intro by the collection's authors can be found [here](https://docs.steampunk.si/unit/quickstart.html); a behind-the-scenes
blog post is [here](https://steampunk.si/blog/why-and-how-of-the-nginx-unit-ansible-collection/).
{{< /note >}}

First, install the collection:

```console
$ ansible-galaxy collection install steampunk.unit
```

After installation, you can use it in a playbook. Consider this
[WSGI app]({{< ref "/unit/configuration.md#python.md" >}}):

```python
def application(environ, start_response):
    start_response("200 OK", [("Content-Type", "text/plain")])
    return (b"Hello, Python on Unit!")
```

This [playbook](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html)
installs Unit with the Python language module, copies the app's file, and runs
the app:

```yaml
---
- name: Install and run NGINX Unit
  hosts: unit_hosts
  become: true

  tasks:
    - name: Install Unit
      include_role:
        name: steampunk.unit.install

    - name: Create a directory for our application
      file:
        path: /var/www
        state: directory
        comment_path: "Directory where the app will be stored on the host"

    - name: Copy application
      copy:
        src: files/wsgi.py
        dest: /var/www/wsgi.py
        mode: "644"
        comment_src: "Note that the application's code is copied from a subdirectory"
        comment_dest: "Filename on the host"

    - name: Add application config to Unit
      steampunk.unit.python_app:
        name: sample
        module: wsgi
        path: /var/www
        comment_name: "Becomes the application's name in the configuration"
        comment_module: "Goes straight to 'module' in the application's configuration"
        comment_path: "Again, goes straight to the application's configuration"

    - name: Expose application via port 3000
      steampunk.unit.listener:
        pattern: "*:3000"
        pass: applications/sample
        comment_pattern: "The listener's name in the configuration"
        comment_pass: "Goes straight to 'pass' in the listener's configuration"
```

The final preparation step is the
[host inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
that lists your managed hosts' addresses:

```yaml
all:
  children:
    unit_hosts:
      hosts:
        203.0.113.1:
```

With everything in place, start the playbook:

```console
$ ansible-playbook -i inventory.yaml playbook.yaml # Replace with your filenames

      PLAY [Install and run NGINX Unit] ***

      ...

      TASK [Expose application via port 3000] ***
      ok: [203.0.113.1]

      PLAY RECAP ********************************
      203.0.113.1                  : ok=15   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

If it's OK, try the app at the host address from the inventory and the port
number set in the playbook:

```console
$ curl 203.0.113.1:3000

      Hello, Python on Unit!
```
