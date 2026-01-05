terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 3.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.6"
    }
  }
  required_version = ">= 1.0"
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure
  pm_ca_file          = var.proxmox_ca_file != "" ? var.proxmox_ca_file : null
  pm_cert_file        = var.proxmox_cert_file != "" ? var.proxmox_cert_file : null
  pm_key_file         = var.proxmox_key_file != "" ? var.proxmox_key_file : null
}

provider "talos" {
  # Configuration will be set dynamically for each node
}
