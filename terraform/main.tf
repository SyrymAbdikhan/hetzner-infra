resource "hcloud_ssh_key" "deploy" {
  name       = "deploy-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "hcloud_firewall" "web" {
  name = "shared-fw"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_server" "web" {
  for_each     = var.servers
  name         = each.key
  server_type  = each.value.server_type
  image        = each.value.image
  location     = each.value.location
  ssh_keys     = [hcloud_ssh_key.deploy.id]
  firewall_ids = [hcloud_firewall.web.id]

  labels = {
    managed_by = "terraform"
  }
}

resource "local_file" "ansible_inventory" {
  content  = "[all]\n${join("\n", [for name, server in hcloud_server.web : "${name} ansible_host=${server.ipv4_address}"])}\n"
  filename = "${path.module}/../ansible/inventory/hosts.ini"
}
