terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "AQ*****6o"
  cloud_id  = "b1***fh"
  folder_id = "b1**lr"
  zone      = "ru-central1-b"
}

resource "yandex_vpc_network" "main-network" {
  name = "main-network"
}

resource "yandex_vpc_subnet" "main-subnet" {
  name           = "main-subnet"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "twit_vm" {
  name = "twit-vm"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd82re2tpfl4chaupeuf"
      size     = 15
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.main-subnet.id
    nat            = true
    ip_address     = "10.129.0.7"
    nat_ip_address = "51.250.103.158"
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "usver:${var.ssh_key}"=
}

# Вывести при создании ресурсов выделенные адреса
output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
