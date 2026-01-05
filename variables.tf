variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification for Proxmox API"
  type        = bool
  default     = false
}

variable "proxmox_ca_file" {
  description = "Path to Proxmox CA certificate file"
  type        = string
  default     = ""
}

variable "proxmox_cert_file" {
  description = "Path to Proxmox client certificate file"
  type        = string
  default     = ""
}

variable "proxmox_key_file" {
  description = "Path to Proxmox client key file"
  type        = string
  default     = ""
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "vm_template" {
  description = "Proxmox VM template name"
  type        = string
  default     = "talos-template"
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "control_plane_cpu" {
  description = "CPU cores for control plane nodes"
  type        = number
  default     = 2
}

variable "control_plane_memory" {
  description = "Memory in MB for control plane nodes"
  type        = number
  default     = 4096
}

variable "control_plane_disk" {
  description = "Disk size in GB for control plane nodes"
  type        = number
  default     = 20
}

variable "worker_cpu" {
  description = "CPU cores for worker nodes"
  type        = number
  default     = 2
}

variable "worker_memory" {
  description = "Memory in MB for worker nodes"
  type        = number
  default     = 4096
}

variable "worker_disk" {
  description = "Disk size in GB for worker nodes"
  type        = number
  default     = 20
}

variable "network_bridge" {
  description = "Network bridge for VMs"
  type        = string
  default     = "vmbr0"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "talos-k8s"
}

variable "cluster_endpoint" {
  description = "Kubernetes API endpoint IP"
  type        = string
}

variable "talos_version" {
  description = "Talos OS version"
  type        = string
  default     = "v1.8.0"
}
