all:
  hosts:
    ${host_name}:
      ansible_host: ${host_ip}
      ansible_connection: ssh
      ansible_user: root
      ansible_ssh_private_key_file: ${private_key}
      public_key: ${public_key}