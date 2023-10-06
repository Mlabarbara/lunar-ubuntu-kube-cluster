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
  clone = "ubuntu-cloud-0"
  vmid = 2020
  
  agent = 1
  os_type = "cloud-init"
  cores = 4
  memory = 4096
  sockets = 1
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"
  balloon = 0

  disk {
    storage = "local-lvm"
    slot = 0
    size = "10G"
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
resource "proxmox_vm_qemu" "kube_node1" {
  count = 3
  target_node = "pve"
  clone = "ubuntu-cloud-1"
  name = "kube-node-1-${count.index + 1}"
  vmid = "21${count.index + 1}"


  agent = 1
  os_type = "cloud-init"
  cores = 2 
  memory = 4096
  sockets = 1
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"
  balloon = 0

  disk {
    storage = "local-lvm"
    slot = 0
    size = "10G"
    type = "scsi"
    discard = "on"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0 = "ip=192.168.12.11${count.index + 1}/16,gw=192.168.10.1"
  sshkeys = var.sshkeys
}
resource "proxmox_vm_qemu" "kube_node2" {
  count = 3
  target_node = "pve"
  clone = "ubuntu-cloud-2"
  name = "kube-node-2-${count.index + 1}"
  vmid = "22${count.index + 1}"


  agent = 1
  os_type = "cloud-init"
  cores = 2
  memory = 4096
  sockets = 1
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"
  balloon = 0

  disk {
    storage = "local-lvm"
    slot = 0
    size = "10G"
    type = "scsi"
    discard = "on"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0 = "ip=192.168.12.22${count.index + 1}/16,gw=192.168.10.1"
  sshkeys = var.sshkeys
}