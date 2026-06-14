variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "servers" {
  description = "Map of servers to create"
  type = map(object({
    server_type = string
    location    = string
    image       = string
  }))
  default = {
    web-01 = {
      server_type = "cx23"
      location    = "nbg1"
      image       = "debian-12"
    }
  }
}

variable "ssh_public_key_path" {
  description = "Local path to the SSH public key to upload"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
