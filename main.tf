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
            subnet_region             = each.value.subnet1_cidr
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        },
        {
            subnet_name               = each.value.subnet2_name
            subnet_ip                 = each.value.subnet2_cidr
            subnet_region             = each.value.subnet2_cidr
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        }
    ]
}