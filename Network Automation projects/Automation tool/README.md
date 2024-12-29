# Ansible Network Automation - 
  This is just a test work project, exploring the use of Ansible for tools agnostic network automation modules fot configuration management [network_cli connection plugin](https://docs.ansible.com/ansible/latest/plugins/connection/network_cli.html).

## Playbooks

 - [show_interfaces.yml](show_interfaces.yml) - this playbook issues `show ip interface brief` on Cisco IOS and Arista EOS, and `show interface terse` on Juniper Junos.  Then displays the output to the terminal window.
 - [backup.yml](backup.yml) - performs a backup of the running configuration on Arista EOS, Cisco IOS and Juniper Junos.

-: automate networking devices from Arista (EOS), Cisco (IOS, IOS XR, NX-OS), Juniper (JunOS), Open vSwitch, and VyOS and many more! Includes [Ansible Tower] curated content specifically for network use cases.
