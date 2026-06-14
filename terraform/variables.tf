variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "server_name" {
  description = "Name for the server"
  type        = string
  default     = "web-01"
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
  default     = "cx23"
}

variable "server_image" {
  description = "OS image to use"
  type        = string
  default     = "debian-12"
}

variable "location" {
  description = "Hetzner datacenter location (nbg1, fsn1, hel1, ash)"
  type        = string
  default     = "nbg1"
}

variable "ssh_public_key_path" {
  description = "Local path to the SSH public key to upload"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
