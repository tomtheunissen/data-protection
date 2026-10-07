# SSH public keys

Place one public key per team member in this folder, named `<firstname>.pub` (for example `tom.pub`).
Every `.pub` file is added to the `azureadmin` account on all VMs by `compute.tf`.

- Only add **public** keys (`id_rsa.pub`). Never add a private key.
- Create a key with `ssh-keygen -t rsa -b 4096` (macOS, Linux or Windows PowerShell).
- Default location: `~/.ssh/id_rsa.pub` on macOS/Linux, `C:\Users\<name>\.ssh\id_rsa.pub` on Windows.
- Adding or removing a key changes `admin_ssh_key`, which recreates the VMs. Agree on the keys before the first `terraform apply`.
