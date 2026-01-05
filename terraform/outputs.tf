output "control_plane_ips" {
  description = "IP addresses of control plane nodes"
  value       = proxmox_vm_qemu.control_plane[*].ssh_host
}

output "worker_ips" {
  description = "IP addresses of worker nodes"
  value       = proxmox_vm_qemu.worker[*].ssh_host
}

output "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  value       = var.cluster_endpoint
}

output "talos_config" {
  description = "Path to generated Talos configuration"
  value       = "talosconfig"
}

output "kubeconfig" {
  description = "Path to generated kubeconfig"
  value       = "kubeconfig"
}

output "bootstrap_command" {
  description = "Command to bootstrap the cluster"
  value       = "talosctl bootstrap --nodes ${join(",", proxmox_vm_qemu.control_plane[*].ssh_host)}"
}
