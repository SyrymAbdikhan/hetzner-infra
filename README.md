# hetzner-infra

Infrastructure as Code for a Hetzner Cloud VPS.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform) >= 1.65
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

### 3. Provision infrastructure

```bash
make apply
```

Creates the server, uploads your SSH public key, and attaches the firewall. Outputs the server IP on completion.

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

## Delete the server

```bash
make destroy
```

Destroys the server, firewall, and SSH key in Hetzner Cloud.
