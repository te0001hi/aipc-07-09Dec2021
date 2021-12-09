all:
  hosts:
    ${host_name}:
      ansible_host: ${host_ip}
      ansible_user: root
      ansible_connection: ssh
      ansible_ssh_private_key_file: ./mykeyy
      