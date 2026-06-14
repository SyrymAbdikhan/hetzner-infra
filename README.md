# hetzner-infra

Infrastructure as Code for a Hetzner Cloud VPS: Terraform creates the server and Ansible configures it.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform) >= 1.65
- [Ansible](https://docs.ansible.com/) >= 2.14
- ***SSH key***: `ssh-keygen -t ed25519`
- ***Hetzner API token***: Cloud Console → Security → API Tokens → Generate

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

Downloads the `hetznercloud/hcloud` provider.

### 3. Create the server

```bash
make apply
```

Creates the server, uploads your SSH public key, and attaches the firewall. Copy the output IP into `ansible/inventory/hosts.ini`:

```bash
cp ansible/inventory/hosts.ini.example ansible/inventory/hosts.ini
# Replace YOUR_SERVER_IP with the IP from terraform output
```

### 4. Configure the server

```bash
make configure
```

Runs the Ansible playbook as root. The playbook:

1. **`deploy_user`** - creates a `deploy` system user, copies your SSH public key, grants passwordless sudo
2. **`docker`** - installs Docker CE and the `docker compose` plugin from the official Docker apt repo
3. **`ssh_config`** - drops `/etc/ssh/sshd_config.d/99-custom.conf` disabling root login and password auth, restarts sshd
4. **`ufw`** - installs UFW, denies all inbound traffic except ports 22/80/443, enables the firewall

### 5. SSH in as the deploy user

```bash
make ssh
```

### Re-running Ansible

After the first `make configure`, root login is disabled. Pass `USER=deploy` for subsequent runs:

```bash
make configure USER=deploy
```

### Delete the server

```bash
make destroy
```

Destroys the server, firewall, and SSH key in Hetzner Cloud.

## Configuration

### Terraform variables (`terraform/terraform.tfvars`)

| Variable | Default | Description |
|----------|---------|-------------|
| `hcloud_token` | - | **Required.** Hetzner Cloud API token |
| `server_name` | `web-01` | Server hostname and resource prefix |
| `server_type` | `cx23` | Instance type (cx23 = 2 vCPU, 4 GB RAM) |
| `server_image` | `debian-12` | OS image |
| `location` | `nbg1` | Datacenter (`nbg1`, `fsn1`, `hel1`, `ash`) |
| `ssh_public_key_path` | `~/.ssh/id_ed25519.pub` | Public key to upload to Hetzner |

### Ansible variables (`ansible/group_vars/all.yml`)

| Variable | Default | Description |
|----------|---------|-------------|
| `deploy_user` | `deploy` | Non-root user created on the server |
| `ssh_public_key_path` | `~/.ssh/deploy.pub` | Public key added to `deploy`'s `authorized_keys` |
| `ufw_allowed_ports` | `[22, 80, 443]` | TCP ports UFW allows inbound |
