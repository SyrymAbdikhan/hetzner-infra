# hetzner-infra

Infrastructure as Code for a Hetzner Cloud VPS: Terraform creates the server and Ansible configures it.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform) >= 1.65
- [Ansible](https://docs.ansible.com/) >= 2.14
- [jq](https://jqlang.github.io/jq/) >= 1.7.1
- **SSH key**: `ssh-keygen -t ed25519 -f ~/.ssh/deploy`
- **Hetzner API token**: Cloud Console → Security → API Tokens → Generate

## Quick start

### 1. Copy and fill in credentials

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform/terraform.tfvars and set your hcloud_token
```

### 2. Initialize Terraform

```bash
make init
```

### 3. Create the server

```bash
make apply
```

Provisions the server(s), uploads your SSH public key, attaches the firewall, and writes `ansible/inventory/hosts.ini` automatically.

### 4. Configure the server

```bash
make configure
```

Runs the Ansible playbook as root:

1. **`deploy_user`** - creates a `deploy` system user, copies your SSH public key, grants passwordless sudo
2. **`docker`** - installs Docker CE and the `docker compose` plugin
3. **`ssh_config`** - disables root login and password auth, restarts sshd
4. **`ufw`** - denies all inbound traffic except ports 22/80/443

### 5. SSH in

```bash
make ssh                  # connects to the first server
make ssh SERVER=web-02    # connects to a specific server
```

### Re-running Ansible

After the first `make configure`, root login is disabled. Pass `SSH_USER=deploy` for subsequent runs:

```bash
make configure SSH_USER=deploy
```

### Delete the server

```bash
make destroy
```

Destroys all servers, shared firewall and SSH key in Hetzner Cloud.

## Configuration

### Terraform (`terraform/terraform.tfvars`)

| Variable | Default | Description |
|----------|---------|-------------|
| `hcloud_token` | - | **Required.** Hetzner Cloud API token |
| `ssh_public_key_path` | `~/.ssh/deploy.pub` | Public key to upload to Hetzner |
| `servers` | *see below* | Map of servers to create - name, type, location, image |

`servers` example entries:

```hcl
servers = {
  web-01 = { server_type = "cx23", location = "nbg1", image = "debian-12" }
  web-02 = { server_type = "cx23", location = "fsn1", image = "debian-12" }
}
```

### Ansible (`ansible/group_vars/all.yml`)

| Variable | Default | Description |
|----------|---------|-------------|
| `deploy_user` | `deploy` | Non-root user created on the server |
| `ssh_public_key_path` | `~/.ssh/deploy.pub` | Public key added to `deploy`'s `authorized_keys` |
| `ufw_allowed_ports` | `[22, 80, 443]` | TCP ports UFW allows inbound |
