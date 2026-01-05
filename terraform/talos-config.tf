data "talos_machine_configuration" "control_plane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_endpoint}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/sda"
          image = "ghcr.io/siderolabs/talos:${var.talos_version}"
        }
        network = {
          hostname = "control-plane-${count.index}"
          interfaces = [
            {
              interface = "eth0"
              method = "dhcp"
            }
          ]
        }
      }
      cluster = {
        externalCloudProvider = {
          enabled = true
        }
        network = {
          dnsDomain = "cluster.local"
          podSubnets = ["10.244.0.0/16"]
          serviceSubnets = ["10.96.0.0/12"]
        }
      }
    })
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_endpoint}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk = "/dev/sda"
          image = "ghcr.io/siderolabs/talos:${var.talos_version}"
        }
        network = {
          hostname = "worker-${count.index}"
          interfaces = [
            {
              interface = "eth0"
              method = "dhcp"
            }
          ]
        }
      }
    })
  ]
}
