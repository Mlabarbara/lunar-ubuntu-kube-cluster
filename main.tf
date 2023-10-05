terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "~> 2.9.14"
    }
  }
}
provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "kube_server" {
  target_node = "pve"
  name = "kube-server"
  clone = "ubuntu-ci-template"
  
  agent = 1
  os_type = "cloud-init"
  cores = 4
  memory = 4096
  sockets = 1
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    storage = "local-lvm"
    slot = 0
    size = "5G"
    type = "scsi"
    iothread = 1
    discard = "on"
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0 = "ip=192.168.12.20/16,gw=192.168.10.1"
  sshkeys = var.sshkeys
}
