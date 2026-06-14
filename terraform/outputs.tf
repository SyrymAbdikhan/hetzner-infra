output "server_ip" {
  description = "Public IPv4 address of the server"
  value       = hcloud_server.web.ipv4_address
}

output "server_name" {
  description = "Name of the server"
  value       = hcloud_server.web.name
}

output "server_id" {
  description = "Hetzner Cloud server ID"
  value       = hcloud_server.web.id
}
