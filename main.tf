module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 9.1"
    for_each = var.vpcs

    project_id   = var.project_id
    network_name = each.value.vpc_name
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name               = each.value.subnet1_name
            subnet_ip                 = each.value.subnet1_cidr
            subnet_region             = each.value.subnet1_region
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        },
        {
            subnet_name               = each.value.subnet2_name
            subnet_ip                 = each.value.subnet2_cidr
            subnet_region             = each.value.subnet2_region
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]

    routes = [
        {
            name                   = "${each.value.vpc_name}-egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        }
    ]
}

resource "google_service_account" "default" {
  account_id   = "spoke-vm-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "vm1" {
  for_each = var.vpcs
  project      = var.project_id
  name         = "${each.value.vpc_name}-instance1"
  machine_type = "n1-standard-1"
  zone         = "${each.value.subnet1_region}-a"
  boot_disk {
    initialize_params {
      image = var.vm1_image
    }
  }
  network_interface {
    subnetwork = module.vpc[each.key].subnets_self_links[0]
  }
  tags = ["airs-testing"]

    service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
    }
}

resource "google_compute_instance" "vm2" {
  for_each = var.vpcs
  project      = var.project_id
  name         = "${each.value.vpc_name}-instance2"
  machine_type = "n1-standard-1"
  zone         = "${each.value.subnet2_region}-a"
  boot_disk {
    initialize_params {
      image = var.vm2_image
    }
  }
  network_interface {
    subnetwork = module.vpc[each.key].subnets_self_links[1]
  }
  tags = ["airs-testing"]

    service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
    }
}