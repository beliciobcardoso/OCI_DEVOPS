resource "oci_core_virtual_network" "VCN" {
  cidr_block     = lookup(var.network_cidrs, "VCN-CIDR")
  compartment_id = var.compartment_id
  display_name   = "VCN ${var.app_name}"
  dns_label      = "VCN${var.app_name}"
  # default_route_table_id = oci_core_route_table.public_route_table.id
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "SUBNET-PUBLIC-CIDR")
  compartment_id             = var.compartment_id
  display_name               = "public-subnet"
  dns_label                  = "publicsubnet"
  vcn_id                     = oci_core_virtual_network.VCN.id
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.public_route_table.id
  dhcp_options_id            = oci_core_virtual_network.VCN.default_dhcp_options_id
  # security_list_ids          = [oci_core_security_list.oke_endpoint_security_list[0].id]
}

resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "public-route-table"

  route_rules {
    description       = "Traffic to/from internet"
    destination       = lookup(var.network_cidrs, "ALL-CIDR")
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "internet-gateway"
  enabled        = true
  vcn_id         = oci_core_virtual_network.VCN.id
}
