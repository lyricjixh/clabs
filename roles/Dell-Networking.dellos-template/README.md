TEMPLATE role
==============

The dellos-template role provides access to structured data from show commands in devices running Dell EMC Networking Operating Systems.This role facilitates the TEXTFSM parsing engine. TextFSM is a template based state machine . It takes the raw string input from the CLI of network devices  dellos10 , run them through a TEXTFSM template and return structured text in the form of a Python dictionary.

It is highly customizable, because it works with separate template definitions, which contains variables and rules with regular expressions. This library is very helpful to parse any text-based CLI output from network devices.


Installation
------------

    ansible-galaxy install Dell-Networking.dellos-template


Connection variables
--------------------

Ansible Dell EMC Networking roles require connection information to establish communication with the nodes in your inventory. This information can exist in the Ansible *group_vars* or *host_vars* directories or inventory, or in the playbook  itself.

| Key         | Required | Choices    | Description                                         |
|-------------|----------|------------|-----------------------------------------------------|
| ``ansible_host`` | yes      |            | Specifies the hostname or address for connecting to the remote device over the specified transport |
| ``ansible_port`` | no       |            | Specifies the port used to build the connection to the remote device; if value is unspecified, the ANSIBLE_REMOTE_PORT option is used; it defaults to 22 |
| ``ansible_ssh_user`` | no       |            | Specifies the username that authenticates the CLI login for the connection to the remote device; if value is unspecified, the ANSIBLE_REMOTE_USER environment variable value is used  |
| ``ansible_ssh_pass`` | no       |            | Specifies the password that authenticates the connection to the remote device. |
| ``ansible_become`` | no       | yes, no\*   | Instructs the module to enter privileged mode on the remote device before sending any commands; if value is unspecified, the ANSIBLE_BECOME environment variable value is used, and the device attempts to execute all commands in non-privileged mode |
| ``ansible_become_method`` | no       | enable, sudo\*   | Instructs the module to allow the become method to be specified for handling privilege escalation; if value is unspecified, the ANSIBLE_BECOME_METHOD environment variable value is used. |
| ``ansible_become_pass`` | no       |            | Specifies the password to use if required to enter privileged mode on the remote device; if ``ansible_become`` is set to no this key is not applicable. |
| ``ansible_network_os`` | yes      | dellos10, null\*  | This value is used to load the correct terminal and cliconf plugins to communicate with the remote device. |

> **NOTE**: Asterisk (\*) denotes the default value if none is specified.

Dependencies
------------

The *dellos-template* role is built on  modules included in the core Ansible code. These modules were added in Ansible version 2.2.0.This role needs textfsm to be installed in the controller,if not it will be installed using ansible pip      module.


Example playbook
----------------

This example uses the *dellos-template* role to parse any text-based CLI output. It creates a *hosts* file with the switch details and corresponding variables. The hosts file should define the *ansible_network_os* variable with corresponding Dell EMC networking OS name.All the supported CLI commands are imported as tasks in tasks/main.yml.
 
**Sample hosts file**

    leaf1 ansible_host= <ip_address> ansible_network_os="dellos10"


**Simple playbook to setup system - leaf.yaml**

    - hosts: leaf1
      roles:
         - Dell-Networking.dellos-template



**Example playbook to run specific show command - leaf.yaml**


    ---
    - name: PARSE SHOW IP INTERFACE BRIEF
      hosts: leaf1
      tasks:
        - import_role:
            name: Dell-Networking.dellos-template
            tasks_from: show_ip_interface_brief.yaml
 


**Run**

    ansible-playbook -i hosts leaf.yaml

(c) 2019 Dell Inc. or its subsidiaries. All Rights Reserved.
