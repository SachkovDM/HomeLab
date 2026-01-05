# Control Plane Nodes
resource "proxmox_vm_qemu" "control_plane" {
  count = var.control_plane_count
  
  name        = "control-plane-${count.index}"
  target_node = var.proxmox_node
  clone       = var.vm_template
  
  cores   = var.control_plane_cpu
  memory  = var.control_plane_memory
  scsihw  = "virtio-scsi-pci"
  
  disks {
    scsi {
      scsi {
        disk {
          size = var.control_plane_disk
          format = "raw"
        }
      }
    }
  }
  
  network {
    model  = "virtio"
    bridge = var.network_bridge
  }
  
  # Boot from network first for Talos
  boot = "order=net0;scsi0"
  
  # Enable QEMU agent
  agent = 1
  
  # Disable ballooning
  ballooning = 0
  
  # Set CPU type
  cpu = "host"
  
  # Set OS type
  os_type = "other"
  
  # Tags for identification
  tags = "talos,k8s,control-plane"
  
  lifecycle {
    ignore_changes = [
      network,
      disks
    ]
  }
}

# Worker Nodes
resource "proxmox_vm_qemu" "worker" {
  count = var.worker_count
  
  name        = "worker-${count.index}"
  target_node = var.proxmox_node
  clone       = var.vm_template
  
  cores   = var.worker_cpu
  memory  = var.worker_memory
  scsihw  = "virtio-scsi-pci"
  
  disks {
    scsi {
      scsi {
        disk {
          size = var.worker_disk
          format = "raw"
        }
      }
    }
  }
  
  network {
    model  = "virtio"
    bridge = var.network_bridge
  }
  
  # Boot from network first for Talos
  boot = "order=net0;scsi0"
  
  # Enable QEMU agent
  agent = 1
  
  # Disable ballooning
  ballooning = 0
  
  # Set CPU type
  cpu = "host"
  
  # Set OS type
  os_type = "other"
  
  # Tags for identification
  tags = "talos,k8s,worker"
  
  lifecycle {
    ignore_changes = [
      network,
      disks
    ]
  }
}

# Generate Talos machine configurations
resource "talos_machine_secrets" "this" {}

resource "talos_machine_configuration_apply" "control_plane" {
  count = var.control_plane_count
  
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane[count.index].machine_configuration
  node                        = proxmox_vm_qemu.control_plane[count.index].ssh_host
  endpoint                    = proxmox_vm_qemu.control_plane[count.index].ssh_host
  
  depends_on = [
    proxmox_vm_qemu.control_plane
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  count = var.worker_count
  
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[count.index].machine_configuration
  node                        = proxmox_vm_qemu.worker[count.index].ssh_host
  endpoint                    = proxmox_vm_qemu.worker[count.index].ssh_host
  
  depends_on = [
    proxmox_vm_qemu.worker
  ]
}
