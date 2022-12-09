Dell OS10/ceos Layer3 Cluster Automation
===============================================

Ansible ENV:
************
* Ansible CFG: ~/sc_lab/ansible.cfg
* DEFAULT_VAULT_PASSWORD_FILE: ~/.vault_pass
* DEFAULT_HOST_LIST: ~/sc_lab/inventory
* DEFAULT_LOG_PATH: ~/LOGS/ansible.log
* BUILD_DIR: ~/cfggen/

Ansible Config:
************
* DEFAULT_CALLBACK_WHITELIST(/home/lab/sc_lab/ansible.cfg) = ['profile_tasks']
* DEFAULT_HOST_LIST(/home/lab/sc_lab/ansible.cfg) = ['/home/lab/sc_lab/inventory']
* DEFAULT_LOG_PATH(/home/lab/sc_lab/ansible.cfg) = /home/lab/LOGS/ansible.log
* DEFAULT_ROLES_PATH(/home/lab/sc_lab/ansible.cfg) = ['/home/skg/dev/scaleio/roles']
* DEFAULT_VAULT_PASSWORD_FILE(/home/lab/sc_lab/ansible.cfg) = /home/lab/.vault_pass
* HOST_KEY_CHECKING(/home/lab/sc_lab/ansible.cfg) = False
* INTERPRETER_PYTHON(/home/lab/sc_lab/ansible.cfg) = auto
* PERSISTENT_CONNECT_TIMEOUT(/home/lab/sc_lab/ansible.cfg) = 60

Version
*******
* Ansible           2.10
* Ansible-engine    2.10
* ansible.netcommon 1.4.1
* Python            3.8
* Jinja2            2.10.1

Inventory:
**********
inventory/lab.yaml

* Inventory file contains the following information:
    the management IP mapping for all the device host, {{ ansible-host }}
    the seq number of each switch, {{ seq }}
    the groups
* Devices are also grouped with respect to the position and the zone.

Variables:
**********
* Ansible sources variables from different folders based on the hostname, group name of the device for which the playbook is scheduled.
* Common variables that can be used in a group of devices are defined under group_vars directory with the same name as group name defined in the inventory file. For instance, leaf.yaml contains the variable definition which are common for both cluster leaf switches and border leaf switches. Ex. Uplink interface numbers to SPINE. 
* Device specific variables are defined under host_vars directory with the same name as device hostname defined in the inventory file.
* For sw1001a, following variables will be sourced based on the inventory file grouping (if the file is available).
    * host_vars/<host.yaml>: define the host specific variable inputs
    * group_vars/rack01.yaml: define the rack common parameters, like vlt-mac etc
    * group_vars/leaf.yaml: define the leaf common variables, like uplink, vlan allocation etc
    * group_vars/lab.yaml: define the entire lab common variables, lik IP/ASN allocation etc
    * group_vars/all.yaml: define the most common variables, lik Ansible playbook credential etc.

Playbooks:
**********
* underlay.yaml, to generate and provision the underlay configuration
* cleanup_underlay.yaml, to remove the underlay configuration from the cluster
* vxlan.yaml, to generate and provision the static vxlan onto cluster

Syntax:
*******
ansible-playbook -i inventory/<inventory file> <playbook>  <options, -t [tags:cfggen, none for complete tasks]>

Example:
### Clear up the underlay configuratio on Leaf
* ansible-playbook -i inventory/lab.yaml cleanup_underlay.yaml -t nounderlay
### Build Spine switch (Intf, BGP) with ceos
* ansible-playbook -i inventory/lab.yaml build_spine.yaml
### Build Leaf switch (Intf, BGP) with OS10EE
* ansible-playbook -i inventory/lab.yaml build_leaf.yaml
### Reload Switch Playbook
* ansible-playbook -i inventory/lab.yaml switch_reload.yaml
### Build VxLan Overlay on Leaf, OS10EE
* ansible-playbook -i inventory/lab.yaml vxlan.yaml

Vault:
*******
ansible-vault encrypt_string 'foobar(password)' --name 'vault_os10_pass'

Vault Key Map:

|Function	|Username	|vault_key
|Spine Switch (ceos)	|admin	|vault_ceos_password
|Leaf Switch (OS10)	|admin	|vault_os10_password
|ESXi Host	|root	|vault_esxi_password
|VMs	|lab	|vault_lab_password
|ZTP VM	|linuxadmin	|vault_linux_password

> README.md
