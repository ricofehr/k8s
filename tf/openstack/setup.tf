# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "${var.provider_user}"
  tenant_name = "${var.provider_tenant}"
  password    = "${var.provider_password}"
  auth_url    = "${var.provider_auth_url}"
  region      = "${var.provider_region}"
  user_domain_name = "Default"
  project_domain_name = "Default"
  endpoint_type = "internalURL"
  insecure = true
}

resource "openstack_compute_keypair_v2" "k8s-keypair" {
  name = "k8s-keypair"
  public_key = "${var.keypair_sshkey}"
}

resource "openstack_networking_floatingip_v2" "floatip_master1" {
  pool = "${var.public_network_name}"
}

resource "openstack_compute_instance_v2" "k8s_master1" {
  name            = "k8s-master1"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor_master}"
  key_pair        = "k8s-keypair"
  security_groups = ["${var.security_group}"]

  network {
    name = "${var.private_network_name}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "floatip_master1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_master1.address}"
  instance_id = "${openstack_compute_instance_v2.k8s_master1.id}"
}

resource "openstack_networking_floatingip_v2" "floatip_node1" {
  pool = "${var.public_network_name}"
}

resource "openstack_compute_instance_v2" "k8s_node1" {
  name            = "k8s-node1"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor_node}"
  key_pair        = "k8s-keypair"
  security_groups = ["${var.security_group}"]

  network {
    name = "${var.private_network_name}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "floatip_node1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_node1.address}"
  instance_id = "${openstack_compute_instance_v2.k8s_node1.id}"
}

resource "openstack_networking_floatingip_v2" "floatip_node2" {
  pool = "${var.public_network_name}"
}

resource "openstack_compute_instance_v2" "k8s_node2" {
  name            = "k8s-node2"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor_node}"
  key_pair        = "k8s-keypair"
  security_groups = ["${var.security_group}"]

  network {
    name = "${var.private_network_name}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "floatip_node2" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_node2.address}"
  instance_id = "${openstack_compute_instance_v2.k8s_node2.id}"
}

output "k8s-master1-ip" {
  value = "${openstack_networking_floatingip_v2.floatip_master1.address}"
}

output "k8s-master1-private-ip" {
  value = "${openstack_compute_instance_v2.k8s_master1.network.0.fixed_ip_v4}"
}

output "k8s-node1-ip" {
  value = "${openstack_networking_floatingip_v2.floatip_node1.address}"
}

output "k8s-node1-private-ip" {
  value = "${openstack_compute_instance_v2.k8s_node1.network.0.fixed_ip_v4}"
}

output "k8s-node2-ip" {
  value = "${openstack_networking_floatingip_v2.floatip_node2.address}"
}

output "k8s-node2-private-ip" {
  value = "${openstack_compute_instance_v2.k8s_node2.network.0.fixed_ip_v4}"
}