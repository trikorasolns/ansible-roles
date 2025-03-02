---
title: Ansible Documentation
subtitle:
tags: [ansible, playbooks]
author: Trikora Solutions SL
---

# Init

ping ad-hoc

```bash
$ ansible all -m ping
```

ping ad-hoc limitando hosts

```bash
$ ansible all -m ping --limit "host01"
```

## Init ansible

```bash
$ ansible-playbook -i inventory/ playbooks/1st_run_me.yml --limit "ocpdmaster01,ocpdnode01"
```

# Ad-hoc

Restart service.

```bash
$ ansible scm01 --module-name=systemd --args="name=gitlab-runsvdir state=restarted" -b -K
```

# oVirt

Start vms.

```bash
$ ansible-playbook -i inventory/hosts  playbooks/ovirt_he_vm_start.yml  --extra-vars "vm_tags=production"
```


# WOL

Playbook to start baremetal hosts.

```bash
$ ansible-playbook playbooks/wol.yml -e wol_delegate=www1
```

Execute adhoc WOL.

```bash
$ ansible -m wakeonlan localhost -a mac=00:00:00:00:00:00;broadcast=192.168.199.255
```

# Docker

```bash
ansible-playbook -i inventory/hosts playbooks/containers.yml --limit vmsd09 --ask-become-pass
```

Host variables:
 * `docker_ports`: firewall ports to open.
