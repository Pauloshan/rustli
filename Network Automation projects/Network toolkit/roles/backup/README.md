# network.toolkit.backup

To use this multi-platform network automation backup role:

```
- name: retrieve router configurations
  hosts: all
  gather_facts: no

  tasks:
    - name: backup configuration
      include_role:
        name: network.toolkit.backup
      when: ansible_network_os is defined
```

