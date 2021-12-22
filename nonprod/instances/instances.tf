terraform {
  required_providers {
    google = {
      source = "hashicorp/google"

    }
  }
}

# Main VPC

resource "google_compute_network" "vpc" {
  name                    = "terraform-vpc"
  auto_create_subnetworks = false
}

# Public Subnet

resource "google_compute_subnetwork" "public" {
  name          = "public"
  ip_cidr_range = "10.0.0.0/24"
  region  = "us-central1"
  network       = google_compute_network.vpc.id
}

# Private Subnet

resource "google_compute_subnetwork" "private" {
  name          = "private"
  ip_cidr_range = "10.0.1.0/24"
  region  = "us-central1"
  network       = google_compute_network.vpc.id
}

# Cloud Router

resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.vpc.id
  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

# # NAT Gateway
# resource "google_compute_router_nat" "nat" {
#   name                               = "nat"
#   router                             = google_compute_router.router.name
#   region                             = google_compute_router.router.region
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

#   subnetwork {
#     name                    = "private"
#     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
#   }
# }

#---------------------------------------------------------------------------------------
# Instance Creation 
#---------------------------------------------------------------------------------------
/* provider "google" {
  #credentials = file("/Users/chaitu/terraform-335119-ff0422db5f67.json")
  credentials = file("/Users/chaitu/gcp-migration-334418-1496f4dcabbe.json")


  project = "gcp-migration-334418"
  region  = "us-central1"
  zone    = "us-central1-c"
 }*/
variable "environment" {
  type = string
}

resource "google_compute_instance" "vm_instance" {
#name = "dev-instance"
name = "${var.environment}-instance"
machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }

  }
  network_interface {
    network = google_compute_network.vpc.id
    #subnetwork = "default"
    subnetwork = google_compute_subnetwork.private.self_link
    access_config {
    }
  }

}