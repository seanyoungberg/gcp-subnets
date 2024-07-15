project_id = "my_project_id"
vm1_image = "debian-12-bookworm-v20240709"
vm2_image = "debian-12-bookworm-v20240709"

vpcs = {
  vpc1 = {
    vpc_name = "vpc1"
    subnet1_name = "vpc1-subnet1"
    subnet1_cidr = "10.1.1.0/24"
    subnet1_region = "us-west1"
    subnet2_name = "vpc1-subnet2"
    subnet2_cidr = "10.1.2.0/24"
    subnet2_region = "us-west2"
    }
  vpc2 = {
    vpc_name = "vpc2"
    subnet1_name = "vpc2-subnet1"
    subnet1_cidr = "10.2.1.0/24"
    subnet1_region = "us-west1"
    subnet2_name = "vpc2-subnet2"
    subnet2_cidr = "10.2.2.0/24"
    subnet2_region = "us-west2"
    }
}