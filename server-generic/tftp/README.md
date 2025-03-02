Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

Other installation instructions
-------------------------------

Global Configuration
--------------------

SMTP server: {{ smtp_server }}
Default user e-mail suffix: {{ email_suffix }}
User Name: {{ smtp_user }}
Password: ******************
SSL: true
SMTP Port: {{ smtp_port }}
Reply-To Address: {{ smtp_user }}

Misc
----

Step 4: Install Nginx (optional)

In order to facilitate visitors' access to Jenkins, you can setup an Nginx reverse proxy for Jenkins, so visitors will no longer need to key in the port number 8080 when accessing your Jenkins application.

Install Nginx using YUM:

sudo yum install nginx

Modify the configuration of Nginx:

sudo vi /etc/nginx/nginx.conf

Find the two lines below:

location / {
}

Insert the six lines below into the { } segment:

proxy_pass http://127.0.0.1:8080;
proxy_redirect off;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;

The final result should be:

location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_redirect off;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

Save and quit:

:wq

Start and enable the Nginx service:

sudo systemctl start nginx.service
sudo systemctl enable nginx.service

Allow traffic on port 80:

sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --reload

Finally, visit the following address from your web browser to confirm your installation:

http://<your-Vultr-server-IP>
