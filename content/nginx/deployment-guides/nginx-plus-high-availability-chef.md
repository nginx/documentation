---
description: Step-by-step instructions for using Chef to automate the setup and maintenance
  of an active-passive high availability cluster of F5 NGINX Plus instances.
nd-docs: DOCS-461
draft: true
title: NGINX Plus High Availability Chef
toc: true
weight: 100
type:
- how-to
---

In a [previous blog post](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/), we went over how to deploy F5 NGINX Plus using Chef. In this blog post we will build on the Chef configs from the last blog post and use Chef to deploy a highly available (HA) NGINX Plus active/passive cluster.

This post assumes that you have already run through the previous post and have a working Chef installation. If not, please review at least the first two sections in the previous post, [Preparing Your Chef Environment](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/#prepare-environment) and [Downloading and Configuring the NGINX Cookbook](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/#download-cookbook).

_Editor – In addition to the previous blog on [Installing NGINX and NGINX Plus with Chef](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/), check out these related blogs about other DevOps automation tools with NGINX and NGINX Plus:_

_

- [Installing NGINX and NGINX Plus with Ansible](https://www.nginx.com/blog/installing-nginx-nginx-plus-ansible/)
- [Installing NGINX and NGINX Plus with Puppet](https://www.nginx.com/blog/installing-nginx-nginx-plus-puppet/)

_

To set up the highly available active/passive cluster, we’re using the [HA solution]({{< ref "nginx/admin-guide/high-availability/ha-keepalived.md" >}}) provided by NGINX, Inc., which is based on [keepalived](http://www.keepalived.org) and the [Virtual Router Redundancy Protocol](https://tools.ietf.org/html/rfc2338) (VRRP). The solution comes with an interactive script for creating the `keepalived` configuration file, but here we’re using Chef to automate the complete setup process.

## Modifying the NGINX Cookbook

First we set up the Chef files for installing of the NGINX Plus HA package ({{<nb>}}**nginx-ha-keepalived**{{</nb>}}) and creating the `keepalived` configuration file, **keepalive.conf**.

1. Modify the existing **plus_package** recipe to include package and configuration templates for the HA solution, by adding the following code to the bottom of the **plus_package.rb** file (per the instructions in the previous post, the file is in the {{<nb>}}**~/chef-zero/playground/cookbooks/nginx/recipes**{{</nb>}} directory).

    We are using the **eth1** interface on each NGINX host, which makes the code a bit more complicated than if we used **eth0**. In case you are using **eth0**, the relevant code appears near the top of the file, commented out.

    This code does three things:

    - It looks up the IP address of the **eth1** interface on the node where NGINX Plus is being installed, and assigns the value to the `origip` variable so it can be passed to the template.
    - It finds the other node in the HA pair by using Chef’s `search` function to iterate through all Chef nodes, then looks up the IP address for that node’s **eth1** interface and assigns the address to the `ha_pair_ips` variable.
    - It installs the {{<nb>}}**nginx-ha-keepalived**{{</nb>}} package, registers the `keepalived` service with Chef, and generates the **keepalived.conf** configuration file as a template, passing in the values of the `origip` and `ha_pair_ips` variables.

    ```nginx
     if node['nginx']['enable_ha_mode'] == 'true'

      ha_pair_ips = Array.new

      origip = "#{node[:network][:interfaces][:eth1][:addresses].detect{|k,v| v[:family] == 'inet'}.first}"

      # The code for finding the IP address of the eth0 interface

      # follows, commented out.

      #origip = "#{node[:ipaddress]}"

      #search(:node, "role:nginx_plus_ha") do |nodes|

      #  ha_pair_ips << nodes["ipaddress"]
      #end
      # This is a workaround for getting the IP address for the eth1
      # that VMs need
      search(:node, "role:nginx_plus_ha AND enable_ha_mode:true NOT name:#{node.name}") do |nodes|
        nodes["network"]["interfaces"]["eth1"]["addresses"].each_pair do |address,value|
          ha_pair_ips << address if value.has_key?("broadcast")
        end
      end

      package 'nginx-ha-keepalived' do
        action :install
      end

      service 'keepalived' do
        supports :status => true, :restart => true, :reload => true

        action   :enable

      end

      template '/etc/keepalived/keepalived.conf' do

        source 'nginx_plus_keepalived.conf.erb'

        owner 'root'

        group node['root_group']

        mode '0644'

        variables(

                  :myip => origip,

                  :ha_pair_ip => ha_pair_ips

                 )

        notifies :reload, 'service[keepalived]', :delayed

      end

    end
    ```

    You can download the [full recipe file](https://www.nginx.com/resource/conf/plus_package.rb-chef-recipe) from the NGINX, Inc. website.

2. Create the Chef template for creating **keepalived.conf**, by copying the following content to a new template file, **nginx_plus_keepalived.conf.erb**, in the {{<nb>}}**~/chef-zero/playground/cookbooks/nginx/templates/default**{{</nb>}} directory.

    We’re using a combination of variables and attributes to pass the necessary information to **keepalived.conf**. We’ll set the attributes in the next step. Here we set the two variables in the template file to the host IP addresses that were set with the `variables` directive in the **plus_package.rb** recipe (modified in the previous step):

    - `myip` – The primary IP address used by `keepalived` to communicate with the other highly available nodes. Corresponds to the `origip` variable in the **plus_package** recipe.
    - `ha_pair_ip` – An array containing the IP address of each host that has the **nginx_plus_ha** role in its run list; it is used to set the IP address of the peer (secondary) host in **keepalived.conf**. Corresponds to the `ha_pair_ips` array in the **plus_package** recipe.

    ```nginx
    vrrp_script chk_nginx_service {

         script "/usr/lib/keepalived/nginx-ha-check"

         interval 3

         weight 50

    }

    vrrp_instance VI_1 {

         interface eth1

         <% if node['nginx']['ha_primary'] == "true" %>

         state MASTER

         priority 151

         <% end %>

         <% if node['nginx']['ha_primary'] == "false" %>

         state BACKUP

         priority 150

         <% end %>

         virtual_router_id 51

         advert_int 1

         unicast_src_ip <%= @myip %>

         unicast_peer {

         <% @ha_pair_ip.each do |ip| %>

            <% if ip != @myip %>

               <%= ip %>

            <% end %>

         <% end %>

         }

         authentication {

              auth_type PASS

              auth_pass <%= node['nginx']['ha_keepalived_key'] %>

         }

         virtual_ipaddress {

              <%= node['nginx']['ha_vip'] %>

         }

         track_script {

              chk_nginx_service

         }

         notify "/usr/lib/keepalived/nginx-ha-notify"

    }

    ```

3. Create a role that sets attributes used in the recipe and template files created in the previous steps, by copying the following contents to a new role file, **nginx_plus_ha.rb** in the {{<nb>}}**~/chef-zero/playground/roles**{{</nb>}} directory.

    Four attributes need to be set, and in the role we set the following three:

    - `[nginx][ha_keepalived_key]` – The authentication key used by `keepalived` to encrypt communication with the other highly available nodes. Used in the template file.
    - `[nginx][ha_vip]` – The virtual IP address (VIP) advertised to clients as the address for NGINX Plus. The `keepalived` process assigns it to the primary NGINX Plus instance, and is is responsible for transferring it to the other instance in case of failover. Used in the template file.
    - `[nginx][enable_ha_mode]` – Triggers the HA section of the **plus_package** recipe when set to `true`. Used in the recipe file.

    We don’t set the fourth attribute, `ha_primary`, in the role because it must be set on a per‑host basis. It is used in the template file to set the `state` and `priority` values in **keepalived.conf**; those values in turn determine which NGINX Plus instance is marked as primary. If `ha_primary` is `true` for a node, it becomes the primary NGINX Plus instance in the HA pair; it becomes the secondary instance if the value is `false`.

    It is also possible to set the primary instance based on hostname matching instead of the `ha_primary` attribute, as we’ll cover in [Setting the Primary Node Based on Hostname Matching](#hostname-match). Also, you can set all four attributes on a per‑host basis, but I prefer to keep as many of the shared attributes in a single location as possible.

    The `run_list` directive in the role references the **nginx_plus** role we created in the [previous blog post](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/#download-cookbook), to save us from having to duplicate everything already defined in that role.

      ```nginx
      name "nginx_plus_ha"
      description "An example role to install NGINX Plus in an HA cluster"
      run_list "role[nginx_plus]"
      default_attributes "nginx" => { "enable_ha_mode" => "true",
                                      "ha_keepalived_key" => "a0cf476cf069ea3dfa8940ff6d6bd885",
                                      "ha_vip" => "10.100.10.50"
                                    }
      ```

## Preparing Nodes for Installation

Now we bootstrap the nodes and get them ready for the installation. Note that the longer outputs have been truncated, leaving only the most important output.

### Setting Up the First Node

1. Upload all of the files and bootstrap the first node:

    `root@chef-server:~# <span style="color:#66ff99; font-weight: bold;">cd chef-zero/playground/cookbooks/</span>

    root@chef-server:~/chef-zero/playground/cookbooks# <span style="color:#66ff99; font-weight: bold;">knife cookbook upload *</span>

    Uploading apache2      [1.0.0]

    Uploading apt          [2.8.2]

    ...

    Uploading nginx        [2.7.6]

    ...

    Uploading yum          [3.8.1]

    Uploading yum-epel     [0.6.3]

    Uploaded 18 cookbooks.

    root@chef-server:~/chef-zero/playground/cookbooks# <span style="color:#66ff99; font-weight: bold;">cd ../</span>

    root@chef-server:~/chef-zero/playground# <span style="color:#66ff99; font-weight: bold;">knife role from file roles/nginx_plus.rb</span>

    Updated Role nginx_plus!

    root@chef-server:~/chef-zero/playground# <span style="color:#66ff99; font-weight: bold;">knife role from file roles/nginx_plus_ha.rb</span>

    Updated Role nginx_plus_ha!

    root@chef-server:~/chef-zero/playground# <span style="color:#66ff99; font-weight: bold;">knife bootstrap -N chef-test-1 -x username --sudo 10.100.10.100</span>

    Creating new client for chef-test-1

    Creating new node for chef-test-1

    Connecting to 10.100.10.100

    username@10.100.10.100's password:

    10.100.10.100 knife sudo password:

    Enter your password:

    10.100.10.100

    10.100.10.100 -----> Existing Chef installation detected

    10.100.10.100 Starting first Chef Client run...

    10.100.10.100 Starting Chef Client, version 12.6.0

    10.100.10.100 resolving cookbooks for run list: []

    10.100.10.100 Synchronizing Cookbooks:

    10.100.10.100 Compiling Cookbooks...

    10.100.10.100 [2016-02-07T06:17:13-08:00] WARN: Node chef-test-1 has an empty run list.

    10.100.10.100 Converging 0 resources

    10.100.10.100

    10.100.10.100 Running handlers:

    10.100.10.100 Running handlers complete

    10.100.10.100 Chef Client finished, 0/0 resources updated in 01 seconds

    `

2. Create a local copy of the node definition file, which we’ll edit as appropriate for the node we bootstrapped in the previous step, {{<nb>}}**chef-test-1**{{</nb>}}:

    ```nginx
    root@chef-server:~/chef-zero/playground# knife node show chef-test-1 --format json > nodes/chef-test-1.json
    ```

3. Edit {{<nb>}}**chef-test-1.json**{{</nb>}} to have the following contents. In particular, we’re updating the run list and setting the `ha_primary` attribute, as required for the HA deployment.

    ```json
    {
      "name": "chef-test-1",
      "chef_environment": "_default",
      "run_list": [
                 "role[nginx_plus_ha]"
      ]
    ,
      "normal": {
        "nginx": {
          "ha_primary": "true"
        },
        "tags": [
        ]
      }
    }
    ```

4. Push the changed node definition to Chef:

    ```nginx
    root@chef-server:~/chef-zero/playground# knife node from file nodes/chef-test-1.json
    Updated Node chef-test-1!
    ```

5. Log in on the {{<nb>}}**chef-test-1**{{</nb>}} node and run the <span style="white-space: nowrap;">`chef-client`</span> command to get everything configured:

    ```text
    username@chef-test-1:~$ <span style="color:#66ff99; font-weight: bold;">sudo chef-client</span>

    Starting Chef Client, version 12.6.0

    resolving cookbooks for run list: ["nginx"]

    Synchronizing Cookbooks:

      - ohai (2.0.1)

      - build-essential (2.2.4)

      - nginx (2.7.6)

      - yum-epel (0.6.3)

      - apt (2.8.2)

      - bluepill (2.4.0)

      - runit (1.7.2)

      - rsyslog (2.1.0)

      - packagecloud (0.1.0)

      - yum (3.8.1)

    Compiling Cookbooks...

    ...

      * template[/etc/keepalived/keepalived.conf] action create

        - create new file /etc/keepalived/keepalived.conf

        - update content in file /etc/keepalived/keepalived.conf from none to 9816fd

        --- /etc/keepalived/keepalived.conf    2016-02-07 06:34:18.117013010 -0800

        +++ /etc/keepalived/.keepalived.conf20160207-1079-sjg8xn    2016-02-07 06:34:18.117013010 -0800

        @@ -1 +1,28 @@

        +vrrp_script chk_nginx_service {

        +    script "/usr/lib/keepalived/nginx-ha-check"

        +    interval 3

        +    weight 50

        +}

        +

        +vrrp_instance VI_1 {

        +    interface eth1

        +    state MASTER

        +    priority 151

        +    virtual_router_id 51

        +    advert_int 1

        +    unicast_src_ip 10.100.10.100

        +    unicast_peer {

        +    }

        +    authentication {

        +        auth_type PASS

        +        auth_pass a0cf476cf069ea3dfa8940ff6d6bd885

        +    }

        +    virtual_ipaddress {

        +        10.100.10.50

        +    }

        +    track_script {

        +        chk_nginx_service

        +    }

        +    notify "/usr/lib/keepalived/nginx-ha-notify"

        +}

        - change mode from '' to '0644'

        - change owner from '' to 'root'

        - change group from '' to 'root'

    Recipe: nginx::default

      * service[nginx] action start (up to date)

      * service[nginx] action reload

        - reload service service[nginx]

    Recipe: nginx::plus_package

      * service[keepalived] action reload (up to date)

    Running handlers:

    Running handlers complete

    Chef Client finished, 18/50 resources updated in 07 seconds

    ```

If we look at **keepalived.conf** at this point, we see the template hasn’t set any values in the `unicast_peer` section, because we’ve registered just this one node with Chef. The following command shows that the VIP specified in the role file, 10.100.10.50, is assigned to **eth1** on this node, making it the primary HA node:

    username@chef-test-1:~$ ip addr show eth1
    3: eth1:  mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 08:00:27:c8:66:ee brd ff:ff:ff:ff:ff:ff
        inet 10.100.10.100/24 brd 10.100.10.255 scope global eth1
           valid_lft forever preferred_lft forever
        inet 10.100.10.50/32 scope global eth1
           valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fec8:66ee/64 scope link
           valid_lft forever preferred_lft forever

### Setting Up the Second Node

Now, let’s get the second node bootstrapped and make sure all of the values are being propagated properly. We know from the first node that the run list works as expected, so we can combine some steps and set the run list and the `ha_primary` attribute directly with the <span style="white-space: nowrap;">`knife` `bootstrap`</span> command, which we run on the Chef server.

`root@chef-server:~/chef-zero/playground# <span style="color:#66ff99; font-weight: bold;">knife bootstrap -N chef-test-2 -x username --json-attributes "{\"nginx\": {\"ha_primary\": \"false\"}}" --sudo --run-list "role[nginx_plus_ha]" 10.100.10.102</span>

Creating new client for chef-test-2

Creating new node for chef-test-2

Connecting to 10.100.10.102

username@10.100.10.102's password:

10.100.10.102 sudo: unable to resolve host chef-test

10.100.10.102 knife sudo password:

Enter your password:

10.100.10.102

10.100.10.102 -----> Existing Chef installation detected

10.100.10.102 Starting first Chef Client run...

10.100.10.102 Starting Chef Client, version 12.6.0

10.100.10.102 resolving cookbooks for run list: ["nginx"]

10.100.10.102 Synchronizing Cookbooks:

10.100.10.102   - bluepill (2.4.0)

10.100.10.102   - apt (2.8.2)

10.100.10.102   - build-essential (2.2.4)

10.100.10.102   - ohai (2.0.1)

10.100.10.102   - nginx (2.7.6)

10.100.10.102   - runit (1.7.2)

10.100.10.102   - yum-epel (0.6.3)

10.100.10.102   - rsyslog (2.1.0)

10.100.10.102   - packagecloud (0.1.0)

10.100.10.102   - yum (3.8.1)

10.100.10.102 Compiling Cookbooks...

...

10.100.10.102   * service[keepalived] action enable (up to date)

10.100.10.102   * template[/etc/keepalived/keepalived.conf] action create

10.100.10.102     - create new file /etc/keepalived/keepalived.conf

10.100.10.102     - update content in file /etc/keepalived/keepalived.conf from none to a9363c

10.100.10.102     --- /etc/keepalived/keepalived.conf    2016-02-07 06:45:10.529976825 -0800

10.100.10.102     +++ /etc/keepalived/.keepalived.conf20160207-11317-1env6hu    2016-02-07 06:45:10.529976825 -0800

10.100.10.102     @@ -1 +1,29 @@

10.100.10.102     +vrrp_script chk_nginx_service {

10.100.10.102     +    script "/usr/lib/keepalived/nginx-ha-check"

10.100.10.102     +    interval 3

10.100.10.102     +    weight 50

10.100.10.102     +}

10.100.10.102     +

10.100.10.102     +vrrp_instance VI_1 {

10.100.10.102     +    interface eth1

10.100.10.102     +    state BACKUP

10.100.10.102     +    priority 150

10.100.10.102     +    virtual_router_id 51

10.100.10.102     +    advert_int 1

10.100.10.102     +    unicast_src_ip 10.100.10.102

10.100.10.102     +    unicast_peer {

10.100.10.102     +          10.100.10.100

10.100.10.102     +    }

10.100.10.102     +    authentication {

10.100.10.102     +        auth_type PASS

10.100.10.102     +        auth_pass a0cf476cf069ea3dfa8940ff6d6bd885

10.100.10.102     +    }

10.100.10.102     +    virtual_ipaddress {

10.100.10.102     +        10.100.10.50

10.100.10.102     +    }

10.100.10.102     +    track_script {

10.100.10.102     +        chk_nginx_service

10.100.10.102     +    }

10.100.10.102     +    notify "/usr/lib/keepalived/nginx-ha-notify"

10.100.10.102     +}

10.100.10.102     - change mode from '' to '0644'

10.100.10.102     - change owner from '' to 'root'

10.100.10.102     - change group from '' to 'root'

10.100.10.102 Recipe: nginx::default

10.100.10.102   * service[nginx] action start (up to date)

10.100.10.102   * service[nginx] action reload

10.100.10.102     - reload service service[nginx]

10.100.10.102 Recipe: nginx::plus_package

10.100.10.102   * service[keepalived] action reload

10.100.10.102     - reload service service[keepalived]

10.100.10.102

10.100.10.102 Running handlers:

10.100.10.102 Running handlers complete

10.100.10.102 Chef Client finished, 18/50 resources updated in 10 seconds`

If we look at **keepalived.conf** at this point, we see that there is a peer set in the `unicast_peer` section. But the following command shows that {{<nb>}}**chef-test-2**{{</nb>}}, which we intend to be the secondary node, is also assigned the VIP (10.100.10.50). This is because we haven’t yet updated the Chef configuration on {{<nb>}}**chef-test-1**{{</nb>}} to make its `keepalived` aware of the secondary node.

    username@chef-test-2:~$ ip addr show eth1
    3: eth1:  mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 08:00:27:6d:d9:64 brd ff:ff:ff:ff:ff:ff
        inet 10.100.10.102/24 brd 10.100.10.255 scope global eth1
           valid_lft forever preferred_lft forever
        inet 10.100.10.50/32 scope global eth1
           valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fe6d:d964/64 scope link
           valid_lft forever preferred_lft forever

### Synchronizing the Nodes

To make `keepalived` on {{<nb>}}**chef-test-1**{{</nb>}} aware of {{<nb>}}**chef-test-2**{{</nb>}} and its IP address, we rerun the <span style="white-space: nowrap;">`chef-client`</span> command on {{<nb>}}**chef-test-1**{{</nb>}}:

```text
username@chef-test-1:~$ <span style="color:#66ff99; font-weight: bold;">sudo chef-client</span>

Starting Chef Client, version 12.6.0

resolving cookbooks for run list: ["nginx"]

Synchronizing Cookbooks:

- ohai (2.0.1)

- build-essential (2.2.4)

- nginx (2.7.6)

- yum-epel (0.6.3)

- apt (2.8.2)

- bluepill (2.4.0)

- runit (1.7.2)

- rsyslog (2.1.0)

- packagecloud (0.1.0)

- yum (3.8.1)

Compiling Cookbooks...

...

username@chef-test-1:~$ <span style="color:#66ff99; font-weight: bold;">sudo chef-client</span>

Starting Chef Client, version 12.6.0

resolving cookbooks for run list: ["nginx"]

Synchronizing Cookbooks:

  - ohai (2.0.1)

  - build-essential (2.2.4)

  - nginx (2.7.6)

  - yum-epel (0.6.3)

  - apt (2.8.2)

  - bluepill (2.4.0)

  - runit (1.7.2)

  - rsyslog (2.1.0)

  - packagecloud (0.1.0)

  - yum (3.8.1)

Compiling Cookbooks...

...

  * template[/etc/keepalived/keepalived.conf] action create

    - update content in file /etc/keepalived/keepalived.conf from 9816fd to af7ce0

    --- /etc/keepalived/keepalived.conf    2016-02-07 06:34:18.117013010 -0800

    +++ /etc/keepalived/.keepalived.conf20160207-3369-73qgm3    2016-02-07 06:53:04.593013010 -0800

    @@ -12,6 +12,7 @@

         advert_int 1

         unicast_src_ip 10.100.10.100

         unicast_peer {

    +          10.100.10.102

         }

         authentication {

             auth_type PASS

Recipe: nginx::default

  * service[nginx] action start (up to date)

  * service[nginx] action reload

    - reload service service[nginx]

Recipe: nginx::plus_package

  * service[keepalived] action reload (up to date)

Running handlers:

Running handlers complete

Chef Client finished, 2/47 resources updated in 05 seconds

```

We see that {{<nb>}}**chef-test-1**{{</nb>}} is still assigned the VIP:

  ```nginx
  username@chef-test-1:~$ ip addr show eth1
  3: eth1:  mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
      link/ether 08:00:27:c8:66:ee brd ff:ff:ff:ff:ff:ff
      inet 10.100.10.100/24 brd 10.100.10.255 scope global eth1
         valid_lft forever preferred_lft forever
      inet 10.100.10.50/32 scope global eth1
         valid_lft forever preferred_lft forever
      inet6 fe80::a00:27ff:fec8:66ee/64 scope link
         valid_lft forever preferred_lft forever
  ```

And {{<nb>}}**chef-test-2**{{</nb>}}, as the secondary node, is now assigned only its physical IP address:

  ```nginx
  username@chef-test-2:~$ ip addr show eth1
  3: eth1:  mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
      link/ether 08:00:27:6d:d9:64 brd ff:ff:ff:ff:ff:ff
      inet 10.100.10.102/24 brd 10.100.10.255 scope global eth1
         valid_lft forever preferred_lft forever
      inet6 fe80::a00:27ff:fe6d:d964/64 scope link
         valid_lft forever preferred_lft forever
  ```

If you want to test the `keepalived` failover at this point, stop the NGINX Plus service on the primary node.

## Setting the Primary Node Based on Hostname Matching

You can automate your HA setup even further if you indicate a host’s usual role (primary or secondary) in its hostname. Then, instead of setting the `ha_primary` attribute in the node definition file (as in Step 3 of [Setting Up the First Node](#first-node)), you can have Chef set the attribute based on the hostname. This takes advantage of Chef’s flexibility in allowing you to set variables inside of recipes, which you do by using slightly modified Ruby code to inspect any of the attributes and membership information the Chef server is aware of. One example is Step 1 of [Modifying the NGINX Cookbook](#modify-cookbook), where we added code to the **plus_package** recipe to look up **eth1**‘s IP address.

Here we extend that code further by adding an `if` statement that inspects the hostname and sets `ha_primary` appropriately. It relies on the presence of the word **primary** or **standby** in the hostname. Put it after the code in **plus_package.rb** that assigns a value to the **origip** variable (the complete code appears in Step 1 of [Modifying the NGINX Cookbook](#modify-cookbook)):

    ```nginx
    # ...
    origip = "#{node[:network][:interfaces][:eth1][:addresses].detect{|k,v| v[:family] == 'inet'}.first}"
    search(:node, "role:nginx_plus_ha AND enable_ha_mode:#{node.nginx.enable_ha_mode} NOT name:#{node.name}") do |nodes|
      nodes["network"]["interfaces"]["eth1"]["addresses"].each_pair do |address,value|
        ha_pair_ips << address if value.has_key?("broadcast")
      end
    end

    if node['name'].include? "primary"
      ha_primary = "true"
    elsif    node['name'].include? "standby"
      ha_primary = "false"
    end
    package 'nginx-ha-keepalived' do
      action :install
    end
    # ...
    ```

Of course you can match on terms in the hostname other than **primary** and **standby**, such as **lb1** and **lb2**. You can also put this logic in the **nginx_plus_keepalived.conf.erb** template file instead, but that is less portable.

## Summary

We have covered some more complex examples of what is possible using the Chef `search` function, as well as Ruby code in the cookbook recipes. It is possible to apply these techniques in many ways, using attributes and the `search` function to build very portable and flexible Chef configurations. We will cover some of these concepts in future blog posts.

_Editor – For more about using DevOps automation tools with NGINX and NGINX Plus, check out these related blogs:_

_

- [Installing NGINX and NGINX Plus with Ansible](https://www.nginx.com/blog/installing-nginx-nginx-plus-ansible/)
- [Installing NGINX and NGINX Plus with Chef](https://www.nginx.com/blog/installing-nginx-nginx-plus-chef/)
- [Installing NGINX and NGINX Plus with Puppet](https://www.nginx.com/blog/installing-nginx-nginx-plus-puppet/)

_

Try out the NGINX Plus HA solution with Chef for yourself – start your <span style="white-space: nowrap;">[free 30-day trial](https://www.nginx.com/free-trial-request/)</span> today or [contact us](https://www.nginx.com/contact-sales/) for a live demo.
