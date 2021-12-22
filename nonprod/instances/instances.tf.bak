terraform {
  required_providers {
    google = {
      source = "hashicorp/google"

    }
  }
}

#---------------------------------------------------------------------------------------
# Create a VPC
#---------------------------------------------------------------------------------------
module "vpc" {
  #source = "github.com/terraform-google-modules/terraform-google-network"
  source = "/Users/chaitu/Desktop/vpc-network-module/terraform-google-network"
  #source       = "/Users/chaitu/Desktop/Locally-GCP/non-prod/network"
  project_id   = "gcp-migration-334418"
  network_name = "dev-vpc"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-central1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
      subnet_flow_logs      = true
    },
  ]

  secondary_ranges = {
    subnet-01 = [
      {
        range_name    = "subnet-01-secondary-01"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]

    subnet-02 = []
  }
}


#---------------------------------------------------------------------------------------
# Instance Creation 
#---------------------------------------------------------------------------------------
 /*provider "google" {
  #credentials = file("/Users/chaitu/terraform-335119-ff0422db5f67.json")
  credentials = file("/Users/chaitu/gcp-migration-334418-1496f4dcabbe.json")


  project = "gcp-migration-334418"
  region  = "us-central1"
  zone    = "us-central1-c"
 }*/
variable "environment" {
  type = string
}
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
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
    network = module.vpc.network_name
    #subnetwork = "default"
    subnetwork = module.vpc.subnets_names[1]
    access_config {
    }
  }

}


